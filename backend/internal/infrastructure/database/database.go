package database

import (
	"context"
	"fmt"
	"time"

	"go.uber.org/zap"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
)

// DB wraps the GORM database connection with additional functionality
type DB struct {
	*gorm.DB
	logger *zap.Logger
}

// Connect establishes a connection to the PostgreSQL database
func Connect(cfg *config.Config, zapLogger *zap.Logger) (*DB, error) {
	if cfg.Database.URL == "" {
		zapLogger.Warn("Database URL not configured, skipping database connection")
		return nil, nil
	}

	// Configure GORM logger based on environment
	gormLogger := logger.Default.LogMode(logger.Info)
	if cfg.Server.Mode == "release" {
		gormLogger = logger.Default.LogMode(logger.Warn)
	}

	// Open database connection
	//
	// NOTE: PreferSimpleProtocol avoids prepared statement caching conflicts that can
	// happen with poolers (e.g. Supabase PgBouncer) during tests/integration runs.
	dialector := postgres.Open(cfg.Database.URL)
	if cfg.Server.Mode == "test" {
		dialector = postgres.New(postgres.Config{DSN: cfg.Database.URL, PreferSimpleProtocol: true})
	}

	db, err := gorm.Open(dialector, &gorm.Config{
		Logger:                 gormLogger,
		SkipDefaultTransaction: true, // Better performance for reads
	})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	// Get underlying SQL DB to configure connection pool
	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("failed to get underlying DB: %w", err)
	}

	// Configure connection pool for production workloads
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)
	sqlDB.SetConnMaxIdleTime(10 * time.Minute)

	// Verify connection with ping
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := sqlDB.PingContext(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	zapLogger.Info("Database connected successfully",
		zap.String("host", "supabase"),
	)

	return &DB{
		DB:     db,
		logger: zapLogger,
	}, nil
}

// HealthCheck verifies database connectivity
func (d *DB) HealthCheck(ctx context.Context) error {
	if d == nil || d.DB == nil {
		return fmt.Errorf("database not initialized")
	}

	sqlDB, err := d.DB.DB()
	if err != nil {
		return fmt.Errorf("failed to get underlying DB: %w", err)
	}

	if err := sqlDB.PingContext(ctx); err != nil {
		return fmt.Errorf("database ping failed: %w", err)
	}

	return nil
}

// Close closes the database connection
func (d *DB) Close() error {
	if d == nil || d.DB == nil {
		return nil
	}

	sqlDB, err := d.DB.DB()
	if err != nil {
		return err
	}

	d.logger.Info("Closing database connection")
	return sqlDB.Close()
}

// HealthStatus represents the database health status
type HealthStatus struct {
	Latency     string `json:"latency,omitempty"`
	Error       string `json:"error,omitempty"`
	MaxOpenConn int    `json:"max_open_connections"`
	OpenConn    int    `json:"open_connections"`
	InUse       int    `json:"in_use"`
	Idle        int    `json:"idle"`
	Connected   bool   `json:"connected"`
}

// GetHealthStatus returns detailed health status of the database
func (d *DB) GetHealthStatus(ctx context.Context) HealthStatus {
	status := HealthStatus{
		Connected: false,
	}

	if d == nil || d.DB == nil {
		status.Error = "database not initialized"
		return status
	}

	sqlDB, err := d.DB.DB()
	if err != nil {
		status.Error = err.Error()
		return status
	}

	// Measure ping latency
	start := time.Now()
	if err := sqlDB.PingContext(ctx); err != nil {
		status.Error = err.Error()
		return status
	}
	latency := time.Since(start)

	// Get connection pool stats
	stats := sqlDB.Stats()

	status.Connected = true
	status.Latency = latency.String()
	status.MaxOpenConn = stats.MaxOpenConnections
	status.OpenConn = stats.OpenConnections
	status.InUse = stats.InUse
	status.Idle = stats.Idle

	return status
}

package database

import (
	"go.uber.org/zap"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
)

// Connect establishes a connection to the PostgreSQL database
func Connect(cfg *config.Config, zapLogger *zap.Logger) (*gorm.DB, error) {
	if cfg.Database.URL == "" {
		zapLogger.Warn("Database URL not configured, skipping database connection")
		return nil, nil
	}

	// Configure GORM logger
	gormLogger := logger.Default.LogMode(logger.Info)
	if cfg.Server.Mode == "release" {
		gormLogger = logger.Default.LogMode(logger.Warn)
	}

	db, err := gorm.Open(postgres.Open(cfg.Database.URL), &gorm.Config{
		Logger: gormLogger,
	})
	if err != nil {
		return nil, err
	}

	// Get underlying SQL DB to configure connection pool
	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	// Configure connection pool
	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)

	zapLogger.Info("Database connected successfully")
	return db, nil
}

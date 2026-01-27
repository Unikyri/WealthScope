package main

import (
	"log"

	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/server"
)

func main() {
	// Load configuration
	cfg := config.Load()

	// Initialize logger
	var logger *zap.Logger
	var err error

	if cfg.Server.Mode == "release" {
		logger, err = zap.NewProduction()
	} else {
		logger, err = zap.NewDevelopment()
	}
	if err != nil {
		log.Fatalf("Failed to initialize logger: %v", err)
	}
	defer func() {
		_ = logger.Sync()
	}()

	logger.Info("Starting WealthScope API",
		zap.String("mode", cfg.Server.Mode),
	)

	// Connect to database (optional for initial setup)
	db, err := database.Connect(cfg, logger)
	if err != nil {
		logger.Warn("Database connection failed, continuing without database",
			zap.Error(err),
		)
	}

	// Ensure database is closed on shutdown
	if db != nil {
		defer func() {
			if err := db.Close(); err != nil {
				logger.Error("Failed to close database connection", zap.Error(err))
			}
		}()
	}

	// Start server with database connection
	srv := server.New(cfg, logger, db)
	srv.Run()
}

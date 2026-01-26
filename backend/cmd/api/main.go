package main

import (
	"log"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/server"
	"go.uber.org/zap"
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
	defer logger.Sync()

	logger.Info("Starting WealthScope API",
		zap.String("mode", cfg.Server.Mode),
	)

	// Connect to database (optional for initial setup)
	_, err = database.Connect(cfg, logger)
	if err != nil {
		logger.Warn("Database connection failed, continuing without database",
			zap.Error(err),
		)
	}

	// Start server
	srv := server.New(cfg, logger)
	srv.Run()
}

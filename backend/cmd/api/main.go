package main

import (
	"log"

	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/server"

	_ "github.com/Unikyri/WealthScope/backend/docs" // Swagger docs
)

// @title WealthScope API
// @version 1.0.0
// @description API para gestión de portafolio de inversiones personales
// @description
// @description ## Autenticación
// @description Esta API utiliza JWT de Supabase Auth. Incluye el token en el header:
// @description `Authorization: Bearer <tu-token-jwt>`
// @description
// @description ## Tipos de Activos Soportados
// @description - `stock` - Acciones
// @description - `etf` - Fondos cotizados
// @description - `bond` - Bonos
// @description - `crypto` - Criptomonedas
// @description - `real_estate` - Bienes raíces
// @description - `gold` - Oro
// @description - `cash` - Efectivo
// @description - `other` - Otros

// @contact.name WealthScope Team
// @contact.url https://github.com/Unikyri/WealthScope
// @contact.email support@wealthscope.app

// @license.name MIT
// @license.url https://opensource.org/licenses/MIT

// @host localhost:8080
// @BasePath /
// @schemes http https

// @securityDefinitions.apikey BearerAuth
// @in header
// @name Authorization
// @description Ingresa tu JWT token con el prefijo "Bearer ". Ejemplo: "Bearer eyJhbGci..."

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

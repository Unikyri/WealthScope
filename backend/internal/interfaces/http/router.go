package http

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/handlers"
)

// NewRouter creates and configures a new Gin router
func NewRouter(mode string, db *database.DB) *gin.Engine {
	// Set Gin mode
	gin.SetMode(mode)

	router := gin.New()

	// Global middleware
	router.Use(gin.Recovery())
	router.Use(requestIDMiddleware())
	router.Use(gin.Logger())

	// Initialize handlers with dependencies
	healthHandler := handlers.NewHealthHandler(db)

	// Health check (public)
	router.GET("/health", healthHandler.Health)

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		v1.GET("/ping", healthHandler.Ping)
	}

	return router
}

// requestIDMiddleware adds a unique request ID to each request
func requestIDMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		requestID := c.GetHeader("X-Request-ID")
		if requestID == "" {
			requestID = uuid.New().String()
		}
		c.Set("request_id", requestID)
		c.Header("X-Request-ID", requestID)
		c.Next()
	}
}

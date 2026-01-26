package handlers

import (
	"time"

	"github.com/Unikyri/WealthScope/backend/pkg/response"
	"github.com/gin-gonic/gin"
)

// HealthHandler handles health check endpoints
type HealthHandler struct{}

// NewHealthHandler creates a new health handler
func NewHealthHandler() *HealthHandler {
	return &HealthHandler{}
}

// HealthResponse represents the health check response
type HealthResponse struct {
	Status    string `json:"status"`
	Timestamp string `json:"timestamp"`
	Version   string `json:"version"`
}

// Health handles GET /health
func (h *HealthHandler) Health(c *gin.Context) {
	response.Success(c, HealthResponse{
		Status:    "healthy",
		Timestamp: time.Now().UTC().Format(time.RFC3339),
		Version:   "0.1.0",
	})
}

// PingResponse represents the ping response
type PingResponse struct {
	Message string `json:"message"`
}

// Ping handles GET /api/v1/ping
func (h *HealthHandler) Ping(c *gin.Context) {
	response.Success(c, PingResponse{
		Message: "pong",
	})
}

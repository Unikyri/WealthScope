package handlers

import (
	"time"

	"github.com/gin-gonic/gin"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// HealthHandler handles health check endpoints
type HealthHandler struct {
	db *database.DB
}

// NewHealthHandler creates a new health handler
func NewHealthHandler(db *database.DB) *HealthHandler {
	return &HealthHandler{
		db: db,
	}
}

// HealthResponse represents the health check response
type HealthResponse struct {
	Database  *database.HealthStatus `json:"database,omitempty"`
	Status    string                 `json:"status"`
	Timestamp string                 `json:"timestamp"`
	Version   string                 `json:"version"`
}

// Health handles GET /health
// @Summary Health check
// @Description Retorna el estado de salud del servicio y la conexión a la base de datos
// @Tags health
// @Produce json
// @Success 200 {object} response.Response{data=HealthResponse}
// @Router /health [get]
func (h *HealthHandler) Health(c *gin.Context) {
	status := "healthy"
	var dbStatus *database.HealthStatus

	// Check database health if available
	if h.db != nil {
		dbHealth := h.db.GetHealthStatus(c.Request.Context())
		dbStatus = &dbHealth
		if !dbHealth.Connected {
			status = "degraded"
		}
	}

	response.Success(c, HealthResponse{
		Status:    status,
		Timestamp: time.Now().UTC().Format(time.RFC3339),
		Version:   "0.1.0",
		Database:  dbStatus,
	})
}

// PingResponse represents the ping response
type PingResponse struct {
	Message string `json:"message"`
}

// Ping handles GET /api/v1/ping
// @Summary Ping
// @Description Endpoint simple para verificar conectividad
// @Tags health
// @Produce json
// @Success 200 {object} response.Response{data=PingResponse}
// @Router /api/v1/ping [get]
func (h *HealthHandler) Ping(c *gin.Context) {
	response.Success(c, PingResponse{
		Message: "pong",
	})
}

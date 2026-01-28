package handlers

import (
	"github.com/gin-gonic/gin"

	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// PortfolioHandler handles portfolio-related HTTP requests
type PortfolioHandler struct {
	getPortfolioSummaryUC *usecases.GetPortfolioSummaryUseCase
	getPortfolioRiskUC    *usecases.GetPortfolioRiskUseCase
}

// NewPortfolioHandler creates a new PortfolioHandler
func NewPortfolioHandler(
	getPortfolioSummaryUC *usecases.GetPortfolioSummaryUseCase,
	getPortfolioRiskUC *usecases.GetPortfolioRiskUseCase,
) *PortfolioHandler {
	return &PortfolioHandler{
		getPortfolioSummaryUC: getPortfolioSummaryUC,
		getPortfolioRiskUC:    getPortfolioRiskUC,
	}
}

// ====================================
// Response DTOs
// ====================================

// AssetTypeBreakdownResponse represents a single asset type in the breakdown
type AssetTypeBreakdownResponse struct {
	Type    string  `json:"type"`
	Value   float64 `json:"value"`
	Percent float64 `json:"percent"`
	Count   int     `json:"count"`
}

// PortfolioSummaryResponse represents the portfolio summary response
type PortfolioSummaryResponse struct {
	LastUpdated     string                       `json:"last_updated"`
	BreakdownByType []AssetTypeBreakdownResponse `json:"breakdown_by_type"`
	TotalValue      float64                      `json:"total_value"`
	TotalInvested   float64                      `json:"total_invested"`
	GainLoss        float64                      `json:"gain_loss"`
	GainLossPercent float64                      `json:"gain_loss_percent"`
	AssetCount      int                          `json:"asset_count"`
}

// ====================================
// Handlers
// ====================================

// GetSummary handles GET /api/v1/portfolio/summary
// @Summary Get portfolio summary
// @Description Returns complete portfolio summary with asset type breakdown
// @Tags portfolio
// @Produce json
// @Success 200 {object} response.Response{data=PortfolioSummaryResponse}
// @Failure 401 {object} response.Response{error=string}
// @Failure 500 {object} response.Response{error=string}
// @Security BearerAuth
// @Router /api/v1/portfolio/summary [get]
func (h *PortfolioHandler) GetSummary(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	summary, err := h.getPortfolioSummaryUC.Execute(c.Request.Context(), userID)
	if err != nil {
		response.InternalError(c, "Failed to get portfolio summary")
		return
	}

	response.Success(c, toPortfolioSummaryResponse(summary))
}

// GetRisk handles GET /api/v1/portfolio/risk
// @Summary Get portfolio risk alerts
// @Description Returns basic concentration risk alerts for the authenticated user's portfolio
// @Tags portfolio
// @Produce json
// @Success 200 {object} response.Response{data=services.PortfolioRisk}
// @Failure 401 {object} response.Response{error=string}
// @Failure 500 {object} response.Response{error=string}
// @Security BearerAuth
// @Router /api/v1/portfolio/risk [get]
func (h *PortfolioHandler) GetRisk(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	risk, err := h.getPortfolioRiskUC.Execute(c.Request.Context(), userID)
	if err != nil {
		response.InternalError(c, "Failed to analyze portfolio risk")
		return
	}

	response.Success(c, risk)
}

// ====================================
// Helpers
// ====================================

// toPortfolioSummaryResponse converts domain PortfolioSummary to response DTO
func toPortfolioSummaryResponse(summary *repositories.PortfolioSummary) PortfolioSummaryResponse {
	breakdown := make([]AssetTypeBreakdownResponse, len(summary.BreakdownByType))
	for i, b := range summary.BreakdownByType {
		breakdown[i] = AssetTypeBreakdownResponse{
			Type:    string(b.Type),
			Value:   b.Value,
			Percent: b.Percent,
			Count:   b.Count,
		}
	}

	return PortfolioSummaryResponse{
		TotalValue:      summary.TotalValue,
		TotalInvested:   summary.TotalInvested,
		GainLoss:        summary.GainLoss,
		GainLossPercent: summary.GainLossPercent,
		AssetCount:      summary.AssetCount,
		LastUpdated:     summary.LastUpdated.Format("2006-01-02T15:04:05Z"),
		BreakdownByType: breakdown,
	}
}

package handlers

import (
	"context"
	"encoding/json"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// ScenarioHandler handles scenario simulation HTTP requests.
type ScenarioHandler struct {
	scenarioEngine     *services.ScenarioEngine
	historicalAnalyzer *services.HistoricalAnalyzer
}

// NewScenarioHandler creates a new ScenarioHandler.
func NewScenarioHandler(
	scenarioEngine *services.ScenarioEngine,
	historicalAnalyzer *services.HistoricalAnalyzer,
) *ScenarioHandler {
	return &ScenarioHandler{
		scenarioEngine:     scenarioEngine,
		historicalAnalyzer: historicalAnalyzer,
	}
}

// SimulateRequest represents the request body for simulation endpoint.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type SimulateRequest struct {
	Type       string          `json:"type" binding:"required"`
	Parameters json.RawMessage `json:"parameters"`
}

// SimulateResponse represents the response from the simulate endpoint.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type SimulateResponse struct {
	AIAnalysis     string                  `json:"ai_analysis,omitempty"`
	Changes        []entities.ChangeDetail `json:"changes"`
	Warnings       []string                `json:"warnings,omitempty"`
	CurrentState   entities.PortfolioState `json:"current_state"`
	ProjectedState entities.PortfolioState `json:"projected_state"`
}

// TemplatesResponse represents the response from the templates endpoint.
type TemplatesResponse struct {
	Templates []entities.ScenarioTemplate `json:"templates"`
}

// HistoricalStatsRequest represents the request for historical stats.
type HistoricalStatsRequest struct {
	Symbol string `json:"symbol" binding:"required"`
	Period string `json:"period"` // 1M, 3M, 6M, 1Y (default: 1Y)
}

// Simulate handles POST /api/v1/ai/simulate
// @Summary Run a what-if scenario simulation
// @Description Simulates investment scenarios like buying/selling assets, market movements, or portfolio rebalancing
// @Tags Scenarios
// @Accept json
// @Produce json
// @Param request body SimulateRequest true "Simulation parameters"
// @Success 200 {object} response.Response{data=SimulateResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/ai/simulate [post]
func (h *ScenarioHandler) Simulate(c *gin.Context) {
	// Get user ID from context
	userIDValue, ok := c.Get(middleware.UserIDKey)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}
	userIDStr, ok := userIDValue.(string)
	if !ok {
		response.BadRequest(c, "Invalid user ID format")
		return
	}
	uid, parseErr := uuid.Parse(userIDStr)
	if parseErr != nil {
		response.BadRequest(c, "Invalid user ID")
		return
	}

	// Parse request
	var req SimulateRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "Invalid request: "+bindErr.Error())
		return
	}

	// Parse scenario parameters
	var params entities.ScenarioParams
	if len(req.Parameters) > 0 {
		if unmarshalErr := json.Unmarshal(req.Parameters, &params); unmarshalErr != nil {
			response.BadRequest(c, "Invalid parameters: "+unmarshalErr.Error())
			return
		}
	}

	// Build scenario request
	scenarioReq := entities.ScenarioRequest{
		UserID:     uid,
		Type:       entities.ScenarioType(req.Type),
		Parameters: params,
	}

	// Validate scenario type
	if !scenarioReq.Type.IsValid() {
		response.BadRequest(c, "Invalid scenario type: "+req.Type)
		return
	}

	// Run simulation with extended timeout (AI analysis may take time)
	ctx, cancel := context.WithTimeout(c.Request.Context(), 90*time.Second)
	defer cancel()
	result, err := h.scenarioEngine.Simulate(ctx, scenarioReq)
	if err != nil {
		response.InternalError(c, "Simulation failed: "+err.Error())
		return
	}

	// Build response
	resp := SimulateResponse{
		CurrentState:   result.CurrentState,
		ProjectedState: result.ProjectedState,
		Changes:        result.Changes,
		AIAnalysis:     result.AIAnalysis,
		Warnings:       result.Warnings,
	}

	response.Success(c, resp)
}

// SimulateChain handles POST /api/v1/ai/simulate/chain
// @Summary Run a multi-step what-if scenario simulation
// @Description Simulates a chain of sequential investment scenarios
// @Tags Scenarios
// @Accept json
// @Produce json
// @Param request body entities.ScenarioChainRequest true "Chain parameters"
// @Success 200 {object} response.Response{data=entities.ChainResult}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/ai/simulate/chain [post]
func (h *ScenarioHandler) SimulateChain(c *gin.Context) {
	// Get user ID from context
	userIDValue, ok := c.Get(middleware.UserIDKey)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}
	userIDStr, ok := userIDValue.(string)
	if !ok {
		response.BadRequest(c, "Invalid user ID format")
		return
	}
	uid, parseErr := uuid.Parse(userIDStr)
	if parseErr != nil {
		response.BadRequest(c, "Invalid user ID")
		return
	}

	// Parse request
	var req entities.ScenarioChainRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "Invalid request: "+bindErr.Error())
		return
	}

	// Set user ID
	req.UserID = uid

	// Validate steps
	if len(req.Steps) == 0 {
		response.BadRequest(c, "At least one step is required")
		return
	}
	for i, step := range req.Steps {
		if !step.Type.IsValid() {
			response.BadRequest(c, "Invalid scenario type in step "+string(rune(i+1))+": "+string(step.Type))
			return
		}
	}

	// Run simulation chain with extended timeout
	ctx, cancel := context.WithTimeout(c.Request.Context(), 90*time.Second)
	defer cancel()
	result, err := h.scenarioEngine.SimulateChain(ctx, req)
	if err != nil {
		response.InternalError(c, "Simulation chain failed: "+err.Error())
		return
	}

	response.Success(c, result)
}

// GetTemplates handles GET /api/v1/ai/scenarios/templates
// @Summary Get predefined scenario templates
// @Description Returns a list of predefined scenario templates that users can run
// @Tags Scenarios
// @Produce json
// @Success 200 {object} response.Response{data=TemplatesResponse}
// @Failure 401 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/ai/scenarios/templates [get]
func (h *ScenarioHandler) GetTemplates(c *gin.Context) {
	templates := h.scenarioEngine.GetTemplates()

	resp := TemplatesResponse{
		Templates: templates,
	}

	response.Success(c, resp)
}

// GetHistoricalStats handles GET /api/v1/ai/scenarios/historical
// @Summary Get historical statistics for a symbol
// @Description Returns historical volatility, drawdown, and other statistics for a symbol
// @Tags Scenarios
// @Produce json
// @Param symbol query string true "Asset symbol (e.g., AAPL)"
// @Param period query string false "Analysis period (1M, 3M, 6M, 1Y)" default(1Y)
// @Success 200 {object} response.Response{data=services.HistoricalStats}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/ai/scenarios/historical [get]
func (h *ScenarioHandler) GetHistoricalStats(c *gin.Context) {
	symbol := c.Query("symbol")
	if symbol == "" {
		response.BadRequest(c, "symbol is required")
		return
	}

	period := c.DefaultQuery("period", "1Y")

	stats, err := h.historicalAnalyzer.GetHistoricalStats(c.Request.Context(), symbol, period)
	if err != nil {
		response.InternalError(c, "Failed to get historical stats: "+err.Error())
		return
	}

	response.Success(c, stats)
}

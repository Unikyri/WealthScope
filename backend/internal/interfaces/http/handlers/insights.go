package handlers

import (
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// InsightsHandler handles insight-related HTTP requests.
type InsightsHandler struct {
	insightService *services.InsightService
}

// NewInsightsHandler creates a new InsightsHandler.
func NewInsightsHandler(insightService *services.InsightService) *InsightsHandler {
	return &InsightsHandler{
		insightService: insightService,
	}
}

// InsightResponse represents an insight in API responses.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type InsightResponse struct {
	ID             uuid.UUID `json:"id"`
	Type           string    `json:"type"`
	Title          string    `json:"title"`
	Content        string    `json:"content"`
	Priority       string    `json:"priority"`
	Category       string    `json:"category"`
	ActionItems    []string  `json:"action_items,omitempty"`
	RelatedSymbols []string  `json:"related_symbols,omitempty"`
	IsRead         bool      `json:"is_read"`
	CreatedAt      time.Time `json:"created_at"`
}

// InsightListResponse represents a list of insights.
type InsightListResponse struct {
	Insights    []InsightResponse `json:"insights"`
	UnreadCount int               `json:"unread_count"`
	Total       int               `json:"total"`
	Limit       int               `json:"limit"`
	Offset      int               `json:"offset"`
}

// UnreadCountResponse represents the unread count response.
type UnreadCountResponse struct {
	Count int `json:"count"`
}

// toInsightResponse converts an entity to response DTO.
func toInsightResponse(insight entities.Insight) InsightResponse {
	return InsightResponse{
		ID:             insight.ID,
		Type:           string(insight.Type),
		Title:          insight.Title,
		Content:        insight.Content,
		Priority:       string(insight.Priority),
		Category:       string(insight.Category),
		ActionItems:    insight.ActionItems,
		RelatedSymbols: insight.RelatedSymbols,
		IsRead:         insight.IsRead(),
		CreatedAt:      insight.CreatedAt,
	}
}

// GetInsights handles GET /api/v1/ai/insights
// @Summary List user insights
// @Description Lists all insights for the authenticated user with optional filters
// @Tags AI Insights
// @Produce json
// @Param type query string false "Filter by type (daily_briefing, alert, recommendation)"
// @Param category query string false "Filter by category (risk, performance, opportunity, general)"
// @Param priority query string false "Filter by priority (high, medium, low)"
// @Param unread query bool false "Show only unread insights"
// @Param limit query int false "Limit (default 20, max 100)"
// @Param offset query int false "Offset (default 0)"
// @Success 200 {object} response.Response{data=InsightListResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights [get]
func (h *InsightsHandler) GetInsights(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	// Parse filters
	filter := entities.DefaultInsightFilter()

	if typeParam := c.Query("type"); typeParam != "" {
		insightType := entities.InsightType(typeParam)
		filter.Type = &insightType
	}

	if categoryParam := c.Query("category"); categoryParam != "" {
		category := entities.InsightCategory(categoryParam)
		filter.Category = &category
	}

	if priorityParam := c.Query("priority"); priorityParam != "" {
		priority := entities.InsightPriority(priorityParam)
		filter.Priority = &priority
	}

	if unreadParam := c.Query("unread"); unreadParam == "true" {
		filter.UnreadOnly = true
	}

	if limitParam := c.Query("limit"); limitParam != "" {
		if limit, err := strconv.Atoi(limitParam); err == nil && limit > 0 {
			if limit > 100 {
				limit = 100
			}
			filter.Limit = limit
		}
	}

	if offsetParam := c.Query("offset"); offsetParam != "" {
		if offset, err := strconv.Atoi(offsetParam); err == nil && offset >= 0 {
			filter.Offset = offset
		}
	}

	insights, total, err := h.insightService.GetUserInsights(c.Request.Context(), userID, filter)
	if err != nil {
		response.InternalError(c, "Failed to retrieve insights: "+err.Error())
		return
	}

	unreadCount, _ := h.insightService.GetUnreadCount(c.Request.Context(), userID)

	insightResponses := make([]InsightResponse, len(insights))
	for i, insight := range insights {
		insightResponses[i] = toInsightResponse(insight)
	}

	response.Success(c, InsightListResponse{
		Insights:    insightResponses,
		UnreadCount: unreadCount,
		Total:       total,
		Limit:       filter.Limit,
		Offset:      filter.Offset,
	})
}

// GetDailyBriefing handles GET /api/v1/ai/insights/daily
// @Summary Get today's daily briefing
// @Description Gets or generates today's daily briefing for the user
// @Tags AI Insights
// @Produce json
// @Success 200 {object} response.Response{data=InsightResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights/daily [get]
func (h *InsightsHandler) GetDailyBriefing(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	briefing, err := h.insightService.GenerateDailyBriefing(c.Request.Context(), userID)
	if err != nil {
		if strings.Contains(err.Error(), "failed to generate") {
			response.InternalError(c, "Failed to generate daily briefing. Please try again later.")
			return
		}
		response.InternalError(c, "Failed to retrieve daily briefing: "+err.Error())
		return
	}

	response.Success(c, toInsightResponse(*briefing))
}

// GenerateInsights handles POST /api/v1/ai/insights/generate
// @Summary Generate new insights
// @Description Forces generation of new insights based on current portfolio analysis
// @Tags AI Insights
// @Produce json
// @Success 200 {object} response.Response{data=[]InsightResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights/generate [post]
func (h *InsightsHandler) GenerateInsights(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	insights, err := h.insightService.GenerateInsights(c.Request.Context(), userID)
	if err != nil {
		response.InternalError(c, "Failed to generate insights: "+err.Error())
		return
	}

	insightResponses := make([]InsightResponse, len(insights))
	for i, insight := range insights {
		insightResponses[i] = toInsightResponse(insight)
	}

	response.Success(c, insightResponses)
}

// MarkAsRead handles PUT /api/v1/ai/insights/:id/read
// @Summary Mark insight as read
// @Description Marks a specific insight as read
// @Tags AI Insights
// @Produce json
// @Param id path string true "Insight ID"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights/{id}/read [put]
func (h *InsightsHandler) MarkAsRead(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	insightIDStr := c.Param("id")
	insightID, err := uuid.Parse(insightIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid insight ID")
		return
	}

	if err := h.insightService.MarkAsRead(c.Request.Context(), insightID, userID); err != nil {
		if strings.Contains(err.Error(), "not found") {
			response.NotFound(c, "Insight not found")
			return
		}
		response.InternalError(c, "Failed to mark insight as read: "+err.Error())
		return
	}

	response.Success(c, gin.H{"message": "Insight marked as read"})
}

// GetUnreadCount handles GET /api/v1/ai/insights/unread/count
// @Summary Get unread insight count
// @Description Returns the count of unread insights for the user
// @Tags AI Insights
// @Produce json
// @Success 200 {object} response.Response{data=UnreadCountResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights/unread/count [get]
func (h *InsightsHandler) GetUnreadCount(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	count, err := h.insightService.GetUnreadCount(c.Request.Context(), userID)
	if err != nil {
		response.InternalError(c, "Failed to get unread count: "+err.Error())
		return
	}

	response.Success(c, UnreadCountResponse{Count: count})
}

// GetInsightByID handles GET /api/v1/ai/insights/:id
// @Summary Get insight by ID
// @Description Retrieves a specific insight by its ID
// @Tags AI Insights
// @Produce json
// @Param id path string true "Insight ID"
// @Success 200 {object} response.Response{data=InsightResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/insights/{id} [get]
func (h *InsightsHandler) GetInsightByID(c *gin.Context) {
	if h.insightService == nil || !h.insightService.IsEnabled() {
		response.InternalError(c, "Insight service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	insightIDStr := c.Param("id")
	insightID, err := uuid.Parse(insightIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid insight ID")
		return
	}

	insight, err := h.insightService.GetInsightByID(c.Request.Context(), insightID, userID)
	if err != nil {
		response.InternalError(c, "Failed to retrieve insight: "+err.Error())
		return
	}

	if insight == nil {
		response.NotFound(c, "Insight not found")
		return
	}

	response.Success(c, toInsightResponse(*insight))
}

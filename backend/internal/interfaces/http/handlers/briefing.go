package handlers

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// BriefingHandler handles AI-generated portfolio briefings.
type BriefingHandler struct {
	portfolioAnalyzer *services.PortfolioAnalyzer
	healthScorer      *services.HealthScorer
	alertGenerator    *services.AlertGenerator
	assetRepo         repositories.AssetRepository
	aiClient          *ai.GeminiClient
	logger            *zap.Logger
}

// NewBriefingHandler creates a new BriefingHandler.
func NewBriefingHandler(
	portfolioAnalyzer *services.PortfolioAnalyzer,
	healthScorer *services.HealthScorer,
	alertGenerator *services.AlertGenerator,
	assetRepo repositories.AssetRepository,
	aiClient *ai.GeminiClient,
	logger *zap.Logger,
) *BriefingHandler {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &BriefingHandler{
		portfolioAnalyzer: portfolioAnalyzer,
		healthScorer:      healthScorer,
		alertGenerator:    alertGenerator,
		assetRepo:         assetRepo,
		aiClient:          aiClient,
		logger:            logger,
	}
}

// Highlight represents a notable portfolio event.
type Highlight struct {
	Type    string `json:"type"`    // "gain", "loss", "alert"
	Asset   string `json:"asset"`   // Asset name or symbol
	Change  string `json:"change"`  // "+5.2%" or "Volatility increased"
	Message string `json:"message"` // Optional detailed message
}

// BriefingResponse represents the daily briefing response.
type BriefingResponse struct {
	Highlights      []Highlight               `json:"highlights"`
	Alerts          []services.PortfolioAlert `json:"alerts"`
	Recommendations []string                  `json:"recommendations"`
	GeneratedAt     time.Time                 `json:"generated_at"`
	Briefing        string                    `json:"briefing"`
	HealthScore     services.HealthScore      `json:"health_score"`
}

// GetBriefing handles GET /api/v1/ai/briefing
// @Summary Get autonomous portfolio briefing
// @Description Generates AI-powered portfolio briefing with highlights, recommendations, and health score
// @Tags AI Portfolio
// @Produce json
// @Success 200 {object} response.Response{data=BriefingResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/briefing [get]
func (h *BriefingHandler) GetBriefing(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "user_id not found in context")
		return
	}

	ctx := c.Request.Context()

	h.logger.Info("generating portfolio briefing",
		zap.String("user_id", userID.String()))

	// 1. Get portfolio analysis
	analysis, err := h.portfolioAnalyzer.Analyze(ctx, userID)
	if err != nil {
		h.logger.Error("failed to analyze portfolio", zap.Error(err))
		response.InternalError(c, "Failed to analyze portfolio")
		return
	}

	// 2. Get assets for health scoring
	assetResult, err := h.assetRepo.FindByUserID(ctx, userID, nil, &repositories.AssetPagination{Page: 1, PerPage: 1000})
	if err != nil {
		h.logger.Error("failed to get assets", zap.Error(err))
		response.InternalError(c, "Failed to get portfolio assets")
		return
	}

	// 3. Calculate health score
	healthScore := h.healthScorer.Calculate(assetResult.Assets)

	// 4. Extract highlights from analysis
	highlights := h.extractHighlights(analysis)

	// 5. Generate AI narrative using Gemini 3
	briefingText, recommendations, err := h.generateAIBriefing(ctx, analysis, healthScore, highlights)
	if err != nil {
		h.logger.Warn("AI briefing generation failed, using fallback", zap.Error(err))
		briefingText = h.generateFallbackBriefing(analysis, healthScore)
		recommendations = healthScore.Suggestions
	}

	// 6. Generate portfolio alerts
	var alerts []services.PortfolioAlert
	if h.alertGenerator != nil {
		alerts = h.alertGenerator.GenerateAlerts(ctx, assetResult.Assets, analysis.Summary, nil)
	}

	briefingResponse := BriefingResponse{
		Briefing:        briefingText,
		Highlights:      highlights,
		Alerts:          alerts,
		Recommendations: recommendations,
		HealthScore:     healthScore,
		GeneratedAt:     time.Now().UTC(),
	}

	h.logger.Info("briefing generated successfully",
		zap.Int("health_score", healthScore.Overall),
		zap.Int("highlights", len(highlights)))

	response.Success(c, briefingResponse)
}

// extractHighlights pulls notable events from the analysis.
func (h *BriefingHandler) extractHighlights(analysis *services.PortfolioAnalysis) []Highlight {
	var highlights []Highlight

	// Add top gainers
	for _, gainer := range analysis.TopGainers {
		name := gainer.Name
		if gainer.Symbol != "" {
			name = gainer.Symbol
		}
		highlights = append(highlights, Highlight{
			Type:   "gain",
			Asset:  name,
			Change: fmt.Sprintf("+%.1f%%", gainer.GainLossPercent),
		})
	}

	// Add top losers
	for _, loser := range analysis.TopLosers {
		name := loser.Name
		if loser.Symbol != "" {
			name = loser.Symbol
		}
		highlights = append(highlights, Highlight{
			Type:   "loss",
			Asset:  name,
			Change: fmt.Sprintf("%.1f%%", loser.GainLossPercent),
		})
	}

	// Add risk alerts
	if analysis.RiskMetrics != nil {
		for _, alert := range analysis.RiskMetrics.Alerts {
			highlights = append(highlights, Highlight{
				Type:    "alert",
				Asset:   "",
				Message: alert.Message,
			})
		}
	}

	// Limit to 5 highlights
	if len(highlights) > 5 {
		highlights = highlights[:5]
	}

	return highlights
}

// generateAIBriefing uses Gemini 3 with thinking levels to create a narrative.
func (h *BriefingHandler) generateAIBriefing(
	ctx context.Context,
	analysis *services.PortfolioAnalysis,
	healthScore services.HealthScore,
	highlights []Highlight,
) (narrative string, recommendations []string, err error) {
	if h.aiClient == nil {
		return "", nil, fmt.Errorf("AI client not configured")
	}

	// Build prompt with portfolio context
	prompt := h.buildBriefingPrompt(analysis, healthScore, highlights)

	systemPrompt := `You are WealthScope AI, an autonomous financial agent providing a daily portfolio briefing.

Your response MUST follow this exact format:

BRIEFING:
[2-3 sentences summarizing portfolio status, performance, and key observations]

RECOMMENDATIONS:
- [First actionable recommendation]
- [Second actionable recommendation]  
- [Third recommendation if applicable]

Guidelines:
- Be concise and professional
- Start the briefing with a greeting appropriate to time of day
- Mention specific numbers when relevant (percentages, values)
- Make recommendations actionable and specific
- Use confidence levels (High/Medium/Low) for predictions
- Focus on what the user should consider doing`

	// Use ThinkingBalanced for daily briefings (good balance of speed and depth)
	response, err := h.aiClient.GenerateWithThinking(ctx, prompt, systemPrompt, ai.ThinkingBalanced)
	if err != nil {
		return "", nil, fmt.Errorf("AI generation failed: %w", err)
	}

	// Parse the response
	narrative, recommendations = h.parseAIResponse(response)

	return narrative, recommendations, nil
}

// buildBriefingPrompt creates a structured prompt for the AI.
func (h *BriefingHandler) buildBriefingPrompt(
	analysis *services.PortfolioAnalysis,
	healthScore services.HealthScore,
	highlights []Highlight,
) string {
	var sb strings.Builder

	sb.WriteString("Generate a daily portfolio briefing based on this data:\n\n")

	// Portfolio summary
	if analysis.Summary != nil {
		sb.WriteString("## Portfolio Summary\n")
		sb.WriteString(fmt.Sprintf("- Total Value: $%.2f\n", analysis.Summary.TotalValue))
		sb.WriteString(fmt.Sprintf("- Total Invested: $%.2f\n", analysis.Summary.TotalInvested))
		sb.WriteString(fmt.Sprintf("- Gain/Loss: $%.2f (%.1f%%)\n", analysis.Summary.GainLoss, analysis.Summary.GainLossPercent))
		sb.WriteString(fmt.Sprintf("- Asset Count: %d\n\n", analysis.Summary.AssetCount))
	}

	// Health score
	sb.WriteString(fmt.Sprintf("## Health Score: %d/100\n", healthScore.Overall))
	sb.WriteString(fmt.Sprintf("- Diversification: %d/100\n", healthScore.Diversification))
	sb.WriteString(fmt.Sprintf("- Risk Level: %d/100\n", healthScore.RiskLevel))
	sb.WriteString(fmt.Sprintf("- Performance: %d/100\n\n", healthScore.Performance))

	// Highlights
	if len(highlights) > 0 {
		sb.WriteString("## Key Events\n")
		for _, h := range highlights {
			if h.Type == "gain" || h.Type == "loss" {
				sb.WriteString(fmt.Sprintf("- %s: %s %s\n", h.Asset, h.Type, h.Change))
			} else if h.Message != "" {
				sb.WriteString(fmt.Sprintf("- Alert: %s\n", h.Message))
			}
		}
		sb.WriteString("\n")
	}

	// Market context
	if analysis.MarketContext != "" {
		sb.WriteString(fmt.Sprintf("## Context\n%s\n", analysis.MarketContext))
	}

	return sb.String()
}

// parseAIResponse extracts narrative and recommendations from AI response.
func (h *BriefingHandler) parseAIResponse(response string) (narrative string, recommendations []string) {
	lines := strings.Split(response, "\n")
	inBriefing := false
	inRecommendations := false
	var briefingLines []string

	for _, line := range lines {
		trimmed := strings.TrimSpace(line)

		if strings.HasPrefix(trimmed, "BRIEFING:") {
			inBriefing = true
			inRecommendations = false
			continue
		}

		if strings.HasPrefix(trimmed, "RECOMMENDATIONS:") {
			inBriefing = false
			inRecommendations = true
			continue
		}

		if inBriefing && trimmed != "" {
			briefingLines = append(briefingLines, trimmed)
		}

		if inRecommendations && strings.HasPrefix(trimmed, "-") {
			rec := strings.TrimPrefix(trimmed, "-")
			rec = strings.TrimSpace(rec)
			if rec != "" {
				recommendations = append(recommendations, rec)
			}
		}
	}

	narrative = strings.Join(briefingLines, " ")

	// Fallback: if parsing failed, use the whole response as narrative
	if narrative == "" {
		narrative = strings.TrimSpace(response)
		if len(narrative) > 500 {
			narrative = narrative[:500] + "..."
		}
	}

	return narrative, recommendations
}

// generateFallbackBriefing creates a simple briefing without AI.
func (h *BriefingHandler) generateFallbackBriefing(analysis *services.PortfolioAnalysis, healthScore services.HealthScore) string {
	if analysis.Summary == nil {
		return "Welcome to WealthScope! Add some assets to get started with your personalized portfolio briefing."
	}

	hour := time.Now().Hour()
	greeting := "Good morning"
	if hour >= 12 && hour < 17 {
		greeting = "Good afternoon"
	} else if hour >= 17 {
		greeting = "Good evening"
	}

	var status string
	if analysis.Summary.GainLossPercent > 0 {
		status = fmt.Sprintf("up %.1f%%", analysis.Summary.GainLossPercent)
	} else if analysis.Summary.GainLossPercent < 0 {
		status = fmt.Sprintf("down %.1f%%", -analysis.Summary.GainLossPercent)
	} else {
		status = "unchanged"
	}

	return fmt.Sprintf(
		"%s! Your portfolio of %d assets is currently valued at $%.2f, %s overall. Your portfolio health score is %d/100.",
		greeting,
		analysis.Summary.AssetCount,
		analysis.Summary.TotalValue,
		status,
		healthScore.Overall,
	)
}

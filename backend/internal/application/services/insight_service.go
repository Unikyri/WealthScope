package services

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
)

// InsightCache provides simple in-memory caching for insights.
type InsightCache struct {
	dailyBriefings map[uuid.UUID]*cachedInsight
	unreadCounts   map[uuid.UUID]*cachedCount
	mu             sync.RWMutex
}

type cachedInsight struct {
	insight   *entities.Insight
	expiresAt time.Time
}

//nolint:govet // fieldalignment: keep logical field grouping for readability
type cachedCount struct {
	count     int
	expiresAt time.Time
}

// NewInsightCache creates a new InsightCache.
func NewInsightCache() *InsightCache {
	return &InsightCache{
		dailyBriefings: make(map[uuid.UUID]*cachedInsight),
		unreadCounts:   make(map[uuid.UUID]*cachedCount),
	}
}

// GetDailyBriefing retrieves cached daily briefing.
func (c *InsightCache) GetDailyBriefing(userID uuid.UUID) *entities.Insight {
	c.mu.RLock()
	defer c.mu.RUnlock()

	cached, ok := c.dailyBriefings[userID]
	if !ok || time.Now().After(cached.expiresAt) {
		return nil
	}
	return cached.insight
}

// SetDailyBriefing caches a daily briefing.
func (c *InsightCache) SetDailyBriefing(userID uuid.UUID, insight *entities.Insight, ttl time.Duration) {
	c.mu.Lock()
	defer c.mu.Unlock()

	c.dailyBriefings[userID] = &cachedInsight{
		insight:   insight,
		expiresAt: time.Now().Add(ttl),
	}
}

// GetUnreadCount retrieves cached unread count.
func (c *InsightCache) GetUnreadCount(userID uuid.UUID) (int, bool) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	cached, ok := c.unreadCounts[userID]
	if !ok || time.Now().After(cached.expiresAt) {
		return 0, false
	}
	return cached.count, true
}

// SetUnreadCount caches unread count.
func (c *InsightCache) SetUnreadCount(userID uuid.UUID, count int, ttl time.Duration) {
	c.mu.Lock()
	defer c.mu.Unlock()

	c.unreadCounts[userID] = &cachedCount{
		count:     count,
		expiresAt: time.Now().Add(ttl),
	}
}

// InvalidateUser invalidates all caches for a user.
func (c *InsightCache) InvalidateUser(userID uuid.UUID) {
	c.mu.Lock()
	defer c.mu.Unlock()

	delete(c.dailyBriefings, userID)
	delete(c.unreadCounts, userID)
}

// InsightService handles insight generation and management.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type InsightService struct {
	analyzer      *PortfolioAnalyzer
	geminiClient  *ai.GeminiClient
	promptBuilder *ai.PromptBuilder
	insightRepo   repositories.InsightRepository
	cache         *InsightCache
	logger        *zap.Logger
}

// NewInsightService creates a new InsightService.
func NewInsightService(
	analyzer *PortfolioAnalyzer,
	geminiClient *ai.GeminiClient,
	promptBuilder *ai.PromptBuilder,
	insightRepo repositories.InsightRepository,
	logger *zap.Logger,
) *InsightService {
	if logger == nil {
		logger = zap.NewNop()
	}

	return &InsightService{
		analyzer:      analyzer,
		geminiClient:  geminiClient,
		promptBuilder: promptBuilder,
		insightRepo:   insightRepo,
		cache:         NewInsightCache(),
		logger:        logger,
	}
}

// GenerateDailyBriefing generates or retrieves today's daily briefing.
func (s *InsightService) GenerateDailyBriefing(ctx context.Context, userID uuid.UUID) (*entities.Insight, error) {
	// Check cache first (4 hour TTL)
	if cached := s.cache.GetDailyBriefing(userID); cached != nil {
		return cached, nil
	}

	// Check if we already have today's briefing in DB
	existing, err := s.insightRepo.GetTodaysBriefing(ctx, userID)
	if err != nil {
		s.logger.Error("failed to check for existing briefing", zap.Error(err))
	}
	if existing != nil {
		s.cache.SetDailyBriefing(userID, existing, 4*time.Hour)
		return existing, nil
	}

	// Generate new briefing
	analysis, err := s.analyzer.Analyze(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to analyze portfolio: %w", err)
	}

	// Build prompt data
	promptData := s.buildPromptData(analysis, "en")

	// Generate briefing content
	userPrompt := ai.BuildDailyBriefingPrompt(promptData)
	content, err := s.geminiClient.Chat(ctx, []ai.Message{
		{Role: "user", Content: userPrompt},
	}, ai.DailyBriefingSystemPrompt)

	if err != nil {
		s.logger.Error("failed to generate daily briefing", zap.Error(err))
		return nil, fmt.Errorf("failed to generate briefing: %w", err)
	}

	// Create and save insight
	title := fmt.Sprintf("Daily Briefing - %s", time.Now().Format("January 2"))
	insight := entities.NewDailyBriefing(userID, title, content)

	// Extract action items from content
	actionItems := ai.ParseActionItems(content)
	insight.SetActionItems(actionItems)

	if err := s.insightRepo.Create(ctx, insight); err != nil {
		s.logger.Error("failed to save daily briefing", zap.Error(err))
		return nil, fmt.Errorf("failed to save briefing: %w", err)
	}

	// Cache the briefing
	s.cache.SetDailyBriefing(userID, insight, 4*time.Hour)
	s.cache.InvalidateUser(userID) // Invalidate unread count

	return insight, nil
}

// GenerateInsights generates multiple insights based on portfolio analysis.
func (s *InsightService) GenerateInsights(ctx context.Context, userID uuid.UUID) ([]entities.Insight, error) {
	analysis, err := s.analyzer.Analyze(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to analyze portfolio: %w", err)
	}

	var insights []entities.Insight

	// Generate daily briefing if not exists today
	briefing, err := s.GenerateDailyBriefing(ctx, userID)
	if err == nil && briefing != nil {
		insights = append(insights, *briefing)
	}

	// Generate alerts based on risk metrics
	if analysis.RiskMetrics != nil {
		for _, alert := range analysis.RiskMetrics.Alerts {
			if alert.Severity == "critical" || alert.Severity == "warning" {
				insight, err := s.generateAlertInsight(ctx, userID, analysis, alert)
				if err != nil {
					s.logger.Warn("failed to generate alert insight", zap.Error(err))
					continue
				}
				insights = append(insights, *insight)
			}
		}
	}

	// Generate recommendation if portfolio has room for improvement
	if s.shouldGenerateRecommendation(analysis) {
		recommendation, err := s.generateRecommendation(ctx, userID, analysis)
		if err != nil {
			s.logger.Warn("failed to generate recommendation", zap.Error(err))
		} else if recommendation != nil {
			insights = append(insights, *recommendation)
		}
	}

	s.cache.InvalidateUser(userID)

	return insights, nil
}

// generateAlertInsight generates an alert insight.
func (s *InsightService) generateAlertInsight(ctx context.Context, userID uuid.UUID, analysis *PortfolioAnalysis, alert RiskAlert) (*entities.Insight, error) {
	promptData := s.buildPromptData(analysis, "en")
	alertData := ai.RiskAlertData{
		Type:     alert.Type,
		Severity: alert.Severity,
		Title:    alert.Title,
		Message:  alert.Message,
	}

	userPrompt := ai.BuildAlertPrompt(alert.Type, promptData, alertData)
	content, err := s.geminiClient.Chat(ctx, []ai.Message{
		{Role: "user", Content: userPrompt},
	}, ai.AlertSystemPrompt)

	if err != nil {
		return nil, fmt.Errorf("failed to generate alert: %w", err)
	}

	priority := entities.InsightPriorityMedium
	if alert.Severity == "critical" {
		priority = entities.InsightPriorityHigh
	}

	category := entities.InsightCategoryRisk
	insight := entities.NewAlert(userID, alert.Title, content, priority, category)

	if err := s.insightRepo.Create(ctx, insight); err != nil {
		return nil, fmt.Errorf("failed to save alert: %w", err)
	}

	return insight, nil
}

// generateRecommendation generates a recommendation insight.
func (s *InsightService) generateRecommendation(ctx context.Context, userID uuid.UUID, analysis *PortfolioAnalysis) (*entities.Insight, error) {
	promptData := s.buildPromptData(analysis, "en")

	userPrompt := ai.BuildRecommendationPrompt(promptData)
	content, err := s.geminiClient.Chat(ctx, []ai.Message{
		{Role: "user", Content: userPrompt},
	}, ai.RecommendationSystemPrompt)

	if err != nil {
		return nil, fmt.Errorf("failed to generate recommendation: %w", err)
	}

	actionItems := ai.ParseActionItems(content)
	insight := entities.NewRecommendation(userID, "Portfolio Improvement Suggestions", content, actionItems)

	if err := s.insightRepo.Create(ctx, insight); err != nil {
		return nil, fmt.Errorf("failed to save recommendation: %w", err)
	}

	return insight, nil
}

// shouldGenerateRecommendation determines if a recommendation should be generated.
func (s *InsightService) shouldGenerateRecommendation(analysis *PortfolioAnalysis) bool {
	if analysis == nil || analysis.Summary == nil {
		return false
	}

	// Generate recommendation if:
	// 1. Risk score is elevated
	if analysis.RiskMetrics != nil && analysis.RiskMetrics.RiskScore > 40 {
		return true
	}

	// 2. There are allocation imbalances
	for _, alloc := range analysis.Allocations {
		if alloc.Status == "overweight" || alloc.Status == "underweight" {
			return true
		}
	}

	// 3. Significant losses
	if analysis.Summary.GainLossPercent < -5 {
		return true
	}

	return false
}

// buildPromptData converts PortfolioAnalysis to PortfolioDataForPrompt.
func (s *InsightService) buildPromptData(analysis *PortfolioAnalysis, lang string) ai.PortfolioDataForPrompt {
	data := ai.PortfolioDataForPrompt{
		PreferredLanguage: lang,
	}

	if analysis == nil || analysis.Summary == nil {
		data.HasPortfolio = false
		return data
	}

	data.HasPortfolio = analysis.Summary.AssetCount > 0
	data.TotalValue = analysis.Summary.TotalValue
	data.TotalInvested = analysis.Summary.TotalInvested
	data.GainLoss = analysis.Summary.GainLoss
	data.GainLossPercent = analysis.Summary.GainLossPercent
	data.AssetCount = analysis.Summary.AssetCount

	// Convert top gainers
	for _, g := range analysis.TopGainers {
		data.TopGainers = append(data.TopGainers, ai.AssetPerformanceData{
			Symbol:          g.Symbol,
			Name:            g.Name,
			GainLossPercent: g.GainLossPercent,
		})
	}

	// Convert top losers
	for _, l := range analysis.TopLosers {
		data.TopLosers = append(data.TopLosers, ai.AssetPerformanceData{
			Symbol:          l.Symbol,
			Name:            l.Name,
			GainLossPercent: l.GainLossPercent,
		})
	}

	// Convert allocations
	for _, a := range analysis.Allocations {
		data.Allocations = append(data.Allocations, ai.AllocationData{
			Type:    a.Type,
			Percent: a.Percent,
			Status:  a.Status,
		})
	}

	// Risk metrics
	if analysis.RiskMetrics != nil {
		data.RiskScore = analysis.RiskMetrics.RiskScore
		data.Diversification = analysis.RiskMetrics.DiversificationLevel

		for _, alert := range analysis.RiskMetrics.Alerts {
			data.RiskAlerts = append(data.RiskAlerts, ai.RiskAlertData{
				Type:     alert.Type,
				Severity: alert.Severity,
				Title:    alert.Title,
				Message:  alert.Message,
			})
		}
	}

	// Convert news
	for _, n := range analysis.RelevantNews {
		data.RelevantNews = append(data.RelevantNews, ai.NewsData{
			Title:     n.Title,
			Source:    n.Source,
			Sentiment: n.Sentiment,
		})
	}

	return data
}

// GetUserInsights retrieves insights for a user with filters.
func (s *InsightService) GetUserInsights(ctx context.Context, userID uuid.UUID, filter entities.InsightFilter) ([]entities.Insight, int, error) {
	insights, err := s.insightRepo.ListByUser(ctx, userID, filter)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to list insights: %w", err)
	}

	total, err := s.insightRepo.CountByUser(ctx, userID, filter)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count insights: %w", err)
	}

	return insights, total, nil
}

// GetUnreadCount returns the count of unread insights.
func (s *InsightService) GetUnreadCount(ctx context.Context, userID uuid.UUID) (int, error) {
	// Check cache first
	if count, ok := s.cache.GetUnreadCount(userID); ok {
		return count, nil
	}

	count, err := s.insightRepo.GetUnreadCount(ctx, userID)
	if err != nil {
		return 0, fmt.Errorf("failed to get unread count: %w", err)
	}

	// Cache for 5 minutes
	s.cache.SetUnreadCount(userID, count, 5*time.Minute)

	return count, nil
}

// MarkAsRead marks an insight as read.
func (s *InsightService) MarkAsRead(ctx context.Context, insightID, userID uuid.UUID) error {
	if err := s.insightRepo.MarkAsRead(ctx, insightID, userID); err != nil {
		return fmt.Errorf("failed to mark as read: %w", err)
	}

	s.cache.InvalidateUser(userID)
	return nil
}

// GetInsightByID retrieves a single insight by ID.
func (s *InsightService) GetInsightByID(ctx context.Context, insightID, userID uuid.UUID) (*entities.Insight, error) {
	return s.insightRepo.GetByID(ctx, insightID, userID)
}

// IsEnabled returns true if the service is properly configured.
func (s *InsightService) IsEnabled() bool {
	return s.geminiClient != nil && s.analyzer != nil
}

// AssetAnalysisResult represents the structured analysis of an asset.
type AssetAnalysisResult struct {
	Summary        string   `json:"summary"`
	KeyPoints      []string `json:"key_points"`
	SentimentScore float64  `json:"sentiment_score"`
	SentimentTrend string   `json:"sentiment_trend"`
}

// GenerateAssetAnalysis generates an AI analysis for a specific asset.
func (s *InsightService) GenerateAssetAnalysis(ctx context.Context, symbol string) (*AssetAnalysisResult, error) {
	prompt := ai.BuildAssetAnalysisPrompt(symbol)

	content, err := s.geminiClient.Chat(ctx, []ai.Message{
		{Role: "user", Content: prompt},
	}, ai.AssetAnalysisSystemPrompt)

	if err != nil {
		s.logger.Error("failed to generate asset analysis", zap.String("symbol", symbol), zap.Error(err))
		return nil, fmt.Errorf("failed to generate analysis: %w", err)
	}

	// Clean up content if it contains markdown code blocks
	content = cleanJSONContent(content)

	var result AssetAnalysisResult
	if err := json.Unmarshal([]byte(content), &result); err != nil {
		s.logger.Error("failed to parse asset analysis JSON",
			zap.String("symbol", symbol),
			zap.String("content", content),
			zap.Error(err))
		return nil, fmt.Errorf("failed to parse analysis response: %w", err)
	}

	return &result, nil
}

// cleanJSONContent removes markdown code blocks from JSON string
func cleanJSONContent(content string) string {
	content = strings.TrimSpace(content)
	if strings.HasPrefix(content, "```json") {
		content = strings.TrimPrefix(content, "```json")
		content = strings.TrimSuffix(content, "```")
	} else if strings.HasPrefix(content, "```") {
		content = strings.TrimPrefix(content, "```")
		content = strings.TrimSuffix(content, "```")
	}
	return strings.TrimSpace(content)
}

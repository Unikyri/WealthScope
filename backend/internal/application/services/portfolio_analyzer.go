package services

import (
	"context"
	"sort"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	domainsvc "github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// AssetPerformance represents the performance of a single asset.
type AssetPerformance struct {
	Symbol          string  `json:"symbol"`
	Name            string  `json:"name"`
	Type            string  `json:"type"`
	GainLossPercent float64 `json:"gain_loss_percent"`
	GainLossAmount  float64 `json:"gain_loss_amount"`
	CurrentValue    float64 `json:"current_value"`
}

// AllocationInsight represents an insight about asset allocation.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AllocationInsight struct {
	Type       string  `json:"type"`
	Status     string  `json:"status"`
	Suggestion string  `json:"suggestion"`
	Percent    float64 `json:"percent"`
}

// PortfolioAnalysis contains comprehensive portfolio analysis data.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PortfolioAnalysis struct {
	AnalyzedAt    time.Time                      `json:"analyzed_at"`
	Summary       *repositories.PortfolioSummary `json:"summary"`
	RiskMetrics   *PortfolioRisk                 `json:"risk_metrics"`
	MarketContext string                         `json:"market_context"`
	TopGainers    []AssetPerformance             `json:"top_gainers"`
	TopLosers     []AssetPerformance             `json:"top_losers"`
	Allocations   []AllocationInsight            `json:"allocations"`
	RelevantNews  []domainsvc.NewsArticle        `json:"relevant_news"`
}

// PortfolioAnalyzer aggregates data from multiple sources to build portfolio analysis.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PortfolioAnalyzer struct {
	assetRepo   repositories.AssetRepository
	riskService *RiskService
	newsService *NewsService
	logger      *zap.Logger
}

// NewPortfolioAnalyzer creates a new PortfolioAnalyzer.
func NewPortfolioAnalyzer(
	assetRepo repositories.AssetRepository,
	riskService *RiskService,
	newsService *NewsService,
	logger *zap.Logger,
) *PortfolioAnalyzer {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &PortfolioAnalyzer{
		assetRepo:   assetRepo,
		riskService: riskService,
		newsService: newsService,
		logger:      logger,
	}
}

// Analyze performs comprehensive portfolio analysis for a user.
func (a *PortfolioAnalyzer) Analyze(ctx context.Context, userID uuid.UUID) (*PortfolioAnalysis, error) {
	analysis := &PortfolioAnalysis{
		AnalyzedAt: time.Now().UTC(),
	}

	// Get portfolio summary
	summary, err := a.assetRepo.GetPortfolioSummary(ctx, userID)
	if err != nil {
		a.logger.Error("failed to get portfolio summary", zap.Error(err))
		return nil, err
	}
	analysis.Summary = summary

	// If no assets, return minimal analysis
	if summary == nil || summary.AssetCount == 0 {
		analysis.RiskMetrics = &PortfolioRisk{
			Alerts:               []RiskAlert{},
			RiskScore:            0,
			DiversificationLevel: "good",
		}
		analysis.MarketContext = "No portfolio data available"
		return analysis, nil
	}

	// Get all assets for detailed analysis
	assetResult, err := a.assetRepo.FindByUserID(ctx, userID, nil, &repositories.AssetPagination{Page: 1, PerPage: 1000})
	if err != nil {
		a.logger.Error("failed to get assets", zap.Error(err))
		return nil, err
	}

	// Analyze risk
	if a.riskService != nil {
		riskMetrics := a.riskService.AnalyzePortfolio(assetResult.Assets)
		analysis.RiskMetrics = &riskMetrics
	}

	// Get top movers
	gainers, losers := a.GetTopMovers(assetResult.Assets, 3)
	analysis.TopGainers = gainers
	analysis.TopLosers = losers

	// Analyze allocations
	analysis.Allocations = a.AnalyzeAllocations(summary.BreakdownByType)

	// Get relevant news for top holdings
	if a.newsService != nil {
		news := a.fetchRelevantNews(ctx, assetResult.Assets)
		analysis.RelevantNews = news
	}

	// Determine market context based on portfolio performance
	analysis.MarketContext = a.determineMarketContext(summary)

	return analysis, nil
}

// GetTopMovers returns the top gainers and losers from assets.
func (a *PortfolioAnalyzer) GetTopMovers(assets []entities.Asset, limit int) (gainers, losers []AssetPerformance) {
	var performances []AssetPerformance

	for _, asset := range assets {
		gainLoss := asset.GainLoss()
		if gainLoss == nil {
			continue
		}

		gainLossPercent := asset.GainLossPercent()
		if gainLossPercent == nil {
			continue
		}

		symbol := ""
		if asset.Symbol != nil {
			symbol = *asset.Symbol
		}

		performances = append(performances, AssetPerformance{
			Symbol:          symbol,
			Name:            asset.Name,
			Type:            string(asset.Type),
			GainLossPercent: *gainLossPercent,
			GainLossAmount:  *gainLoss,
			CurrentValue:    asset.TotalValue(),
		})
	}

	// Sort by gain/loss percent
	sort.Slice(performances, func(i, j int) bool {
		return performances[i].GainLossPercent > performances[j].GainLossPercent
	})

	// Get top gainers (positive performance)
	for i := 0; i < len(performances) && i < limit; i++ {
		if performances[i].GainLossPercent > 0 {
			gainers = append(gainers, performances[i])
		}
	}

	// Get top losers (negative performance, from the end)
	for i := len(performances) - 1; i >= 0 && len(losers) < limit; i-- {
		if performances[i].GainLossPercent < 0 {
			losers = append(losers, performances[i])
		}
	}

	return gainers, losers
}

// AnalyzeAllocations analyzes asset type allocations and provides insights.
func (a *PortfolioAnalyzer) AnalyzeAllocations(breakdown []repositories.AssetTypeBreakdown) []AllocationInsight {
	// Define target allocations (simplified balanced portfolio)
	targetAllocations := map[entities.AssetType]float64{
		entities.AssetTypeStock:      40.0,
		entities.AssetTypeETF:        20.0,
		entities.AssetTypeBond:       20.0,
		entities.AssetTypeCrypto:     5.0,
		entities.AssetTypeRealEstate: 10.0,
		entities.AssetTypeGold:       5.0,
	}

	var insights []AllocationInsight

	for _, b := range breakdown {
		target, hasTarget := targetAllocations[b.Type]
		status := "balanced"
		suggestion := ""

		if hasTarget {
			diff := b.Percent - target
			if diff > 10 {
				status = "overweight"
				suggestion = "Consider reducing exposure to maintain balance"
			} else if diff < -10 {
				status = "underweight"
				suggestion = "Consider increasing allocation for better diversification"
			}
		} else {
			// For types without target (cash, other)
			if b.Percent > 20 {
				status = "overweight"
				suggestion = "High cash position may reduce returns"
			}
		}

		insights = append(insights, AllocationInsight{
			Type:       string(b.Type),
			Percent:    b.Percent,
			Status:     status,
			Suggestion: suggestion,
		})
	}

	return insights
}

// fetchRelevantNews fetches news for the top holdings.
func (a *PortfolioAnalyzer) fetchRelevantNews(ctx context.Context, assets []entities.Asset) []domainsvc.NewsArticle {
	// Get unique symbols from assets (prioritize by value)
	type symbolValue struct {
		symbol string
		value  float64
	}

	var symbolValues []symbolValue
	for _, asset := range assets {
		if asset.Symbol != nil && *asset.Symbol != "" {
			symbolValues = append(symbolValues, symbolValue{
				symbol: *asset.Symbol,
				value:  asset.TotalValue(),
			})
		}
	}

	// Sort by value (highest first)
	sort.Slice(symbolValues, func(i, j int) bool {
		return symbolValues[i].value > symbolValues[j].value
	})

	// Get news for top 3 symbols
	var allNews []domainsvc.NewsArticle
	seenIDs := make(map[string]bool)

	for i := 0; i < len(symbolValues) && i < 3; i++ {
		news, err := a.newsService.GetNewsBySymbol(ctx, symbolValues[i].symbol, 2)
		if err != nil {
			a.logger.Warn("failed to fetch news for symbol",
				zap.String("symbol", symbolValues[i].symbol),
				zap.Error(err))
			continue
		}

		for _, article := range news {
			if !seenIDs[article.ID] {
				seenIDs[article.ID] = true
				allNews = append(allNews, article)
			}
		}
	}

	// Limit to 5 articles total
	if len(allNews) > 5 {
		allNews = allNews[:5]
	}

	return allNews
}

// determineMarketContext provides a simple market context based on portfolio performance.
func (a *PortfolioAnalyzer) determineMarketContext(summary *repositories.PortfolioSummary) string {
	if summary == nil {
		return "neutral"
	}

	switch {
	case summary.GainLossPercent > 5:
		return "Your portfolio is performing well with positive gains."
	case summary.GainLossPercent > 0:
		return "Your portfolio shows modest positive performance."
	case summary.GainLossPercent > -5:
		return "Your portfolio is slightly down but within normal range."
	default:
		return "Your portfolio is experiencing significant losses. Consider reviewing your positions."
	}
}

// GetPortfolioSummary returns just the portfolio summary without full analysis.
func (a *PortfolioAnalyzer) GetPortfolioSummary(ctx context.Context, userID uuid.UUID) (*repositories.PortfolioSummary, error) {
	return a.assetRepo.GetPortfolioSummary(ctx, userID)
}

// HasPortfolio checks if a user has any assets.
func (a *PortfolioAnalyzer) HasPortfolio(ctx context.Context, userID uuid.UUID) (bool, error) {
	count, err := a.assetRepo.CountByUserID(ctx, userID)
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

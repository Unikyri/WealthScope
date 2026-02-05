package services

import (
	"context"
	"fmt"
	"math"
	"time"

	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// HistoricalStats contains statistical analysis of historical price data
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type HistoricalStats struct {
	Symbol        string  `json:"symbol"`
	Period        string  `json:"period"`
	DataPoints    int     `json:"data_points"`
	AverageReturn float64 `json:"average_return"`
	Volatility    float64 `json:"volatility"`
	MaxDrawdown   float64 `json:"max_drawdown"`
	BestDay       float64 `json:"best_day"`
	WorstDay      float64 `json:"worst_day"`
	PositiveDays  int     `json:"positive_days"`
	NegativeDays  int     `json:"negative_days"`
}

// Projection contains future value projections based on historical data
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type Projection struct {
	Symbol             string  `json:"symbol"`
	CurrentValue       float64 `json:"current_value"`
	TimeframeMonths    int     `json:"timeframe_months"`
	ExpectedValue      float64 `json:"expected_value"`
	OptimisticValue    float64 `json:"optimistic_value"`
	PessimisticValue   float64 `json:"pessimistic_value"`
	ExpectedReturn     float64 `json:"expected_return"`
	OptimisticReturn   float64 `json:"optimistic_return"`
	PessimisticReturn  float64 `json:"pessimistic_return"`
	ConfidenceInterval float64 `json:"confidence_interval"`
}

// HistoricalAnalyzer provides historical data analysis for scenario simulations
type HistoricalAnalyzer struct {
	priceHistoryRepo repositories.PriceHistoryRepository
	logger           *zap.Logger
}

// NewHistoricalAnalyzer creates a new HistoricalAnalyzer
func NewHistoricalAnalyzer(
	priceHistoryRepo repositories.PriceHistoryRepository,
	logger *zap.Logger,
) *HistoricalAnalyzer {
	return &HistoricalAnalyzer{
		priceHistoryRepo: priceHistoryRepo,
		logger:           logger,
	}
}

// GetHistoricalStats returns statistical analysis for a symbol over a period
func (a *HistoricalAnalyzer) GetHistoricalStats(
	ctx context.Context,
	symbol string,
	period string,
) (*HistoricalStats, error) {
	// Parse period to date range
	from, to := a.parsePeriod(period)

	// Get historical prices
	prices, err := a.priceHistoryRepo.GetBySymbolAndDateRange(ctx, symbol, from, to)
	if err != nil {
		return nil, fmt.Errorf("failed to get price history: %w", err)
	}

	if len(prices) < 2 {
		a.logger.Warn("insufficient data points for analysis",
			zap.String("symbol", symbol),
			zap.Int("data_points", len(prices)),
		)
		return &HistoricalStats{
			Symbol:     symbol,
			Period:     period,
			DataPoints: len(prices),
		}, nil
	}

	// Calculate returns
	returns := a.calculateDailyReturns(prices)
	if len(returns) == 0 {
		return &HistoricalStats{
			Symbol:     symbol,
			Period:     period,
			DataPoints: len(prices),
		}, nil
	}

	// Calculate statistics
	avgReturn := a.calculateMean(returns)
	volatility := a.calculateStandardDeviation(returns)
	maxDrawdown := a.calculateMaxDrawdown(prices)
	bestDay, worstDay := a.findExtremes(returns)
	positiveDays, negativeDays := a.countPositiveNegative(returns)

	return &HistoricalStats{
		Symbol:        symbol,
		Period:        period,
		DataPoints:    len(prices),
		AverageReturn: avgReturn * 100,
		Volatility:    volatility * 100,
		MaxDrawdown:   maxDrawdown * 100,
		BestDay:       bestDay * 100,
		WorstDay:      worstDay * 100,
		PositiveDays:  positiveDays,
		NegativeDays:  negativeDays,
	}, nil
}

// ProjectWithHistory projects future values based on historical performance
func (a *HistoricalAnalyzer) ProjectWithHistory(
	ctx context.Context,
	symbol string,
	currentValue float64,
	months int,
) (*Projection, error) {
	// Get 1 year of historical data for projection
	stats, err := a.GetHistoricalStats(ctx, symbol, "1Y")
	if err != nil {
		return nil, err
	}

	// If no data, return projection with current value
	if stats.DataPoints < 2 {
		return &Projection{
			Symbol:             symbol,
			CurrentValue:       currentValue,
			TimeframeMonths:    months,
			ExpectedValue:      currentValue,
			OptimisticValue:    currentValue,
			PessimisticValue:   currentValue,
			ConfidenceInterval: 0,
		}, nil
	}

	// Annualize the daily return (assume ~252 trading days)
	dailyReturn := stats.AverageReturn / 100
	annualReturn := dailyReturn * 252

	// Scale to the requested timeframe
	timeframeYears := float64(months) / 12.0
	expectedReturn := annualReturn * timeframeYears

	// Calculate volatility-adjusted projections
	dailyVolatility := stats.Volatility / 100
	annualVolatility := dailyVolatility * math.Sqrt(252)
	timeframeVolatility := annualVolatility * math.Sqrt(timeframeYears)

	// 1.5 standard deviations for ~87% confidence interval
	confidenceMultiplier := 1.5

	expectedValue := currentValue * (1 + expectedReturn)
	optimisticValue := currentValue * (1 + expectedReturn + (timeframeVolatility * confidenceMultiplier))
	pessimisticValue := currentValue * (1 + expectedReturn - (timeframeVolatility * confidenceMultiplier))

	// Don't let pessimistic go below 0
	if pessimisticValue < 0 {
		pessimisticValue = 0
	}

	return &Projection{
		Symbol:             symbol,
		CurrentValue:       currentValue,
		TimeframeMonths:    months,
		ExpectedValue:      expectedValue,
		OptimisticValue:    optimisticValue,
		PessimisticValue:   pessimisticValue,
		ExpectedReturn:     expectedReturn * 100,
		OptimisticReturn:   ((optimisticValue - currentValue) / currentValue) * 100,
		PessimisticReturn:  ((pessimisticValue - currentValue) / currentValue) * 100,
		ConfidenceInterval: 87,
	}, nil
}

// parsePeriod converts a period string to a date range
func (a *HistoricalAnalyzer) parsePeriod(period string) (time.Time, time.Time) {
	now := time.Now().UTC()
	to := now

	var from time.Time
	switch period {
	case "1M":
		from = now.AddDate(0, -1, 0)
	case "3M":
		from = now.AddDate(0, -3, 0)
	case "6M":
		from = now.AddDate(0, -6, 0)
	case "1Y":
		from = now.AddDate(-1, 0, 0)
	case "2Y":
		from = now.AddDate(-2, 0, 0)
	case "5Y":
		from = now.AddDate(-5, 0, 0)
	default:
		// Default to 1 year
		from = now.AddDate(-1, 0, 0)
	}

	return from, to
}

// calculateDailyReturns computes the daily returns from price data
func (a *HistoricalAnalyzer) calculateDailyReturns(prices []entities.PriceHistory) []float64 {
	if len(prices) < 2 {
		return nil
	}

	returns := make([]float64, 0, len(prices)-1)
	for i := 1; i < len(prices); i++ {
		if prices[i-1].Price > 0 {
			dailyReturn := (prices[i].Price - prices[i-1].Price) / prices[i-1].Price
			returns = append(returns, dailyReturn)
		}
	}
	return returns
}

// calculateMean computes the mean of a slice of values
func (a *HistoricalAnalyzer) calculateMean(values []float64) float64 {
	if len(values) == 0 {
		return 0
	}
	sum := 0.0
	for _, v := range values {
		sum += v
	}
	return sum / float64(len(values))
}

// calculateStandardDeviation computes the standard deviation
func (a *HistoricalAnalyzer) calculateStandardDeviation(values []float64) float64 {
	if len(values) < 2 {
		return 0
	}
	mean := a.calculateMean(values)
	sumSquaredDiff := 0.0
	for _, v := range values {
		diff := v - mean
		sumSquaredDiff += diff * diff
	}
	variance := sumSquaredDiff / float64(len(values)-1)
	return math.Sqrt(variance)
}

// calculateMaxDrawdown computes the maximum peak-to-trough decline
func (a *HistoricalAnalyzer) calculateMaxDrawdown(prices []entities.PriceHistory) float64 {
	if len(prices) < 2 {
		return 0
	}

	maxDrawdown := 0.0
	peak := prices[0].Price

	for _, p := range prices {
		if p.Price > peak {
			peak = p.Price
		}
		if peak > 0 {
			drawdown := (peak - p.Price) / peak
			if drawdown > maxDrawdown {
				maxDrawdown = drawdown
			}
		}
	}

	return maxDrawdown
}

// findExtremes finds the best and worst daily returns
func (a *HistoricalAnalyzer) findExtremes(returns []float64) (best, worst float64) {
	if len(returns) == 0 {
		return 0, 0
	}

	best = returns[0]
	worst = returns[0]

	for _, r := range returns {
		if r > best {
			best = r
		}
		if r < worst {
			worst = r
		}
	}

	return best, worst
}

// countPositiveNegative counts positive and negative return days
func (a *HistoricalAnalyzer) countPositiveNegative(returns []float64) (positive, negative int) {
	for _, r := range returns {
		if r > 0 {
			positive++
		} else if r < 0 {
			negative++
		}
	}
	return positive, negative
}

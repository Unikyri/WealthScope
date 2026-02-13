package services

import (
	"math"

	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// HealthScore represents portfolio health metrics with weighted scoring.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type HealthScore struct {
	Suggestions     []string `json:"suggestions"`
	Overall         int      `json:"overall"`         // 0-100 weighted average
	Diversification int      `json:"diversification"` // 25% weight
	SectorBalance   int      `json:"sector_balance"`  // 20% weight
	RiskLevel       int      `json:"risk_level"`      // 20% weight
	Performance     int      `json:"performance"`     // 15% weight
	Correlation     int      `json:"correlation"`     // 10% weight - placeholder
	Liquidity       int      `json:"liquidity"`       // 10% weight
}

// Scoring weights
const (
	weightDiversification = 0.25
	weightSectorBalance   = 0.20
	weightRiskLevel       = 0.20
	weightPerformance     = 0.15
	weightCorrelation     = 0.10
	weightLiquidity       = 0.10
)

// HealthScorer calculates portfolio health scores.
type HealthScorer struct {
	logger *zap.Logger
}

// NewHealthScorer creates a new HealthScorer.
func NewHealthScorer(logger *zap.Logger) *HealthScorer {
	return &HealthScorer{
		logger: logger,
	}
}

// Calculate computes the portfolio health score from assets.
func (s *HealthScorer) Calculate(assets []entities.Asset) HealthScore {
	if len(assets) == 0 {
		return HealthScore{
			Overall:     0,
			Suggestions: []string{"Add assets to your portfolio to see health metrics"},
		}
	}

	// Calculate individual factor scores
	diversification := s.calculateDiversificationScore(assets)
	sectorBalance := s.calculateSectorBalanceScore(assets)
	riskLevel := s.calculateRiskScore(assets)
	performance := s.calculatePerformanceScore(assets)
	correlation := s.calculateCorrelationScore(assets) // Placeholder
	liquidity := s.calculateLiquidityScore(assets)

	// Calculate weighted overall score
	overall := int(
		float64(diversification)*weightDiversification +
			float64(sectorBalance)*weightSectorBalance +
			float64(riskLevel)*weightRiskLevel +
			float64(performance)*weightPerformance +
			float64(correlation)*weightCorrelation +
			float64(liquidity)*weightLiquidity,
	)

	// Generate suggestions based on low scores
	suggestions := s.generateSuggestions(diversification, sectorBalance, riskLevel, performance, liquidity)

	s.logger.Debug("calculated portfolio health score",
		zap.Int("overall", overall),
		zap.Int("diversification", diversification),
		zap.Int("sector_balance", sectorBalance),
		zap.Int("risk_level", riskLevel),
		zap.Int("performance", performance),
		zap.Int("assets_count", len(assets)))

	return HealthScore{
		Overall:         overall,
		Diversification: diversification,
		SectorBalance:   sectorBalance,
		RiskLevel:       riskLevel,
		Performance:     performance,
		Correlation:     correlation,
		Liquidity:       liquidity,
		Suggestions:     suggestions,
	}
}

// calculateDiversificationScore scores based on number of asset types and distribution.
// Higher diversity = higher score.
func (s *HealthScorer) calculateDiversificationScore(assets []entities.Asset) int {
	if len(assets) == 0 {
		return 0
	}

	// Count unique asset types
	typeCount := make(map[entities.AssetType]int)
	for _, asset := range assets {
		typeCount[asset.Type]++
	}

	uniqueTypes := len(typeCount)
	totalAssets := len(assets)

	// Score based on:
	// 1. Number of unique types (0-50 points)
	// 2. Distribution evenness (0-50 points)

	// 1. Type diversity: more types = higher score
	// Max score at 5+ types
	typeScore := min(uniqueTypes*10, 50)

	// 2. Distribution evenness using simplified entropy
	// Perfect distribution: each type has equal count
	idealCount := float64(totalAssets) / float64(uniqueTypes)
	var deviation float64
	for _, count := range typeCount {
		deviation += math.Abs(float64(count) - idealCount)
	}
	// Normalize deviation
	maxDeviation := float64(totalAssets)
	evenness := 1.0 - (deviation / maxDeviation)
	distributionScore := int(evenness * 50)

	return min(typeScore+distributionScore, 100)
}

// calculateSectorBalanceScore evaluates sector/industry distribution.
func (s *HealthScorer) calculateSectorBalanceScore(assets []entities.Asset) int {
	if len(assets) == 0 {
		return 0
	}

	// Group by asset type and calculate value weights
	typeValues := make(map[entities.AssetType]float64)
	var totalValue float64

	for _, asset := range assets {
		value := asset.TotalValue()
		typeValues[asset.Type] += value
		totalValue += value
	}

	if totalValue == 0 {
		return 50 // Neutral score
	}

	// Check for over-concentration (any single type > 50% is concerning)
	var maxConcentration float64
	for _, value := range typeValues {
		concentration := value / totalValue
		if concentration > maxConcentration {
			maxConcentration = concentration
		}
	}

	// Calculate score: less concentration = higher score
	// 100% in one type = 0 score
	// 50% or less in any type = 100 score
	if maxConcentration >= 1.0 {
		return 0
	}
	if maxConcentration <= 0.5 {
		return 100
	}

	// Linear scale from 50-100% concentration = 100-0 score
	return int((1.0 - ((maxConcentration - 0.5) * 2)) * 100)
}

// calculateRiskScore evaluates portfolio risk level.
// Mix of volatile and stable assets = better score.
func (s *HealthScorer) calculateRiskScore(assets []entities.Asset) int {
	if len(assets) == 0 {
		return 0
	}

	// Classify assets by risk level
	var highRiskValue, medRiskValue, lowRiskValue float64

	for _, asset := range assets {
		value := asset.TotalValue()
		switch asset.Type {
		case entities.AssetTypeCrypto:
			highRiskValue += value
		case entities.AssetTypeStock, entities.AssetTypeETF, entities.AssetTypeRealEstate:
			medRiskValue += value
		case entities.AssetTypeBond, entities.AssetTypeCash:
			lowRiskValue += value
		default:
			medRiskValue += value
		}
	}

	totalValue := highRiskValue + medRiskValue + lowRiskValue
	if totalValue == 0 {
		return 50
	}

	// Ideal: balanced mix (not all high-risk, not all low-risk)
	// Score based on having some stability
	lowRiskRatio := lowRiskValue / totalValue
	highRiskRatio := highRiskValue / totalValue

	// Penalize if too much high risk (>60%) or too conservative (<10% growth)
	score := 100

	if highRiskRatio > 0.6 {
		score -= int((highRiskRatio - 0.6) * 200) // -40 max
	}

	if lowRiskRatio > 0.8 {
		score -= 20 // Too conservative penalty
	}

	// Reward balanced approach
	if lowRiskRatio >= 0.2 && lowRiskRatio <= 0.5 {
		score += 10
	}

	return max(0, min(score, 100))
}

// calculatePerformanceScore evaluates recent portfolio performance.
func (s *HealthScorer) calculatePerformanceScore(assets []entities.Asset) int {
	if len(assets) == 0 {
		return 0
	}

	var totalGainLoss, totalCost float64
	assetsWithPrice := 0

	for _, asset := range assets {
		gl := asset.GainLoss()
		if gl != nil {
			totalGainLoss += *gl
			totalCost += asset.TotalCost()
			assetsWithPrice++
		}
	}

	if totalCost == 0 || assetsWithPrice == 0 {
		return 50 // Neutral score when no price data
	}

	// Calculate overall return percentage
	returnPct := (totalGainLoss / totalCost) * 100

	// Score mapping:
	// < -20% = 0
	// -20% to 0% = 0-50
	// 0% to 20% = 50-100
	// > 20% = 100
	switch {
	case returnPct <= -20:
		return 0
	case returnPct < 0:
		return int(50 + (returnPct * 2.5)) // -20 to 0 = 0 to 50
	case returnPct <= 20:
		return int(50 + (returnPct * 2.5)) // 0 to 20 = 50 to 100
	default:
		return 100
	}
}

// calculateCorrelationScore is a placeholder for correlation analysis.
// Would require historical price data for proper implementation.
func (s *HealthScorer) calculateCorrelationScore(_ []entities.Asset) int {
	// Placeholder: return neutral score
	// Future: analyze asset price correlations
	return 70
}

// calculateLiquidityScore evaluates how easily assets can be sold.
func (s *HealthScorer) calculateLiquidityScore(assets []entities.Asset) int {
	if len(assets) == 0 {
		return 0
	}

	var liquidValue, illiquidValue float64

	for _, asset := range assets {
		value := asset.TotalValue()
		switch asset.Type {
		case entities.AssetTypeStock, entities.AssetTypeETF, entities.AssetTypeCrypto, entities.AssetTypeCash:
			liquidValue += value
		case entities.AssetTypeBond:
			liquidValue += value * 0.8 // Somewhat liquid
			illiquidValue += value * 0.2
		case entities.AssetTypeRealEstate:
			illiquidValue += value
		default:
			liquidValue += value * 0.5
			illiquidValue += value * 0.5
		}
	}

	totalValue := liquidValue + illiquidValue
	if totalValue == 0 {
		return 50
	}

	liquidityRatio := liquidValue / totalValue
	return int(liquidityRatio * 100)
}

// generateSuggestions creates improvement recommendations based on scores.
func (s *HealthScorer) generateSuggestions(diversification, sectorBalance, riskLevel, performance, liquidity int) []string {
	var suggestions []string

	if diversification < 60 {
		suggestions = append(suggestions, "Consider diversifying into more asset types for better risk management")
	}

	if sectorBalance < 50 {
		suggestions = append(suggestions, "Your portfolio may be over-concentrated in one area - consider rebalancing")
	}

	if riskLevel < 50 {
		suggestions = append(suggestions, "Your portfolio has high risk exposure - consider adding stable assets like bonds or gold")
	}

	if performance < 40 {
		suggestions = append(suggestions, "Review underperforming assets and consider restructuring")
	}

	if liquidity < 50 {
		suggestions = append(suggestions, "Significant portion of portfolio is in illiquid assets - ensure you have emergency liquidity")
	}

	if len(suggestions) == 0 {
		suggestions = append(suggestions, "Your portfolio is well-balanced - continue monitoring market conditions")
	}

	return suggestions
}

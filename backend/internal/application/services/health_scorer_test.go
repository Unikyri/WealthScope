package services

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

func TestHealthScorer_Calculate_EmptyPortfolio(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	score := scorer.Calculate([]entities.Asset{})

	assert.Equal(t, 0, score.Overall)
	assert.Contains(t, score.Suggestions[0], "Add assets")
}

func TestHealthScorer_Calculate_DiversifiedPortfolio(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Create a well-diversified portfolio
	assets := []entities.Asset{
		{Type: entities.AssetTypeStock, Quantity: 10, PurchasePrice: 100},
		{Type: entities.AssetTypeBond, Quantity: 5, PurchasePrice: 200},
		{Type: entities.AssetTypeETF, Quantity: 8, PurchasePrice: 150},
		{Type: entities.AssetTypeCrypto, Quantity: 2, PurchasePrice: 500},
		{Type: entities.AssetTypeGold, Quantity: 3, PurchasePrice: 300},
	}

	score := scorer.Calculate(assets)

	// Diversified portfolio should have good diversification score
	assert.Greater(t, score.Diversification, 60)
	assert.Greater(t, score.Overall, 50)
}

func TestHealthScorer_Calculate_SingleAssetType(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Single asset type = poor diversification
	assets := []entities.Asset{
		{Type: entities.AssetTypeStock, Quantity: 100, PurchasePrice: 50},
		{Type: entities.AssetTypeStock, Quantity: 200, PurchasePrice: 30},
	}

	score := scorer.Calculate(assets)

	// Single type should have low diversification score
	assert.LessOrEqual(t, score.Diversification, 60)
	assert.LessOrEqual(t, score.SectorBalance, 50) // All in one type
}

func TestHealthScorer_Calculate_HighRiskPortfolio(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// All crypto = high risk
	assets := []entities.Asset{
		{Type: entities.AssetTypeCrypto, Quantity: 10, PurchasePrice: 1000},
		{Type: entities.AssetTypeCrypto, Quantity: 5, PurchasePrice: 2000},
	}

	score := scorer.Calculate(assets)

	// High-risk portfolio should have lower risk score
	assert.LessOrEqual(t, score.RiskLevel, 70)
}

func TestHealthScorer_Calculate_ConservativePortfolio(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// All bonds and cash = conservative
	assets := []entities.Asset{
		{Type: entities.AssetTypeBond, Quantity: 10, PurchasePrice: 100},
		{Type: entities.AssetTypeCash, Quantity: 1, PurchasePrice: 5000},
		{Type: entities.AssetTypeGold, Quantity: 2, PurchasePrice: 1000},
	}

	score := scorer.Calculate(assets)

	// Conservative portfolio should have high liquidity
	assert.Greater(t, score.Liquidity, 70)
}

func TestHealthScorer_Calculate_PositivePerformance(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Assets with gains
	currentPrice := 120.0 // 20% gain
	assets := []entities.Asset{
		{Type: entities.AssetTypeStock, Quantity: 10, PurchasePrice: 100, CurrentPrice: &currentPrice},
	}

	score := scorer.Calculate(assets)

	// Positive performance should have good performance score
	assert.Greater(t, score.Performance, 50)
}

func TestHealthScorer_Calculate_NegativePerformance(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Assets with losses
	currentPrice := 80.0 // 20% loss
	assets := []entities.Asset{
		{Type: entities.AssetTypeStock, Quantity: 10, PurchasePrice: 100, CurrentPrice: &currentPrice},
	}

	score := scorer.Calculate(assets)

	// Negative performance should have lower performance score
	assert.Less(t, score.Performance, 50)
}

func TestHealthScorer_GeneratesSuggestions(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Poorly diversified, high risk portfolio
	assets := []entities.Asset{
		{Type: entities.AssetTypeCrypto, Quantity: 100, PurchasePrice: 500},
	}

	score := scorer.Calculate(assets)

	// Should generate suggestions for improvement
	assert.Greater(t, len(score.Suggestions), 0)
}

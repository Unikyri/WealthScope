package services

import (
	"encoding/json"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// makeAsset creates a test asset with JSONB core_data for use in health scorer tests.
func makeAsset(assetType entities.AssetType, qty, price float64) entities.Asset {
	coreData, _ := json.Marshal(map[string]interface{}{
		"quantity":       qty,
		"purchase_price": price,
	})
	return *entities.NewAsset(
		[16]byte{}, // zero UUID for tests
		assetType,
		string(assetType),
		coreData,
		nil,
	)
}

// makeAssetWithCurrentPrice creates a test asset with current_price in extended_data.
func makeAssetWithCurrentPrice(assetType entities.AssetType, qty, purchasePrice, currentPrice float64) entities.Asset {
	coreData, _ := json.Marshal(map[string]interface{}{
		"quantity":       qty,
		"purchase_price": purchasePrice,
	})
	extData, _ := json.Marshal(map[string]interface{}{
		"current_price": currentPrice,
	})
	return *entities.NewAsset(
		[16]byte{},
		assetType,
		string(assetType),
		coreData,
		extData,
	)
}

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
		makeAsset(entities.AssetTypeStock, 10, 100),
		makeAsset(entities.AssetTypeBond, 5, 200),
		makeAsset(entities.AssetTypeETF, 8, 150),
		makeAsset(entities.AssetTypeCrypto, 2, 500),
		makeAsset(entities.AssetTypeCash, 3, 300),
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
		makeAsset(entities.AssetTypeStock, 100, 50),
		makeAsset(entities.AssetTypeStock, 200, 30),
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
		makeAsset(entities.AssetTypeCrypto, 10, 1000),
		makeAsset(entities.AssetTypeCrypto, 5, 2000),
	}

	score := scorer.Calculate(assets)

	// High-risk portfolio should have lower risk score
	assert.LessOrEqual(t, score.RiskLevel, 70)
}

func TestHealthScorer_Calculate_ConservativePortfolio(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// All bonds and cash = conservative
	assets := []entities.Asset{
		makeAsset(entities.AssetTypeBond, 10, 100),
		makeAsset(entities.AssetTypeCash, 1, 5000),
		makeAsset(entities.AssetTypeCustom, 2, 1000),
	}

	score := scorer.Calculate(assets)

	// Conservative portfolio should have high liquidity
	assert.Greater(t, score.Liquidity, 70)
}

func TestHealthScorer_Calculate_PositivePerformance(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Assets with gains (20% gain)
	assets := []entities.Asset{
		makeAssetWithCurrentPrice(entities.AssetTypeStock, 10, 100, 120),
	}

	score := scorer.Calculate(assets)

	// Positive performance should have good performance score
	assert.Greater(t, score.Performance, 50)
}

func TestHealthScorer_Calculate_NegativePerformance(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Assets with losses (20% loss)
	assets := []entities.Asset{
		makeAssetWithCurrentPrice(entities.AssetTypeStock, 10, 100, 80),
	}

	score := scorer.Calculate(assets)

	// Negative performance should have lower performance score
	assert.Less(t, score.Performance, 50)
}

func TestHealthScorer_GeneratesSuggestions(t *testing.T) {
	scorer := NewHealthScorer(zap.NewNop())

	// Poorly diversified, high risk portfolio
	assets := []entities.Asset{
		makeAsset(entities.AssetTypeCrypto, 100, 500),
	}

	score := scorer.Calculate(assets)

	// Should generate suggestions for improvement
	assert.Greater(t, len(score.Suggestions), 0)
}

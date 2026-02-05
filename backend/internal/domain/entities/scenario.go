package entities

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// ScenarioType defines the type of simulation
type ScenarioType string

const (
	ScenarioBuyAsset   ScenarioType = "buy_asset"
	ScenarioSellAsset  ScenarioType = "sell_asset"
	ScenarioMarketMove ScenarioType = "market_move"
	ScenarioNewAsset   ScenarioType = "new_asset"
	ScenarioRebalance  ScenarioType = "rebalance"
)

// ValidScenarioTypes contains all valid scenario types
var ValidScenarioTypes = []ScenarioType{
	ScenarioBuyAsset,
	ScenarioSellAsset,
	ScenarioMarketMove,
	ScenarioNewAsset,
	ScenarioRebalance,
}

// IsValid checks if the scenario type is valid
func (t ScenarioType) IsValid() bool {
	for _, valid := range ValidScenarioTypes {
		if t == valid {
			return true
		}
	}
	return false
}

// ScenarioRequest is the input for a simulation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ScenarioRequest struct {
	UserID     uuid.UUID      `json:"user_id"`
	Type       ScenarioType   `json:"type"`
	Parameters ScenarioParams `json:"parameters"`
}

// ScenarioParams contains type-specific parameters for simulation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ScenarioParams struct {
	// For buy/sell scenarios
	AssetID  *uuid.UUID `json:"asset_id,omitempty"`
	Quantity float64    `json:"quantity,omitempty"`
	Price    float64    `json:"price,omitempty"`

	// For market move scenarios
	ChangePercent float64  `json:"change_percent,omitempty"` // e.g., -20 for 20% drop
	AssetTypes    []string `json:"asset_types,omitempty"`    // Affected asset types (empty = all)

	// For new asset scenarios
	NewAsset *NewAssetParams `json:"new_asset,omitempty"`

	// For rebalance scenarios
	TargetAllocation map[string]float64 `json:"target_allocation,omitempty"` // type -> percentage
}

// NewAssetParams defines parameters for adding a new hypothetical asset
type NewAssetParams struct {
	Type          string  `json:"type"`
	Name          string  `json:"name"`
	Symbol        string  `json:"symbol,omitempty"`
	Quantity      float64 `json:"quantity"`
	PurchasePrice float64 `json:"purchase_price"`
}

// ScenarioResult is the output of a simulation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ScenarioResult struct {
	CurrentState   PortfolioState `json:"current_state"`
	ProjectedState PortfolioState `json:"projected_state"`
	Changes        []ChangeDetail `json:"changes"`
	AIAnalysis     string         `json:"ai_analysis,omitempty"`
	Warnings       []string       `json:"warnings,omitempty"`
}

// PortfolioState represents the state of a portfolio at a point in time
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PortfolioState struct {
	TotalValue      float64          `json:"total_value"`
	TotalInvested   float64          `json:"total_invested"`
	GainLoss        float64          `json:"gain_loss"`
	GainLossPercent float64          `json:"gain_loss_percent"`
	AssetCount      int              `json:"asset_count"`
	Allocation      []AllocationItem `json:"allocation"`
}

// AllocationItem represents an allocation by asset type
type AllocationItem struct {
	Type    string  `json:"type"`
	Value   float64 `json:"value"`
	Percent float64 `json:"percent"`
}

// ChangeDetail describes a single change in the simulation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ChangeDetail struct {
	Type        string  `json:"type"` // increase, decrease, new, removed
	Description string  `json:"description"`
	OldValue    float64 `json:"old_value,omitempty"`
	NewValue    float64 `json:"new_value,omitempty"`
	Difference  float64 `json:"difference"`
}

// Scenario represents a saved simulation in the database
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type Scenario struct {
	ID         uuid.UUID       `json:"id"`
	UserID     uuid.UUID       `json:"user_id"`
	Type       ScenarioType    `json:"type"`
	Query      json.RawMessage `json:"query"`
	Result     json.RawMessage `json:"result"`
	AIAnalysis *string         `json:"ai_analysis,omitempty"`
	CreatedAt  time.Time       `json:"created_at"`
}

// NewScenario creates a new Scenario entity
func NewScenario(userID uuid.UUID, scenarioType ScenarioType, query, result json.RawMessage, aiAnalysis *string) *Scenario {
	return &Scenario{
		ID:         uuid.New(),
		UserID:     userID,
		Type:       scenarioType,
		Query:      query,
		Result:     result,
		AIAnalysis: aiAnalysis,
		CreatedAt:  time.Now().UTC(),
	}
}

// ScenarioTemplate represents a predefined scenario template
type ScenarioTemplate struct {
	Parameters  ScenarioParams `json:"parameters"`
	ID          string         `json:"id"`
	Name        string         `json:"name"`
	Description string         `json:"description"`
	Type        ScenarioType   `json:"type"`
}

// GetPredefinedTemplates returns the list of predefined scenario templates
func GetPredefinedTemplates() []ScenarioTemplate {
	return []ScenarioTemplate{
		{
			ID:          "market_drop_10",
			Name:        "10% Market Correction",
			Description: "Simulates a 10% drop across all assets",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: -10},
		},
		{
			ID:          "market_drop_20",
			Name:        "20% Market Crash",
			Description: "Simulates a 20% drop across all assets (bear market)",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: -20},
		},
		{
			ID:          "market_drop_30",
			Name:        "30% Recession",
			Description: "Simulates a 30% drop typical of major recessions",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: -30},
		},
		{
			ID:          "market_rally_10",
			Name:        "10% Bull Rally",
			Description: "Simulates a 10% increase across all assets",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: 10},
		},
		{
			ID:          "tech_crash",
			Name:        "Tech Sector Crash",
			Description: "Simulates a 40% drop in tech stocks only",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: -40, AssetTypes: []string{"stock"}},
		},
		{
			ID:          "crypto_crash",
			Name:        "Crypto Winter",
			Description: "Simulates a 50% drop in cryptocurrency assets",
			Type:        ScenarioMarketMove,
			Parameters:  ScenarioParams{ChangePercent: -50, AssetTypes: []string{"crypto"}},
		},
		{
			ID:          "balanced_60_40",
			Name:        "60/40 Portfolio",
			Description: "Rebalance to classic 60% stocks, 40% bonds allocation",
			Type:        ScenarioRebalance,
			Parameters:  ScenarioParams{TargetAllocation: map[string]float64{"stock": 60, "bond": 40}},
		},
		{
			ID:          "conservative",
			Name:        "Conservative Allocation",
			Description: "Rebalance to 40% stocks, 40% bonds, 20% cash",
			Type:        ScenarioRebalance,
			Parameters:  ScenarioParams{TargetAllocation: map[string]float64{"stock": 40, "bond": 40, "cash": 20}},
		},
	}
}

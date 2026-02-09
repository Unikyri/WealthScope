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
type ScenarioRequest struct {
	Type       ScenarioType   `json:"type"`
	Parameters ScenarioParams `json:"parameters"`
	UserID     uuid.UUID      `json:"user_id"`
}

// ScenarioParams contains type-specific parameters for simulation
type ScenarioParams struct {
	TargetAllocation map[string]float64 `json:"target_allocation,omitempty"`
	AssetID          *uuid.UUID         `json:"asset_id,omitempty"`
	NewAsset         *NewAssetParams    `json:"new_asset,omitempty"`
	AssetTypes       []string           `json:"asset_types,omitempty"`
	Quantity         float64            `json:"quantity,omitempty"`
	Price            float64            `json:"price,omitempty"`
	ChangePercent    float64            `json:"change_percent,omitempty"`
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
type ScenarioResult struct {
	Changes        []ChangeDetail `json:"changes"`
	Warnings       []string       `json:"warnings,omitempty"`
	AIAnalysis     string         `json:"ai_analysis,omitempty"`
	CurrentState   PortfolioState `json:"current_state"`
	ProjectedState PortfolioState `json:"projected_state"`
}

// PortfolioState represents the state of a portfolio at a point in time
type PortfolioState struct {
	Allocation      []AllocationItem `json:"allocation"`
	TotalValue      float64          `json:"total_value"`
	TotalInvested   float64          `json:"total_invested"`
	GainLoss        float64          `json:"gain_loss"`
	GainLossPercent float64          `json:"gain_loss_percent"`
	AssetCount      int              `json:"asset_count"`
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
	CreatedAt  time.Time       `json:"created_at"`
	AIAnalysis *string         `json:"ai_analysis,omitempty"`
	Type       ScenarioType    `json:"type"`
	Query      json.RawMessage `json:"query"`
	Result     json.RawMessage `json:"result"`
	ID         uuid.UUID       `json:"id"`
	UserID     uuid.UUID       `json:"user_id"`
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
	ID          string         `json:"id"`
	Name        string         `json:"name"`
	Description string         `json:"description"`
	Type        ScenarioType   `json:"type"`
	Parameters  ScenarioParams `json:"parameters"`
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

// ScenarioChainRequest defines a sequence of scenario steps
//
//nolint:govet // fieldalignment: keep logical field grouping
type ScenarioChainRequest struct {
	Steps  []ScenarioStep `json:"steps"`
	UserID uuid.UUID      `json:"user_id"`
}

// ScenarioStep represents a single step in a scenario chain
//
//nolint:govet // fieldalignment: keep logical field grouping
type ScenarioStep struct {
	Type       ScenarioType   `json:"type"`
	Parameters ScenarioParams `json:"parameters"`
	Order      int            `json:"order"`
}

// ChainResult represents the result of a scenario chain simulation
//
//nolint:govet // fieldalignment: keep logical field grouping
type ChainResult struct {
	Steps       []StepResult    `json:"steps"`
	Risk        *RiskAssessment `json:"risk,omitempty"`
	FinalState  PortfolioState  `json:"final_state"`
	TotalImpact float64         `json:"total_impact"`
}

// StepResult represents the result of a single step
//
//nolint:govet // fieldalignment: keep logical field grouping
type StepResult struct {
	Result *ScenarioResult `json:"result"`
	Step   ScenarioStep    `json:"step"`
}

// RiskAssessment represents the calculated risk of the final portfolio state
//
//nolint:govet // fieldalignment: keep logical field grouping
type RiskAssessment struct {
	Level          string   `json:"level"`
	Recommendation string   `json:"recommendation"`
	Factors        []string `json:"factors"`
	Warnings       []string `json:"warnings"`
	Score          int      `json:"score"`
}

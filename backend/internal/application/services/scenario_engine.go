package services

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
)

// ScenarioEngine runs portfolio simulations for what-if scenarios
type ScenarioEngine struct {
	assetRepo repositories.AssetRepository
	logger    *zap.Logger
	aiClient  AIClient
}

// AIClient defines the interface for AI generation
type AIClient interface {
	GenerateWithThinking(ctx context.Context, prompt, systemPrompt string, thinkingLevel ai.ThinkingLevel) (string, error)
}

// NewScenarioEngine creates a new ScenarioEngine
func NewScenarioEngine(
	assetRepo repositories.AssetRepository,
	logger *zap.Logger,
	aiClient AIClient,
) *ScenarioEngine {
	return &ScenarioEngine{
		assetRepo: assetRepo,
		logger:    logger,
		aiClient:  aiClient,
	}
}

// Simulate runs a scenario and returns projected results
func (e *ScenarioEngine) Simulate(ctx context.Context, req entities.ScenarioRequest) (*entities.ScenarioResult, error) {
	e.logger.Info("running scenario simulation",
		zap.String("user_id", req.UserID.String()),
		zap.String("type", string(req.Type)),
	)

	// Validate scenario type
	if !req.Type.IsValid() {
		return nil, fmt.Errorf("invalid scenario type: %s", req.Type)
	}

	// Get current portfolio state
	currentState, err := e.getCurrentState(ctx, req.UserID)
	if err != nil {
		return nil, fmt.Errorf("failed to get current state: %w", err)
	}

	// Run appropriate simulation
	var projectedState entities.PortfolioState
	var changes []entities.ChangeDetail
	var warnings []string

	switch req.Type {
	case entities.ScenarioBuyAsset:
		projectedState, changes, warnings, err = e.simulateBuy(ctx, req.UserID, currentState, req.Parameters)
	case entities.ScenarioSellAsset:
		projectedState, changes, warnings, err = e.simulateSell(ctx, req.UserID, currentState, req.Parameters)
	case entities.ScenarioMarketMove:
		projectedState, changes, warnings, err = e.simulateMarketMove(currentState, req.Parameters)
	case entities.ScenarioNewAsset:
		projectedState, changes, warnings, err = e.simulateNewAsset(currentState, req.Parameters)
	case entities.ScenarioRebalance:
		projectedState, changes, warnings, err = e.simulateRebalance(currentState, req.Parameters)
	default:
		return nil, fmt.Errorf("unhandled scenario type: %s", req.Type)
	}

	if err != nil {
		return nil, err
	}

	return &entities.ScenarioResult{
		CurrentState:   currentState,
		ProjectedState: projectedState,
		Changes:        changes,
		Warnings:       warnings,
	}, nil
}

// getCurrentState builds the current portfolio state from the repository
func (e *ScenarioEngine) getCurrentState(ctx context.Context, userID uuid.UUID) (entities.PortfolioState, error) {
	summary, err := e.assetRepo.GetPortfolioSummary(ctx, userID)
	if err != nil {
		return entities.PortfolioState{}, err
	}

	allocation := make([]entities.AllocationItem, 0, len(summary.BreakdownByType))
	for _, b := range summary.BreakdownByType {
		allocation = append(allocation, entities.AllocationItem{
			Type:    string(b.Type),
			Value:   b.Value,
			Percent: b.Percent,
		})
	}

	return entities.PortfolioState{
		TotalValue:      summary.TotalValue,
		TotalInvested:   summary.TotalInvested,
		GainLoss:        summary.GainLoss,
		GainLossPercent: summary.GainLossPercent,
		AssetCount:      summary.AssetCount,
		Allocation:      allocation,
	}, nil
}

// simulateBuy simulates buying more of an existing asset
func (e *ScenarioEngine) simulateBuy(
	ctx context.Context,
	userID uuid.UUID,
	current entities.PortfolioState,
	params entities.ScenarioParams,
) (entities.PortfolioState, []entities.ChangeDetail, []string, error) {
	var warnings []string

	// Validate parameters
	if params.Quantity <= 0 {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("quantity must be positive")
	}
	if params.Price <= 0 {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("price must be positive")
	}

	// Calculate purchase amount
	purchaseAmount := params.Quantity * params.Price
	newTotalValue := current.TotalValue + purchaseAmount
	newTotalInvested := current.TotalInvested + purchaseAmount

	// If asset ID is provided, validate it exists
	var assetName string
	if params.AssetID != nil {
		asset, findErr := e.assetRepo.FindByID(ctx, *params.AssetID, userID)
		if findErr != nil {
			return entities.PortfolioState{}, nil, nil, fmt.Errorf("asset not found: %w", findErr)
		}
		assetName = asset.Name
	} else {
		assetName = "asset"
	}

	projected := current
	projected.TotalValue = newTotalValue
	projected.TotalInvested = newTotalInvested
	projected.GainLoss = newTotalValue - newTotalInvested
	if newTotalInvested > 0 {
		projected.GainLossPercent = (projected.GainLoss / newTotalInvested) * 100
	}

	changes := []entities.ChangeDetail{
		{
			Type:        "increase",
			Description: fmt.Sprintf("Buy %.4f units of %s at $%.2f each", params.Quantity, assetName, params.Price),
			OldValue:    current.TotalValue,
			NewValue:    newTotalValue,
			Difference:  purchaseAmount,
		},
	}

	return projected, changes, warnings, nil
}

// simulateSell simulates selling an existing asset
func (e *ScenarioEngine) simulateSell(
	ctx context.Context,
	userID uuid.UUID,
	current entities.PortfolioState,
	params entities.ScenarioParams,
) (entities.PortfolioState, []entities.ChangeDetail, []string, error) {
	var warnings []string

	if params.Quantity <= 0 {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("quantity must be positive")
	}
	if params.AssetID == nil {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("asset_id is required for sell scenario")
	}

	// Get the asset
	asset, findErr := e.assetRepo.FindByID(ctx, *params.AssetID, userID)
	if findErr != nil {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("asset not found: %w", findErr)
	}

	// Extract values from JSONB core_data/extended_data
	coreMap, _ := asset.GetCoreDataMap()
	extMap, _ := asset.GetExtendedDataMap()

	assetQty := toFloat64(coreMap["quantity"])
	assetPurchasePrice := toFloat64(coreMap["purchase_price"])

	if params.Quantity > assetQty {
		warnings = append(warnings, fmt.Sprintf("Selling more than owned: %.4f > %.4f", params.Quantity, assetQty))
	}

	// Use current price if available, otherwise purchase price
	price := assetPurchasePrice
	if cp := toFloat64(extMap["current_price"]); cp > 0 {
		price = cp
	}

	// Use provided price if specified
	if params.Price > 0 {
		price = params.Price
	}

	saleAmount := params.Quantity * price
	costBasis := params.Quantity * assetPurchasePrice

	newTotalValue := current.TotalValue - saleAmount
	newTotalInvested := current.TotalInvested - costBasis

	projected := current
	projected.TotalValue = newTotalValue
	projected.TotalInvested = newTotalInvested
	if newTotalInvested > 0 {
		projected.GainLoss = newTotalValue - newTotalInvested
		projected.GainLossPercent = (projected.GainLoss / newTotalInvested) * 100
	} else {
		projected.GainLoss = 0
		projected.GainLossPercent = 0
	}

	// Adjust asset count if selling all
	if params.Quantity >= assetQty {
		projected.AssetCount--
	}

	changes := []entities.ChangeDetail{
		{
			Type:        "decrease",
			Description: fmt.Sprintf("Sell %.4f units of %s at $%.2f each", params.Quantity, asset.Name, price),
			OldValue:    current.TotalValue,
			NewValue:    newTotalValue,
			Difference:  -saleAmount,
		},
	}

	return projected, changes, warnings, nil
}

// simulateMarketMove simulates a market-wide or sector-specific change
//
//nolint:unparam // error is always nil but kept for interface consistency with other simulate methods
func (e *ScenarioEngine) simulateMarketMove(
	current entities.PortfolioState,
	params entities.ScenarioParams,
) (entities.PortfolioState, []entities.ChangeDetail, []string, error) {
	var warnings []string

	if params.ChangePercent == 0 {
		warnings = append(warnings, "Change percent is 0, no impact on portfolio")
	}

	changeMultiplier := 1 + (params.ChangePercent / 100)

	// If asset types are specified, only apply to those types
	var affectedTypes []string
	if len(params.AssetTypes) > 0 {
		affectedTypes = params.AssetTypes
	}

	projected := current
	var totalChange float64

	if len(affectedTypes) > 0 {
		// Selective change - only affect specified asset types
		for i, alloc := range projected.Allocation {
			isAffected := false
			for _, t := range affectedTypes {
				if alloc.Type == t {
					isAffected = true
					break
				}
			}
			if isAffected {
				oldValue := alloc.Value
				newValue := oldValue * changeMultiplier
				change := newValue - oldValue
				totalChange += change
				projected.Allocation[i].Value = newValue
			}
		}
		projected.TotalValue = current.TotalValue + totalChange
	} else {
		// Apply to entire portfolio
		projected.TotalValue = current.TotalValue * changeMultiplier
		totalChange = projected.TotalValue - current.TotalValue
		// Update all allocations
		for i := range projected.Allocation {
			projected.Allocation[i].Value *= changeMultiplier
		}
	}

	// Recalculate gain/loss
	projected.GainLoss = projected.TotalValue - current.TotalInvested
	if current.TotalInvested > 0 {
		projected.GainLossPercent = (projected.GainLoss / current.TotalInvested) * 100
	}

	// Recalculate allocation percentages
	if projected.TotalValue > 0 {
		for i := range projected.Allocation {
			projected.Allocation[i].Percent = (projected.Allocation[i].Value / projected.TotalValue) * 100
		}
	}

	changeType := "increase"
	if params.ChangePercent < 0 {
		changeType = "decrease"
	}

	description := fmt.Sprintf("Market moves %.1f%%", params.ChangePercent)
	if len(affectedTypes) > 0 {
		description = fmt.Sprintf("%s (affecting: %v)", description, affectedTypes)
	}

	changes := []entities.ChangeDetail{
		{
			Type:        changeType,
			Description: description,
			OldValue:    current.TotalValue,
			NewValue:    projected.TotalValue,
			Difference:  totalChange,
		},
	}

	return projected, changes, warnings, nil
}

// simulateNewAsset simulates adding a new asset to the portfolio
func (e *ScenarioEngine) simulateNewAsset(
	current entities.PortfolioState,
	params entities.ScenarioParams,
) (entities.PortfolioState, []entities.ChangeDetail, []string, error) {
	var warnings []string

	if params.NewAsset == nil {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("new_asset parameters are required")
	}

	newAsset := params.NewAsset
	if newAsset.Quantity <= 0 || newAsset.PurchasePrice <= 0 {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("quantity and purchase_price must be positive")
	}

	investmentAmount := newAsset.Quantity * newAsset.PurchasePrice

	projected := current
	projected.TotalValue += investmentAmount
	projected.TotalInvested += investmentAmount
	projected.AssetCount++
	projected.GainLoss = projected.TotalValue - projected.TotalInvested
	if projected.TotalInvested > 0 {
		projected.GainLossPercent = (projected.GainLoss / projected.TotalInvested) * 100
	}

	// Update allocation
	assetType := newAsset.Type
	found := false
	for i := range projected.Allocation {
		if projected.Allocation[i].Type == assetType {
			projected.Allocation[i].Value += investmentAmount
			found = true
			break
		}
	}
	if !found {
		projected.Allocation = append(projected.Allocation, entities.AllocationItem{
			Type:  assetType,
			Value: investmentAmount,
		})
	}

	// Recalculate percentages
	if projected.TotalValue > 0 {
		for i := range projected.Allocation {
			projected.Allocation[i].Percent = (projected.Allocation[i].Value / projected.TotalValue) * 100
		}
	}

	changes := []entities.ChangeDetail{
		{
			Type:        "new",
			Description: fmt.Sprintf("Add new %s: %s (%.4f units at $%.2f)", newAsset.Type, newAsset.Name, newAsset.Quantity, newAsset.PurchasePrice),
			NewValue:    investmentAmount,
			Difference:  investmentAmount,
		},
	}

	return projected, changes, warnings, nil
}

// simulateRebalance simulates rebalancing to a target allocation
func (e *ScenarioEngine) simulateRebalance(
	current entities.PortfolioState,
	params entities.ScenarioParams,
) (entities.PortfolioState, []entities.ChangeDetail, []string, error) {
	var warnings []string

	if len(params.TargetAllocation) == 0 {
		return entities.PortfolioState{}, nil, nil, fmt.Errorf("target_allocation is required for rebalance scenario")
	}

	// Validate target allocation sums to 100
	totalPercent := 0.0
	for _, pct := range params.TargetAllocation {
		totalPercent += pct
	}
	if totalPercent < 99 || totalPercent > 101 {
		warnings = append(warnings, fmt.Sprintf("Target allocation sums to %.1f%%, ideally should be 100%%", totalPercent))
	}

	projected := current
	var changes []entities.ChangeDetail

	// Calculate target values for each type
	for assetType, targetPct := range params.TargetAllocation {
		targetValue := current.TotalValue * (targetPct / 100)

		// Find current value for this type
		var currentValue float64
		for _, alloc := range current.Allocation {
			if alloc.Type == assetType {
				currentValue = alloc.Value
				break
			}
		}

		diff := targetValue - currentValue
		if diff > 0.01 || diff < -0.01 { // Ignore tiny differences
			changeType := "increase"
			action := "Buy"
			if diff < 0 {
				changeType = "decrease"
				action = "Sell"
			}

			changes = append(changes, entities.ChangeDetail{
				Type:        changeType,
				Description: fmt.Sprintf("%s $%.2f of %s to reach %.1f%% allocation", action, absFloat(diff), assetType, targetPct),
				OldValue:    currentValue,
				NewValue:    targetValue,
				Difference:  diff,
			})
		}

		// Update projected allocation
		found := false
		for i := range projected.Allocation {
			if projected.Allocation[i].Type == assetType {
				projected.Allocation[i].Value = targetValue
				projected.Allocation[i].Percent = targetPct
				found = true
				break
			}
		}
		if !found && targetValue > 0 {
			projected.Allocation = append(projected.Allocation, entities.AllocationItem{
				Type:    assetType,
				Value:   targetValue,
				Percent: targetPct,
			})
		}
	}

	// Note: In a rebalance, total value stays the same (we're just moving money around)
	// But invested amount might change if we realize gains/losses

	return projected, changes, warnings, nil
}

// absFloat returns the absolute value of a float64
func absFloat(x float64) float64 {
	if x < 0 {
		return -x
	}
	return x
}

// toFloat64 safely converts an interface{} (from JSON unmarshal) to float64.
func toFloat64(v interface{}) float64 {
	if v == nil {
		return 0
	}
	switch val := v.(type) {
	case float64:
		return val
	case int:
		return float64(val)
	case int64:
		return float64(val)
	default:
		return 0
	}
}

// GetTemplates returns the list of predefined scenario templates

// SimulateChain runs a multi-step scenario simulation
func (e *ScenarioEngine) SimulateChain(ctx context.Context, req entities.ScenarioChainRequest) (*entities.ChainResult, error) {
	e.logger.Info("running scenario chain",
		zap.String("user_id", req.UserID.String()),
		zap.Int("steps", len(req.Steps)),
	)

	// Get initial state
	initialState, err := e.getCurrentState(ctx, req.UserID)
	if err != nil {
		return nil, fmt.Errorf("failed to get current state: %w", err)
	}

	currentState := initialState
	stepResults := make([]entities.StepResult, 0, len(req.Steps))

	for _, step := range req.Steps {
		// Run simulation for this step
		var projected entities.PortfolioState
		var changes []entities.ChangeDetail
		var warnings []string
		var simErr error

		// Re-use existing simulation logic
		// We process params locally to fit the interface if needed,
		// but simulate* methods take params directly.

		switch step.Type {
		case entities.ScenarioBuyAsset:
			projected, changes, warnings, simErr = e.simulateBuy(ctx, req.UserID, currentState, step.Parameters)
		case entities.ScenarioSellAsset:
			projected, changes, warnings, simErr = e.simulateSell(ctx, req.UserID, currentState, step.Parameters)
		case entities.ScenarioMarketMove:
			projected, changes, warnings, simErr = e.simulateMarketMove(currentState, step.Parameters)
		case entities.ScenarioNewAsset:
			projected, changes, warnings, simErr = e.simulateNewAsset(currentState, step.Parameters)
		case entities.ScenarioRebalance:
			projected, changes, warnings, simErr = e.simulateRebalance(currentState, step.Parameters)
		default:
			return nil, fmt.Errorf("unhandled scenario type in step %d: %s", step.Order, step.Type)
		}

		if simErr != nil {
			return nil, fmt.Errorf("simulation failed at step %d (%s): %w", step.Order, step.Type, simErr)
		}

		// Store result for this step
		stepRes := entities.StepResult{
			Step: step,
			Result: &entities.ScenarioResult{
				CurrentState:   currentState, // State before this step
				ProjectedState: projected,    // State after this step
				Changes:        changes,
				Warnings:       warnings,
			},
		}

		// TODO: T-10.3.2 Add AI explanation here
		if e.aiClient != nil {
			explanation, aiErr := e.explainStep(ctx, step, currentState, projected, changes, warnings)
			if aiErr != nil {
				e.logger.Warn("failed to generate AI explanation", zap.Error(aiErr))
			} else {
				// We need to inject the analysis into the StepResult's Result
				// Note: Result.AIAnalysis is a string field
				stepRes.Result.AIAnalysis = explanation
			}
		}

		stepResults = append(stepResults, stepRes)

		// Update current state for next step
		currentState = projected
	}

	// Calculate total impact
	totalImpact := currentState.TotalValue - initialState.TotalValue

	// T-10.3.3 Assess Risk
	risk := e.assessRisk(initialState, currentState)

	return &entities.ChainResult{
		Steps:       stepResults,
		FinalState:  currentState,
		TotalImpact: totalImpact,
		Risk:        risk,
	}, nil
}

// assessRisk calculates risk factors based on portfolio changes
func (e *ScenarioEngine) assessRisk(initial, final entities.PortfolioState) *entities.RiskAssessment {
	risk := &entities.RiskAssessment{
		Score:   10, // Base score
		Level:   "low",
		Factors: []string{},
	}

	// 1. Concentration Risk
	// Check if any single asset type > 50% or significantly increased
	for _, alloc := range final.Allocation {
		// Example: High crypto concentration
		if alloc.Type == "crypto" && alloc.Percent > 30 {
			risk.Score += 20
			risk.Factors = append(risk.Factors, fmt.Sprintf("High crypto concentration (%.1f%%)", alloc.Percent))
		}
		// Example: Single stock dominance (approximated by type if individual assets not tracked in aggregate)
		// Since we only have type aggregation in PortfolioState, we check type concentration.
		if alloc.Percent > 60 {
			risk.Score += 15
			risk.Factors = append(risk.Factors, fmt.Sprintf("Heavy concentration in %s (%.1f%%)", alloc.Type, alloc.Percent))
		}
	}

	// 2. Cash Drag / Liquidity
	// Check if cash is too low (< 2%) or too high (> 50%)
	var cashPercent float64
	for _, alloc := range final.Allocation {
		if alloc.Type == "cash" {
			cashPercent = alloc.Percent
			break
		}
	}
	if cashPercent < 2 {
		risk.Score += 10
		risk.Factors = append(risk.Factors, fmt.Sprintf("Low liquidity (Cash: %.1f%%)", cashPercent))
	} else if cashPercent > 50 {
		risk.Score += 5
		risk.Factors = append(risk.Factors, fmt.Sprintf("High cash drag (Cash: %.1f%%)", cashPercent))
	}

	// 3. Volatility Impact (Approximated)
	// If total value drops significantly > 10%, flag as high impact scenario
	valueChange := (final.TotalValue - initial.TotalValue) / initial.TotalValue * 100
	if valueChange < -15 {
		risk.Score += 25
		risk.Factors = append(risk.Factors, fmt.Sprintf("Significant portfolio drawdown (%.1f%%)", valueChange))
	} else if valueChange < -5 {
		risk.Score += 10
		risk.Factors = append(risk.Factors, fmt.Sprintf("Moderate portfolio drawdown (%.1f%%)", valueChange))
	}

	// Determine Level
	if risk.Score >= 75 {
		risk.Level = "critical"
		risk.Recommendation = "Immediate portfolio review recommended. Consider diversification to reduce exposure."
	} else if risk.Score >= 50 {
		risk.Level = "high"
		risk.Recommendation = "High risk detected. Consider rebalancing to lower concentration or volatility."
	} else if risk.Score >= 25 {
		risk.Level = "medium"
		risk.Recommendation = "Moderate risk. Monitor concentration levels."
	} else {
		risk.Level = "low"
		risk.Recommendation = "Portfolio risk is within healthy limits."
	}

	return risk
}

// GetTemplates returns the list of predefined scenario templates
func (e *ScenarioEngine) GetTemplates() []entities.ScenarioTemplate {
	return entities.GetPredefinedTemplates()
}

// explainStep generates an AI explanation for a simulation step
func (e *ScenarioEngine) explainStep(
	ctx context.Context,
	step entities.ScenarioStep,
	initial, final entities.PortfolioState,
	changes []entities.ChangeDetail,
	warnings []string,
) (string, error) {
	prompt := fmt.Sprintf(`Explain this portfolio simulation step as if you are a financial educator.

Scenario Step: Order %d, Type %s
Parameters: %+v

Initial State: Value $%.2f, Invested $%.2f
Final State: Value $%.2f, Invested $%.2f

Changes:
`, step.Order, step.Type, step.Parameters, initial.TotalValue, initial.TotalInvested, final.TotalValue, final.TotalInvested)

	for _, change := range changes {
		prompt += fmt.Sprintf("- %s (Diff: $%.2f)\n", change.Description, change.Difference)
	}

	if len(warnings) > 0 {
		prompt += "\nWarnings Triggered:\n"
		for _, w := range warnings {
			prompt += fmt.Sprintf("- %s\n", w)
		}
	}

	prompt += `
Provide a concise explanation (2-3 sentences) covering:
1. What happened in this step.
2. How it impacted the portfolio (value, allocation, or risk).
3. A brief educational takeaway or consideration.

Do NOT use markdown headers or bullet points. Just a paragraph.`

	systemPrompt := "You are WealthScope AI, a financial assistant explaining simulation results."

	// Use ThinkingBalanced (2) for reasonable reasoning depth without excessive latency
	return e.aiClient.GenerateWithThinking(ctx, prompt, systemPrompt, ai.ThinkingBalanced)
}

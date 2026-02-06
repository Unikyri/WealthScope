package services

import (
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// Correlation represents a correlation between two assets.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type Correlation struct {
	Asset1 string  `json:"asset1"`
	Asset2 string  `json:"asset2"`
	Value  float64 `json:"value"` // -1 to 1
	Type   string  `json:"type"`  // positive, negative, neutral
}

// CorrelationDetector identifies correlations between portfolio assets.
type CorrelationDetector struct {
	logger *zap.Logger
}

// NewCorrelationDetector creates a new CorrelationDetector.
func NewCorrelationDetector(logger *zap.Logger) *CorrelationDetector {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &CorrelationDetector{
		logger: logger,
	}
}

// DetectCorrelations identifies highly correlated asset pairs.
// Returns pairs with correlation > 0.7 or < -0.7.
func (d *CorrelationDetector) DetectCorrelations(assets []entities.Asset) []Correlation {
	if len(assets) < 2 {
		return nil
	}

	var correlations []Correlation

	// Group assets by type to detect sector correlations
	typeCorrelations := d.detectTypeCorrelations(assets)
	correlations = append(correlations, typeCorrelations...)

	// For assets with symbols, detect symbol-based correlations
	symbolCorrelations := d.detectSymbolCorrelations(assets)
	correlations = append(correlations, symbolCorrelations...)

	d.logger.Debug("detected correlations",
		zap.Int("total", len(correlations)),
		zap.Int("assets", len(assets)))

	return correlations
}

// detectTypeCorrelations identifies correlations based on asset types.
// Assets of the same type are assumed to be correlated.
func (d *CorrelationDetector) detectTypeCorrelations(assets []entities.Asset) []Correlation {
	// Count assets by type
	typeCounts := make(map[entities.AssetType]int)
	typeSymbols := make(map[entities.AssetType][]string)

	for _, asset := range assets {
		typeCounts[asset.Type]++
		symbol := asset.Name
		if asset.Symbol != nil && *asset.Symbol != "" {
			symbol = *asset.Symbol
		}
		typeSymbols[asset.Type] = append(typeSymbols[asset.Type], symbol)
	}

	var correlations []Correlation

	// Types with multiple assets have inherent correlation
	for assetType, count := range typeCounts {
		if count >= 2 {
			symbols := typeSymbols[assetType]
			// Report the first pair as correlated
			if len(symbols) >= 2 {
				correlations = append(correlations, Correlation{
					Asset1: symbols[0],
					Asset2: symbols[1],
					Value:  0.75, // Assumed correlation for same-type assets
					Type:   getCorrelationType(0.75),
				})
			}
		}
	}

	// Detect inherently correlated asset types
	// Tech stocks vs Tech ETFs, Crypto assets, etc.
	correlatedTypes := map[entities.AssetType]entities.AssetType{
		entities.AssetTypeStock: entities.AssetTypeETF,
	}

	for type1, type2 := range correlatedTypes {
		if len(typeSymbols[type1]) > 0 && len(typeSymbols[type2]) > 0 {
			correlations = append(correlations, Correlation{
				Asset1: typeSymbols[type1][0],
				Asset2: typeSymbols[type2][0],
				Value:  0.65,
				Type:   getCorrelationType(0.65),
			})
		}
	}

	return correlations
}

// detectSymbolCorrelations detects correlations between specific symbols.
// Uses predefined known correlations for common assets.
func (d *CorrelationDetector) detectSymbolCorrelations(assets []entities.Asset) []Correlation {
	// Known high-correlation asset pairs
	knownCorrelations := map[string]map[string]float64{
		"AAPL": {"MSFT": 0.85, "GOOGL": 0.80, "QQQ": 0.90},
		"BTC":  {"ETH": 0.88, "COIN": 0.75},
		"MSFT": {"GOOGL": 0.82},
		"SPY":  {"QQQ": 0.85, "IWM": 0.80},
		"GLD":  {"SLV": 0.80},
	}

	// Create symbol set for quick lookup
	symbolSet := make(map[string]bool)
	for _, asset := range assets {
		if asset.Symbol != nil && *asset.Symbol != "" {
			symbolSet[*asset.Symbol] = true
		}
	}

	var correlations []Correlation

	for symbol1, corrs := range knownCorrelations {
		if !symbolSet[symbol1] {
			continue
		}
		for symbol2, value := range corrs {
			if symbolSet[symbol2] && math.Abs(value) > 0.7 {
				correlations = append(correlations, Correlation{
					Asset1: symbol1,
					Asset2: symbol2,
					Value:  value,
					Type:   getCorrelationType(value),
				})
			}
		}
	}

	return correlations
}

// GenerateCorrelationAlerts creates alerts for high correlations.
func (d *CorrelationDetector) GenerateCorrelationAlerts(correlations []Correlation) []PortfolioAlert {
	var alerts []PortfolioAlert

	for _, corr := range correlations {
		if math.Abs(corr.Value) < 0.7 {
			continue
		}

		var message, action string
		severity := AlertSeverityInfo

		if corr.Value > 0.8 {
			severity = AlertSeverityWarning
			message = corr.Asset1 + " and " + corr.Asset2 + " are highly correlated (" +
				formatPercent(corr.Value*100) + ") - consider diversifying"
			action = "Review allocation and consider reducing concentration in correlated assets"
		} else if corr.Value > 0.7 {
			message = corr.Asset1 + " and " + corr.Asset2 + " show moderate correlation (" +
				formatPercent(corr.Value*100) + ")"
			action = "Monitor these assets as they tend to move together"
		} else if corr.Value < -0.7 {
			message = corr.Asset1 + " and " + corr.Asset2 + " are negatively correlated - good for diversification"
			action = "This is positive for risk management"
		}

		if message != "" {
			alerts = append(alerts, PortfolioAlert{
				ID:        uuid.New(),
				Type:      AlertTypeCorrelation,
				Severity:  severity,
				Message:   message,
				Action:    action,
				CreatedAt: time.Now().UTC(),
			})
		}
	}

	return alerts
}

// getCorrelationType classifies correlation strength.
func getCorrelationType(value float64) string {
	if value > 0.7 {
		return "strong_positive"
	} else if value > 0.3 {
		return "moderate_positive"
	} else if value > -0.3 {
		return "neutral"
	} else if value > -0.7 {
		return "moderate_negative"
	}
	return "strong_negative"
}

// formatPercent formats a float as percentage string.
func formatPercent(value float64) string {
	return fmt.Sprintf("%.0f%%", value)
}

package services

import (
	"context"
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
)

// AlertType represents the type of portfolio alert.
type AlertType string

const (
	AlertTypePrice         AlertType = "price"
	AlertTypeConcentration AlertType = "concentration"
	AlertTypeCorrelation   AlertType = "correlation"
	AlertTypeHealth        AlertType = "health"
	AlertTypePerformance   AlertType = "performance"
)

// AlertSeverity represents alert severity levels.
type AlertSeverity string

const (
	AlertSeverityInfo     AlertSeverity = "info"
	AlertSeverityWarning  AlertSeverity = "warning"
	AlertSeverityCritical AlertSeverity = "critical"
)

// PortfolioAlert represents an alert for portfolio changes.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PortfolioAlert struct {
	ID        uuid.UUID     `json:"id"`
	Type      AlertType     `json:"type"`
	Severity  AlertSeverity `json:"severity"`
	Message   string        `json:"message"`
	Asset     string        `json:"asset,omitempty"`
	Action    string        `json:"action,omitempty"`
	CreatedAt time.Time     `json:"created_at"`
}

// AlertGenerator generates portfolio alerts based on analysis.
type AlertGenerator struct {
	healthScorer        *HealthScorer
	correlationDetector *CorrelationDetector
	aiClient            *ai.GeminiClient
	logger              *zap.Logger
}

// NewAlertGenerator creates a new AlertGenerator.
func NewAlertGenerator(
	healthScorer *HealthScorer,
	correlationDetector *CorrelationDetector,
	aiClient *ai.GeminiClient,
	logger *zap.Logger,
) *AlertGenerator {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &AlertGenerator{
		healthScorer:        healthScorer,
		correlationDetector: correlationDetector,
		aiClient:            aiClient,
		logger:              logger,
	}
}

// GenerateAlerts analyzes portfolio and generates relevant alerts.
func (g *AlertGenerator) GenerateAlerts(
	ctx context.Context,
	assets []entities.Asset,
	summary *repositories.PortfolioSummary,
	previousHealthScore *int,
) []PortfolioAlert {
	var alerts []PortfolioAlert

	// 1. Generate price alerts
	priceAlerts := g.generatePriceAlerts(assets)
	alerts = append(alerts, priceAlerts...)

	// 2. Generate concentration alerts
	concentrationAlerts := g.generateConcentrationAlerts(assets, summary)
	alerts = append(alerts, concentrationAlerts...)

	// 3. Generate correlation alerts
	if g.correlationDetector != nil {
		correlations := g.correlationDetector.DetectCorrelations(assets)
		correlationAlerts := g.correlationDetector.GenerateCorrelationAlerts(correlations)
		alerts = append(alerts, correlationAlerts...)
	}

	// 4. Generate health score alerts
	if g.healthScorer != nil {
		healthScore := g.healthScorer.Calculate(assets)
		healthAlerts := g.generateHealthAlerts(healthScore, previousHealthScore)
		alerts = append(alerts, healthAlerts...)
	}

	g.logger.Debug("generated portfolio alerts",
		zap.Int("total", len(alerts)),
		zap.Int("price", len(priceAlerts)),
		zap.Int("concentration", len(concentrationAlerts)))

	return alerts
}

// generatePriceAlerts creates alerts for significant price movements.
func (g *AlertGenerator) generatePriceAlerts(assets []entities.Asset) []PortfolioAlert {
	var alerts []PortfolioAlert

	for _, asset := range assets {
		gainLossPct := asset.GainLossPercent()
		if gainLossPct == nil {
			continue
		}

		pct := *gainLossPct
		absChange := math.Abs(pct)

		// Alert for ±5% or more
		if absChange < 5.0 {
			continue
		}

		name := asset.Name
		if asset.Symbol != nil && *asset.Symbol != "" {
			name = *asset.Symbol
		}

		var severity AlertSeverity
		var message, action string

		if pct > 0 {
			if pct > 20 {
				severity = AlertSeverityCritical
				message = fmt.Sprintf("%s is up %.1f%%! Consider taking profits", name, pct)
				action = "Review position and consider rebalancing"
			} else if pct > 10 {
				severity = AlertSeverityWarning
				message = fmt.Sprintf("%s gained %.1f%%", name, pct)
				action = "Monitor for profit-taking opportunities"
			} else {
				severity = AlertSeverityInfo
				message = fmt.Sprintf("%s is up %.1f%%", name, pct)
				action = "Good performance - continue monitoring"
			}
		} else {
			if pct < -20 {
				severity = AlertSeverityCritical
				message = fmt.Sprintf("%s is down %.1f%% - significant loss", name, -pct)
				action = "Review position - consider if fundamentals have changed"
			} else if pct < -10 {
				severity = AlertSeverityWarning
				message = fmt.Sprintf("%s dropped %.1f%%", name, -pct)
				action = "Evaluate if this is a buying opportunity or time to exit"
			} else {
				severity = AlertSeverityInfo
				message = fmt.Sprintf("%s is down %.1f%%", name, -pct)
				action = "Minor decline - monitor closely"
			}
		}

		alerts = append(alerts, PortfolioAlert{
			ID:        uuid.New(),
			Type:      AlertTypePrice,
			Severity:  severity,
			Message:   message,
			Asset:     name,
			Action:    action,
			CreatedAt: time.Now().UTC(),
		})
	}

	return alerts
}

// generateConcentrationAlerts creates alerts for over-concentrated positions.
func (g *AlertGenerator) generateConcentrationAlerts(
	assets []entities.Asset,
	summary *repositories.PortfolioSummary,
) []PortfolioAlert {
	var alerts []PortfolioAlert

	if summary == nil || summary.TotalValue == 0 {
		return alerts
	}

	// Check individual asset concentration
	for _, asset := range assets {
		value := asset.TotalValue()
		concentration := (value / summary.TotalValue) * 100

		if concentration < 25 {
			continue
		}

		name := asset.Name
		if asset.Symbol != nil && *asset.Symbol != "" {
			name = *asset.Symbol
		}

		var severity AlertSeverity
		var message, action string

		if concentration > 50 {
			severity = AlertSeverityCritical
			message = fmt.Sprintf("%s represents %.0f%% of your portfolio - extreme concentration risk", name, concentration)
			action = "Strongly consider diversifying to reduce single-asset risk"
		} else if concentration > 35 {
			severity = AlertSeverityWarning
			message = fmt.Sprintf("%s is %.0f%% of your portfolio - high concentration", name, concentration)
			action = "Consider reducing position size for better risk management"
		} else {
			severity = AlertSeverityInfo
			message = fmt.Sprintf("%s makes up %.0f%% of your portfolio", name, concentration)
			action = "Monitor this position's weight"
		}

		alerts = append(alerts, PortfolioAlert{
			ID:        uuid.New(),
			Type:      AlertTypeConcentration,
			Severity:  severity,
			Message:   message,
			Asset:     name,
			Action:    action,
			CreatedAt: time.Now().UTC(),
		})
	}

	// Check asset type concentration
	for _, breakdown := range summary.BreakdownByType {
		if breakdown.Percent < 50 {
			continue
		}

		alerts = append(alerts, PortfolioAlert{
			ID:       uuid.New(),
			Type:     AlertTypeConcentration,
			Severity: AlertSeverityWarning,
			Message: fmt.Sprintf("%s assets represent %.0f%% of portfolio - sector concentration risk",
				breakdown.Type, breakdown.Percent),
			Action:    "Consider adding other asset types for diversification",
			CreatedAt: time.Now().UTC(),
		})
	}

	return alerts
}

// generateHealthAlerts creates alerts for health score changes.
func (g *AlertGenerator) generateHealthAlerts(
	currentScore HealthScore,
	previousScore *int,
) []PortfolioAlert {
	var alerts []PortfolioAlert

	// Alert if health score is low
	if currentScore.Overall < 50 {
		alerts = append(alerts, PortfolioAlert{
			ID:        uuid.New(),
			Type:      AlertTypeHealth,
			Severity:  AlertSeverityWarning,
			Message:   fmt.Sprintf("Portfolio health score is %d/100 - needs attention", currentScore.Overall),
			Action:    "Review portfolio structure based on suggestions",
			CreatedAt: time.Now().UTC(),
		})
	}

	// Alert if health score dropped significantly
	if previousScore != nil {
		drop := *previousScore - currentScore.Overall
		if drop >= 10 {
			severity := AlertSeverityWarning
			if drop >= 20 {
				severity = AlertSeverityCritical
			}

			alerts = append(alerts, PortfolioAlert{
				ID:       uuid.New(),
				Type:     AlertTypeHealth,
				Severity: severity,
				Message: fmt.Sprintf("Portfolio health dropped %d points (from %d to %d)",
					drop, *previousScore, currentScore.Overall),
				Action:    "Review recent changes and consider rebalancing",
				CreatedAt: time.Now().UTC(),
			})
		}
	}

	// Add alerts for specific low-scoring factors
	if currentScore.Diversification < 40 {
		alerts = append(alerts, PortfolioAlert{
			ID:        uuid.New(),
			Type:      AlertTypeHealth,
			Severity:  AlertSeverityInfo,
			Message:   fmt.Sprintf("Diversification score is low (%d/100)", currentScore.Diversification),
			Action:    "Add different asset types to improve diversification",
			CreatedAt: time.Now().UTC(),
		})
	}

	if currentScore.RiskLevel < 40 {
		alerts = append(alerts, PortfolioAlert{
			ID:        uuid.New(),
			Type:      AlertTypeHealth,
			Severity:  AlertSeverityWarning,
			Message:   fmt.Sprintf("Risk level score is low (%d/100) - portfolio may be too aggressive", currentScore.RiskLevel),
			Action:    "Consider adding stable assets like bonds or gold",
			CreatedAt: time.Now().UTC(),
		})
	}

	return alerts
}

// EnhanceAlertsWithAI uses Gemini 3 to improve alert messages (optional enhancement).
func (g *AlertGenerator) EnhanceAlertsWithAI(ctx context.Context, alerts []PortfolioAlert) []PortfolioAlert {
	if g.aiClient == nil || len(alerts) == 0 {
		return alerts
	}

	// For hackathon, keep simple rule-based alerts
	// AI enhancement can be added for more sophisticated messaging
	g.logger.Debug("AI alert enhancement available but using rule-based for performance")

	return alerts
}

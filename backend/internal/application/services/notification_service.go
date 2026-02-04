package services

import (
	"context"
	"sync"
	"time"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// AlertTriggerType represents the type of alert trigger.
type AlertTriggerType string

const (
	AlertTriggerConcentrationRisk AlertTriggerType = "concentration_risk"
	AlertTriggerLargeLoss         AlertTriggerType = "large_loss"
	AlertTriggerPortfolioDecline  AlertTriggerType = "portfolio_decline"
	AlertTriggerRiskLevelChange   AlertTriggerType = "risk_level_change"
	AlertTriggerNewSectorExposure AlertTriggerType = "new_sector_exposure"
	AlertTriggerRebalanceNeeded   AlertTriggerType = "rebalance_needed"
)

// AlertTrigger represents a triggered alert condition.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AlertTrigger struct {
	Type        AlertTriggerType `json:"type"`
	Threshold   float64          `json:"threshold"`
	ActualValue float64          `json:"actual_value"`
	Severity    string           `json:"severity"` // critical, warning, info
	Title       string           `json:"title"`
	Message     string           `json:"message"`
}

// AlertThresholds defines the thresholds for various alert types.
type AlertThresholds struct {
	ConcentrationWarning  float64 // Single asset >X% of portfolio (default: 40%)
	ConcentrationCritical float64 // Single asset >X% of portfolio (default: 70%)
	LargeLossWarning      float64 // Single asset down >X% (default: 10%)
	LargeLossCritical     float64 // Single asset down >X% (default: 20%)
	PortfolioDeclineWarn  float64 // Total portfolio down >X% (default: 5%)
	PortfolioDeclineCrit  float64 // Total portfolio down >X% (default: 10%)
	RiskScoreWarning      int     // Risk score >X (default: 50)
	RiskScoreCritical     int     // Risk score >X (default: 70)
	RebalanceDrift        float64 // Allocation drift >X% (default: 10%)
}

// DefaultAlertThresholds returns default alert thresholds.
func DefaultAlertThresholds() AlertThresholds {
	return AlertThresholds{
		ConcentrationWarning:  40.0,
		ConcentrationCritical: 70.0,
		LargeLossWarning:      10.0,
		LargeLossCritical:     20.0,
		PortfolioDeclineWarn:  5.0,
		PortfolioDeclineCrit:  10.0,
		RiskScoreWarning:      50,
		RiskScoreCritical:     70,
		RebalanceDrift:        10.0,
	}
}

// notificationRecord tracks when a notification was last sent.
type notificationRecord struct {
	lastSent time.Time
	count    int
}

// NotificationService handles alert detection and notification tracking.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NotificationService struct {
	insightRepo repositories.InsightRepository
	thresholds  AlertThresholds
	logger      *zap.Logger

	// In-memory tracking to avoid duplicate notifications
	recentNotifications map[string]*notificationRecord
	mu                  sync.RWMutex
	cooldownPeriod      time.Duration
}

// NewNotificationService creates a new NotificationService.
func NewNotificationService(
	insightRepo repositories.InsightRepository,
	logger *zap.Logger,
) *NotificationService {
	if logger == nil {
		logger = zap.NewNop()
	}

	return &NotificationService{
		insightRepo:         insightRepo,
		thresholds:          DefaultAlertThresholds(),
		logger:              logger,
		recentNotifications: make(map[string]*notificationRecord),
		cooldownPeriod:      4 * time.Hour, // Don't repeat same alert within 4 hours
	}
}

// SetThresholds allows customizing alert thresholds.
func (s *NotificationService) SetThresholds(thresholds AlertThresholds) {
	s.thresholds = thresholds
}

// CheckAlertTriggers analyzes a portfolio and returns any triggered alerts.
func (s *NotificationService) CheckAlertTriggers(ctx context.Context, analysis *PortfolioAnalysis) []AlertTrigger {
	if analysis == nil {
		return nil
	}

	var triggers []AlertTrigger

	// Check risk-based alerts
	if analysis.RiskMetrics != nil {
		triggers = append(triggers, s.checkRiskAlerts(analysis.RiskMetrics)...)
	}

	// Check portfolio performance
	if analysis.Summary != nil {
		triggers = append(triggers, s.checkPerformanceAlerts(analysis.Summary)...)
	}

	// Check allocation drift
	triggers = append(triggers, s.checkAllocationAlerts(analysis.Allocations)...)

	// Check individual asset performance
	triggers = append(triggers, s.checkAssetAlerts(analysis.TopLosers)...)

	return triggers
}

// checkRiskAlerts checks for risk-related alerts.
func (s *NotificationService) checkRiskAlerts(risk *PortfolioRisk) []AlertTrigger {
	var triggers []AlertTrigger

	// Check risk score
	if risk.RiskScore >= s.thresholds.RiskScoreCritical {
		triggers = append(triggers, AlertTrigger{
			Type:        AlertTriggerRiskLevelChange,
			Threshold:   float64(s.thresholds.RiskScoreCritical),
			ActualValue: float64(risk.RiskScore),
			Severity:    "critical",
			Title:       "Critical Risk Level",
			Message:     "Your portfolio risk score has reached critical levels. Immediate review recommended.",
		})
	} else if risk.RiskScore >= s.thresholds.RiskScoreWarning {
		triggers = append(triggers, AlertTrigger{
			Type:        AlertTriggerRiskLevelChange,
			Threshold:   float64(s.thresholds.RiskScoreWarning),
			ActualValue: float64(risk.RiskScore),
			Severity:    "warning",
			Title:       "Elevated Risk Level",
			Message:     "Your portfolio risk score is elevated. Consider reviewing your positions.",
		})
	}

	// Check concentration from existing risk alerts
	for _, alert := range risk.Alerts {
		if alert.Type == "sector_concentration" || alert.Type == "geographic_concentration" {
			triggers = append(triggers, AlertTrigger{
				Type:        AlertTriggerConcentrationRisk,
				Threshold:   alert.Threshold,
				ActualValue: alert.Value,
				Severity:    alert.Severity,
				Title:       alert.Title,
				Message:     alert.Message,
			})
		}
	}

	return triggers
}

// checkPerformanceAlerts checks for portfolio-wide performance alerts.
func (s *NotificationService) checkPerformanceAlerts(summary *repositories.PortfolioSummary) []AlertTrigger {
	var triggers []AlertTrigger

	// Check overall portfolio decline
	if summary.GainLossPercent <= -s.thresholds.PortfolioDeclineCrit {
		triggers = append(triggers, AlertTrigger{
			Type:        AlertTriggerPortfolioDecline,
			Threshold:   s.thresholds.PortfolioDeclineCrit,
			ActualValue: -summary.GainLossPercent,
			Severity:    "critical",
			Title:       "Significant Portfolio Decline",
			Message:     "Your portfolio has declined significantly. Review your positions and consider your investment strategy.",
		})
	} else if summary.GainLossPercent <= -s.thresholds.PortfolioDeclineWarn {
		triggers = append(triggers, AlertTrigger{
			Type:        AlertTriggerPortfolioDecline,
			Threshold:   s.thresholds.PortfolioDeclineWarn,
			ActualValue: -summary.GainLossPercent,
			Severity:    "warning",
			Title:       "Portfolio Decline",
			Message:     "Your portfolio has experienced a notable decline. Stay informed about market conditions.",
		})
	}

	return triggers
}

// checkAllocationAlerts checks for allocation drift alerts.
func (s *NotificationService) checkAllocationAlerts(allocations []AllocationInsight) []AlertTrigger {
	var triggers []AlertTrigger

	overweightCount := 0
	underweightCount := 0

	for _, alloc := range allocations {
		if alloc.Status == "overweight" {
			overweightCount++
		} else if alloc.Status == "underweight" {
			underweightCount++
		}
	}

	// Alert if multiple allocations are off balance
	if overweightCount >= 2 || underweightCount >= 2 {
		triggers = append(triggers, AlertTrigger{
			Type:        AlertTriggerRebalanceNeeded,
			Threshold:   s.thresholds.RebalanceDrift,
			ActualValue: float64(overweightCount + underweightCount),
			Severity:    "warning",
			Title:       "Portfolio Rebalancing Recommended",
			Message:     "Your portfolio allocation has drifted from balanced targets. Consider rebalancing.",
		})
	}

	return triggers
}

// checkAssetAlerts checks for individual asset performance alerts.
func (s *NotificationService) checkAssetAlerts(losers []AssetPerformance) []AlertTrigger {
	var triggers []AlertTrigger

	for _, asset := range losers {
		lossPercent := -asset.GainLossPercent // Convert to positive for comparison

		if lossPercent >= s.thresholds.LargeLossCritical {
			triggers = append(triggers, AlertTrigger{
				Type:        AlertTriggerLargeLoss,
				Threshold:   s.thresholds.LargeLossCritical,
				ActualValue: lossPercent,
				Severity:    "critical",
				Title:       "Significant Loss: " + asset.Name,
				Message:     asset.Name + " has declined significantly. Review this position.",
			})
		} else if lossPercent >= s.thresholds.LargeLossWarning {
			triggers = append(triggers, AlertTrigger{
				Type:        AlertTriggerLargeLoss,
				Threshold:   s.thresholds.LargeLossWarning,
				ActualValue: lossPercent,
				Severity:    "warning",
				Title:       "Notable Loss: " + asset.Name,
				Message:     asset.Name + " has declined notably. Monitor this position.",
			})
		}
	}

	return triggers
}

// ShouldNotify determines if a notification should be sent based on cooldown.
func (s *NotificationService) ShouldNotify(ctx context.Context, userID uuid.UUID, trigger AlertTrigger) bool {
	key := s.notificationKey(userID, trigger)

	s.mu.RLock()
	record, exists := s.recentNotifications[key]
	s.mu.RUnlock()

	if !exists {
		return true
	}

	// Check if cooldown has passed
	if time.Since(record.lastSent) > s.cooldownPeriod {
		return true
	}

	// For critical alerts, allow more frequent notifications
	if trigger.Severity == "critical" && time.Since(record.lastSent) > time.Hour {
		return true
	}

	return false
}

// RecordNotification records that a notification was sent.
func (s *NotificationService) RecordNotification(ctx context.Context, userID uuid.UUID, trigger AlertTrigger) error {
	key := s.notificationKey(userID, trigger)

	s.mu.Lock()
	defer s.mu.Unlock()

	if record, exists := s.recentNotifications[key]; exists {
		record.lastSent = time.Now()
		record.count++
	} else {
		s.recentNotifications[key] = &notificationRecord{
			lastSent: time.Now(),
			count:    1,
		}
	}

	return nil
}

// notificationKey generates a unique key for tracking notifications.
func (s *NotificationService) notificationKey(userID uuid.UUID, trigger AlertTrigger) string {
	return userID.String() + ":" + string(trigger.Type) + ":" + trigger.Severity
}

// CreateInsightFromTrigger creates an insight entity from an alert trigger.
func (s *NotificationService) CreateInsightFromTrigger(userID uuid.UUID, trigger AlertTrigger) *entities.Insight {
	priority := entities.InsightPriorityMedium
	if trigger.Severity == "critical" {
		priority = entities.InsightPriorityHigh
	} else if trigger.Severity == "info" {
		priority = entities.InsightPriorityLow
	}

	insight := entities.NewAlert(userID, trigger.Title, trigger.Message, priority, entities.InsightCategoryRisk)

	// Add related symbols if applicable
	// (This would need to be enhanced based on the specific trigger)

	return insight
}

// CleanupOldRecords removes old notification records to prevent memory growth.
func (s *NotificationService) CleanupOldRecords() {
	s.mu.Lock()
	defer s.mu.Unlock()

	cutoff := time.Now().Add(-24 * time.Hour)
	for key, record := range s.recentNotifications {
		if record.lastSent.Before(cutoff) {
			delete(s.recentNotifications, key)
		}
	}
}

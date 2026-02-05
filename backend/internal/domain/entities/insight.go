package entities

import (
	"time"

	"github.com/google/uuid"
)

// InsightType represents the type of insight.
type InsightType string

const (
	InsightTypeDailyBriefing  InsightType = "daily_briefing"
	InsightTypeAlert          InsightType = "alert"
	InsightTypeRecommendation InsightType = "recommendation"
	InsightTypeOpportunity    InsightType = "opportunity"
)

// InsightPriority represents the priority level of an insight.
type InsightPriority string

const (
	InsightPriorityHigh   InsightPriority = "high"
	InsightPriorityMedium InsightPriority = "medium"
	InsightPriorityLow    InsightPriority = "low"
)

// InsightCategory represents the category of an insight.
type InsightCategory string

const (
	InsightCategoryRisk        InsightCategory = "risk"
	InsightCategoryPerformance InsightCategory = "performance"
	InsightCategoryOpportunity InsightCategory = "opportunity"
	InsightCategoryGeneral     InsightCategory = "general"
	InsightCategoryMarket      InsightCategory = "market"
)

// Insight represents a proactive financial insight or recommendation.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type Insight struct {
	ID             uuid.UUID       `json:"id"`
	UserID         uuid.UUID       `json:"user_id"`
	Type           InsightType     `json:"type"`
	Title          string          `json:"title"`
	Content        string          `json:"content"`
	Priority       InsightPriority `json:"priority"`
	Category       InsightCategory `json:"category"`
	ActionItems    []string        `json:"action_items,omitempty"`
	RelatedSymbols []string        `json:"related_symbols,omitempty"`
	ExpiresAt      *time.Time      `json:"expires_at,omitempty"`
	ReadAt         *time.Time      `json:"read_at,omitempty"`
	CreatedAt      time.Time       `json:"created_at"`
}

// NewInsight creates a new Insight with default values.
func NewInsight(userID uuid.UUID, insightType InsightType, title, content string) *Insight {
	return &Insight{
		ID:             uuid.New(),
		UserID:         userID,
		Type:           insightType,
		Title:          title,
		Content:        content,
		Priority:       InsightPriorityMedium,
		Category:       InsightCategoryGeneral,
		ActionItems:    []string{},
		RelatedSymbols: []string{},
		CreatedAt:      time.Now().UTC(),
	}
}

// NewDailyBriefing creates a new daily briefing insight.
func NewDailyBriefing(userID uuid.UUID, title, content string) *Insight {
	insight := NewInsight(userID, InsightTypeDailyBriefing, title, content)
	insight.Category = InsightCategoryGeneral
	// Daily briefings expire at end of day
	endOfDay := time.Now().UTC().Truncate(24 * time.Hour).Add(24 * time.Hour)
	insight.ExpiresAt = &endOfDay
	return insight
}

// NewAlert creates a new alert insight.
func NewAlert(userID uuid.UUID, title, content string, priority InsightPriority, category InsightCategory) *Insight {
	insight := NewInsight(userID, InsightTypeAlert, title, content)
	insight.Priority = priority
	insight.Category = category
	return insight
}

// NewRecommendation creates a new recommendation insight.
func NewRecommendation(userID uuid.UUID, title, content string, actionItems []string) *Insight {
	insight := NewInsight(userID, InsightTypeRecommendation, title, content)
	insight.Category = InsightCategoryOpportunity
	insight.ActionItems = actionItems
	return insight
}

// IsRead returns true if the insight has been read.
func (i *Insight) IsRead() bool {
	return i.ReadAt != nil
}

// IsExpired returns true if the insight has expired.
func (i *Insight) IsExpired() bool {
	if i.ExpiresAt == nil {
		return false
	}
	return time.Now().UTC().After(*i.ExpiresAt)
}

// MarkAsRead marks the insight as read.
func (i *Insight) MarkAsRead() {
	now := time.Now().UTC()
	i.ReadAt = &now
}

// SetActionItems sets the action items for the insight.
func (i *Insight) SetActionItems(items []string) {
	i.ActionItems = items
}

// SetRelatedSymbols sets the related symbols for the insight.
func (i *Insight) SetRelatedSymbols(symbols []string) {
	i.RelatedSymbols = symbols
}

// SetExpiration sets the expiration time for the insight.
func (i *Insight) SetExpiration(expiresAt time.Time) {
	i.ExpiresAt = &expiresAt
}

// InsightFilter represents filter options for listing insights.
type InsightFilter struct {
	Type       *InsightType
	Category   *InsightCategory
	Priority   *InsightPriority
	UnreadOnly bool
	Limit      int
	Offset     int
}

// DefaultInsightFilter returns a default filter with reasonable defaults.
func DefaultInsightFilter() InsightFilter {
	return InsightFilter{
		UnreadOnly: false,
		Limit:      20,
		Offset:     0,
	}
}

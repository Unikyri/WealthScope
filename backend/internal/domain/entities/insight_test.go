package entities

import (
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestNewInsight(t *testing.T) {
	userID := uuid.New()
	title := "Test Insight"
	content := "This is test content"

	insight := NewInsight(userID, InsightTypeAlert, title, content)

	assert.NotEqual(t, uuid.Nil, insight.ID)
	assert.Equal(t, userID, insight.UserID)
	assert.Equal(t, InsightTypeAlert, insight.Type)
	assert.Equal(t, title, insight.Title)
	assert.Equal(t, content, insight.Content)
	assert.Equal(t, InsightPriorityMedium, insight.Priority)
	assert.Equal(t, InsightCategoryGeneral, insight.Category)
	assert.NotNil(t, insight.ActionItems)
	assert.Empty(t, insight.ActionItems)
	assert.NotNil(t, insight.RelatedSymbols)
	assert.Empty(t, insight.RelatedSymbols)
	assert.Nil(t, insight.ExpiresAt)
	assert.Nil(t, insight.ReadAt)
	assert.False(t, insight.CreatedAt.IsZero())
}

func TestNewDailyBriefing(t *testing.T) {
	userID := uuid.New()
	title := "Daily Briefing - January 26"
	content := "Your portfolio summary..."

	briefing := NewDailyBriefing(userID, title, content)

	assert.Equal(t, InsightTypeDailyBriefing, briefing.Type)
	assert.Equal(t, InsightCategoryGeneral, briefing.Category)
	assert.NotNil(t, briefing.ExpiresAt)

	// Should expire at end of day
	endOfDay := time.Now().UTC().Truncate(24 * time.Hour).Add(24 * time.Hour)
	assert.Equal(t, endOfDay.Day(), briefing.ExpiresAt.Day())
}

func TestNewAlert(t *testing.T) {
	userID := uuid.New()
	title := "Risk Alert"
	content := "High concentration detected"

	alert := NewAlert(userID, title, content, InsightPriorityHigh, InsightCategoryRisk)

	assert.Equal(t, InsightTypeAlert, alert.Type)
	assert.Equal(t, InsightPriorityHigh, alert.Priority)
	assert.Equal(t, InsightCategoryRisk, alert.Category)
}

func TestNewRecommendation(t *testing.T) {
	userID := uuid.New()
	title := "Portfolio Improvement"
	content := "Consider diversifying..."
	actionItems := []string{"Add bonds", "Reduce tech exposure"}

	rec := NewRecommendation(userID, title, content, actionItems)

	assert.Equal(t, InsightTypeRecommendation, rec.Type)
	assert.Equal(t, InsightCategoryOpportunity, rec.Category)
	assert.Equal(t, actionItems, rec.ActionItems)
}

func TestInsight_IsRead(t *testing.T) {
	insight := NewInsight(uuid.New(), InsightTypeAlert, "Test", "Content")

	assert.False(t, insight.IsRead())

	insight.MarkAsRead()

	assert.True(t, insight.IsRead())
	assert.NotNil(t, insight.ReadAt)
}

func TestInsight_IsExpired(t *testing.T) {
	insight := NewInsight(uuid.New(), InsightTypeAlert, "Test", "Content")

	// No expiration set
	assert.False(t, insight.IsExpired())

	// Set future expiration
	future := time.Now().Add(1 * time.Hour)
	insight.SetExpiration(future)
	assert.False(t, insight.IsExpired())

	// Set past expiration
	past := time.Now().Add(-1 * time.Hour)
	insight.SetExpiration(past)
	assert.True(t, insight.IsExpired())
}

func TestInsight_SetActionItems(t *testing.T) {
	insight := NewInsight(uuid.New(), InsightTypeRecommendation, "Test", "Content")

	items := []string{"Item 1", "Item 2", "Item 3"}
	insight.SetActionItems(items)

	assert.Equal(t, items, insight.ActionItems)
	assert.Len(t, insight.ActionItems, 3)
}

func TestInsight_SetRelatedSymbols(t *testing.T) {
	insight := NewInsight(uuid.New(), InsightTypeAlert, "Test", "Content")

	symbols := []string{"AAPL", "MSFT", "GOOGL"}
	insight.SetRelatedSymbols(symbols)

	assert.Equal(t, symbols, insight.RelatedSymbols)
	assert.Len(t, insight.RelatedSymbols, 3)
}

func TestInsightTypeConstants(t *testing.T) {
	assert.Equal(t, InsightType("daily_briefing"), InsightTypeDailyBriefing)
	assert.Equal(t, InsightType("alert"), InsightTypeAlert)
	assert.Equal(t, InsightType("recommendation"), InsightTypeRecommendation)
	assert.Equal(t, InsightType("opportunity"), InsightTypeOpportunity)
}

func TestInsightPriorityConstants(t *testing.T) {
	assert.Equal(t, InsightPriority("high"), InsightPriorityHigh)
	assert.Equal(t, InsightPriority("medium"), InsightPriorityMedium)
	assert.Equal(t, InsightPriority("low"), InsightPriorityLow)
}

func TestInsightCategoryConstants(t *testing.T) {
	assert.Equal(t, InsightCategory("risk"), InsightCategoryRisk)
	assert.Equal(t, InsightCategory("performance"), InsightCategoryPerformance)
	assert.Equal(t, InsightCategory("opportunity"), InsightCategoryOpportunity)
	assert.Equal(t, InsightCategory("general"), InsightCategoryGeneral)
	assert.Equal(t, InsightCategory("market"), InsightCategoryMarket)
}

func TestInsightFilter_Default(t *testing.T) {
	filter := DefaultInsightFilter()

	assert.Nil(t, filter.Type)
	assert.Nil(t, filter.Category)
	assert.Nil(t, filter.Priority)
	assert.False(t, filter.UnreadOnly)
	assert.Equal(t, 20, filter.Limit)
	assert.Equal(t, 0, filter.Offset)
}

func TestInsightFilter_WithValues(t *testing.T) {
	insightType := InsightTypeAlert
	category := InsightCategoryRisk
	priority := InsightPriorityHigh

	filter := InsightFilter{
		Type:       &insightType,
		Category:   &category,
		Priority:   &priority,
		UnreadOnly: true,
		Limit:      50,
		Offset:     10,
	}

	assert.Equal(t, InsightTypeAlert, *filter.Type)
	assert.Equal(t, InsightCategoryRisk, *filter.Category)
	assert.Equal(t, InsightPriorityHigh, *filter.Priority)
	assert.True(t, filter.UnreadOnly)
	assert.Equal(t, 50, filter.Limit)
	assert.Equal(t, 10, filter.Offset)
}

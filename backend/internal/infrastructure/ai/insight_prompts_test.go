package ai

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBuildDailyBriefingPrompt_NoPortfolio(t *testing.T) {
	data := PortfolioDataForPrompt{
		HasPortfolio: false,
		AssetCount:   0,
	}

	prompt := BuildDailyBriefingPrompt(data)

	assert.Contains(t, prompt, "Today's Date")
	assert.Contains(t, prompt, "no assets")
	assert.Contains(t, prompt, "welcoming briefing")
}

func TestBuildDailyBriefingPrompt_WithPortfolio(t *testing.T) {
	data := PortfolioDataForPrompt{
		HasPortfolio:    true,
		TotalValue:      10000.50,
		TotalInvested:   9000.00,
		GainLoss:        1000.50,
		GainLossPercent: 11.12,
		AssetCount:      5,
		TopGainers: []AssetPerformanceData{
			{Symbol: "AAPL", Name: "Apple Inc", GainLossPercent: 15.5},
			{Symbol: "MSFT", Name: "Microsoft", GainLossPercent: 10.2},
		},
		TopLosers: []AssetPerformanceData{
			{Symbol: "TSLA", Name: "Tesla", GainLossPercent: -5.3},
		},
		Allocations: []AllocationData{
			{Type: "stock", Percent: 60.0, Status: "balanced"},
			{Type: "crypto", Percent: 20.0, Status: "overweight"},
		},
		RiskScore:       45,
		Diversification: "medium",
		RiskAlerts: []RiskAlertData{
			{Type: "sector_concentration", Severity: "warning", Title: "Tech Heavy", Message: "50% in tech"},
		},
		RelevantNews: []NewsData{
			{Title: "Apple beats earnings", Source: "Reuters", Sentiment: 0.8},
		},
	}

	prompt := BuildDailyBriefingPrompt(data)

	assert.Contains(t, prompt, "10000.50")
	assert.Contains(t, prompt, "9000.00")
	assert.Contains(t, prompt, "Apple Inc")
	assert.Contains(t, prompt, "Tesla")
	assert.Contains(t, prompt, "stock")
	assert.Contains(t, prompt, "45/100")
	assert.Contains(t, prompt, "Tech Heavy")
	assert.Contains(t, prompt, "Apple beats earnings")
}

func TestBuildDailyBriefingPrompt_Spanish(t *testing.T) {
	data := PortfolioDataForPrompt{
		HasPortfolio:      true,
		AssetCount:        3,
		TotalValue:        5000,
		PreferredLanguage: "es",
	}

	prompt := BuildDailyBriefingPrompt(data)

	assert.Contains(t, prompt, "Spanish")
}

func TestBuildAlertPrompt(t *testing.T) {
	data := PortfolioDataForPrompt{
		TotalValue:      10000,
		RiskScore:       65,
		Diversification: "medium",
		Allocations: []AllocationData{
			{Type: "stock", Percent: 70.0},
		},
	}

	alertData := RiskAlertData{
		Type:     "sector_concentration",
		Severity: "warning",
		Title:    "High concentration",
		Message:  "70% in stocks",
	}

	prompt := BuildAlertPrompt("sector_concentration", data, alertData)

	assert.Contains(t, prompt, "sector_concentration")
	assert.Contains(t, prompt, "warning")
	assert.Contains(t, prompt, "70% in stocks")
	assert.Contains(t, prompt, "10000")
	assert.Contains(t, prompt, "65/100")
}

func TestBuildRecommendationPrompt(t *testing.T) {
	data := PortfolioDataForPrompt{
		TotalValue:        20000,
		GainLossPercent:   5.5,
		RiskScore:         55,
		Diversification:   "medium",
		PreferredLanguage: "en",
		Allocations: []AllocationData{
			{Type: "stock", Percent: 80.0, Status: "overweight"},
			{Type: "bond", Percent: 5.0, Status: "underweight"},
		},
	}

	prompt := BuildRecommendationPrompt(data)

	assert.Contains(t, prompt, "20000")
	assert.Contains(t, prompt, "5.50%")
	assert.Contains(t, prompt, "55/100")
	assert.Contains(t, prompt, "overweight")
	assert.Contains(t, prompt, "underweight")
}

func TestParseActionItems(t *testing.T) {
	tests := []struct {
		name     string
		content  string
		expected []string
	}{
		{
			name: "bullet points with action verbs",
			content: `Here are some suggestions:
- Consider diversifying into bonds
- Review your tech holdings
- Monitor the crypto market`,
			expected: []string{
				"Consider diversifying into bonds",
				"Review your tech holdings",
				"Monitor the crypto market",
			},
		},
		{
			name: "numbered list",
			content: `1. Reduce your position in AAPL
2. Add some fixed income
3. Check your risk profile`,
			expected: []string{
				"Reduce your position in AAPL",
				"Add some fixed income",
				"Check your risk profile",
			},
		},
		{
			name: "asterisk bullets",
			content: `* Consider adding bonds
* Evaluate your exposure`,
			expected: []string{
				"Consider adding bonds",
				"Evaluate your exposure",
			},
		},
		{
			name:     "no action items",
			content:  "Your portfolio looks good. No changes needed.",
			expected: nil,
		},
		{
			name: "mixed content",
			content: `Summary of your portfolio.

Some observations:
- Your stocks are performing well
- Consider rebalancing quarterly
- Investigate international exposure

Remember to stay diversified.`,
			expected: []string{
				"Consider rebalancing quarterly",
				"Investigate international exposure",
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := ParseActionItems(tt.content)

			if tt.expected == nil {
				assert.Empty(t, result)
			} else {
				assert.Equal(t, len(tt.expected), len(result))
				for i, expected := range tt.expected {
					if i < len(result) {
						assert.Equal(t, expected, result[i])
					}
				}
			}
		})
	}
}

func TestParseActionItems_Limit(t *testing.T) {
	// Create content with more than 5 action items
	content := `- Consider option 1
- Review option 2
- Add option 3
- Evaluate option 4
- Assess option 5
- Monitor option 6
- Investigate option 7`

	result := ParseActionItems(content)

	assert.LessOrEqual(t, len(result), 5, "Should limit to 5 action items")
}

func TestDailyBriefingSystemPrompt(t *testing.T) {
	// Verify the system prompt contains key elements
	assert.Contains(t, DailyBriefingSystemPrompt, "WealthScope AI")
	assert.Contains(t, DailyBriefingSystemPrompt, "daily briefing")
	assert.Contains(t, DailyBriefingSystemPrompt, "Portfolio Snapshot")
	assert.Contains(t, DailyBriefingSystemPrompt, "Action Items")
	assert.Contains(t, DailyBriefingSystemPrompt, "300-500 words")
}

func TestAlertSystemPrompt(t *testing.T) {
	assert.Contains(t, AlertSystemPrompt, "analyzing a portfolio")
	assert.Contains(t, AlertSystemPrompt, "risk")
	assert.Contains(t, AlertSystemPrompt, "actionable")
}

func TestRecommendationSystemPrompt(t *testing.T) {
	assert.Contains(t, RecommendationSystemPrompt, "improvement recommendations")
	assert.Contains(t, RecommendationSystemPrompt, "realistic")
	assert.Contains(t, RecommendationSystemPrompt, "3 action items")
}

func TestPortfolioDataForPrompt_Struct(t *testing.T) {
	// Test that the struct can be created and used
	data := PortfolioDataForPrompt{
		TotalValue:        12345.67,
		TotalInvested:     10000.00,
		GainLoss:          2345.67,
		GainLossPercent:   23.46,
		AssetCount:        10,
		HasPortfolio:      true,
		PreferredLanguage: "en",
	}

	assert.Equal(t, 12345.67, data.TotalValue)
	assert.Equal(t, 10000.00, data.TotalInvested)
	assert.Equal(t, 2345.67, data.GainLoss)
	assert.Equal(t, 23.46, data.GainLossPercent)
	assert.Equal(t, 10, data.AssetCount)
	assert.True(t, data.HasPortfolio)
	assert.Equal(t, "en", data.PreferredLanguage)
}

func TestBuildDailyBriefingPrompt_DateFormat(t *testing.T) {
	data := PortfolioDataForPrompt{
		HasPortfolio: true,
		AssetCount:   1,
		TotalValue:   1000,
	}

	prompt := BuildDailyBriefingPrompt(data)

	// Should contain a date in format like "Monday, January 2, 2006"
	assert.Contains(t, prompt, "Today's Date:")

	// Verify it contains a day name
	days := []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
	hasDay := false
	for _, day := range days {
		if strings.Contains(prompt, day) {
			hasDay = true
			break
		}
	}
	assert.True(t, hasDay, "Prompt should contain a day name")
}

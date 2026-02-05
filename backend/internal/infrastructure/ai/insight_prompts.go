package ai

import (
	"fmt"
	"strings"
	"time"
)

// DailyBriefingSystemPrompt is the system prompt for generating daily briefings.
const DailyBriefingSystemPrompt = `You are WealthScope AI, a proactive financial advisor generating a daily briefing for a user's investment portfolio.

## Your Task
Generate a concise, personalized daily briefing that helps the user understand their portfolio's current state and any actions they should consider.

## Briefing Structure
1. **Opening** - A brief, personalized greeting with the date
2. **Portfolio Snapshot** - Key metrics in 2-3 sentences
3. **Notable Changes** - Top movers (gains/losses) if significant
4. **Risk Alerts** - Any concentration or diversification concerns
5. **Market Context** - Brief relevant market commentary
6. **Action Items** - 1-3 specific, actionable suggestions (optional)

## Guidelines
- Be concise (300-500 words maximum)
- Use clear, simple language
- Focus on what matters most to the user
- Avoid generic advice - be specific to their portfolio
- If portfolio is performing well, acknowledge it positively
- If there are concerns, present them constructively with solutions
- Use bullet points for readability
- End with a positive or motivational note

## Format
Use markdown formatting for better readability. Include headers (##) for each section.`

// AlertSystemPrompt is the system prompt for generating risk alerts.
const AlertSystemPrompt = `You are WealthScope AI, analyzing a portfolio for potential risks and generating an alert.

## Your Task
Based on the portfolio analysis data provided, generate a clear, actionable alert about the identified risk.

## Alert Structure
1. **Title** - Clear, attention-grabbing title (max 60 chars)
2. **Issue** - What the problem is in 1-2 sentences
3. **Impact** - Why this matters to the user
4. **Recommendation** - Specific action(s) to address the issue

## Guidelines
- Be direct and clear about the risk
- Explain in simple terms why this matters
- Provide specific, actionable recommendations
- Don't be alarmist - present facts constructively
- Include relevant numbers/percentages when available`

// RecommendationSystemPrompt is the system prompt for generating recommendations.
const RecommendationSystemPrompt = `You are WealthScope AI, generating improvement recommendations for a portfolio.

## Your Task
Based on the portfolio analysis, suggest specific improvements the user could make to optimize their portfolio.

## Recommendation Structure
1. **Suggestion** - Clear statement of what to do
2. **Rationale** - Why this would help
3. **How to Implement** - Practical steps

## Guidelines
- Focus on realistic, achievable improvements
- Consider the user's current portfolio composition
- Suggest diversification opportunities if relevant
- Don't recommend specific stock picks
- Keep suggestions educational and informative
- Maximum 3 action items per recommendation`

// PortfolioDataForPrompt represents portfolio data formatted for prompts.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PortfolioDataForPrompt struct {
	TotalValue        float64
	TotalInvested     float64
	GainLoss          float64
	GainLossPercent   float64
	AssetCount        int
	TopGainers        []AssetPerformanceData
	TopLosers         []AssetPerformanceData
	Allocations       []AllocationData
	RiskScore         int
	Diversification   string
	RiskAlerts        []RiskAlertData
	RelevantNews      []NewsData
	HasPortfolio      bool
	PreferredLanguage string
}

// AssetPerformanceData represents asset performance for prompts.
type AssetPerformanceData struct {
	Symbol          string
	Name            string
	GainLossPercent float64
}

// AllocationData represents allocation data for prompts.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AllocationData struct {
	Type    string
	Percent float64
	Status  string
}

// RiskAlertData represents risk alert data for prompts.
type RiskAlertData struct {
	Type     string
	Severity string
	Title    string
	Message  string
}

// NewsData represents news data for prompts.
type NewsData struct {
	Title     string
	Source    string
	Sentiment float64
}

// BuildDailyBriefingPrompt builds the user prompt for daily briefing generation.
func BuildDailyBriefingPrompt(data PortfolioDataForPrompt) string {
	var sb strings.Builder

	// Date
	sb.WriteString(fmt.Sprintf("Today's Date: %s\n\n", time.Now().Format("Monday, January 2, 2006")))

	// Portfolio Summary
	sb.WriteString("## Portfolio Data\n")
	if !data.HasPortfolio || data.AssetCount == 0 {
		sb.WriteString("The user has no assets in their portfolio yet.\n")
		sb.WriteString("Generate a welcoming briefing encouraging them to start building their portfolio.\n")
		return sb.String()
	}

	sb.WriteString(fmt.Sprintf("- Total Value: $%.2f\n", data.TotalValue))
	sb.WriteString(fmt.Sprintf("- Total Invested: $%.2f\n", data.TotalInvested))
	sb.WriteString(fmt.Sprintf("- Overall Gain/Loss: $%.2f (%.2f%%)\n", data.GainLoss, data.GainLossPercent))
	sb.WriteString(fmt.Sprintf("- Number of Assets: %d\n", data.AssetCount))

	// Top Movers
	if len(data.TopGainers) > 0 {
		sb.WriteString("\n## Top Gainers\n")
		for _, g := range data.TopGainers {
			sb.WriteString(fmt.Sprintf("- %s (%s): +%.2f%%\n", g.Name, g.Symbol, g.GainLossPercent))
		}
	}

	if len(data.TopLosers) > 0 {
		sb.WriteString("\n## Top Losers\n")
		for _, l := range data.TopLosers {
			sb.WriteString(fmt.Sprintf("- %s (%s): %.2f%%\n", l.Name, l.Symbol, l.GainLossPercent))
		}
	}

	// Allocations
	if len(data.Allocations) > 0 {
		sb.WriteString("\n## Asset Allocation\n")
		for _, a := range data.Allocations {
			sb.WriteString(fmt.Sprintf("- %s: %.1f%% (%s)\n", a.Type, a.Percent, a.Status))
		}
	}

	// Risk Analysis
	sb.WriteString("\n## Risk Analysis\n")
	sb.WriteString(fmt.Sprintf("- Risk Score: %d/100\n", data.RiskScore))
	sb.WriteString(fmt.Sprintf("- Diversification: %s\n", data.Diversification))

	if len(data.RiskAlerts) > 0 {
		sb.WriteString("\n## Active Risk Alerts\n")
		for _, alert := range data.RiskAlerts {
			sb.WriteString(fmt.Sprintf("- [%s] %s: %s\n", alert.Severity, alert.Title, alert.Message))
		}
	}

	// Relevant News
	if len(data.RelevantNews) > 0 {
		sb.WriteString("\n## Recent News for Your Holdings\n")
		for _, news := range data.RelevantNews {
			sentiment := "neutral"
			if news.Sentiment > 0.2 {
				sentiment = "positive"
			} else if news.Sentiment < -0.2 {
				sentiment = "negative"
			}
			sb.WriteString(fmt.Sprintf("- \"%s\" (%s, %s sentiment)\n", news.Title, news.Source, sentiment))
		}
	}

	// Language preference
	if data.PreferredLanguage == "es" {
		sb.WriteString("\n## Language\nPlease generate the briefing in Spanish.\n")
	}

	sb.WriteString("\nGenerate the daily briefing based on this data.")

	return sb.String()
}

// BuildAlertPrompt builds the user prompt for alert generation.
func BuildAlertPrompt(alertType string, data PortfolioDataForPrompt, specificAlert RiskAlertData) string {
	var sb strings.Builder

	sb.WriteString("## Alert Context\n")
	sb.WriteString(fmt.Sprintf("Alert Type: %s\n", alertType))
	sb.WriteString(fmt.Sprintf("Severity: %s\n", specificAlert.Severity))
	sb.WriteString(fmt.Sprintf("Current Issue: %s\n", specificAlert.Message))

	sb.WriteString("\n## Portfolio Context\n")
	sb.WriteString(fmt.Sprintf("- Total Value: $%.2f\n", data.TotalValue))
	sb.WriteString(fmt.Sprintf("- Risk Score: %d/100\n", data.RiskScore))
	sb.WriteString(fmt.Sprintf("- Diversification: %s\n", data.Diversification))

	if len(data.Allocations) > 0 {
		sb.WriteString("\n## Current Allocations\n")
		for _, a := range data.Allocations {
			sb.WriteString(fmt.Sprintf("- %s: %.1f%%\n", a.Type, a.Percent))
		}
	}

	if data.PreferredLanguage == "es" {
		sb.WriteString("\n## Language\nPlease generate the alert in Spanish.\n")
	}

	sb.WriteString("\nGenerate a helpful alert based on this information.")

	return sb.String()
}

// BuildRecommendationPrompt builds the user prompt for recommendation generation.
func BuildRecommendationPrompt(data PortfolioDataForPrompt) string {
	var sb strings.Builder

	sb.WriteString("## Portfolio Analysis\n")
	sb.WriteString(fmt.Sprintf("- Total Value: $%.2f\n", data.TotalValue))
	sb.WriteString(fmt.Sprintf("- Overall Performance: %.2f%%\n", data.GainLossPercent))
	sb.WriteString(fmt.Sprintf("- Risk Score: %d/100\n", data.RiskScore))
	sb.WriteString(fmt.Sprintf("- Diversification Level: %s\n", data.Diversification))

	if len(data.Allocations) > 0 {
		sb.WriteString("\n## Current Allocations\n")
		for _, a := range data.Allocations {
			status := ""
			if a.Status != "balanced" {
				status = fmt.Sprintf(" - %s", a.Status)
			}
			sb.WriteString(fmt.Sprintf("- %s: %.1f%%%s\n", a.Type, a.Percent, status))
		}
	}

	// Identify areas for improvement
	sb.WriteString("\n## Areas for Improvement\n")

	hasIssues := false
	for _, a := range data.Allocations {
		if a.Status == "overweight" {
			sb.WriteString(fmt.Sprintf("- %s is overweight at %.1f%%\n", a.Type, a.Percent))
			hasIssues = true
		} else if a.Status == "underweight" {
			sb.WriteString(fmt.Sprintf("- %s is underweight at %.1f%%\n", a.Type, a.Percent))
			hasIssues = true
		}
	}

	if !hasIssues {
		sb.WriteString("- Portfolio appears well-balanced\n")
	}

	if data.RiskScore > 50 {
		sb.WriteString(fmt.Sprintf("- Risk score is elevated at %d/100\n", data.RiskScore))
	}

	if data.PreferredLanguage == "es" {
		sb.WriteString("\n## Language\nPlease generate recommendations in Spanish.\n")
	}

	sb.WriteString("\nGenerate 2-3 specific recommendations to improve this portfolio.")

	return sb.String()
}

// ParseActionItems extracts action items from AI-generated content.
// Looks for bullet points or numbered lists starting with action verbs.
func ParseActionItems(content string) []string {
	lines := strings.Split(content, "\n")
	var actionItems []string

	actionVerbs := []string{
		"consider", "review", "reduce", "increase", "diversify",
		"monitor", "evaluate", "rebalance", "add", "sell",
		"buy", "check", "assess", "explore", "investigate",
	}

	for _, line := range lines {
		line = strings.TrimSpace(line)
		// Check if line is a bullet point or numbered item
		if strings.HasPrefix(line, "- ") || strings.HasPrefix(line, "* ") ||
			(len(line) > 2 && line[0] >= '1' && line[0] <= '9' && line[1] == '.') {

			// Remove bullet/number prefix
			cleanLine := strings.TrimLeft(line, "-* 0123456789.")
			cleanLine = strings.TrimSpace(cleanLine)
			lowerLine := strings.ToLower(cleanLine)

			// Check if starts with action verb
			for _, verb := range actionVerbs {
				if strings.HasPrefix(lowerLine, verb) {
					actionItems = append(actionItems, cleanLine)
					break
				}
			}
		}
	}

	// Limit to 5 action items
	if len(actionItems) > 5 {
		actionItems = actionItems[:5]
	}

	return actionItems
}

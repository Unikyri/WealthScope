package ai

import (
	"fmt"
	"strings"
)

// FinancialAdvisorSystemPrompt is the base system prompt for WealthScope AI.
// Optimized for Gemini 3 capabilities including extended context and reasoning.
const FinancialAdvisorSystemPrompt = `You are WealthScope AI, an intelligent financial advisor assistant powered by Gemini 3, designed to help users manage and understand their investment portfolios.

## Your Capabilities
- Analyze investment portfolios and provide deep insights on asset allocation
- Explain financial concepts in clear, accessible language
- Provide market insights and general investment education
- Help users understand risk, diversification, and correlations
- Suggest portfolio optimization strategies with confidence levels
- Answer questions about stocks, ETFs, cryptocurrencies, forex, and precious metals
- Perform step-by-step scenario analysis for What-If simulations

## Advanced Analysis Features (Gemini 3)
- Extended context window for comprehensive portfolio analysis
- Multi-step reasoning for complex financial decisions
- Pattern recognition across historical market data
- Correlation analysis between portfolio assets
- Risk-adjusted return projections

## Your Limitations
- You are NOT a licensed financial advisor
- Your advice is for educational and informational purposes only
- Users should consult with qualified financial professionals before making investment decisions
- You cannot execute trades directly
- You should not provide specific buy/sell recommendations with exact timing

## Response Guidelines
- Be concise but thorough in your explanations
- Use simple language when explaining complex financial concepts
- Think step-by-step when analyzing complex scenarios
- Show your reasoning process when appropriate
- Provide confidence levels (Low/Medium/High) for predictions
- When discussing risk, always emphasize the importance of diversification
- Acknowledge uncertainty when appropriate
- Format responses with markdown for better readability
- Use bullet points and headers for complex explanations

## Ethical Guidelines
- Never encourage excessive risk-taking
- Always consider the user's stated risk tolerance
- Promote long-term thinking over short-term speculation
- Be transparent about the limitations of AI-generated advice`

// UserContext contains contextual information about the user for personalized responses.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type UserContext struct {
	RiskProfile   string
	PreferredLang string
	TopAssetTypes []string
	TotalValue    float64
	AssetCount    int
	HasPortfolio  bool
}

// PromptBuilder constructs personalized system prompts.
type PromptBuilder struct{}

// NewPromptBuilder creates a new PromptBuilder.
func NewPromptBuilder() *PromptBuilder {
	return &PromptBuilder{}
}

// BuildSystemPrompt creates a personalized system prompt based on user context.
func (p *PromptBuilder) BuildSystemPrompt(ctx UserContext) string {
	var sb strings.Builder

	sb.WriteString(FinancialAdvisorSystemPrompt)

	// Add user context section if available
	if ctx.HasPortfolio || ctx.RiskProfile != "" {
		sb.WriteString("\n\n## Current User Context\n")

		if ctx.HasPortfolio {
			sb.WriteString(fmt.Sprintf("- User has a portfolio with %d assets\n", ctx.AssetCount))
			if ctx.TotalValue > 0 {
				sb.WriteString(fmt.Sprintf("- Portfolio total value: $%.2f\n", ctx.TotalValue))
			}
			if len(ctx.TopAssetTypes) > 0 {
				sb.WriteString(fmt.Sprintf("- Main asset types: %s\n", strings.Join(ctx.TopAssetTypes, ", ")))
			}
		}

		if ctx.RiskProfile != "" {
			sb.WriteString(fmt.Sprintf("- User's risk profile: %s\n", ctx.RiskProfile))
			sb.WriteString(p.getRiskGuidelines(ctx.RiskProfile))
		}
	}

	// Add language preference
	if ctx.PreferredLang == "es" {
		sb.WriteString("\n\n## Language Preference\nThe user prefers responses in Spanish. Please respond in Spanish.")
	}

	return sb.String()
}

// getRiskGuidelines returns specific guidelines based on risk profile.
func (p *PromptBuilder) getRiskGuidelines(profile string) string {
	switch strings.ToLower(profile) {
	case "conservative":
		return `
When advising this conservative investor:
- Emphasize capital preservation and stable returns
- Recommend focusing on bonds, dividend stocks, and low-volatility assets
- Discuss the importance of emergency funds before investing
- Suggest a higher allocation to fixed-income securities`

	case "moderate":
		return `
When advising this moderate investor:
- Balance growth potential with risk management
- Suggest a diversified mix of stocks and bonds
- Discuss both upside potential and downside risks
- Recommend regular portfolio rebalancing`

	case "aggressive":
		return `
When advising this aggressive investor:
- Acknowledge their higher risk tolerance
- Discuss growth-oriented investments but still emphasize diversification
- Remind them of the importance of having some defensive positions
- Explain that higher potential returns come with higher volatility`

	default:
		return ""
	}
}

// BuildWelcomeMessage creates a personalized welcome message for new conversations.
func (p *PromptBuilder) BuildWelcomeMessage(ctx UserContext) string {
	if ctx.PreferredLang == "es" {
		if ctx.HasPortfolio {
			return fmt.Sprintf("¡Hola! Soy WealthScope AI, tu asistente financiero. Veo que tienes un portafolio con %d activos. ¿En qué puedo ayudarte hoy?", ctx.AssetCount)
		}
		return "¡Hola! Soy WealthScope AI, tu asistente financiero. ¿En qué puedo ayudarte con tus inversiones hoy?"
	}

	if ctx.HasPortfolio {
		return fmt.Sprintf("Hello! I'm WealthScope AI, your financial assistant. I see you have a portfolio with %d assets. How can I help you today?", ctx.AssetCount)
	}
	return "Hello! I'm WealthScope AI, your financial assistant. How can I help you with your investments today?"
}

// ConversationStarters returns suggested conversation starters.
//
//nolint:misspell // Spanish text is intentional
func (p *PromptBuilder) ConversationStarters(hasPortfolio bool, lang string) []string {
	if lang == "es" {
		if hasPortfolio {
			return []string{
				"¿Cómo está diversificado mi portafolio?",
				"¿Cuál es mi exposición al riesgo?",
				"¿Qué activos debería considerar agregar?",
				"Explícame las tendencias del mercado",
			}
		}
		return []string{
			"¿Cómo empiezo a invertir?",
			"¿Qué es la diversificación?",
			"Explícame los tipos de activos",
			"¿Cuánto debería invertir?",
		}
	}

	if hasPortfolio {
		return []string{
			"How diversified is my portfolio?",
			"What's my risk exposure?",
			"What assets should I consider adding?",
			"Explain current market trends",
		}
	}
	return []string{
		"How do I start investing?",
		"What is diversification?",
		"Explain different asset types",
		"How much should I invest?",
	}
}

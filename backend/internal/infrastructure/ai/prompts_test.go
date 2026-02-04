package ai

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPromptBuilder_BuildSystemPrompt(t *testing.T) {
	builder := NewPromptBuilder()

	t.Run("base prompt without context", func(t *testing.T) {
		ctx := UserContext{}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "WealthScope AI")
		assert.Contains(t, prompt, "financial advisor")
		assert.Contains(t, prompt, "NOT a licensed financial advisor")
	})

	t.Run("with portfolio context", func(t *testing.T) {
		ctx := UserContext{
			HasPortfolio:  true,
			TotalValue:    10000.50,
			AssetCount:    5,
			TopAssetTypes: []string{"stock", "crypto"},
		}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "5 assets")
		assert.Contains(t, prompt, "10000.50")
		assert.Contains(t, prompt, "stock, crypto")
	})

	t.Run("with risk profile - conservative", func(t *testing.T) {
		ctx := UserContext{
			RiskProfile: "conservative",
		}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "conservative")
		assert.Contains(t, prompt, "capital preservation")
	})

	t.Run("with risk profile - moderate", func(t *testing.T) {
		ctx := UserContext{
			RiskProfile: "moderate",
		}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "moderate")
		assert.Contains(t, prompt, "Balance growth")
	})

	t.Run("with risk profile - aggressive", func(t *testing.T) {
		ctx := UserContext{
			RiskProfile: "aggressive",
		}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "aggressive")
		assert.Contains(t, prompt, "higher risk tolerance")
	})

	t.Run("with Spanish language preference", func(t *testing.T) {
		ctx := UserContext{
			PreferredLang: "es",
		}
		prompt := builder.BuildSystemPrompt(ctx)

		assert.Contains(t, prompt, "Spanish")
	})
}

func TestPromptBuilder_BuildWelcomeMessage(t *testing.T) {
	builder := NewPromptBuilder()

	t.Run("English without portfolio", func(t *testing.T) {
		ctx := UserContext{
			HasPortfolio:  false,
			PreferredLang: "en",
		}
		msg := builder.BuildWelcomeMessage(ctx)

		assert.Contains(t, msg, "WealthScope AI")
		assert.Contains(t, msg, "How can I help")
	})

	t.Run("English with portfolio", func(t *testing.T) {
		ctx := UserContext{
			HasPortfolio:  true,
			AssetCount:    3,
			PreferredLang: "en",
		}
		msg := builder.BuildWelcomeMessage(ctx)

		assert.Contains(t, msg, "3 assets")
	})

	t.Run("Spanish without portfolio", func(t *testing.T) {
		ctx := UserContext{
			HasPortfolio:  false,
			PreferredLang: "es",
		}
		msg := builder.BuildWelcomeMessage(ctx)

		assert.Contains(t, msg, "WealthScope AI")
		assert.Contains(t, msg, "ayudarte")
	})

	t.Run("Spanish with portfolio", func(t *testing.T) {
		ctx := UserContext{
			HasPortfolio:  true,
			AssetCount:    5,
			PreferredLang: "es",
		}
		msg := builder.BuildWelcomeMessage(ctx)

		assert.Contains(t, msg, "5 activos")
	})
}

func TestPromptBuilder_ConversationStarters(t *testing.T) {
	builder := NewPromptBuilder()

	t.Run("English with portfolio", func(t *testing.T) {
		starters := builder.ConversationStarters(true, "en")

		assert.NotEmpty(t, starters)
		assert.Len(t, starters, 4)

		// Should contain portfolio-related starters
		hasPortfolioRelated := false
		for _, s := range starters {
			if strings.Contains(s, "portfolio") || strings.Contains(s, "diversified") {
				hasPortfolioRelated = true
				break
			}
		}
		assert.True(t, hasPortfolioRelated)
	})

	t.Run("English without portfolio", func(t *testing.T) {
		starters := builder.ConversationStarters(false, "en")

		assert.NotEmpty(t, starters)
		assert.Len(t, starters, 4)

		// Should contain beginner-related starters
		hasBeginnerRelated := false
		for _, s := range starters {
			if strings.Contains(s, "start") || strings.Contains(s, "diversification") {
				hasBeginnerRelated = true
				break
			}
		}
		assert.True(t, hasBeginnerRelated)
	})

	t.Run("Spanish with portfolio", func(t *testing.T) {
		starters := builder.ConversationStarters(true, "es")

		assert.NotEmpty(t, starters)
		assert.Len(t, starters, 4)

		// Should be in Spanish
		hasSpanish := false
		for _, s := range starters {
			if strings.Contains(s, "portafolio") || strings.Contains(s, "diversificado") {
				hasSpanish = true
				break
			}
		}
		assert.True(t, hasSpanish)
	})

	t.Run("Spanish without portfolio", func(t *testing.T) {
		starters := builder.ConversationStarters(false, "es")

		assert.NotEmpty(t, starters)
		assert.Len(t, starters, 4)

		// Should be in Spanish
		hasSpanish := false
		for _, s := range starters {
			if strings.Contains(s, "empiezo") || strings.Contains(s, "invertir") {
				hasSpanish = true
				break
			}
		}
		assert.True(t, hasSpanish)
	})
}

func TestFinancialAdvisorSystemPrompt(t *testing.T) {
	// Verify the system prompt contains key elements
	assert.Contains(t, FinancialAdvisorSystemPrompt, "WealthScope AI")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Capabilities")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Limitations")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "NOT a licensed financial advisor")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Response Guidelines")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Ethical Guidelines")
}

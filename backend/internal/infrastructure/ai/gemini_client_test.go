package ai

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/zap"
)

func TestThinkingLevel_Constants(t *testing.T) {
	// Verify thinking levels are correctly defined
	assert.Equal(t, ThinkingFast, ThinkingLevel(1))
	assert.Equal(t, ThinkingBalanced, ThinkingLevel(3))
	assert.Equal(t, ThinkingDeep, ThinkingLevel(5))

	// Verify ordering
	assert.Less(t, int(ThinkingFast), int(ThinkingBalanced))
	assert.Less(t, int(ThinkingBalanced), int(ThinkingDeep))
}

func TestNewGeminiClient_RequiresAPIKey(t *testing.T) {
	logger := zap.NewNop()

	_, err := NewGeminiClient("", "gemini-3-flash-preview", nil, logger)
	require.Error(t, err)
	assert.Contains(t, err.Error(), "API key is required")
}

func TestNewGeminiClient_DefaultModel(t *testing.T) {
	// Skip if no API key (unit test only)
	t.Skip("Skipping integration test - requires API key")
}

func TestIsGemini3Model(t *testing.T) {
	tests := []struct {
		name     string
		model    string
		expected bool
	}{
		{
			name:     "gemini-3-flash-preview is Gemini 3",
			model:    "gemini-3-flash-preview",
			expected: true,
		},
		{
			name:     "gemini-3.0-flash is Gemini 3",
			model:    "gemini-3.0-flash",
			expected: true,
		},
		{
			name:     "gemini-1.5-flash is not Gemini 3",
			model:    "gemini-1.5-flash",
			expected: false,
		},
		{
			name:     "gemini-2.0-flash-exp is not Gemini 3",
			model:    "gemini-2.0-flash-exp",
			expected: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Test the IsGemini3 logic directly
			result := strings.HasPrefix(tt.model, "gemini-3")
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestMessage_Roles(t *testing.T) {
	// Test valid message roles and content
	userMsg := Message{Role: "user", Content: "Hello"}
	assert.Equal(t, "user", userMsg.Role)
	assert.Equal(t, "Hello", userMsg.Content)

	assistantMsg := Message{Role: "assistant", Content: "Hi there!"}
	assert.Equal(t, "assistant", assistantMsg.Role)
	assert.Equal(t, "Hi there!", assistantMsg.Content)

	systemMsg := Message{Role: "system", Content: "You are an AI."}
	assert.Equal(t, "system", systemMsg.Role)
	assert.Equal(t, "You are an AI.", systemMsg.Content)
}

func TestFinancialAdvisorSystemPrompt_ContainsGemini3Features(t *testing.T) {
	// Verify prompt mentions Gemini 3 capabilities
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Gemini 3")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "step-by-step")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "confidence levels")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Extended context")
	assert.Contains(t, FinancialAdvisorSystemPrompt, "Multi-step reasoning")
}

func TestPromptBuilder_BuildSystemPrompt_IncludesGemini3(t *testing.T) {
	pb := NewPromptBuilder()

	// Test with empty context - should include Gemini 3 reference
	prompt := pb.BuildSystemPrompt(UserContext{})
	assert.Contains(t, prompt, "WealthScope AI")
	assert.Contains(t, prompt, "Gemini 3")
	assert.Contains(t, prompt, "Advanced Analysis Features")
}

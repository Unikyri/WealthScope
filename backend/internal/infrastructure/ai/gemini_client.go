package ai

import (
	"context"
	"fmt"
	"iter"
	"strings"

	"go.uber.org/zap"
	"google.golang.org/genai"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

// ThinkingLevel configures reasoning depth for Gemini 3.
// Higher levels enable more complex multi-step reasoning.
type ThinkingLevel int

const (
	// ThinkingFast provides quick responses for simple queries.
	ThinkingFast ThinkingLevel = 1
	// ThinkingBalanced provides balanced analysis for general use.
	ThinkingBalanced ThinkingLevel = 3
	// ThinkingDeep provides complex analysis for scenarios like What-If.
	ThinkingDeep ThinkingLevel = 5
)

// Message represents a chat message for the AI.
type Message struct {
	Role    string // "user", "assistant", "system"
	Content string
}

// GeminiClient wraps the Google Gemini API client.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type GeminiClient struct {
	client      *genai.Client
	model       string
	rateLimiter *marketdata.RateLimiter
	logger      *zap.Logger
}

// NewGeminiClient creates a new Gemini API client.
func NewGeminiClient(apiKey, model string, rateLimiter *marketdata.RateLimiter, logger *zap.Logger) (*GeminiClient, error) {
	if apiKey == "" {
		return nil, fmt.Errorf("gemini: API key is required")
	}
	if model == "" {
		model = "gemini-3-flash-preview"
	}
	if logger == nil {
		logger = zap.NewNop()
	}

	// Warn if not using Gemini 3 model (required for hackathon)
	if !strings.HasPrefix(model, "gemini-3") {
		logger.Warn("using non-Gemini-3 model - hackathon requires Gemini 3",
			zap.String("model", model),
			zap.String("recommended", "gemini-3-flash-preview"))
	}

	ctx := context.Background()
	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		return nil, fmt.Errorf("gemini: failed to create client: %w", err)
	}

	logger.Info("Gemini client initialized",
		zap.String("model", model),
		zap.Bool("is_gemini_3", strings.HasPrefix(model, "gemini-3")))

	return &GeminiClient{
		client:      client,
		model:       model,
		rateLimiter: rateLimiter,
		logger:      logger,
	}, nil
}

// Chat sends a message to Gemini and returns the response.
func (c *GeminiClient) Chat(ctx context.Context, messages []Message, systemPrompt string) (string, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return "", fmt.Errorf("gemini: rate limit wait: %w", err)
		}
	}

	// Build conversation contents
	contents := c.buildContents(messages)

	// Build config with system instruction
	config := &genai.GenerateContentConfig{}
	if systemPrompt != "" {
		config.SystemInstruction = &genai.Content{
			Parts: []*genai.Part{
				{Text: systemPrompt},
			},
		}
	}

	c.logger.Debug("sending chat request to Gemini",
		zap.String("model", c.model),
		zap.Int("messages", len(messages)))

	// Call the API
	result, err := c.client.Models.GenerateContent(ctx, c.model, contents, config)
	if err != nil {
		c.logger.Error("gemini API error", zap.Error(err))
		return "", fmt.Errorf("gemini: generate content failed: %w", err)
	}

	// Extract text from response
	text := result.Text()
	if text == "" {
		return "", fmt.Errorf("gemini: empty response")
	}

	c.logger.Debug("received response from Gemini",
		zap.Int("response_length", len(text)))

	return text, nil
}

// ChatStream sends a message to Gemini and returns a channel for streaming responses.
func (c *GeminiClient) ChatStream(ctx context.Context, messages []Message, systemPrompt string) (<-chan string, <-chan error) {
	textChan := make(chan string, 100)
	errChan := make(chan error, 1)

	go func() {
		defer close(textChan)
		defer close(errChan)

		if c.rateLimiter != nil {
			if err := c.rateLimiter.Wait(ctx); err != nil {
				errChan <- fmt.Errorf("gemini: rate limit wait: %w", err)
				return
			}
		}

		// Build conversation contents
		contents := c.buildContents(messages)

		// Build config with system instruction
		config := &genai.GenerateContentConfig{}
		if systemPrompt != "" {
			config.SystemInstruction = &genai.Content{
				Parts: []*genai.Part{
					{Text: systemPrompt},
				},
			}
		}

		c.logger.Debug("starting streaming chat request to Gemini",
			zap.String("model", c.model),
			zap.Int("messages", len(messages)))

		// Call the streaming API
		stream := c.client.Models.GenerateContentStream(ctx, c.model, contents, config)
		c.processStream(stream, textChan, errChan)
	}()

	return textChan, errChan
}

// processStream handles the streaming response from Gemini.
func (c *GeminiClient) processStream(stream iter.Seq2[*genai.GenerateContentResponse, error], textChan chan<- string, errChan chan<- error) {
	for resp, err := range stream {
		if err != nil {
			c.logger.Error("gemini stream error", zap.Error(err))
			errChan <- fmt.Errorf("gemini: stream error: %w", err)
			return
		}

		// Extract text from response chunk
		if resp != nil && len(resp.Candidates) > 0 {
			candidate := resp.Candidates[0]
			if candidate.Content != nil {
				for _, part := range candidate.Content.Parts {
					if part.Text != "" {
						textChan <- part.Text
					}
				}
			}
		}
	}
}

// buildContents converts Message slice to Gemini Content format.
func (c *GeminiClient) buildContents(messages []Message) []*genai.Content {
	contents := make([]*genai.Content, 0, len(messages))

	for _, msg := range messages {
		role := msg.Role
		// Map our roles to Gemini roles
		if role == "assistant" {
			role = "model"
		}
		// Skip system messages in contents (they go in SystemInstruction)
		if role == "system" {
			continue
		}

		contents = append(contents, &genai.Content{
			Role: role,
			Parts: []*genai.Part{
				{Text: msg.Content},
			},
		})
	}

	return contents
}

// AnalyzeImage sends an image to Gemini Vision for analysis.
// This method supports multimodal content (image + text prompt).
// Supported MIME types: image/jpeg, image/png, image/webp, image/gif, application/pdf
func (c *GeminiClient) AnalyzeImage(ctx context.Context, imageData []byte, mimeType, prompt string) (string, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return "", fmt.Errorf("gemini: rate limit wait: %w", err)
		}
	}

	if len(imageData) == 0 {
		return "", fmt.Errorf("gemini: image data is empty")
	}

	c.logger.Debug("sending image analysis request to Gemini",
		zap.String("model", c.model),
		zap.String("mime_type", mimeType),
		zap.Int("image_size", len(imageData)),
		zap.Int("prompt_length", len(prompt)))

	// Build multimodal content with image and text
	contents := []*genai.Content{{
		Role: "user",
		Parts: []*genai.Part{
			{
				InlineData: &genai.Blob{
					MIMEType: mimeType,
					Data:     imageData,
				},
			},
			{Text: prompt},
		},
	}}

	// Call the API
	result, err := c.client.Models.GenerateContent(ctx, c.model, contents, nil)
	if err != nil {
		c.logger.Error("gemini vision API error", zap.Error(err))
		return "", fmt.Errorf("gemini: vision analysis failed: %w", err)
	}

	// Extract text from response
	text := result.Text()
	if text == "" {
		return "", fmt.Errorf("gemini: empty vision response")
	}

	c.logger.Debug("received vision response from Gemini",
		zap.Int("response_length", len(text)))

	return text, nil
}

// AnalyzeImageWithSystemPrompt sends an image to Gemini Vision with a system instruction.
func (c *GeminiClient) AnalyzeImageWithSystemPrompt(ctx context.Context, imageData []byte, mimeType, prompt, systemPrompt string) (string, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return "", fmt.Errorf("gemini: rate limit wait: %w", err)
		}
	}

	if len(imageData) == 0 {
		return "", fmt.Errorf("gemini: image data is empty")
	}

	c.logger.Debug("sending image analysis request to Gemini with system prompt",
		zap.String("model", c.model),
		zap.String("mime_type", mimeType),
		zap.Int("image_size", len(imageData)))

	// Build multimodal content with image and text
	contents := []*genai.Content{{
		Role: "user",
		Parts: []*genai.Part{
			{
				InlineData: &genai.Blob{
					MIMEType: mimeType,
					Data:     imageData,
				},
			},
			{Text: prompt},
		},
	}}

	// Build config with system instruction
	config := &genai.GenerateContentConfig{}
	if systemPrompt != "" {
		config.SystemInstruction = &genai.Content{
			Parts: []*genai.Part{
				{Text: systemPrompt},
			},
		}
	}

	// Call the API
	result, err := c.client.Models.GenerateContent(ctx, c.model, contents, config)
	if err != nil {
		c.logger.Error("gemini vision API error", zap.Error(err))
		return "", fmt.Errorf("gemini: vision analysis failed: %w", err)
	}

	// Extract text from response
	text := result.Text()
	if text == "" {
		return "", fmt.Errorf("gemini: empty vision response")
	}

	c.logger.Debug("received vision response from Gemini",
		zap.Int("response_length", len(text)))

	return text, nil
}

// Close closes the Gemini client.
// Note: The genai.Client doesn't have a Close method, but we keep this
// for interface consistency and future cleanup needs.
func (c *GeminiClient) Close() error {
	// genai.Client doesn't require explicit closing
	return nil
}

// Model returns the model name being used.
func (c *GeminiClient) Model() string {
	return c.model
}

// GenerateWithThinking uses Gemini 3 thinking levels for complex reasoning.
// Higher thinking levels enable deeper multi-step analysis suitable for
// financial scenarios like What-If simulations and portfolio optimization.
func (c *GeminiClient) GenerateWithThinking(
	ctx context.Context,
	prompt string,
	systemPrompt string,
	thinkingLevel ThinkingLevel,
) (string, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return "", fmt.Errorf("gemini: rate limit wait: %w", err)
		}
	}

	c.logger.Debug("sending request with thinking level",
		zap.String("model", c.model),
		zap.Int("thinking_level", int(thinkingLevel)),
		zap.Int("prompt_length", len(prompt)))

	// Build content
	contents := []*genai.Content{{
		Role: "user",
		Parts: []*genai.Part{
			{Text: prompt},
		},
	}}

	// Build config with system instruction and thinking level
	config := &genai.GenerateContentConfig{
		// Temperature adjusted based on thinking level:
		// Lower for deeper analysis, higher for creative responses
		Temperature: genai.Ptr(float32(0.9 - (float32(thinkingLevel) * 0.1))),
		// TopP for nucleus sampling
		TopP: genai.Ptr(float32(0.95)),
		// TopK for diverse token selection
		TopK: genai.Ptr(float32(40)),
	}

	if systemPrompt != "" {
		// Include thinking level guidance in system prompt
		enhancedPrompt := fmt.Sprintf(`%s

REASONING DEPTH: Level %d
- Think step-by-step when analyzing
- Consider multiple perspectives
- Provide confidence levels for predictions
- Show your reasoning process when appropriate`, systemPrompt, thinkingLevel)

		config.SystemInstruction = &genai.Content{
			Parts: []*genai.Part{
				{Text: enhancedPrompt},
			},
		}
	}

	// Call the API
	result, err := c.client.Models.GenerateContent(ctx, c.model, contents, config)
	if err != nil {
		c.logger.Error("gemini thinking API error", zap.Error(err))
		return "", fmt.Errorf("gemini: thinking generation failed: %w", err)
	}

	// Extract text from response
	text := result.Text()
	if text == "" {
		return "", fmt.Errorf("gemini: empty thinking response")
	}

	c.logger.Debug("received thinking response from Gemini",
		zap.Int("response_length", len(text)),
		zap.Int("thinking_level", int(thinkingLevel)))

	return text, nil
}

// IsGemini3 returns true if the client is using a Gemini 3 model.
func (c *GeminiClient) IsGemini3() bool {
	return strings.HasPrefix(c.model, "gemini-3")
}

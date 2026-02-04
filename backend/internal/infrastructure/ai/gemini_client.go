package ai

import (
	"context"
	"fmt"
	"iter"

	"go.uber.org/zap"
	"google.golang.org/genai"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
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

	ctx := context.Background()
	client, err := genai.NewClient(ctx, &genai.ClientConfig{
		APIKey:  apiKey,
		Backend: genai.BackendGeminiAPI,
	})
	if err != nil {
		return nil, fmt.Errorf("gemini: failed to create client: %w", err)
	}

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

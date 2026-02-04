package services

import (
	"context"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
)

// ChatRequest represents a request to chat with the AI.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ChatRequest struct {
	UserID         uuid.UUID
	ConversationID *uuid.UUID // Optional, creates new if nil
	Message        string
	UserContext    ai.UserContext // Portfolio context for personalized responses
}

// ChatResponse represents the response from the AI.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ChatResponse struct {
	ConversationID uuid.UUID        `json:"conversation_id"`
	UserMessage    entities.Message `json:"user_message"`
	AIMessage      entities.Message `json:"ai_message"`
}

// ConversationWithMessages represents a conversation with its messages.
type ConversationWithMessages struct {
	Conversation entities.Conversation `json:"conversation"`
	Messages     []entities.Message    `json:"messages"`
}

// AIService handles AI chat functionality with conversation management.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AIService struct {
	geminiClient       *ai.GeminiClient
	promptBuilder      *ai.PromptBuilder
	conversationRepo   repositories.ConversationRepository
	messageRepo        repositories.MessageRepository
	maxConversations   int
	maxMessagesPerConv int
	logger             *zap.Logger
}

// NewAIService creates a new AIService.
func NewAIService(
	geminiClient *ai.GeminiClient,
	promptBuilder *ai.PromptBuilder,
	conversationRepo repositories.ConversationRepository,
	messageRepo repositories.MessageRepository,
	maxConversations int,
	maxMessagesPerConv int,
	logger *zap.Logger,
) *AIService {
	if logger == nil {
		logger = zap.NewNop()
	}
	if maxConversations <= 0 {
		maxConversations = 50
	}
	if maxMessagesPerConv <= 0 {
		maxMessagesPerConv = 100
	}

	return &AIService{
		geminiClient:       geminiClient,
		promptBuilder:      promptBuilder,
		conversationRepo:   conversationRepo,
		messageRepo:        messageRepo,
		maxConversations:   maxConversations,
		maxMessagesPerConv: maxMessagesPerConv,
		logger:             logger,
	}
}

// Chat sends a message to the AI and returns the response.
func (s *AIService) Chat(ctx context.Context, req ChatRequest) (*ChatResponse, error) {
	var conversation *entities.Conversation

	// Get or create conversation
	if req.ConversationID != nil {
		conv, err := s.conversationRepo.GetByID(ctx, *req.ConversationID, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("get conversation: %w", err)
		}
		if conv == nil {
			return nil, fmt.Errorf("conversation not found")
		}
		conversation = conv
	} else {
		// Check conversation limit
		count, err := s.conversationRepo.CountByUser(ctx, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("count conversations: %w", err)
		}
		if count >= s.maxConversations {
			return nil, fmt.Errorf("maximum conversations limit reached (%d)", s.maxConversations)
		}

		// Create new conversation
		conversation = entities.NewConversation(req.UserID, "")
		if createErr := s.conversationRepo.Create(ctx, conversation); createErr != nil {
			return nil, fmt.Errorf("create conversation: %w", createErr)
		}
	}

	// Check message limit
	msgCount, countErr := s.messageRepo.CountByConversation(ctx, conversation.ID)
	if countErr != nil {
		return nil, fmt.Errorf("count messages: %w", countErr)
	}
	if msgCount >= s.maxMessagesPerConv {
		return nil, fmt.Errorf("maximum messages limit reached (%d)", s.maxMessagesPerConv)
	}

	// Save user message
	userMsg := entities.NewUserMessage(conversation.ID, req.Message)
	if saveErr := s.messageRepo.Create(ctx, userMsg); saveErr != nil {
		return nil, fmt.Errorf("save user message: %w", saveErr)
	}

	// Get conversation history for context
	history, err := s.messageRepo.GetByConversation(ctx, conversation.ID, s.maxMessagesPerConv)
	if err != nil {
		return nil, fmt.Errorf("get message history: %w", err)
	}

	// Convert to AI message format
	aiMessages := make([]ai.Message, len(history))
	for i, msg := range history {
		aiMessages[i] = ai.Message{
			Role:    msg.Role,
			Content: msg.Content,
		}
	}

	// Build system prompt with user context
	systemPrompt := s.promptBuilder.BuildSystemPrompt(req.UserContext)

	// Call Gemini API
	response, err := s.geminiClient.Chat(ctx, aiMessages, systemPrompt)
	if err != nil {
		s.logger.Error("Gemini chat failed", zap.Error(err))
		return nil, fmt.Errorf("AI chat failed: %w", err)
	}

	// Save AI response
	aiMsg := entities.NewAssistantMessage(conversation.ID, response)
	if err := s.messageRepo.Create(ctx, aiMsg); err != nil {
		return nil, fmt.Errorf("save AI message: %w", err)
	}

	// Update conversation title if it's a new conversation (first message)
	if msgCount == 0 {
		title := s.generateTitle(req.Message)
		if err := s.conversationRepo.UpdateTitle(ctx, conversation.ID, req.UserID, title); err != nil {
			s.logger.Warn("failed to update conversation title", zap.Error(err))
		}
	}

	return &ChatResponse{
		ConversationID: conversation.ID,
		UserMessage:    *userMsg,
		AIMessage:      *aiMsg,
	}, nil
}

// generateTitle creates a conversation title from the first message.
func (s *AIService) generateTitle(message string) string {
	// Truncate message for title
	title := strings.TrimSpace(message)
	if len(title) > 50 {
		title = title[:47] + "..."
	}
	return title
}

// CreateConversation creates a new conversation.
func (s *AIService) CreateConversation(ctx context.Context, userID uuid.UUID, title string) (*entities.Conversation, error) {
	// Check conversation limit
	count, err := s.conversationRepo.CountByUser(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("count conversations: %w", err)
	}
	if count >= s.maxConversations {
		return nil, fmt.Errorf("maximum conversations limit reached (%d)", s.maxConversations)
	}

	conversation := entities.NewConversation(userID, title)
	if err := s.conversationRepo.Create(ctx, conversation); err != nil {
		return nil, fmt.Errorf("create conversation: %w", err)
	}

	return conversation, nil
}

// GetConversation retrieves a conversation with its messages.
func (s *AIService) GetConversation(ctx context.Context, convID, userID uuid.UUID) (*ConversationWithMessages, error) {
	conversation, err := s.conversationRepo.GetByID(ctx, convID, userID)
	if err != nil {
		return nil, fmt.Errorf("get conversation: %w", err)
	}
	if conversation == nil {
		return nil, nil
	}

	messages, err := s.messageRepo.GetByConversation(ctx, convID, s.maxMessagesPerConv)
	if err != nil {
		return nil, fmt.Errorf("get messages: %w", err)
	}

	return &ConversationWithMessages{
		Conversation: *conversation,
		Messages:     messages,
	}, nil
}

// ListConversations lists user's conversations with pagination.
func (s *AIService) ListConversations(ctx context.Context, userID uuid.UUID, limit, offset int) ([]entities.Conversation, int, error) {
	if limit <= 0 {
		limit = 20
	}
	if limit > 100 {
		limit = 100
	}

	conversations, err := s.conversationRepo.ListByUser(ctx, userID, limit, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("list conversations: %w", err)
	}

	total, err := s.conversationRepo.CountByUser(ctx, userID)
	if err != nil {
		return nil, 0, fmt.Errorf("count conversations: %w", err)
	}

	return conversations, total, nil
}

// UpdateConversationTitle updates a conversation's title.
func (s *AIService) UpdateConversationTitle(ctx context.Context, convID, userID uuid.UUID, title string) error {
	if strings.TrimSpace(title) == "" {
		return fmt.Errorf("title cannot be empty")
	}
	return s.conversationRepo.UpdateTitle(ctx, convID, userID, title)
}

// DeleteConversation deletes a conversation and all its messages.
func (s *AIService) DeleteConversation(ctx context.Context, convID, userID uuid.UUID) error {
	// Messages are deleted via CASCADE in the database
	return s.conversationRepo.Delete(ctx, convID, userID)
}

// GetWelcomeMessage returns a personalized welcome message.
func (s *AIService) GetWelcomeMessage(userCtx ai.UserContext) string {
	return s.promptBuilder.BuildWelcomeMessage(userCtx)
}

// GetConversationStarters returns suggested conversation starters.
func (s *AIService) GetConversationStarters(hasPortfolio bool, lang string) []string {
	return s.promptBuilder.ConversationStarters(hasPortfolio, lang)
}

// IsEnabled returns true if the AI service is properly configured.
func (s *AIService) IsEnabled() bool {
	return s.geminiClient != nil
}

// Close closes the AI service and its dependencies.
func (s *AIService) Close() error {
	if s.geminiClient != nil {
		return s.geminiClient.Close()
	}
	return nil
}

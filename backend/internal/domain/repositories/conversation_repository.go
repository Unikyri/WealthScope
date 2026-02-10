package repositories

import (
	"context"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// ConversationRepository defines the interface for conversation persistence.
type ConversationRepository interface {
	// Create creates a new conversation.
	Create(ctx context.Context, conv *entities.Conversation) error

	// GetByID retrieves a conversation by ID, ensuring it belongs to the user.
	GetByID(ctx context.Context, id, userID uuid.UUID) (*entities.Conversation, error)

	// ListByUser retrieves all conversations for a user with pagination.
	ListByUser(ctx context.Context, userID uuid.UUID, limit, offset int) ([]entities.Conversation, error)

	// CountByUser returns the total count of conversations for a user.
	CountByUser(ctx context.Context, userID uuid.UUID) (int, error)

	// UpdateTitle updates the title of a conversation.
	UpdateTitle(ctx context.Context, id, userID uuid.UUID, title string) error

	// Delete deletes a conversation by ID, ensuring it belongs to the user.
	Delete(ctx context.Context, id, userID uuid.UUID) error
}

// MessageRepository defines the interface for message persistence.
type MessageRepository interface {
	// Create creates a new message.
	Create(ctx context.Context, msg *entities.Message) error

	// GetByConversation retrieves messages for a conversation with limit.
	GetByConversation(ctx context.Context, conversationID uuid.UUID, limit int) ([]entities.Message, error)

	// CountByConversation returns the total count of messages in a conversation.
	CountByConversation(ctx context.Context, conversationID uuid.UUID) (int, error)

	// DeleteByConversation deletes all messages for a conversation.
	DeleteByConversation(ctx context.Context, conversationID uuid.UUID) error
}

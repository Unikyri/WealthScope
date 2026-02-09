package entities

import (
	"time"

	"github.com/google/uuid"
)

// Conversation represents an AI chat conversation.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type Conversation struct {
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Title     string    `json:"title"`
	ID        uuid.UUID `json:"id"`
	UserID    uuid.UUID `json:"user_id"`
}

// NewConversation creates a new conversation with default values.
func NewConversation(userID uuid.UUID, title string) *Conversation {
	now := time.Now().UTC()
	if title == "" {
		title = "New Conversation"
	}
	return &Conversation{
		ID:        uuid.New(),
		UserID:    userID,
		Title:     title,
		CreatedAt: now,
		UpdatedAt: now,
	}
}

// Message represents a single message in a conversation.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type Message struct {
	CreatedAt      time.Time `json:"created_at"`
	Role           string    `json:"role"`
	Content        string    `json:"content"`
	ID             uuid.UUID `json:"id"`
	ConversationID uuid.UUID `json:"conversation_id"`
}

// MessageRole constants for message types.
const (
	MessageRoleUser      = "user"
	MessageRoleAssistant = "assistant"
	MessageRoleSystem    = "system"
)

// NewMessage creates a new message with default values.
func NewMessage(conversationID uuid.UUID, role, content string) *Message {
	return &Message{
		ID:             uuid.New(),
		ConversationID: conversationID,
		Role:           role,
		Content:        content,
		CreatedAt:      time.Now().UTC(),
	}
}

// NewUserMessage creates a new user message.
func NewUserMessage(conversationID uuid.UUID, content string) *Message {
	return NewMessage(conversationID, MessageRoleUser, content)
}

// NewAssistantMessage creates a new assistant message.
func NewAssistantMessage(conversationID uuid.UUID, content string) *Message {
	return NewMessage(conversationID, MessageRoleAssistant, content)
}

// IsValidRole checks if the role is valid.
func IsValidRole(role string) bool {
	return role == MessageRoleUser || role == MessageRoleAssistant || role == MessageRoleSystem
}

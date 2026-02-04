package entities

import (
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestNewConversation(t *testing.T) {
	t.Run("creates conversation with title", func(t *testing.T) {
		userID := uuid.New()
		title := "My Conversation"

		conv := NewConversation(userID, title)

		assert.NotEqual(t, uuid.Nil, conv.ID)
		assert.Equal(t, userID, conv.UserID)
		assert.Equal(t, title, conv.Title)
		assert.False(t, conv.CreatedAt.IsZero())
		assert.False(t, conv.UpdatedAt.IsZero())
		assert.True(t, conv.CreatedAt.Before(time.Now().Add(time.Second)))
	})

	t.Run("creates conversation with default title", func(t *testing.T) {
		userID := uuid.New()

		conv := NewConversation(userID, "")

		assert.Equal(t, "New Conversation", conv.Title)
	})
}

func TestNewMessage(t *testing.T) {
	t.Run("creates message with role and content", func(t *testing.T) {
		convID := uuid.New()
		role := "user"
		content := "Hello, AI!"

		msg := NewMessage(convID, role, content)

		assert.NotEqual(t, uuid.Nil, msg.ID)
		assert.Equal(t, convID, msg.ConversationID)
		assert.Equal(t, role, msg.Role)
		assert.Equal(t, content, msg.Content)
		assert.False(t, msg.CreatedAt.IsZero())
	})
}

func TestNewUserMessage(t *testing.T) {
	convID := uuid.New()
	content := "User question"

	msg := NewUserMessage(convID, content)

	assert.Equal(t, MessageRoleUser, msg.Role)
	assert.Equal(t, content, msg.Content)
	assert.Equal(t, convID, msg.ConversationID)
}

func TestNewAssistantMessage(t *testing.T) {
	convID := uuid.New()
	content := "AI response"

	msg := NewAssistantMessage(convID, content)

	assert.Equal(t, MessageRoleAssistant, msg.Role)
	assert.Equal(t, content, msg.Content)
	assert.Equal(t, convID, msg.ConversationID)
}

func TestIsValidRole(t *testing.T) {
	tests := []struct {
		role     string
		expected bool
	}{
		{MessageRoleUser, true},
		{MessageRoleAssistant, true},
		{MessageRoleSystem, true},
		{"user", true},
		{"assistant", true},
		{"system", true},
		{"invalid", false},
		{"", false},
		{"admin", false},
	}

	for _, tt := range tests {
		t.Run(tt.role, func(t *testing.T) {
			assert.Equal(t, tt.expected, IsValidRole(tt.role))
		})
	}
}

func TestMessageRoleConstants(t *testing.T) {
	assert.Equal(t, "user", MessageRoleUser)
	assert.Equal(t, "assistant", MessageRoleAssistant)
	assert.Equal(t, "system", MessageRoleSystem)
}

package repositories

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// MessageModel is the GORM model for messages table.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type MessageModel struct {
	ID             uuid.UUID `gorm:"type:uuid;primaryKey"`
	ConversationID uuid.UUID `gorm:"type:uuid;not null;index"`
	Role           string    `gorm:"type:varchar(20);not null"`
	Content        string    `gorm:"type:text;not null"`
	CreatedAt      time.Time `gorm:"not null"`
}

// TableName returns the table name for MessageModel.
func (MessageModel) TableName() string {
	return "messages"
}

// ToEntity converts MessageModel to entities.Message.
func (m *MessageModel) ToEntity() *entities.Message {
	return &entities.Message{
		ID:             m.ID,
		ConversationID: m.ConversationID,
		Role:           m.Role,
		Content:        m.Content,
		CreatedAt:      m.CreatedAt,
	}
}

// FromMessageEntity creates a MessageModel from an entity.
func FromMessageEntity(e *entities.Message) *MessageModel {
	return &MessageModel{
		ID:             e.ID,
		ConversationID: e.ConversationID,
		Role:           e.Role,
		Content:        e.Content,
		CreatedAt:      e.CreatedAt,
	}
}

// PostgresMessageRepository implements repositories.MessageRepository.
type PostgresMessageRepository struct {
	db *gorm.DB
}

// NewPostgresMessageRepository creates a new PostgresMessageRepository.
func NewPostgresMessageRepository(db *gorm.DB) repositories.MessageRepository {
	return &PostgresMessageRepository{db: db}
}

// Create creates a new message.
func (r *PostgresMessageRepository) Create(ctx context.Context, msg *entities.Message) error {
	model := FromMessageEntity(msg)
	result := r.db.WithContext(ctx).Create(model)
	if result.Error != nil {
		return fmt.Errorf("create message: %w", result.Error)
	}
	return nil
}

// GetByConversation retrieves messages for a conversation with limit.
// Messages are returned in chronological order (oldest first).
func (r *PostgresMessageRepository) GetByConversation(ctx context.Context, conversationID uuid.UUID, limit int) ([]entities.Message, error) {
	var models []MessageModel
	result := r.db.WithContext(ctx).
		Where("conversation_id = ?", conversationID).
		Order("created_at ASC").
		Limit(limit).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("get messages: %w", result.Error)
	}

	messages := make([]entities.Message, len(models))
	for i, m := range models {
		messages[i] = *m.ToEntity()
	}

	return messages, nil
}

// CountByConversation returns the total count of messages in a conversation.
func (r *PostgresMessageRepository) CountByConversation(ctx context.Context, conversationID uuid.UUID) (int, error) {
	var count int64
	result := r.db.WithContext(ctx).Model(&MessageModel{}).Where("conversation_id = ?", conversationID).Count(&count)
	if result.Error != nil {
		return 0, fmt.Errorf("count messages: %w", result.Error)
	}
	return int(count), nil
}

// DeleteByConversation deletes all messages for a conversation.
func (r *PostgresMessageRepository) DeleteByConversation(ctx context.Context, conversationID uuid.UUID) error {
	result := r.db.WithContext(ctx).Where("conversation_id = ?", conversationID).Delete(&MessageModel{})
	if result.Error != nil {
		return fmt.Errorf("delete messages: %w", result.Error)
	}
	return nil
}

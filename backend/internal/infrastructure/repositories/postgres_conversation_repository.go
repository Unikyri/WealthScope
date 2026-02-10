package repositories

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// ConversationModel is the GORM model for conversations table.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ConversationModel struct {
	CreatedAt time.Time `gorm:"not null"`
	UpdatedAt time.Time `gorm:"not null"`
	Title     string    `gorm:"type:varchar(255);not null"`
	ID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	UserID    uuid.UUID `gorm:"type:uuid;not null;index"`
}

// TableName returns the table name for ConversationModel.
func (ConversationModel) TableName() string {
	return "conversations"
}

// ToEntity converts ConversationModel to entities.Conversation.
func (m *ConversationModel) ToEntity() *entities.Conversation {
	return &entities.Conversation{
		ID:        m.ID,
		UserID:    m.UserID,
		Title:     m.Title,
		CreatedAt: m.CreatedAt,
		UpdatedAt: m.UpdatedAt,
	}
}

// FromConversationEntity creates a ConversationModel from an entity.
func FromConversationEntity(e *entities.Conversation) *ConversationModel {
	return &ConversationModel{
		ID:        e.ID,
		UserID:    e.UserID,
		Title:     e.Title,
		CreatedAt: e.CreatedAt,
		UpdatedAt: e.UpdatedAt,
	}
}

// PostgresConversationRepository implements repositories.ConversationRepository.
type PostgresConversationRepository struct {
	db *gorm.DB
}

// NewPostgresConversationRepository creates a new PostgresConversationRepository.
func NewPostgresConversationRepository(db *gorm.DB) repositories.ConversationRepository {
	return &PostgresConversationRepository{db: db}
}

// Create creates a new conversation.
func (r *PostgresConversationRepository) Create(ctx context.Context, conv *entities.Conversation) error {
	model := FromConversationEntity(conv)
	result := r.db.WithContext(ctx).Create(model)
	if result.Error != nil {
		return fmt.Errorf("create conversation: %w", result.Error)
	}
	return nil
}

// GetByID retrieves a conversation by ID, ensuring it belongs to the user.
func (r *PostgresConversationRepository) GetByID(ctx context.Context, id, userID uuid.UUID) (*entities.Conversation, error) {
	var model ConversationModel
	result := r.db.WithContext(ctx).Where("id = ? AND user_id = ?", id, userID).First(&model)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, fmt.Errorf("get conversation by id: %w", result.Error)
	}
	return model.ToEntity(), nil
}

// ListByUser retrieves all conversations for a user with pagination.
func (r *PostgresConversationRepository) ListByUser(ctx context.Context, userID uuid.UUID, limit, offset int) ([]entities.Conversation, error) {
	var models []ConversationModel
	result := r.db.WithContext(ctx).
		Where("user_id = ?", userID).
		Order("updated_at DESC").
		Limit(limit).
		Offset(offset).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("list conversations: %w", result.Error)
	}

	conversations := make([]entities.Conversation, len(models))
	for i, m := range models {
		conversations[i] = *m.ToEntity()
	}

	return conversations, nil
}

// CountByUser returns the total count of conversations for a user.
func (r *PostgresConversationRepository) CountByUser(ctx context.Context, userID uuid.UUID) (int, error) {
	var count int64
	result := r.db.WithContext(ctx).Model(&ConversationModel{}).Where("user_id = ?", userID).Count(&count)
	if result.Error != nil {
		return 0, fmt.Errorf("count conversations: %w", result.Error)
	}
	return int(count), nil
}

// UpdateTitle updates the title of a conversation.
func (r *PostgresConversationRepository) UpdateTitle(ctx context.Context, id, userID uuid.UUID, title string) error {
	result := r.db.WithContext(ctx).
		Model(&ConversationModel{}).
		Where("id = ? AND user_id = ?", id, userID).
		Updates(map[string]interface{}{
			"title":      title,
			"updated_at": time.Now().UTC(),
		})

	if result.Error != nil {
		return fmt.Errorf("update conversation title: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("conversation not found or not owned by user")
	}

	return nil
}

// Delete deletes a conversation by ID, ensuring it belongs to the user.
func (r *PostgresConversationRepository) Delete(ctx context.Context, id, userID uuid.UUID) error {
	result := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		Delete(&ConversationModel{})

	if result.Error != nil {
		return fmt.Errorf("delete conversation: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("conversation not found or not owned by user")
	}

	return nil
}

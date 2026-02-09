package repositories

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// InsightModel is the GORM model for insights table.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type InsightModel struct {
	CreatedAt      time.Time  `gorm:"type:timestamptz;not null;index:idx_insights_created_at"`
	ExpiresAt      *time.Time `gorm:"type:timestamptz"`
	ReadAt         *time.Time `gorm:"type:timestamptz"`
	Type           string     `gorm:"type:varchar(50);not null;index"`
	Title          string     `gorm:"type:varchar(255);not null"`
	Content        string     `gorm:"type:text;not null"`
	Priority       string     `gorm:"type:varchar(20);not null;default:'medium'"`
	Category       string     `gorm:"type:varchar(50);not null"`
	ActionItems    string     `gorm:"type:jsonb;default:'[]'"`
	RelatedSymbols string     `gorm:"type:jsonb;default:'[]'"`
	ID             uuid.UUID  `gorm:"type:uuid;primaryKey"`
	UserID         uuid.UUID  `gorm:"type:uuid;not null;index"`
}

// TableName returns the table name for InsightModel.
func (InsightModel) TableName() string {
	return "insights"
}

// ToEntity converts InsightModel to entities.Insight.
func (m *InsightModel) ToEntity() *entities.Insight {
	var actionItems []string
	var relatedSymbols []string

	// Parse JSON fields
	if m.ActionItems != "" && m.ActionItems != "[]" {
		_ = json.Unmarshal([]byte(m.ActionItems), &actionItems)
	}
	if m.RelatedSymbols != "" && m.RelatedSymbols != "[]" {
		_ = json.Unmarshal([]byte(m.RelatedSymbols), &relatedSymbols)
	}

	return &entities.Insight{
		ID:             m.ID,
		UserID:         m.UserID,
		Type:           entities.InsightType(m.Type),
		Title:          m.Title,
		Content:        m.Content,
		Priority:       entities.InsightPriority(m.Priority),
		Category:       entities.InsightCategory(m.Category),
		ActionItems:    actionItems,
		RelatedSymbols: relatedSymbols,
		ExpiresAt:      m.ExpiresAt,
		ReadAt:         m.ReadAt,
		CreatedAt:      m.CreatedAt,
	}
}

// FromInsightEntity creates an InsightModel from an entity.
func FromInsightEntity(e *entities.Insight) *InsightModel {
	actionItems, _ := json.Marshal(e.ActionItems)
	relatedSymbols, _ := json.Marshal(e.RelatedSymbols)

	return &InsightModel{
		ID:             e.ID,
		UserID:         e.UserID,
		Type:           string(e.Type),
		Title:          e.Title,
		Content:        e.Content,
		Priority:       string(e.Priority),
		Category:       string(e.Category),
		ActionItems:    string(actionItems),
		RelatedSymbols: string(relatedSymbols),
		ExpiresAt:      e.ExpiresAt,
		ReadAt:         e.ReadAt,
		CreatedAt:      e.CreatedAt,
	}
}

// PostgresInsightRepository implements repositories.InsightRepository.
type PostgresInsightRepository struct {
	db *gorm.DB
}

// NewPostgresInsightRepository creates a new PostgresInsightRepository.
func NewPostgresInsightRepository(db *gorm.DB) repositories.InsightRepository {
	return &PostgresInsightRepository{db: db}
}

// Create creates a new insight.
func (r *PostgresInsightRepository) Create(ctx context.Context, insight *entities.Insight) error {
	model := FromInsightEntity(insight)
	result := r.db.WithContext(ctx).Create(model)
	if result.Error != nil {
		return fmt.Errorf("create insight: %w", result.Error)
	}
	return nil
}

// GetByID retrieves an insight by ID, ensuring it belongs to the user.
func (r *PostgresInsightRepository) GetByID(ctx context.Context, id, userID uuid.UUID) (*entities.Insight, error) {
	var model InsightModel
	result := r.db.WithContext(ctx).Where("id = ? AND user_id = ?", id, userID).First(&model)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, fmt.Errorf("get insight by id: %w", result.Error)
	}
	return model.ToEntity(), nil
}

// ListByUser retrieves insights for a user with filters.
func (r *PostgresInsightRepository) ListByUser(ctx context.Context, userID uuid.UUID, filter entities.InsightFilter) ([]entities.Insight, error) {
	query := r.db.WithContext(ctx).Where("user_id = ?", userID)

	// Apply filters
	if filter.Type != nil {
		query = query.Where("type = ?", string(*filter.Type))
	}
	if filter.Category != nil {
		query = query.Where("category = ?", string(*filter.Category))
	}
	if filter.Priority != nil {
		query = query.Where("priority = ?", string(*filter.Priority))
	}
	if filter.UnreadOnly {
		query = query.Where("read_at IS NULL")
	}

	// Apply pagination
	if filter.Limit > 0 {
		query = query.Limit(filter.Limit)
	}
	if filter.Offset > 0 {
		query = query.Offset(filter.Offset)
	}

	// Order by created_at DESC (newest first)
	query = query.Order("created_at DESC")

	var models []InsightModel
	result := query.Find(&models)
	if result.Error != nil {
		return nil, fmt.Errorf("list insights: %w", result.Error)
	}

	insights := make([]entities.Insight, len(models))
	for i, m := range models {
		insights[i] = *m.ToEntity()
	}

	return insights, nil
}

// CountByUser returns the total count of insights matching the filter.
func (r *PostgresInsightRepository) CountByUser(ctx context.Context, userID uuid.UUID, filter entities.InsightFilter) (int, error) {
	query := r.db.WithContext(ctx).Model(&InsightModel{}).Where("user_id = ?", userID)

	// Apply filters (same as ListByUser but without pagination)
	if filter.Type != nil {
		query = query.Where("type = ?", string(*filter.Type))
	}
	if filter.Category != nil {
		query = query.Where("category = ?", string(*filter.Category))
	}
	if filter.Priority != nil {
		query = query.Where("priority = ?", string(*filter.Priority))
	}
	if filter.UnreadOnly {
		query = query.Where("read_at IS NULL")
	}

	var count int64
	result := query.Count(&count)
	if result.Error != nil {
		return 0, fmt.Errorf("count insights: %w", result.Error)
	}

	return int(count), nil
}

// GetUnreadCount returns the count of unread insights for a user.
func (r *PostgresInsightRepository) GetUnreadCount(ctx context.Context, userID uuid.UUID) (int, error) {
	var count int64
	result := r.db.WithContext(ctx).
		Model(&InsightModel{}).
		Where("user_id = ? AND read_at IS NULL", userID).
		Count(&count)

	if result.Error != nil {
		return 0, fmt.Errorf("count unread insights: %w", result.Error)
	}

	return int(count), nil
}

// MarkAsRead marks an insight as read.
func (r *PostgresInsightRepository) MarkAsRead(ctx context.Context, id, userID uuid.UUID) error {
	now := time.Now().UTC()
	result := r.db.WithContext(ctx).
		Model(&InsightModel{}).
		Where("id = ? AND user_id = ?", id, userID).
		Update("read_at", now)

	if result.Error != nil {
		return fmt.Errorf("mark insight as read: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("insight not found or not owned by user")
	}

	return nil
}

// GetTodaysBriefing retrieves today's daily briefing for a user.
func (r *PostgresInsightRepository) GetTodaysBriefing(ctx context.Context, userID uuid.UUID) (*entities.Insight, error) {
	// Get start of today (UTC)
	startOfDay := time.Now().UTC().Truncate(24 * time.Hour)

	var model InsightModel
	result := r.db.WithContext(ctx).
		Where("user_id = ? AND type = ? AND created_at >= ?",
			userID, string(entities.InsightTypeDailyBriefing), startOfDay).
		Order("created_at DESC").
		First(&model)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, fmt.Errorf("get today's briefing: %w", result.Error)
	}

	return model.ToEntity(), nil
}

// GetLatestByType retrieves the most recent insight of a specific type.
func (r *PostgresInsightRepository) GetLatestByType(ctx context.Context, userID uuid.UUID, insightType entities.InsightType) (*entities.Insight, error) {
	var model InsightModel
	result := r.db.WithContext(ctx).
		Where("user_id = ? AND type = ?", userID, string(insightType)).
		Order("created_at DESC").
		First(&model)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, fmt.Errorf("get latest insight by type: %w", result.Error)
	}

	return model.ToEntity(), nil
}

// DeleteExpired deletes all expired insights.
func (r *PostgresInsightRepository) DeleteExpired(ctx context.Context) (int, error) {
	now := time.Now().UTC()
	result := r.db.WithContext(ctx).
		Where("expires_at IS NOT NULL AND expires_at < ?", now).
		Delete(&InsightModel{})

	if result.Error != nil {
		return 0, fmt.Errorf("delete expired insights: %w", result.Error)
	}

	return int(result.RowsAffected), nil
}

// DeleteByUser deletes all insights for a user.
func (r *PostgresInsightRepository) DeleteByUser(ctx context.Context, userID uuid.UUID) error {
	result := r.db.WithContext(ctx).
		Where("user_id = ?", userID).
		Delete(&InsightModel{})

	if result.Error != nil {
		return fmt.Errorf("delete user insights: %w", result.Error)
	}

	return nil
}

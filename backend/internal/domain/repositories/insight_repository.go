package repositories

import (
	"context"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// InsightRepository defines the interface for insight persistence.
type InsightRepository interface {
	// Create creates a new insight.
	Create(ctx context.Context, insight *entities.Insight) error

	// GetByID retrieves an insight by ID, ensuring it belongs to the user.
	GetByID(ctx context.Context, id, userID uuid.UUID) (*entities.Insight, error)

	// ListByUser retrieves insights for a user with filters.
	ListByUser(ctx context.Context, userID uuid.UUID, filter entities.InsightFilter) ([]entities.Insight, error)

	// CountByUser returns the total count of insights matching the filter.
	CountByUser(ctx context.Context, userID uuid.UUID, filter entities.InsightFilter) (int, error)

	// GetUnreadCount returns the count of unread insights for a user.
	GetUnreadCount(ctx context.Context, userID uuid.UUID) (int, error)

	// MarkAsRead marks an insight as read.
	MarkAsRead(ctx context.Context, id, userID uuid.UUID) error

	// GetTodaysBriefing retrieves today's daily briefing for a user.
	GetTodaysBriefing(ctx context.Context, userID uuid.UUID) (*entities.Insight, error)

	// GetLatestByType retrieves the most recent insight of a specific type.
	GetLatestByType(ctx context.Context, userID uuid.UUID, insightType entities.InsightType) (*entities.Insight, error)

	// DeleteExpired deletes all expired insights.
	DeleteExpired(ctx context.Context) (int, error)

	// DeleteByUser deletes all insights for a user.
	DeleteByUser(ctx context.Context, userID uuid.UUID) error
}

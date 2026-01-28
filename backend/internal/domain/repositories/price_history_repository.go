package repositories

import (
	"context"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// PriceHistoryRepository defines the interface for persisting historical quotes.
type PriceHistoryRepository interface {
	Insert(ctx context.Context, price *entities.PriceHistory) error
}

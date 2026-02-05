package repositories

import (
	"context"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// PriceHistoryRepository defines the interface for persisting historical quotes.
type PriceHistoryRepository interface {
	Insert(ctx context.Context, price *entities.PriceHistory) error

	// GetBySymbolAndDateRange retrieves price history for a symbol within a date range.
	// Used for historical analysis in scenario simulations.
	GetBySymbolAndDateRange(ctx context.Context, symbol string, from, to time.Time) ([]entities.PriceHistory, error)
}

package repositories

import (
	"context"
	"fmt"
	"time"

	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

var _ repositories.PriceHistoryRepository = (*PostgresPriceHistoryRepository)(nil)

type PostgresPriceHistoryRepository struct {
	db *gorm.DB
}

func NewPostgresPriceHistoryRepository(db *gorm.DB) *PostgresPriceHistoryRepository {
	return &PostgresPriceHistoryRepository{db: db}
}

func (r *PostgresPriceHistoryRepository) Insert(ctx context.Context, price *entities.PriceHistory) error {
	model := &PriceHistoryModel{
		Symbol:        price.Symbol,
		Price:         price.Price,
		ChangeAmount:  price.ChangeAmount,
		ChangePercent: price.ChangePercent,
		MarketState:   price.MarketState,
		RecordedAt:    price.RecordedAt,
		Source:        price.Source,
	}
	if model.Source == "" {
		model.Source = "yahoo_finance"
	}

	if err := r.db.WithContext(ctx).Create(model).Error; err != nil {
		return fmt.Errorf("failed to insert price history: %w", err)
	}
	return nil
}

func (r *PostgresPriceHistoryRepository) GetBySymbolAndDateRange(
	ctx context.Context,
	symbol string,
	from, to time.Time,
) ([]entities.PriceHistory, error) {
	var models []PriceHistoryModel

	err := r.db.WithContext(ctx).
		Where("symbol = ? AND recorded_at >= ? AND recorded_at <= ?", symbol, from, to).
		Order("recorded_at ASC").
		Find(&models).Error
	if err != nil {
		return nil, fmt.Errorf("failed to get price history: %w", err)
	}

	result := make([]entities.PriceHistory, len(models))
	for i, m := range models {
		result[i] = entities.PriceHistory{
			Symbol:        m.Symbol,
			Price:         m.Price,
			ChangeAmount:  m.ChangeAmount,
			ChangePercent: m.ChangePercent,
			MarketState:   m.MarketState,
			RecordedAt:    m.RecordedAt,
			Source:        m.Source,
		}
	}

	return result, nil
}

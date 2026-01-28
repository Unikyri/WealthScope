package repositories

import (
	"context"
	"fmt"

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

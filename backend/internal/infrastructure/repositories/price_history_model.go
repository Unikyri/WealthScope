package repositories

import (
	"time"

	"gorm.io/gorm"
)

// PriceHistoryModel is the GORM model for the price_history table.
//
//nolint:govet // fieldalignment: keep explicit field ordering for clarity with GORM tags
type PriceHistoryModel struct {
	RecordedAt    time.Time      `gorm:"column:recorded_at;index"`
	CreatedAt     time.Time      `gorm:"column:created_at;autoCreateTime"`
	UpdatedAt     time.Time      `gorm:"column:updated_at;autoUpdateTime"`
	DeletedAt     gorm.DeletedAt `gorm:"index"`
	Symbol        string         `gorm:"column:symbol;size:20;not null;index"`
	MarketState   string         `gorm:"column:market_state;size:20"`
	Source        string         `gorm:"column:source;size:50;default:yahoo_finance"`
	ID            string         `gorm:"column:id;type:uuid;default:uuid_generate_v4();primaryKey"`
	Price         float64        `gorm:"column:price;type:decimal(18,4);not null"`
	ChangeAmount  float64        `gorm:"column:change_amount;type:decimal(18,4)"`
	ChangePercent float64        `gorm:"column:change_percent;type:decimal(8,4)"`
}

func (PriceHistoryModel) TableName() string { return "price_history" }

package repositories

import (
	"database/sql"
	"encoding/json"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// AssetModel is the GORM model for the assets table
type AssetModel struct {
	UpdatedAt     time.Time       `gorm:"column:updated_at;autoUpdateTime"`
	CreatedAt     time.Time       `gorm:"column:created_at;autoCreateTime"`
	PurchaseDate  sql.NullTime    `gorm:"column:purchase_date"`
	Type          string          `gorm:"type:asset_type;not null"`
	Name          string          `gorm:"not null"`
	Currency      string          `gorm:"default:USD"`
	Notes         sql.NullString  `gorm:"column:notes"`
	Symbol        sql.NullString  `gorm:"column:symbol"`
	Metadata      json.RawMessage `gorm:"type:jsonb;default:'{}'"`
	CurrentPrice  sql.NullFloat64 `gorm:"type:decimal(20,2);column:current_price"`
	Quantity      float64         `gorm:"type:decimal(20,8);not null"`
	PurchasePrice float64         `gorm:"type:decimal(20,2);not null;column:purchase_price"`
	ID            uuid.UUID       `gorm:"type:uuid;primaryKey"`
	UserID        uuid.UUID       `gorm:"type:uuid;not null;index"`
}

// TableName returns the table name for GORM
func (AssetModel) TableName() string {
	return "assets"
}

// ToEntity converts AssetModel to domain Asset entity
func (m *AssetModel) ToEntity() *entities.Asset {
	asset := &entities.Asset{
		ID:            m.ID,
		UserID:        m.UserID,
		Type:          entities.AssetType(m.Type),
		Name:          m.Name,
		Quantity:      m.Quantity,
		PurchasePrice: m.PurchasePrice,
		Currency:      m.Currency,
		Metadata:      m.Metadata,
		CreatedAt:     m.CreatedAt,
		UpdatedAt:     m.UpdatedAt,
	}

	// Handle nullable fields
	if m.Symbol.Valid {
		asset.Symbol = &m.Symbol.String
	}
	if m.CurrentPrice.Valid {
		asset.CurrentPrice = &m.CurrentPrice.Float64
	}
	if m.PurchaseDate.Valid {
		asset.PurchaseDate = &m.PurchaseDate.Time
	}
	if m.Notes.Valid {
		asset.Notes = &m.Notes.String
	}

	return asset
}

// FromAssetEntity creates an AssetModel from a domain Asset entity
func FromAssetEntity(asset *entities.Asset) *AssetModel {
	model := &AssetModel{
		ID:            asset.ID,
		UserID:        asset.UserID,
		Type:          string(asset.Type),
		Name:          asset.Name,
		Quantity:      asset.Quantity,
		PurchasePrice: asset.PurchasePrice,
		Currency:      asset.Currency,
		Metadata:      asset.Metadata,
		CreatedAt:     asset.CreatedAt,
		UpdatedAt:     asset.UpdatedAt,
	}

	// Handle nullable fields
	if asset.Symbol != nil {
		model.Symbol = sql.NullString{String: *asset.Symbol, Valid: true}
	}
	if asset.CurrentPrice != nil {
		model.CurrentPrice = sql.NullFloat64{Float64: *asset.CurrentPrice, Valid: true}
	}
	if asset.PurchaseDate != nil {
		model.PurchaseDate = sql.NullTime{Time: *asset.PurchaseDate, Valid: true}
	}
	if asset.Notes != nil {
		model.Notes = sql.NullString{String: *asset.Notes, Valid: true}
	}

	return model
}

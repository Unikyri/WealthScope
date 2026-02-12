package repositories

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// AssetModel is the GORM model for the assets table (v2 - JSONB architecture)
type AssetModel struct {
	CreatedAt    time.Time       `gorm:"column:created_at;autoCreateTime"`
	UpdatedAt    time.Time       `gorm:"column:updated_at;autoUpdateTime"`
	DeletedAt    gorm.DeletedAt  `gorm:"index"`
	CoreData     json.RawMessage `gorm:"type:jsonb;default:'{}';column:core_data"`
	ExtendedData json.RawMessage `gorm:"type:jsonb;default:'{}';column:extended_data"`
	Type         string          `gorm:"type:asset_type;not null"`
	Name         string          `gorm:"not null"`
	ID           uuid.UUID       `gorm:"type:uuid;primaryKey"`
	UserID       uuid.UUID       `gorm:"type:uuid;not null;index"`
}

// TableName returns the table name for GORM
func (AssetModel) TableName() string {
	return "assets"
}

// ToEntity converts AssetModel to domain Asset entity
func (m *AssetModel) ToEntity() *entities.Asset {
	return &entities.Asset{
		ID:           m.ID,
		UserID:       m.UserID,
		Type:         entities.AssetType(m.Type),
		Name:         m.Name,
		CoreData:     m.CoreData,
		ExtendedData: m.ExtendedData,
		CreatedAt:    m.CreatedAt,
		UpdatedAt:    m.UpdatedAt,
	}
}

// FromAssetEntity creates an AssetModel from a domain Asset entity
func FromAssetEntity(asset *entities.Asset) *AssetModel {
	coreData := asset.CoreData
	if coreData == nil {
		coreData = json.RawMessage("{}")
	}
	extendedData := asset.ExtendedData
	if extendedData == nil {
		extendedData = json.RawMessage("{}")
	}
	return &AssetModel{
		ID:           asset.ID,
		UserID:       asset.UserID,
		Type:         string(asset.Type),
		Name:         asset.Name,
		CoreData:     coreData,
		ExtendedData: extendedData,
		CreatedAt:    asset.CreatedAt,
		UpdatedAt:    asset.UpdatedAt,
	}
}

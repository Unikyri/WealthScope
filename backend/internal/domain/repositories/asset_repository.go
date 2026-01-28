package repositories

import (
	"context"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// AssetFilters contains optional filters for listing assets
type AssetFilters struct {
	Type     *entities.AssetType // Filter by asset type
	Symbol   *string             // Filter by symbol (exact match)
	Currency *string             // Filter by currency
}

// AssetPagination contains pagination parameters
type AssetPagination struct {
	Page    int // Page number (1-indexed)
	PerPage int // Items per page
}

// AssetListResult contains the result of a paginated list query
type AssetListResult struct {
	Assets     []entities.Asset
	TotalCount int64
	Page       int
	PerPage    int
	TotalPages int
}

// AssetTypeBreakdown represents aggregated data for a single asset type
type AssetTypeBreakdown struct {
	Type    entities.AssetType
	Value   float64
	Percent float64
	Count   int
}

// PortfolioSummary contains the complete portfolio summary with breakdown
type PortfolioSummary struct {
	LastUpdated     time.Time
	BreakdownByType []AssetTypeBreakdown
	TotalValue      float64
	TotalInvested   float64
	GainLoss        float64
	GainLossPercent float64
	AssetCount      int
}

// AssetRepository defines the interface for asset data access
type AssetRepository interface {
	// Create creates a new asset
	Create(ctx context.Context, asset *entities.Asset) error

	// FindByID finds an asset by its ID and user ID (ensures ownership)
	FindByID(ctx context.Context, id, userID uuid.UUID) (*entities.Asset, error)

	// FindByUserID lists all assets for a user with optional filters and pagination
	FindByUserID(ctx context.Context, userID uuid.UUID, filters *AssetFilters, pagination *AssetPagination) (*AssetListResult, error)

	// Update updates an existing asset (only if owned by the user)
	Update(ctx context.Context, asset *entities.Asset) error

	// Delete deletes an asset by ID (only if owned by the user)
	Delete(ctx context.Context, id, userID uuid.UUID) error

	// CountByUserID returns the total count of assets for a user
	CountByUserID(ctx context.Context, userID uuid.UUID) (int64, error)

	// GetTotalValueByUserID calculates the total portfolio value for a user
	GetTotalValueByUserID(ctx context.Context, userID uuid.UUID) (float64, error)

	// FindBySymbol finds assets by symbol for a specific user
	FindBySymbol(ctx context.Context, userID uuid.UUID, symbol string) ([]entities.Asset, error)

	// GetPortfolioSummary returns complete portfolio summary with breakdown by asset type
	GetPortfolioSummary(ctx context.Context, userID uuid.UUID) (*PortfolioSummary, error)

	// FindListedAssets returns assets that have a tradable symbol (e.g. stocks, ETFs, crypto).
	FindListedAssets(ctx context.Context, userID uuid.UUID) ([]entities.Asset, error)

	// UpdateCurrentPriceBySymbol updates current_price for all assets matching a symbol for a user.
	UpdateCurrentPriceBySymbol(ctx context.Context, userID uuid.UUID, symbol string, price float64) error
}

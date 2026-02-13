package repositories

import (
	"context"
	"errors"
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// Ensure PostgresAssetRepository implements AssetRepository
var _ repositories.AssetRepository = (*PostgresAssetRepository)(nil)

// ErrAssetNotFound is returned when an asset is not found
var ErrAssetNotFound = errors.New("asset not found")

// PostgresAssetRepository implements AssetRepository using GORM
type PostgresAssetRepository struct {
	db *gorm.DB
}

// NewPostgresAssetRepository creates a new PostgresAssetRepository
func NewPostgresAssetRepository(db *gorm.DB) *PostgresAssetRepository {
	return &PostgresAssetRepository{db: db}
}

// Create creates a new asset
func (r *PostgresAssetRepository) Create(ctx context.Context, asset *entities.Asset) error {
	model := FromAssetEntity(asset)
	result := r.db.WithContext(ctx).Create(model)
	if result.Error != nil {
		return fmt.Errorf("failed to create asset: %w", result.Error)
	}
	return nil
}

// FindByID finds an asset by its ID and user ID (ensures ownership)
func (r *PostgresAssetRepository) FindByID(ctx context.Context, id, userID uuid.UUID) (*entities.Asset, error) {
	var model AssetModel
	result := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		First(&model)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, ErrAssetNotFound
		}
		return nil, fmt.Errorf("failed to find asset: %w", result.Error)
	}
	return model.ToEntity(), nil
}

// FindByUserID lists all assets for a user with optional filters and pagination
func (r *PostgresAssetRepository) FindByUserID(
	ctx context.Context,
	userID uuid.UUID,
	filters *repositories.AssetFilters,
	pagination *repositories.AssetPagination,
) (*repositories.AssetListResult, error) {
	query := r.db.WithContext(ctx).Where("user_id = ?", userID)

	// Apply filters
	if filters != nil {
		if filters.Type != nil {
			query = query.Where("type = ?", string(*filters.Type))
		}
		if filters.Symbol != nil {
			// Search within core_data JSONB for ticker or symbol
			query = query.Where(
				"(core_data->>'ticker' = ? OR core_data->>'symbol' = ? OR core_data->>'cusip' = ?)",
				*filters.Symbol, *filters.Symbol, *filters.Symbol,
			)
		}
		if filters.Currency != nil {
			query = query.Where("core_data->>'currency' = ?", *filters.Currency)
		}
	}

	// Count total records
	var totalCount int64
	countResult := query.Model(&AssetModel{}).Count(&totalCount)
	if countResult.Error != nil {
		return nil, fmt.Errorf("failed to count assets: %w", countResult.Error)
	}

	// Apply pagination defaults
	page := 1
	perPage := 20
	if pagination != nil {
		if pagination.Page > 0 {
			page = pagination.Page
		}
		if pagination.PerPage > 0 && pagination.PerPage <= 100 {
			perPage = pagination.PerPage
		}
	}

	offset := (page - 1) * perPage
	totalPages := int(math.Ceil(float64(totalCount) / float64(perPage)))

	// Fetch assets with pagination
	var models []AssetModel
	result := query.
		Order("created_at DESC").
		Offset(offset).
		Limit(perPage).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("failed to list assets: %w", result.Error)
	}

	// Convert to entities
	assets := make([]entities.Asset, len(models))
	for i, model := range models {
		assets[i] = *model.ToEntity()
	}

	return &repositories.AssetListResult{
		Assets:     assets,
		TotalCount: totalCount,
		Page:       page,
		PerPage:    perPage,
		TotalPages: totalPages,
	}, nil
}

// Update updates an existing asset (only if owned by the user)
func (r *PostgresAssetRepository) Update(ctx context.Context, asset *entities.Asset) error {
	model := FromAssetEntity(asset)

	result := r.db.WithContext(ctx).
		Model(&AssetModel{}).
		Where("id = ? AND user_id = ?", asset.ID, asset.UserID).
		Updates(map[string]interface{}{
			"type":          model.Type,
			"name":          model.Name,
			"core_data":     model.CoreData,
			"extended_data": model.ExtendedData,
			"updated_at":    model.UpdatedAt,
		})

	if result.Error != nil {
		return fmt.Errorf("failed to update asset: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return ErrAssetNotFound
	}
	return nil
}

// Delete deletes an asset by ID (only if owned by the user)
func (r *PostgresAssetRepository) Delete(ctx context.Context, id, userID uuid.UUID) error {
	result := r.db.WithContext(ctx).
		Where("id = ? AND user_id = ?", id, userID).
		Delete(&AssetModel{})

	if result.Error != nil {
		return fmt.Errorf("failed to delete asset: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return ErrAssetNotFound
	}
	return nil
}

// CountByUserID returns the total count of assets for a user
func (r *PostgresAssetRepository) CountByUserID(ctx context.Context, userID uuid.UUID) (int64, error) {
	var count int64
	result := r.db.WithContext(ctx).
		Model(&AssetModel{}).
		Where("user_id = ?", userID).
		Count(&count)

	if result.Error != nil {
		return 0, fmt.Errorf("failed to count assets: %w", result.Error)
	}
	return count, nil
}

// GetTotalValueByUserID calculates the total portfolio value for a user.
// Since values are in JSONB, we fetch all assets and compute in Go.
func (r *PostgresAssetRepository) GetTotalValueByUserID(ctx context.Context, userID uuid.UUID) (float64, error) {
	var models []AssetModel
	result := r.db.WithContext(ctx).
		Where("user_id = ?", userID).
		Find(&models)

	if result.Error != nil {
		return 0, fmt.Errorf("failed to fetch assets for value calculation: %w", result.Error)
	}

	var total float64
	for _, model := range models {
		asset := model.ToEntity()
		total += asset.TotalValue()
	}
	return total, nil
}

// FindBySymbol finds assets by symbol for a specific user.
// Searches across core_data ticker, symbol, and cusip fields.
func (r *PostgresAssetRepository) FindBySymbol(ctx context.Context, userID uuid.UUID, symbol string) ([]entities.Asset, error) {
	var models []AssetModel
	result := r.db.WithContext(ctx).
		Where("user_id = ? AND (core_data->>'ticker' = ? OR core_data->>'symbol' = ? OR core_data->>'cusip' = ?)",
			userID, symbol, symbol, symbol).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("failed to find assets by symbol: %w", result.Error)
	}

	assets := make([]entities.Asset, len(models))
	for i, model := range models {
		assets[i] = *model.ToEntity()
	}
	return assets, nil
}

// FindListedAssets returns assets that have a tradable symbol.
func (r *PostgresAssetRepository) FindListedAssets(ctx context.Context, userID uuid.UUID) ([]entities.Asset, error) {
	var models []AssetModel
	result := r.db.WithContext(ctx).
		Where(`user_id = ? AND (
			(core_data->>'ticker' IS NOT NULL AND core_data->>'ticker' <> '') OR
			(core_data->>'symbol' IS NOT NULL AND core_data->>'symbol' <> '')
		)`, userID).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("failed to list listed assets: %w", result.Error)
	}

	assets := make([]entities.Asset, len(models))
	for i, model := range models {
		assets[i] = *model.ToEntity()
	}
	return assets, nil
}

// UpdateCurrentPriceBySymbol updates current_price in extended_data for all assets matching a symbol.
func (r *PostgresAssetRepository) UpdateCurrentPriceBySymbol(ctx context.Context, userID uuid.UUID, symbol string, price float64) error {
	now := time.Now().UTC()

	// Use raw SQL to update JSONB field
	sql := `UPDATE assets SET
		extended_data = jsonb_set(COALESCE(extended_data, '{}'), '{current_price}', to_jsonb($1::numeric)),
		updated_at = $2
		WHERE user_id = $3 AND (core_data->>'ticker' = $4 OR core_data->>'symbol' = $4)
		AND deleted_at IS NULL`

	result := r.db.WithContext(ctx).Exec(sql, price, now, userID, symbol)
	if result.Error != nil {
		return fmt.Errorf("failed to update current_price: %w", result.Error)
	}

	return nil
}

// ListUserIDsWithListedAssets returns distinct user IDs that have listed assets.
func (r *PostgresAssetRepository) ListUserIDsWithListedAssets(ctx context.Context) ([]uuid.UUID, error) {
	var userIDs []uuid.UUID
	result := r.db.WithContext(ctx).
		Model(&AssetModel{}).
		Where(`(core_data->>'ticker' IS NOT NULL AND core_data->>'ticker' <> '') OR
			(core_data->>'symbol' IS NOT NULL AND core_data->>'symbol' <> '')`).
		Distinct("user_id").
		Pluck("user_id", &userIDs)

	if result.Error != nil {
		return nil, fmt.Errorf("failed to list user IDs with listed assets: %w", result.Error)
	}
	return userIDs, nil
}

// GetPortfolioSummary returns complete portfolio summary with breakdown by asset type
func (r *PostgresAssetRepository) GetPortfolioSummary(ctx context.Context, userID uuid.UUID) (*repositories.PortfolioSummary, error) {
	var models []AssetModel
	result := r.db.WithContext(ctx).
		Where("user_id = ?", userID).
		Find(&models)

	if result.Error != nil {
		return nil, fmt.Errorf("failed to fetch assets for portfolio summary: %w", result.Error)
	}

	var totalValue, totalInvested float64
	typeMap := make(map[entities.AssetType]*repositories.AssetTypeBreakdown)
	var lastUpdated time.Time

	for _, model := range models {
		asset := model.ToEntity()

		currentValue := asset.TotalValue()
		investedValue := asset.TotalCost()

		totalValue += currentValue
		totalInvested += investedValue

		if asset.UpdatedAt.After(lastUpdated) {
			lastUpdated = asset.UpdatedAt
		}

		if _, exists := typeMap[asset.Type]; !exists {
			typeMap[asset.Type] = &repositories.AssetTypeBreakdown{
				Type: asset.Type,
			}
		}
		typeMap[asset.Type].Value += currentValue
		typeMap[asset.Type].Count++
	}

	gainLoss := totalValue - totalInvested
	var gainLossPercent float64
	if totalInvested > 0 {
		gainLossPercent = (gainLoss / totalInvested) * 100
	}

	breakdown := make([]repositories.AssetTypeBreakdown, 0, len(typeMap))
	for _, tb := range typeMap {
		if totalValue > 0 {
			tb.Percent = (tb.Value / totalValue) * 100
		}
		breakdown = append(breakdown, *tb)
	}

	if lastUpdated.IsZero() {
		lastUpdated = time.Now().UTC()
	}

	return &repositories.PortfolioSummary{
		TotalValue:      totalValue,
		TotalInvested:   totalInvested,
		GainLoss:        gainLoss,
		GainLossPercent: gainLossPercent,
		AssetCount:      len(models),
		LastUpdated:     lastUpdated,
		BreakdownByType: breakdown,
	}, nil
}

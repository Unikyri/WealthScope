package usecases

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// Common errors for asset operations
var (
	ErrInvalidAssetType   = errors.New("invalid asset type")
	ErrInvalidQuantity    = errors.New("quantity must be greater than 0")
	ErrInvalidPrice       = errors.New("price must be non-negative")
	ErrAssetNameRequired  = errors.New("asset name is required")
	ErrAssetNotFound      = errors.New("asset not found")
	ErrUnauthorizedAccess = errors.New("unauthorized access to asset")
)

// ====================================
// Create Asset Use Case
// ====================================

// CreateAssetInput represents the input for creating an asset
type CreateAssetInput struct {
	Metadata      map[string]interface{}
	PurchaseDate  *time.Time
	Symbol        *string
	CurrentPrice  *float64
	Notes         *string
	Type          string
	Name          string
	Currency      string
	Quantity      float64
	PurchasePrice float64
	UserID        uuid.UUID
}

// CreateAssetUseCase handles creating a new asset
type CreateAssetUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewCreateAssetUseCase creates a new CreateAssetUseCase
func NewCreateAssetUseCase(assetRepo repositories.AssetRepository) *CreateAssetUseCase {
	return &CreateAssetUseCase{assetRepo: assetRepo}
}

// Execute creates a new asset for the user
func (uc *CreateAssetUseCase) Execute(ctx context.Context, input CreateAssetInput) (*entities.Asset, error) {
	// Validate asset type
	assetType := entities.AssetType(input.Type)
	if !assetType.IsValid() {
		return nil, ErrInvalidAssetType
	}

	// Validate required fields
	if input.Name == "" {
		return nil, ErrAssetNameRequired
	}
	if input.Quantity <= 0 {
		return nil, ErrInvalidQuantity
	}
	if input.PurchasePrice < 0 {
		return nil, ErrInvalidPrice
	}

	// Set default currency
	currency := input.Currency
	if currency == "" {
		currency = "USD"
	}

	// Create asset entity
	asset := entities.NewAsset(
		input.UserID,
		assetType,
		input.Name,
		input.Quantity,
		input.PurchasePrice,
		currency,
	)

	// Set optional fields
	if input.Symbol != nil {
		asset.SetSymbol(*input.Symbol)
	}
	if input.CurrentPrice != nil {
		asset.SetCurrentPrice(*input.CurrentPrice)
	}
	if input.PurchaseDate != nil {
		asset.SetPurchaseDate(*input.PurchaseDate)
	}
	if input.Notes != nil {
		asset.SetNotes(*input.Notes)
	}
	if input.Metadata != nil {
		metadataJSON, err := json.Marshal(input.Metadata)
		if err != nil {
			return nil, fmt.Errorf("failed to marshal metadata: %w", err)
		}
		asset.SetMetadata(metadataJSON)
	}

	// Save to repository
	if err := uc.assetRepo.Create(ctx, asset); err != nil {
		return nil, fmt.Errorf("failed to create asset: %w", err)
	}

	return asset, nil
}

// ====================================
// Get Asset Use Case
// ====================================

// GetAssetUseCase handles retrieving a single asset
type GetAssetUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewGetAssetUseCase creates a new GetAssetUseCase
func NewGetAssetUseCase(assetRepo repositories.AssetRepository) *GetAssetUseCase {
	return &GetAssetUseCase{assetRepo: assetRepo}
}

// Execute retrieves an asset by ID for the specified user
func (uc *GetAssetUseCase) Execute(ctx context.Context, assetID, userID uuid.UUID) (*entities.Asset, error) {
	asset, err := uc.assetRepo.FindByID(ctx, assetID, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get asset: %w", err)
	}
	return asset, nil
}

// ====================================
// List Assets Use Case
// ====================================

// ListAssetsInput represents the input for listing assets
type ListAssetsInput struct {
	Type     *string
	Symbol   *string
	Currency *string
	UserID   uuid.UUID
	Page     int
	PerPage  int
}

// ListAssetsOutput represents the output of listing assets
type ListAssetsOutput struct {
	Assets     []entities.Asset
	TotalCount int64
	Page       int
	PerPage    int
	TotalPages int
}

// ListAssetsUseCase handles listing user's assets
type ListAssetsUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewListAssetsUseCase creates a new ListAssetsUseCase
func NewListAssetsUseCase(assetRepo repositories.AssetRepository) *ListAssetsUseCase {
	return &ListAssetsUseCase{assetRepo: assetRepo}
}

// Execute retrieves a paginated list of assets for the user
func (uc *ListAssetsUseCase) Execute(ctx context.Context, input ListAssetsInput) (*ListAssetsOutput, error) {
	// Build filters
	var filters *repositories.AssetFilters
	if input.Type != nil || input.Symbol != nil || input.Currency != nil {
		filters = &repositories.AssetFilters{}
		if input.Type != nil {
			assetType := entities.AssetType(*input.Type)
			if assetType.IsValid() {
				filters.Type = &assetType
			}
		}
		if input.Symbol != nil {
			filters.Symbol = input.Symbol
		}
		if input.Currency != nil {
			filters.Currency = input.Currency
		}
	}

	// Build pagination
	pagination := &repositories.AssetPagination{
		Page:    input.Page,
		PerPage: input.PerPage,
	}

	result, err := uc.assetRepo.FindByUserID(ctx, input.UserID, filters, pagination)
	if err != nil {
		return nil, fmt.Errorf("failed to list assets: %w", err)
	}

	return &ListAssetsOutput{
		Assets:     result.Assets,
		TotalCount: result.TotalCount,
		Page:       result.Page,
		PerPage:    result.PerPage,
		TotalPages: result.TotalPages,
	}, nil
}

// ====================================
// Update Asset Use Case
// ====================================

// UpdateAssetInput represents the input for updating an asset
type UpdateAssetInput struct {
	Metadata      map[string]interface{}
	PurchaseDate  *time.Time
	Type          *string
	Name          *string
	Symbol        *string
	Quantity      *float64
	PurchasePrice *float64
	CurrentPrice  *float64
	Currency      *string
	Notes         *string
	AssetID       uuid.UUID
	UserID        uuid.UUID
}

// UpdateAssetUseCase handles updating an existing asset
type UpdateAssetUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewUpdateAssetUseCase creates a new UpdateAssetUseCase
func NewUpdateAssetUseCase(assetRepo repositories.AssetRepository) *UpdateAssetUseCase {
	return &UpdateAssetUseCase{assetRepo: assetRepo}
}

// Execute updates an asset for the specified user
func (uc *UpdateAssetUseCase) Execute(ctx context.Context, input UpdateAssetInput) (*entities.Asset, error) {
	// Get existing asset (also validates ownership)
	asset, err := uc.assetRepo.FindByID(ctx, input.AssetID, input.UserID)
	if err != nil {
		return nil, fmt.Errorf("failed to find asset: %w", err)
	}

	// Update fields if provided
	if input.Type != nil {
		assetType := entities.AssetType(*input.Type)
		if !assetType.IsValid() {
			return nil, ErrInvalidAssetType
		}
		asset.Type = assetType
	}
	if input.Name != nil {
		if *input.Name == "" {
			return nil, ErrAssetNameRequired
		}
		asset.Name = *input.Name
	}
	if input.Symbol != nil {
		asset.SetSymbol(*input.Symbol)
	}
	if input.Quantity != nil {
		if *input.Quantity <= 0 {
			return nil, ErrInvalidQuantity
		}
		asset.Quantity = *input.Quantity
	}
	if input.PurchasePrice != nil {
		if *input.PurchasePrice < 0 {
			return nil, ErrInvalidPrice
		}
		asset.PurchasePrice = *input.PurchasePrice
	}
	if input.CurrentPrice != nil {
		asset.SetCurrentPrice(*input.CurrentPrice)
	}
	if input.Currency != nil {
		asset.Currency = *input.Currency
	}
	if input.PurchaseDate != nil {
		asset.SetPurchaseDate(*input.PurchaseDate)
	}
	if input.Notes != nil {
		asset.SetNotes(*input.Notes)
	}
	if input.Metadata != nil {
		metadataJSON, err := json.Marshal(input.Metadata)
		if err != nil {
			return nil, fmt.Errorf("failed to marshal metadata: %w", err)
		}
		asset.SetMetadata(metadataJSON)
	}

	asset.UpdatedAt = time.Now().UTC()

	// Save changes
	if err := uc.assetRepo.Update(ctx, asset); err != nil {
		return nil, fmt.Errorf("failed to update asset: %w", err)
	}

	return asset, nil
}

// ====================================
// Delete Asset Use Case
// ====================================

// DeleteAssetUseCase handles deleting an asset
type DeleteAssetUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewDeleteAssetUseCase creates a new DeleteAssetUseCase
func NewDeleteAssetUseCase(assetRepo repositories.AssetRepository) *DeleteAssetUseCase {
	return &DeleteAssetUseCase{assetRepo: assetRepo}
}

// Execute deletes an asset for the specified user
func (uc *DeleteAssetUseCase) Execute(ctx context.Context, assetID, userID uuid.UUID) error {
	if err := uc.assetRepo.Delete(ctx, assetID, userID); err != nil {
		return fmt.Errorf("failed to delete asset: %w", err)
	}
	return nil
}

package usecases

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// Common errors
var (
	ErrInvalidAssetType    = errors.New("invalid asset type")
	ErrAssetNotFound       = errors.New("asset not found")
	ErrUnauthorized        = errors.New("unauthorized access to asset")
	ErrMissingRequiredData = errors.New("missing required core_data fields")
)

// CreateAssetInput contains the data needed to create a new asset (v2 - JSONB)
type CreateAssetInput struct {
	CoreData     map[string]interface{} `json:"core_data"`
	ExtendedData map[string]interface{} `json:"extended_data,omitempty"`
	Type         string                 `json:"type"`
	Name         string                 `json:"name"`
	UserID       uuid.UUID              `json:"-"`
}

// CreateAssetOutput contains the result of creating an asset
type CreateAssetOutput struct {
	Asset *entities.Asset `json:"asset"`
}

// GetAssetInput contains the data needed to get an asset
type GetAssetInput struct {
	AssetID uuid.UUID `json:"asset_id"`
	UserID  uuid.UUID `json:"-"`
}

// GetAssetOutput contains the result of getting an asset
type GetAssetOutput struct {
	Asset *entities.Asset `json:"asset"`
}

// ListAssetsInput contains the data needed to list assets
type ListAssetsInput struct {
	Type     *string   `json:"type,omitempty"`
	Symbol   *string   `json:"symbol,omitempty"`
	Currency *string   `json:"currency,omitempty"`
	UserID   uuid.UUID `json:"-"`
	Page     int       `json:"page,omitempty"`
	PerPage  int       `json:"per_page,omitempty"`
}

// ListAssetsOutput contains the result of listing assets
type ListAssetsOutput struct {
	Assets     []entities.Asset `json:"assets"`
	TotalCount int64            `json:"total_count"`
	Page       int              `json:"page"`
	PerPage    int              `json:"per_page"`
	TotalPages int              `json:"total_pages"`
}

// UpdateAssetInput contains the data needed to update an asset
type UpdateAssetInput struct {
	CoreData     map[string]interface{} `json:"core_data,omitempty"`
	ExtendedData map[string]interface{} `json:"extended_data,omitempty"`
	Type         *string                `json:"type,omitempty"`
	Name         *string                `json:"name,omitempty"`
	AssetID      uuid.UUID              `json:"asset_id"`
	UserID       uuid.UUID              `json:"-"`
}

// UpdateAssetOutput contains the result of updating an asset
type UpdateAssetOutput struct {
	Asset *entities.Asset `json:"asset"`
}

// DeleteAssetInput contains the data needed to delete an asset
type DeleteAssetInput struct {
	AssetID uuid.UUID `json:"asset_id"`
	UserID  uuid.UUID `json:"-"`
}

// AssetUseCases handles business logic for assets
type AssetUseCases struct {
	repo repositories.AssetRepository
}

// NewAssetUseCases creates a new AssetUseCases
func NewAssetUseCases(repo repositories.AssetRepository) *AssetUseCases {
	return &AssetUseCases{repo: repo}
}

// CreateAsset validates and creates a new asset
func (uc *AssetUseCases) CreateAsset(ctx context.Context, input CreateAssetInput) (*CreateAssetOutput, error) {
	// Validate asset type
	assetType := entities.AssetType(strings.TrimSpace(input.Type))
	if !assetType.IsValid() {
		return nil, fmt.Errorf("%w: %s", ErrInvalidAssetType, input.Type)
	}

	// Validate name
	name := strings.TrimSpace(input.Name)
	if name == "" {
		return nil, fmt.Errorf("asset name is required")
	}

	// Validate required core_data fields
	if input.CoreData == nil {
		input.CoreData = make(map[string]interface{})
	}
	missingFields := entities.ValidateCoreData(assetType, input.CoreData)
	if len(missingFields) > 0 {
		return nil, fmt.Errorf("%w: %s", ErrMissingRequiredData, strings.Join(missingFields, ", "))
	}

	// Serialize core_data
	coreDataJSON, err := json.Marshal(input.CoreData)
	if err != nil {
		return nil, fmt.Errorf("failed to serialize core_data: %w", err)
	}

	// Serialize extended_data
	var extendedDataJSON json.RawMessage
	if input.ExtendedData != nil {
		extendedDataJSON, err = json.Marshal(input.ExtendedData)
		if err != nil {
			return nil, fmt.Errorf("failed to serialize extended_data: %w", err)
		}
	} else {
		extendedDataJSON = json.RawMessage("{}")
	}

	asset := entities.NewAsset(input.UserID, assetType, name, coreDataJSON, extendedDataJSON)

	if err := uc.repo.Create(ctx, asset); err != nil {
		return nil, fmt.Errorf("failed to create asset: %w", err)
	}

	return &CreateAssetOutput{Asset: asset}, nil
}

// GetAsset retrieves an asset by ID with ownership check
func (uc *AssetUseCases) GetAsset(ctx context.Context, input GetAssetInput) (*GetAssetOutput, error) {
	asset, err := uc.repo.FindByID(ctx, input.AssetID, input.UserID)
	if err != nil {
		return nil, fmt.Errorf("%w", ErrAssetNotFound)
	}
	return &GetAssetOutput{Asset: asset}, nil
}

// ListAssets retrieves all assets for a user with optional filters and pagination
func (uc *AssetUseCases) ListAssets(ctx context.Context, input ListAssetsInput) (*ListAssetsOutput, error) {
	// Build filters
	var filters *repositories.AssetFilters
	if input.Type != nil || input.Symbol != nil || input.Currency != nil {
		filters = &repositories.AssetFilters{}
		if input.Type != nil {
			assetType := entities.AssetType(*input.Type)
			if !assetType.IsValid() {
				return nil, fmt.Errorf("%w: %s", ErrInvalidAssetType, *input.Type)
			}
			filters.Type = &assetType
		}
		filters.Symbol = input.Symbol
		filters.Currency = input.Currency
	}

	// Build pagination
	pagination := &repositories.AssetPagination{
		Page:    input.Page,
		PerPage: input.PerPage,
	}

	result, err := uc.repo.FindByUserID(ctx, input.UserID, filters, pagination)
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

// UpdateAsset updates an existing asset with ownership check
func (uc *AssetUseCases) UpdateAsset(ctx context.Context, input UpdateAssetInput) (*UpdateAssetOutput, error) {
	// Find existing asset
	existing, err := uc.repo.FindByID(ctx, input.AssetID, input.UserID)
	if err != nil {
		return nil, fmt.Errorf("%w", ErrAssetNotFound)
	}

	// Update type if provided
	if input.Type != nil {
		assetType := entities.AssetType(*input.Type)
		if !assetType.IsValid() {
			return nil, fmt.Errorf("%w: %s", ErrInvalidAssetType, *input.Type)
		}
		existing.Type = assetType
	}

	// Update name if provided
	if input.Name != nil {
		name := strings.TrimSpace(*input.Name)
		if name != "" {
			existing.Name = name
		}
	}

	// Update core_data if provided (merge with existing)
	if input.CoreData != nil {
		existingCoreData, err := existing.GetCoreDataMap()
		if err != nil {
			existingCoreData = make(map[string]interface{})
		}
		for k, v := range input.CoreData {
			if v == nil {
				delete(existingCoreData, k)
			} else {
				existingCoreData[k] = v
			}
		}
		coreDataJSON, err := json.Marshal(existingCoreData)
		if err != nil {
			return nil, fmt.Errorf("failed to serialize core_data: %w", err)
		}
		existing.SetCoreData(coreDataJSON)
	}

	// Update extended_data if provided (merge with existing)
	if input.ExtendedData != nil {
		existingExtData, err := existing.GetExtendedDataMap()
		if err != nil {
			existingExtData = make(map[string]interface{})
		}
		for k, v := range input.ExtendedData {
			if v == nil {
				delete(existingExtData, k)
			} else {
				existingExtData[k] = v
			}
		}
		extDataJSON, err := json.Marshal(existingExtData)
		if err != nil {
			return nil, fmt.Errorf("failed to serialize extended_data: %w", err)
		}
		existing.SetExtendedData(extDataJSON)
	}

	existing.UpdatedAt = time.Now().UTC()

	if err := uc.repo.Update(ctx, existing); err != nil {
		return nil, fmt.Errorf("failed to update asset: %w", err)
	}

	return &UpdateAssetOutput{Asset: existing}, nil
}

// DeleteAsset deletes an asset with ownership check
func (uc *AssetUseCases) DeleteAsset(ctx context.Context, input DeleteAssetInput) error {
	// Verify asset exists and belongs to user
	_, err := uc.repo.FindByID(ctx, input.AssetID, input.UserID)
	if err != nil {
		return fmt.Errorf("%w", ErrAssetNotFound)
	}

	if err := uc.repo.Delete(ctx, input.AssetID, input.UserID); err != nil {
		return fmt.Errorf("failed to delete asset: %w", err)
	}

	return nil
}

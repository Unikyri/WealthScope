package usecases

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

type fakePagedAssetRepo struct {
	pages map[int][]entities.Asset
}

func (f *fakePagedAssetRepo) Create(ctx context.Context, asset *entities.Asset) error { return nil }
func (f *fakePagedAssetRepo) FindByID(ctx context.Context, id, userID uuid.UUID) (*entities.Asset, error) {
	return nil, nil
}
func (f *fakePagedAssetRepo) FindByUserID(ctx context.Context, userID uuid.UUID, filters *repositories.AssetFilters, pagination *repositories.AssetPagination) (*repositories.AssetListResult, error) {
	page := 1
	per := 20
	if pagination != nil {
		page = pagination.Page
		per = pagination.PerPage
	}
	assets := f.pages[page]
	total := 0
	for _, p := range f.pages {
		total += len(p)
	}
	totalPages := 0
	if per > 0 {
		totalPages = (total + per - 1) / per
	}
	return &repositories.AssetListResult{
		Assets:     assets,
		TotalCount: int64(total),
		Page:       page,
		PerPage:    per,
		TotalPages: totalPages,
	}, nil
}
func (f *fakePagedAssetRepo) Update(ctx context.Context, asset *entities.Asset) error { return nil }
func (f *fakePagedAssetRepo) Delete(ctx context.Context, id, userID uuid.UUID) error  { return nil }
func (f *fakePagedAssetRepo) CountByUserID(ctx context.Context, userID uuid.UUID) (int64, error) {
	return 0, nil
}
func (f *fakePagedAssetRepo) GetTotalValueByUserID(ctx context.Context, userID uuid.UUID) (float64, error) {
	return 0, nil
}
func (f *fakePagedAssetRepo) FindBySymbol(ctx context.Context, userID uuid.UUID, symbol string) ([]entities.Asset, error) {
	return nil, nil
}
func (f *fakePagedAssetRepo) GetPortfolioSummary(ctx context.Context, userID uuid.UUID) (*repositories.PortfolioSummary, error) {
	return nil, nil
}
func (f *fakePagedAssetRepo) FindListedAssets(ctx context.Context, userID uuid.UUID) ([]entities.Asset, error) {
	return nil, nil
}
func (f *fakePagedAssetRepo) UpdateCurrentPriceBySymbol(ctx context.Context, userID uuid.UUID, symbol string, price float64) error {
	return nil
}
func (f *fakePagedAssetRepo) ListUserIDsWithListedAssets(ctx context.Context) ([]uuid.UUID, error) {
	return nil, nil
}

func newTestAssetForRisk(userID uuid.UUID, assetType entities.AssetType, name string, qty, price float64) entities.Asset {
	coreData, _ := json.Marshal(map[string]interface{}{
		"quantity":       qty,
		"purchase_price": price,
		"currency":       "USD",
	})
	return *entities.NewAsset(userID, assetType, name, coreData, nil)
}

func TestGetPortfolioRiskUseCase_Execute_AggregatesPages(t *testing.T) {
	repo := &fakePagedAssetRepo{
		pages: map[int][]entities.Asset{
			1: {newTestAssetForRisk(uuid.New(), entities.AssetTypeStock, "A", 1, 100)},
			2: {newTestAssetForRisk(uuid.New(), entities.AssetTypeStock, "B", 1, 100)},
		},
	}
	uc := NewGetPortfolioRiskUseCase(repo, services.NewRiskService())

	out, err := uc.Execute(context.Background(), uuid.New())
	require.NoError(t, err)
	require.NotNil(t, out.Alerts)
}

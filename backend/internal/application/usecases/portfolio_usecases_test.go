package usecases

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

type fakeAssetRepo struct {
	summary *repositories.PortfolioSummary
	err     error
}

func (f *fakeAssetRepo) Create(ctx context.Context, asset *entities.Asset) error { return nil }
func (f *fakeAssetRepo) FindByID(ctx context.Context, id, userID uuid.UUID) (*entities.Asset, error) {
	return nil, nil
}
func (f *fakeAssetRepo) FindByUserID(
	ctx context.Context,
	userID uuid.UUID,
	filters *repositories.AssetFilters,
	pagination *repositories.AssetPagination,
) (*repositories.AssetListResult, error) {
	return &repositories.AssetListResult{}, nil
}
func (f *fakeAssetRepo) Update(ctx context.Context, asset *entities.Asset) error { return nil }
func (f *fakeAssetRepo) Delete(ctx context.Context, id, userID uuid.UUID) error  { return nil }
func (f *fakeAssetRepo) CountByUserID(ctx context.Context, userID uuid.UUID) (int64, error) {
	return 0, nil
}
func (f *fakeAssetRepo) GetTotalValueByUserID(ctx context.Context, userID uuid.UUID) (float64, error) {
	return 0, nil
}
func (f *fakeAssetRepo) FindBySymbol(ctx context.Context, userID uuid.UUID, symbol string) ([]entities.Asset, error) {
	return nil, nil
}
func (f *fakeAssetRepo) GetPortfolioSummary(ctx context.Context, userID uuid.UUID) (*repositories.PortfolioSummary, error) {
	if f.err != nil {
		return nil, f.err
	}
	return f.summary, nil
}

func TestGetPortfolioSummaryUseCase_Execute_ReturnsSummary(t *testing.T) {
	t.Parallel()

	userID := uuid.New()
	now := time.Now().UTC()

	want := &repositories.PortfolioSummary{
		TotalValue:      125000,
		TotalInvested:   100000,
		GainLoss:        25000,
		GainLossPercent: 25,
		AssetCount:      3,
		LastUpdated:     now,
		BreakdownByType: []repositories.AssetTypeBreakdown{
			{Type: entities.AssetTypeStock, Value: 80000, Percent: 64, Count: 2},
			{Type: entities.AssetTypeRealEstate, Value: 45000, Percent: 36, Count: 1},
		},
	}

	uc := NewGetPortfolioSummaryUseCase(&fakeAssetRepo{summary: want})

	got, err := uc.Execute(context.Background(), userID)
	if err != nil {
		t.Fatalf("expected nil error, got %v", err)
	}
	if got == nil {
		t.Fatalf("expected non-nil summary")
	}
	if got.TotalValue != want.TotalValue {
		t.Fatalf("TotalValue mismatch: got %v want %v", got.TotalValue, want.TotalValue)
	}
	if got.GainLossPercent != want.GainLossPercent {
		t.Fatalf("GainLossPercent mismatch: got %v want %v", got.GainLossPercent, want.GainLossPercent)
	}
	if got.AssetCount != want.AssetCount {
		t.Fatalf("AssetCount mismatch: got %v want %v", got.AssetCount, want.AssetCount)
	}
}

func TestGetPortfolioSummaryUseCase_Execute_WrapsError(t *testing.T) {
	t.Parallel()

	repoErr := errors.New("db failed")
	uc := NewGetPortfolioSummaryUseCase(&fakeAssetRepo{err: repoErr})

	_, err := uc.Execute(context.Background(), uuid.New())
	if err == nil {
		t.Fatalf("expected error, got nil")
	}
	if !errors.Is(err, repoErr) {
		t.Fatalf("expected wrapped error to contain repoErr")
	}
}

package repositories

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	domainRepo "github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// newTestAsset creates a test asset with JSONB core_data containing quantity, purchase_price, and currency.
func newTestAsset(userID uuid.UUID, assetType entities.AssetType, name string, qty, price float64, currency string) *entities.Asset {
	coreData, _ := json.Marshal(map[string]interface{}{
		"quantity":       qty,
		"purchase_price": price,
		"currency":       currency,
	})
	return entities.NewAsset(userID, assetType, name, coreData, nil)
}

func TestPostgresAssetRepository_CRUD(t *testing.T) {
	db := openTestGormDB(t)
	tx := beginTx(t, db)

	repo := NewPostgresAssetRepository(tx)
	ctx := context.Background()

	userID := uuid.New()
	ensureUserExists(t, tx, userID)
	asset := newTestAsset(userID, entities.AssetTypeStock, "Apple Inc.", 10, 150, "USD")
	asset.SetSymbol("AAPL")

	// Create
	require.NoError(t, repo.Create(ctx, asset))

	// FindByID
	got, err := repo.FindByID(ctx, asset.ID, userID)
	require.NoError(t, err)
	require.Equal(t, asset.ID, got.ID)
	require.Equal(t, userID, got.UserID)
	require.Equal(t, "Apple Inc.", got.Name)
	require.Equal(t, "AAPL", got.Symbol())

	// Update name via core data
	asset.Name = "Apple Updated"
	coreData, _ := json.Marshal(map[string]interface{}{
		"quantity":       12,
		"purchase_price": 155,
		"currency":       "USD",
		"ticker":         "AAPL",
	})
	asset.SetCoreData(coreData)

	nowBefore := time.Now().UTC().Add(-1 * time.Second)
	require.NoError(t, repo.Update(ctx, asset))

	got2, err := repo.FindByID(ctx, asset.ID, userID)
	require.NoError(t, err)
	require.Equal(t, "Apple Updated", got2.Name)
	require.True(t, got2.UpdatedAt.After(nowBefore))

	// Delete (soft delete)
	require.NoError(t, repo.Delete(ctx, asset.ID, userID))
	_, err = repo.FindByID(ctx, asset.ID, userID)
	require.Error(t, err)
	require.ErrorIs(t, err, ErrAssetNotFound)

	// Not found (random UUID)
	_, err = repo.FindByID(ctx, uuid.New(), userID)
	require.Error(t, err)
	require.ErrorIs(t, err, ErrAssetNotFound)
}

func TestPostgresAssetRepository_FindByUserID_FiltersAndPagination(t *testing.T) {
	db := openTestGormDB(t)
	tx := beginTx(t, db)

	repo := NewPostgresAssetRepository(tx)
	ctx := context.Background()

	userID := uuid.New()
	ensureUserExists(t, tx, userID)

	// Seed assets (3 stocks, 1 crypto)
	for i := 0; i < 3; i++ {
		a := newTestAsset(userID, entities.AssetTypeStock, "Stock", 1, 100, "USD")
		require.NoError(t, repo.Create(ctx, a))
	}
	crypto := newTestAsset(userID, entities.AssetTypeCrypto, "BTC", 1, 20000, "USD")
	require.NoError(t, repo.Create(ctx, crypto))

	// Filter by type
	assetType := entities.AssetTypeStock
	res, err := repo.FindByUserID(ctx, userID, &domainRepo.AssetFilters{Type: &assetType}, &domainRepo.AssetPagination{Page: 1, PerPage: 100})
	require.NoError(t, err)
	require.Equal(t, int64(3), res.TotalCount)
	require.Len(t, res.Assets, 3)

	// Pagination
	res2, err := repo.FindByUserID(ctx, userID, nil, &domainRepo.AssetPagination{Page: 1, PerPage: 2})
	require.NoError(t, err)
	require.Equal(t, int64(4), res2.TotalCount)
	require.Len(t, res2.Assets, 2)
	require.Equal(t, 2, res2.PerPage)
	require.Equal(t, 2, res2.TotalPages)
}

func TestPostgresAssetRepository_GetPortfolioSummary_UsesCurrentOrPurchasePrice(t *testing.T) {
	db := openTestGormDB(t)
	tx := beginTx(t, db)

	repo := NewPostgresAssetRepository(tx)
	ctx := context.Background()

	userID := uuid.New()
	ensureUserExists(t, tx, userID)

	// Asset with current_price in extended_data
	a1 := newTestAsset(userID, entities.AssetTypeStock, "A", 10, 100, "USD") // invested 1000
	extData, _ := json.Marshal(map[string]interface{}{"current_price": 120})
	a1.SetExtendedData(extData) // value 1200
	require.NoError(t, repo.Create(ctx, a1))

	// Asset without current_price (fallback to purchase_price)
	a2 := newTestAsset(userID, entities.AssetTypeETF, "B", 5, 200, "USD") // invested/value 1000
	require.NoError(t, repo.Create(ctx, a2))

	summary, err := repo.GetPortfolioSummary(ctx, userID)
	require.NoError(t, err)

	require.Equal(t, 2, summary.AssetCount)
	require.InEpsilon(t, 2200.0, summary.TotalValue, 0.0001)
	require.InEpsilon(t, 2000.0, summary.TotalInvested, 0.0001)
	require.InEpsilon(t, 200.0, summary.GainLoss, 0.0001)
}

func TestPostgresAssetRepository_AggregationsAndHelpers(t *testing.T) {
	db := openTestGormDB(t)
	tx := beginTx(t, db)

	repo := NewPostgresAssetRepository(tx)
	ctx := context.Background()

	userID := uuid.New()
	ensureUserExists(t, tx, userID)

	// Seed 2 listed assets with symbol and 1 non-listed
	a1 := newTestAsset(userID, entities.AssetTypeStock, "A", 1, 100, "USD")
	a1.SetSymbol("AAPL")
	extData, _ := json.Marshal(map[string]interface{}{"current_price": 120})
	a1.SetExtendedData(extData)
	require.NoError(t, repo.Create(ctx, a1))

	a2 := newTestAsset(userID, entities.AssetTypeETF, "B", 2, 50, "USD")
	a2.SetSymbol("SPY")
	require.NoError(t, repo.Create(ctx, a2))

	a3 := newTestAsset(userID, entities.AssetTypeCash, "Cash", 1, 10, "USD")
	require.NoError(t, repo.Create(ctx, a3))

	// CountByUserID
	cnt, err := repo.CountByUserID(ctx, userID)
	require.NoError(t, err)
	require.Equal(t, int64(3), cnt)

	// GetTotalValueByUserID (uses COALESCE current_price, purchase_price)
	total, err := repo.GetTotalValueByUserID(ctx, userID)
	require.NoError(t, err)
	// a1: 1*120, a2: 2*50, a3: 1*10
	require.InEpsilon(t, 230.0, total, 0.0001)

	// FindBySymbol
	found, err := repo.FindBySymbol(ctx, userID, "AAPL")
	require.NoError(t, err)
	require.Len(t, found, 1)

	// FindListedAssets
	listed, err := repo.FindListedAssets(ctx, userID)
	require.NoError(t, err)
	require.GreaterOrEqual(t, len(listed), 2)

	// UpdateCurrentPriceBySymbol
	require.NoError(t, repo.UpdateCurrentPriceBySymbol(ctx, userID, "SPY", 60))
	after, err := repo.FindBySymbol(ctx, userID, "SPY")
	require.NoError(t, err)
	require.Len(t, after, 1)
	// Verify current_price is in extended_data
	extMap, extErr := after[0].GetExtendedDataMap()
	require.NoError(t, extErr)
	require.InEpsilon(t, 60.0, extMap["current_price"].(float64), 0.0001)

	// ListUserIDsWithListedAssets
	userIDs, err := repo.ListUserIDsWithListedAssets(ctx)
	require.NoError(t, err)
	require.Contains(t, userIDs, userID)
}

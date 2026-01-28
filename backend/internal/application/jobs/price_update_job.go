package jobs

import (
	"context"
	"time"

	"go.uber.org/zap"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// PriceUpdateJob updates current_price for listed assets and stores price history.
type PriceUpdateJob struct {
	pricing   *services.PricingService
	assetRepo repositories.AssetRepository
	priceRepo repositories.PriceHistoryRepository
	logger    *zap.Logger
}

func NewPriceUpdateJob(
	pricing *services.PricingService,
	assetRepo repositories.AssetRepository,
	priceRepo repositories.PriceHistoryRepository,
	logger *zap.Logger,
) *PriceUpdateJob {
	return &PriceUpdateJob{
		pricing:   pricing,
		assetRepo: assetRepo,
		priceRepo: priceRepo,
		logger:    logger,
	}
}

func (j *PriceUpdateJob) Run(ctx context.Context, userID uuid.UUID) error {
	start := time.Now()
	j.logger.Info("Starting price update job", zap.String("user_id", userID.String()))

	err := j.pricing.UpdateAssetPrices(ctx, userID, j.assetRepo, j.priceRepo)
	if err != nil {
		j.logger.Error("Price update job failed", zap.Error(err))
		return err
	}

	j.logger.Info("Price update job completed", zap.Duration("duration", time.Since(start)))
	return nil
}

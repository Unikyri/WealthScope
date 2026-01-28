package usecases

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// ====================================
// Get Portfolio Summary Use Case
// ====================================

// GetPortfolioSummaryUseCase handles retrieving portfolio summary
type GetPortfolioSummaryUseCase struct {
	assetRepo repositories.AssetRepository
}

// NewGetPortfolioSummaryUseCase creates a new GetPortfolioSummaryUseCase
func NewGetPortfolioSummaryUseCase(assetRepo repositories.AssetRepository) *GetPortfolioSummaryUseCase {
	return &GetPortfolioSummaryUseCase{assetRepo: assetRepo}
}

// Execute retrieves the portfolio summary for the specified user
func (uc *GetPortfolioSummaryUseCase) Execute(ctx context.Context, userID uuid.UUID) (*repositories.PortfolioSummary, error) {
	summary, err := uc.assetRepo.GetPortfolioSummary(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get portfolio summary: %w", err)
	}
	return summary, nil
}

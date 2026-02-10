package usecases

import (
	"context"
	"fmt"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

type GetPortfolioRiskUseCase struct {
	assetRepo repositories.AssetRepository
	riskSvc   *services.RiskService
}

func NewGetPortfolioRiskUseCase(assetRepo repositories.AssetRepository, riskSvc *services.RiskService) *GetPortfolioRiskUseCase {
	return &GetPortfolioRiskUseCase{
		assetRepo: assetRepo,
		riskSvc:   riskSvc,
	}
}

func (uc *GetPortfolioRiskUseCase) Execute(ctx context.Context, userID uuid.UUID) (services.PortfolioRisk, error) {
	if uc.assetRepo == nil || uc.riskSvc == nil {
		return services.PortfolioRisk{}, fmt.Errorf("dependencies not initialized")
	}

	all := make([]entities.Asset, 0, 64)

	page := 1
	for {
		res, err := uc.assetRepo.FindByUserID(ctx, userID, nil, &repositories.AssetPagination{
			Page:    page,
			PerPage: 100,
		})
		if err != nil {
			return services.PortfolioRisk{}, err
		}
		all = append(all, res.Assets...)
		if page >= res.TotalPages || len(res.Assets) == 0 {
			break
		}
		page++
	}

	return uc.riskSvc.AnalyzePortfolio(all), nil
}

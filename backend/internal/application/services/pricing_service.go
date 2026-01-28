package services

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

// PricingService fetches and caches market prices for listed assets.
type PricingService struct {
	client *marketdata.YahooFinanceClient
	cache  *marketdata.TTLCache[*marketdata.Quote]

	ttl time.Duration
}

func NewPricingService(client *marketdata.YahooFinanceClient, ttl time.Duration) *PricingService {
	if ttl <= 0 {
		ttl = time.Minute
	}
	return &PricingService{
		client: client,
		cache:  marketdata.NewTTLCache[*marketdata.Quote](ttl),
		ttl:    ttl,
	}
}

// GetQuote returns a quote for a symbol using cache-first strategy.
func (s *PricingService) GetQuote(ctx context.Context, symbol string) (*marketdata.Quote, error) {
	if q, ok := s.cache.Get(symbol); ok && q != nil {
		return q, nil
	}
	q, err := s.client.GetQuote(ctx, symbol)
	if err != nil {
		return nil, err
	}
	s.cache.Set(symbol, q)
	return q, nil
}

// GetQuotes returns quotes for multiple symbols (cache-first, falls back to API).
func (s *PricingService) GetQuotes(ctx context.Context, symbols []string) (map[string]*marketdata.Quote, error) {
	need := make([]string, 0, len(symbols))
	out := make(map[string]*marketdata.Quote, len(symbols))

	for _, sym := range symbols {
		if q, ok := s.cache.Get(sym); ok && q != nil {
			out[sym] = q
			continue
		}
		need = append(need, sym)
	}

	if len(need) == 0 {
		return out, nil
	}

	fetched, err := s.client.GetQuotes(ctx, need)
	if err != nil {
		return nil, err
	}

	for sym, q := range fetched {
		out[sym] = q
		s.cache.Set(sym, q)
	}

	return out, nil
}

// UpdateAssetPrices updates current_price for all listed assets owned by a user.
// This uses the market data client with cache support and then persists the prices.
func (s *PricingService) UpdateAssetPrices(
	ctx context.Context,
	userID uuid.UUID,
	assetRepo repositories.AssetRepository,
	priceRepo repositories.PriceHistoryRepository,
) error {
	listed, err := assetRepo.FindListedAssets(ctx, userID)
	if err != nil {
		return fmt.Errorf("failed to list assets for pricing: %w", err)
	}

	symbols := make([]string, 0, len(listed))
	for _, a := range listed {
		if a.Symbol == nil || *a.Symbol == "" {
			continue
		}
		symbols = append(symbols, *a.Symbol)
	}

	quotes, err := s.GetQuotes(ctx, symbols)
	if err != nil {
		return fmt.Errorf("failed to fetch quotes: %w", err)
	}

	for _, a := range listed {
		if a.Symbol == nil || *a.Symbol == "" {
			continue
		}
		q := quotes[*a.Symbol]
		if q == nil {
			continue
		}

		// Update asset current_price
		if err := assetRepo.UpdateCurrentPriceBySymbol(ctx, userID, *a.Symbol, q.Price); err != nil {
			return fmt.Errorf("failed to update current_price for %s: %w", *a.Symbol, err)
		}

		// Persist history record
		if priceRepo != nil {
			_ = priceRepo.Insert(ctx, &entities.PriceHistory{
				Symbol:        q.Symbol,
				Price:         q.Price,
				ChangeAmount:  q.Change,
				ChangePercent: q.ChangePercent,
				MarketState:   q.MarketState,
				RecordedAt:    q.UpdatedAt,
				Source:        "yahoo_finance",
			})
		}
	}

	return nil
}

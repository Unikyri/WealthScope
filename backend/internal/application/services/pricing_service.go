package services

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	domainsvc "github.com/Unikyri/WealthScope/backend/internal/domain/services"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

// PricingService fetches and caches market prices for listed assets.
// It uses separate caches for regular assets and metals (which have stricter API limits).
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type PricingService struct {
	client      domainsvc.MarketDataClient
	cache       *marketdata.TTLCache[*domainsvc.Quote]
	metalsCache *marketdata.TTLCache[*domainsvc.Quote]

	ttl       time.Duration
	metalsTTL time.Duration
}

// NewPricingService creates a new PricingService with standard cache TTL.
func NewPricingService(client domainsvc.MarketDataClient, ttl time.Duration) *PricingService {
	return NewPricingServiceWithMetalsTTL(client, ttl, 12*time.Hour)
}

// NewPricingServiceWithMetalsTTL creates a new PricingService with custom metals cache TTL.
// Metal APIs (like MetalPriceAPI) have very limited quotas (50 req/month),
// so we cache metal prices for much longer (default 12 hours).
func NewPricingServiceWithMetalsTTL(client domainsvc.MarketDataClient, ttl, metalsTTL time.Duration) *PricingService {
	if ttl <= 0 {
		ttl = time.Minute
	}
	if metalsTTL <= 0 {
		metalsTTL = 12 * time.Hour // Very long TTL for metals due to API quota limits
	}
	return &PricingService{
		client:      client,
		cache:       marketdata.NewTTLCache[*domainsvc.Quote](ttl),
		metalsCache: marketdata.NewTTLCache[*domainsvc.Quote](metalsTTL),
		ttl:         ttl,
		metalsTTL:   metalsTTL,
	}
}

// isMetalSymbol checks if a symbol represents a precious metal.
// Uses a simple heuristic to detect gold, silver, platinum, palladium.
func isMetalSymbol(symbol string) bool {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	metalSymbols := map[string]bool{
		"GOLD": true, "XAU": true, "GLD": true, "XAUUSD": true,
		"SILVER": true, "XAG": true, "SLV": true, "XAGUSD": true,
		"PLATINUM": true, "XPT": true, "PLAT": true, "XPTUSD": true,
		"PALLADIUM": true, "XPD": true, "PALL": true, "XPDUSD": true,
	}
	return metalSymbols[symbol]
}

// GetQuote returns a quote for a symbol using cache-first strategy.
// Metal symbols use a separate cache with longer TTL to conserve API quota.
func (s *PricingService) GetQuote(ctx context.Context, symbol string) (*domainsvc.Quote, error) {
	// Choose cache based on symbol type
	cache := s.cache
	if isMetalSymbol(symbol) {
		cache = s.metalsCache
	}

	if q, ok := cache.Get(symbol); ok && q != nil {
		return q, nil
	}
	q, err := s.client.GetQuote(ctx, symbol)
	if err != nil {
		return nil, err
	}
	cache.Set(symbol, q)
	return q, nil
}

// GetQuotes returns quotes for multiple symbols (cache-first, falls back to API).
// Metal symbols use a separate cache with longer TTL to conserve API quota.
func (s *PricingService) GetQuotes(ctx context.Context, symbols []string) (map[string]*domainsvc.Quote, error) {
	need := make([]string, 0, len(symbols))
	out := make(map[string]*domainsvc.Quote, len(symbols))

	for _, sym := range symbols {
		// Choose cache based on symbol type
		cache := s.cache
		if isMetalSymbol(sym) {
			cache = s.metalsCache
		}

		if q, ok := cache.Get(sym); ok && q != nil {
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
		// Store in appropriate cache
		if isMetalSymbol(sym) {
			s.metalsCache.Set(sym, q)
		} else {
			s.cache.Set(sym, q)
		}
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
			source := q.Source
			if source == "" {
				source = s.client.Name()
			}
			_ = priceRepo.Insert(ctx, &entities.PriceHistory{
				Symbol:        q.Symbol,
				Price:         q.Price,
				ChangeAmount:  q.Change,
				ChangePercent: q.ChangePercent,
				MarketState:   q.MarketState,
				RecordedAt:    q.UpdatedAt,
				Source:        source,
			})
		}
	}

	return nil
}

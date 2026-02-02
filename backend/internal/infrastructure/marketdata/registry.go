package marketdata

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
	"go.uber.org/zap"
)

// ProviderRegistry implements services.MarketDataClient by delegating to a list of
// clients per category and applying fallback on error.
type ProviderRegistry struct {
	mu         sync.RWMutex
	providers  map[services.AssetCategory][]services.MarketDataClient
	defaultCat services.AssetCategory
	logger     *zap.Logger
}

// NewProviderRegistry creates a registry with default category equity and optional logger.
func NewProviderRegistry(logger *zap.Logger) *ProviderRegistry {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &ProviderRegistry{
		providers:  make(map[services.AssetCategory][]services.MarketDataClient),
		defaultCat: services.CategoryEquity,
		logger:     logger,
	}
}

// Register adds a client for the given category. Order matters for fallback (first wins on success).
func (r *ProviderRegistry) Register(category services.AssetCategory, client services.MarketDataClient) {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.providers[category] = append(r.providers[category], client)
}

// resolveCategory returns the category for a symbol; for US-6.1 we default to equity.
func (r *ProviderRegistry) resolveCategory(symbol string) services.AssetCategory {
	_ = symbol
	return r.defaultCat
}

// GetQuote returns a quote by trying each registered provider for the symbol's category until one succeeds.
func (r *ProviderRegistry) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	r.mu.RLock()
	clients := r.providers[r.resolveCategory(symbol)]
	r.mu.RUnlock()

	var lastErr error
	for _, client := range clients {
		if !client.SupportsSymbol(symbol) {
			continue
		}
		q, err := client.GetQuote(ctx, symbol)
		if err != nil {
			lastErr = err
			r.logger.Debug("market data provider failed", zap.String("provider", client.Name()), zap.String("symbol", symbol), zap.Error(err))
			continue
		}
		if q != nil {
			if q.Source == "" {
				q.Source = client.Name()
			}
			return q, nil
		}
	}
	if lastErr != nil {
		return nil, fmt.Errorf("all providers failed for symbol %q: %w", symbol, lastErr)
	}
	return nil, fmt.Errorf("no quote for symbol %q", symbol)
}

// GetQuotes returns quotes for multiple symbols; fetches per symbol with fallback.
func (r *ProviderRegistry) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	out := make(map[string]*services.Quote, len(symbols))
	for _, symbol := range symbols {
		q, err := r.GetQuote(ctx, symbol)
		if err != nil {
			r.logger.Debug("GetQuotes: skip symbol", zap.String("symbol", symbol), zap.Error(err))
			continue
		}
		if q != nil {
			out[symbol] = q
		}
	}
	return out, nil
}

// GetHistoricalPrices tries each provider for the symbol's category until one returns data.
func (r *ProviderRegistry) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	r.mu.RLock()
	clients := r.providers[r.resolveCategory(symbol)]
	r.mu.RUnlock()

	var lastErr error
	for _, client := range clients {
		if !client.SupportsSymbol(symbol) {
			continue
		}
		points, err := client.GetHistoricalPrices(ctx, symbol, from, to)
		if err != nil {
			lastErr = err
			continue
		}
		if len(points) > 0 {
			return points, nil
		}
	}
	if lastErr != nil {
		return nil, lastErr
	}
	return nil, nil
}

// SupportsSymbol returns true if at least one provider for the default category supports the symbol.
func (r *ProviderRegistry) SupportsSymbol(symbol string) bool {
	r.mu.RLock()
	clients := r.providers[r.resolveCategory(symbol)]
	r.mu.RUnlock()
	for _, c := range clients {
		if c.SupportsSymbol(symbol) {
			return true
		}
	}
	return false
}

// Name returns a fixed name for the registry (used when registry is the single injected client).
func (r *ProviderRegistry) Name() string {
	return "market_data_registry"
}

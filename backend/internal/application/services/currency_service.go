package services

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// CurrencyService provides currency conversion functionality using forex market data.
// It abstracts the underlying forex providers and provides caching for efficiency.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type CurrencyService struct {
	forexClient services.MarketDataClient
	rateCache   map[string]*cachedRate
	cacheTTL    time.Duration
	mu          sync.RWMutex
}

// cachedRate stores a cached exchange rate with its fetch time.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type cachedRate struct {
	fetchedAt time.Time
	rate      float64
}

// NewCurrencyService creates a new CurrencyService with the given forex client and cache TTL.
func NewCurrencyService(forexClient services.MarketDataClient, cacheTTL time.Duration) *CurrencyService {
	if cacheTTL <= 0 {
		cacheTTL = 5 * time.Minute // Default cache TTL
	}
	return &CurrencyService{
		forexClient: forexClient,
		cacheTTL:    cacheTTL,
		rateCache:   make(map[string]*cachedRate),
	}
}

// Convert converts an amount from one currency to another.
// Returns the converted amount or an error if the conversion fails.
func (s *CurrencyService) Convert(ctx context.Context, amount float64, from, to string) (float64, error) {
	from = strings.ToUpper(strings.TrimSpace(from))
	to = strings.ToUpper(strings.TrimSpace(to))

	// Same currency, no conversion needed
	if from == to {
		return amount, nil
	}

	rate, err := s.GetExchangeRate(ctx, from, to)
	if err != nil {
		return 0, fmt.Errorf("currency conversion failed: %w", err)
	}

	return amount * rate, nil
}

// GetExchangeRate gets the exchange rate from one currency to another.
// Uses caching to minimize API calls.
func (s *CurrencyService) GetExchangeRate(ctx context.Context, from, to string) (float64, error) {
	from = strings.ToUpper(strings.TrimSpace(from))
	to = strings.ToUpper(strings.TrimSpace(to))

	// Same currency rate is 1
	if from == to {
		return 1.0, nil
	}

	cacheKey := fmt.Sprintf("%s/%s", from, to)

	// Check cache first
	s.mu.RLock()
	cached, ok := s.rateCache[cacheKey]
	s.mu.RUnlock()

	if ok && time.Since(cached.fetchedAt) < s.cacheTTL {
		return cached.rate, nil
	}

	// Fetch fresh rate
	rate, err := s.fetchRate(ctx, from, to)
	if err != nil {
		// If we have a stale cached value, return it rather than fail
		if ok {
			return cached.rate, nil
		}
		return 0, err
	}

	// Update cache
	s.mu.Lock()
	s.rateCache[cacheKey] = &cachedRate{
		rate:      rate,
		fetchedAt: time.Now(),
	}
	s.mu.Unlock()

	return rate, nil
}

// fetchRate fetches the exchange rate from the forex provider.
func (s *CurrencyService) fetchRate(ctx context.Context, from, to string) (float64, error) {
	symbol := fmt.Sprintf("%s/%s", from, to)

	quote, err := s.forexClient.GetQuote(ctx, symbol)
	if err != nil {
		// Try reverse pair and invert
		reverseSymbol := fmt.Sprintf("%s/%s", to, from)
		reverseQuote, reverseErr := s.forexClient.GetQuote(ctx, reverseSymbol)
		if reverseErr != nil {
			return 0, fmt.Errorf("failed to get rate for %s: %w", symbol, err)
		}
		if reverseQuote.Price == 0 {
			return 0, fmt.Errorf("invalid rate (zero) for %s", reverseSymbol)
		}
		return 1.0 / reverseQuote.Price, nil
	}

	if quote.Price == 0 {
		return 0, fmt.Errorf("invalid rate (zero) for %s", symbol)
	}

	return quote.Price, nil
}

// ConvertMultiple converts an amount to multiple target currencies.
// Returns a map of currency code to converted amount.
func (s *CurrencyService) ConvertMultiple(ctx context.Context, amount float64, from string, toCurrencies []string) (map[string]float64, error) {
	from = strings.ToUpper(strings.TrimSpace(from))
	results := make(map[string]float64, len(toCurrencies))

	for _, to := range toCurrencies {
		to = strings.ToUpper(strings.TrimSpace(to))
		converted, err := s.Convert(ctx, amount, from, to)
		if err != nil {
			// Skip failed conversions but continue with others
			continue
		}
		results[to] = converted
	}

	return results, nil
}

// GetSupportedCurrencies returns a list of commonly supported currencies.
// This is a static list; actual support depends on the forex provider.
func (s *CurrencyService) GetSupportedCurrencies() []string {
	return []string{
		"USD", "EUR", "GBP", "JPY", "CHF", "CAD", "AUD", "NZD",
		"CNY", "HKD", "SGD", "KRW", "INR", "MXN", "BRL", "ZAR",
		"SEK", "NOK", "DKK", "PLN", "TRY", "THB", "IDR", "MYR",
	}
}

// ClearCache clears the exchange rate cache.
func (s *CurrencyService) ClearCache() {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.rateCache = make(map[string]*cachedRate)
}

// GetCacheStats returns cache statistics for monitoring.
func (s *CurrencyService) GetCacheStats() (size int, hitRate float64) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return len(s.rateCache), 0 // Hit rate tracking would require more infrastructure
}

package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	exchangeRateBaseURL        = "https://open.er-api.com"
	exchangeRateDefaultTimeout = 15 * time.Second
)

// ExchangeRateClient implements services.MarketDataClient for ExchangeRate-API.
// Free tier: 1500 requests/month. No API key required for open endpoint.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ExchangeRateClient struct {
	httpClient   *http.Client
	apiKey       string // Optional, for paid tier
	baseURL      string
	rateLimiter  *RateLimiter
	symbolMapper *ForexSymbolMapper
}

// NewExchangeRateClient creates a new ExchangeRate-API client.
// apiKey is optional for the free tier.
// If rateLimiter is nil, no rate limiting is applied.
func NewExchangeRateClient(apiKey string, rateLimiter *RateLimiter, mapper *ForexSymbolMapper) *ExchangeRateClient {
	return &ExchangeRateClient{
		httpClient: &http.Client{
			Timeout: exchangeRateDefaultTimeout,
		},
		apiKey:       apiKey,
		baseURL:      exchangeRateBaseURL,
		rateLimiter:  rateLimiter,
		symbolMapper: mapper,
	}
}

// exchangeRateLatestResponse represents the /v6/latest endpoint response.
//
//nolint:govet // fieldalignment: match API response structure
type exchangeRateLatestResponse struct {
	Result             string             `json:"result"`
	Documentation      string             `json:"documentation"`
	TermsOfUse         string             `json:"terms_of_use"`
	TimeLastUpdateUnix int64              `json:"time_last_update_unix"`
	TimeLastUpdateUTC  string             `json:"time_last_update_utc"`
	TimeNextUpdateUnix int64              `json:"time_next_update_unix"`
	TimeNextUpdateUTC  string             `json:"time_next_update_utc"`
	BaseCode           string             `json:"base_code"`
	Rates              map[string]float64 `json:"rates"`
}

// GetQuote fetches the latest exchange rate for a forex pair.
func (c *ExchangeRateClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("exchangerate: rate limit wait: %w", err)
		}
	}

	base, quote, ok := c.symbolMapper.ParsePair(symbol)
	if !ok {
		return nil, fmt.Errorf("exchangerate: invalid forex symbol %s", symbol)
	}

	// Build URL - ExchangeRate uses base currency in path
	urlStr := fmt.Sprintf("%s/v6/latest/%s", c.baseURL, base)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, urlStr, nil)
	if err != nil {
		return nil, fmt.Errorf("exchangerate: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("exchangerate: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("exchangerate: unexpected status %d", resp.StatusCode)
	}

	var result exchangeRateLatestResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("exchangerate: decode response: %w", err)
	}

	if result.Result != "success" {
		return nil, fmt.Errorf("exchangerate: API returned error")
	}

	rate, ok := result.Rates[quote]
	if !ok {
		return nil, fmt.Errorf("exchangerate: rate not found for %s", quote)
	}

	// Parse timestamp
	var updatedAt time.Time
	if result.TimeLastUpdateUnix > 0 {
		updatedAt = time.Unix(result.TimeLastUpdateUnix, 0).UTC()
	} else {
		updatedAt = time.Now().UTC()
	}

	return &services.Quote{
		Symbol:        c.symbolMapper.FormatPair(base, quote),
		Price:         rate,
		Change:        0, // ExchangeRate doesn't provide change data
		ChangePercent: 0,
		MarketState:   c.determineMarketState(),
		Currency:      quote,
		UpdatedAt:     updatedAt,
		Source:        c.Name(),
	}, nil
}

// GetQuotes fetches quotes for multiple forex pairs.
func (c *ExchangeRateClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	quotes := make(map[string]*services.Quote, len(symbols))

	// Group by base currency for efficient requests
	baseToQuotes := make(map[string][]string)

	for _, symbol := range symbols {
		base, quote, ok := c.symbolMapper.ParsePair(symbol)
		if !ok {
			continue
		}
		baseToQuotes[base] = append(baseToQuotes[base], quote)
	}

	// Make requests per base currency
	for base, quoteCurrencies := range baseToQuotes {
		if c.rateLimiter != nil {
			if err := c.rateLimiter.Wait(ctx); err != nil {
				continue
			}
		}

		urlStr := fmt.Sprintf("%s/v6/latest/%s", c.baseURL, base)

		req, err := http.NewRequestWithContext(ctx, http.MethodGet, urlStr, nil)
		if err != nil {
			continue
		}

		req.Header.Set("Accept", "application/json")
		req.Header.Set("User-Agent", "WealthScope/1.0")

		resp, err := c.httpClient.Do(req)
		if err != nil {
			continue
		}

		var result exchangeRateLatestResponse
		if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
			resp.Body.Close()
			continue
		}
		resp.Body.Close()

		if result.Result != "success" {
			continue
		}

		// Parse timestamp
		var updatedAt time.Time
		if result.TimeLastUpdateUnix > 0 {
			updatedAt = time.Unix(result.TimeLastUpdateUnix, 0).UTC()
		} else {
			updatedAt = time.Now().UTC()
		}

		marketState := c.determineMarketState()

		for _, quoteCurrency := range quoteCurrencies {
			rate, ok := result.Rates[quoteCurrency]
			if !ok {
				continue
			}

			key := c.symbolMapper.FormatPair(base, quoteCurrency)
			quotes[key] = &services.Quote{
				Symbol:        key,
				Price:         rate,
				Change:        0,
				ChangePercent: 0,
				MarketState:   marketState,
				Currency:      quoteCurrency,
				UpdatedAt:     updatedAt,
				Source:        c.Name(),
			}
		}
	}

	return quotes, nil
}

// GetHistoricalPrices is not fully supported by the free tier of ExchangeRate-API.
// Returns nil for now - use Frankfurter for historical data.
func (c *ExchangeRateClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	// ExchangeRate-API free tier doesn't support historical data
	// Return nil to let the registry try another provider
	_ = ctx
	_ = symbol
	_ = from
	_ = to
	return nil, nil
}

// SupportsSymbol returns true if the symbol is a valid forex pair.
func (c *ExchangeRateClient) SupportsSymbol(symbol string) bool {
	if c.symbolMapper == nil {
		return false
	}
	return c.symbolMapper.IsForexSymbol(symbol)
}

// Name returns the provider name.
func (c *ExchangeRateClient) Name() string {
	return "exchangerate"
}

// determineMarketState returns the forex market state.
func (c *ExchangeRateClient) determineMarketState() string {
	now := time.Now().UTC()
	weekday := now.Weekday()

	// Forex is closed on weekends
	if weekday == time.Saturday || weekday == time.Sunday {
		return "CLOSED"
	}

	return "OPEN"
}

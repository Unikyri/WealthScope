package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"sort"
	"strings"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	frankfurterBaseURL        = "https://api.frankfurter.app"
	frankfurterDefaultTimeout = 15 * time.Second
)

// FrankfurterClient implements services.MarketDataClient for Frankfurter API.
// Frankfurter is a free, open-source API for currency exchange rates.
// No API key required. Uses ECB (European Central Bank) data.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type FrankfurterClient struct {
	httpClient   *http.Client
	baseURL      string
	rateLimiter  *RateLimiter
	symbolMapper *ForexSymbolMapper
}

// NewFrankfurterClient creates a new Frankfurter client.
// No API key is required. If rateLimiter is nil, no rate limiting is applied.
func NewFrankfurterClient(rateLimiter *RateLimiter, mapper *ForexSymbolMapper) *FrankfurterClient {
	return &FrankfurterClient{
		httpClient: &http.Client{
			Timeout: frankfurterDefaultTimeout,
		},
		baseURL:      frankfurterBaseURL,
		rateLimiter:  rateLimiter,
		symbolMapper: mapper,
	}
}

// frankfurterLatestResponse represents the /latest endpoint response.
//
//nolint:govet // fieldalignment: match API response structure
type frankfurterLatestResponse struct {
	Amount float64            `json:"amount"`
	Base   string             `json:"base"`
	Date   string             `json:"date"`
	Rates  map[string]float64 `json:"rates"`
}

// frankfurterTimeseriesResponse represents the /timeseries endpoint response.
//
//nolint:govet // fieldalignment: match API response structure
type frankfurterTimeseriesResponse struct {
	Amount    float64                       `json:"amount"`
	Base      string                        `json:"base"`
	StartDate string                        `json:"start_date"`
	EndDate   string                        `json:"end_date"`
	Rates     map[string]map[string]float64 `json:"rates"` // date -> currency -> rate
}

// GetQuote fetches the latest exchange rate for a forex pair.
func (c *FrankfurterClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("frankfurter: rate limit wait: %w", err)
		}
	}

	base, quote, ok := c.symbolMapper.ParsePair(symbol)
	if !ok {
		return nil, fmt.Errorf("frankfurter: invalid forex symbol %s", symbol)
	}

	// Build URL
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: parse base URL: %w", err)
	}
	u.Path = u.Path + "/latest"

	q := u.Query()
	q.Set("from", base)
	q.Set("to", quote)
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("frankfurter: unexpected status %d", resp.StatusCode)
	}

	var result frankfurterLatestResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("frankfurter: decode response: %w", err)
	}

	rate, ok := result.Rates[quote]
	if !ok {
		return nil, fmt.Errorf("frankfurter: rate not found for %s", quote)
	}

	// Parse date
	var updatedAt time.Time
	if result.Date != "" {
		parsedDate, err := time.Parse("2006-01-02", result.Date)
		if err == nil {
			updatedAt = parsedDate
		} else {
			updatedAt = time.Now().UTC()
		}
	} else {
		updatedAt = time.Now().UTC()
	}

	return &services.Quote{
		Symbol:        c.symbolMapper.FormatPair(base, quote),
		Price:         rate,
		Change:        0, // Frankfurter doesn't provide change data
		ChangePercent: 0,
		MarketState:   c.determineMarketState(),
		Currency:      quote,
		UpdatedAt:     updatedAt,
		Source:        c.Name(),
	}, nil
}

// GetQuotes fetches quotes for multiple forex pairs.
// Frankfurter supports batch requests with multiple "to" currencies.
func (c *FrankfurterClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	quotes := make(map[string]*services.Quote, len(symbols))

	// Group by base currency for efficient batch requests
	baseToQuotes := make(map[string][]string)
	symbolToKey := make(map[string]string)

	for _, symbol := range symbols {
		base, quote, ok := c.symbolMapper.ParsePair(symbol)
		if !ok {
			continue
		}
		baseToQuotes[base] = append(baseToQuotes[base], quote)
		key := c.symbolMapper.FormatPair(base, quote)
		symbolToKey[symbol] = key
	}

	// Make batch requests per base currency
	for base, quoteCurrencies := range baseToQuotes {
		if c.rateLimiter != nil {
			if err := c.rateLimiter.Wait(ctx); err != nil {
				continue
			}
		}

		// Build URL with multiple to currencies
		u, err := url.Parse(c.baseURL)
		if err != nil {
			continue
		}
		u.Path = u.Path + "/latest"

		q := u.Query()
		q.Set("from", base)
		q.Set("to", strings.Join(quoteCurrencies, ","))
		u.RawQuery = q.Encode()

		req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
		if err != nil {
			continue
		}

		req.Header.Set("Accept", "application/json")
		req.Header.Set("User-Agent", "WealthScope/1.0")

		resp, err := c.httpClient.Do(req)
		if err != nil {
			continue
		}

		var result frankfurterLatestResponse
		if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
			resp.Body.Close()
			continue
		}
		resp.Body.Close()

		// Parse date
		var updatedAt time.Time
		if result.Date != "" {
			parsedDate, _ := time.Parse("2006-01-02", result.Date)
			updatedAt = parsedDate
		} else {
			updatedAt = time.Now().UTC()
		}

		marketState := c.determineMarketState()

		for quoteCurrency, rate := range result.Rates {
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

// GetHistoricalPrices fetches historical exchange rates using the timeseries endpoint.
func (c *FrankfurterClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("frankfurter: rate limit wait: %w", err)
		}
	}

	base, quote, ok := c.symbolMapper.ParsePair(symbol)
	if !ok {
		return nil, fmt.Errorf("frankfurter: invalid forex symbol %s", symbol)
	}

	// Build URL for timeseries
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: parse base URL: %w", err)
	}

	// Frankfurter uses date range in path: /{start_date}..{end_date}
	u.Path = fmt.Sprintf("%s/%s..%s", u.Path, from.Format("2006-01-02"), to.Format("2006-01-02"))

	q := u.Query()
	q.Set("from", base)
	q.Set("to", quote)
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("frankfurter: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("frankfurter: unexpected status %d", resp.StatusCode)
	}

	var result frankfurterTimeseriesResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("frankfurter: decode response: %w", err)
	}

	if len(result.Rates) == 0 {
		return nil, fmt.Errorf("frankfurter: no historical data for %s", symbol)
	}

	// Convert to PricePoints
	points := make([]services.PricePoint, 0, len(result.Rates))

	for dateStr, rates := range result.Rates {
		rate, ok := rates[quote]
		if !ok {
			continue
		}

		date, err := time.Parse("2006-01-02", dateStr)
		if err != nil {
			continue
		}

		// Forex doesn't have OHLC, use rate as all values
		points = append(points, services.PricePoint{
			Timestamp: date,
			Open:      rate,
			High:      rate,
			Low:       rate,
			Close:     rate,
			Volume:    0, // Forex doesn't have volume data from Frankfurter
		})
	}

	// Sort by date ascending
	sort.Slice(points, func(i, j int) bool {
		return points[i].Timestamp.Before(points[j].Timestamp)
	})

	return points, nil
}

// SupportsSymbol returns true if the symbol is a valid forex pair.
func (c *FrankfurterClient) SupportsSymbol(symbol string) bool {
	if c.symbolMapper == nil {
		return false
	}
	return c.symbolMapper.IsForexSymbol(symbol)
}

// Name returns the provider name.
func (c *FrankfurterClient) Name() string {
	return "frankfurter"
}

// determineMarketState returns the forex market state.
// Forex markets are open 24/5 (closed on weekends).
func (c *FrankfurterClient) determineMarketState() string {
	now := time.Now().UTC()
	weekday := now.Weekday()

	// Forex is closed on weekends
	if weekday == time.Saturday || weekday == time.Sunday {
		return "CLOSED"
	}

	return "OPEN"
}

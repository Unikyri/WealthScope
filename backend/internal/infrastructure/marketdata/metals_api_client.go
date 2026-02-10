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
	metalPriceAPIBaseURL        = "https://api.metalpriceapi.com/v1"
	metalPriceAPIDefaultTimeout = 15 * time.Second
)

// MetalsAPIClient implements services.MarketDataClient for MetalPriceAPI.
// MetalPriceAPI provides precious metals pricing data (gold, silver, platinum, palladium).
// Requires an API key. Free tier: 50 requests/month.
// Docs: https://metalpriceapi.com/documentation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type MetalsAPIClient struct {
	httpClient   *http.Client
	rateLimiter  *RateLimiter
	symbolMapper *MetalsSymbolMapper
	apiKey       string
	baseURL      string
}

// NewMetalsAPIClient creates a new MetalPriceAPI client.
// apiKey is required. If rateLimiter is nil, no rate limiting is applied.
func NewMetalsAPIClient(apiKey string, rateLimiter *RateLimiter, mapper *MetalsSymbolMapper) *MetalsAPIClient {
	return &MetalsAPIClient{
		httpClient: &http.Client{
			Timeout: metalPriceAPIDefaultTimeout,
		},
		apiKey:       apiKey,
		baseURL:      metalPriceAPIBaseURL,
		rateLimiter:  rateLimiter,
		symbolMapper: mapper,
	}
}

// metalsAPILatestResponse represents the /latest endpoint response.
//
//nolint:govet // fieldalignment: match API response structure
type metalsAPILatestResponse struct {
	Rates     map[string]float64 `json:"rates"`
	Base      string             `json:"base"`
	Date      string             `json:"date"`
	Timestamp int64              `json:"timestamp"`
	Success   bool               `json:"success"`
}

// metalsAPIHistoricalResponse represents the /{date} endpoint response.
//
//nolint:govet // fieldalignment: match API response structure
type metalsAPIHistoricalResponse struct {
	Rates      map[string]float64 `json:"rates"`
	Base       string             `json:"base"`
	Date       string             `json:"date"`
	Timestamp  int64              `json:"timestamp"`
	Success    bool               `json:"success"`
	Historical bool               `json:"historical"`
}

// GetQuote fetches the latest price for a precious metal.
func (c *MetalsAPIClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("metals_api: rate limit wait: %w", err)
		}
	}

	apiSymbol, ok := c.symbolMapper.ToAPISymbol(symbol)
	if !ok {
		return nil, fmt.Errorf("metals_api: unknown metal symbol %s", symbol)
	}

	// Build URL for /latest endpoint
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("metalprice_api: parse base URL: %w", err)
	}
	u.Path = u.Path + "/latest"

	q := u.Query()
	q.Set("api_key", c.apiKey)
	q.Set("base", "USD")
	q.Set("currencies", apiSymbol)
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("metalprice_api: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("metals_api: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("metals_api: unexpected status %d", resp.StatusCode)
	}

	var result metalsAPILatestResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("metals_api: decode response: %w", err)
	}

	if !result.Success {
		return nil, fmt.Errorf("metals_api: API returned error")
	}

	// Get price - try direct USD price first (USDXAU), then calculate from inverse rate
	price, ok := c.extractPrice(result.Rates, apiSymbol)
	if !ok {
		return nil, fmt.Errorf("metals_api: price not found for %s", apiSymbol)
	}

	// Parse timestamp
	var updatedAt time.Time
	if result.Timestamp > 0 {
		updatedAt = time.Unix(result.Timestamp, 0).UTC()
	} else {
		updatedAt = time.Now().UTC()
	}

	return &services.Quote{
		Symbol:        apiSymbol,
		Price:         price,
		Change:        0, // MetalPriceAPI doesn't provide change in /latest
		ChangePercent: 0,
		MarketState:   c.determineMarketState(),
		Currency:      "USD",
		UpdatedAt:     updatedAt,
		Source:        c.Name(),
	}, nil
}

// extractPrice extracts the USD price from the rates map.
// MetalPriceAPI returns both inverse rates (XAU: 0.00048) and direct prices (USDXAU: 2069).
// We prefer the direct price if available, otherwise calculate from inverse.
func (c *MetalsAPIClient) extractPrice(rates map[string]float64, apiSymbol string) (float64, bool) {
	// Try direct USD price first (e.g., "USDXAU")
	directKey := "USD" + apiSymbol
	if price, ok := rates[directKey]; ok && price > 0 {
		return price, true
	}

	// Fall back to calculating from inverse rate
	// When base=USD, rate is how much of the metal you get per USD
	// So price = 1/rate (how many USD per unit of metal)
	if rate, ok := rates[apiSymbol]; ok && rate > 0 {
		return 1.0 / rate, true
	}

	return 0, false
}

// GetQuotes fetches quotes for multiple precious metals.
func (c *MetalsAPIClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	quotes := make(map[string]*services.Quote, len(symbols))

	// Collect valid API symbols
	apiSymbols := make([]string, 0, len(symbols))
	symbolMapping := make(map[string]string) // apiSymbol -> original symbol

	for _, symbol := range symbols {
		apiSymbol, ok := c.symbolMapper.ToAPISymbol(symbol)
		if !ok {
			continue
		}
		// Avoid duplicates
		if _, exists := symbolMapping[apiSymbol]; !exists {
			apiSymbols = append(apiSymbols, apiSymbol)
			symbolMapping[apiSymbol] = symbol
		}
	}

	if len(apiSymbols) == 0 {
		return quotes, nil
	}

	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return quotes, nil
		}
	}

	// Build URL with all symbols
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return quotes, nil
	}
	u.Path = u.Path + "/latest"

	q := u.Query()
	q.Set("api_key", c.apiKey)
	q.Set("base", "USD")
	q.Set("currencies", strings.Join(apiSymbols, ","))
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return quotes, nil
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return quotes, nil
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return quotes, nil
	}

	var result metalsAPILatestResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return quotes, nil
	}

	if !result.Success {
		return quotes, nil
	}

	// Parse timestamp
	var updatedAt time.Time
	if result.Timestamp > 0 {
		updatedAt = time.Unix(result.Timestamp, 0).UTC()
	} else {
		updatedAt = time.Now().UTC()
	}

	marketState := c.determineMarketState()

	// Extract prices for each requested symbol
	for _, apiSymbol := range apiSymbols {
		price, ok := c.extractPrice(result.Rates, apiSymbol)
		if !ok {
			continue
		}

		quotes[apiSymbol] = &services.Quote{
			Symbol:        apiSymbol,
			Price:         price,
			Change:        0,
			ChangePercent: 0,
			MarketState:   marketState,
			Currency:      "USD",
			UpdatedAt:     updatedAt,
			Source:        c.Name(),
		}
	}

	return quotes, nil
}

// GetHistoricalPrices fetches historical prices for a precious metal.
// Note: Free tier doesn't support timeseries, so we fetch individual dates.
func (c *MetalsAPIClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	apiSymbol, ok := c.symbolMapper.ToAPISymbol(symbol)
	if !ok {
		return nil, fmt.Errorf("metals_api: unknown metal symbol %s", symbol)
	}

	// Generate list of dates to fetch (excluding weekends for metals market)
	dates := c.generateTradingDates(from, to)
	if len(dates) == 0 {
		return nil, nil
	}

	// Limit to avoid excessive API calls (free tier has 50/month)
	maxDates := 30
	if len(dates) > maxDates {
		// Sample evenly
		step := len(dates) / maxDates
		if step < 1 {
			step = 1
		}
		sampled := make([]time.Time, 0, maxDates)
		for i := 0; i < len(dates) && len(sampled) < maxDates; i += step {
			sampled = append(sampled, dates[i])
		}
		dates = sampled
	}

	points := make([]services.PricePoint, 0, len(dates))

	for _, date := range dates {
		if c.rateLimiter != nil {
			if err := c.rateLimiter.Wait(ctx); err != nil {
				continue
			}
		}

		point, err := c.fetchHistoricalPrice(ctx, apiSymbol, date)
		if err != nil {
			continue // Skip failed dates
		}
		if point != nil {
			points = append(points, *point)
		}
	}

	// Sort by date ascending
	sort.Slice(points, func(i, j int) bool {
		return points[i].Timestamp.Before(points[j].Timestamp)
	})

	return points, nil
}

// fetchHistoricalPrice fetches the price for a single date.
func (c *MetalsAPIClient) fetchHistoricalPrice(ctx context.Context, apiSymbol string, date time.Time) (*services.PricePoint, error) {
	// Build URL for historical endpoint: /{YYYY-MM-DD}
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, err
	}
	u.Path = fmt.Sprintf("%s/%s", u.Path, date.Format("2006-01-02"))

	q := u.Query()
	q.Set("api_key", c.apiKey)
	q.Set("base", "USD")
	q.Set("currencies", apiSymbol)
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("status %d", resp.StatusCode)
	}

	var result metalsAPIHistoricalResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, err
	}

	if !result.Success {
		return nil, fmt.Errorf("API error")
	}

	price, ok := c.extractPrice(result.Rates, apiSymbol)
	if !ok {
		return nil, fmt.Errorf("price not found")
	}

	// Metals don't have OHLC in free tier, use close price for all
	return &services.PricePoint{
		Timestamp: date,
		Open:      price,
		High:      price,
		Low:       price,
		Close:     price,
		Volume:    0, // No volume data for spot metals
	}, nil
}

// generateTradingDates generates a list of trading dates between from and to.
// Excludes weekends as metals markets are closed.
func (c *MetalsAPIClient) generateTradingDates(from, to time.Time) []time.Time {
	var dates []time.Time

	// Normalize to start of day
	current := time.Date(from.Year(), from.Month(), from.Day(), 0, 0, 0, 0, time.UTC)
	end := time.Date(to.Year(), to.Month(), to.Day(), 0, 0, 0, 0, time.UTC)

	for !current.After(end) {
		weekday := current.Weekday()
		// Include Monday through Friday
		if weekday != time.Saturday && weekday != time.Sunday {
			dates = append(dates, current)
		}
		current = current.AddDate(0, 0, 1)
	}

	return dates
}

// SupportsSymbol returns true if the symbol is a precious metal.
func (c *MetalsAPIClient) SupportsSymbol(symbol string) bool {
	if c.symbolMapper == nil {
		return false
	}
	return c.symbolMapper.IsMetalSymbol(symbol)
}

// Name returns the provider name.
func (c *MetalsAPIClient) Name() string {
	return "metalprice_api"
}

// determineMarketState returns the market state for precious metals.
// Metals markets trade 23 hours/day, 5 days/week (closed weekends).
func (c *MetalsAPIClient) determineMarketState() string {
	now := time.Now().UTC()
	weekday := now.Weekday()

	// Metals markets are closed on weekends
	if weekday == time.Saturday || weekday == time.Sunday {
		return "CLOSED"
	}

	return "OPEN"
}

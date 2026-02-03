package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	finnhubBaseURL        = "https://finnhub.io/api/v1"
	finnhubDefaultTimeout = 15 * time.Second
)

// FinnhubClient implements services.MarketDataClient for Finnhub API.
// Uses /quote for current prices and /stock/candle for historical data.
// Free tier: 60 requests/minute.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type FinnhubClient struct {
	httpClient  *http.Client
	apiKey      string
	baseURL     string
	rateLimiter *RateLimiter
}

// NewFinnhubClient creates a new Finnhub client with the given API key.
// If rateLimiter is nil, no rate limiting is applied.
func NewFinnhubClient(apiKey string, rateLimiter *RateLimiter) *FinnhubClient {
	return &FinnhubClient{
		httpClient: &http.Client{
			Timeout: finnhubDefaultTimeout,
		},
		apiKey:      apiKey,
		baseURL:     finnhubBaseURL,
		rateLimiter: rateLimiter,
	}
}

// finnhubQuoteResponse represents the Finnhub /quote API response.
type finnhubQuoteResponse struct {
	CurrentPrice  float64 `json:"c"`  // Current price
	Change        float64 `json:"d"`  // Change
	PercentChange float64 `json:"dp"` // Percent change
	High          float64 `json:"h"`  // High price of the day
	Low           float64 `json:"l"`  // Low price of the day
	Open          float64 `json:"o"`  // Open price of the day
	PreviousClose float64 `json:"pc"` // Previous close price
	Timestamp     int64   `json:"t"`  // Timestamp (Unix)
}

// finnhubCandleResponse represents the Finnhub /stock/candle API response.
type finnhubCandleResponse struct {
	Close     []float64 `json:"c"` // Close prices
	High      []float64 `json:"h"` // High prices
	Low       []float64 `json:"l"` // Low prices
	Open      []float64 `json:"o"` // Open prices
	Status    string    `json:"s"` // Status: "ok" or "no_data"
	Timestamp []int64   `json:"t"` // Timestamps (Unix)
	Volume    []int64   `json:"v"` // Volumes
}

// GetQuote fetches the latest quote for a symbol using /quote endpoint.
func (c *FinnhubClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("finnhub: rate limit wait: %w", err)
		}
	}

	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return nil, fmt.Errorf("finnhub: empty symbol")
	}

	url := fmt.Sprintf("%s/quote?symbol=%s&token=%s", c.baseURL, symbol, c.apiKey)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("finnhub: create request: %w", err)
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("finnhub: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("finnhub: unexpected status %d", resp.StatusCode)
	}

	var result finnhubQuoteResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("finnhub: decode response: %w", err)
	}

	// Check for empty/invalid response (price == 0 and timestamp == 0)
	if result.CurrentPrice == 0 && result.Timestamp == 0 {
		return nil, fmt.Errorf("finnhub: no data for symbol %s", symbol)
	}

	return c.parseQuoteResponse(symbol, &result), nil
}

// GetQuotes fetches quotes for multiple symbols. Finnhub doesn't support batch quotes,
// so this makes sequential calls for each symbol.
func (c *FinnhubClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	quotes := make(map[string]*services.Quote, len(symbols))

	for _, symbol := range symbols {
		select {
		case <-ctx.Done():
			return quotes, ctx.Err()
		default:
		}

		q, err := c.GetQuote(ctx, symbol)
		if err != nil {
			// Skip failed symbols, don't fail entire batch
			continue
		}
		quotes[strings.ToUpper(symbol)] = q
	}

	return quotes, nil
}

// GetHistoricalPrices fetches daily OHLCV data using /stock/candle endpoint.
func (c *FinnhubClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("finnhub: rate limit wait: %w", err)
		}
	}

	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return nil, fmt.Errorf("finnhub: empty symbol")
	}

	// Convert times to Unix timestamps
	fromUnix := from.Unix()
	toUnix := to.Unix()

	// Resolution: D = daily candles
	url := fmt.Sprintf("%s/stock/candle?symbol=%s&resolution=D&from=%d&to=%d&token=%s",
		c.baseURL, symbol, fromUnix, toUnix, c.apiKey)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("finnhub: create request: %w", err)
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("finnhub: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("finnhub: unexpected status %d", resp.StatusCode)
	}

	var result finnhubCandleResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("finnhub: decode response: %w", err)
	}

	// Check for no data
	if result.Status == "no_data" || len(result.Close) == 0 {
		return nil, fmt.Errorf("finnhub: no historical data for symbol %s", symbol)
	}

	return c.parseCandleResponse(&result), nil
}

// SupportsSymbol returns true for US stock/ETF symbols.
// Finnhub supports US stocks, forex, and crypto.
func (c *FinnhubClient) SupportsSymbol(symbol string) bool {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return false
	}
	// Basic validation: 1-5 uppercase letters for US stocks
	// Finnhub uses plain symbols for US stocks (AAPL, MSFT)
	return len(symbol) >= 1 && len(symbol) <= 10
}

// Name returns the provider name.
func (c *FinnhubClient) Name() string {
	return "finnhub"
}

// parseQuoteResponse converts Finnhub quote response to domain Quote.
func (c *FinnhubClient) parseQuoteResponse(symbol string, data *finnhubQuoteResponse) *services.Quote {
	var updatedAt time.Time
	if data.Timestamp > 0 {
		updatedAt = time.Unix(data.Timestamp, 0).UTC()
	} else {
		updatedAt = time.Now().UTC()
	}

	// Determine market state based on time
	marketState := c.determineMarketState()

	return &services.Quote{
		Symbol:        symbol,
		Price:         data.CurrentPrice,
		Change:        data.Change,
		ChangePercent: data.PercentChange,
		MarketState:   marketState,
		Currency:      "USD", // Finnhub returns US stocks in USD
		UpdatedAt:     updatedAt,
		Source:        c.Name(),
	}
}

// parseCandleResponse converts Finnhub candle response to domain PricePoints.
func (c *FinnhubClient) parseCandleResponse(data *finnhubCandleResponse) []services.PricePoint {
	n := len(data.Timestamp)
	points := make([]services.PricePoint, 0, n)

	for i := 0; i < n; i++ {
		var volume int64
		if i < len(data.Volume) {
			volume = data.Volume[i]
		}

		var open, high, low, closePrice float64
		if i < len(data.Open) {
			open = data.Open[i]
		}
		if i < len(data.High) {
			high = data.High[i]
		}
		if i < len(data.Low) {
			low = data.Low[i]
		}
		if i < len(data.Close) {
			closePrice = data.Close[i]
		}

		points = append(points, services.PricePoint{
			Timestamp: time.Unix(data.Timestamp[i], 0).UTC(),
			Open:      open,
			High:      high,
			Low:       low,
			Close:     closePrice,
			Volume:    volume,
		})
	}

	return points
}

// determineMarketState returns the current US market state based on time.
func (c *FinnhubClient) determineMarketState() string {
	loc, err := time.LoadLocation("America/New_York")
	if err != nil {
		return "UNKNOWN"
	}

	now := time.Now().In(loc)
	weekday := now.Weekday()
	hour := now.Hour()
	minute := now.Minute()

	// Weekend
	if weekday == time.Saturday || weekday == time.Sunday {
		return "CLOSED"
	}

	// Market hours: 9:30 AM - 4:00 PM ET
	marketOpen := hour > 9 || (hour == 9 && minute >= 30)
	marketClose := hour < 16

	if marketOpen && marketClose {
		return "REGULAR"
	}

	// Pre-market: 4:00 AM - 9:30 AM ET
	if hour >= 4 && (hour < 9 || (hour == 9 && minute < 30)) {
		return "PRE"
	}

	// Post-market: 4:00 PM - 8:00 PM ET
	if hour >= 16 && hour < 20 {
		return "POST"
	}

	return "CLOSED"
}

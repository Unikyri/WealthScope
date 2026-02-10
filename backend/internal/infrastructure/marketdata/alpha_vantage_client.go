package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	alphaVantageBaseURL        = "https://www.alphavantage.co/query"
	alphaVantageDefaultTimeout = 15 * time.Second
)

// AlphaVantageClient implements services.MarketDataClient for Alpha Vantage API.
// Uses GLOBAL_QUOTE for current prices and TIME_SERIES_DAILY for historical data.
// Free tier: 25 requests/day, so use conservatively as a fallback provider.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AlphaVantageClient struct {
	httpClient  *http.Client
	rateLimiter *RateLimiter
	apiKey      string
	baseURL     string
}

// NewAlphaVantageClient creates a new Alpha Vantage client with the given API key.
// If rateLimiter is nil, no rate limiting is applied.
func NewAlphaVantageClient(apiKey string, rateLimiter *RateLimiter) *AlphaVantageClient {
	return &AlphaVantageClient{
		httpClient: &http.Client{
			Timeout: alphaVantageDefaultTimeout,
		},
		apiKey:      apiKey,
		baseURL:     alphaVantageBaseURL,
		rateLimiter: rateLimiter,
	}
}

// globalQuoteResponse represents the Alpha Vantage GLOBAL_QUOTE API response.
type globalQuoteResponse struct {
	GlobalQuote globalQuoteData `json:"Global Quote"`
}

type globalQuoteData struct {
	Symbol           string `json:"01. symbol"`
	Open             string `json:"02. open"`
	High             string `json:"03. high"`
	Low              string `json:"04. low"`
	Price            string `json:"05. price"`
	Volume           string `json:"06. volume"`
	LatestTradingDay string `json:"07. latest trading day"`
	PreviousClose    string `json:"08. previous close"`
	Change           string `json:"09. change"`
	ChangePercent    string `json:"10. change percent"`
}

// timeSeriesDailyResponse represents the Alpha Vantage TIME_SERIES_DAILY API response.
type timeSeriesDailyResponse struct {
	MetaData   map[string]string         `json:"Meta Data"`
	TimeSeries map[string]dailyOHLCVData `json:"Time Series (Daily)"`
}

type dailyOHLCVData struct {
	Open   string `json:"1. open"`
	High   string `json:"2. high"`
	Low    string `json:"3. low"`
	Close  string `json:"4. close"`
	Volume string `json:"5. volume"`
}

// GetQuote fetches the latest quote for a symbol using GLOBAL_QUOTE endpoint.
func (c *AlphaVantageClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("alpha_vantage: rate limit wait: %w", err)
		}
	}

	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return nil, fmt.Errorf("alpha_vantage: empty symbol")
	}

	url := fmt.Sprintf("%s?function=GLOBAL_QUOTE&symbol=%s&apikey=%s", c.baseURL, symbol, c.apiKey)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("alpha_vantage: create request: %w", err)
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("alpha_vantage: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("alpha_vantage: unexpected status %d", resp.StatusCode)
	}

	var result globalQuoteResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("alpha_vantage: decode response: %w", err)
	}

	// Check for empty response (API limit reached or invalid symbol)
	if result.GlobalQuote.Symbol == "" {
		return nil, fmt.Errorf("alpha_vantage: no data for symbol %s (API limit or invalid symbol)", symbol)
	}

	return c.parseGlobalQuote(&result.GlobalQuote)
}

// GetQuotes fetches quotes for multiple symbols. Alpha Vantage doesn't support batch quotes,
// so this makes sequential calls for each symbol.
func (c *AlphaVantageClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
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

// GetHistoricalPrices fetches daily OHLCV data using TIME_SERIES_DAILY endpoint.
func (c *AlphaVantageClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("alpha_vantage: rate limit wait: %w", err)
		}
	}

	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return nil, fmt.Errorf("alpha_vantage: empty symbol")
	}

	// Use outputsize=full to get more historical data (20+ years)
	// Use outputsize=compact for only last 100 data points
	outputSize := "compact"
	daysDiff := to.Sub(from).Hours() / 24
	if daysDiff > 100 {
		outputSize = "full"
	}

	url := fmt.Sprintf("%s?function=TIME_SERIES_DAILY&symbol=%s&outputsize=%s&apikey=%s",
		c.baseURL, symbol, outputSize, c.apiKey)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("alpha_vantage: create request: %w", err)
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("alpha_vantage: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("alpha_vantage: unexpected status %d", resp.StatusCode)
	}

	var result timeSeriesDailyResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("alpha_vantage: decode response: %w", err)
	}

	if len(result.TimeSeries) == 0 {
		return nil, fmt.Errorf("alpha_vantage: no historical data for symbol %s", symbol)
	}

	return c.parseTimeSeries(result.TimeSeries, from, to), nil
}

// SupportsSymbol returns true for US stock/ETF symbols.
// Alpha Vantage supports global stocks but we focus on US markets.
func (c *AlphaVantageClient) SupportsSymbol(symbol string) bool {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return false
	}
	// Basic validation: 1-5 uppercase letters, optionally with exchange suffix
	// Examples: AAPL, MSFT, BRK.B, TSCO.LON
	// For now, support all non-empty symbols
	return len(symbol) >= 1 && len(symbol) <= 10
}

// Name returns the provider name.
func (c *AlphaVantageClient) Name() string {
	return "alpha_vantage"
}

// parseGlobalQuote converts Alpha Vantage response to domain Quote.
func (c *AlphaVantageClient) parseGlobalQuote(data *globalQuoteData) (*services.Quote, error) {
	price, err := strconv.ParseFloat(data.Price, 64)
	if err != nil {
		return nil, fmt.Errorf("alpha_vantage: parse price: %w", err)
	}

	change, _ := strconv.ParseFloat(data.Change, 64)

	// Parse change percent (remove % suffix)
	changePercentStr := strings.TrimSuffix(data.ChangePercent, "%")
	changePercent, _ := strconv.ParseFloat(changePercentStr, 64)

	// Determine market state based on time
	marketState := c.determineMarketState()

	return &services.Quote{
		Symbol:        data.Symbol,
		Price:         price,
		Change:        change,
		ChangePercent: changePercent,
		MarketState:   marketState,
		Currency:      "USD", // Alpha Vantage returns US stocks in USD
		UpdatedAt:     time.Now().UTC(),
		Source:        c.Name(),
	}, nil
}

// parseTimeSeries converts Alpha Vantage time series to domain PricePoints.
func (c *AlphaVantageClient) parseTimeSeries(timeSeries map[string]dailyOHLCVData, from, to time.Time) []services.PricePoint {
	var points []services.PricePoint

	for dateStr, data := range timeSeries {
		// Parse date (format: 2024-01-15)
		date, err := time.Parse("2006-01-02", dateStr)
		if err != nil {
			continue // skip invalid dates
		}

		// Filter by date range
		if date.Before(from) || date.After(to) {
			continue
		}

		open, _ := strconv.ParseFloat(data.Open, 64)
		high, _ := strconv.ParseFloat(data.High, 64)
		low, _ := strconv.ParseFloat(data.Low, 64)
		closePrice, _ := strconv.ParseFloat(data.Close, 64)
		volume, _ := strconv.ParseInt(data.Volume, 10, 64)

		points = append(points, services.PricePoint{
			Timestamp: date,
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
func (c *AlphaVantageClient) determineMarketState() string {
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

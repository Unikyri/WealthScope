package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	coingeckoBaseURL        = "https://api.coingecko.com/api/v3"
	coingeckoProBaseURL     = "https://pro-api.coingecko.com/api/v3"
	coingeckoDefaultTimeout = 15 * time.Second
)

// CoinGeckoClient implements services.MarketDataClient for CoinGecko API.
// Uses /simple/price for current prices and /coins/{id}/market_chart for historical data.
// Free tier: 10-30 requests/minute depending on endpoint.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type CoinGeckoClient struct {
	httpClient   *http.Client
	rateLimiter  *RateLimiter
	symbolMapper *CryptoSymbolMapper
	apiKey       string
	baseURL      string
}

// NewCoinGeckoClient creates a new CoinGecko client.
// apiKey is optional for the free tier but recommended for higher rate limits.
// If rateLimiter is nil, no rate limiting is applied.
func NewCoinGeckoClient(apiKey string, rateLimiter *RateLimiter, mapper *CryptoSymbolMapper) *CoinGeckoClient {
	baseURL := coingeckoBaseURL
	if apiKey != "" {
		baseURL = coingeckoProBaseURL
	}

	return &CoinGeckoClient{
		httpClient: &http.Client{
			Timeout: coingeckoDefaultTimeout,
		},
		apiKey:       apiKey,
		baseURL:      baseURL,
		rateLimiter:  rateLimiter,
		symbolMapper: mapper,
	}
}

// simplePriceResponse represents the CoinGecko /simple/price API response.
// The response is a map of coin ID to price data.
type simplePriceResponse map[string]simplePriceData

type simplePriceData struct {
	USD           float64 `json:"usd"`
	USD24HChange  float64 `json:"usd_24h_change"`
	USD24HVol     float64 `json:"usd_24h_vol"`
	USDMarketCap  float64 `json:"usd_market_cap"`
	LastUpdatedAt int64   `json:"last_updated_at"`
}

// marketChartResponse represents the CoinGecko /coins/{id}/market_chart response.
type marketChartResponse struct {
	Prices       [][]float64 `json:"prices"`        // [timestamp_ms, price]
	MarketCaps   [][]float64 `json:"market_caps"`   // [timestamp_ms, market_cap]
	TotalVolumes [][]float64 `json:"total_volumes"` // [timestamp_ms, volume]
}

// GetQuote fetches the latest quote for a cryptocurrency symbol.
func (c *CoinGeckoClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	quotes, err := c.GetQuotes(ctx, []string{symbol})
	if err != nil {
		return nil, err
	}

	normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
	q, ok := quotes[normalizedSymbol]
	if !ok {
		return nil, fmt.Errorf("coingecko: no data for symbol %s", symbol)
	}
	return q, nil
}

// GetQuotes fetches quotes for multiple cryptocurrency symbols.
// CoinGecko supports batch requests, so this is more efficient than individual calls.
func (c *CoinGeckoClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	if len(symbols) == 0 {
		return map[string]*services.Quote{}, nil
	}

	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("coingecko: rate limit wait: %w", err)
		}
	}

	// Convert symbols to CoinGecko IDs
	coinIDs := make([]string, 0, len(symbols))
	symbolToID := make(map[string]string)

	for _, symbol := range symbols {
		symbol = strings.TrimSpace(symbol)
		if symbol == "" {
			continue
		}

		normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
		if id, ok := c.symbolMapper.ToCoinGeckoID(normalizedSymbol); ok {
			coinIDs = append(coinIDs, id)
			symbolToID[id] = normalizedSymbol
		}
	}

	if len(coinIDs) == 0 {
		return map[string]*services.Quote{}, nil
	}

	// Build URL with query params
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("coingecko: parse base URL: %w", err)
	}
	u.Path = u.Path + "/simple/price"

	q := u.Query()
	q.Set("ids", strings.Join(coinIDs, ","))
	q.Set("vs_currencies", "usd")
	q.Set("include_24hr_change", "true")
	q.Set("include_24hr_vol", "true")
	q.Set("include_last_updated_at", "true")
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("coingecko: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")
	if c.apiKey != "" {
		req.Header.Set("x-cg-pro-api-key", c.apiKey)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("coingecko: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("coingecko: unexpected status %d", resp.StatusCode)
	}

	var result simplePriceResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("coingecko: decode response: %w", err)
	}

	// Convert to Quote map
	quotes := make(map[string]*services.Quote, len(result))
	now := time.Now().UTC()

	for coinID, data := range result {
		symbol, ok := symbolToID[coinID]
		if !ok {
			// Try reverse lookup
			symbol, ok = c.symbolMapper.FromCoinGeckoID(coinID)
			if !ok {
				continue
			}
		}

		// Calculate change from price and percent
		change := data.USD * (data.USD24HChange / 100)

		var updatedAt time.Time
		if data.LastUpdatedAt > 0 {
			updatedAt = time.Unix(data.LastUpdatedAt, 0).UTC()
		} else {
			updatedAt = now
		}

		quotes[symbol] = &services.Quote{
			Symbol:        symbol,
			Price:         data.USD,
			Change:        change,
			ChangePercent: data.USD24HChange,
			MarketState:   "24/7", // Crypto markets are always open
			Currency:      "USD",
			UpdatedAt:     updatedAt,
			Source:        c.Name(),
		}
	}

	return quotes, nil
}

// GetHistoricalPrices fetches historical price data using /coins/{id}/market_chart endpoint.
func (c *CoinGeckoClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("coingecko: rate limit wait: %w", err)
		}
	}

	normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
	coinID, ok := c.symbolMapper.ToCoinGeckoID(normalizedSymbol)
	if !ok {
		return nil, fmt.Errorf("coingecko: unknown symbol %s", symbol)
	}

	// Build URL
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("coingecko: parse base URL: %w", err)
	}
	u.Path = fmt.Sprintf("%s/coins/%s/market_chart/range", u.Path, coinID)

	q := u.Query()
	q.Set("vs_currency", "usd")
	q.Set("from", fmt.Sprintf("%d", from.Unix()))
	q.Set("to", fmt.Sprintf("%d", to.Unix()))
	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("coingecko: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")
	if c.apiKey != "" {
		req.Header.Set("x-cg-pro-api-key", c.apiKey)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("coingecko: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("coingecko: unexpected status %d", resp.StatusCode)
	}

	var result marketChartResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("coingecko: decode response: %w", err)
	}

	if len(result.Prices) == 0 {
		return nil, fmt.Errorf("coingecko: no historical data for symbol %s", symbol)
	}

	// Convert to PricePoints
	// CoinGecko market_chart doesn't provide OHLC, only close prices
	// We'll use the price as both Open and Close
	points := make([]services.PricePoint, 0, len(result.Prices))

	for i, priceData := range result.Prices {
		if len(priceData) < 2 {
			continue
		}

		timestamp := time.Unix(int64(priceData[0]/1000), 0).UTC()
		price := priceData[1]

		var volume int64
		if i < len(result.TotalVolumes) && len(result.TotalVolumes[i]) >= 2 {
			volume = int64(result.TotalVolumes[i][1])
		}

		points = append(points, services.PricePoint{
			Timestamp: timestamp,
			Open:      price,
			High:      price,
			Low:       price,
			Close:     price,
			Volume:    volume,
		})
	}

	return points, nil
}

// SupportsSymbol returns true if the symbol is a known cryptocurrency.
func (c *CoinGeckoClient) SupportsSymbol(symbol string) bool {
	if c.symbolMapper == nil {
		return false
	}
	return c.symbolMapper.IsCryptoSymbol(symbol)
}

// Name returns the provider name.
func (c *CoinGeckoClient) Name() string {
	return "coingecko"
}

package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

const (
	binanceBaseURL        = "https://api.binance.com"
	binanceDefaultTimeout = 15 * time.Second
)

// BinanceClient implements services.MarketDataClient for Binance API.
// Uses /api/v3/ticker/24hr for current prices and /api/v3/klines for historical data.
// Public endpoints have a rate limit of 1200 requests/minute.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type BinanceClient struct {
	httpClient   *http.Client
	rateLimiter  *RateLimiter
	symbolMapper *CryptoSymbolMapper
	baseURL      string
}

// NewBinanceClient creates a new Binance client.
// No API key is required for public endpoints.
// If rateLimiter is nil, no rate limiting is applied.
func NewBinanceClient(rateLimiter *RateLimiter, mapper *CryptoSymbolMapper) *BinanceClient {
	return &BinanceClient{
		httpClient: &http.Client{
			Timeout: binanceDefaultTimeout,
		},
		baseURL:      binanceBaseURL,
		rateLimiter:  rateLimiter,
		symbolMapper: mapper,
	}
}

// ticker24hrResponse represents the Binance /api/v3/ticker/24hr response.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type ticker24hrResponse struct {
	Symbol             string `json:"symbol"`
	PriceChange        string `json:"priceChange"`
	PriceChangePercent string `json:"priceChangePercent"`
	WeightedAvgPrice   string `json:"weightedAvgPrice"`
	PrevClosePrice     string `json:"prevClosePrice"`
	LastPrice          string `json:"lastPrice"`
	LastQty            string `json:"lastQty"`
	BidPrice           string `json:"bidPrice"`
	BidQty             string `json:"bidQty"`
	AskPrice           string `json:"askPrice"`
	AskQty             string `json:"askQty"`
	OpenPrice          string `json:"openPrice"`
	HighPrice          string `json:"highPrice"`
	LowPrice           string `json:"lowPrice"`
	Volume             string `json:"volume"`
	QuoteVolume        string `json:"quoteVolume"`
	OpenTime           int64  `json:"openTime"`
	CloseTime          int64  `json:"closeTime"`
	FirstID            int64  `json:"firstId"`
	LastID             int64  `json:"lastId"`
	Count              int64  `json:"count"`
}

// klineResponse represents a single kline/candlestick from Binance.
// Response is an array: [openTime, open, high, low, close, volume, closeTime, ...]
type klineResponse []interface{}

// GetQuote fetches the latest quote for a cryptocurrency symbol.
func (c *BinanceClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("binance: rate limit wait: %w", err)
		}
	}

	normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
	binanceSymbol, ok := c.symbolMapper.ToBinanceSymbol(normalizedSymbol)
	if !ok {
		return nil, fmt.Errorf("binance: unknown symbol %s", symbol)
	}

	url := fmt.Sprintf("%s/api/v3/ticker/24hr?symbol=%s", c.baseURL, binanceSymbol)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("binance: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("binance: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("binance: unexpected status %d", resp.StatusCode)
	}

	var result ticker24hrResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("binance: decode response: %w", err)
	}

	return c.parseTicker24hr(normalizedSymbol, &result)
}

// GetQuotes fetches quotes for multiple cryptocurrency symbols.
// Binance doesn't support batch requests for specific symbols, so we make sequential calls.
func (c *BinanceClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
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
		quotes[c.symbolMapper.NormalizeSymbol(symbol)] = q
	}

	return quotes, nil
}

// GetHistoricalPrices fetches historical OHLCV data using /api/v3/klines endpoint.
func (c *BinanceClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("binance: rate limit wait: %w", err)
		}
	}

	normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
	binanceSymbol, ok := c.symbolMapper.ToBinanceSymbol(normalizedSymbol)
	if !ok {
		return nil, fmt.Errorf("binance: unknown symbol %s", symbol)
	}

	// Binance klines endpoint
	// interval: 1d for daily candles
	url := fmt.Sprintf("%s/api/v3/klines?symbol=%s&interval=1d&startTime=%d&endTime=%d&limit=1000",
		c.baseURL, binanceSymbol, from.UnixMilli(), to.UnixMilli())

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("binance: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("binance: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("binance: unexpected status %d", resp.StatusCode)
	}

	var result []klineResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("binance: decode response: %w", err)
	}

	if len(result) == 0 {
		return nil, fmt.Errorf("binance: no historical data for symbol %s", symbol)
	}

	return c.parseKlines(result), nil
}

// SupportsSymbol returns true if the symbol is a known cryptocurrency with Binance support.
func (c *BinanceClient) SupportsSymbol(symbol string) bool {
	if c.symbolMapper == nil {
		return false
	}
	normalizedSymbol := c.symbolMapper.NormalizeSymbol(symbol)
	_, ok := c.symbolMapper.ToBinanceSymbol(normalizedSymbol)
	return ok
}

// Name returns the provider name.
func (c *BinanceClient) Name() string {
	return "binance"
}

// parseTicker24hr converts Binance ticker response to domain Quote.
func (c *BinanceClient) parseTicker24hr(symbol string, data *ticker24hrResponse) (*services.Quote, error) {
	price, err := strconv.ParseFloat(data.LastPrice, 64)
	if err != nil {
		return nil, fmt.Errorf("binance: parse price: %w", err)
	}

	change, _ := strconv.ParseFloat(data.PriceChange, 64)
	changePercent, _ := strconv.ParseFloat(data.PriceChangePercent, 64)

	var updatedAt time.Time
	if data.CloseTime > 0 {
		updatedAt = time.UnixMilli(data.CloseTime).UTC()
	} else {
		updatedAt = time.Now().UTC()
	}

	return &services.Quote{
		Symbol:        symbol,
		Price:         price,
		Change:        change,
		ChangePercent: changePercent,
		MarketState:   "24/7", // Crypto markets are always open
		Currency:      "USD",  // USDT pairs are USD-equivalent
		UpdatedAt:     updatedAt,
		Source:        c.Name(),
	}, nil
}

// parseKlines converts Binance kline response to domain PricePoints.
func (c *BinanceClient) parseKlines(klines []klineResponse) []services.PricePoint {
	points := make([]services.PricePoint, 0, len(klines))

	for _, kline := range klines {
		// Kline format: [openTime, open, high, low, close, volume, closeTime, ...]
		if len(kline) < 6 {
			continue
		}

		openTimeMs, ok := kline[0].(float64)
		if !ok {
			continue
		}

		openStr, ok := kline[1].(string)
		if !ok {
			continue
		}
		open, _ := strconv.ParseFloat(openStr, 64)

		highStr, ok := kline[2].(string)
		if !ok {
			continue
		}
		high, _ := strconv.ParseFloat(highStr, 64)

		lowStr, ok := kline[3].(string)
		if !ok {
			continue
		}
		low, _ := strconv.ParseFloat(lowStr, 64)

		closeStr, ok := kline[4].(string)
		if !ok {
			continue
		}
		closePrice, _ := strconv.ParseFloat(closeStr, 64)

		volumeStr, ok := kline[5].(string)
		if !ok {
			continue
		}
		volumeFloat, _ := strconv.ParseFloat(volumeStr, 64)
		volume := int64(volumeFloat)

		points = append(points, services.PricePoint{
			Timestamp: time.UnixMilli(int64(openTimeMs)).UTC(),
			Open:      open,
			High:      high,
			Low:       low,
			Close:     closePrice,
			Volume:    volume,
		})
	}

	return points
}

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

// YahooFinanceClient fetches quotes from Yahoo Finance public endpoints.
// Implements services.MarketDataClient.
//
// Source endpoint used:
// - https://query1.finance.yahoo.com/v7/finance/quote?symbols=AAPL,MSFT
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type YahooFinanceClient struct {
	httpClient  *http.Client
	baseURL     string
	rateLimiter *RateLimiter
}

// NewYahooFinanceClient creates a new YahooFinanceClient.
// rateLimiter is optional and can be nil for no rate limiting.
func NewYahooFinanceClient(rateLimiter *RateLimiter) *YahooFinanceClient {
	return &YahooFinanceClient{
		httpClient:  &http.Client{Timeout: 10 * time.Second},
		baseURL:     "https://query1.finance.yahoo.com",
		rateLimiter: rateLimiter,
	}
}

// GetQuote fetches a single quote.
func (c *YahooFinanceClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	quotes, err := c.GetQuotes(ctx, []string{symbol})
	if err != nil {
		return nil, err
	}
	q, ok := quotes[strings.ToUpper(symbol)]
	if !ok {
		return nil, fmt.Errorf("quote not found for symbol %q", symbol)
	}
	return q, nil
}

// GetQuotes fetches quotes for multiple symbols.
func (c *YahooFinanceClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	if len(symbols) == 0 {
		return map[string]*services.Quote{}, nil
	}

	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("yahoo_finance: rate limit wait: %w", err)
		}
	}

	symbolsCSV := strings.Join(normalizeSymbols(symbols), ",")

	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, err
	}
	u.Path = "/v7/finance/quote"
	q := u.Query()
	q.Set("symbols", symbolsCSV)
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

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return nil, fmt.Errorf("yahoo finance returned status %d", resp.StatusCode)
	}

	var payload yahooQuoteResponse
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return nil, fmt.Errorf("failed to decode yahoo finance response: %w", err)
	}

	out := make(map[string]*services.Quote, len(payload.QuoteResponse.Result))
	now := time.Now().UTC()
	source := c.Name()

	for _, r := range payload.QuoteResponse.Result {
		if r.Symbol == "" {
			continue
		}

		out[strings.ToUpper(r.Symbol)] = &services.Quote{
			Symbol:        r.Symbol,
			Price:         r.RegularMarketPrice,
			Change:        r.RegularMarketChange,
			ChangePercent: r.RegularMarketChangePercent,
			MarketState:   r.MarketState,
			Currency:      r.Currency,
			UpdatedAt:     now,
			Source:        source,
		}
	}

	return out, nil
}

// GetHistoricalPrices returns historical OHLCV; not implemented for Yahoo public API in US-6.1.
func (c *YahooFinanceClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	_ = ctx
	_ = symbol
	_ = from
	_ = to
	return nil, nil
}

// SupportsSymbol returns true for any non-empty symbol (Yahoo handles equities).
func (c *YahooFinanceClient) SupportsSymbol(symbol string) bool {
	return strings.TrimSpace(symbol) != ""
}

// Name returns the provider name for logging and PriceHistory.Source.
func (c *YahooFinanceClient) Name() string {
	return "yahoo_finance"
}

func normalizeSymbols(symbols []string) []string {
	out := make([]string, 0, len(symbols))
	seen := make(map[string]struct{}, len(symbols))
	for _, s := range symbols {
		s = strings.TrimSpace(s)
		if s == "" {
			continue
		}
		s = strings.ToUpper(s)
		if _, ok := seen[s]; ok {
			continue
		}
		seen[s] = struct{}{}
		out = append(out, s)
	}
	return out
}

type yahooQuoteResponse struct {
	QuoteResponse struct {
		Error  interface{}        `json:"error"`
		Result []yahooQuoteResult `json:"result"`
	} `json:"quoteResponse"`
}

//nolint:govet // fieldalignment: readability over micro-optimization for DTO
type yahooQuoteResult struct {
	RegularMarketPrice         float64 `json:"regularMarketPrice"`
	RegularMarketChange        float64 `json:"regularMarketChange"`
	RegularMarketChangePercent float64 `json:"regularMarketChangePercent"`
	Symbol                     string  `json:"symbol"`
	MarketState                string  `json:"marketState"`
	Currency                   string  `json:"currency"`
}

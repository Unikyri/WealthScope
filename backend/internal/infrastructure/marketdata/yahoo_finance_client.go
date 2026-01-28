package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// Quote represents a market quote for a symbol.
//
//nolint:govet // fieldalignment: readability over micro-optimization for DTO
type Quote struct {
	UpdatedAt     time.Time `json:"updated_at"`
	Price         float64   `json:"price"`
	Change        float64   `json:"change"`
	ChangePercent float64   `json:"change_percent"`
	Symbol        string    `json:"symbol"`
	MarketState   string    `json:"market_state"`
	Currency      string    `json:"currency,omitempty"`
}

// YahooFinanceClient fetches quotes from Yahoo Finance public endpoints.
//
// Source endpoint used:
// - https://query1.finance.yahoo.com/v7/finance/quote?symbols=AAPL,MSFT
type YahooFinanceClient struct {
	httpClient *http.Client
	baseURL    string
}

// NewYahooFinanceClient creates a new YahooFinanceClient.
func NewYahooFinanceClient(httpClient *http.Client) *YahooFinanceClient {
	if httpClient == nil {
		httpClient = &http.Client{Timeout: 10 * time.Second}
	}
	return &YahooFinanceClient{
		httpClient: httpClient,
		baseURL:    "https://query1.finance.yahoo.com",
	}
}

// GetQuote fetches a single quote.
func (c *YahooFinanceClient) GetQuote(ctx context.Context, symbol string) (*Quote, error) {
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
func (c *YahooFinanceClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*Quote, error) {
	if len(symbols) == 0 {
		return map[string]*Quote{}, nil
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

	out := make(map[string]*Quote, len(payload.QuoteResponse.Result))
	now := time.Now().UTC()

	for _, r := range payload.QuoteResponse.Result {
		if r.Symbol == "" {
			continue
		}

		out[strings.ToUpper(r.Symbol)] = &Quote{
			Symbol:        r.Symbol,
			Price:         r.RegularMarketPrice,
			Change:        r.RegularMarketChange,
			ChangePercent: r.RegularMarketChangePercent,
			MarketState:   r.MarketState,
			Currency:      r.Currency,
			UpdatedAt:     now,
		}
	}

	return out, nil
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

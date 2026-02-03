package marketdata

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestFinnhubClient_GetQuote(t *testing.T) {
	// Mock Finnhub API response
	mockResponse := `{
		"c": 182.75,
		"d": 0.81,
		"dp": 0.4454,
		"h": 183.31,
		"l": 181.56,
		"o": 182.43,
		"pc": 181.94,
		"t": 1705340800
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/quote", r.URL.Path)
		assert.Equal(t, "AAPL", r.URL.Query().Get("symbol"))
		assert.Equal(t, "test-api-key", r.URL.Query().Get("token"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "AAPL")

	require.NoError(t, err)
	require.NotNil(t, quote)
	assert.Equal(t, "AAPL", quote.Symbol)
	assert.Equal(t, 182.75, quote.Price)
	assert.Equal(t, 0.81, quote.Change)
	assert.InDelta(t, 0.4454, quote.ChangePercent, 0.001)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "finnhub", quote.Source)
	// Check that timestamp was parsed correctly
	assert.Equal(t, time.Unix(1705340800, 0).UTC(), quote.UpdatedAt)
}

func TestFinnhubClient_GetQuote_EmptySymbol(t *testing.T) {
	client := NewFinnhubClient("test-api-key", nil)
	ctx := context.Background()

	quote, err := client.GetQuote(ctx, "")
	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "empty symbol")
}

func TestFinnhubClient_GetQuote_NoData(t *testing.T) {
	// Empty response (invalid symbol)
	mockResponse := `{"c": 0, "d": null, "dp": null, "h": 0, "l": 0, "o": 0, "pc": 0, "t": 0}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "INVALID")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "no data for symbol")
}

func TestFinnhubClient_GetQuote_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusUnauthorized)
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "AAPL")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "unexpected status 401")
}

func TestFinnhubClient_GetQuotes(t *testing.T) {
	callCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		callCount++
		symbol := r.URL.Query().Get("symbol")

		var response string
		switch symbol {
		case "AAPL":
			response = `{"c": 182.75, "d": 0.81, "dp": 0.45, "h": 183.0, "l": 181.0, "o": 182.0, "pc": 181.94, "t": 1705340800}`
		case "MSFT":
			response = `{"c": 380.50, "d": 2.30, "dp": 0.61, "h": 382.0, "l": 378.0, "o": 379.0, "pc": 378.20, "t": 1705340800}`
		default:
			response = `{"c": 0, "d": null, "dp": null, "h": 0, "l": 0, "o": 0, "pc": 0, "t": 0}`
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(response))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quotes, err := client.GetQuotes(ctx, []string{"AAPL", "MSFT", "INVALID"})

	require.NoError(t, err)
	assert.Len(t, quotes, 2) // INVALID should be skipped
	assert.Equal(t, 3, callCount)

	assert.NotNil(t, quotes["AAPL"])
	assert.Equal(t, 182.75, quotes["AAPL"].Price)

	assert.NotNil(t, quotes["MSFT"])
	assert.Equal(t, 380.50, quotes["MSFT"].Price)
}

func TestFinnhubClient_GetHistoricalPrices(t *testing.T) {
	mockResponse := `{
		"c": [182.75, 181.94, 180.50],
		"h": [183.50, 182.50, 181.00],
		"l": [181.00, 180.50, 179.00],
		"o": [182.00, 181.00, 180.00],
		"s": "ok",
		"t": [1705363200, 1705276800, 1705190400],
		"v": [5000000, 4500000, 4000000]
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/stock/candle", r.URL.Path)
		assert.Equal(t, "AAPL", r.URL.Query().Get("symbol"))
		assert.Equal(t, "D", r.URL.Query().Get("resolution"))
		assert.NotEmpty(t, r.URL.Query().Get("from"))
		assert.NotEmpty(t, r.URL.Query().Get("to"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	from := time.Date(2024, 1, 10, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 16, 0, 0, 0, 0, time.UTC)

	prices, err := client.GetHistoricalPrices(ctx, "AAPL", from, to)

	require.NoError(t, err)
	assert.Len(t, prices, 3)

	// Check first price point
	assert.Equal(t, 182.00, prices[0].Open)
	assert.Equal(t, 183.50, prices[0].High)
	assert.Equal(t, 181.00, prices[0].Low)
	assert.Equal(t, 182.75, prices[0].Close)
	assert.Equal(t, int64(5000000), prices[0].Volume)
}

func TestFinnhubClient_GetHistoricalPrices_NoData(t *testing.T) {
	mockResponse := `{"s": "no_data"}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "INVALID", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "no historical data")
}

func TestFinnhubClient_GetHistoricalPrices_EmptyArrays(t *testing.T) {
	mockResponse := `{"c": [], "h": [], "l": [], "o": [], "s": "ok", "t": [], "v": []}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "AAPL", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "no historical data")
}

func TestFinnhubClient_SupportsSymbol(t *testing.T) {
	client := NewFinnhubClient("test-api-key", nil)

	assert.True(t, client.SupportsSymbol("AAPL"))
	assert.True(t, client.SupportsSymbol("MSFT"))
	assert.True(t, client.SupportsSymbol("BRK.B"))
	assert.False(t, client.SupportsSymbol(""))
	assert.False(t, client.SupportsSymbol("   "))
}

func TestFinnhubClient_Name(t *testing.T) {
	client := NewFinnhubClient("test-api-key", nil)
	assert.Equal(t, "finnhub", client.Name())
}

func TestFinnhubClient_WithRateLimiter(t *testing.T) {
	mockResponse := `{"c": 182.75, "d": 0.81, "dp": 0.45, "h": 183.0, "l": 181.0, "o": 182.0, "pc": 181.94, "t": 1705340800}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	rateLimiter := NewRateLimiter(2, time.Second)
	client := NewFinnhubClient("test-api-key", rateLimiter)
	client.baseURL = server.URL

	ctx := context.Background()

	// First two requests should succeed immediately
	_, err1 := client.GetQuote(ctx, "AAPL")
	_, err2 := client.GetQuote(ctx, "AAPL")

	assert.NoError(t, err1)
	assert.NoError(t, err2)

	// Third request should wait for rate limiter
	start := time.Now()
	_, err3 := client.GetQuote(ctx, "AAPL")
	elapsed := time.Since(start)

	assert.NoError(t, err3)
	assert.GreaterOrEqual(t, elapsed.Milliseconds(), int64(400)) // Should have waited ~500ms
}

func TestFinnhubClient_RateLimiter_ContextCancelled(t *testing.T) {
	rateLimiter := NewRateLimiter(1, time.Hour) // Very slow refill
	client := NewFinnhubClient("test-api-key", rateLimiter)

	// Consume the only token
	rateLimiter.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	_, err := client.GetQuote(ctx, "AAPL")

	assert.Error(t, err)
	assert.Contains(t, err.Error(), "rate limit wait")
}

func TestFinnhubClient_GetQuote_ZeroTimestamp(t *testing.T) {
	// Response with zero timestamp (should use current time)
	mockResponse := `{"c": 182.75, "d": 0.81, "dp": 0.45, "h": 183.0, "l": 181.0, "o": 182.0, "pc": 181.94, "t": 0}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewFinnhubClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	before := time.Now().UTC()
	quote, err := client.GetQuote(ctx, "AAPL")
	after := time.Now().UTC()

	require.NoError(t, err)
	require.NotNil(t, quote)
	assert.Equal(t, 182.75, quote.Price)
	// With t=0 but c!=0, it's valid data, UpdatedAt should be set to now
	assert.True(t, quote.UpdatedAt.After(before.Add(-time.Second)) && quote.UpdatedAt.Before(after.Add(time.Second)))
}

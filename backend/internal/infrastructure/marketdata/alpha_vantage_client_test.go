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

func TestAlphaVantageClient_GetQuote(t *testing.T) {
	// Mock Alpha Vantage API response
	mockResponse := `{
		"Global Quote": {
			"01. symbol": "AAPL",
			"02. open": "182.4300",
			"03. high": "183.3100",
			"04. low": "181.5600",
			"05. price": "182.7500",
			"06. volume": "3245678",
			"07. latest trading day": "2024-01-15",
			"08. previous close": "181.9400",
			"09. change": "0.8100",
			"10. change percent": "0.4454%"
		}
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "GLOBAL_QUOTE", r.URL.Query().Get("function"))
		assert.Equal(t, "AAPL", r.URL.Query().Get("symbol"))
		assert.Equal(t, "test-api-key", r.URL.Query().Get("apikey"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
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
	assert.Equal(t, "alpha_vantage", quote.Source)
}

func TestAlphaVantageClient_GetQuote_EmptySymbol(t *testing.T) {
	client := NewAlphaVantageClient("test-api-key", nil)
	ctx := context.Background()

	quote, err := client.GetQuote(ctx, "")
	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "empty symbol")
}

func TestAlphaVantageClient_GetQuote_NoData(t *testing.T) {
	// Empty response (API limit or invalid symbol)
	mockResponse := `{"Global Quote": {}}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "INVALID")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "no data for symbol")
}

func TestAlphaVantageClient_GetQuote_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "AAPL")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "unexpected status 500")
}

func TestAlphaVantageClient_GetQuotes(t *testing.T) {
	callCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		callCount++
		symbol := r.URL.Query().Get("symbol")

		var response string
		switch symbol {
		case "AAPL":
			response = `{"Global Quote": {"01. symbol": "AAPL", "05. price": "182.75", "09. change": "0.81", "10. change percent": "0.45%"}}`
		case "MSFT":
			response = `{"Global Quote": {"01. symbol": "MSFT", "05. price": "380.50", "09. change": "2.30", "10. change percent": "0.61%"}}`
		default:
			response = `{"Global Quote": {}}`
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(response))
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
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

func TestAlphaVantageClient_GetHistoricalPrices(t *testing.T) {
	mockResponse := `{
		"Meta Data": {
			"1. Information": "Daily Prices",
			"2. Symbol": "AAPL"
		},
		"Time Series (Daily)": {
			"2024-01-15": {
				"1. open": "182.00",
				"2. high": "183.50",
				"3. low": "181.00",
				"4. close": "182.75",
				"5. volume": "5000000"
			},
			"2024-01-14": {
				"1. open": "180.00",
				"2. high": "182.00",
				"3. low": "179.50",
				"4. close": "181.94",
				"5. volume": "4500000"
			},
			"2024-01-10": {
				"1. open": "178.00",
				"2. high": "180.00",
				"3. low": "177.50",
				"4. close": "179.00",
				"5. volume": "4000000"
			}
		}
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "TIME_SERIES_DAILY", r.URL.Query().Get("function"))
		assert.Equal(t, "AAPL", r.URL.Query().Get("symbol"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	from := time.Date(2024, 1, 12, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 16, 0, 0, 0, 0, time.UTC)

	prices, err := client.GetHistoricalPrices(ctx, "AAPL", from, to)

	require.NoError(t, err)
	assert.Len(t, prices, 2) // Only 2024-01-14 and 2024-01-15 are in range (2024-01-10 is before)

	// Check one of the prices
	found := false
	for _, p := range prices {
		if p.Timestamp.Day() == 15 {
			assert.Equal(t, 182.00, p.Open)
			assert.Equal(t, 183.50, p.High)
			assert.Equal(t, 181.00, p.Low)
			assert.Equal(t, 182.75, p.Close)
			assert.Equal(t, int64(5000000), p.Volume)
			found = true
		}
	}
	assert.True(t, found, "Expected to find price point for 2024-01-15")
}

func TestAlphaVantageClient_GetHistoricalPrices_NoData(t *testing.T) {
	mockResponse := `{"Meta Data": {}, "Time Series (Daily)": {}}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	client := NewAlphaVantageClient("test-api-key", nil)
	client.baseURL = server.URL

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "INVALID", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "no historical data")
}

func TestAlphaVantageClient_SupportsSymbol(t *testing.T) {
	client := NewAlphaVantageClient("test-api-key", nil)

	assert.True(t, client.SupportsSymbol("AAPL"))
	assert.True(t, client.SupportsSymbol("MSFT"))
	assert.True(t, client.SupportsSymbol("BRK.B"))
	assert.True(t, client.SupportsSymbol("TSCO.LON"))
	assert.False(t, client.SupportsSymbol(""))
	assert.False(t, client.SupportsSymbol("   "))
}

func TestAlphaVantageClient_Name(t *testing.T) {
	client := NewAlphaVantageClient("test-api-key", nil)
	assert.Equal(t, "alpha_vantage", client.Name())
}

func TestAlphaVantageClient_WithRateLimiter(t *testing.T) {
	mockResponse := `{"Global Quote": {"01. symbol": "AAPL", "05. price": "182.75", "09. change": "0.81", "10. change percent": "0.45%"}}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	rateLimiter := NewRateLimiter(2, time.Second)
	client := NewAlphaVantageClient("test-api-key", rateLimiter)
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

func TestAlphaVantageClient_RateLimiter_ContextCancelled(t *testing.T) {
	rateLimiter := NewRateLimiter(1, time.Hour) // Very slow refill
	client := NewAlphaVantageClient("test-api-key", rateLimiter)

	// Consume the only token
	rateLimiter.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	_, err := client.GetQuote(ctx, "AAPL")

	assert.Error(t, err)
	assert.Contains(t, err.Error(), "rate limit wait")
}

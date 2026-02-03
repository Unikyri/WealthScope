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

func TestFrankfurterClient_GetQuote(t *testing.T) {
	// Mock server response
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/latest", r.URL.Path)
		assert.Equal(t, "EUR", r.URL.Query().Get("from"))
		assert.Equal(t, "USD", r.URL.Query().Get("to"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"amount": 1.0,
			"base": "EUR",
			"date": "2024-01-15",
			"rates": {
				"USD": 1.0875
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)
	client.baseURL = server.URL

	quote, err := client.GetQuote(context.Background(), "EUR/USD")
	require.NoError(t, err)
	require.NotNil(t, quote)

	assert.Equal(t, "EUR/USD", quote.Symbol)
	assert.Equal(t, 1.0875, quote.Price)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "frankfurter", quote.Source)
}

func TestFrankfurterClient_GetQuote_InvalidSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)

	_, err := client.GetQuote(context.Background(), "INVALID")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "invalid forex symbol")
}

func TestFrankfurterClient_GetQuotes_Batch(t *testing.T) {
	// Mock server that handles batch requests
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/latest", r.URL.Path)
		from := r.URL.Query().Get("from")
		to := r.URL.Query().Get("to")

		var response string
		if from == "EUR" {
			response = `{
				"amount": 1.0,
				"base": "EUR",
				"date": "2024-01-15",
				"rates": {
					"USD": 1.0875,
					"GBP": 0.8567
				}
			}`
		} else {
			response = `{
				"amount": 1.0,
				"base": "` + from + `",
				"date": "2024-01-15",
				"rates": {
					"` + to + `": 1.5
				}
			}`
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(response))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)
	client.baseURL = server.URL

	quotes, err := client.GetQuotes(context.Background(), []string{"EUR/USD", "EUR/GBP"})
	require.NoError(t, err)
	require.NotNil(t, quotes)

	// Should batch requests with same base
	assert.Len(t, quotes, 2)
	assert.NotNil(t, quotes["EUR/USD"])
	assert.NotNil(t, quotes["EUR/GBP"])
	assert.Equal(t, 1.0875, quotes["EUR/USD"].Price)
	assert.Equal(t, 0.8567, quotes["EUR/GBP"].Price)
}

func TestFrankfurterClient_GetHistoricalPrices(t *testing.T) {
	// Mock server response for timeseries
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Frankfurter uses date range in path: /2024-01-01..2024-01-05
		assert.Contains(t, r.URL.Path, "..")

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"amount": 1.0,
			"base": "EUR",
			"start_date": "2024-01-01",
			"end_date": "2024-01-05",
			"rates": {
				"2024-01-01": {"USD": 1.0850},
				"2024-01-02": {"USD": 1.0875},
				"2024-01-03": {"USD": 1.0900},
				"2024-01-04": {"USD": 1.0880},
				"2024-01-05": {"USD": 1.0860}
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)
	client.baseURL = server.URL

	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 5, 0, 0, 0, 0, time.UTC)

	points, err := client.GetHistoricalPrices(context.Background(), "EUR/USD", from, to)
	require.NoError(t, err)
	require.NotNil(t, points)
	assert.Len(t, points, 5)

	// Should be sorted by date ascending
	assert.Equal(t, time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC), points[0].Timestamp)
	assert.Equal(t, 1.0850, points[0].Close)
	assert.Equal(t, time.Date(2024, 1, 5, 0, 0, 0, 0, time.UTC), points[4].Timestamp)
}

func TestFrankfurterClient_SupportsSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)

	assert.True(t, client.SupportsSymbol("EUR/USD"))
	assert.True(t, client.SupportsSymbol("EURUSD"))
	assert.True(t, client.SupportsSymbol("gbp/jpy"))
	assert.False(t, client.SupportsSymbol("AAPL"))
	assert.False(t, client.SupportsSymbol("BTC"))
	assert.False(t, client.SupportsSymbol(""))
}

func TestFrankfurterClient_Name(t *testing.T) {
	client := NewFrankfurterClient(nil, nil)
	assert.Equal(t, "frankfurter", client.Name())
}

func TestFrankfurterClient_RateLimiting(t *testing.T) {
	requestCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestCount++
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"amount": 1.0,
			"base": "EUR",
			"date": "2024-01-15",
			"rates": {"USD": 1.0875}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	limiter := NewRateLimiter(2, time.Second) // 2 requests per second
	client := NewFrankfurterClient(limiter, mapper)
	client.baseURL = server.URL

	ctx := context.Background()

	// First two requests should succeed quickly
	_, err := client.GetQuote(ctx, "EUR/USD")
	require.NoError(t, err)
	_, err = client.GetQuote(ctx, "EUR/USD")
	require.NoError(t, err)

	assert.Equal(t, 2, requestCount)
}

func TestFrankfurterClient_determineMarketState(t *testing.T) {
	client := NewFrankfurterClient(nil, nil)

	// This test depends on the current time, so we just verify it returns a valid state
	state := client.determineMarketState()
	assert.Contains(t, []string{"OPEN", "CLOSED"}, state)
}

func TestFrankfurterClient_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewFrankfurterClient(nil, mapper)
	client.baseURL = server.URL

	_, err := client.GetQuote(context.Background(), "EUR/USD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "unexpected status")
}

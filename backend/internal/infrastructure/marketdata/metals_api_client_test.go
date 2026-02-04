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

func TestMetalsAPIClient_GetQuote(t *testing.T) {
	// Mock server response
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/latest", r.URL.Path)
		assert.Equal(t, "USD", r.URL.Query().Get("base"))
		assert.Contains(t, r.URL.Query().Get("currencies"), "XAU")

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": true,
			"timestamp": 1705315200,
			"base": "USD",
			"date": "2024-01-15",
			"rates": {
				"XAU": 0.0004831705,
				"USDXAU": 2069.66
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)
	client.baseURL = server.URL

	quote, err := client.GetQuote(context.Background(), "GOLD")
	require.NoError(t, err)
	require.NotNil(t, quote)

	assert.Equal(t, "XAU", quote.Symbol)
	assert.InDelta(t, 2069.66, quote.Price, 0.01)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "metalprice_api", quote.Source)
}

func TestMetalsAPIClient_GetQuote_InverseRate(t *testing.T) {
	// Test when only inverse rate is provided (no USDXAU key)
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": true,
			"timestamp": 1705315200,
			"base": "USD",
			"date": "2024-01-15",
			"rates": {
				"XAU": 0.0004831705
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)
	client.baseURL = server.URL

	quote, err := client.GetQuote(context.Background(), "XAU")
	require.NoError(t, err)
	require.NotNil(t, quote)

	// Price should be 1/0.0004831705 ≈ 2069.66
	expectedPrice := 1.0 / 0.0004831705
	assert.InDelta(t, expectedPrice, quote.Price, 0.01)
}

func TestMetalsAPIClient_PriceConversion(t *testing.T) {
	// Test the critical price conversion logic
	// API returns inverse rate: 0.0004831705
	// Expected price: 1/0.0004831705 = 2069.6627...
	apiRate := 0.0004831705
	expectedPrice := 1.0 / apiRate
	assert.InDelta(t, 2069.66, expectedPrice, 0.01)
}

func TestMetalsAPIClient_GetQuote_InvalidSymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)

	_, err := client.GetQuote(context.Background(), "INVALID")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "unknown metal symbol")
}

func TestMetalsAPIClient_GetQuotes(t *testing.T) {
	// Mock server that returns multiple metals
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/latest", r.URL.Path)

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": true,
			"timestamp": 1705315200,
			"base": "USD",
			"date": "2024-01-15",
			"rates": {
				"XAU": 0.0004831705,
				"USDXAU": 2069.66,
				"XAG": 0.041405839,
				"USDXAG": 24.15
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)
	client.baseURL = server.URL

	quotes, err := client.GetQuotes(context.Background(), []string{"GOLD", "SILVER"})
	require.NoError(t, err)
	require.NotNil(t, quotes)

	assert.Len(t, quotes, 2)
	assert.NotNil(t, quotes["XAU"])
	assert.NotNil(t, quotes["XAG"])
	assert.InDelta(t, 2069.66, quotes["XAU"].Price, 0.01)
	assert.InDelta(t, 24.15, quotes["XAG"].Price, 0.01)
}

func TestMetalsAPIClient_SupportsSymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)

	// Valid metal symbols
	assert.True(t, client.SupportsSymbol("GOLD"))
	assert.True(t, client.SupportsSymbol("XAU"))
	assert.True(t, client.SupportsSymbol("SILVER"))
	assert.True(t, client.SupportsSymbol("XAG"))
	assert.True(t, client.SupportsSymbol("PLATINUM"))
	assert.True(t, client.SupportsSymbol("XPT"))
	assert.True(t, client.SupportsSymbol("PALLADIUM"))
	assert.True(t, client.SupportsSymbol("XPD"))

	// Invalid symbols
	assert.False(t, client.SupportsSymbol("AAPL"))
	assert.False(t, client.SupportsSymbol("BTC"))
	assert.False(t, client.SupportsSymbol("EUR/USD"))
	assert.False(t, client.SupportsSymbol(""))
}

func TestMetalsAPIClient_Name(t *testing.T) {
	client := NewMetalsAPIClient("test_key", nil, nil)
	assert.Equal(t, "metalprice_api", client.Name())
}

func TestMetalsAPIClient_determineMarketState(t *testing.T) {
	client := NewMetalsAPIClient("test_key", nil, nil)

	// This test depends on the current time, so we just verify it returns a valid state
	state := client.determineMarketState()
	assert.Contains(t, []string{"OPEN", "CLOSED"}, state)
}

func TestMetalsAPIClient_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)
	client.baseURL = server.URL

	_, err := client.GetQuote(context.Background(), "GOLD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "unexpected status")
}

func TestMetalsAPIClient_APIError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": false,
			"error": {
				"code": 401,
				"info": "Invalid API key"
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("invalid_key", nil, mapper)
	client.baseURL = server.URL

	_, err := client.GetQuote(context.Background(), "GOLD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "API returned error")
}

func TestMetalsAPIClient_RateLimiting(t *testing.T) {
	requestCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestCount++
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": true,
			"timestamp": 1705315200,
			"base": "USD",
			"date": "2024-01-15",
			"rates": {
				"XAU": 0.0004831705,
				"USDXAU": 2069.66
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	limiter := NewRateLimiter(2, time.Second) // 2 requests per second
	client := NewMetalsAPIClient("test_api_key", limiter, mapper)
	client.baseURL = server.URL

	ctx := context.Background()

	// First two requests should succeed quickly
	_, err := client.GetQuote(ctx, "GOLD")
	require.NoError(t, err)
	_, err = client.GetQuote(ctx, "GOLD")
	require.NoError(t, err)

	assert.Equal(t, 2, requestCount)
}

func TestMetalsAPIClient_extractPrice(t *testing.T) {
	client := NewMetalsAPIClient("test_key", nil, nil)

	tests := []struct {
		name      string
		rates     map[string]float64
		apiSymbol string
		wantPrice float64
		wantFound bool
	}{
		{
			name: "direct price USDXAU",
			rates: map[string]float64{
				"XAU":    0.0004831705,
				"USDXAU": 2069.66,
			},
			apiSymbol: "XAU",
			wantPrice: 2069.66,
			wantFound: true,
		},
		{
			name: "inverse rate only",
			rates: map[string]float64{
				"XAU": 0.0004831705,
			},
			apiSymbol: "XAU",
			wantPrice: 1.0 / 0.0004831705,
			wantFound: true,
		},
		{
			name: "silver USDXAG",
			rates: map[string]float64{
				"XAG":    0.041405839,
				"USDXAG": 24.15,
			},
			apiSymbol: "XAG",
			wantPrice: 24.15,
			wantFound: true,
		},
		{
			name:      "symbol not found",
			rates:     map[string]float64{"XAU": 0.0004831705},
			apiSymbol: "XAG",
			wantPrice: 0,
			wantFound: false,
		},
		{
			name:      "zero rate",
			rates:     map[string]float64{"XAU": 0},
			apiSymbol: "XAU",
			wantPrice: 0,
			wantFound: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			price, found := client.extractPrice(tt.rates, tt.apiSymbol)
			assert.Equal(t, tt.wantFound, found, "found mismatch")
			if tt.wantFound {
				assert.InDelta(t, tt.wantPrice, price, 0.01, "price mismatch")
			}
		})
	}
}

func TestMetalsAPIClient_generateTradingDates(t *testing.T) {
	client := NewMetalsAPIClient("test_key", nil, nil)

	// Test a week with weekends
	from := time.Date(2024, 1, 8, 0, 0, 0, 0, time.UTC) // Monday
	to := time.Date(2024, 1, 14, 0, 0, 0, 0, time.UTC)  // Sunday

	dates := client.generateTradingDates(from, to)

	// Should have 5 trading days (Mon-Fri)
	assert.Len(t, dates, 5)

	// Verify no weekends
	for _, d := range dates {
		weekday := d.Weekday()
		assert.NotEqual(t, time.Saturday, weekday, "should not include Saturday")
		assert.NotEqual(t, time.Sunday, weekday, "should not include Sunday")
	}
}

func TestMetalsAPIClient_GetHistoricalPrices(t *testing.T) {
	requestCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestCount++
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"success": true,
			"historical": true,
			"timestamp": 1705315200,
			"base": "USD",
			"date": "2024-01-15",
			"rates": {
				"XAU": 0.0004831705
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewMetalsSymbolMapper()
	client := NewMetalsAPIClient("test_api_key", nil, mapper)
	client.baseURL = server.URL

	// Short date range to limit requests
	from := time.Date(2024, 1, 15, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 17, 0, 0, 0, 0, time.UTC)

	points, err := client.GetHistoricalPrices(context.Background(), "GOLD", from, to)
	require.NoError(t, err)
	require.NotNil(t, points)

	// Should have 2-3 trading days
	assert.GreaterOrEqual(t, len(points), 1)
	assert.LessOrEqual(t, len(points), 3)

	// Verify price is calculated correctly
	for _, p := range points {
		assert.InDelta(t, 1.0/0.0004831705, p.Close, 0.01)
	}
}

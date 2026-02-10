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

func TestExchangeRateClient_GetQuote(t *testing.T) {
	// Mock server response
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Equal(t, "/v6/latest/EUR", r.URL.Path)

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"result": "success",
			"documentation": "https://www.exchangerate-api.com/docs",
			"terms_of_use": "https://www.exchangerate-api.com/terms",
			"time_last_update_unix": 1705276801,
			"time_last_update_utc": "Mon, 15 Jan 2024 00:00:01 +0000",
			"time_next_update_unix": 1705363201,
			"time_next_update_utc": "Tue, 16 Jan 2024 00:00:01 +0000",
			"base_code": "EUR",
			"rates": {
				"USD": 1.0875,
				"GBP": 0.8567,
				"JPY": 160.25
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)
	client.baseURL = server.URL

	quote, err := client.GetQuote(context.Background(), "EUR/USD")
	require.NoError(t, err)
	require.NotNil(t, quote)

	assert.Equal(t, "EUR/USD", quote.Symbol)
	assert.Equal(t, 1.0875, quote.Price)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "exchangerate", quote.Source)
}

func TestExchangeRateClient_GetQuote_InvalidSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)

	_, err := client.GetQuote(context.Background(), "INVALID")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "invalid forex symbol")
}

func TestExchangeRateClient_GetQuotes(t *testing.T) {
	// Mock server that returns all rates for a base currency
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var response string
		if r.URL.Path == "/v6/latest/EUR" {
			response = `{
				"result": "success",
				"time_last_update_unix": 1705276801,
				"base_code": "EUR",
				"rates": {
					"USD": 1.0875,
					"GBP": 0.8567
				}
			}`
		} else if r.URL.Path == "/v6/latest/USD" {
			response = `{
				"result": "success",
				"time_last_update_unix": 1705276801,
				"base_code": "USD",
				"rates": {
					"JPY": 147.50
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
	client := NewExchangeRateClient("", nil, mapper)
	client.baseURL = server.URL

	quotes, err := client.GetQuotes(context.Background(), []string{"EUR/USD", "EUR/GBP", "USD/JPY"})
	require.NoError(t, err)
	require.NotNil(t, quotes)

	assert.Len(t, quotes, 3)
	assert.NotNil(t, quotes["EUR/USD"])
	assert.NotNil(t, quotes["EUR/GBP"])
	assert.NotNil(t, quotes["USD/JPY"])
	assert.Equal(t, 1.0875, quotes["EUR/USD"].Price)
	assert.Equal(t, 0.8567, quotes["EUR/GBP"].Price)
	assert.Equal(t, 147.50, quotes["USD/JPY"].Price)
}

func TestExchangeRateClient_GetHistoricalPrices_NotSupported(t *testing.T) {
	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)

	// ExchangeRate free tier doesn't support historical data
	from := time.Date(2024, 1, 1, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 5, 0, 0, 0, 0, time.UTC)
	points, err := client.GetHistoricalPrices(context.Background(), "EUR/USD", from, to)

	// Should return nil without error (to allow fallback to another provider)
	assert.NoError(t, err)
	assert.Nil(t, points)
}

func TestExchangeRateClient_SupportsSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)

	assert.True(t, client.SupportsSymbol("EUR/USD"))
	assert.True(t, client.SupportsSymbol("EURUSD"))
	assert.True(t, client.SupportsSymbol("gbp/jpy"))
	assert.False(t, client.SupportsSymbol("AAPL"))
	assert.False(t, client.SupportsSymbol("BTC"))
	assert.False(t, client.SupportsSymbol(""))
}

func TestExchangeRateClient_Name(t *testing.T) {
	client := NewExchangeRateClient("", nil, nil)
	assert.Equal(t, "exchangerate", client.Name())
}

func TestExchangeRateClient_APIError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"result": "error",
			"error-type": "unsupported-code"
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)
	client.baseURL = server.URL

	_, err := client.GetQuote(context.Background(), "EUR/USD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "API returned error")
}

func TestExchangeRateClient_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)
	client.baseURL = server.URL

	_, err := client.GetQuote(context.Background(), "EUR/USD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "unexpected status")
}

func TestExchangeRateClient_RateNotFound(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, err := w.Write([]byte(`{
			"result": "success",
			"time_last_update_unix": 1705276801,
			"base_code": "EUR",
			"rates": {
				"GBP": 0.8567
			}
		}`))
		require.NoError(t, err)
	}))
	defer server.Close()

	mapper := NewForexSymbolMapper()
	client := NewExchangeRateClient("", nil, mapper)
	client.baseURL = server.URL

	// Request EUR/USD but USD is not in rates
	_, err := client.GetQuote(context.Background(), "EUR/USD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "rate not found")
}

func TestExchangeRateClient_determineMarketState(t *testing.T) {
	client := NewExchangeRateClient("", nil, nil)

	// This test depends on the current time, so we just verify it returns a valid state
	state := client.determineMarketState()
	assert.Contains(t, []string{"OPEN", "CLOSED"}, state)
}

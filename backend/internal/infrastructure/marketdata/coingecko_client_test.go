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

func TestCoinGeckoClient_GetQuote(t *testing.T) {
	// Mock CoinGecko API response
	mockResponse := `{
		"bitcoin": {
			"usd": 43250.50,
			"usd_24h_change": 2.45,
			"usd_24h_vol": 28500000000,
			"usd_market_cap": 850000000000,
			"last_updated_at": 1705340800
		}
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Contains(t, r.URL.Path, "/simple/price")
		assert.Equal(t, "bitcoin", r.URL.Query().Get("ids"))
		assert.Equal(t, "usd", r.URL.Query().Get("vs_currencies"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	require.NoError(t, err)
	require.NotNil(t, quote)
	assert.Equal(t, "BTC", quote.Symbol)
	assert.Equal(t, 43250.50, quote.Price)
	assert.InDelta(t, 2.45, quote.ChangePercent, 0.01)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "24/7", quote.MarketState)
	assert.Equal(t, "coingecko", quote.Source)
}

func TestCoinGeckoClient_GetQuote_UnknownSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "UNKNOWNCRYPTO")

	assert.Error(t, err)
	assert.Nil(t, quote)
}

func TestCoinGeckoClient_GetQuotes_Batch(t *testing.T) {
	mockResponse := `{
		"bitcoin": {
			"usd": 43250.50,
			"usd_24h_change": 2.45,
			"last_updated_at": 1705340800
		},
		"ethereum": {
			"usd": 2280.75,
			"usd_24h_change": -1.23,
			"last_updated_at": 1705340800
		}
	}`

	callCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		callCount++
		ids := r.URL.Query().Get("ids")
		assert.Contains(t, ids, "bitcoin")
		assert.Contains(t, ids, "ethereum")

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quotes, err := client.GetQuotes(ctx, []string{"BTC", "ETH"})

	require.NoError(t, err)
	assert.Len(t, quotes, 2)
	assert.Equal(t, 1, callCount) // Should be a single batch request

	assert.NotNil(t, quotes["BTC"])
	assert.Equal(t, 43250.50, quotes["BTC"].Price)

	assert.NotNil(t, quotes["ETH"])
	assert.Equal(t, 2280.75, quotes["ETH"].Price)
}

func TestCoinGeckoClient_GetQuotes_EmptyList(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)

	ctx := context.Background()
	quotes, err := client.GetQuotes(ctx, []string{})

	require.NoError(t, err)
	assert.Empty(t, quotes)
}

func TestCoinGeckoClient_GetQuote_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusTooManyRequests)
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "unexpected status 429")
}

func TestCoinGeckoClient_GetHistoricalPrices(t *testing.T) {
	mockResponse := `{
		"prices": [
			[1705190400000, 42000.50],
			[1705276800000, 42500.75],
			[1705363200000, 43250.50]
		],
		"market_caps": [
			[1705190400000, 820000000000],
			[1705276800000, 830000000000],
			[1705363200000, 850000000000]
		],
		"total_volumes": [
			[1705190400000, 25000000000],
			[1705276800000, 27000000000],
			[1705363200000, 28500000000]
		]
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Contains(t, r.URL.Path, "/coins/bitcoin/market_chart/range")
		assert.Equal(t, "usd", r.URL.Query().Get("vs_currency"))
		assert.NotEmpty(t, r.URL.Query().Get("from"))
		assert.NotEmpty(t, r.URL.Query().Get("to"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	from := time.Date(2024, 1, 14, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 16, 0, 0, 0, 0, time.UTC)

	prices, err := client.GetHistoricalPrices(ctx, "BTC", from, to)

	require.NoError(t, err)
	assert.Len(t, prices, 3)

	// Check first price point
	assert.Equal(t, 42000.50, prices[0].Close)
	assert.Equal(t, int64(25000000000), prices[0].Volume)
}

func TestCoinGeckoClient_GetHistoricalPrices_NoData(t *testing.T) {
	mockResponse := `{"prices": [], "market_caps": [], "total_volumes": []}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "BTC", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "no historical data")
}

func TestCoinGeckoClient_GetHistoricalPrices_UnknownSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "UNKNOWNCRYPTO", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "unknown symbol")
}

func TestCoinGeckoClient_SupportsSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)

	assert.True(t, client.SupportsSymbol("BTC"))
	assert.True(t, client.SupportsSymbol("ETH"))
	assert.True(t, client.SupportsSymbol("bitcoin")) // CoinGecko ID
	assert.False(t, client.SupportsSymbol("AAPL"))   // Stock, not crypto
	assert.False(t, client.SupportsSymbol(""))
}

func TestCoinGeckoClient_Name(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	assert.Equal(t, "coingecko", client.Name())
}

func TestCoinGeckoClient_WithRateLimiter(t *testing.T) {
	mockResponse := `{"bitcoin": {"usd": 43250.50, "usd_24h_change": 2.45, "last_updated_at": 1705340800}}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	rateLimiter := NewRateLimiter(2, time.Second)
	client := NewCoinGeckoClient("", rateLimiter, mapper)
	client.baseURL = server.URL

	ctx := context.Background()

	// First two requests should succeed immediately
	_, err1 := client.GetQuote(ctx, "BTC")
	_, err2 := client.GetQuote(ctx, "BTC")

	assert.NoError(t, err1)
	assert.NoError(t, err2)

	// Third request should wait for rate limiter
	start := time.Now()
	_, err3 := client.GetQuote(ctx, "BTC")
	elapsed := time.Since(start)

	assert.NoError(t, err3)
	assert.GreaterOrEqual(t, elapsed.Milliseconds(), int64(400)) // Should have waited ~500ms
}

func TestCoinGeckoClient_RateLimiter_ContextCanceled(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	rateLimiter := NewRateLimiter(1, time.Hour) // Very slow refill
	client := NewCoinGeckoClient("", rateLimiter, mapper)

	// Consume the only token
	rateLimiter.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	_, err := client.GetQuote(ctx, "BTC")

	assert.Error(t, err)
	assert.Contains(t, err.Error(), "rate limit wait")
}

func TestCoinGeckoClient_WithAPIKey(t *testing.T) {
	mockResponse := `{"bitcoin": {"usd": 43250.50, "usd_24h_change": 2.45, "last_updated_at": 1705340800}}`

	var receivedHeader string
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		receivedHeader = r.Header.Get("x-cg-pro-api-key")

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("test-api-key", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	_, err := client.GetQuote(ctx, "BTC")

	require.NoError(t, err)
	assert.Equal(t, "test-api-key", receivedHeader)
}

func TestCoinGeckoClient_CalculatesChange(t *testing.T) {
	// Price = 100, ChangePercent = 5% -> Change should be 5
	mockResponse := `{
		"bitcoin": {
			"usd": 100.0,
			"usd_24h_change": 5.0,
			"last_updated_at": 1705340800
		}
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewCoinGeckoClient("", nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	require.NoError(t, err)
	require.NotNil(t, quote)
	assert.Equal(t, 100.0, quote.Price)
	assert.Equal(t, 5.0, quote.ChangePercent)
	assert.InDelta(t, 5.0, quote.Change, 0.01) // 100 * 0.05 = 5
}

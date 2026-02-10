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

func TestBinanceClient_GetQuote(t *testing.T) {
	// Mock Binance API response
	mockResponse := `{
		"symbol": "BTCUSDT",
		"priceChange": "1050.25",
		"priceChangePercent": "2.45",
		"weightedAvgPrice": "42800.50",
		"prevClosePrice": "42200.25",
		"lastPrice": "43250.50",
		"lastQty": "0.50",
		"bidPrice": "43249.00",
		"bidQty": "1.25",
		"askPrice": "43251.00",
		"askQty": "0.75",
		"openPrice": "42200.25",
		"highPrice": "43800.00",
		"lowPrice": "42100.00",
		"volume": "12345.67",
		"quoteVolume": "530000000.00",
		"openTime": 1705254400000,
		"closeTime": 1705340800000,
		"firstId": 1000000,
		"lastId": 1500000,
		"count": 500000
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Contains(t, r.URL.Path, "/api/v3/ticker/24hr")
		assert.Equal(t, "BTCUSDT", r.URL.Query().Get("symbol"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	require.NoError(t, err)
	require.NotNil(t, quote)
	assert.Equal(t, "BTC", quote.Symbol)
	assert.Equal(t, 43250.50, quote.Price)
	assert.Equal(t, 1050.25, quote.Change)
	assert.InDelta(t, 2.45, quote.ChangePercent, 0.01)
	assert.Equal(t, "USD", quote.Currency)
	assert.Equal(t, "24/7", quote.MarketState)
	assert.Equal(t, "binance", quote.Source)
}

func TestBinanceClient_GetQuote_UnknownSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "USDT") // USDT has no trading pair in our mapper

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "unknown symbol")
}

func TestBinanceClient_GetQuote_HTTPError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusBadRequest)
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	assert.Error(t, err)
	assert.Nil(t, quote)
	assert.Contains(t, err.Error(), "unexpected status 400")
}

func TestBinanceClient_GetQuotes(t *testing.T) {
	callCount := 0
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		callCount++
		symbol := r.URL.Query().Get("symbol")

		var response string
		switch symbol {
		case "BTCUSDT":
			response = `{"symbol": "BTCUSDT", "lastPrice": "43250.50", "priceChange": "1050.25", "priceChangePercent": "2.45", "closeTime": 1705340800000}`
		case "ETHUSDT":
			response = `{"symbol": "ETHUSDT", "lastPrice": "2280.75", "priceChange": "-28.50", "priceChangePercent": "-1.23", "closeTime": 1705340800000}`
		default:
			w.WriteHeader(http.StatusBadRequest)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(response))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quotes, err := client.GetQuotes(ctx, []string{"BTC", "ETH"})

	require.NoError(t, err)
	assert.Len(t, quotes, 2)
	assert.Equal(t, 2, callCount) // Sequential calls for each symbol

	assert.NotNil(t, quotes["BTC"])
	assert.Equal(t, 43250.50, quotes["BTC"].Price)

	assert.NotNil(t, quotes["ETH"])
	assert.Equal(t, 2280.75, quotes["ETH"].Price)
}

func TestBinanceClient_GetQuotes_PartialFailure(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		symbol := r.URL.Query().Get("symbol")

		if symbol == "BTCUSDT" {
			response := `{"symbol": "BTCUSDT", "lastPrice": "43250.50", "priceChange": "1050.25", "priceChangePercent": "2.45", "closeTime": 1705340800000}`
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte(response))
		} else {
			w.WriteHeader(http.StatusBadRequest)
		}
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quotes, err := client.GetQuotes(ctx, []string{"BTC", "INVALID"})

	require.NoError(t, err)
	assert.Len(t, quotes, 1)
	assert.NotNil(t, quotes["BTC"])
}

func TestBinanceClient_GetHistoricalPrices(t *testing.T) {
	// Binance kline response format: [openTime, open, high, low, close, volume, closeTime, ...]
	mockResponse := `[
		[1705190400000, "42000.50", "42500.00", "41800.00", "42300.00", "1000.00", 1705276799999, "42150000.00", 50000, "500.00", "21075000.00", "0"],
		[1705276800000, "42300.00", "43000.00", "42200.00", "42800.00", "1200.00", 1705363199999, "51360000.00", 60000, "600.00", "25680000.00", "0"],
		[1705363200000, "42800.00", "43500.00", "42600.00", "43250.50", "1500.00", 1705449599999, "64500000.00", 75000, "750.00", "32250000.00", "0"]
	]`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		assert.Contains(t, r.URL.Path, "/api/v3/klines")
		assert.Equal(t, "BTCUSDT", r.URL.Query().Get("symbol"))
		assert.Equal(t, "1d", r.URL.Query().Get("interval"))
		assert.NotEmpty(t, r.URL.Query().Get("startTime"))
		assert.NotEmpty(t, r.URL.Query().Get("endTime"))

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	from := time.Date(2024, 1, 14, 0, 0, 0, 0, time.UTC)
	to := time.Date(2024, 1, 17, 0, 0, 0, 0, time.UTC)

	prices, err := client.GetHistoricalPrices(ctx, "BTC", from, to)

	require.NoError(t, err)
	assert.Len(t, prices, 3)

	// Check first price point
	assert.Equal(t, 42000.50, prices[0].Open)
	assert.Equal(t, 42500.00, prices[0].High)
	assert.Equal(t, 41800.00, prices[0].Low)
	assert.Equal(t, 42300.00, prices[0].Close)
	assert.Equal(t, int64(1000), prices[0].Volume)
}

func TestBinanceClient_GetHistoricalPrices_NoData(t *testing.T) {
	mockResponse := `[]`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "BTC", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "no historical data")
}

func TestBinanceClient_GetHistoricalPrices_UnknownSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)

	ctx := context.Background()
	prices, err := client.GetHistoricalPrices(ctx, "USDT", time.Now().AddDate(0, -1, 0), time.Now())

	assert.Error(t, err)
	assert.Nil(t, prices)
	assert.Contains(t, err.Error(), "unknown symbol")
}

func TestBinanceClient_SupportsSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)

	assert.True(t, client.SupportsSymbol("BTC"))
	assert.True(t, client.SupportsSymbol("ETH"))
	assert.True(t, client.SupportsSymbol("btc"))   // lowercase should work
	assert.False(t, client.SupportsSymbol("USDT")) // stablecoin, no pair
	assert.False(t, client.SupportsSymbol("AAPL")) // Stock, not crypto
	assert.False(t, client.SupportsSymbol(""))
}

func TestBinanceClient_Name(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	assert.Equal(t, "binance", client.Name())
}

func TestBinanceClient_WithRateLimiter(t *testing.T) {
	mockResponse := `{"symbol": "BTCUSDT", "lastPrice": "43250.50", "priceChange": "1050.25", "priceChangePercent": "2.45", "closeTime": 1705340800000}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	rateLimiter := NewRateLimiter(2, time.Second)
	client := NewBinanceClient(rateLimiter, mapper)
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

func TestBinanceClient_RateLimiter_ContextCanceled(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	rateLimiter := NewRateLimiter(1, time.Hour) // Very slow refill
	client := NewBinanceClient(rateLimiter, mapper)

	// Consume the only token
	rateLimiter.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	_, err := client.GetQuote(ctx, "BTC")

	assert.Error(t, err)
	assert.Contains(t, err.Error(), "rate limit wait")
}

func TestBinanceClient_GetQuotes_ContextCanceled(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		time.Sleep(100 * time.Millisecond) // Simulate slow response
		w.WriteHeader(http.StatusOK)
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	quotes, err := client.GetQuotes(ctx, []string{"BTC", "ETH", "SOL"})

	// Should return partial results or error due to context cancellation
	assert.True(t, len(quotes) < 3 || err != nil)
}

func TestBinanceClient_ParsesTimestamp(t *testing.T) {
	mockResponse := `{
		"symbol": "BTCUSDT",
		"lastPrice": "43250.50",
		"priceChange": "1050.25",
		"priceChangePercent": "2.45",
		"closeTime": 1705340800000
	}`

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(mockResponse))
	}))
	defer server.Close()

	mapper := NewCryptoSymbolMapper()
	client := NewBinanceClient(nil, mapper)
	client.baseURL = server.URL

	ctx := context.Background()
	quote, err := client.GetQuote(ctx, "BTC")

	require.NoError(t, err)
	require.NotNil(t, quote)
	// Timestamp 1705340800000 ms = Mon Jan 15 2024 16:00:00 GMT+0000
	expected := time.UnixMilli(1705340800000).UTC()
	assert.Equal(t, expected, quote.UpdatedAt)
}

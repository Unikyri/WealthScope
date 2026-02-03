package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// MockMarketDataClient is a mock implementation of services.MarketDataClient
type MockMarketDataClient struct {
	mock.Mock
}

//nolint:errcheck // mock type assertion is safe in tests
func (m *MockMarketDataClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	args := m.Called(ctx, symbol)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*services.Quote), args.Error(1)
}

//nolint:errcheck // mock type assertion is safe in tests
func (m *MockMarketDataClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	args := m.Called(ctx, symbols)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(map[string]*services.Quote), args.Error(1)
}

//nolint:errcheck // mock type assertion is safe in tests
func (m *MockMarketDataClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	args := m.Called(ctx, symbol, from, to)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]services.PricePoint), args.Error(1)
}

func (m *MockMarketDataClient) SupportsSymbol(symbol string) bool {
	args := m.Called(symbol)
	return args.Bool(0)
}

func (m *MockMarketDataClient) Name() string {
	return "mock"
}

func TestCurrencyService_Convert_SameCurrency(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	// Same currency should return same amount without API call
	result, err := svc.Convert(context.Background(), 100.0, "USD", "USD")
	require.NoError(t, err)
	assert.Equal(t, 100.0, result)

	// No API calls should have been made
	mockClient.AssertNotCalled(t, "GetQuote")
}

func TestCurrencyService_Convert_Success(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil)

	result, err := svc.Convert(context.Background(), 100.0, "EUR", "USD")
	require.NoError(t, err)
	assert.InDelta(t, 110.0, result, 0.0001) // 100 EUR * 1.10 = 110 USD

	mockClient.AssertExpectations(t)
}

func TestCurrencyService_GetExchangeRate_Cached(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil).Once() // Only called once

	// First call - fetches from API
	rate1, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)
	assert.Equal(t, 1.10, rate1)

	// Second call - should use cache
	rate2, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)
	assert.Equal(t, 1.10, rate2)

	mockClient.AssertExpectations(t)
}

func TestCurrencyService_GetExchangeRate_SameCurrency(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	rate, err := svc.GetExchangeRate(context.Background(), "USD", "USD")
	require.NoError(t, err)
	assert.Equal(t, 1.0, rate)

	mockClient.AssertNotCalled(t, "GetQuote")
}

func TestCurrencyService_GetExchangeRate_ReversePair(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	// First call fails, second with reverse pair succeeds
	mockClient.On("GetQuote", mock.Anything, "JPY/USD").Return(nil, errors.New("not found"))
	mockClient.On("GetQuote", mock.Anything, "USD/JPY").Return(&services.Quote{
		Symbol: "USD/JPY",
		Price:  150.0,
	}, nil)

	rate, err := svc.GetExchangeRate(context.Background(), "JPY", "USD")
	require.NoError(t, err)
	assert.InDelta(t, 1.0/150.0, rate, 0.0001) // Inverted rate

	mockClient.AssertExpectations(t)
}

func TestCurrencyService_GetExchangeRate_Error(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "XXX/YYY").Return(nil, errors.New("not found"))
	mockClient.On("GetQuote", mock.Anything, "YYY/XXX").Return(nil, errors.New("not found"))

	_, err := svc.GetExchangeRate(context.Background(), "XXX", "YYY")
	assert.Error(t, err)
}

func TestCurrencyService_ConvertMultiple(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "USD/EUR").Return(&services.Quote{
		Symbol: "USD/EUR",
		Price:  0.92,
	}, nil)
	mockClient.On("GetQuote", mock.Anything, "USD/GBP").Return(&services.Quote{
		Symbol: "USD/GBP",
		Price:  0.79,
	}, nil)
	mockClient.On("GetQuote", mock.Anything, "USD/XXX").Return(nil, errors.New("not found"))
	mockClient.On("GetQuote", mock.Anything, "XXX/USD").Return(nil, errors.New("not found"))

	results, err := svc.ConvertMultiple(context.Background(), 100.0, "USD", []string{"EUR", "GBP", "XXX"})
	require.NoError(t, err)

	// Should have 2 results (XXX failed but doesn't error the whole operation)
	assert.Len(t, results, 2)
	assert.Equal(t, 92.0, results["EUR"])
	assert.Equal(t, 79.0, results["GBP"])
	_, exists := results["XXX"]
	assert.False(t, exists)
}

func TestCurrencyService_GetSupportedCurrencies(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	currencies := svc.GetSupportedCurrencies()
	assert.NotEmpty(t, currencies)
	assert.Contains(t, currencies, "USD")
	assert.Contains(t, currencies, "EUR")
	assert.Contains(t, currencies, "GBP")
}

func TestCurrencyService_ClearCache(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil)

	// First call - fetches from API
	_, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)

	// Clear cache
	svc.ClearCache()

	// Second call - should fetch from API again
	_, err = svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)

	// GetQuote should have been called twice
	mockClient.AssertNumberOfCalls(t, "GetQuote", 2)
}

func TestCurrencyService_GetCacheStats(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	// Initially empty
	size, _ := svc.GetCacheStats()
	assert.Equal(t, 0, size)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil)

	// Add an entry
	_, _ = svc.GetExchangeRate(context.Background(), "EUR", "USD")

	size, _ = svc.GetCacheStats()
	assert.Equal(t, 1, size)
}

func TestCurrencyService_CacheExpiry(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	// Very short TTL for testing
	svc := NewCurrencyService(mockClient, 50*time.Millisecond)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil)

	// First call
	_, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)

	// Wait for cache to expire
	time.Sleep(100 * time.Millisecond)

	// Second call should fetch again
	_, err = svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)

	// Should have been called twice
	mockClient.AssertNumberOfCalls(t, "GetQuote", 2)
}

func TestCurrencyService_StaleCache_OnError(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, 50*time.Millisecond)

	// First call succeeds
	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  1.10,
	}, nil).Once()

	_, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)

	// Wait for cache to expire
	time.Sleep(100 * time.Millisecond)

	// Second call fails - should return stale cached value
	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(nil, errors.New("network error")).Once()
	mockClient.On("GetQuote", mock.Anything, "USD/EUR").Return(nil, errors.New("network error")).Once()

	rate, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	require.NoError(t, err)
	assert.Equal(t, 1.10, rate) // Returns stale cached value
}

func TestCurrencyService_ZeroRate(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	svc := NewCurrencyService(mockClient, time.Minute)

	mockClient.On("GetQuote", mock.Anything, "EUR/USD").Return(&services.Quote{
		Symbol: "EUR/USD",
		Price:  0, // Invalid zero rate
	}, nil)

	_, err := svc.GetExchangeRate(context.Background(), "EUR", "USD")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "invalid rate (zero)")
}

func TestCurrencyService_DefaultCacheTTL(t *testing.T) {
	mockClient := new(MockMarketDataClient)
	// Pass 0 TTL - should use default
	svc := NewCurrencyService(mockClient, 0)

	assert.Equal(t, 5*time.Minute, svc.cacheTTL)
}

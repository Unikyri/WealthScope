package marketdata

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

func TestProviderRegistry_GetQuote_Fallback(t *testing.T) {
	ctx := context.Background()
	logger := zap.NewNop()
	registry := NewProviderRegistry(logger)

	// First client fails for AAPL, second succeeds
	mockFail := NewMockClient("mock_fail")
	mockFail.SetFailSymbol("AAPL")
	mockOK := NewMockClient("mock_ok")

	registry.Register(services.CategoryEquity, mockFail)
	registry.Register(services.CategoryEquity, mockOK)

	q, err := registry.GetQuote(ctx, "AAPL")
	require.NoError(t, err)
	require.NotNil(t, q)
	assert.Equal(t, "AAPL", q.Symbol)
	assert.Equal(t, 100.0, q.Price)
	assert.Equal(t, "mock_ok", q.Source)
}

func TestProviderRegistry_GetQuote_AllFail(t *testing.T) {
	ctx := context.Background()
	logger := zap.NewNop()
	registry := NewProviderRegistry(logger)

	mockFail := NewMockClient("mock_fail")
	mockFail.SetFailSymbol("MISSING")
	registry.Register(services.CategoryEquity, mockFail)

	q, err := registry.GetQuote(ctx, "MISSING")
	assert.Error(t, err)
	assert.Nil(t, q)
}

func TestProviderRegistry_GetQuote_FirstSucceeds(t *testing.T) {
	ctx := context.Background()
	logger := zap.NewNop()
	registry := NewProviderRegistry(logger)

	mockFirst := NewMockClient("first")
	mockSecond := NewMockClient("second")
	registry.Register(services.CategoryEquity, mockFirst)
	registry.Register(services.CategoryEquity, mockSecond)

	q, err := registry.GetQuote(ctx, "AAPL")
	require.NoError(t, err)
	require.NotNil(t, q)
	assert.Equal(t, "first", q.Source)
}

func TestProviderRegistry_GetQuotes_Partial(t *testing.T) {
	ctx := context.Background()
	logger := zap.NewNop()
	registry := NewProviderRegistry(logger)

	// Only one mock; it fails for FAIL so that symbol is skipped in GetQuotes
	mock := NewMockClient("mock")
	mock.SetFailSymbol("FAIL")
	registry.Register(services.CategoryEquity, mock)

	quotes, err := registry.GetQuotes(ctx, []string{"OK1", "FAIL", "OK2"})
	require.NoError(t, err)
	assert.Len(t, quotes, 2)
	assert.Contains(t, quotes, "OK1")
	assert.Contains(t, quotes, "OK2")
	assert.NotContains(t, quotes, "FAIL")
}

func TestProviderRegistry_SupportsSymbol(t *testing.T) {
	logger := zap.NewNop()
	registry := NewProviderRegistry(logger)
	mock := NewMockClient("mock")
	registry.Register(services.CategoryEquity, mock)

	assert.True(t, registry.SupportsSymbol("AAPL"))
}

func TestProviderRegistry_Name(t *testing.T) {
	registry := NewProviderRegistry(nil)
	assert.Equal(t, "market_data_registry", registry.Name())
}

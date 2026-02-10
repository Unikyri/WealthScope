package services

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

func TestNewPricingService(t *testing.T) {
	mock := marketdata.NewMockClient("mock")
	svc := NewPricingService(mock, time.Minute)
	require.NotNil(t, svc)
	assert.NotNil(t, svc.client)
	assert.Equal(t, mock, svc.client)
}

func TestPricingService_GetQuote_DelegatesAndCaches(t *testing.T) {
	ctx := context.Background()
	mock := marketdata.NewMockClient("mock")
	svc := NewPricingService(mock, time.Minute)

	q, err := svc.GetQuote(ctx, "AAPL")
	require.NoError(t, err)
	require.NotNil(t, q)
	assert.Equal(t, "AAPL", q.Symbol)
	assert.Equal(t, 100.0, q.Price)
	assert.Equal(t, "mock", q.Source)

	// Second call hits cache (mock would still work)
	q2, err2 := svc.GetQuote(ctx, "AAPL")
	require.NoError(t, err2)
	require.NotNil(t, q2)
	assert.Equal(t, q.Symbol, q2.Symbol)
}

func TestPricingService_GetQuotes_DelegatesAndCaches(t *testing.T) {
	ctx := context.Background()
	mock := marketdata.NewMockClient("mock")
	svc := NewPricingService(mock, time.Minute)

	quotes, err := svc.GetQuotes(ctx, []string{"AAPL", "MSFT"})
	require.NoError(t, err)
	require.Len(t, quotes, 2)
	assert.Equal(t, 100.0, quotes["AAPL"].Price)
	assert.Equal(t, 100.0, quotes["MSFT"].Price)
}

func TestPricingService_GetQuote_MockFail(t *testing.T) {
	ctx := context.Background()
	mock := marketdata.NewMockClient("mock")
	mock.SetFailSymbol("FAIL")
	svc := NewPricingService(mock, time.Minute)

	q, err := svc.GetQuote(ctx, "FAIL")
	assert.Error(t, err)
	assert.Nil(t, q)
}

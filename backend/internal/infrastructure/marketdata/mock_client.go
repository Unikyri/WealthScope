package marketdata

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// MockClient implements services.MarketDataClient for tests.
// Configure FailSymbols to make GetQuote/GetQuotes return an error for those symbols.
// Quotes for other symbols return fixed data (price 100, etc.).
//
//nolint:govet // fieldalignment: keep maps and mutex grouped for test readability
type MockClient struct {
	NameStr     string
	FailSymbols map[string]bool // symbol -> true to fail
	Supported   map[string]bool // symbol -> true to support; nil = support all
	mu          sync.RWMutex
}

// NewMockClient returns a mock client with the given name.
func NewMockClient(name string) *MockClient {
	return &MockClient{
		NameStr:     name,
		FailSymbols: make(map[string]bool),
		Supported:   nil,
	}
}

// SetFailSymbol marks symbol to return error from GetQuote/GetQuotes.
func (m *MockClient) SetFailSymbol(symbol string) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.FailSymbols == nil {
		m.FailSymbols = make(map[string]bool)
	}
	m.FailSymbols[strings.ToUpper(symbol)] = true
}

// SetSupportSymbol marks symbol as supported (if Supported map is used).
func (m *MockClient) SetSupportSymbol(symbol string, support bool) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if m.Supported == nil {
		m.Supported = make(map[string]bool)
	}
	m.Supported[strings.ToUpper(symbol)] = support
}

// GetQuote returns a mock quote or error if symbol is in FailSymbols.
func (m *MockClient) GetQuote(ctx context.Context, symbol string) (*services.Quote, error) {
	_ = ctx
	symbol = strings.ToUpper(symbol)
	m.mu.RLock()
	fail := m.FailSymbols[symbol]
	supported := m.Supported == nil || m.Supported[symbol]
	m.mu.RUnlock()

	if !supported {
		return nil, fmt.Errorf("mock: symbol %s not supported", symbol)
	}
	if fail {
		return nil, fmt.Errorf("mock: failing symbol %s", symbol)
	}

	now := time.Now().UTC()
	return &services.Quote{
		Symbol:        symbol,
		Price:         100,
		Change:        1,
		ChangePercent: 1,
		MarketState:   "REGULAR",
		Currency:      "USD",
		UpdatedAt:     now,
		Source:        m.Name(),
	}, nil
}

// GetQuotes returns mock quotes for each symbol; fails only for symbols in FailSymbols.
func (m *MockClient) GetQuotes(ctx context.Context, symbols []string) (map[string]*services.Quote, error) {
	out := make(map[string]*services.Quote, len(symbols))
	for _, symbol := range symbols {
		q, err := m.GetQuote(ctx, symbol)
		if err != nil {
			continue
		}
		out[strings.ToUpper(symbol)] = q
	}
	return out, nil
}

// GetHistoricalPrices returns empty slice (mock).
func (m *MockClient) GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]services.PricePoint, error) {
	_ = ctx
	_ = symbol
	_ = from
	_ = to
	return nil, nil
}

// SupportsSymbol returns true unless Supported map is set and symbol is not in it.
func (m *MockClient) SupportsSymbol(symbol string) bool {
	symbol = strings.ToUpper(symbol)
	m.mu.RLock()
	defer m.mu.RUnlock()
	if m.Supported == nil {
		return true
	}
	return m.Supported[symbol]
}

// Name returns the mock client name.
func (m *MockClient) Name() string {
	if m.NameStr != "" {
		return m.NameStr
	}
	return "mock"
}

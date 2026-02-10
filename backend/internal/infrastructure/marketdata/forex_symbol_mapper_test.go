package marketdata

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestForexSymbolMapper_ParsePair(t *testing.T) {
	mapper := NewForexSymbolMapper()

	tests := []struct {
		name      string
		symbol    string
		wantBase  string
		wantQuote string
		wantOK    bool
	}{
		{
			name:      "standard format EUR/USD",
			symbol:    "EUR/USD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "concatenated format EURUSD",
			symbol:    "EURUSD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "dash format EUR-USD",
			symbol:    "EUR-USD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "underscore format EUR_USD",
			symbol:    "EUR_USD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "lowercase eurusd",
			symbol:    "eurusd",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "mixed case EuR/UsD",
			symbol:    "EuR/UsD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "with spaces EUR / USD",
			symbol:    "EUR USD",
			wantBase:  "EUR",
			wantQuote: "USD",
			wantOK:    true,
		},
		{
			name:      "GBP/JPY valid pair",
			symbol:    "GBP/JPY",
			wantBase:  "GBP",
			wantQuote: "JPY",
			wantOK:    true,
		},
		{
			name:      "invalid - same currency",
			symbol:    "USD/USD",
			wantBase:  "",
			wantQuote: "",
			wantOK:    false,
		},
		{
			name:      "invalid - unknown currency XXX",
			symbol:    "XXX/USD",
			wantBase:  "",
			wantQuote: "",
			wantOK:    false,
		},
		{
			name:      "invalid - too short",
			symbol:    "EUUS",
			wantBase:  "",
			wantQuote: "",
			wantOK:    false,
		},
		{
			name:      "invalid - too long",
			symbol:    "EURUSDGBP",
			wantBase:  "",
			wantQuote: "",
			wantOK:    false,
		},
		{
			name:      "invalid - empty",
			symbol:    "",
			wantBase:  "",
			wantQuote: "",
			wantOK:    false,
		},
		{
			name:      "valid - MXN/BRL",
			symbol:    "MXN/BRL",
			wantBase:  "MXN",
			wantQuote: "BRL",
			wantOK:    true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			base, quote, ok := mapper.ParsePair(tt.symbol)
			assert.Equal(t, tt.wantOK, ok, "ok mismatch")
			assert.Equal(t, tt.wantBase, base, "base mismatch")
			assert.Equal(t, tt.wantQuote, quote, "quote mismatch")
		})
	}
}

func TestForexSymbolMapper_NormalizeSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()

	tests := []struct {
		input    string
		expected string
	}{
		{"EUR/USD", "EURUSD"},
		{"eur-usd", "EURUSD"},
		{"EUR_USD", "EURUSD"},
		{"  eurusd  ", "EURUSD"},
		{"gbp/jpy", "GBPJPY"},
		{"", ""},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := mapper.NormalizeSymbol(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestForexSymbolMapper_IsForexSymbol(t *testing.T) {
	mapper := NewForexSymbolMapper()

	// Valid forex symbols
	validSymbols := []string{
		"EUR/USD", "EURUSD", "GBP/JPY", "USD/CHF", "AUD/NZD",
		"eur/usd", "USD-MXN", "CNY/HKD",
	}

	for _, symbol := range validSymbols {
		t.Run("valid_"+symbol, func(t *testing.T) {
			assert.True(t, mapper.IsForexSymbol(symbol), "should be forex: %s", symbol)
		})
	}

	// Invalid symbols
	invalidSymbols := []string{
		"AAPL", "BTC", "ETH/BTC", "XXX/YYY", "EURUSDJPY", "",
	}

	for _, symbol := range invalidSymbols {
		t.Run("invalid_"+symbol, func(t *testing.T) {
			assert.False(t, mapper.IsForexSymbol(symbol), "should not be forex: %s", symbol)
		})
	}
}

func TestForexSymbolMapper_FormatPair(t *testing.T) {
	mapper := NewForexSymbolMapper()

	result := mapper.FormatPair("eur", "usd")
	assert.Equal(t, "EUR/USD", result)

	result = mapper.FormatPair("GBP", "JPY")
	assert.Equal(t, "GBP/JPY", result)
}

func TestForexSymbolMapper_GetSupportedCurrencies(t *testing.T) {
	mapper := NewForexSymbolMapper()

	currencies := mapper.GetSupportedCurrencies()
	assert.NotEmpty(t, currencies)

	// Check major currencies are present
	majorCurrencies := []string{"USD", "EUR", "GBP", "JPY", "CHF", "CAD", "AUD"}
	for _, major := range majorCurrencies {
		found := false
		for _, c := range currencies {
			if c == major {
				found = true
				break
			}
		}
		assert.True(t, found, "should contain %s", major)
	}
}

func TestForexSymbolMapper_IsSupportedCurrency(t *testing.T) {
	mapper := NewForexSymbolMapper()

	assert.True(t, mapper.IsSupportedCurrency("USD"))
	assert.True(t, mapper.IsSupportedCurrency("usd"))
	assert.True(t, mapper.IsSupportedCurrency("EUR"))
	assert.True(t, mapper.IsSupportedCurrency("MXN"))
	assert.False(t, mapper.IsSupportedCurrency("XXX"))
	assert.False(t, mapper.IsSupportedCurrency(""))
}

func TestForexSymbolMapper_GetMajorPairs(t *testing.T) {
	mapper := NewForexSymbolMapper()

	pairs := mapper.GetMajorPairs()
	assert.NotEmpty(t, pairs)
	assert.Contains(t, pairs, "EUR/USD")
	assert.Contains(t, pairs, "USD/JPY")
	assert.Contains(t, pairs, "GBP/USD")
}

package marketdata

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestMetalsSymbolMapper_ToAPISymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	tests := []struct {
		name      string
		input     string
		wantAPI   string
		wantFound bool
	}{
		// Gold aliases
		{"GOLD to XAU", "GOLD", "XAU", true},
		{"XAU to XAU", "XAU", "XAU", true},
		{"GLD to XAU", "GLD", "XAU", true},
		{"gold lowercase", "gold", "XAU", true},
		{"XAUUSD to XAU", "XAUUSD", "XAU", true},

		// Silver aliases
		{"SILVER to XAG", "SILVER", "XAG", true},
		{"XAG to XAG", "XAG", "XAG", true},
		{"SLV to XAG", "SLV", "XAG", true},

		// Platinum aliases
		{"PLATINUM to XPT", "PLATINUM", "XPT", true},
		{"XPT to XPT", "XPT", "XPT", true},

		// Palladium aliases
		{"PALLADIUM to XPD", "PALLADIUM", "XPD", true},
		{"XPD to XPD", "XPD", "XPD", true},

		// Unknown symbols
		{"unknown AAPL", "AAPL", "", false},
		{"unknown BTC", "BTC", "", false},
		{"empty string", "", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			apiSymbol, found := mapper.ToAPISymbol(tt.input)
			assert.Equal(t, tt.wantFound, found, "found mismatch")
			assert.Equal(t, tt.wantAPI, apiSymbol, "API symbol mismatch")
		})
	}
}

func TestMetalsSymbolMapper_IsMetalSymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	// Valid metal symbols
	validSymbols := []string{
		"GOLD", "gold", "XAU", "GLD", "XAUUSD",
		"SILVER", "XAG", "SLV",
		"PLATINUM", "XPT",
		"PALLADIUM", "XPD",
	}

	for _, symbol := range validSymbols {
		t.Run("valid_"+symbol, func(t *testing.T) {
			assert.True(t, mapper.IsMetalSymbol(symbol), "should be metal: %s", symbol)
		})
	}

	// Invalid symbols
	invalidSymbols := []string{
		"AAPL", "BTC", "ETH", "EUR/USD", "SPY", "",
	}

	for _, symbol := range invalidSymbols {
		t.Run("invalid_"+symbol, func(t *testing.T) {
			assert.False(t, mapper.IsMetalSymbol(symbol), "should not be metal: %s", symbol)
		})
	}
}

func TestMetalsSymbolMapper_ToDisplaySymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	tests := []struct {
		apiSymbol string
		wantName  string
	}{
		{"XAU", "Gold"},
		{"XAG", "Silver"},
		{"XPT", "Platinum"},
		{"XPD", "Palladium"},
		{"UNKNOWN", "UNKNOWN"}, // Returns input if not found
	}

	for _, tt := range tests {
		t.Run(tt.apiSymbol, func(t *testing.T) {
			name := mapper.ToDisplaySymbol(tt.apiSymbol)
			assert.Equal(t, tt.wantName, name)
		})
	}
}

func TestMetalsSymbolMapper_GetMetalName(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	tests := []struct {
		symbol   string
		wantName string
	}{
		{"GOLD", "Gold"},
		{"XAU", "Gold"},
		{"GLD", "Gold"},
		{"SILVER", "Silver"},
		{"XAG", "Silver"},
		{"PLATINUM", "Platinum"},
		{"PALLADIUM", "Palladium"},
		{"UNKNOWN", ""}, // Returns empty if not found
	}

	for _, tt := range tests {
		t.Run(tt.symbol, func(t *testing.T) {
			name := mapper.GetMetalName(tt.symbol)
			assert.Equal(t, tt.wantName, name)
		})
	}
}

func TestMetalsSymbolMapper_GetAllSymbols(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	symbols := mapper.GetAllSymbols()
	assert.NotEmpty(t, symbols)

	// Should contain major aliases
	symbolMap := make(map[string]bool)
	for _, s := range symbols {
		symbolMap[s] = true
	}

	assert.True(t, symbolMap["GOLD"], "should contain GOLD")
	assert.True(t, symbolMap["XAU"], "should contain XAU")
	assert.True(t, symbolMap["SILVER"], "should contain SILVER")
	assert.True(t, symbolMap["XAG"], "should contain XAG")
	assert.True(t, symbolMap["PLATINUM"], "should contain PLATINUM")
	assert.True(t, symbolMap["XPT"], "should contain XPT")
	assert.True(t, symbolMap["PALLADIUM"], "should contain PALLADIUM")
	assert.True(t, symbolMap["XPD"], "should contain XPD")
}

func TestMetalsSymbolMapper_GetAPISymbols(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	apiSymbols := mapper.GetAPISymbols()
	assert.Len(t, apiSymbols, 4) // XAU, XAG, XPT, XPD

	symbolMap := make(map[string]bool)
	for _, s := range apiSymbols {
		symbolMap[s] = true
	}

	assert.True(t, symbolMap["XAU"], "should contain XAU")
	assert.True(t, symbolMap["XAG"], "should contain XAG")
	assert.True(t, symbolMap["XPT"], "should contain XPT")
	assert.True(t, symbolMap["XPD"], "should contain XPD")
}

func TestMetalsSymbolMapper_NormalizeSymbol(t *testing.T) {
	mapper := NewMetalsSymbolMapper()

	tests := []struct {
		input    string
		expected string
	}{
		{"GOLD", "XAU"},
		{"gold", "XAU"},
		{"XAU", "XAU"},
		{"SILVER", "XAG"},
		{"UNKNOWN", "UNKNOWN"}, // Unknown returns uppercase input
		{"  xau  ", "XAU"},     // Trims whitespace
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := mapper.NormalizeSymbol(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

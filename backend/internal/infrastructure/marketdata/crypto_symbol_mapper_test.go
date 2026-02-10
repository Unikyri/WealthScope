package marketdata

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewCryptoSymbolMapper(t *testing.T) {
	mapper := NewCryptoSymbolMapper()
	require.NotNil(t, mapper)
	assert.NotEmpty(t, mapper.toCoinGecko)
	assert.NotEmpty(t, mapper.toBinance)
}

func TestCryptoSymbolMapper_ToCoinGeckoID(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		symbol   string
		expected string
		ok       bool
	}{
		{"BTC", "bitcoin", true},
		{"ETH", "ethereum", true},
		{"SOL", "solana", true},
		{"DOGE", "dogecoin", true},
		{"btc", "bitcoin", true},     // lowercase should work
		{"  BTC  ", "bitcoin", true}, // with spaces
		{"INVALID", "", false},
		{"", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.symbol, func(t *testing.T) {
			id, ok := mapper.ToCoinGeckoID(tt.symbol)
			assert.Equal(t, tt.ok, ok)
			if tt.ok {
				assert.Equal(t, tt.expected, id)
			}
		})
	}
}

func TestCryptoSymbolMapper_ToBinanceSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		symbol   string
		expected string
		ok       bool
	}{
		{"BTC", "BTCUSDT", true},
		{"ETH", "ETHUSDT", true},
		{"SOL", "SOLUSDT", true},
		{"btc", "BTCUSDT", true}, // lowercase should work
		{"USDT", "", false},      // stablecoins don't have trading pairs
		{"USDC", "", false},
		{"INVALID", "", false},
		{"", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.symbol, func(t *testing.T) {
			pair, ok := mapper.ToBinanceSymbol(tt.symbol)
			assert.Equal(t, tt.ok, ok)
			if tt.ok {
				assert.Equal(t, tt.expected, pair)
			}
		})
	}
}

func TestCryptoSymbolMapper_FromCoinGeckoID(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		id       string
		expected string
		ok       bool
	}{
		{"bitcoin", "BTC", true},
		{"ethereum", "ETH", true},
		{"solana", "SOL", true},
		{"BITCOIN", "BTC", true}, // uppercase should work (normalized to lowercase)
		{"invalid-coin", "", false},
		{"", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.id, func(t *testing.T) {
			symbol, ok := mapper.FromCoinGeckoID(tt.id)
			assert.Equal(t, tt.ok, ok)
			if tt.ok {
				assert.Equal(t, tt.expected, symbol)
			}
		})
	}
}

func TestCryptoSymbolMapper_FromBinanceSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		pair     string
		expected string
		ok       bool
	}{
		{"BTCUSDT", "BTC", true},
		{"ETHUSDT", "ETH", true},
		{"btcusdt", "BTC", true}, // lowercase should work
		{"INVALIDUSDT", "", false},
		{"", "", false},
	}

	for _, tt := range tests {
		t.Run(tt.pair, func(t *testing.T) {
			symbol, ok := mapper.FromBinanceSymbol(tt.pair)
			assert.Equal(t, tt.ok, ok)
			if tt.ok {
				assert.Equal(t, tt.expected, symbol)
			}
		})
	}
}

func TestCryptoSymbolMapper_NormalizeSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		input    string
		expected string
	}{
		{"BTC", "BTC"},
		{"btc", "BTC"},
		{"bitcoin", "BTC"}, // CoinGecko ID -> symbol
		{"BTCUSDT", "BTC"}, // Binance pair -> symbol
		{"  eth  ", "ETH"},
		{"solana", "SOL"},
		{"unknown", "UNKNOWN"}, // Unknown symbols are uppercased
		{"", ""},
	}

	for _, tt := range tests {
		t.Run(tt.input, func(t *testing.T) {
			result := mapper.NormalizeSymbol(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestCryptoSymbolMapper_IsCryptoSymbol(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	tests := []struct {
		symbol   string
		expected bool
	}{
		{"BTC", true},
		{"ETH", true},
		{"bitcoin", true}, // CoinGecko ID
		{"BTCUSDT", true}, // Binance pair
		{"btc", true},     // lowercase
		{"AAPL", false},   // stock symbol
		{"MSFT", false},
		{"INVALID", false},
		{"", false},
	}

	for _, tt := range tests {
		t.Run(tt.symbol, func(t *testing.T) {
			result := mapper.IsCryptoSymbol(tt.symbol)
			assert.Equal(t, tt.expected, result)
		})
	}
}

func TestCryptoSymbolMapper_GetAllSymbols(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	symbols := mapper.GetAllSymbols()
	assert.NotEmpty(t, symbols)
	assert.GreaterOrEqual(t, len(symbols), 50) // We mapped 50+ cryptos

	// Check that common symbols are present
	symbolSet := make(map[string]bool)
	for _, s := range symbols {
		symbolSet[s] = true
	}
	assert.True(t, symbolSet["BTC"])
	assert.True(t, symbolSet["ETH"])
	assert.True(t, symbolSet["SOL"])
}

func TestCryptoSymbolMapper_Bidirectional(t *testing.T) {
	mapper := NewCryptoSymbolMapper()

	// Test that all CoinGecko mappings are bidirectional
	for symbol, coinGeckoID := range mapper.toCoinGecko {
		reverseSymbol, ok := mapper.fromCoinGecko[coinGeckoID]
		assert.True(t, ok, "Missing reverse mapping for CoinGecko ID: %s", coinGeckoID)
		assert.Equal(t, symbol, reverseSymbol)
	}

	// Test that all Binance mappings are bidirectional
	for symbol, binancePair := range mapper.toBinance {
		reverseSymbol, ok := mapper.fromBinance[binancePair]
		assert.True(t, ok, "Missing reverse mapping for Binance pair: %s", binancePair)
		assert.Equal(t, symbol, reverseSymbol)
	}
}

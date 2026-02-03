package marketdata

import "strings"

// CryptoSymbolMapper handles symbol translation between different crypto providers.
// Users typically use ticker symbols (BTC, ETH) while providers use different formats:
// - CoinGecko uses IDs: "bitcoin", "ethereum"
// - Binance uses trading pairs: "BTCUSDT", "ETHUSDT"
type CryptoSymbolMapper struct {
	// symbol -> coingecko_id (e.g., "BTC" -> "bitcoin")
	toCoinGecko map[string]string
	// symbol -> binance_pair (e.g., "BTC" -> "BTCUSDT")
	toBinance map[string]string
	// Reverse lookups
	fromCoinGecko map[string]string // "bitcoin" -> "BTC"
	fromBinance   map[string]string // "BTCUSDT" -> "BTC"
}

// NewCryptoSymbolMapper creates a new mapper with predefined mappings for top cryptocurrencies.
func NewCryptoSymbolMapper() *CryptoSymbolMapper {
	m := &CryptoSymbolMapper{
		toCoinGecko:   make(map[string]string),
		toBinance:     make(map[string]string),
		fromCoinGecko: make(map[string]string),
		fromBinance:   make(map[string]string),
	}

	// Define mappings for top 50+ cryptocurrencies
	// Format: symbol, coingecko_id, binance_pair
	mappings := []struct {
		symbol      string
		coingeckoID string
		binancePair string
	}{
		// Top 10 by market cap
		{"BTC", "bitcoin", "BTCUSDT"},
		{"ETH", "ethereum", "ETHUSDT"},
		{"USDT", "tether", ""}, // Stablecoin, no trading pair needed
		{"BNB", "binancecoin", "BNBUSDT"},
		{"SOL", "solana", "SOLUSDT"},
		{"XRP", "ripple", "XRPUSDT"},
		{"USDC", "usd-coin", ""}, // Stablecoin
		{"ADA", "cardano", "ADAUSDT"},
		{"DOGE", "dogecoin", "DOGEUSDT"},
		{"AVAX", "avalanche-2", "AVAXUSDT"},

		// Top 11-25
		{"TRX", "tron", "TRXUSDT"},
		{"DOT", "polkadot", "DOTUSDT"},
		{"LINK", "chainlink", "LINKUSDT"},
		{"MATIC", "matic-network", "MATICUSDT"},
		{"TON", "the-open-network", "TONUSDT"},
		{"SHIB", "shiba-inu", "SHIBUSDT"},
		{"LTC", "litecoin", "LTCUSDT"},
		{"BCH", "bitcoin-cash", "BCHUSDT"},
		{"ATOM", "cosmos", "ATOMUSDT"},
		{"UNI", "uniswap", "UNIUSDT"},
		{"XLM", "stellar", "XLMUSDT"},
		{"ETC", "ethereum-classic", "ETCUSDT"},
		{"XMR", "monero", "XMRUSDT"},
		{"OKB", "okb", "OKBUSDT"},
		{"FIL", "filecoin", "FILUSDT"},

		// Top 26-50
		{"HBAR", "hedera-hashgraph", "HBARUSDT"},
		{"APT", "aptos", "APTUSDT"},
		{"ARB", "arbitrum", "ARBUSDT"},
		{"VET", "vechain", "VETUSDT"},
		{"NEAR", "near", "NEARUSDT"},
		{"OP", "optimism", "OPUSDT"},
		{"MKR", "maker", "MKRUSDT"},
		{"AAVE", "aave", "AAVEUSDT"},
		{"GRT", "the-graph", "GRTUSDT"},
		{"ALGO", "algorand", "ALGOUSDT"},
		{"QNT", "quant-network", "QNTUSDT"},
		{"FTM", "fantom", "FTMUSDT"},
		{"EOS", "eos", "EOSUSDT"},
		{"SAND", "the-sandbox", "SANDUSDT"},
		{"MANA", "decentraland", "MANAUSDT"},
		{"THETA", "theta-token", "THETAUSDT"},
		{"AXS", "axie-infinity", "AXSUSDT"},
		{"EGLD", "elrond-erd-2", "EGLDUSDT"},
		{"XTZ", "tezos", "XTZUSDT"},
		{"IMX", "immutable-x", "IMXUSDT"},
		{"FLOW", "flow", "FLOWUSDT"},
		{"NEO", "neo", "NEOUSDT"},
		{"KAVA", "kava", "KAVAUSDT"},
		{"SNX", "havven", "SNXUSDT"},
		{"RPL", "rocket-pool", "RPLUSDT"},

		// Additional popular tokens
		{"CRV", "curve-dao-token", "CRVUSDT"},
		{"LDO", "lido-dao", "LDOUSDT"},
		{"INJ", "injective-protocol", "INJUSDT"},
		{"RUNE", "thorchain", "RUNEUSDT"},
		{"APE", "apecoin", "APEUSDT"},
		{"CHZ", "chiliz", "CHZUSDT"},
		{"COMP", "compound-governance-token", "COMPUSDT"},
		{"ZEC", "zcash", "ZECUSDT"},
		{"DASH", "dash", "DASHUSDT"},
		{"ENJ", "enjincoin", "ENJUSDT"},
		{"BAT", "basic-attention-token", "BATUSDT"},
		{"ZIL", "zilliqa", "ZILUSDT"},
		{"1INCH", "1inch", "1INCHUSDT"},
		{"CAKE", "pancakeswap-token", "CAKEUSDT"},
		{"SUSHI", "sushi", "SUSHIUSDT"},
		{"YFI", "yearn-finance", "YFIUSDT"},
	}

	for _, mapping := range mappings {
		symbol := strings.ToUpper(mapping.symbol)
		m.toCoinGecko[symbol] = mapping.coingeckoID
		m.fromCoinGecko[mapping.coingeckoID] = symbol

		if mapping.binancePair != "" {
			m.toBinance[symbol] = mapping.binancePair
			m.fromBinance[mapping.binancePair] = symbol
		}
	}

	return m
}

// ToCoinGeckoID converts a ticker symbol to CoinGecko ID.
// Returns the ID and true if found, empty string and false otherwise.
func (m *CryptoSymbolMapper) ToCoinGeckoID(symbol string) (string, bool) {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	id, ok := m.toCoinGecko[symbol]
	return id, ok
}

// ToBinanceSymbol converts a ticker symbol to Binance trading pair.
// Returns the pair and true if found, empty string and false otherwise.
func (m *CryptoSymbolMapper) ToBinanceSymbol(symbol string) (string, bool) {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	pair, ok := m.toBinance[symbol]
	return pair, ok
}

// FromCoinGeckoID converts a CoinGecko ID back to ticker symbol.
func (m *CryptoSymbolMapper) FromCoinGeckoID(id string) (string, bool) {
	id = strings.ToLower(strings.TrimSpace(id))
	symbol, ok := m.fromCoinGecko[id]
	return symbol, ok
}

// FromBinanceSymbol converts a Binance trading pair back to ticker symbol.
func (m *CryptoSymbolMapper) FromBinanceSymbol(pair string) (string, bool) {
	pair = strings.ToUpper(strings.TrimSpace(pair))
	symbol, ok := m.fromBinance[pair]
	return symbol, ok
}

// NormalizeSymbol normalizes a symbol to uppercase ticker format.
// Handles both ticker symbols and provider-specific formats.
func (m *CryptoSymbolMapper) NormalizeSymbol(symbol string) string {
	symbol = strings.TrimSpace(symbol)
	if symbol == "" {
		return ""
	}

	// Try to normalize from CoinGecko ID
	if normalized, ok := m.fromCoinGecko[strings.ToLower(symbol)]; ok {
		return normalized
	}

	// Try to normalize from Binance pair
	if normalized, ok := m.fromBinance[strings.ToUpper(symbol)]; ok {
		return normalized
	}

	// Return uppercase version
	return strings.ToUpper(symbol)
}

// IsCryptoSymbol returns true if the symbol is a known cryptocurrency.
func (m *CryptoSymbolMapper) IsCryptoSymbol(symbol string) bool {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return false
	}

	// Check if it's in our mapping
	if _, ok := m.toCoinGecko[symbol]; ok {
		return true
	}

	// Check if it's a CoinGecko ID
	if _, ok := m.fromCoinGecko[strings.ToLower(symbol)]; ok {
		return true
	}

	// Check if it's a Binance pair
	if _, ok := m.fromBinance[symbol]; ok {
		return true
	}

	return false
}

// GetAllSymbols returns all known crypto ticker symbols.
func (m *CryptoSymbolMapper) GetAllSymbols() []string {
	symbols := make([]string, 0, len(m.toCoinGecko))
	for symbol := range m.toCoinGecko {
		symbols = append(symbols, symbol)
	}
	return symbols
}

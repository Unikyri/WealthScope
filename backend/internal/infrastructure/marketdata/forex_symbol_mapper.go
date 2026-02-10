package marketdata

import (
	"regexp"
	"strings"
)

// ForexSymbolMapper handles symbol normalization and validation for forex currency pairs.
// Forex pairs are represented as BASE/QUOTE (e.g., EUR/USD) where:
// - BASE is the currency being bought/sold
// - QUOTE is the currency used to express the price
type ForexSymbolMapper struct {
	supportedCurrencies map[string]bool
}

// NewForexSymbolMapper creates a new mapper with supported ISO 4217 currency codes.
func NewForexSymbolMapper() *ForexSymbolMapper {
	m := &ForexSymbolMapper{
		supportedCurrencies: make(map[string]bool),
	}

	// Major currencies (G10)
	majorCurrencies := []string{
		"USD", // US Dollar
		"EUR", // Euro
		"GBP", // British Pound
		"JPY", // Japanese Yen
		"CHF", // Swiss Franc
		"CAD", // Canadian Dollar
		"AUD", // Australian Dollar
		"NZD", // New Zealand Dollar
		"SEK", // Swedish Krona
		"NOK", // Norwegian Krone
	}

	// Other important currencies
	otherCurrencies := []string{
		"CNY", // Chinese Yuan
		"HKD", // Hong Kong Dollar
		"SGD", // Singapore Dollar
		"KRW", // South Korean Won
		"INR", // Indian Rupee
		"MXN", // Mexican Peso
		"BRL", // Brazilian Real
		"ZAR", // South African Rand
		"TRY", // Turkish Lira
		"RUB", // Russian Ruble
		"PLN", // Polish Zloty
		"THB", // Thai Baht
		"IDR", // Indonesian Rupiah
		"MYR", // Malaysian Ringgit
		"PHP", // Philippine Peso
		"CZK", // Czech Koruna
		"ILS", // Israeli Shekel
		"CLP", // Chilean Peso
		"COP", // Colombian Peso
		"PEN", // Peruvian Sol
		"ARS", // Argentine Peso
		"DKK", // Danish Krone
		"HUF", // Hungarian Forint
		"RON", // Romanian Leu
		"BGN", // Bulgarian Lev
		"ISK", // Icelandic Krona
		"HRK", // Croatian Kuna
		"AED", // UAE Dirham
		"SAR", // Saudi Riyal
		"TWD", // Taiwan Dollar
		"VND", // Vietnamese Dong
	}

	for _, c := range majorCurrencies {
		m.supportedCurrencies[c] = true
	}
	for _, c := range otherCurrencies {
		m.supportedCurrencies[c] = true
	}

	return m
}

// pairRegex matches various forex pair formats
var pairRegex = regexp.MustCompile(`^([A-Z]{3})[\s/\-_]?([A-Z]{3})$`)

// NormalizeSymbol converts various forex pair formats to a standard format.
// Examples: "EUR/USD" -> "EURUSD", "eur-usd" -> "EURUSD", "EURUSD" -> "EURUSD"
func (m *ForexSymbolMapper) NormalizeSymbol(symbol string) string {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return ""
	}

	// Remove common separators
	symbol = strings.ReplaceAll(symbol, "/", "")
	symbol = strings.ReplaceAll(symbol, "-", "")
	symbol = strings.ReplaceAll(symbol, "_", "")
	symbol = strings.ReplaceAll(symbol, " ", "")

	return symbol
}

// ParsePair extracts base and quote currencies from a forex symbol.
// Returns (base, quote, true) if valid, ("", "", false) otherwise.
func (m *ForexSymbolMapper) ParsePair(symbol string) (base, quote string, ok bool) {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if symbol == "" {
		return "", "", false
	}

	// Try to match with regex (handles EUR/USD, EUR-USD, EUR_USD, EUR USD)
	matches := pairRegex.FindStringSubmatch(symbol)
	if len(matches) == 3 {
		base = matches[1]
		quote = matches[2]
	} else if len(symbol) == 6 {
		// Try direct 6-character format (EURUSD)
		base = symbol[:3]
		quote = symbol[3:]
	} else {
		return "", "", false
	}

	// Validate both currencies
	if !m.supportedCurrencies[base] || !m.supportedCurrencies[quote] {
		return "", "", false
	}

	// Same currency pairs are invalid
	if base == quote {
		return "", "", false
	}

	return base, quote, true
}

// IsForexSymbol returns true if the symbol represents a valid forex pair.
func (m *ForexSymbolMapper) IsForexSymbol(symbol string) bool {
	_, _, ok := m.ParsePair(symbol)
	return ok
}

// FormatPair formats base and quote currencies into standard symbol format.
func (m *ForexSymbolMapper) FormatPair(base, quote string) string {
	return strings.ToUpper(base) + "/" + strings.ToUpper(quote)
}

// GetSupportedCurrencies returns all supported ISO 4217 currency codes.
func (m *ForexSymbolMapper) GetSupportedCurrencies() []string {
	currencies := make([]string, 0, len(m.supportedCurrencies))
	for c := range m.supportedCurrencies {
		currencies = append(currencies, c)
	}
	return currencies
}

// IsSupportedCurrency checks if a currency code is supported.
func (m *ForexSymbolMapper) IsSupportedCurrency(currency string) bool {
	return m.supportedCurrencies[strings.ToUpper(strings.TrimSpace(currency))]
}

// GetMajorPairs returns the most commonly traded forex pairs.
func (m *ForexSymbolMapper) GetMajorPairs() []string {
	return []string{
		"EUR/USD", // Euro / US Dollar
		"USD/JPY", // US Dollar / Japanese Yen
		"GBP/USD", // British Pound / US Dollar
		"USD/CHF", // US Dollar / Swiss Franc
		"AUD/USD", // Australian Dollar / US Dollar
		"USD/CAD", // US Dollar / Canadian Dollar
		"NZD/USD", // New Zealand Dollar / US Dollar
	}
}

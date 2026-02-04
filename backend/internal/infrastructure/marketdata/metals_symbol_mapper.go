package marketdata

import "strings"

// MetalsSymbolMapper handles symbol translation for precious metals.
// Users may use various symbols (GOLD, XAU, GLD) which need to be mapped
// to the standard ISO 4217 codes used by Metals-API (XAU, XAG, XPT, XPD).
type MetalsSymbolMapper struct {
	// User symbol -> API symbol (e.g., "GOLD" -> "XAU")
	toAPISymbol map[string]string
	// API symbol -> standard display name
	toDisplayName map[string]string
	// All known metal symbols for detection
	allSymbols map[string]bool
}

// NewMetalsSymbolMapper creates a new mapper with predefined mappings for precious metals.
func NewMetalsSymbolMapper() *MetalsSymbolMapper {
	m := &MetalsSymbolMapper{
		toAPISymbol:   make(map[string]string),
		toDisplayName: make(map[string]string),
		allSymbols:    make(map[string]bool),
	}

	// Define mappings for precious metals
	// Format: user_symbol -> {api_symbol, display_name}
	mappings := []struct {
		userSymbol  string
		apiSymbol   string
		displayName string
	}{
		// Gold aliases
		{"GOLD", "XAU", "Gold"},
		{"XAU", "XAU", "Gold"},
		{"GLD", "XAU", "Gold"},
		{"XAUUSD", "XAU", "Gold"},

		// Silver aliases
		{"SILVER", "XAG", "Silver"},
		{"XAG", "XAG", "Silver"},
		{"SLV", "XAG", "Silver"},
		{"XAGUSD", "XAG", "Silver"},

		// Platinum aliases
		{"PLATINUM", "XPT", "Platinum"},
		{"XPT", "XPT", "Platinum"},
		{"PLAT", "XPT", "Platinum"},
		{"XPTUSD", "XPT", "Platinum"},

		// Palladium aliases
		{"PALLADIUM", "XPD", "Palladium"},
		{"XPD", "XPD", "Palladium"},
		{"PALL", "XPD", "Palladium"},
		{"XPDUSD", "XPD", "Palladium"},
	}

	for _, mapping := range mappings {
		symbol := strings.ToUpper(mapping.userSymbol)
		m.toAPISymbol[symbol] = mapping.apiSymbol
		m.toDisplayName[mapping.apiSymbol] = mapping.displayName
		m.allSymbols[symbol] = true
	}

	return m
}

// ToAPISymbol converts a user symbol to the Metals-API symbol.
// Returns the API symbol and true if found, empty string and false otherwise.
func (m *MetalsSymbolMapper) ToAPISymbol(symbol string) (string, bool) {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	apiSymbol, ok := m.toAPISymbol[symbol]
	return apiSymbol, ok
}

// ToDisplaySymbol returns the display name for an API symbol.
// Returns the API symbol itself if no display name is found.
func (m *MetalsSymbolMapper) ToDisplaySymbol(apiSymbol string) string {
	apiSymbol = strings.ToUpper(strings.TrimSpace(apiSymbol))
	if name, ok := m.toDisplayName[apiSymbol]; ok {
		return name
	}
	return apiSymbol
}

// IsMetalSymbol returns true if the symbol represents a precious metal.
func (m *MetalsSymbolMapper) IsMetalSymbol(symbol string) bool {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	return m.allSymbols[symbol]
}

// GetAllSymbols returns all known user symbols.
func (m *MetalsSymbolMapper) GetAllSymbols() []string {
	symbols := make([]string, 0, len(m.allSymbols))
	for symbol := range m.allSymbols {
		symbols = append(symbols, symbol)
	}
	return symbols
}

// GetMetalName returns the human-readable name for a metal symbol.
func (m *MetalsSymbolMapper) GetMetalName(symbol string) string {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if apiSymbol, ok := m.toAPISymbol[symbol]; ok {
		if name, ok := m.toDisplayName[apiSymbol]; ok {
			return name
		}
	}
	return ""
}

// GetAPIsymbols returns the list of API symbols (XAU, XAG, XPT, XPD).
func (m *MetalsSymbolMapper) GetAPISymbols() []string {
	seen := make(map[string]bool)
	symbols := make([]string, 0, 4)
	for _, apiSymbol := range m.toAPISymbol {
		if !seen[apiSymbol] {
			seen[apiSymbol] = true
			symbols = append(symbols, apiSymbol)
		}
	}
	return symbols
}

// NormalizeSymbol normalizes a symbol to the standard API format.
// Returns the API symbol if recognized, or the uppercase input otherwise.
func (m *MetalsSymbolMapper) NormalizeSymbol(symbol string) string {
	symbol = strings.ToUpper(strings.TrimSpace(symbol))
	if apiSymbol, ok := m.toAPISymbol[symbol]; ok {
		return apiSymbol
	}
	return symbol
}

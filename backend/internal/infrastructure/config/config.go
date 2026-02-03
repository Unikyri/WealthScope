package config

import (
	"log"
	"strings"

	"github.com/spf13/viper"
)

// Config holds all configuration for the application
//
//nolint:govet // fieldalignment: keep grouped sub-configs for readability
type Config struct {
	Pricing    PricingConfig
	MarketData MarketDataConfig
	Database   DatabaseConfig
	Server     ServerConfig
	Log        LogConfig
	Supabase   SupabaseConfig
}

// ServerConfig holds server-specific configuration
type ServerConfig struct {
	Port string
	Mode string // debug, release, test
}

// DatabaseConfig holds database configuration
type DatabaseConfig struct {
	URL string
}

// PricingConfig holds pricing/market data configuration
type PricingConfig struct {
	UpdateIntervalSeconds int
}

// MarketDataConfig holds multi-provider market data API keys, enabled flags, and rate limits.
// If a provider is disabled or has no key (where required), it is not registered.
// Yahoo can be enabled without a key (public endpoint).
//
//nolint:govet // fieldalignment: keep grouped by provider for readability
type MarketDataConfig struct {
	// Alpha Vantage (equities)
	AlphaVantageAPIKey    string
	AlphaVantageEnabled   bool
	AlphaVantageRateLimit int // requests per minute

	// Finnhub (equities)
	FinnhubAPIKey    string
	FinnhubEnabled   bool
	FinnhubRateLimit int // requests per minute

	// Yahoo Finance (equities)
	YahooFinanceAPIKey  string
	YahooFinanceEnabled bool
	YahooRateLimit      int // requests per minute

	// CoinGecko (crypto)
	CoinGeckoAPIKey    string
	CoinGeckoEnabled   bool
	CoinGeckoRateLimit int // requests per minute

	// Binance (crypto)
	BinanceEnabled   bool
	BinanceRateLimit int // requests per minute

	// Frankfurter (forex - no API key required)
	FrankfurterEnabled   bool
	FrankfurterRateLimit int // requests per minute

	// ExchangeRate API (forex)
	ExchangeRateAPIKey    string
	ExchangeRateEnabled   bool
	ExchangeRateRateLimit int // requests per minute

	// Metals-API (precious metals - gold, silver, platinum, palladium)
	MetalsAPIKey       string
	MetalsAPIEnabled   bool
	MetalsAPIRateLimit int // requests per minute

	// Cache settings
	CacheTTLSeconds int
}

// SupabaseConfig holds Supabase configuration
type SupabaseConfig struct {
	URL        string
	AnonKey    string
	ServiceKey string
	JWTSecret  string
}

// LogConfig holds logging configuration
type LogConfig struct {
	Level string
}

// Load reads configuration from environment variables
func Load() *Config {
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

	viper.SetConfigFile(".env")
	viper.AddConfigPath(".")
	viper.SetConfigType("env")

	err := viper.ReadInConfig()
	if err != nil {
		// Advertencia suave si no existe el archivo (para producción con variables de entorno reales)
		log.Printf("Advertencia al leer config: %v (usando variables de entorno)", err)
	}

	// Set defaults (Usando las claves tipo ENV para consistencia)
	viper.SetDefault("SERVER_PORT", "8080")
	viper.SetDefault("SERVER_MODE", "debug")
	viper.SetDefault("DATABASE_URL", "")
	viper.SetDefault("PRICING_UPDATE_INTERVAL_SECONDS", 300)
	viper.SetDefault("MARKETDATA_ALPHA_VANTAGE_API_KEY", "")
	viper.SetDefault("MARKETDATA_ALPHA_VANTAGE_ENABLED", false)
	viper.SetDefault("MARKETDATA_ALPHA_VANTAGE_RATE_LIMIT", 5) // 5 req/min (conservative for 25/day free tier)
	viper.SetDefault("MARKETDATA_FINNHUB_API_KEY", "")
	viper.SetDefault("MARKETDATA_FINNHUB_ENABLED", false)
	viper.SetDefault("MARKETDATA_FINNHUB_RATE_LIMIT", 60) // 60 req/min free tier
	viper.SetDefault("MARKETDATA_YAHOO_FINANCE_API_KEY", "")
	viper.SetDefault("MARKETDATA_YAHOO_FINANCE_ENABLED", true)
	viper.SetDefault("MARKETDATA_YAHOO_RATE_LIMIT", 100)      // conservative limit
	viper.SetDefault("MARKETDATA_COINGECKO_API_KEY", "")      // optional for free tier
	viper.SetDefault("MARKETDATA_COINGECKO_ENABLED", true)    // enable crypto by default
	viper.SetDefault("MARKETDATA_COINGECKO_RATE_LIMIT", 10)   // 10-30 req/min free tier
	viper.SetDefault("MARKETDATA_BINANCE_ENABLED", true)      // enable crypto by default
	viper.SetDefault("MARKETDATA_BINANCE_RATE_LIMIT", 100)    // conservative for 1200/min limit
	viper.SetDefault("MARKETDATA_FRANKFURTER_ENABLED", true)  // enable forex by default
	viper.SetDefault("MARKETDATA_FRANKFURTER_RATE_LIMIT", 30) // no official limit, be conservative
	viper.SetDefault("MARKETDATA_EXCHANGERATE_API_KEY", "")   // optional for free tier
	viper.SetDefault("MARKETDATA_EXCHANGERATE_ENABLED", true) // enable forex by default
	viper.SetDefault("MARKETDATA_EXCHANGERATE_RATE_LIMIT", 5) // conservative for 1500/month limit
	viper.SetDefault("MARKETDATA_METALS_API_KEY", "")         // required for metals
	viper.SetDefault("MARKETDATA_METALS_API_ENABLED", false)  // disabled by default (requires API key)
	viper.SetDefault("MARKETDATA_METALS_API_RATE_LIMIT", 3)   // very conservative for 100/month free tier
	viper.SetDefault("MARKETDATA_CACHE_TTL_SECONDS", 60)      // 1 minute cache
	viper.SetDefault("SUPABASE_URL", "")
	viper.SetDefault("SUPABASE_ANON_KEY", "")
	viper.SetDefault("SUPABASE_SERVICE_KEY", "")
	viper.SetDefault("SUPABASE_JWT_SECRET", "")
	viper.SetDefault("LOG_LEVEL", "info")

	return &Config{
		Server: ServerConfig{
			// CAMBIO: Usar claves en mayúsculas que coinciden con el .env
			Port: viper.GetString("SERVER_PORT"),
			Mode: viper.GetString("SERVER_MODE"),
		},
		Database: DatabaseConfig{
			URL: viper.GetString("DATABASE_URL"),
		},
		Pricing: PricingConfig{
			UpdateIntervalSeconds: viper.GetInt("PRICING_UPDATE_INTERVAL_SECONDS"),
		},
		MarketData: MarketDataConfig{
			AlphaVantageAPIKey:    viper.GetString("MARKETDATA_ALPHA_VANTAGE_API_KEY"),
			AlphaVantageEnabled:   viper.GetBool("MARKETDATA_ALPHA_VANTAGE_ENABLED"),
			AlphaVantageRateLimit: viper.GetInt("MARKETDATA_ALPHA_VANTAGE_RATE_LIMIT"),
			FinnhubAPIKey:         viper.GetString("MARKETDATA_FINNHUB_API_KEY"),
			FinnhubEnabled:        viper.GetBool("MARKETDATA_FINNHUB_ENABLED"),
			FinnhubRateLimit:      viper.GetInt("MARKETDATA_FINNHUB_RATE_LIMIT"),
			YahooFinanceAPIKey:    viper.GetString("MARKETDATA_YAHOO_FINANCE_API_KEY"),
			YahooFinanceEnabled:   viper.GetBool("MARKETDATA_YAHOO_FINANCE_ENABLED"),
			YahooRateLimit:        viper.GetInt("MARKETDATA_YAHOO_RATE_LIMIT"),
			CoinGeckoAPIKey:       viper.GetString("MARKETDATA_COINGECKO_API_KEY"),
			CoinGeckoEnabled:      viper.GetBool("MARKETDATA_COINGECKO_ENABLED"),
			CoinGeckoRateLimit:    viper.GetInt("MARKETDATA_COINGECKO_RATE_LIMIT"),
			BinanceEnabled:        viper.GetBool("MARKETDATA_BINANCE_ENABLED"),
			BinanceRateLimit:      viper.GetInt("MARKETDATA_BINANCE_RATE_LIMIT"),
			FrankfurterEnabled:    viper.GetBool("MARKETDATA_FRANKFURTER_ENABLED"),
			FrankfurterRateLimit:  viper.GetInt("MARKETDATA_FRANKFURTER_RATE_LIMIT"),
			ExchangeRateAPIKey:    viper.GetString("MARKETDATA_EXCHANGERATE_API_KEY"),
			ExchangeRateEnabled:   viper.GetBool("MARKETDATA_EXCHANGERATE_ENABLED"),
			ExchangeRateRateLimit: viper.GetInt("MARKETDATA_EXCHANGERATE_RATE_LIMIT"),
			MetalsAPIKey:          viper.GetString("MARKETDATA_METALS_API_KEY"),
			MetalsAPIEnabled:      viper.GetBool("MARKETDATA_METALS_API_ENABLED"),
			MetalsAPIRateLimit:    viper.GetInt("MARKETDATA_METALS_API_RATE_LIMIT"),
			CacheTTLSeconds:       viper.GetInt("MARKETDATA_CACHE_TTL_SECONDS"),
		},
		Supabase: SupabaseConfig{
			URL:        viper.GetString("SUPABASE_URL"),
			AnonKey:    viper.GetString("SUPABASE_ANON_KEY"),
			ServiceKey: viper.GetString("SUPABASE_SERVICE_KEY"),
			JWTSecret:  viper.GetString("SUPABASE_JWT_SECRET"),
		},
		Log: LogConfig{
			Level: viper.GetString("LOG_LEVEL"),
		},
	}
}

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
	// Alpha Vantage
	AlphaVantageAPIKey    string
	AlphaVantageEnabled   bool
	AlphaVantageRateLimit int // requests per minute

	// Finnhub
	FinnhubAPIKey    string
	FinnhubEnabled   bool
	FinnhubRateLimit int // requests per minute

	// Yahoo Finance
	YahooFinanceAPIKey  string
	YahooFinanceEnabled bool
	YahooRateLimit      int // requests per minute

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
	viper.SetDefault("MARKETDATA_YAHOO_RATE_LIMIT", 100) // conservative limit
	viper.SetDefault("MARKETDATA_CACHE_TTL_SECONDS", 60) // 1 minute cache
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

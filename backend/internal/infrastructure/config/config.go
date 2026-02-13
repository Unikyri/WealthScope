package config

import (
	"log"
	"strings"

	"github.com/spf13/viper"
)

// Config holds all configuration for the application
type Config struct {
	Supabase   SupabaseConfig
	Server     ServerConfig
	Database   DatabaseConfig
	Log        LogConfig
	AI         AIConfig
	News       NewsConfig
	MarketData MarketDataConfig
	Pricing    PricingConfig
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
	// MetalsUpdateIntervalHours controls how often metals prices are updated.
	// Set to 0 to use the default interval. Default: 12 hours (to save API quota).
	// MetalPriceAPI free tier only allows ~50 requests/month.
	MetalsUpdateIntervalHours int
}

// MarketDataConfig holds multi-provider market data API keys, enabled flags, and rate limits.
// If a provider is disabled or has no key (where required), it is not registered.
// Yahoo can be enabled without a key (public endpoint).
type MarketDataConfig struct {
	YahooFinanceAPIKey    string
	MetalsAPIKey          string
	ExchangeRateAPIKey    string
	FinnhubAPIKey         string
	AlphaVantageAPIKey    string
	CoinGeckoAPIKey       string
	FREDAPIKey            string
	RentCastAPIKey        string
	FrankfurterRateLimit  int
	AlphaVantageRateLimit int
	YahooRateLimit        int
	FinnhubRateLimit      int
	CacheTTLSeconds       int
	CoinGeckoRateLimit    int
	MetalsAPIRateLimit    int
	BinanceRateLimit      int
	ExchangeRateRateLimit int
	FREDRateLimit         int
	RentCastRateLimit     int
	RentCastMonthlyQuota  int
	FinnhubEnabled        bool
	YahooFinanceEnabled   bool
	ExchangeRateEnabled   bool
	FrankfurterEnabled    bool
	AlphaVantageEnabled   bool
	MetalsAPIEnabled      bool
	BinanceEnabled        bool
	CoinGeckoEnabled      bool
	FREDEnabled           bool
	RentCastEnabled       bool
}

// NewsConfig holds news provider configuration
type NewsConfig struct {
	NewsDataAPIKey      string
	MarketauxAPIKey     string
	NewsDataRateLimit   int
	MarketauxRateLimit  int
	NewsCacheTTLSeconds int
	NewsDataEnabled     bool
	MarketauxEnabled    bool
}

// AIConfig holds AI provider configuration (Google Gemini)
type AIConfig struct {
	GeminiAPIKey       string
	GeminiModel        string
	GeminiEnabled      bool
	GeminiRateLimit    int // requests per minute
	MaxConversations   int // max conversations per user
	MaxMessagesPerConv int // max messages per conversation
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

	// Bind alternative env var names for news APIs (Railway uses NEWSDATA_API_KEY,
	// code uses NEWS_NEWSDATA_API_KEY). BindEnv accepts both formats.
	_ = viper.BindEnv("NEWS_NEWSDATA_API_KEY", "NEWS_NEWSDATA_API_KEY", "NEWSDATA_API_KEY")
	_ = viper.BindEnv("NEWS_MARKETAUX_API_KEY", "NEWS_MARKETAUX_API_KEY", "MARKETAUX_API_KEY")

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
	viper.SetDefault("PRICING_METALS_UPDATE_INTERVAL_HOURS", 12) // 12 hours for metals (limited API quota)
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
	viper.SetDefault("MARKETDATA_METALS_API_RATE_LIMIT", 2)   // very conservative for 50/month free tier
	viper.SetDefault("MARKETDATA_FRED_API_KEY", "")           // required for bond yields
	viper.SetDefault("MARKETDATA_FRED_ENABLED", false)        // disabled by default (requires API key)
	viper.SetDefault("MARKETDATA_FRED_RATE_LIMIT", 60)        // 120 req/min free tier
	viper.SetDefault("MARKETDATA_RENTCAST_API_KEY", "")       // required for real estate data
	viper.SetDefault("MARKETDATA_RENTCAST_ENABLED", false)    // disabled by default (requires API key)
	viper.SetDefault("MARKETDATA_RENTCAST_RATE_LIMIT", 1)     // very conservative
	viper.SetDefault("MARKETDATA_RENTCAST_MONTHLY_QUOTA", 45) // hard limit on free tier
	viper.SetDefault("MARKETDATA_CACHE_TTL_SECONDS", 60)      // 1 minute cache
	viper.SetDefault("NEWS_NEWSDATA_API_KEY", "")             // required for news
	viper.SetDefault("NEWS_NEWSDATA_ENABLED", true)           // enable news by default
	viper.SetDefault("NEWS_NEWSDATA_RATE_LIMIT", 10)          // 200/day free tier
	viper.SetDefault("NEWS_MARKETAUX_API_KEY", "")            // required for news
	viper.SetDefault("NEWS_MARKETAUX_ENABLED", true)          // enable news by default
	viper.SetDefault("NEWS_MARKETAUX_RATE_LIMIT", 5)          // 100/day free tier
	viper.SetDefault("NEWS_CACHE_TTL_SECONDS", 300)           // 5 minute cache for news
	viper.SetDefault("GEMINI_API_KEY", "")                    // required for AI features
	viper.SetDefault("GEMINI_MODEL", "gemini-3-flash-preview")
	viper.SetDefault("GEMINI_ENABLED", true)              // enable AI by default
	viper.SetDefault("GEMINI_RATE_LIMIT", 30)             // 30 req/min
	viper.SetDefault("GEMINI_MAX_CONVERSATIONS", 50)      // max conversations per user
	viper.SetDefault("GEMINI_MAX_MESSAGES_PER_CONV", 100) // max messages per conversation
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
			UpdateIntervalSeconds:     viper.GetInt("PRICING_UPDATE_INTERVAL_SECONDS"),
			MetalsUpdateIntervalHours: viper.GetInt("PRICING_METALS_UPDATE_INTERVAL_HOURS"),
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
			FREDAPIKey:            viper.GetString("MARKETDATA_FRED_API_KEY"),
			FREDEnabled:           viper.GetBool("MARKETDATA_FRED_ENABLED"),
			FREDRateLimit:         viper.GetInt("MARKETDATA_FRED_RATE_LIMIT"),
			RentCastAPIKey:        viper.GetString("MARKETDATA_RENTCAST_API_KEY"),
			RentCastEnabled:       viper.GetBool("MARKETDATA_RENTCAST_ENABLED"),
			RentCastRateLimit:     viper.GetInt("MARKETDATA_RENTCAST_RATE_LIMIT"),
			RentCastMonthlyQuota:  viper.GetInt("MARKETDATA_RENTCAST_MONTHLY_QUOTA"),
			CacheTTLSeconds:       viper.GetInt("MARKETDATA_CACHE_TTL_SECONDS"),
		},
		News: NewsConfig{
			NewsDataAPIKey:      viper.GetString("NEWS_NEWSDATA_API_KEY"),
			NewsDataEnabled:     viper.GetBool("NEWS_NEWSDATA_ENABLED"),
			NewsDataRateLimit:   viper.GetInt("NEWS_NEWSDATA_RATE_LIMIT"),
			MarketauxAPIKey:     viper.GetString("NEWS_MARKETAUX_API_KEY"),
			MarketauxEnabled:    viper.GetBool("NEWS_MARKETAUX_ENABLED"),
			MarketauxRateLimit:  viper.GetInt("NEWS_MARKETAUX_RATE_LIMIT"),
			NewsCacheTTLSeconds: viper.GetInt("NEWS_CACHE_TTL_SECONDS"),
		},
		AI: AIConfig{
			GeminiAPIKey:       viper.GetString("GEMINI_API_KEY"),
			GeminiModel:        viper.GetString("GEMINI_MODEL"),
			GeminiEnabled:      viper.GetBool("GEMINI_ENABLED"),
			GeminiRateLimit:    viper.GetInt("GEMINI_RATE_LIMIT"),
			MaxConversations:   viper.GetInt("GEMINI_MAX_CONVERSATIONS"),
			MaxMessagesPerConv: viper.GetInt("GEMINI_MAX_MESSAGES_PER_CONV"),
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

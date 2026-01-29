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
	Pricing  PricingConfig
	Database DatabaseConfig
	Server   ServerConfig
	Log      LogConfig
	Supabase SupabaseConfig
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

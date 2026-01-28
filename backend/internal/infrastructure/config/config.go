package config

import (
	"strings"

	"github.com/spf13/viper"
)

// Config holds all configuration for the application
type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
	Pricing  PricingConfig
	Supabase SupabaseConfig
	Log      LogConfig
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

	// Set defaults
	viper.SetDefault("server.port", "8080")
	viper.SetDefault("server.mode", "debug")
	viper.SetDefault("database.url", "")
	viper.SetDefault("pricing.update_interval_seconds", 300)
	viper.SetDefault("supabase.url", "")
	viper.SetDefault("supabase.anon_key", "")
	viper.SetDefault("supabase.service_key", "")
	viper.SetDefault("supabase.jwt_secret", "")
	viper.SetDefault("log.level", "info")

	return &Config{
		Server: ServerConfig{
			Port: viper.GetString("server.port"),
			Mode: viper.GetString("server.mode"),
		},
		Database: DatabaseConfig{
			URL: viper.GetString("database.url"),
		},
		Pricing: PricingConfig{
			UpdateIntervalSeconds: viper.GetInt("pricing.update_interval_seconds"),
		},
		Supabase: SupabaseConfig{
			URL:        viper.GetString("supabase.url"),
			AnonKey:    viper.GetString("supabase.anon_key"),
			ServiceKey: viper.GetString("supabase.service_key"),
			JWTSecret:  viper.GetString("supabase.jwt_secret"),
		},
		Log: LogConfig{
			Level: viper.GetString("log.level"),
		},
	}
}

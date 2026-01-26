package config

import (
	"strings"

	"github.com/spf13/viper"
)

// Config holds all configuration for the application
type Config struct {
	Server   ServerConfig
	Database DatabaseConfig
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
	viper.SetDefault("log.level", "info")

	return &Config{
		Server: ServerConfig{
			Port: viper.GetString("server.port"),
			Mode: viper.GetString("server.mode"),
		},
		Database: DatabaseConfig{
			URL: viper.GetString("database.url"),
		},
		Log: LogConfig{
			Level: viper.GetString("log.level"),
		},
	}
}

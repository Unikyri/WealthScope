package services

import (
	"context"
	"time"
)

// AssetCategory represents the market category for provider selection (equity, crypto, forex, metal).
type AssetCategory string

const (
	CategoryEquity AssetCategory = "equity"
	CategoryCrypto AssetCategory = "crypto"
	CategoryForex  AssetCategory = "forex"
	CategoryMetal  AssetCategory = "metal"
)

// Quote is the domain DTO for a price snapshot of a symbol.
// Source is set by the registry to the provider name that returned the quote (e.g. "yahoo_finance").
//
//nolint:govet // fieldalignment: readability over micro-optimization for DTO
type Quote struct {
	Symbol        string    `json:"symbol"`
	MarketState   string    `json:"market_state,omitempty"`
	Currency      string    `json:"currency,omitempty"`
	Price         float64   `json:"price"`
	Change        float64   `json:"change"`
	ChangePercent float64   `json:"change_percent"`
	UpdatedAt     time.Time `json:"updated_at"`
	Source        string    `json:"source,omitempty"` // provider name, set by registry
}

// PricePoint is an OHLCV data point for historical series.
//
//nolint:govet // fieldalignment: readability over micro-optimization for DTO
type PricePoint struct {
	Timestamp time.Time
	Open      float64
	High      float64
	Low       float64
	Close     float64
	Volume    int64
}

// MarketDataClient is the interface for market data providers (Yahoo, Alpha Vantage, Finnhub, etc.).
// Implementations are in infrastructure; the registry uses this interface for fallback.
type MarketDataClient interface {
	GetQuote(ctx context.Context, symbol string) (*Quote, error)
	GetQuotes(ctx context.Context, symbols []string) (map[string]*Quote, error)
	GetHistoricalPrices(ctx context.Context, symbol string, from, to time.Time) ([]PricePoint, error)
	SupportsSymbol(symbol string) bool
	Name() string
}

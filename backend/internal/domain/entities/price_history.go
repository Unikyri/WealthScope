package entities

import "time"

// PriceHistory represents a single recorded price observation.
//
//nolint:govet // fieldalignment: readability over micro-optimization for DTO
type PriceHistory struct {
	RecordedAt    time.Time `json:"recorded_at"`
	Symbol        string    `json:"symbol"`
	MarketState   string    `json:"market_state,omitempty"`
	Source        string    `json:"source,omitempty"`
	Price         float64   `json:"price"`
	ChangeAmount  float64   `json:"change_amount,omitempty"`
	ChangePercent float64   `json:"change_percent,omitempty"`
}

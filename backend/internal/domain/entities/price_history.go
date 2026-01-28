package entities

import "time"

// PriceHistory represents a single recorded price observation.
type PriceHistory struct {
	Symbol        string    `json:"symbol"`
	Price         float64   `json:"price"`
	ChangeAmount  float64   `json:"change_amount,omitempty"`
	ChangePercent float64   `json:"change_percent,omitempty"`
	MarketState   string    `json:"market_state,omitempty"`
	RecordedAt    time.Time `json:"recorded_at"`
	Source        string    `json:"source,omitempty"`
}

package services

import (
	"context"
	"time"
)

// NewsClient is the interface for news data providers (NewsData.io, Marketaux).
// Implementations are in infrastructure; the NewsService uses this interface for fallback.
type NewsClient interface {
	// GetNews retrieves news articles based on the query parameters.
	GetNews(ctx context.Context, query NewsQuery) ([]NewsArticle, error)

	// GetNewsBySymbol retrieves news articles for a specific stock symbol.
	GetNewsBySymbol(ctx context.Context, symbol string, limit int) ([]NewsArticle, error)

	// Name returns the provider name (e.g., "newsdata", "marketaux").
	Name() string
}

// NewsQuery represents the query parameters for news retrieval.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NewsQuery struct {
	Keywords string
	Language string
	Symbols  []string
	Limit    int
	Page     int
}

// NewsArticle represents a news article from any provider.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NewsArticle struct {
	PublishedAt time.Time `json:"published_at"`
	ID          string    `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Content     string    `json:"content,omitempty"`
	URL         string    `json:"url"`
	ImageURL    string    `json:"image_url,omitempty"`
	Source      string    `json:"source"`
	Provider    string    `json:"provider"`
	Symbols     []string  `json:"symbols,omitempty"`
	Sentiment   float64   `json:"sentiment,omitempty"`
}

// NewsResponse represents the paginated response for news queries.
type NewsResponse struct {
	Articles []NewsArticle `json:"articles"`
	Total    int           `json:"total"`
	Page     int           `json:"page"`
	Limit    int           `json:"limit"`
}

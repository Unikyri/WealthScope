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
	Symbols  []string // Filter by stock symbols (e.g., AAPL, TSLA)
	Keywords string   // Search keywords
	Language string   // Language filter (e.g., "en", "es")
	Limit    int      // Max articles to return
	Page     int      // Pagination page number
}

// NewsArticle represents a news article from any provider.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NewsArticle struct {
	ID          string    `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Content     string    `json:"content,omitempty"`
	URL         string    `json:"url"`
	ImageURL    string    `json:"image_url,omitempty"`
	Source      string    `json:"source"`
	PublishedAt time.Time `json:"published_at"`
	Symbols     []string  `json:"symbols,omitempty"`
	Sentiment   float64   `json:"sentiment,omitempty"` // -1 (negative) to +1 (positive)
	Provider    string    `json:"provider"`
}

// NewsResponse represents the paginated response for news queries.
type NewsResponse struct {
	Articles []NewsArticle `json:"articles"`
	Total    int           `json:"total"`
	Page     int           `json:"page"`
	Limit    int           `json:"limit"`
}

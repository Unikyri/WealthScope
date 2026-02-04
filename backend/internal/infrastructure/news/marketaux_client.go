package news

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

const (
	marketauxBaseURL        = "https://api.marketaux.com/v1/news/all"
	marketauxDefaultTimeout = 15 * time.Second
)

// MarketauxClient implements services.NewsClient for Marketaux API.
// Marketaux provides financial news with entity recognition and sentiment analysis.
// Free tier: 100 requests/day, 3 articles/request.
// Docs: https://marketaux.com/documentation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type MarketauxClient struct {
	httpClient  *http.Client
	apiKey      string
	baseURL     string
	rateLimiter *marketdata.RateLimiter
}

// NewMarketauxClient creates a new Marketaux client.
func NewMarketauxClient(apiKey string, rateLimiter *marketdata.RateLimiter) *MarketauxClient {
	return &MarketauxClient{
		httpClient: &http.Client{
			Timeout: marketauxDefaultTimeout,
		},
		apiKey:      apiKey,
		baseURL:     marketauxBaseURL,
		rateLimiter: rateLimiter,
	}
}

// marketauxResponse represents the API response from Marketaux.
//
//nolint:govet // fieldalignment: keep JSON field order
type marketauxResponse struct {
	Meta struct {
		Found    int `json:"found"`
		Returned int `json:"returned"`
		Limit    int `json:"limit"`
		Page     int `json:"page"`
	} `json:"meta"`
	Data []marketauxArticle `json:"data"`
}

// marketauxArticle represents a single article from Marketaux.
//
//nolint:govet // fieldalignment: keep JSON field order
type marketauxArticle struct {
	UUID           string             `json:"uuid"`
	Title          string             `json:"title"`
	Description    string             `json:"description"`
	Keywords       string             `json:"keywords"`
	Snippet        string             `json:"snippet"`
	URL            string             `json:"url"`
	ImageURL       string             `json:"image_url"`
	Language       string             `json:"language"`
	PublishedAt    string             `json:"published_at"`
	Source         string             `json:"source"`
	RelevanceScore float64            `json:"relevance_score"`
	Entities       []marketauxEntity  `json:"entities"`
	Similar        []marketauxArticle `json:"similar"`
}

// marketauxEntity represents an entity identified in an article.
//
//nolint:govet // fieldalignment: keep JSON field order
type marketauxEntity struct {
	Symbol         string               `json:"symbol"`
	Name           string               `json:"name"`
	Exchange       string               `json:"exchange"`
	ExchangeLong   string               `json:"exchange_long"`
	Country        string               `json:"country"`
	Type           string               `json:"type"`
	Industry       string               `json:"industry"`
	MatchScore     float64              `json:"match_score"`
	SentimentScore float64              `json:"sentiment_score"`
	Highlights     []marketauxHighlight `json:"highlights"`
}

// marketauxHighlight represents a text highlight for an entity.
//
//nolint:govet // fieldalignment: keep JSON field order
type marketauxHighlight struct {
	Highlight     string  `json:"highlight"`
	Sentiment     float64 `json:"sentiment"`
	HighlightedIn string  `json:"highlighted_in"`
}

// GetNews retrieves news articles based on the query parameters.
func (c *MarketauxClient) GetNews(ctx context.Context, query services.NewsQuery) ([]services.NewsArticle, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("marketaux: rate limit wait: %w", err)
		}
	}

	// Build URL
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("marketaux: parse base URL: %w", err)
	}

	q := u.Query()
	q.Set("api_token", c.apiKey)

	// Apply symbol filtering (Marketaux's primary strength)
	if len(query.Symbols) > 0 {
		q.Set("symbols", strings.Join(query.Symbols, ","))
		q.Set("filter_entities", "true")
	}

	// Apply keyword search
	if query.Keywords != "" {
		q.Set("search", query.Keywords)
	}

	// Apply language filter
	if query.Language != "" {
		q.Set("language", query.Language)
	}

	// Only return articles with entities (stocks mentioned)
	q.Set("must_have_entities", "true")

	// Limit (max 3 for free tier)
	limit := query.Limit
	if limit <= 0 || limit > 50 {
		limit = 10
	}
	q.Set("limit", fmt.Sprintf("%d", limit))

	// Pagination
	if query.Page > 0 {
		q.Set("page", fmt.Sprintf("%d", query.Page))
	}

	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("marketaux: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("marketaux: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("marketaux: unexpected status %d", resp.StatusCode)
	}

	var result marketauxResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("marketaux: decode response: %w", err)
	}

	// Convert to domain articles
	articles := make([]services.NewsArticle, 0, len(result.Data))
	for _, r := range result.Data {
		article := c.toNewsArticle(r)
		articles = append(articles, article)
	}

	return articles, nil
}

// GetNewsBySymbol retrieves news articles for a specific stock symbol.
func (c *MarketauxClient) GetNewsBySymbol(ctx context.Context, symbol string, limit int) ([]services.NewsArticle, error) {
	return c.GetNews(ctx, services.NewsQuery{
		Symbols:  []string{symbol},
		Limit:    limit,
		Language: "en",
	})
}

// Name returns the provider name.
func (c *MarketauxClient) Name() string {
	return "marketaux"
}

// toNewsArticle converts a Marketaux article to a domain NewsArticle.
func (c *MarketauxClient) toNewsArticle(r marketauxArticle) services.NewsArticle {
	// Parse publication date
	pubDate, _ := time.Parse(time.RFC3339, r.PublishedAt)
	if pubDate.IsZero() {
		// Try alternative format
		pubDate, _ = time.Parse("2006-01-02T15:04:05.000000Z", r.PublishedAt)
	}
	if pubDate.IsZero() {
		pubDate = time.Now().UTC()
	}

	// Extract symbols and calculate average sentiment from entities
	var symbols []string
	var totalSentiment float64
	sentimentCount := 0

	for _, entity := range r.Entities {
		if entity.Symbol != "" {
			symbols = append(symbols, entity.Symbol)
		}
		if entity.SentimentScore != 0 {
			totalSentiment += entity.SentimentScore
			sentimentCount++
		}
	}

	// Calculate average sentiment
	var avgSentiment float64
	if sentimentCount > 0 {
		avgSentiment = totalSentiment / float64(sentimentCount)
	}

	// Use snippet as content if description is empty
	content := r.Description
	if content == "" {
		content = r.Snippet
	}

	return services.NewsArticle{
		ID:          r.UUID,
		Title:       r.Title,
		Description: r.Description,
		Content:     content,
		URL:         r.URL,
		ImageURL:    r.ImageURL,
		Source:      r.Source,
		PublishedAt: pubDate,
		Symbols:     symbols,
		Sentiment:   avgSentiment,
		Provider:    c.Name(),
	}
}

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
	newsDataBaseURL        = "https://newsdata.io/api/1/latest"
	newsDataDefaultTimeout = 15 * time.Second
)

// NewsDataClient implements services.NewsClient for NewsData.io API.
// NewsData.io provides general news with business category filtering.
// Free tier: 200 requests/day, 10 articles/request.
// Docs: https://newsdata.io/documentation
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NewsDataClient struct {
	httpClient  *http.Client
	apiKey      string
	baseURL     string
	rateLimiter *marketdata.RateLimiter
}

// NewNewsDataClient creates a new NewsData.io client.
func NewNewsDataClient(apiKey string, rateLimiter *marketdata.RateLimiter) *NewsDataClient {
	return &NewsDataClient{
		httpClient: &http.Client{
			Timeout: newsDataDefaultTimeout,
		},
		apiKey:      apiKey,
		baseURL:     newsDataBaseURL,
		rateLimiter: rateLimiter,
	}
}

// newsDataResponse represents the API response from NewsData.io.
//
//nolint:govet // fieldalignment: keep JSON field order
type newsDataResponse struct {
	Status       string            `json:"status"`
	TotalResults int               `json:"totalResults"`
	Results      []newsDataArticle `json:"results"`
	NextPage     string            `json:"nextPage,omitempty"`
}

// newsDataArticle represents a single article from NewsData.io.
type newsDataArticle struct {
	ArticleID   string   `json:"article_id"`
	Title       string   `json:"title"`
	Link        string   `json:"link"`
	Keywords    []string `json:"keywords"`
	Creator     []string `json:"creator"`
	Description string   `json:"description"`
	Content     string   `json:"content"`
	PubDate     string   `json:"pubDate"`
	ImageURL    string   `json:"image_url"`
	SourceID    string   `json:"source_id"`
	SourceName  string   `json:"source_name"`
	SourceURL   string   `json:"source_url"`
	Language    string   `json:"language"`
	Country     []string `json:"country"`
	Category    []string `json:"category"`
}

// GetNews retrieves news articles based on the query parameters.
func (c *NewsDataClient) GetNews(ctx context.Context, query services.NewsQuery) ([]services.NewsArticle, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("newsdata: rate limit wait: %w", err)
		}
	}

	// Build URL
	u, err := url.Parse(c.baseURL)
	if err != nil {
		return nil, fmt.Errorf("newsdata: parse base URL: %w", err)
	}

	q := u.Query()
	q.Set("apikey", c.apiKey)
	q.Set("category", "business") // Focus on financial/business news

	// Apply language filter
	lang := query.Language
	if lang == "" {
		lang = "en"
	}
	q.Set("language", lang)

	// Apply keyword search
	if query.Keywords != "" {
		q.Set("q", query.Keywords)
	}

	// Apply symbol search (convert to keywords since NewsData doesn't support symbols directly)
	if len(query.Symbols) > 0 && query.Keywords == "" {
		q.Set("q", strings.Join(query.Symbols, " OR "))
	}

	// Limit (max 10 for free tier)
	limit := query.Limit
	if limit <= 0 || limit > 10 {
		limit = 10
	}
	q.Set("size", fmt.Sprintf("%d", limit))

	u.RawQuery = q.Encode()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
	if err != nil {
		return nil, fmt.Errorf("newsdata: create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "WealthScope/1.0")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("newsdata: request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("newsdata: unexpected status %d", resp.StatusCode)
	}

	var result newsDataResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("newsdata: decode response: %w", err)
	}

	if result.Status != "success" {
		return nil, fmt.Errorf("newsdata: API returned status %s", result.Status)
	}

	// Convert to domain articles
	articles := make([]services.NewsArticle, 0, len(result.Results))
	for _, r := range result.Results {
		article := c.toNewsArticle(r)
		articles = append(articles, article)
	}

	return articles, nil
}

// GetNewsBySymbol retrieves news articles for a specific stock symbol.
func (c *NewsDataClient) GetNewsBySymbol(ctx context.Context, symbol string, limit int) ([]services.NewsArticle, error) {
	return c.GetNews(ctx, services.NewsQuery{
		Keywords: symbol,
		Limit:    limit,
		Language: "en",
	})
}

// Name returns the provider name.
func (c *NewsDataClient) Name() string {
	return "newsdata"
}

// toNewsArticle converts a NewsData.io article to a domain NewsArticle.
func (c *NewsDataClient) toNewsArticle(r newsDataArticle) services.NewsArticle {
	// Parse publication date
	pubDate, _ := time.Parse("2006-01-02 15:04:05", r.PubDate)
	if pubDate.IsZero() {
		// Try alternative format
		pubDate, _ = time.Parse(time.RFC3339, r.PubDate)
	}
	if pubDate.IsZero() {
		pubDate = time.Now().UTC()
	}

	// Extract symbols from keywords (basic heuristic)
	var symbols []string
	for _, kw := range r.Keywords {
		// Common stock ticker patterns (all caps, 1-5 chars)
		kw = strings.TrimSpace(kw)
		if len(kw) >= 1 && len(kw) <= 5 && kw == strings.ToUpper(kw) {
			symbols = append(symbols, kw)
		}
	}

	return services.NewsArticle{
		ID:          r.ArticleID,
		Title:       r.Title,
		Description: r.Description,
		Content:     r.Content,
		URL:         r.Link,
		ImageURL:    r.ImageURL,
		Source:      r.SourceName,
		PublishedAt: pubDate,
		Symbols:     symbols,
		Sentiment:   0, // NewsData doesn't provide sentiment
		Provider:    c.Name(),
	}
}

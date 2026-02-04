package news

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

func TestNewsDataClient_GetNews(t *testing.T) {
	// Create mock server
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Verify request parameters
		assert.Equal(t, "test_key", r.URL.Query().Get("apikey"))
		assert.Equal(t, "business", r.URL.Query().Get("category"))
		assert.Equal(t, "en", r.URL.Query().Get("language"))

		// Return mock response
		response := newsDataResponse{
			Status:       "success",
			TotalResults: 2,
			Results: []newsDataArticle{
				{
					ArticleID:   "article1",
					Title:       "Apple Stock Rises",
					Description: "Apple shares surge after earnings report",
					Content:     "Full article content here",
					Link:        "https://example.com/article1",
					ImageURL:    "https://example.com/image1.jpg",
					SourceName:  "Financial Times",
					PubDate:     "2026-01-26 10:00:00",
					Keywords:    []string{"AAPL", "stocks", "technology"},
				},
				{
					ArticleID:   "article2",
					Title:       "Tesla Announces New Model",
					Description: "Tesla unveils new electric vehicle",
					Link:        "https://example.com/article2",
					SourceName:  "Bloomberg",
					PubDate:     "2026-01-26 09:00:00",
					Keywords:    []string{"TSLA", "EV"},
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	// Create client with mock server
	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	// Test GetNews
	articles, err := client.GetNews(context.Background(), services.NewsQuery{
		Language: "en",
		Limit:    10,
	})

	require.NoError(t, err)
	assert.Len(t, articles, 2)

	// Verify first article
	assert.Equal(t, "article1", articles[0].ID)
	assert.Equal(t, "Apple Stock Rises", articles[0].Title)
	assert.Equal(t, "Apple shares surge after earnings report", articles[0].Description)
	assert.Equal(t, "https://example.com/article1", articles[0].URL)
	assert.Equal(t, "Financial Times", articles[0].Source)
	assert.Equal(t, "newsdata", articles[0].Provider)
	assert.Contains(t, articles[0].Symbols, "AAPL")

	// Verify second article
	assert.Equal(t, "article2", articles[1].ID)
	assert.Equal(t, "Tesla Announces New Model", articles[1].Title)
}

func TestNewsDataClient_GetNewsBySymbol(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Should search for the symbol as keyword
		assert.Contains(t, r.URL.Query().Get("q"), "AAPL")

		response := newsDataResponse{
			Status:       "success",
			TotalResults: 1,
			Results: []newsDataArticle{
				{
					ArticleID:  "article1",
					Title:      "Apple News",
					Link:       "https://example.com/article1",
					SourceName: "Reuters",
					PubDate:    "2026-01-26 10:00:00",
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNewsBySymbol(context.Background(), "AAPL", 5)

	require.NoError(t, err)
	assert.Len(t, articles, 1)
	assert.Equal(t, "Apple News", articles[0].Title)
}

func TestNewsDataClient_Name(t *testing.T) {
	client := NewNewsDataClient("test_key", nil)
	assert.Equal(t, "newsdata", client.Name())
}

func TestNewsDataClient_ErrorResponse(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusUnauthorized)
	}))
	defer server.Close()

	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "invalid_key",
		baseURL:    server.URL,
	}

	_, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.Error(t, err)
	assert.Contains(t, err.Error(), "unexpected status 401")
}

func TestNewsDataClient_APIStatusError(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		response := newsDataResponse{
			Status: "error",
		}
		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	_, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.Error(t, err)
	assert.Contains(t, err.Error(), "API returned status error")
}

func TestNewsDataClient_DateParsing(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		response := newsDataResponse{
			Status: "success",
			Results: []newsDataArticle{
				{
					ArticleID:  "article1",
					Title:      "Test Article",
					Link:       "https://example.com/article1",
					SourceName: "Test",
					PubDate:    "2026-01-26 15:30:45", // Standard format
				},
				{
					ArticleID:  "article2",
					Title:      "Test Article 2",
					Link:       "https://example.com/article2",
					SourceName: "Test",
					PubDate:    "2026-01-26T15:30:45Z", // RFC3339 format
				},
				{
					ArticleID:  "article3",
					Title:      "Test Article 3",
					Link:       "https://example.com/article3",
					SourceName: "Test",
					PubDate:    "invalid-date", // Invalid format
				},
			},
		}
		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.NoError(t, err)
	assert.Len(t, articles, 3)

	// First article should have parsed date
	assert.False(t, articles[0].PublishedAt.IsZero())

	// Second article should have parsed date
	assert.False(t, articles[1].PublishedAt.IsZero())

	// Third article should fall back to current time (not zero)
	assert.False(t, articles[2].PublishedAt.IsZero())
}

func TestNewsDataClient_SymbolsFromKeywords(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		response := newsDataResponse{
			Status: "success",
			Results: []newsDataArticle{
				{
					ArticleID:  "article1",
					Title:      "Market Update",
					Link:       "https://example.com/article1",
					SourceName: "Test",
					PubDate:    "2026-01-26 10:00:00",
					Keywords:   []string{"AAPL", "MSFT", "technology", "S&P500"},
				},
			},
		}
		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &NewsDataClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.NoError(t, err)
	assert.Len(t, articles, 1)

	// Should extract AAPL and MSFT as symbols (uppercase, 1-5 chars)
	assert.Contains(t, articles[0].Symbols, "AAPL")
	assert.Contains(t, articles[0].Symbols, "MSFT")
}

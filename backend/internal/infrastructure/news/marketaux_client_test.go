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

func TestMarketauxClient_GetNews(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Verify request parameters
		assert.Equal(t, "test_key", r.URL.Query().Get("api_token"))
		assert.Equal(t, "true", r.URL.Query().Get("must_have_entities"))

		response := marketauxResponse{
			Meta: struct {
				Found    int `json:"found"`
				Returned int `json:"returned"`
				Limit    int `json:"limit"`
				Page     int `json:"page"`
			}{
				Found:    2,
				Returned: 2,
				Limit:    10,
				Page:     1,
			},
			Data: []marketauxArticle{
				{
					UUID:        "uuid1",
					Title:       "Apple Earnings Beat Expectations",
					Description: "Apple Inc. reported Q4 earnings...",
					Snippet:     "Apple reported strong earnings",
					URL:         "https://example.com/apple-earnings",
					ImageURL:    "https://example.com/apple.jpg",
					Source:      "Bloomberg",
					PublishedAt: "2026-01-26T10:00:00.000000Z",
					Entities: []marketauxEntity{
						{
							Symbol:         "AAPL",
							Name:           "Apple Inc",
							SentimentScore: 0.75,
							MatchScore:     0.95,
						},
					},
				},
				{
					UUID:        "uuid2",
					Title:       "Tech Stocks Rally",
					Description: "Technology sector leads market gains",
					URL:         "https://example.com/tech-rally",
					Source:      "Reuters",
					PublishedAt: "2026-01-26T09:00:00Z",
					Entities: []marketauxEntity{
						{
							Symbol:         "MSFT",
							Name:           "Microsoft",
							SentimentScore: 0.6,
						},
						{
							Symbol:         "GOOGL",
							Name:           "Alphabet",
							SentimentScore: 0.5,
						},
					},
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNews(context.Background(), services.NewsQuery{
		Language: "en",
		Limit:    10,
	})

	require.NoError(t, err)
	assert.Len(t, articles, 2)

	// Verify first article
	assert.Equal(t, "uuid1", articles[0].ID)
	assert.Equal(t, "Apple Earnings Beat Expectations", articles[0].Title)
	assert.Equal(t, "Apple Inc. reported Q4 earnings...", articles[0].Description)
	assert.Equal(t, "https://example.com/apple-earnings", articles[0].URL)
	assert.Equal(t, "Bloomberg", articles[0].Source)
	assert.Equal(t, "marketaux", articles[0].Provider)
	assert.Contains(t, articles[0].Symbols, "AAPL")
	assert.InDelta(t, 0.75, articles[0].Sentiment, 0.01) // Average sentiment

	// Verify second article
	assert.Equal(t, "uuid2", articles[1].ID)
	assert.Contains(t, articles[1].Symbols, "MSFT")
	assert.Contains(t, articles[1].Symbols, "GOOGL")
	assert.InDelta(t, 0.55, articles[1].Sentiment, 0.01) // Average of 0.6 and 0.5
}

func TestMarketauxClient_GetNewsBySymbol(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Should filter by symbol
		assert.Equal(t, "TSLA", r.URL.Query().Get("symbols"))
		assert.Equal(t, "true", r.URL.Query().Get("filter_entities"))

		response := marketauxResponse{
			Data: []marketauxArticle{
				{
					UUID:        "uuid1",
					Title:       "Tesla News",
					URL:         "https://example.com/tesla",
					Source:      "CNBC",
					PublishedAt: "2026-01-26T10:00:00Z",
					Entities: []marketauxEntity{
						{
							Symbol:         "TSLA",
							SentimentScore: 0.3,
						},
					},
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNewsBySymbol(context.Background(), "TSLA", 5)

	require.NoError(t, err)
	assert.Len(t, articles, 1)
	assert.Equal(t, "Tesla News", articles[0].Title)
	assert.Contains(t, articles[0].Symbols, "TSLA")
}

func TestMarketauxClient_Name(t *testing.T) {
	client := NewMarketauxClient("test_key", nil)
	assert.Equal(t, "marketaux", client.Name())
}

func TestMarketauxClient_ErrorResponse(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusForbidden)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "invalid_key",
		baseURL:    server.URL,
	}

	_, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.Error(t, err)
	assert.Contains(t, err.Error(), "unexpected status 403")
}

func TestMarketauxClient_MultipleSymbols(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Should include multiple symbols
		symbols := r.URL.Query().Get("symbols")
		assert.Contains(t, symbols, "AAPL")
		assert.Contains(t, symbols, "MSFT")

		response := marketauxResponse{
			Data: []marketauxArticle{},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	_, err := client.GetNews(context.Background(), services.NewsQuery{
		Symbols: []string{"AAPL", "MSFT"},
	})

	require.NoError(t, err)
}

func TestMarketauxClient_KeywordSearch(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Should use search parameter for keywords
		assert.Equal(t, "artificial intelligence", r.URL.Query().Get("search"))

		response := marketauxResponse{
			Data: []marketauxArticle{},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	_, err := client.GetNews(context.Background(), services.NewsQuery{
		Keywords: "artificial intelligence",
	})

	require.NoError(t, err)
}

func TestMarketauxClient_SentimentCalculation(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		response := marketauxResponse{
			Data: []marketauxArticle{
				{
					UUID:        "uuid1",
					Title:       "Mixed Sentiment Article",
					URL:         "https://example.com/mixed",
					Source:      "Test",
					PublishedAt: "2026-01-26T10:00:00Z",
					Entities: []marketauxEntity{
						{Symbol: "A", SentimentScore: 0.8},
						{Symbol: "B", SentimentScore: -0.2},
						{Symbol: "C", SentimentScore: 0.4},
					},
				},
				{
					UUID:        "uuid2",
					Title:       "No Sentiment Article",
					URL:         "https://example.com/none",
					Source:      "Test",
					PublishedAt: "2026-01-26T09:00:00Z",
					Entities: []marketauxEntity{
						{Symbol: "X"},
						{Symbol: "Y"},
					},
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.NoError(t, err)
	assert.Len(t, articles, 2)

	// First article: average of 0.8, -0.2, 0.4 = 1.0/3 = 0.333...
	assert.InDelta(t, 0.333, articles[0].Sentiment, 0.01)

	// Second article: no sentiment scores, should be 0
	assert.Equal(t, 0.0, articles[1].Sentiment)
}

func TestMarketauxClient_EmptyDescription(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		response := marketauxResponse{
			Data: []marketauxArticle{
				{
					UUID:        "uuid1",
					Title:       "Test Article",
					Description: "", // Empty description
					Snippet:     "This is the snippet content",
					URL:         "https://example.com/test",
					Source:      "Test",
					PublishedAt: "2026-01-26T10:00:00Z",
				},
			},
		}

		w.Header().Set("Content-Type", "application/json")
		//nolint:errcheck
		json.NewEncoder(w).Encode(response)
	}))
	defer server.Close()

	client := &MarketauxClient{
		httpClient: &http.Client{Timeout: 10 * time.Second},
		apiKey:     "test_key",
		baseURL:    server.URL,
	}

	articles, err := client.GetNews(context.Background(), services.NewsQuery{})

	require.NoError(t, err)
	assert.Len(t, articles, 1)

	// Content should use snippet when description is empty
	assert.Equal(t, "This is the snippet content", articles[0].Content)
}

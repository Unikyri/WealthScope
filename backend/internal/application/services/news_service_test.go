package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// mockNewsClient is a test mock for services.NewsClient.
//
//nolint:govet // fieldalignment: test mock struct
type mockNewsClient struct {
	name     string
	articles []services.NewsArticle
	err      error
}

func (m *mockNewsClient) GetNews(_ context.Context, _ services.NewsQuery) ([]services.NewsArticle, error) {
	if m.err != nil {
		return nil, m.err
	}
	return m.articles, nil
}

func (m *mockNewsClient) GetNewsBySymbol(_ context.Context, _ string, _ int) ([]services.NewsArticle, error) {
	if m.err != nil {
		return nil, m.err
	}
	return m.articles, nil
}

func (m *mockNewsClient) Name() string {
	return m.name
}

func TestNewsService_GetNews_Success(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:          "1",
			Title:       "Test Article",
			PublishedAt: time.Now(),
			Provider:    "mock",
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.GetNews(context.Background(), services.NewsQuery{
		Limit: 10,
	})

	require.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Test Article", result[0].Title)
}

func TestNewsService_GetNews_Fallback(t *testing.T) {
	primaryArticles := []services.NewsArticle{
		{
			ID:          "primary",
			Title:       "Primary Article",
			PublishedAt: time.Now(),
		},
	}

	fallbackArticles := []services.NewsArticle{
		{
			ID:          "fallback",
			Title:       "Fallback Article",
			PublishedAt: time.Now(),
		},
	}

	// Primary fails, fallback succeeds
	primary := &mockNewsClient{
		name: "primary",
		err:  errors.New("primary failed"),
	}

	fallback := &mockNewsClient{
		name:     "fallback",
		articles: fallbackArticles,
	}

	svc := NewNewsService([]services.NewsClient{primary, fallback}, time.Minute, nil)

	result, err := svc.GetNews(context.Background(), services.NewsQuery{
		Limit: 10,
	})

	require.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Fallback Article", result[0].Title)

	// Verify primary was used when available
	primary.err = nil
	primary.articles = primaryArticles

	svc.ClearCache() // Clear cache to test fresh request

	result, err = svc.GetNews(context.Background(), services.NewsQuery{
		Limit: 10,
	})

	require.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Primary Article", result[0].Title)
}

func TestNewsService_GetNews_Caching(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:          "1",
			Title:       "Cached Article",
			PublishedAt: time.Now(),
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, 10*time.Second, nil)

	// First call should hit provider
	_, err := svc.GetNews(context.Background(), services.NewsQuery{
		Keywords: "test",
		Limit:    10,
	})
	require.NoError(t, err)

	// Second call should hit cache (same query)
	result, err := svc.GetNews(context.Background(), services.NewsQuery{
		Keywords: "test",
		Limit:    10,
	})
	require.NoError(t, err)
	assert.Len(t, result, 1)

	// Verify cache stats
	entries, _ := svc.GetCacheStats()
	assert.Equal(t, 1, entries)
}

func TestNewsService_GetNews_AllProvidersFail(t *testing.T) {
	provider := &mockNewsClient{
		name: "failing",
		err:  errors.New("provider error"),
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	_, err := svc.GetNews(context.Background(), services.NewsQuery{})

	require.Error(t, err)
	assert.Contains(t, err.Error(), "all news providers failed")
}

func TestNewsService_GetNewsBySymbols(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:      "1",
			Title:   "Apple News",
			Symbols: []string{"AAPL"},
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.GetNewsBySymbols(context.Background(), []string{"AAPL", "MSFT"}, 5)

	require.NoError(t, err)
	assert.Len(t, result, 1)
}

func TestNewsService_GetNewsBySymbol(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:      "1",
			Title:   "Tesla Update",
			Symbols: []string{"TSLA"},
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.GetNewsBySymbol(context.Background(), "TSLA", 10)

	require.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Tesla Update", result[0].Title)
}

func TestNewsService_GetTrendingNews(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:    "1",
			Title: "Trending News",
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.GetTrendingNews(context.Background(), 10)

	require.NoError(t, err)
	assert.Len(t, result, 1)
}

func TestNewsService_SearchNews(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:    "1",
			Title: "Search Result",
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.SearchNews(context.Background(), "blockchain", 10)

	require.NoError(t, err)
	assert.Len(t, result, 1)
}

func TestNewsService_ClearCache(t *testing.T) {
	articles := []services.NewsArticle{
		{
			ID:    "1",
			Title: "Test",
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	// Add to cache
	_, err := svc.GetNews(context.Background(), services.NewsQuery{})
	require.NoError(t, err)

	entries, _ := svc.GetCacheStats()
	assert.Equal(t, 1, entries)

	// Clear cache
	svc.ClearCache()

	entries, _ = svc.GetCacheStats()
	assert.Equal(t, 0, entries)
}

func TestNewsService_SortsByPublishedAt(t *testing.T) {
	now := time.Now()
	articles := []services.NewsArticle{
		{
			ID:          "old",
			Title:       "Old Article",
			PublishedAt: now.Add(-2 * time.Hour),
		},
		{
			ID:          "newest",
			Title:       "Newest Article",
			PublishedAt: now,
		},
		{
			ID:          "mid",
			Title:       "Middle Article",
			PublishedAt: now.Add(-1 * time.Hour),
		},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	result, err := svc.GetNews(context.Background(), services.NewsQuery{})

	require.NoError(t, err)
	assert.Len(t, result, 3)

	// Should be sorted by published date, newest first
	assert.Equal(t, "Newest Article", result[0].Title)
	assert.Equal(t, "Middle Article", result[1].Title)
	assert.Equal(t, "Old Article", result[2].Title)
}

func TestNewsService_ProviderCount(t *testing.T) {
	svc := NewNewsService([]services.NewsClient{
		&mockNewsClient{name: "provider1"},
		&mockNewsClient{name: "provider2"},
	}, time.Minute, nil)

	assert.Equal(t, 2, svc.ProviderCount())
}

func TestNewsService_DefaultCacheTTL(t *testing.T) {
	// When TTL is 0 or negative, should use default
	svc := NewNewsService([]services.NewsClient{}, 0, nil)
	assert.NotNil(t, svc)
}

func TestNewsService_CacheKeyConsistency(t *testing.T) {
	articles := []services.NewsArticle{
		{ID: "1", Title: "Test"},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	svc := NewNewsService([]services.NewsClient{provider}, time.Minute, nil)

	// Same query with different symbol order should generate same cache key
	_, _ = svc.GetNews(context.Background(), services.NewsQuery{
		Symbols: []string{"AAPL", "MSFT"},
	})

	_, _ = svc.GetNews(context.Background(), services.NewsQuery{
		Symbols: []string{"MSFT", "AAPL"},
	})

	// Should only have one cache entry (same key)
	entries, _ := svc.GetCacheStats()
	assert.Equal(t, 1, entries)
}

func TestNewsService_StaleCache(t *testing.T) {
	articles := []services.NewsArticle{
		{ID: "1", Title: "Cached"},
	}

	provider := &mockNewsClient{
		name:     "mock",
		articles: articles,
	}

	// Very short cache TTL
	svc := NewNewsService([]services.NewsClient{provider}, 100*time.Millisecond, nil)

	// First call
	_, err := svc.GetNews(context.Background(), services.NewsQuery{Keywords: "test"})
	require.NoError(t, err)

	// Wait for cache to expire
	time.Sleep(150 * time.Millisecond)

	// Now make provider fail - should still return stale cache
	provider.err = errors.New("provider down")

	result, err := svc.GetNews(context.Background(), services.NewsQuery{Keywords: "test"})

	// Should succeed with stale cache
	require.NoError(t, err)
	assert.Len(t, result, 1)
	assert.Equal(t, "Cached", result[0].Title)
}

package services

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"

	"go.uber.org/zap"
)

// NewsService aggregates news from multiple providers with caching and fallback.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type NewsService struct {
	cache     map[string]*cachedNews
	logger    *zap.Logger
	providers []services.NewsClient
	cacheTTL  time.Duration
	mu        sync.RWMutex
}

// cachedNews represents a cached news response.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type cachedNews struct {
	fetchedAt time.Time
	articles  []services.NewsArticle
}

// NewNewsService creates a new NewsService with the given providers.
// Providers are tried in order (first is primary, rest are fallbacks).
func NewNewsService(providers []services.NewsClient, cacheTTL time.Duration, logger *zap.Logger) *NewsService {
	if logger == nil {
		logger = zap.NewNop()
	}
	if cacheTTL <= 0 {
		cacheTTL = 5 * time.Minute
	}
	return &NewsService{
		providers: providers,
		cache:     make(map[string]*cachedNews),
		cacheTTL:  cacheTTL,
		logger:    logger,
	}
}

// GetNews retrieves news articles based on the query, using cache and fallback.
func (s *NewsService) GetNews(ctx context.Context, query services.NewsQuery) ([]services.NewsArticle, error) {
	// Generate cache key
	cacheKey := s.generateCacheKey(query)

	// Check cache
	s.mu.RLock()
	cached, ok := s.cache[cacheKey]
	s.mu.RUnlock()

	if ok && time.Since(cached.fetchedAt) < s.cacheTTL {
		s.logger.Debug("news cache hit", zap.String("key", cacheKey))
		return cached.articles, nil
	}

	// Try each provider in order
	var articles []services.NewsArticle
	var lastErr error

	for _, provider := range s.providers {
		s.logger.Debug("trying news provider",
			zap.String("provider", provider.Name()),
			zap.Strings("symbols", query.Symbols),
			zap.String("keywords", query.Keywords))

		articles, lastErr = provider.GetNews(ctx, query)
		if lastErr != nil {
			s.logger.Warn("news provider failed",
				zap.String("provider", provider.Name()),
				zap.Error(lastErr))
			continue
		}

		if len(articles) > 0 {
			s.logger.Debug("news provider succeeded",
				zap.String("provider", provider.Name()),
				zap.Int("articles", len(articles)))
			break
		}
	}

	// If all providers failed but we have stale cache, return it
	if lastErr != nil && ok {
		s.logger.Warn("all providers failed, returning stale cache",
			zap.String("key", cacheKey),
			zap.Error(lastErr))
		return cached.articles, nil
	}

	if lastErr != nil && len(articles) == 0 {
		return nil, fmt.Errorf("all news providers failed: %w", lastErr)
	}

	// Sort by published date (newest first)
	sort.Slice(articles, func(i, j int) bool {
		return articles[i].PublishedAt.After(articles[j].PublishedAt)
	})

	// Cache results
	s.mu.Lock()
	s.cache[cacheKey] = &cachedNews{
		articles:  articles,
		fetchedAt: time.Now(),
	}
	s.mu.Unlock()

	return articles, nil
}

// GetNewsBySymbols retrieves news for multiple stock symbols.
func (s *NewsService) GetNewsBySymbols(ctx context.Context, symbols []string, limit int) ([]services.NewsArticle, error) {
	if limit <= 0 {
		limit = 10
	}

	return s.GetNews(ctx, services.NewsQuery{
		Symbols:  symbols,
		Limit:    limit,
		Language: "en",
	})
}

// GetNewsBySymbol retrieves news for a single stock symbol.
func (s *NewsService) GetNewsBySymbol(ctx context.Context, symbol string, limit int) ([]services.NewsArticle, error) {
	if limit <= 0 {
		limit = 10
	}

	return s.GetNews(ctx, services.NewsQuery{
		Symbols:  []string{symbol},
		Limit:    limit,
		Language: "en",
	})
}

// GetTrendingNews retrieves trending financial news without symbol filtering.
func (s *NewsService) GetTrendingNews(ctx context.Context, limit int) ([]services.NewsArticle, error) {
	if limit <= 0 {
		limit = 10
	}

	return s.GetNews(ctx, services.NewsQuery{
		Limit:    limit,
		Language: "en",
	})
}

// SearchNews searches news by keywords.
func (s *NewsService) SearchNews(ctx context.Context, keywords string, limit int) ([]services.NewsArticle, error) {
	if limit <= 0 {
		limit = 10
	}

	return s.GetNews(ctx, services.NewsQuery{
		Keywords: keywords,
		Limit:    limit,
		Language: "en",
	})
}

// ClearCache removes all cached news.
func (s *NewsService) ClearCache() {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.cache = make(map[string]*cachedNews)
}

// GetCacheStats returns cache statistics.
func (s *NewsService) GetCacheStats() (entries int, oldestAge time.Duration) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	entries = len(s.cache)
	var oldest time.Time

	for _, c := range s.cache {
		if oldest.IsZero() || c.fetchedAt.Before(oldest) {
			oldest = c.fetchedAt
		}
	}

	if !oldest.IsZero() {
		oldestAge = time.Since(oldest)
	}

	return entries, oldestAge
}

// generateCacheKey creates a unique cache key from the query parameters.
func (s *NewsService) generateCacheKey(query services.NewsQuery) string {
	// Sort symbols for consistent key
	symbols := make([]string, len(query.Symbols))
	copy(symbols, query.Symbols)
	sort.Strings(symbols)

	keyData := fmt.Sprintf("symbols=%s|keywords=%s|lang=%s|limit=%d|page=%d",
		strings.Join(symbols, ","),
		query.Keywords,
		query.Language,
		query.Limit,
		query.Page,
	)

	hash := sha256.Sum256([]byte(keyData))
	return hex.EncodeToString(hash[:8])
}

// ProviderCount returns the number of registered providers.
func (s *NewsService) ProviderCount() int {
	return len(s.providers)
}

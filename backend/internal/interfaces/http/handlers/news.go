package handlers

import (
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"

	appsvc "github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// NewsHandler handles news-related HTTP requests.
type NewsHandler struct {
	newsService *appsvc.NewsService
}

// NewNewsHandler creates a new NewsHandler.
func NewNewsHandler(newsService *appsvc.NewsService) *NewsHandler {
	return &NewsHandler{
		newsService: newsService,
	}
}

// NewsListResponse represents the response for news list endpoints.
type NewsListResponse struct {
	Articles []services.NewsArticle `json:"articles"`
	Total    int                    `json:"total"`
	Page     int                    `json:"page"`
	Limit    int                    `json:"limit"`
}

// GetNews handles GET /api/v1/news
// @Summary Get latest financial news
// @Description Fetch latest financial news with optional filtering by symbols, keywords, language
// @Tags News
// @Accept json
// @Produce json
// @Param symbols query string false "Comma-separated stock symbols (e.g., AAPL,TSLA)"
// @Param q query string false "Search keywords"
// @Param language query string false "Language code (default: en)"
// @Param limit query int false "Max articles (default 10, max 50)"
// @Param page query int false "Page number (default 1)"
// @Success 200 {object} response.Response{data=NewsListResponse}
// @Failure 400 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/news [get]
func (h *NewsHandler) GetNews(c *gin.Context) {
	// Parse query parameters
	symbolsParam := c.Query("symbols")
	var symbols []string
	if symbolsParam != "" {
		symbols = strings.Split(symbolsParam, ",")
		for i, s := range symbols {
			symbols[i] = strings.TrimSpace(strings.ToUpper(s))
		}
	}

	keywords := c.Query("q")
	language := c.DefaultQuery("language", "en")

	limit, err := strconv.Atoi(c.DefaultQuery("limit", "10"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	page, err := strconv.Atoi(c.DefaultQuery("page", "1"))
	if err != nil || page <= 0 {
		page = 1
	}

	// Build query
	query := services.NewsQuery{
		Symbols:  symbols,
		Keywords: keywords,
		Language: language,
		Limit:    limit,
		Page:     page,
	}

	// Get news
	articles, err := h.newsService.GetNews(c.Request.Context(), query)
	if err != nil {
		response.InternalError(c, "Failed to fetch news: "+err.Error())
		return
	}

	// Return response
	response.Success(c, NewsListResponse{
		Articles: articles,
		Total:    len(articles),
		Page:     page,
		Limit:    limit,
	})
}

// GetNewsBySymbol handles GET /api/v1/news/symbol/:symbol
// @Summary Get news for a specific symbol
// @Description Fetch financial news related to a specific stock or crypto symbol
// @Tags News
// @Accept json
// @Produce json
// @Param symbol path string true "Stock symbol (e.g., AAPL)"
// @Param limit query int false "Max articles (default 10, max 50)"
// @Success 200 {object} response.Response{data=NewsListResponse}
// @Failure 400 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/news/symbol/{symbol} [get]
func (h *NewsHandler) GetNewsBySymbol(c *gin.Context) {
	symbol := strings.TrimSpace(strings.ToUpper(c.Param("symbol")))
	if symbol == "" {
		response.BadRequest(c, "Symbol is required")
		return
	}

	limit, err := strconv.Atoi(c.DefaultQuery("limit", "10"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get news for symbol
	articles, err := h.newsService.GetNewsBySymbol(c.Request.Context(), symbol, limit)
	if err != nil {
		response.InternalError(c, "Failed to fetch news for symbol: "+err.Error())
		return
	}

	// Return response
	response.Success(c, NewsListResponse{
		Articles: articles,
		Total:    len(articles),
		Page:     1,
		Limit:    limit,
	})
}

// GetTrendingNews handles GET /api/v1/news/trending
// @Summary Get trending financial news
// @Description Fetch top trending financial news articles
// @Tags News
// @Accept json
// @Produce json
// @Param limit query int false "Max articles (default 10, max 50)"
// @Success 200 {object} response.Response{data=NewsListResponse}
// @Failure 500 {object} response.Response
// @Router /api/v1/news/trending [get]
func (h *NewsHandler) GetTrendingNews(c *gin.Context) {
	limit, err := strconv.Atoi(c.DefaultQuery("limit", "10"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Get trending news
	articles, err := h.newsService.GetTrendingNews(c.Request.Context(), limit)
	if err != nil {
		response.InternalError(c, "Failed to fetch trending news: "+err.Error())
		return
	}

	// Return response
	response.Success(c, NewsListResponse{
		Articles: articles,
		Total:    len(articles),
		Page:     1,
		Limit:    limit,
	})
}

// SearchNews handles GET /api/v1/news/search
// @Summary Search financial news
// @Description Search for financial news articles by keywords
// @Tags News
// @Accept json
// @Produce json
// @Param q query string true "Search keywords"
// @Param limit query int false "Max articles (default 10, max 50)"
// @Success 200 {object} response.Response{data=NewsListResponse}
// @Failure 400 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/news/search [get]
func (h *NewsHandler) SearchNews(c *gin.Context) {
	keywords := c.Query("q")
	if keywords == "" {
		response.BadRequest(c, "Search query (q) is required")
		return
	}

	limit, err := strconv.Atoi(c.DefaultQuery("limit", "10"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 50 {
		limit = 50
	}

	// Search news
	articles, err := h.newsService.SearchNews(c.Request.Context(), keywords, limit)
	if err != nil {
		response.InternalError(c, "Failed to search news: "+err.Error())
		return
	}

	// Return response
	response.Success(c, NewsListResponse{
		Articles: articles,
		Total:    len(articles),
		Page:     1,
		Limit:    limit,
	})
}

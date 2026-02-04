package http

import (
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/logging"
	infraRepo "github.com/Unikyri/WealthScope/backend/internal/infrastructure/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/handlers"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
)

// RouterDeps holds all dependencies needed by the router
type RouterDeps struct {
	Config      *config.Config
	DB          *database.DB
	NewsService *services.NewsService
	AIService   *services.AIService
}

// NewRouter creates and configures a new Gin router
func NewRouter(deps RouterDeps) *gin.Engine {
	// Set Gin mode
	gin.SetMode(deps.Config.Server.Mode)

	router := gin.New()

	// Global middleware
	router.Use(gin.Recovery())
	router.Use(corsMiddleware())
	router.Use(requestIDMiddleware())
	router.Use(gin.Logger())

	// Initialize rate limiter for auth endpoints (5 attempts per minute)
	authRateLimiter := middleware.NewRateLimiter(5, time.Minute)

	// Initialize auth logger
	authLogger, _ := logging.NewAuthLogger()
	_ = authLogger // Will be used in handlers

	// Initialize repositories
	var userRepo repositories.UserRepository
	var assetRepo repositories.AssetRepository
	if deps.DB != nil {
		userRepo = infraRepo.NewPostgresUserRepository(deps.DB.DB)
		assetRepo = infraRepo.NewPostgresAssetRepository(deps.DB.DB)
	}

	// Initialize use cases
	var syncUserUseCase *usecases.SyncUserUseCase
	var createAssetUC *usecases.CreateAssetUseCase
	var getAssetUC *usecases.GetAssetUseCase
	var listAssetsUC *usecases.ListAssetsUseCase
	var updateAssetUC *usecases.UpdateAssetUseCase
	var deleteAssetUC *usecases.DeleteAssetUseCase

	if userRepo != nil {
		syncUserUseCase = usecases.NewSyncUserUseCase(userRepo)
	}
	if assetRepo != nil {
		createAssetUC = usecases.NewCreateAssetUseCase(assetRepo)
		getAssetUC = usecases.NewGetAssetUseCase(assetRepo)
		listAssetsUC = usecases.NewListAssetsUseCase(assetRepo)
		updateAssetUC = usecases.NewUpdateAssetUseCase(assetRepo)
		deleteAssetUC = usecases.NewDeleteAssetUseCase(assetRepo)
	}

	// Initialize portfolio use cases
	var getPortfolioSummaryUC *usecases.GetPortfolioSummaryUseCase
	if assetRepo != nil {
		getPortfolioSummaryUC = usecases.NewGetPortfolioSummaryUseCase(assetRepo)
	}

	// Initialize risk use cases
	var getPortfolioRiskUC *usecases.GetPortfolioRiskUseCase
	if assetRepo != nil {
		getPortfolioRiskUC = usecases.NewGetPortfolioRiskUseCase(assetRepo, services.NewRiskService())
	}

	// Initialize handlers
	healthHandler := handlers.NewHealthHandler(deps.DB)
	authHandler := handlers.NewAuthHandler(syncUserUseCase)
	assetHandler := handlers.NewAssetHandler(
		createAssetUC,
		getAssetUC,
		listAssetsUC,
		updateAssetUC,
		deleteAssetUC,
	)
	portfolioHandler := handlers.NewPortfolioHandler(getPortfolioSummaryUC, getPortfolioRiskUC)

	// Initialize news handler
	var newsHandler *handlers.NewsHandler
	if deps.NewsService != nil {
		newsHandler = handlers.NewNewsHandler(deps.NewsService)
	}

	// Initialize chat handler
	var chatHandler *handlers.ChatHandler
	if deps.AIService != nil {
		chatHandler = handlers.NewChatHandler(deps.AIService)
	}

	// Health check (public)
	router.GET("/health", healthHandler.Health)

	// Swagger documentation
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Public routes
		v1.GET("/ping", healthHandler.Ping)

		// Auth routes (protected with rate limiting)
		auth := v1.Group("/auth")
		auth.Use(authRateLimiter.Middleware()) // Rate limit: 5 attempts per minute
		auth.Use(middleware.AuthMiddleware(deps.Config.Supabase.URL))
		{
			auth.POST("/sync", authHandler.Sync)
			auth.GET("/me", authHandler.Me)
		}

		// Asset routes (protected)
		assets := v1.Group("/assets")
		assets.Use(middleware.AuthMiddleware(deps.Config.Supabase.URL))
		{
			assets.POST("", assetHandler.Create)
			assets.GET("", assetHandler.List)
			assets.GET("/:id", assetHandler.GetByID)
			assets.PUT("/:id", assetHandler.Update)
			assets.DELETE("/:id", assetHandler.Delete)
		}

		// Portfolio routes (protected)
		portfolio := v1.Group("/portfolio")
		portfolio.Use(middleware.AuthMiddleware(deps.Config.Supabase.URL))
		{
			portfolio.GET("/summary", portfolioHandler.GetSummary)
			portfolio.GET("/risk", portfolioHandler.GetRisk)
		}

		// News routes (public - no auth required for general news)
		if newsHandler != nil {
			news := v1.Group("/news")
			{
				news.GET("", newsHandler.GetNews)
				news.GET("/trending", newsHandler.GetTrendingNews)
				news.GET("/search", newsHandler.SearchNews)
				news.GET("/symbol/:symbol", newsHandler.GetNewsBySymbol)
			}
		}

		// AI routes (protected)
		if chatHandler != nil {
			ai := v1.Group("/ai")
			ai.Use(middleware.AuthMiddleware(deps.Config.Supabase.URL))
			{
				ai.GET("/welcome", chatHandler.Welcome)
				ai.POST("/chat", chatHandler.Chat)
				ai.POST("/conversations", chatHandler.CreateConversation)
				ai.GET("/conversations", chatHandler.ListConversations)
				ai.GET("/conversations/:id", chatHandler.GetConversation)
				ai.PUT("/conversations/:id", chatHandler.UpdateConversation)
				ai.DELETE("/conversations/:id", chatHandler.DeleteConversation)
			}
		}
	}

	return router
}

// requestIDMiddleware adds a unique request ID to each request
func requestIDMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		requestID := c.GetHeader("X-Request-ID")
		if requestID == "" {
			requestID = uuid.New().String()
		}
		c.Set("request_id", requestID)
		c.Header("X-Request-ID", requestID)
		c.Next()
	}
}

// corsMiddleware handles Cross-Origin Resource Sharing (CORS)
func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		origin := c.GetHeader("Origin")

		// Allow requests from any origin in development
		// In production, you might want to restrict this to specific domains
		if origin != "" {
			c.Header("Access-Control-Allow-Origin", origin)
		} else {
			c.Header("Access-Control-Allow-Origin", "*")
		}

		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization, X-Request-ID")
		c.Header("Access-Control-Allow-Credentials", "true")
		c.Header("Access-Control-Max-Age", "86400")

		// Handle preflight OPTIONS request
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

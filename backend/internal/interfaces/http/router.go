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
	Config *config.Config
	DB     *database.DB
}

// NewRouter creates and configures a new Gin router
func NewRouter(deps RouterDeps) *gin.Engine {
	// Set Gin mode
	gin.SetMode(deps.Config.Server.Mode)

	router := gin.New()

	// Global middleware
	router.Use(gin.Recovery())
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
		auth.Use(middleware.AuthMiddleware(deps.Config.Supabase.JWTSecret))
		{
			auth.POST("/sync", authHandler.Sync)
			auth.GET("/me", authHandler.Me)
		}

		// Asset routes (protected)
		assets := v1.Group("/assets")
		assets.Use(middleware.AuthMiddleware(deps.Config.Supabase.JWTSecret))
		{
			assets.POST("", assetHandler.Create)
			assets.GET("", assetHandler.List)
			assets.GET("/:id", assetHandler.GetByID)
			assets.PUT("/:id", assetHandler.Update)
			assets.DELETE("/:id", assetHandler.Delete)
		}

		// Portfolio routes (protected)
		portfolio := v1.Group("/portfolio")
		portfolio.Use(middleware.AuthMiddleware(deps.Config.Supabase.JWTSecret))
		{
			portfolio.GET("/summary", portfolioHandler.GetSummary)
			portfolio.GET("/risk", portfolioHandler.GetRisk)
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

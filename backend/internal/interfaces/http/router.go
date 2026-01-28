package http

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
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

	// Health check (public)
	router.GET("/health", healthHandler.Health)

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Public routes
		v1.GET("/ping", healthHandler.Ping)

		// Auth routes (protected)
		auth := v1.Group("/auth")
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

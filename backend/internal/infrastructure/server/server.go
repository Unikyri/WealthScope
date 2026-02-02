package server

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/application/jobs"
	appsvc "github.com/Unikyri/WealthScope/backend/internal/application/services"
	domainsvc "github.com/Unikyri/WealthScope/backend/internal/domain/services"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
	infraRepo "github.com/Unikyri/WealthScope/backend/internal/infrastructure/repositories"
	router "github.com/Unikyri/WealthScope/backend/internal/interfaces/http"
)

// Server represents the HTTP server
type Server struct {
	cfg    *config.Config
	logger *zap.Logger
	db     *database.DB
}

// New creates a new server instance
func New(cfg *config.Config, logger *zap.Logger, db *database.DB) *Server {
	return &Server{
		cfg:    cfg,
		logger: logger,
		db:     db,
	}
}

// Run starts the HTTP server with graceful shutdown
func (s *Server) Run() {
	// Create router with dependencies
	r := router.NewRouter(router.RouterDeps{
		Config: s.cfg,
		DB:     s.db,
	})

	// Create HTTP server
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%s", s.cfg.Server.Port),
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Start price update job (best-effort) if DB is available.
	if s.db != nil {
		go s.runPriceUpdateLoop()
	}

	// Start server in goroutine
	go func() {
		s.logger.Info("Starting server",
			zap.String("port", s.cfg.Server.Port),
			zap.String("mode", s.cfg.Server.Mode),
			zap.Bool("database_connected", s.db != nil),
		)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			s.logger.Fatal("Server failed to start", zap.Error(err))
		}
	}()

	// Wait for interrupt signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	s.logger.Info("Shutting down server...")

	// Graceful shutdown with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		s.logger.Fatal("Server forced to shutdown", zap.Error(err))
	}

	s.logger.Info("Server exited properly")
}

func (s *Server) runPriceUpdateLoop() {
	intervalSeconds := s.cfg.Pricing.UpdateIntervalSeconds
	if intervalSeconds <= 0 {
		intervalSeconds = 300
	}
	interval := time.Duration(intervalSeconds) * time.Second

	assetRepo := infraRepo.NewPostgresAssetRepository(s.db.DB)
	priceRepo := infraRepo.NewPostgresPriceHistoryRepository(s.db.DB)

	registry := marketdata.NewProviderRegistry(s.logger)
	if s.cfg.MarketData.YahooFinanceEnabled {
		registry.Register(domainsvc.CategoryEquity, marketdata.NewYahooFinanceClient(nil))
	}
	// Alpha Vantage / Finnhub registered in US-6.2 when enabled and keys present

	pricingSvc := appsvc.NewPricingService(registry, time.Minute)
	job := jobs.NewPriceUpdateJob(pricingSvc, assetRepo, priceRepo, s.logger)

	ticker := time.NewTicker(interval)
	defer ticker.Stop()

	// NOTE: We intentionally do not run immediately on startup to avoid
	// expensive work during deployments; first run happens after interval.
	for range ticker.C {
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		userIDs, err := assetRepo.ListUserIDsWithListedAssets(ctx)
		if err != nil {
			s.logger.Error("Failed to list users for price job", zap.Error(err))
			cancel()
			continue
		}

		for _, userID := range userIDs {
			if err := job.Run(ctx, userID); err != nil {
				// continue best-effort
				s.logger.Warn("Price job failed for user", zap.String("user_id", userID.String()), zap.Error(err))
			}
		}
		cancel()
	}
}

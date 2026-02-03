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

	// Setup market data providers with fallback order: Yahoo -> Finnhub -> Alpha Vantage
	registry := s.setupMarketDataProviders()

	cacheTTL := time.Duration(s.cfg.MarketData.CacheTTLSeconds) * time.Second
	if cacheTTL <= 0 {
		cacheTTL = time.Minute
	}
	pricingSvc := appsvc.NewPricingService(registry, cacheTTL)
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

// setupMarketDataProviders configures the market data providers with rate limiting.
// Fallback order for equities: Yahoo Finance (primary) -> Finnhub -> Alpha Vantage
// Fallback order for crypto: CoinGecko (primary) -> Binance
// Fallback order for forex: Frankfurter (primary) -> ExchangeRate API
// Fallback order for metals: Metals-API (primary)
func (s *Server) setupMarketDataProviders() domainsvc.MarketDataClient {
	registry := marketdata.NewProviderRegistry(s.logger)

	// Create shared crypto symbol mapper for category detection and symbol translation
	cryptoMapper := marketdata.NewCryptoSymbolMapper()
	registry.SetCryptoMapper(cryptoMapper)

	// ==================== EQUITY PROVIDERS ====================

	// 1. Yahoo Finance (primary - no API key needed, highest rate limit)
	if s.cfg.MarketData.YahooFinanceEnabled {
		yahooRateLimit := s.cfg.MarketData.YahooRateLimit
		if yahooRateLimit <= 0 {
			yahooRateLimit = 100 // default conservative limit
		}
		yahooLimiter := marketdata.NewRateLimiter(yahooRateLimit, time.Minute)
		yahoo := marketdata.NewYahooFinanceClient(yahooLimiter)
		registry.Register(domainsvc.CategoryEquity, yahoo)
		s.logger.Info("Registered Yahoo Finance provider",
			zap.Int("rate_limit_per_min", yahooRateLimit))
	}

	// 2. Finnhub (secondary - requires API key, 60 req/min free tier)
	if s.cfg.MarketData.FinnhubEnabled && s.cfg.MarketData.FinnhubAPIKey != "" {
		finnhubRateLimit := s.cfg.MarketData.FinnhubRateLimit
		if finnhubRateLimit <= 0 {
			finnhubRateLimit = 60
		}
		finnhubLimiter := marketdata.NewRateLimiter(finnhubRateLimit, time.Minute)
		finnhub := marketdata.NewFinnhubClient(s.cfg.MarketData.FinnhubAPIKey, finnhubLimiter)
		registry.Register(domainsvc.CategoryEquity, finnhub)
		s.logger.Info("Registered Finnhub provider",
			zap.Int("rate_limit_per_min", finnhubRateLimit))
	}

	// 3. Alpha Vantage (tertiary - requires API key, limited 25 req/day free tier)
	if s.cfg.MarketData.AlphaVantageEnabled && s.cfg.MarketData.AlphaVantageAPIKey != "" {
		alphaRateLimit := s.cfg.MarketData.AlphaVantageRateLimit
		if alphaRateLimit <= 0 {
			alphaRateLimit = 5 // very conservative for 25/day limit
		}
		alphaLimiter := marketdata.NewRateLimiter(alphaRateLimit, time.Minute)
		alpha := marketdata.NewAlphaVantageClient(s.cfg.MarketData.AlphaVantageAPIKey, alphaLimiter)
		registry.Register(domainsvc.CategoryEquity, alpha)
		s.logger.Info("Registered Alpha Vantage provider",
			zap.Int("rate_limit_per_min", alphaRateLimit))
	}

	// ==================== CRYPTO PROVIDERS ====================

	// 4. CoinGecko (primary crypto - comprehensive data, free tier available)
	if s.cfg.MarketData.CoinGeckoEnabled {
		geckoRateLimit := s.cfg.MarketData.CoinGeckoRateLimit
		if geckoRateLimit <= 0 {
			geckoRateLimit = 10 // conservative for free tier
		}
		geckoLimiter := marketdata.NewRateLimiter(geckoRateLimit, time.Minute)
		gecko := marketdata.NewCoinGeckoClient(s.cfg.MarketData.CoinGeckoAPIKey, geckoLimiter, cryptoMapper)
		registry.Register(domainsvc.CategoryCrypto, gecko)
		s.logger.Info("Registered CoinGecko provider",
			zap.Int("rate_limit_per_min", geckoRateLimit),
			zap.Bool("has_api_key", s.cfg.MarketData.CoinGeckoAPIKey != ""))
	}

	// 5. Binance (secondary crypto - fast real-time data, no API key needed)
	if s.cfg.MarketData.BinanceEnabled {
		binanceRateLimit := s.cfg.MarketData.BinanceRateLimit
		if binanceRateLimit <= 0 {
			binanceRateLimit = 100 // conservative for 1200/min limit
		}
		binanceLimiter := marketdata.NewRateLimiter(binanceRateLimit, time.Minute)
		binance := marketdata.NewBinanceClient(binanceLimiter, cryptoMapper)
		registry.Register(domainsvc.CategoryCrypto, binance)
		s.logger.Info("Registered Binance provider",
			zap.Int("rate_limit_per_min", binanceRateLimit))
	}

	// ==================== FOREX PROVIDERS ====================

	// Create shared forex symbol mapper for category detection and symbol translation
	forexMapper := marketdata.NewForexSymbolMapper()
	registry.SetForexMapper(forexMapper)

	// 6. Frankfurter (primary forex - free, reliable, uses ECB data)
	if s.cfg.MarketData.FrankfurterEnabled {
		frankfurterRateLimit := s.cfg.MarketData.FrankfurterRateLimit
		if frankfurterRateLimit <= 0 {
			frankfurterRateLimit = 30 // no official limit, be conservative
		}
		frankfurterLimiter := marketdata.NewRateLimiter(frankfurterRateLimit, time.Minute)
		frankfurter := marketdata.NewFrankfurterClient(frankfurterLimiter, forexMapper)
		registry.Register(domainsvc.CategoryForex, frankfurter)
		s.logger.Info("Registered Frankfurter provider",
			zap.Int("rate_limit_per_min", frankfurterRateLimit))
	}

	// 7. ExchangeRate API (secondary forex - backup, 1500 req/month free tier)
	if s.cfg.MarketData.ExchangeRateEnabled {
		erRateLimit := s.cfg.MarketData.ExchangeRateRateLimit
		if erRateLimit <= 0 {
			erRateLimit = 5 // very conservative for monthly limit
		}
		erLimiter := marketdata.NewRateLimiter(erRateLimit, time.Minute)
		exchangeRate := marketdata.NewExchangeRateClient(s.cfg.MarketData.ExchangeRateAPIKey, erLimiter, forexMapper)
		registry.Register(domainsvc.CategoryForex, exchangeRate)
		s.logger.Info("Registered ExchangeRate provider",
			zap.Int("rate_limit_per_min", erRateLimit),
			zap.Bool("has_api_key", s.cfg.MarketData.ExchangeRateAPIKey != ""))
	}

	// ==================== METALS PROVIDERS ====================

	// Create shared metals symbol mapper for category detection
	metalsMapper := marketdata.NewMetalsSymbolMapper()
	registry.SetMetalsMapper(metalsMapper)

	// 8. Metals-API (precious metals - requires API key, 100 req/month free tier)
	if s.cfg.MarketData.MetalsAPIEnabled && s.cfg.MarketData.MetalsAPIKey != "" {
		metalsRateLimit := s.cfg.MarketData.MetalsAPIRateLimit
		if metalsRateLimit <= 0 {
			metalsRateLimit = 3 // very conservative for 100/month limit
		}
		metalsLimiter := marketdata.NewRateLimiter(metalsRateLimit, time.Minute)
		metalsAPI := marketdata.NewMetalsAPIClient(s.cfg.MarketData.MetalsAPIKey, metalsLimiter, metalsMapper)
		registry.Register(domainsvc.CategoryMetal, metalsAPI)
		s.logger.Info("Registered Metals-API provider",
			zap.Int("rate_limit_per_min", metalsRateLimit))
	}

	return registry
}

package server

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	router "github.com/Unikyri/WealthScope/backend/internal/interfaces/http"
	"go.uber.org/zap"
)

// Server represents the HTTP server
type Server struct {
	cfg    *config.Config
	logger *zap.Logger
}

// New creates a new server instance
func New(cfg *config.Config, logger *zap.Logger) *Server {
	return &Server{
		cfg:    cfg,
		logger: logger,
	}
}

// Run starts the HTTP server with graceful shutdown
func (s *Server) Run() {
	// Create router
	r := router.NewRouter(s.cfg.Server.Mode)

	// Create HTTP server
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%s", s.cfg.Server.Port),
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Start server in goroutine
	go func() {
		s.logger.Info("Starting server",
			zap.String("port", s.cfg.Server.Port),
			zap.String("mode", s.cfg.Server.Mode),
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

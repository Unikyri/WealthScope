package http_test

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/config"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/database"
	httpRouter "github.com/Unikyri/WealthScope/backend/internal/interfaces/http"
)

func TestIntegration_AssetsAndPortfolioEndpoints(t *testing.T) {
	t.Setenv("SERVER_MODE", "test")
	cfg := config.Load()
	if cfg.Database.URL == "" || cfg.Supabase.JWTSecret == "" {
		t.Skip("DATABASE_URL or SUPABASE_JWT_SECRET not set; skipping integration tests")
	}

	logger := newTestLogger(t)
	db, err := database.Connect(cfg, logger)
	require.NoError(t, err)
	require.NotNil(t, db)

	gin.SetMode(gin.TestMode)
	r := httpRouter.NewRouter(httpRouter.RouterDeps{Config: cfg, DB: db})

	userID := uuid.New()
	email := "test+" + userID.String() + "@example.com"
	token := makeTestJWT(t, cfg.Supabase.JWTSecret, userID, email)

	// Ensure FK users(id) exists for assets.user_id
	require.NoError(t, db.DB.Exec(
		"INSERT INTO users (id, email, created_at, updated_at) VALUES (?, ?, NOW(), NOW()) ON CONFLICT (id) DO NOTHING",
		userID, email,
	).Error)

	// Create asset
	createBody := map[string]interface{}{
		"type":           "stock",
		"symbol":         "AAPL",
		"name":           "Apple Inc.",
		"quantity":       10,
		"purchase_price": 150,
		"currency":       "USD",
	}
	created := doJSON(t, r, http.MethodPost, "/api/v1/assets", token, createBody)
	require.Equal(t, http.StatusCreated, created.Code)

	var createResp struct {
		Success bool                   `json:"success"`
		Data    map[string]interface{} `json:"data"`
	}
	require.NoError(t, json.Unmarshal(created.Body.Bytes(), &createResp))
	require.True(t, createResp.Success)
	assetIDAny := createResp.Data["id"]
	require.NotNil(t, assetIDAny)
	assetID, ok := assetIDAny.(string)
	require.True(t, ok)

	// List assets
	list := doJSON(t, r, http.MethodGet, "/api/v1/assets", token, nil)
	require.Equal(t, http.StatusOK, list.Code)

	// Get asset
	get := doJSON(t, r, http.MethodGet, "/api/v1/assets/"+assetID, token, nil)
	require.Equal(t, http.StatusOK, get.Code)

	// Portfolio summary
	sum := doJSON(t, r, http.MethodGet, "/api/v1/portfolio/summary", token, nil)
	require.Equal(t, http.StatusOK, sum.Code)

	// Portfolio risk
	risk := doJSON(t, r, http.MethodGet, "/api/v1/portfolio/risk", token, nil)
	require.Equal(t, http.StatusOK, risk.Code)

	// Unauthorized check
	noAuth := doJSON(t, r, http.MethodGet, "/api/v1/assets", "", nil)
	require.Equal(t, http.StatusUnauthorized, noAuth.Code)
}

func doJSON(t *testing.T, r http.Handler, method, path, bearer string, body interface{}) *httptest.ResponseRecorder {
	t.Helper()
	var b []byte
	if body != nil {
		var err error
		b, err = json.Marshal(body)
		require.NoError(t, err)
	}

	req := httptest.NewRequest(method, path, bytes.NewReader(b))
	req.Header.Set("Content-Type", "application/json")
	if bearer != "" {
		req.Header.Set("Authorization", "Bearer "+bearer)
	}
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	return w
}

func makeTestJWT(t *testing.T, secret string, userID uuid.UUID, email string) string {
	t.Helper()
	claims := jwt.MapClaims{
		"sub":   userID.String(),
		"email": email,
		"iat":   time.Now().Unix(),
		"exp":   time.Now().Add(5 * time.Minute).Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := token.SignedString([]byte(secret))
	require.NoError(t, err)
	return signed
}

func newTestLogger(t *testing.T) *zap.Logger {
	t.Helper()
	logger, err := zap.NewDevelopment()
	if err != nil {
		t.Fatalf("failed to create logger: %v", err)
	}
	t.Cleanup(func() { _ = logger.Sync() })
	return logger
}

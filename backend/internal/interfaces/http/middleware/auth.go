package middleware

import (
	"fmt"
	"strings"
	"sync"

	"github.com/MicahParks/keyfunc/v3"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// ContextKey is a type for context keys to avoid collisions
type ContextKey string

const (
	// UserIDKey is the context key for user ID
	UserIDKey ContextKey = "user_id"
	// UserEmailKey is the context key for user email
	UserEmailKey ContextKey = "user_email"
)

// jwksCache holds the cached JWKS keyfunc
//
//nolint:govet // fieldalignment: keep related fields together for readability
type jwksCache struct {
	keyfunc jwt.Keyfunc
	jwksURL string
	mu      sync.RWMutex
}

var globalJWKSCache = &jwksCache{}

// getOrCreateJWKS returns a cached JWKS keyfunc or creates a new one
func getOrCreateJWKS(supabaseURL string) (jwt.Keyfunc, error) {
	jwksURL := fmt.Sprintf("%s/auth/v1/.well-known/jwks.json", supabaseURL)

	globalJWKSCache.mu.RLock()
	if globalJWKSCache.keyfunc != nil && globalJWKSCache.jwksURL == jwksURL {
		kf := globalJWKSCache.keyfunc
		globalJWKSCache.mu.RUnlock()
		return kf, nil
	}
	globalJWKSCache.mu.RUnlock()

	// Create new JWKS keyfunc with refresh
	globalJWKSCache.mu.Lock()
	defer globalJWKSCache.mu.Unlock()

	// Double-check after acquiring write lock
	if globalJWKSCache.keyfunc != nil && globalJWKSCache.jwksURL == jwksURL {
		return globalJWKSCache.keyfunc, nil
	}

	// Use NewDefault which handles background refresh without requiring a context
	// This avoids the "context deadline exceeded" error that occurs when
	// using NewDefaultCtx with a context that gets canceled
	k, err := keyfunc.NewDefault([]string{jwksURL})
	if err != nil {
		return nil, fmt.Errorf("failed to create JWKS keyfunc: %w", err)
	}

	globalJWKSCache.keyfunc = k.Keyfunc
	globalJWKSCache.jwksURL = jwksURL

	return k.Keyfunc, nil
}

// AuthMiddleware validates JWT tokens from Supabase Auth
// It supports both HS256 (legacy) and ES256 (current) signing methods
func AuthMiddleware(jwtSecretOrSupabaseURL string) gin.HandlerFunc {
	// Detect if this is a Supabase URL or a JWT secret
	isSupabaseURL := strings.HasPrefix(jwtSecretOrSupabaseURL, "http")

	return func(c *gin.Context) {
		// Get Authorization header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			response.Unauthorized(c, "Authorization header required")
			c.Abort()
			return
		}

		// Check Bearer prefix
		if !strings.HasPrefix(authHeader, "Bearer ") {
			response.Unauthorized(c, "Invalid authorization format. Use: Bearer <token>")
			c.Abort()
			return
		}

		// Extract token
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		if tokenString == "" {
			response.Unauthorized(c, "Token is required")
			c.Abort()
			return
		}

		var token *jwt.Token
		var err error

		if isSupabaseURL {
			// Use JWKS for ES256 tokens
			kf, jwksErr := getOrCreateJWKS(jwtSecretOrSupabaseURL)
			if jwksErr != nil {
				response.InternalError(c, "Failed to initialize token validation")
				c.Abort()
				return
			}
			token, err = jwt.Parse(tokenString, kf)
		} else {
			// Fallback to HS256 with secret (for backwards compatibility)
			token, err = jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
				// Accept both HMAC and ECDSA
				switch token.Method.(type) {
				case *jwt.SigningMethodHMAC:
					return []byte(jwtSecretOrSupabaseURL), nil
				default:
					return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
				}
			})
		}

		if err != nil {
			response.Unauthorized(c, "Invalid token: "+err.Error())
			c.Abort()
			return
		}

		if !token.Valid {
			response.Unauthorized(c, "Token is not valid")
			c.Abort()
			return
		}

		// Extract claims
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			response.Unauthorized(c, "Invalid token claims")
			c.Abort()
			return
		}

		// Get user ID from "sub" claim (Supabase uses "sub" for user ID)
		sub, ok := claims["sub"].(string)
		if !ok || sub == "" {
			response.Unauthorized(c, "User ID not found in token")
			c.Abort()
			return
		}

		// Validate UUID format
		userID, err := uuid.Parse(sub)
		if err != nil {
			response.Unauthorized(c, "Invalid user ID format")
			c.Abort()
			return
		}

		// Get email from claims if available
		email, _ := claims["email"].(string)

		// Set user info in context
		c.Set(string(UserIDKey), userID)
		c.Set(string(UserEmailKey), email)

		c.Next()
	}
}

// GetUserID extracts user ID from gin context
func GetUserID(c *gin.Context) (uuid.UUID, bool) {
	userID, exists := c.Get(string(UserIDKey))
	if !exists {
		return uuid.Nil, false
	}
	id, ok := userID.(uuid.UUID)
	return id, ok
}

// GetUserEmail extracts user email from gin context
func GetUserEmail(c *gin.Context) string {
	email, exists := c.Get(string(UserEmailKey))
	if !exists || email == nil {
		return ""
	}
	emailStr, ok := email.(string)
	if !ok {
		return ""
	}
	return emailStr
}

// OptionalAuthMiddleware extracts user info if token present, but doesn't require it
func OptionalAuthMiddleware(jwtSecretOrSupabaseURL string) gin.HandlerFunc {
	isSupabaseURL := strings.HasPrefix(jwtSecretOrSupabaseURL, "http")

	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.Next()
			return
		}

		if !strings.HasPrefix(authHeader, "Bearer ") {
			c.Next()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		if tokenString == "" {
			c.Next()
			return
		}

		var token *jwt.Token
		var err error

		if isSupabaseURL {
			kf, jwksErr := getOrCreateJWKS(jwtSecretOrSupabaseURL)
			if jwksErr != nil {
				c.Next()
				return
			}
			token, err = jwt.Parse(tokenString, kf)
		} else {
			token, err = jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
				if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
					return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
				}
				return []byte(jwtSecretOrSupabaseURL), nil
			})
		}

		if err != nil || !token.Valid {
			c.Next()
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.Next()
			return
		}

		sub, ok := claims["sub"].(string)
		if !ok || sub == "" {
			c.Next()
			return
		}

		userID, err := uuid.Parse(sub)
		if err != nil {
			c.Next()
			return
		}

		email, _ := claims["email"].(string)

		c.Set(string(UserIDKey), userID)
		c.Set(string(UserEmailKey), email)

		c.Next()
	}
}

package middleware

import (
	"errors"
	"strings"

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

// AuthMiddleware validates JWT tokens from Supabase Auth
func AuthMiddleware(jwtSecret string) gin.HandlerFunc {
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

		// Parse and validate token
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			// Validate signing method
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, errors.New("invalid signing method")
			}
			return []byte(jwtSecret), nil
		})

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
	email, _ := c.Get(string(UserEmailKey))
	if email == nil {
		return ""
	}
	return email.(string)
}

// OptionalAuthMiddleware extracts user info if token present, but doesn't require it
func OptionalAuthMiddleware(jwtSecret string) gin.HandlerFunc {
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

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, errors.New("invalid signing method")
			}
			return []byte(jwtSecret), nil
		})

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

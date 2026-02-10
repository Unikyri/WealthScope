package middleware

import (
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

// RateLimiter implements rate limiting based on client IP
type RateLimiter struct {
	attempts map[string][]time.Time
	mu       sync.RWMutex
	limit    int
	window   time.Duration
}

// NewRateLimiter creates a new RateLimiter with the specified limit and time window
func NewRateLimiter(limit int, window time.Duration) *RateLimiter {
	rl := &RateLimiter{
		attempts: make(map[string][]time.Time),
		limit:    limit,
		window:   window,
	}

	// Start cleanup goroutine
	go rl.cleanup()

	return rl
}

// Middleware returns a Gin middleware that enforces rate limiting
func (rl *RateLimiter) Middleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()

		if !rl.isAllowed(ip) {
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"success": false,
				"error":   "Too many attempts. Try again later.",
			})
			return
		}

		c.Next()
	}
}

// isAllowed checks if the IP is within the rate limit and records the attempt
func (rl *RateLimiter) isAllowed(ip string) bool {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	now := time.Now()
	windowStart := now.Add(-rl.window)

	// Filter attempts within the window
	var validAttempts []time.Time
	for _, t := range rl.attempts[ip] {
		if t.After(windowStart) {
			validAttempts = append(validAttempts, t)
		}
	}

	// Check if limit exceeded
	if len(validAttempts) >= rl.limit {
		return false
	}

	// Record this attempt
	rl.attempts[ip] = append(validAttempts, now)
	return true
}

// cleanup periodically removes old entries to prevent memory leaks
func (rl *RateLimiter) cleanup() {
	ticker := time.NewTicker(5 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		rl.mu.Lock()
		now := time.Now()
		windowStart := now.Add(-rl.window)

		for ip, attempts := range rl.attempts {
			var validAttempts []time.Time
			for _, t := range attempts {
				if t.After(windowStart) {
					validAttempts = append(validAttempts, t)
				}
			}
			if len(validAttempts) == 0 {
				delete(rl.attempts, ip)
			} else {
				rl.attempts[ip] = validAttempts
			}
		}
		rl.mu.Unlock()
	}
}

// GetRemainingAttempts returns how many attempts are left for an IP
func (rl *RateLimiter) GetRemainingAttempts(ip string) int {
	rl.mu.RLock()
	defer rl.mu.RUnlock()

	now := time.Now()
	windowStart := now.Add(-rl.window)

	var count int
	for _, t := range rl.attempts[ip] {
		if t.After(windowStart) {
			count++
		}
	}

	remaining := rl.limit - count
	if remaining < 0 {
		return 0
	}
	return remaining
}

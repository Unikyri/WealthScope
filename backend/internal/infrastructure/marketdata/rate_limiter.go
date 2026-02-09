package marketdata

import (
	"context"
	"sync"
	"time"
)

// RateLimiter implements a token bucket rate limiter for API calls.
// It allows bursting up to maxTokens requests and refills tokens over time.
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type RateLimiter struct {
	lastRefill time.Time
	maxTokens  int
	tokens     int
	refillRate time.Duration
	mu         sync.Mutex
}

// NewRateLimiter creates a new rate limiter with the given max tokens and refill period.
// maxTokens: maximum number of tokens (requests) allowed in the bucket
// refillPeriod: time period over which all tokens are refilled (e.g., time.Minute for 60 req/min)
func NewRateLimiter(maxTokens int, refillPeriod time.Duration) *RateLimiter {
	if maxTokens <= 0 {
		maxTokens = 1
	}
	refillRate := refillPeriod / time.Duration(maxTokens)
	return &RateLimiter{
		maxTokens:  maxTokens,
		tokens:     maxTokens,
		refillRate: refillRate,
		lastRefill: time.Now(),
	}
}

// refill adds tokens based on elapsed time since last refill.
// Must be called with mutex held.
func (r *RateLimiter) refill() {
	now := time.Now()
	elapsed := now.Sub(r.lastRefill)
	tokensToAdd := int(elapsed / r.refillRate)
	if tokensToAdd > 0 {
		r.tokens += tokensToAdd
		if r.tokens > r.maxTokens {
			r.tokens = r.maxTokens
		}
		r.lastRefill = now
	}
}

// Allow checks if a request is allowed (non-blocking).
// Returns true if allowed (and consumes a token), false otherwise.
func (r *RateLimiter) Allow() bool {
	r.mu.Lock()
	defer r.mu.Unlock()

	r.refill()

	if r.tokens > 0 {
		r.tokens--
		return true
	}
	return false
}

// Wait blocks until a token is available or the context is canceled.
// Returns nil if a token was acquired, or the context error if canceled.
func (r *RateLimiter) Wait(ctx context.Context) error {
	for {
		if r.Allow() {
			return nil
		}

		// Calculate time until next token
		r.mu.Lock()
		waitTime := r.refillRate
		r.mu.Unlock()

		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-time.After(waitTime):
			// Try again
		}
	}
}

// Tokens returns the current number of available tokens.
// Useful for monitoring and testing.
func (r *RateLimiter) Tokens() int {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.refill()
	return r.tokens
}

// Reset resets the rate limiter to its initial state with full tokens.
func (r *RateLimiter) Reset() {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.tokens = r.maxTokens
	r.lastRefill = time.Now()
}

package marketdata

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestNewRateLimiter(t *testing.T) {
	rl := NewRateLimiter(10, time.Minute)
	require.NotNil(t, rl)
	assert.Equal(t, 10, rl.maxTokens)
	assert.Equal(t, 10, rl.tokens)
}

func TestNewRateLimiter_ZeroTokens(t *testing.T) {
	rl := NewRateLimiter(0, time.Minute)
	require.NotNil(t, rl)
	assert.Equal(t, 1, rl.maxTokens) // should default to 1
}

func TestRateLimiter_Allow(t *testing.T) {
	rl := NewRateLimiter(3, time.Minute)

	// Should allow 3 requests
	assert.True(t, rl.Allow())
	assert.True(t, rl.Allow())
	assert.True(t, rl.Allow())

	// Fourth request should be denied
	assert.False(t, rl.Allow())
}

func TestRateLimiter_Tokens(t *testing.T) {
	rl := NewRateLimiter(5, time.Minute)

	assert.Equal(t, 5, rl.Tokens())

	rl.Allow()
	assert.Equal(t, 4, rl.Tokens())

	rl.Allow()
	rl.Allow()
	assert.Equal(t, 2, rl.Tokens())
}

func TestRateLimiter_Reset(t *testing.T) {
	rl := NewRateLimiter(5, time.Minute)

	// Consume all tokens
	for i := 0; i < 5; i++ {
		rl.Allow()
	}
	assert.Equal(t, 0, rl.Tokens())

	// Reset
	rl.Reset()
	assert.Equal(t, 5, rl.Tokens())
}

func TestRateLimiter_Refill(t *testing.T) {
	// Create a rate limiter with 10 tokens per 100ms (fast refill for testing)
	rl := NewRateLimiter(10, 100*time.Millisecond)

	// Consume all tokens
	for i := 0; i < 10; i++ {
		require.True(t, rl.Allow())
	}
	assert.False(t, rl.Allow())

	// Wait for refill (at least 1 token)
	time.Sleep(15 * time.Millisecond) // ~1.5 tokens should refill

	// Should have at least 1 token now
	assert.True(t, rl.Allow())
}

func TestRateLimiter_Wait_Success(t *testing.T) {
	// Fast rate limiter for testing
	rl := NewRateLimiter(2, 50*time.Millisecond)

	// Consume all tokens
	rl.Allow()
	rl.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 100*time.Millisecond)
	defer cancel()

	start := time.Now()
	err := rl.Wait(ctx)
	elapsed := time.Since(start)

	assert.NoError(t, err)
	assert.GreaterOrEqual(t, elapsed.Milliseconds(), int64(20)) // should have waited for refill
}

func TestRateLimiter_Wait_ContextCancelled(t *testing.T) {
	rl := NewRateLimiter(1, time.Hour) // very slow refill

	// Consume the only token
	rl.Allow()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()

	err := rl.Wait(ctx)
	assert.Error(t, err)
	assert.ErrorIs(t, err, context.DeadlineExceeded)
}

func TestRateLimiter_Wait_ImmediateSuccess(t *testing.T) {
	rl := NewRateLimiter(5, time.Minute)

	ctx := context.Background()
	start := time.Now()
	err := rl.Wait(ctx)
	elapsed := time.Since(start)

	assert.NoError(t, err)
	assert.Less(t, elapsed.Milliseconds(), int64(10)) // should be nearly instant
	assert.Equal(t, 4, rl.Tokens())                   // one token consumed
}

func TestRateLimiter_ConcurrentAccess(t *testing.T) {
	rl := NewRateLimiter(100, time.Second)

	// Run 50 goroutines trying to acquire tokens
	done := make(chan bool, 50)
	for i := 0; i < 50; i++ {
		go func() {
			rl.Allow()
			done <- true
		}()
	}

	// Wait for all goroutines
	for i := 0; i < 50; i++ {
		<-done
	}

	// Should have 50 tokens remaining
	assert.Equal(t, 50, rl.Tokens())
}

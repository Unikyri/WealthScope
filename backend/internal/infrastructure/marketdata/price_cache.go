package marketdata

import (
	"sync"
	"time"
)

type cacheEntry[T any] struct {
	value     T
	expiresAt time.Time
}

// TTLCache is a small in-memory cache with TTL, safe for concurrent use.
type TTLCache[T any] struct {
	m   map[string]cacheEntry[T]
	mu  sync.RWMutex
	ttl time.Duration
}

// NewTTLCache creates a new TTLCache with the given TTL.
func NewTTLCache[T any](ttl time.Duration) *TTLCache[T] {
	return &TTLCache[T]{
		ttl: ttl,
		m:   make(map[string]cacheEntry[T]),
	}
}

// Get returns (value, true) when present and not expired.
func (c *TTLCache[T]) Get(key string) (T, bool) {
	c.mu.RLock()
	entry, ok := c.m[key]
	c.mu.RUnlock()

	var zero T
	if !ok {
		return zero, false
	}

	if time.Now().After(entry.expiresAt) {
		c.mu.Lock()
		delete(c.m, key)
		c.mu.Unlock()
		return zero, false
	}

	return entry.value, true
}

// Set stores a value with TTL.
func (c *TTLCache[T]) Set(key string, value T) {
	c.mu.Lock()
	c.m[key] = cacheEntry[T]{
		value:     value,
		expiresAt: time.Now().Add(c.ttl),
	}
	c.mu.Unlock()
}

// Clear removes all entries.
func (c *TTLCache[T]) Clear() {
	c.mu.Lock()
	c.m = make(map[string]cacheEntry[T])
	c.mu.Unlock()
}

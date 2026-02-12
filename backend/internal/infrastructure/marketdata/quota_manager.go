package marketdata

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"gorm.io/gorm"
)

// QuotaManager tracks monthly API request counts per provider and enforces limits.
// It persists counts to the api_quotas table in PostgreSQL.
type QuotaManager struct {
	db     *gorm.DB
	cache  map[string]*quotaEntry
	limits map[string]int // provider_name -> max requests per month
	mu     sync.RWMutex
}

type quotaEntry struct {
	MonthYear string
	Count     int
	MaxCount  int
}

// APIQuotaModel is the GORM model for the api_quotas table
type APIQuotaModel struct {
	CreatedAt    time.Time `gorm:"autoCreateTime"`
	UpdatedAt    time.Time `gorm:"autoUpdateTime"`
	MonthYear    string    `gorm:"column:month_year;not null"`
	ProviderName string    `gorm:"column:provider_name;not null"`
	ID           string    `gorm:"type:uuid;primaryKey;default:gen_random_uuid()"`
	RequestCount int       `gorm:"column:request_count;default:0"`
	MaxAllowed   int       `gorm:"column:max_allowed;not null"`
}

// TableName returns the table name
func (APIQuotaModel) TableName() string {
	return "api_quotas"
}

// NewQuotaManager creates a new QuotaManager.
// limits maps provider names to their monthly request limits.
func NewQuotaManager(db *gorm.DB, limits map[string]int) *QuotaManager {
	return &QuotaManager{
		db:     db,
		limits: limits,
		cache:  make(map[string]*quotaEntry),
	}
}

// currentMonthYear returns the current month in YYYY-MM format.
func currentMonthYear() string {
	return time.Now().UTC().Format("2006-01")
}

// CanUse checks if there is remaining quota for the given provider.
func (qm *QuotaManager) CanUse(ctx context.Context, provider string) (bool, error) {
	maxAllowed, ok := qm.limits[provider]
	if !ok {
		return true, nil // no limit configured = unlimited
	}

	qm.mu.RLock()
	month := currentMonthYear()
	entry, cached := qm.cache[provider]
	qm.mu.RUnlock()

	if cached && entry.MonthYear == month {
		return entry.Count < entry.MaxCount, nil
	}

	// Load from DB
	count, err := qm.loadCount(ctx, provider, month, maxAllowed)
	if err != nil {
		return false, err
	}

	return count < maxAllowed, nil
}

// RecordUsage increments the request count for the given provider.
func (qm *QuotaManager) RecordUsage(ctx context.Context, provider string) error {
	maxAllowed, ok := qm.limits[provider]
	if !ok {
		return nil // no limit configured
	}

	month := currentMonthYear()

	qm.mu.Lock()
	defer qm.mu.Unlock()

	// Upsert count in database
	result := qm.db.WithContext(ctx).Exec(`
		INSERT INTO api_quotas (provider_name, month_year, request_count, max_allowed)
		VALUES (?, ?, 1, ?)
		ON CONFLICT (provider_name, month_year)
		DO UPDATE SET request_count = api_quotas.request_count + 1, updated_at = NOW()
	`, provider, month, maxAllowed)

	if result.Error != nil {
		return fmt.Errorf("failed to record usage for %s: %w", provider, result.Error)
	}

	// Update cache
	entry, exists := qm.cache[provider]
	if !exists || entry.MonthYear != month {
		qm.cache[provider] = &quotaEntry{
			Count:     1,
			MaxCount:  maxAllowed,
			MonthYear: month,
		}
	} else {
		entry.Count++
	}

	return nil
}

// GetUsage returns the current usage and limit for a provider.
func (qm *QuotaManager) GetUsage(ctx context.Context, provider string) (count int, maxAllowed int, err error) {
	maxAllowed, ok := qm.limits[provider]
	if !ok {
		return 0, 0, nil // no limit
	}

	month := currentMonthYear()
	count, err = qm.loadCount(ctx, provider, month, maxAllowed)
	if err != nil {
		return 0, maxAllowed, err
	}
	return count, maxAllowed, nil
}

// GetAllUsage returns usage for all tracked providers.
func (qm *QuotaManager) GetAllUsage(ctx context.Context) (map[string][2]int, error) {
	month := currentMonthYear()
	result := make(map[string][2]int)

	for provider, maxAllowed := range qm.limits {
		count, err := qm.loadCount(ctx, provider, month, maxAllowed)
		if err != nil {
			return nil, err
		}
		result[provider] = [2]int{count, maxAllowed}
	}
	return result, nil
}

// loadCount loads the count from DB and updates cache.
func (qm *QuotaManager) loadCount(ctx context.Context, provider, month string, maxAllowed int) (int, error) {
	var model APIQuotaModel
	result := qm.db.WithContext(ctx).
		Where("provider_name = ? AND month_year = ?", provider, month).
		First(&model)

	count := 0
	if result.Error != nil {
		if !errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return 0, fmt.Errorf("failed to load quota: %w", result.Error)
		}
		// No record yet = 0 usage
	} else {
		count = model.RequestCount
	}

	// Update cache
	qm.mu.Lock()
	qm.cache[provider] = &quotaEntry{
		Count:     count,
		MaxCount:  maxAllowed,
		MonthYear: month,
	}
	qm.mu.Unlock()

	return count, nil
}

// ErrQuotaExceeded is returned when the provider's monthly quota is exhausted.
var ErrQuotaExceeded = errors.New("monthly API quota exceeded")

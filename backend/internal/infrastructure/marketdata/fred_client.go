package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// FREDClient implements MarketDataClient for the FRED API.
// Used for bond yields, interest rate benchmarks, and treasury data.
type FREDClient struct {
	httpClient  *http.Client
	rateLimiter *RateLimiter
	quota       *QuotaManager
	apiKey      string
	baseURL     string
}

// NewFREDClient creates a new FRED API client
func NewFREDClient(apiKey string, rateLimiter *RateLimiter, quota *QuotaManager) *FREDClient {
	return &FREDClient{
		apiKey:  apiKey,
		baseURL: "https://api.stlouisfed.org",
		httpClient: &http.Client{
			Timeout: 15 * time.Second,
		},
		rateLimiter: rateLimiter,
		quota:       quota,
	}
}

// Name returns the provider name
func (c *FREDClient) Name() string {
	return "fred"
}

// Category returns the asset categories this client supports
func (c *FREDClient) Category() services.AssetCategory {
	return services.CategoryBond
}

// SupportsSymbol checks if FRED can provide data for a symbol.
// FRED uses series IDs, not ticker symbols. Common series: DGS10, DGS2, FEDFUNDS
func (c *FREDClient) SupportsSymbol(_ string) bool {
	return false // FRED doesn't work with ticker symbols directly
}

// GetQuote returns the latest value for a FRED series
func (c *FREDClient) GetQuote(ctx context.Context, seriesID string) (*services.Quote, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("rate limit exceeded: %w", err)
		}
	}

	if c.quota != nil {
		canUse, err := c.quota.CanUse(ctx, "fred")
		if err != nil {
			log.Printf("[FRED] quota check error: %v", err)
		}
		if !canUse {
			return nil, ErrQuotaExceeded
		}
	}

	url := fmt.Sprintf("%s/fred/series/observations?series_id=%s&api_key=%s&file_type=json&sort_order=desc&limit=1",
		c.baseURL, seriesID, c.apiKey)

	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch FRED data: %w", err)
	}
	defer resp.Body.Close()

	if c.quota != nil {
		_ = c.quota.RecordUsage(ctx, "fred")
	}

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("FRED API error %d: %s", resp.StatusCode, string(body))
	}

	var result fredObservationResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("failed to decode FRED response: %w", err)
	}

	if len(result.Observations) == 0 {
		return nil, fmt.Errorf("no observations found for series %s", seriesID)
	}

	obs := result.Observations[0]
	var value float64
	if _, err := fmt.Sscanf(obs.Value, "%f", &value); err != nil {
		return nil, fmt.Errorf("failed to parse value: %w", err)
	}

	return &services.Quote{
		Symbol:    seriesID,
		Price:     value,
		Currency:  "USD",
		Source:    "FRED",
		UpdatedAt: time.Now().UTC(),
	}, nil
}

// GetHistoricalPrices returns historical data for a FRED series
func (c *FREDClient) GetHistoricalPrices(ctx context.Context, seriesID string, from, to time.Time) ([]services.PricePoint, error) {
	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("rate limit exceeded: %w", err)
		}
	}

	url := fmt.Sprintf("%s/fred/series/observations?series_id=%s&api_key=%s&file_type=json&observation_start=%s&observation_end=%s",
		c.baseURL, seriesID, c.apiKey, from.Format("2006-01-02"), to.Format("2006-01-02"))

	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch FRED historical data: %w", err)
	}
	defer resp.Body.Close()

	if c.quota != nil {
		_ = c.quota.RecordUsage(ctx, "fred")
	}

	var result fredObservationResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("failed to decode FRED response: %w", err)
	}

	points := make([]services.PricePoint, 0, len(result.Observations))
	for _, obs := range result.Observations {
		var val float64
		if _, err := fmt.Sscanf(obs.Value, "%f", &val); err != nil {
			continue // skip malformed observations
		}
		date, err := time.Parse("2006-01-02", obs.Date)
		if err != nil {
			continue
		}
		points = append(points, services.PricePoint{
			Timestamp: date,
			Close:     val,
		})
	}

	return points, nil
}

// GetBenchmarkRate fetches a specific FRED series for use as a benchmark rate.
// Common series: DGS10 (10Y Treasury), DGS2 (2Y Treasury), FEDFUNDS (Fed Funds Rate)
func (c *FREDClient) GetBenchmarkRate(ctx context.Context, seriesID string) (float64, error) {
	quote, err := c.GetQuote(ctx, seriesID)
	if err != nil {
		return 0, err
	}
	return quote.Price, nil
}

// FRED API response types
type fredObservationResponse struct {
	Observations []fredObservation `json:"observations"`
}

type fredObservation struct {
	Date  string `json:"date"`
	Value string `json:"value"`
}

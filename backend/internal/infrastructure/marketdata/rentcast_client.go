package marketdata

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"time"

	"github.com/Unikyri/WealthScope/backend/internal/domain/services"
)

// RentCastClient implements property data lookup via the RentCast API.
// IMPORTANT: RentCast has a hard limit of 45 requests/month on the free tier.
// All calls MUST go through the QuotaManager.
type RentCastClient struct {
	httpClient  *http.Client
	rateLimiter *RateLimiter
	quota       *QuotaManager
	apiKey      string
	baseURL     string
}

// NewRentCastClient creates a new RentCast API client
func NewRentCastClient(apiKey string, rateLimiter *RateLimiter, quota *QuotaManager) *RentCastClient {
	return &RentCastClient{
		apiKey:  apiKey,
		baseURL: "https://api.rentcast.io/v1",
		httpClient: &http.Client{
			Timeout: 15 * time.Second,
		},
		rateLimiter: rateLimiter,
		quota:       quota,
	}
}

// Name returns the provider name
func (c *RentCastClient) Name() string {
	return "rentcast"
}

// Category returns the asset category
func (c *RentCastClient) Category() services.AssetCategory {
	return services.CategoryRealEstate
}

// SupportsSymbol returns false — RentCast works with addresses, not symbols
func (c *RentCastClient) SupportsSymbol(_ string) bool {
	return false
}

// GetQuote is not applicable for RentCast
func (c *RentCastClient) GetQuote(_ context.Context, _ string) (*services.Quote, error) {
	return nil, fmt.Errorf("RentCast does not support symbol-based quotes")
}

// GetHistoricalPrices is not applicable for RentCast
func (c *RentCastClient) GetHistoricalPrices(_ context.Context, _ string, _, _ time.Time) ([]services.PricePoint, error) {
	return nil, fmt.Errorf("RentCast does not support historical price series")
}

// GetPropertyValue fetches the automated valuation model (AVM) estimate for a property.
func (c *RentCastClient) GetPropertyValue(ctx context.Context, address string) (*PropertyValuation, error) {
	if c.quota != nil {
		canUse, err := c.quota.CanUse(ctx, "rentcast")
		if err != nil {
			log.Printf("[RentCast] quota check error: %v", err)
		}
		if !canUse {
			return nil, ErrQuotaExceeded
		}
	}

	if c.rateLimiter != nil {
		if err := c.rateLimiter.Wait(ctx); err != nil {
			return nil, fmt.Errorf("rate limit exceeded: %w", err)
		}
	}

	endpoint := fmt.Sprintf("%s/avm/value?address=%s", c.baseURL, url.QueryEscape(address))
	req, err := http.NewRequestWithContext(ctx, "GET", endpoint, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}
	req.Header.Set("X-Api-Key", c.apiKey)
	req.Header.Set("Accept", "application/json")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch property value: %w", err)
	}
	defer resp.Body.Close()

	if c.quota != nil {
		_ = c.quota.RecordUsage(ctx, "rentcast")
	}

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("RentCast API error %d: %s", resp.StatusCode, string(body))
	}

	var result rentCastAVMResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("failed to decode RentCast response: %w", err)
	}

	return &PropertyValuation{
		EstimatedValue: result.Price,
		PriceLow:       result.PriceLow,
		PriceHigh:      result.PriceHigh,
		LastSalePrice:  result.LastSalePrice,
		LastSaleDate:   result.LastSaleDate,
		PropertyType:   result.PropertyType,
		Bedrooms:       result.Bedrooms,
		Bathrooms:      result.Bathrooms,
		SquareFootage:  result.SquareFootage,
		Source:         "RentCast",
	}, nil
}

// PropertyValuation contains property valuation data
type PropertyValuation struct {
	LastSaleDate   string  `json:"last_sale_date,omitempty"`
	PropertyType   string  `json:"property_type,omitempty"`
	Source         string  `json:"source"`
	EstimatedValue float64 `json:"estimated_value"`
	PriceLow       float64 `json:"price_low,omitempty"`
	PriceHigh      float64 `json:"price_high,omitempty"`
	LastSalePrice  float64 `json:"last_sale_price,omitempty"`
	SquareFootage  float64 `json:"square_footage,omitempty"`
	Bedrooms       int     `json:"bedrooms,omitempty"`
	Bathrooms      int     `json:"bathrooms,omitempty"`
}

// RentCast API response types
type rentCastAVMResponse struct {
	LastSaleDate  string  `json:"lastSaleDate"`
	PropertyType  string  `json:"propertyType"`
	Price         float64 `json:"price"`
	PriceLow      float64 `json:"priceLow"`
	PriceHigh     float64 `json:"priceHigh"`
	LastSalePrice float64 `json:"lastSalePrice"`
	SquareFootage float64 `json:"squareFootage"`
	Bedrooms      int     `json:"bedrooms"`
	Bathrooms     int     `json:"bathrooms"`
}

package services

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/marketdata"
)

// AutofillService orchestrates API calls to auto-fill extended_data per asset type.
type AutofillService struct {
	registry *marketdata.ProviderRegistry
	fred     *marketdata.FREDClient
	rentcast *marketdata.RentCastClient
}

// NewAutofillService creates a new AutofillService
func NewAutofillService(
	registry *marketdata.ProviderRegistry,
	fred *marketdata.FREDClient,
	rentcast *marketdata.RentCastClient,
) *AutofillService {
	return &AutofillService{
		registry: registry,
		fred:     fred,
		rentcast: rentcast,
	}
}

// Fill attempts to auto-fill extended data for the given asset type using market APIs.
// Returns: filled extended_data map, API sources used, and error (non-fatal: partial data returned on error).
func (s *AutofillService) Fill(ctx context.Context, assetType entities.AssetType, coreData map[string]interface{}) (map[string]interface{}, []string, error) {
	extendedData := make(map[string]interface{})
	var apiSources []string
	var lastErr error

	switch assetType {
	case entities.AssetTypeStock, entities.AssetTypeETF:
		lastErr = s.fillEquity(ctx, coreData, extendedData, &apiSources)

	case entities.AssetTypeBond:
		lastErr = s.fillBond(ctx, coreData, extendedData, &apiSources)

	case entities.AssetTypeCrypto:
		lastErr = s.fillCrypto(ctx, coreData, extendedData, &apiSources)

	case entities.AssetTypeRealEstate:
		lastErr = s.fillRealEstate(ctx, coreData, extendedData, &apiSources)

	case entities.AssetTypeCash:
		lastErr = s.fillCash(ctx, extendedData, &apiSources)

	case entities.AssetTypeCustom, entities.AssetTypeLiability:
		// No autofill for custom assets or liabilities
		return extendedData, nil, nil
	}

	return extendedData, apiSources, lastErr
}

// fillEquity fills stock/ETF data from the equity providers in the registry
func (s *AutofillService) fillEquity(ctx context.Context, coreData, extendedData map[string]interface{}, apiSources *[]string) error {
	ticker := getStringField(coreData, "ticker")
	if ticker == "" {
		return fmt.Errorf("ticker is required for equity autofill")
	}

	// Try to get a quote from the registry (Alpha Vantage -> Finnhub fallback)
	if s.registry != nil {
		quote, err := s.registry.GetQuote(ctx, ticker)
		if err != nil {
			log.Printf("[Autofill] equity quote error for %s: %v", ticker, err)
			return err
		}
		if quote != nil {
			extendedData["current_price"] = quote.Price
			extendedData["source"] = quote.Source
			if quote.Change != 0 {
				extendedData["change"] = quote.Change
				extendedData["change_percent"] = quote.ChangePercent
			}
			if quote.MarketState != "" {
				extendedData["market_state"] = quote.MarketState
			}
			*apiSources = append(*apiSources, quote.Source)
		}
	}

	return nil
}

// fillBond fills bond data from FRED (benchmark yields)
func (s *AutofillService) fillBond(ctx context.Context, _ map[string]interface{}, extendedData map[string]interface{}, apiSources *[]string) error {
	if s.fred == nil {
		return fmt.Errorf("FRED client not available")
	}

	// Fetch 10-year treasury yield as a benchmark
	yield, err := s.fred.GetBenchmarkRate(ctx, "DGS10")
	if err != nil {
		log.Printf("[Autofill] FRED DGS10 error: %v", err)
		return err
	}

	extendedData["yield_to_maturity"] = yield
	extendedData["bond_type"] = "treasury"
	*apiSources = append(*apiSources, "FRED")

	return nil
}

// fillCrypto fills crypto data from the crypto providers in the registry
func (s *AutofillService) fillCrypto(ctx context.Context, coreData, extendedData map[string]interface{}, apiSources *[]string) error {
	symbol := getStringField(coreData, "symbol")
	if symbol == "" {
		return fmt.Errorf("symbol is required for crypto autofill")
	}

	if s.registry != nil {
		quote, err := s.registry.GetQuote(ctx, symbol)
		if err != nil {
			log.Printf("[Autofill] crypto quote error for %s: %v", symbol, err)
			return err
		}
		if quote != nil {
			extendedData["current_price"] = quote.Price
			extendedData["source"] = quote.Source
			*apiSources = append(*apiSources, quote.Source)
		}
	}

	return nil
}

// fillRealEstate fills real estate data from RentCast
func (s *AutofillService) fillRealEstate(ctx context.Context, coreData, extendedData map[string]interface{}, apiSources *[]string) error {
	address := getStringField(coreData, "address")
	if address == "" {
		return fmt.Errorf("address is required for real estate autofill")
	}

	if s.rentcast == nil {
		return fmt.Errorf("RentCast client not available")
	}

	valuation, err := s.rentcast.GetPropertyValue(ctx, address)
	if err != nil {
		log.Printf("[Autofill] RentCast error for %s: %v", address, err)
		return err
	}

	if valuation != nil {
		extendedData["estimated_market_value"] = valuation.EstimatedValue
		if valuation.PriceLow > 0 {
			extendedData["price_range_low"] = valuation.PriceLow
		}
		if valuation.PriceHigh > 0 {
			extendedData["price_range_high"] = valuation.PriceHigh
		}
		if valuation.LastSalePrice > 0 {
			extendedData["last_sale_price"] = valuation.LastSalePrice
		}
		if valuation.LastSaleDate != "" {
			extendedData["last_sale_date"] = valuation.LastSaleDate
		}
		*apiSources = append(*apiSources, "RentCast")
	}

	return nil
}

// fillCash fills cash/bank account data from FRED (benchmark interest rate)
func (s *AutofillService) fillCash(ctx context.Context, extendedData map[string]interface{}, apiSources *[]string) error {
	if s.fred == nil {
		return fmt.Errorf("FRED client not available")
	}

	// Fetch Federal Funds Rate as interest rate benchmark
	rate, err := s.fred.GetBenchmarkRate(ctx, "FEDFUNDS")
	if err != nil {
		log.Printf("[Autofill] FRED FEDFUNDS error: %v", err)
		return err
	}

	extendedData["interest_rate_benchmark"] = rate
	*apiSources = append(*apiSources, "FRED")

	return nil
}

// getStringField safely extracts a string value from a map
func getStringField(data map[string]interface{}, key string) string {
	v, ok := data[key]
	if !ok {
		return ""
	}
	// Handle both string and json.Number
	switch val := v.(type) {
	case string:
		return val
	case json.Number:
		return val.String()
	default:
		return fmt.Sprintf("%v", v)
	}
}

package entities

// AssetFormSchema describes the form fields for a given asset type.
type AssetFormSchema struct {
	AssetType      AssetType         `json:"asset_type"`
	ManualFields   map[string]string `json:"manual_fields"`
	AutoFillFields map[string]string `json:"auto_fill_fields,omitempty"`
	APISources     []string          `json:"api_sources,omitempty"`
}

// AllFormSchemas returns form schemas for all asset types.
func AllFormSchemas() []AssetFormSchema {
	return []AssetFormSchema{
		{
			AssetType: AssetTypeStock,
			ManualFields: map[string]string{
				"ticker":                   "string",
				"quantity":                 "number",
				"purchase_price_per_share": "number",
				"trade_date":               "date",
				"fees":                     "number",
				"account_type":             "taxable | roth_ira | traditional_ira | 401k",
				"broker":                   "string",
			},
			AutoFillFields: map[string]string{
				"company_name":   "string",
				"exchange":       "string",
				"sector":         "string",
				"industry":       "string",
				"current_price":  "number",
				"market_cap":     "number",
				"dividend_yield": "number",
			},
			APISources: []string{"Alpha Vantage", "Finnhub"},
		},
		{
			AssetType: AssetTypeETF,
			ManualFields: map[string]string{
				"ticker":                   "string",
				"quantity":                 "number",
				"purchase_price_per_share": "number",
				"trade_date":               "date",
				"fees":                     "number",
				"broker":                   "string",
			},
			AutoFillFields: map[string]string{
				"fund_name":       "string",
				"expense_ratio":   "number",
				"aum":             "number",
				"sector_exposure": "array",
				"current_price":   "number",
				"dividend_yield":  "number",
			},
			APISources: []string{"Alpha Vantage", "Finnhub"},
		},
		{
			AssetType: AssetTypeBond,
			ManualFields: map[string]string{
				"issuer":                 "string",
				"cusip":                  "string",
				"face_value":             "number",
				"purchase_price_percent": "number",
				"coupon_rate":            "number",
				"coupon_frequency":       "annual | semiannual | quarterly",
				"maturity_date":          "date",
				"trade_date":             "date",
			},
			AutoFillFields: map[string]string{
				"credit_rating":         "string",
				"bond_type":             "treasury | corporate | municipal",
				"yield_to_maturity":     "number",
				"current_price_percent": "number",
			},
			APISources: []string{"Finnhub", "FRED"},
		},
		{
			AssetType: AssetTypeCrypto,
			ManualFields: map[string]string{
				"symbol":         "string",
				"quantity":       "number",
				"purchase_price": "number",
				"purchase_date":  "date",
				"wallet_type":    "exchange | hardware | defi",
				"exchange_name":  "string",
				"staked":         "boolean",
				"staking_yield":  "number",
			},
			AutoFillFields: map[string]string{
				"token_name":         "string",
				"current_price":      "number",
				"market_cap":         "number",
				"circulating_supply": "number",
				"volume_24h":         "number",
			},
			APISources: []string{"CoinGecko", "Binance"},
		},
		{
			AssetType: AssetTypeRealEstate,
			ManualFields: map[string]string{
				"property_type":           "residential | commercial",
				"address":                 "string",
				"purchase_price":          "number",
				"down_payment":            "number",
				"mortgage_amount":         "number",
				"interest_rate":           "number",
				"mortgage_term_years":     "number",
				"annual_property_tax":     "number",
				"annual_insurance":        "number",
				"hoa_fees_annual":         "number",
				"monthly_rent_income":     "number",
				"annual_maintenance_cost": "number",
			},
			AutoFillFields: map[string]string{
				"estimated_market_value": "number",
				"last_sale_price":        "number",
				"property_tax_history":   "array",
				"zestimate_like_value":   "number",
			},
			APISources: []string{"RentCast"},
		},
		{
			AssetType: AssetTypeCash,
			ManualFields: map[string]string{
				"bank_name":    "string",
				"account_type": "checking | savings | cd",
				"balance":      "number",
				"apy":          "number",
				"currency":     "string",
			},
			AutoFillFields: map[string]string{
				"interest_rate_benchmark": "number",
			},
			APISources: []string{"FRED"},
		},
		{
			AssetType: AssetTypeCustom,
			ManualFields: map[string]string{
				"name":                    "string",
				"category":                "string",
				"description":             "string",
				"purchase_price":          "number",
				"current_estimated_value": "number",
				"liquidity_level":         "low | medium | high",
				"risk_level":              "low | medium | high",
			},
		},
		{
			AssetType: AssetTypeLiability,
			ManualFields: map[string]string{
				"liability_type":        "mortgage | credit_card | student_loan | margin | personal_loan",
				"lender":                "string",
				"original_amount":       "number",
				"current_balance":       "number",
				"interest_rate":         "number",
				"minimum_payment":       "number",
				"term_remaining_months": "number",
			},
		},
	}
}

// GetFormSchema returns the form schema for a specific asset type, or nil.
func GetFormSchema(assetType AssetType) *AssetFormSchema {
	for _, schema := range AllFormSchemas() {
		if schema.AssetType == assetType {
			return &schema
		}
	}
	return nil
}

// requiredFieldsByType defines the minimum required core_data fields per asset type.
var requiredFieldsByType = map[AssetType][]string{
	AssetTypeStock:      {"ticker", "quantity", "purchase_price_per_share"},
	AssetTypeETF:        {"ticker", "quantity", "purchase_price_per_share"},
	AssetTypeBond:       {"issuer", "face_value", "coupon_rate", "maturity_date"},
	AssetTypeCrypto:     {"symbol", "quantity", "purchase_price"},
	AssetTypeRealEstate: {"address", "purchase_price"},
	AssetTypeCash:       {"bank_name", "balance"},
	AssetTypeCustom:     {"name", "purchase_price"},
	AssetTypeLiability:  {"liability_type", "current_balance"},
}

// ValidateCoreData checks that the provided core_data contains all required fields
// for the given asset type. Returns nil if valid, or a list of missing fields.
func ValidateCoreData(assetType AssetType, coreData map[string]interface{}) []string {
	required, ok := requiredFieldsByType[assetType]
	if !ok {
		return nil // unknown type, no validation
	}

	var missing []string
	for _, field := range required {
		v, exists := coreData[field]
		if !exists || v == nil {
			missing = append(missing, field)
			continue
		}
		// Check for empty strings
		if s, ok := v.(string); ok && s == "" {
			missing = append(missing, field)
		}
	}
	return missing
}

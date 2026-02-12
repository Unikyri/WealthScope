package entities

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// AssetType represents the type of investment asset
type AssetType string

const (
	AssetTypeStock      AssetType = "stock"
	AssetTypeETF        AssetType = "etf"
	AssetTypeBond       AssetType = "bond"
	AssetTypeCrypto     AssetType = "crypto"
	AssetTypeRealEstate AssetType = "real_estate"
	AssetTypeCash       AssetType = "cash"
	AssetTypeCustom     AssetType = "custom"
	AssetTypeLiability  AssetType = "liability"
)

// ValidAssetTypes contains all valid asset types
var ValidAssetTypes = []AssetType{
	AssetTypeStock,
	AssetTypeETF,
	AssetTypeBond,
	AssetTypeCrypto,
	AssetTypeRealEstate,
	AssetTypeCash,
	AssetTypeCustom,
	AssetTypeLiability,
}

// IsValid checks if the asset type is valid
func (t AssetType) IsValid() bool {
	for _, valid := range ValidAssetTypes {
		if t == valid {
			return true
		}
	}
	return false
}

// Asset represents an investment asset owned by a user.
// Uses a flexible JSONB architecture: CoreData holds user-submitted manual fields,
// ExtendedData holds auto-filled fields from market data APIs.
type Asset struct {
	CreatedAt    time.Time       `json:"created_at"`
	UpdatedAt    time.Time       `json:"updated_at"`
	CoreData     json.RawMessage `json:"core_data"`
	ExtendedData json.RawMessage `json:"extended_data,omitempty"`
	Type         AssetType       `json:"type"`
	Name         string          `json:"name"`
	ID           uuid.UUID       `json:"id"`
	UserID       uuid.UUID       `json:"user_id"`
}

// NewAsset creates a new Asset with required fields
func NewAsset(userID uuid.UUID, assetType AssetType, name string, coreData, extendedData json.RawMessage) *Asset {
	now := time.Now().UTC()
	if coreData == nil {
		coreData = json.RawMessage("{}")
	}
	if extendedData == nil {
		extendedData = json.RawMessage("{}")
	}
	return &Asset{
		ID:           uuid.New(),
		UserID:       userID,
		Type:         assetType,
		Name:         name,
		CoreData:     coreData,
		ExtendedData: extendedData,
		CreatedAt:    now,
		UpdatedAt:    now,
	}
}

// GetCoreDataMap parses CoreData into a map.
func (a *Asset) GetCoreDataMap() (map[string]interface{}, error) {
	var m map[string]interface{}
	if len(a.CoreData) == 0 {
		return make(map[string]interface{}), nil
	}
	if err := json.Unmarshal(a.CoreData, &m); err != nil {
		return nil, err
	}
	return m, nil
}

// GetExtendedDataMap parses ExtendedData into a map.
func (a *Asset) GetExtendedDataMap() (map[string]interface{}, error) {
	var m map[string]interface{}
	if len(a.ExtendedData) == 0 {
		return make(map[string]interface{}), nil
	}
	if err := json.Unmarshal(a.ExtendedData, &m); err != nil {
		return nil, err
	}
	return m, nil
}

// Symbol returns the symbol/ticker from CoreData (for backward compatibility).
func (a *Asset) Symbol() string {
	m, err := a.GetCoreDataMap()
	if err != nil {
		return ""
	}
	// Try "ticker" first (stocks/ETFs), then "symbol" (crypto)
	if t, ok := m["ticker"].(string); ok && t != "" {
		return t
	}
	if s, ok := m["symbol"].(string); ok && s != "" {
		return s
	}
	return ""
}

// SetSymbol sets the ticker/symbol in CoreData.
func (a *Asset) SetSymbol(symbol string) {
	m, _ := a.GetCoreDataMap()
	if m == nil {
		m = make(map[string]interface{})
	}
	m["ticker"] = symbol
	data, _ := json.Marshal(m)
	a.CoreData = data
}

// SetCoreDataField sets a single field in CoreData.
func (a *Asset) SetCoreDataField(key string, value interface{}) {
	m, _ := a.GetCoreDataMap()
	if m == nil {
		m = make(map[string]interface{})
	}
	m[key] = value
	data, _ := json.Marshal(m)
	a.CoreData = data
}

// SetMetadata merges metadata into ExtendedData (for backward compatibility with OCR).
func (a *Asset) SetMetadata(metadataBytes json.RawMessage) {
	var ext map[string]interface{}
	if len(a.ExtendedData) > 0 {
		_ = json.Unmarshal(a.ExtendedData, &ext)
	}
	if ext == nil {
		ext = make(map[string]interface{})
	}
	var meta map[string]interface{}
	if err := json.Unmarshal(metadataBytes, &meta); err == nil {
		for k, v := range meta {
			ext[k] = v
		}
	}
	data, _ := json.Marshal(ext)
	a.ExtendedData = data
}

// SetCoreData updates the core data JSON
func (a *Asset) SetCoreData(data json.RawMessage) {
	a.CoreData = data
	a.UpdatedAt = time.Now().UTC()
}

// SetExtendedData updates the extended data JSON
func (a *Asset) SetExtendedData(data json.RawMessage) {
	a.ExtendedData = data
	a.UpdatedAt = time.Now().UTC()
}

// TotalValue calculates the total value based on core_data fields.
// Tries current_price from extended_data first, then purchase_price from core_data.
func (a *Asset) TotalValue() float64 {
	qty := a.getFloat("quantity", a.CoreData)
	price := a.getFloat("current_price", a.ExtendedData)
	if price == 0 {
		price = a.getFloat("current_price", a.CoreData)
	}
	if price == 0 {
		price = a.getFloat("purchase_price", a.CoreData)
		if price == 0 {
			price = a.getFloat("purchase_price_per_share", a.CoreData)
		}
	}
	if qty == 0 {
		qty = 1 // for real_estate, cash, custom — quantity defaults to 1
	}

	// Special handling for asset types where "value" means something different
	switch a.Type {
	case AssetTypeCash:
		balance := a.getFloat("balance", a.CoreData)
		if balance > 0 {
			return balance
		}
	case AssetTypeRealEstate:
		estimated := a.getFloat("estimated_market_value", a.ExtendedData)
		if estimated > 0 {
			return estimated
		}
		return a.getFloat("purchase_price", a.CoreData)
	case AssetTypeCustom:
		est := a.getFloat("current_estimated_value", a.CoreData)
		if est > 0 {
			return est
		}
		return a.getFloat("purchase_price", a.CoreData)
	case AssetTypeLiability:
		return -a.getFloat("current_balance", a.CoreData)
	}

	return qty * price
}

// TotalCost calculates the total cost at purchase
func (a *Asset) TotalCost() float64 {
	qty := a.getFloat("quantity", a.CoreData)
	price := a.getFloat("purchase_price", a.CoreData)
	if price == 0 {
		price = a.getFloat("purchase_price_per_share", a.CoreData)
	}
	if qty == 0 {
		qty = 1
	}

	switch a.Type {
	case AssetTypeCash:
		return a.getFloat("balance", a.CoreData)
	case AssetTypeRealEstate:
		return a.getFloat("purchase_price", a.CoreData)
	case AssetTypeCustom:
		return a.getFloat("purchase_price", a.CoreData)
	case AssetTypeLiability:
		return -a.getFloat("original_amount", a.CoreData)
	}

	return qty * price
}

// GainLoss calculates the profit or loss
func (a *Asset) GainLoss() *float64 {
	totalValue := a.TotalValue()
	totalCost := a.TotalCost()
	if totalCost == 0 {
		return nil
	}
	gl := totalValue - totalCost
	return &gl
}

// GainLossPercent calculates the percentage gain or loss
func (a *Asset) GainLossPercent() *float64 {
	cost := a.TotalCost()
	if cost == 0 {
		return nil
	}
	gl := a.GainLoss()
	if gl == nil {
		return nil
	}
	pct := (*gl / cost) * 100
	return &pct
}

// getFloat extracts a float64 from a JSON field in the given raw message.
func (a *Asset) getFloat(field string, data json.RawMessage) float64 {
	if len(data) < 2 {
		return 0
	}
	var m map[string]interface{}
	if err := json.Unmarshal(data, &m); err != nil {
		return 0
	}
	v, ok := m[field]
	if !ok {
		return 0
	}
	switch val := v.(type) {
	case float64:
		return val
	case int:
		return float64(val)
	default:
		return 0
	}
}

// GetSymbol extracts the symbol/ticker from core_data.
func (a *Asset) GetSymbol() string {
	m, err := a.GetCoreDataMap()
	if err != nil {
		return ""
	}
	// Try "ticker" (stocks, ETFs), "symbol" (crypto), "cusip" (bonds)
	for _, key := range []string{"ticker", "symbol", "cusip"} {
		if v, ok := m[key]; ok {
			if s, ok := v.(string); ok && s != "" {
				return s
			}
		}
	}
	return ""
}

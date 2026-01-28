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
	AssetTypeGold       AssetType = "gold"
	AssetTypeCash       AssetType = "cash"
	AssetTypeOther      AssetType = "other"
)

// ValidAssetTypes contains all valid asset types
var ValidAssetTypes = []AssetType{
	AssetTypeStock,
	AssetTypeETF,
	AssetTypeBond,
	AssetTypeCrypto,
	AssetTypeRealEstate,
	AssetTypeGold,
	AssetTypeCash,
	AssetTypeOther,
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

// Asset represents an investment asset owned by a user
type Asset struct {
	CreatedAt     time.Time       `json:"created_at"`
	UpdatedAt     time.Time       `json:"updated_at"`
	CurrentPrice  *float64        `json:"current_price,omitempty"`
	Notes         *string         `json:"notes,omitempty"`
	Symbol        *string         `json:"symbol,omitempty"`
	PurchaseDate  *time.Time      `json:"purchase_date,omitempty"`
	Type          AssetType       `json:"type"`
	Name          string          `json:"name"`
	Currency      string          `json:"currency"`
	Metadata      json.RawMessage `json:"metadata,omitempty"`
	Quantity      float64         `json:"quantity"`
	PurchasePrice float64         `json:"purchase_price"`
	ID            uuid.UUID       `json:"id"`
	UserID        uuid.UUID       `json:"user_id"`
}

// NewAsset creates a new Asset with required fields
func NewAsset(userID uuid.UUID, assetType AssetType, name string, quantity, purchasePrice float64, currency string) *Asset {
	now := time.Now().UTC()
	return &Asset{
		ID:            uuid.New(),
		UserID:        userID,
		Type:          assetType,
		Name:          name,
		Quantity:      quantity,
		PurchasePrice: purchasePrice,
		Currency:      currency,
		Metadata:      json.RawMessage("{}"),
		CreatedAt:     now,
		UpdatedAt:     now,
	}
}

// TotalValue calculates the total value of the asset based on current price
// Uses purchase price if current price is not available
func (a *Asset) TotalValue() float64 {
	price := a.PurchasePrice
	if a.CurrentPrice != nil {
		price = *a.CurrentPrice
	}
	return a.Quantity * price
}

// TotalCost calculates the total cost at purchase
func (a *Asset) TotalCost() float64 {
	return a.Quantity * a.PurchasePrice
}

// GainLoss calculates the profit or loss
// Returns nil if current price is not available
func (a *Asset) GainLoss() *float64 {
	if a.CurrentPrice == nil {
		return nil
	}
	gl := a.TotalValue() - a.TotalCost()
	return &gl
}

// GainLossPercent calculates the percentage gain or loss
// Returns nil if current price is not available
func (a *Asset) GainLossPercent() *float64 {
	if a.CurrentPrice == nil || a.TotalCost() == 0 {
		return nil
	}
	gl := a.GainLoss()
	if gl == nil {
		return nil
	}
	pct := (*gl / a.TotalCost()) * 100
	return &pct
}

// SetSymbol sets the symbol for the asset (used for stocks, crypto, etc.)
func (a *Asset) SetSymbol(symbol string) {
	a.Symbol = &symbol
	a.UpdatedAt = time.Now().UTC()
}

// SetCurrentPrice updates the current market price
func (a *Asset) SetCurrentPrice(price float64) {
	a.CurrentPrice = &price
	a.UpdatedAt = time.Now().UTC()
}

// SetMetadata updates the metadata JSON
func (a *Asset) SetMetadata(metadata json.RawMessage) {
	a.Metadata = metadata
	a.UpdatedAt = time.Now().UTC()
}

// SetNotes adds notes to the asset
func (a *Asset) SetNotes(notes string) {
	a.Notes = &notes
	a.UpdatedAt = time.Now().UTC()
}

// SetPurchaseDate sets the purchase date
func (a *Asset) SetPurchaseDate(date time.Time) {
	a.PurchaseDate = &date
	a.UpdatedAt = time.Now().UTC()
}

// Update updates the mutable fields of an asset
func (a *Asset) Update(name string, quantity, purchasePrice float64, currency string) {
	a.Name = name
	a.Quantity = quantity
	a.PurchasePrice = purchasePrice
	a.Currency = currency
	a.UpdatedAt = time.Now().UTC()
}

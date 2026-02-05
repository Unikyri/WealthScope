// Package dto contains Data Transfer Objects for the application layer.
package dto

// ExtractedAsset represents an asset extracted from a document via OCR.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ExtractedAsset struct {
	// Name is the name of the asset (e.g., "Apple Inc.", "Bitcoin")
	Name string `json:"name"`
	// Type is the asset category (stock, etf, bond, crypto, real_estate, gold, cash, other)
	Type string `json:"type"`
	// Symbol is the ticker symbol (optional, e.g., "AAPL", "BTC")
	Symbol *string `json:"symbol,omitempty"`
	// Quantity is the number of units held
	Quantity float64 `json:"quantity"`
	// PurchasePrice is the unit price (or current value if purchase price unknown)
	PurchasePrice float64 `json:"purchase_price"`
	// Currency is the currency code (e.g., "USD", "EUR")
	Currency string `json:"currency"`
	// Confidence is the OCR confidence score (0.0 to 1.0)
	Confidence float64 `json:"confidence"`
}

// OCRResult represents the complete result of OCR document processing.
type OCRResult struct {
	// DocumentType identifies the type of document processed
	// (bank_statement, portfolio_report, investment_summary, other)
	DocumentType string `json:"document_type"`
	// Assets contains all extracted financial assets
	Assets []ExtractedAsset `json:"assets"`
	// RawText contains the raw text extracted from the document (optional, for debugging)
	RawText string `json:"raw_text,omitempty"`
	// Warnings contains any issues encountered during extraction
	Warnings []string `json:"warnings,omitempty"`
}

// OCRRequest represents the request parameters for OCR processing.
type OCRRequest struct {
	// DocumentHint is an optional hint about the document type
	// to improve extraction accuracy
	DocumentHint string `json:"document_hint,omitempty"`
}

// ConfirmOCRAssetsRequest represents the request to confirm and create assets from OCR.
type ConfirmOCRAssetsRequest struct {
	// Assets contains the list of assets to confirm/create
	Assets []ConfirmAsset `json:"assets" binding:"required,min=1,dive"`
}

// ConfirmAsset represents a single asset confirmation with optional edits.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ConfirmAsset struct {
	// Name is the asset name (required)
	Name string `json:"name" binding:"required"`
	// Type is the asset type (required)
	Type string `json:"type" binding:"required"`
	// Symbol is the ticker symbol (optional)
	Symbol *string `json:"symbol,omitempty"`
	// Quantity is the number of units (required, must be positive)
	Quantity float64 `json:"quantity" binding:"required,gt=0"`
	// PurchasePrice is the unit price (required, must be non-negative)
	PurchasePrice float64 `json:"purchase_price" binding:"required,gte=0"`
	// Currency is the currency code (required)
	Currency string `json:"currency" binding:"required"`
}

// OCRResponse represents the API response for OCR processing.
type OCRResponse struct {
	// DocumentType identifies the type of document processed
	DocumentType string `json:"document_type"`
	// Assets contains all extracted financial assets
	Assets []ExtractedAssetResponse `json:"assets"`
	// Warnings contains any issues encountered during extraction
	Warnings []string `json:"warnings,omitempty"`
}

// ExtractedAssetResponse represents an extracted asset in the API response.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ExtractedAssetResponse struct {
	// Name is the name of the asset
	Name string `json:"name"`
	// Type is the asset category
	Type string `json:"type"`
	// Symbol is the ticker symbol (optional)
	Symbol *string `json:"symbol,omitempty"`
	// Quantity is the number of units held
	Quantity float64 `json:"quantity"`
	// PurchasePrice is the unit price
	PurchasePrice float64 `json:"purchase_price"`
	// Currency is the currency code
	Currency string `json:"currency"`
	// Confidence is the OCR confidence score (0.0 to 1.0)
	Confidence float64 `json:"confidence"`
	// TotalValue is the calculated total value (quantity * price)
	TotalValue float64 `json:"total_value"`
}

// ConfirmOCRAssetsResponse represents the response after creating assets from OCR.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ConfirmOCRAssetsResponse struct {
	// CreatedCount is the number of assets successfully created
	CreatedCount int `json:"created_count"`
	// AssetIDs contains the IDs of the created assets
	AssetIDs []string `json:"asset_ids"`
}

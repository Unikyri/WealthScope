// Package dto contains Data Transfer Objects for the application layer.
package dto

// ExtractedAsset represents an asset extracted from a document via OCR.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ExtractedAsset struct {
	Symbol        *string `json:"symbol,omitempty"`
	Name          string  `json:"name"`
	Type          string  `json:"type"`
	Currency      string  `json:"currency"`
	Quantity      float64 `json:"quantity"`
	PurchasePrice float64 `json:"purchase_price"`
	Confidence    float64 `json:"confidence"`
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
	Symbol        *string `json:"symbol,omitempty"`
	Name          string  `json:"name" binding:"required"`
	Type          string  `json:"type" binding:"required"`
	Currency      string  `json:"currency" binding:"required"`
	Quantity      float64 `json:"quantity" binding:"required,gt=0"`
	PurchasePrice float64 `json:"purchase_price" binding:"required,gte=0"`
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
	Symbol        *string `json:"symbol,omitempty"`
	Name          string  `json:"name"`
	Type          string  `json:"type"`
	Currency      string  `json:"currency"`
	Quantity      float64 `json:"quantity"`
	PurchasePrice float64 `json:"purchase_price"`
	Confidence    float64 `json:"confidence"`
	TotalValue    float64 `json:"total_value"`
}

// ConfirmOCRAssetsResponse represents the response after creating assets from OCR.
//
//nolint:govet // fieldalignment: keep logical field order for JSON serialization
type ConfirmOCRAssetsResponse struct {
	AssetIDs     []string `json:"asset_ids"`
	CreatedCount int      `json:"created_count"`
}

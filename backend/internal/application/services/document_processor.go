// Package services contains application layer services.
package services

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"

	"github.com/google/uuid"
	"go.uber.org/zap"

	"github.com/Unikyri/WealthScope/backend/internal/application/dto"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
)

// DocumentProcessor handles OCR processing of financial documents.
type DocumentProcessor struct {
	geminiClient *ai.GeminiClient
	assetRepo    repositories.AssetRepository
	logger       *zap.Logger
}

// NewDocumentProcessor creates a new DocumentProcessor service.
func NewDocumentProcessor(
	geminiClient *ai.GeminiClient,
	assetRepo repositories.AssetRepository,
	logger *zap.Logger,
) *DocumentProcessor {
	if logger == nil {
		logger = zap.NewNop()
	}
	return &DocumentProcessor{
		geminiClient: geminiClient,
		assetRepo:    assetRepo,
		logger:       logger,
	}
}

// ProcessDocument extracts financial assets from a document image using OCR.
func (dp *DocumentProcessor) ProcessDocument(
	ctx context.Context,
	userID uuid.UUID,
	fileData []byte,
	fileName string,
	mimeType string,
	documentHint string,
) (*dto.OCRResult, error) {
	// Validate file size
	if len(fileData) > ai.MaxFileSize {
		return nil, fmt.Errorf("file size exceeds maximum allowed (%d bytes)", ai.MaxFileSize)
	}

	// Validate MIME type
	if !ai.IsValidMIMEType(mimeType) {
		return nil, fmt.Errorf("unsupported file type: %s", mimeType)
	}

	dp.logger.Info("processing document for OCR",
		zap.String("user_id", userID.String()),
		zap.String("filename", fileName),
		zap.String("mime_type", mimeType),
		zap.Int("file_size", len(fileData)),
		zap.String("document_hint", documentHint))

	// Build the appropriate prompt
	prompt := ai.BuildOCRPrompt(documentHint)

	// Call Gemini Vision API
	response, err := dp.geminiClient.AnalyzeImageWithSystemPrompt(
		ctx,
		fileData,
		mimeType,
		prompt,
		ai.OCRSystemPrompt,
	)
	if err != nil {
		dp.logger.Error("gemini vision analysis failed",
			zap.Error(err),
			zap.String("user_id", userID.String()))
		return nil, fmt.Errorf("OCR analysis failed: %w", err)
	}

	// Parse the response
	result, err := dp.parseOCRResponse(response)
	if err != nil {
		dp.logger.Error("failed to parse OCR response",
			zap.Error(err),
			zap.String("response", response))
		return nil, fmt.Errorf("failed to parse OCR response: %w", err)
	}

	// Store raw response for debugging
	result.RawText = response

	dp.logger.Info("OCR processing completed",
		zap.String("user_id", userID.String()),
		zap.String("document_type", result.DocumentType),
		zap.Int("assets_found", len(result.Assets)),
		zap.Int("warnings", len(result.Warnings)))

	return result, nil
}

// parseOCRResponse parses the JSON response from Gemini Vision.
func (dp *DocumentProcessor) parseOCRResponse(response string) (*dto.OCRResult, error) {
	// Clean the response - remove markdown code blocks if present
	cleaned := cleanJSONResponse(response)

	// Try to parse as JSON
	var result dto.OCRResult
	if err := json.Unmarshal([]byte(cleaned), &result); err != nil {
		// Try to extract JSON from the response
		extracted := extractJSON(cleaned)
		if extracted == "" {
			return nil, fmt.Errorf("invalid JSON response: %w", err)
		}
		if err := json.Unmarshal([]byte(extracted), &result); err != nil {
			return nil, fmt.Errorf("failed to parse extracted JSON: %w", err)
		}
	}

	// Validate and normalize each extracted asset
	validAssets := make([]dto.ExtractedAsset, 0, len(result.Assets))
	for i := range result.Assets {
		asset := &result.Assets[i]
		if err := dp.validateAndNormalizeAsset(asset); err != nil {
			result.Warnings = append(result.Warnings,
				fmt.Sprintf("Asset '%s': %v", asset.Name, err))
			continue
		}
		validAssets = append(validAssets, *asset)
	}
	result.Assets = validAssets

	// Normalize document type
	if result.DocumentType == "" {
		result.DocumentType = "other"
	}

	return &result, nil
}

// cleanJSONResponse removes markdown formatting from the response.
func cleanJSONResponse(response string) string {
	// Remove markdown code blocks
	response = strings.TrimSpace(response)

	// Handle ```json ... ``` format
	if strings.HasPrefix(response, "```json") {
		response = strings.TrimPrefix(response, "```json")
		response = strings.TrimSuffix(response, "```")
	} else if strings.HasPrefix(response, "```") {
		response = strings.TrimPrefix(response, "```")
		response = strings.TrimSuffix(response, "```")
	}

	return strings.TrimSpace(response)
}

// extractJSON attempts to extract a JSON object from a string.
func extractJSON(s string) string {
	// Find the first { and last }
	start := strings.Index(s, "{")
	end := strings.LastIndex(s, "}")
	if start == -1 || end == -1 || start >= end {
		return ""
	}
	return s[start : end+1]
}

// validateAndNormalizeAsset validates and normalizes an extracted asset.
func (dp *DocumentProcessor) validateAndNormalizeAsset(asset *dto.ExtractedAsset) error {
	// Validate name
	asset.Name = strings.TrimSpace(asset.Name)
	if asset.Name == "" {
		return errors.New("name is required")
	}

	// Normalize and validate type
	asset.Type = strings.ToLower(strings.TrimSpace(asset.Type))
	if !entities.AssetType(asset.Type).IsValid() {
		dp.logger.Debug("invalid asset type, defaulting to 'other'",
			zap.String("original_type", asset.Type),
			zap.String("asset_name", asset.Name))
		asset.Type = string(entities.AssetTypeOther)
	}

	// Validate quantity
	if asset.Quantity <= 0 {
		return errors.New("quantity must be positive")
	}

	// Validate price
	if asset.PurchasePrice < 0 {
		return errors.New("price cannot be negative")
	}

	// Normalize currency
	asset.Currency = strings.ToUpper(strings.TrimSpace(asset.Currency))
	if asset.Currency == "" {
		asset.Currency = "USD"
	}

	// Normalize symbol
	if asset.Symbol != nil {
		symbol := strings.ToUpper(strings.TrimSpace(*asset.Symbol))
		if symbol == "" || symbol == "NULL" || symbol == "N/A" {
			asset.Symbol = nil
		} else {
			asset.Symbol = &symbol
		}
	}

	// Ensure confidence is in valid range
	if asset.Confidence < 0 {
		asset.Confidence = 0
	} else if asset.Confidence > 1 {
		asset.Confidence = 1
	}

	return nil
}

// CreateAssetsFromOCR creates Asset entities from extracted OCR data.
func (dp *DocumentProcessor) CreateAssetsFromOCR(
	ctx context.Context,
	userID uuid.UUID,
	assets []dto.ConfirmAsset,
) ([]entities.Asset, error) {
	if len(assets) == 0 {
		return nil, errors.New("no assets to create")
	}

	dp.logger.Info("creating assets from OCR",
		zap.String("user_id", userID.String()),
		zap.Int("asset_count", len(assets)))

	created := make([]entities.Asset, 0, len(assets))

	for _, ext := range assets {
		// Validate the confirmed asset
		if err := validateConfirmedAsset(&ext); err != nil {
			return nil, fmt.Errorf("invalid asset '%s': %w", ext.Name, err)
		}

		// Create the asset entity
		asset := entities.NewAsset(
			userID,
			entities.AssetType(ext.Type),
			ext.Name,
			ext.Quantity,
			ext.PurchasePrice,
			ext.Currency,
		)

		// Set symbol if provided
		if ext.Symbol != nil && *ext.Symbol != "" {
			asset.SetSymbol(*ext.Symbol)
		}

		// Add OCR source metadata
		metadata := map[string]interface{}{
			"source": "ocr",
		}
		metadataBytes, _ := json.Marshal(metadata)
		asset.SetMetadata(metadataBytes)

		// Persist to repository
		if err := dp.assetRepo.Create(ctx, asset); err != nil {
			dp.logger.Error("failed to create asset",
				zap.Error(err),
				zap.String("asset_name", ext.Name))
			return nil, fmt.Errorf("failed to create asset '%s': %w", ext.Name, err)
		}

		dp.logger.Debug("asset created from OCR",
			zap.String("asset_id", asset.ID.String()),
			zap.String("asset_name", asset.Name),
			zap.String("asset_type", string(asset.Type)))

		created = append(created, *asset)
	}

	dp.logger.Info("assets created successfully from OCR",
		zap.String("user_id", userID.String()),
		zap.Int("created_count", len(created)))

	return created, nil
}

// validateConfirmedAsset validates a confirmed asset before creation.
func validateConfirmedAsset(asset *dto.ConfirmAsset) error {
	if asset.Name == "" {
		return errors.New("name is required")
	}

	if !entities.AssetType(asset.Type).IsValid() {
		return fmt.Errorf("invalid asset type: %s", asset.Type)
	}

	if asset.Quantity <= 0 {
		return errors.New("quantity must be positive")
	}

	if asset.PurchasePrice < 0 {
		return errors.New("price cannot be negative")
	}

	if asset.Currency == "" {
		return errors.New("currency is required")
	}

	// Validate currency format (3 letter code)
	if matched, _ := regexp.MatchString(`^[A-Z]{3}$`, asset.Currency); !matched {
		return fmt.Errorf("invalid currency format: %s", asset.Currency)
	}

	return nil
}

// ConvertToResponse converts internal OCRResult to API response format.
func ConvertToResponse(result *dto.OCRResult) *dto.OCRResponse {
	assets := make([]dto.ExtractedAssetResponse, 0, len(result.Assets))
	for _, a := range result.Assets {
		assets = append(assets, dto.ExtractedAssetResponse{
			Name:          a.Name,
			Type:          a.Type,
			Symbol:        a.Symbol,
			Quantity:      a.Quantity,
			PurchasePrice: a.PurchasePrice,
			Currency:      a.Currency,
			Confidence:    a.Confidence,
			TotalValue:    a.Quantity * a.PurchasePrice,
		})
	}

	return &dto.OCRResponse{
		DocumentType: result.DocumentType,
		Assets:       assets,
		Warnings:     result.Warnings,
	}
}

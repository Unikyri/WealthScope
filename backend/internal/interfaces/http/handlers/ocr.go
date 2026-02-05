package handlers

import (
	"io"
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/Unikyri/WealthScope/backend/internal/application/dto"
	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// OCRHandler handles OCR document processing HTTP requests.
type OCRHandler struct {
	processor *services.DocumentProcessor
}

// NewOCRHandler creates a new OCRHandler.
func NewOCRHandler(processor *services.DocumentProcessor) *OCRHandler {
	return &OCRHandler{
		processor: processor,
	}
}

// ProcessDocument handles POST /api/v1/ai/ocr
// @Summary Process document with OCR
// @Description Extract financial assets from a document image using OCR
// @Tags AI OCR
// @Accept multipart/form-data
// @Produce json
// @Param document formData file true "Document file (image or PDF)"
// @Param document_hint formData string false "Hint about document type (bank_statement, portfolio_report)"
// @Success 200 {object} response.Response{data=dto.OCRResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/ocr [post]
func (h *OCRHandler) ProcessDocument(c *gin.Context) {
	if h.processor == nil {
		response.InternalError(c, "OCR service is not available")
		return
	}

	// Get authenticated user
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	// Get the uploaded file
	file, header, err := c.Request.FormFile("document")
	if err != nil {
		response.BadRequest(c, "No document file provided. Use form field 'document'")
		return
	}
	defer file.Close()

	// Validate file size
	if header.Size > ai.MaxFileSize {
		response.BadRequest(c, "File too large. Maximum size is 10MB")
		return
	}

	// Get and validate MIME type
	mimeType := header.Header.Get("Content-Type")
	if mimeType == "" {
		// Try to detect from file extension
		mimeType = detectMIMEType(header.Filename)
	}

	if !ai.IsValidMIMEType(mimeType) {
		response.BadRequest(c, "Invalid file type. Supported formats: JPEG, PNG, WebP, GIF, PDF")
		return
	}

	// Read file data
	fileData, err := io.ReadAll(file)
	if err != nil {
		response.InternalError(c, "Failed to read uploaded file")
		return
	}

	// Get optional document hint
	documentHint := c.PostForm("document_hint")

	// Process the document
	result, err := h.processor.ProcessDocument(
		c.Request.Context(),
		userID,
		fileData,
		header.Filename,
		mimeType,
		documentHint,
	)
	if err != nil {
		response.InternalError(c, "OCR processing failed: "+err.Error())
		return
	}

	// Convert to response format
	resp := services.ConvertToResponse(result)
	response.Success(c, resp)
}

// CreateAssetsFromOCR handles POST /api/v1/ai/ocr/confirm
// @Summary Create assets from OCR results
// @Description Confirm and create assets extracted from OCR processing
// @Tags AI OCR
// @Accept json
// @Produce json
// @Param request body dto.ConfirmOCRAssetsRequest true "Assets to create"
// @Success 201 {object} response.Response{data=dto.ConfirmOCRAssetsResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/ocr/confirm [post]
func (h *OCRHandler) CreateAssetsFromOCR(c *gin.Context) {
	if h.processor == nil {
		response.InternalError(c, "OCR service is not available")
		return
	}

	// Get authenticated user
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	// Parse request body
	var req dto.ConfirmOCRAssetsRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request: "+err.Error())
		return
	}

	// Validate at least one asset
	if len(req.Assets) == 0 {
		response.BadRequest(c, "At least one asset is required")
		return
	}

	// Create the assets
	created, err := h.processor.CreateAssetsFromOCR(
		c.Request.Context(),
		userID,
		req.Assets,
	)
	if err != nil {
		response.InternalError(c, "Failed to create assets: "+err.Error())
		return
	}

	// Build response with created asset IDs
	assetIDs := make([]string, 0, len(created))
	for _, asset := range created {
		assetIDs = append(assetIDs, asset.ID.String())
	}

	resp := dto.ConfirmOCRAssetsResponse{
		CreatedCount: len(created),
		AssetIDs:     assetIDs,
	}

	c.JSON(http.StatusCreated, gin.H{
		"success": true,
		"data":    resp,
		"meta": gin.H{
			"request_id": c.GetString("request_id"),
		},
	})
}

// detectMIMEType attempts to detect MIME type from filename.
func detectMIMEType(filename string) string {
	ext := ""
	for i := len(filename) - 1; i >= 0; i-- {
		if filename[i] == '.' {
			ext = filename[i:]
			break
		}
	}

	switch ext {
	case ".jpg", ".jpeg":
		return "image/jpeg"
	case ".png":
		return "image/png"
	case ".webp":
		return "image/webp"
	case ".gif":
		return "image/gif"
	case ".pdf":
		return "application/pdf"
	default:
		return ""
	}
}

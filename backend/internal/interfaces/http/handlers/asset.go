package handlers

import (
	"encoding/json"
	"errors"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	infraRepo "github.com/Unikyri/WealthScope/backend/internal/infrastructure/repositories"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// AssetHandler handles asset-related endpoints
type AssetHandler struct {
	createAssetUC *usecases.CreateAssetUseCase
	getAssetUC    *usecases.GetAssetUseCase
	listAssetsUC  *usecases.ListAssetsUseCase
	updateAssetUC *usecases.UpdateAssetUseCase
	deleteAssetUC *usecases.DeleteAssetUseCase
}

// NewAssetHandler creates a new AssetHandler
func NewAssetHandler(
	createUC *usecases.CreateAssetUseCase,
	getUC *usecases.GetAssetUseCase,
	listUC *usecases.ListAssetsUseCase,
	updateUC *usecases.UpdateAssetUseCase,
	deleteUC *usecases.DeleteAssetUseCase,
) *AssetHandler {
	return &AssetHandler{
		createAssetUC: createUC,
		getAssetUC:    getUC,
		listAssetsUC:  listUC,
		updateAssetUC: updateUC,
		deleteAssetUC: deleteUC,
	}
}

// ====================================
// Request/Response DTOs
// ====================================

// CreateAssetRequest represents the request body for creating an asset
type CreateAssetRequest struct {
	Metadata      map[string]interface{} `json:"metadata,omitempty"`
	Symbol        *string                `json:"symbol,omitempty" binding:"omitempty,max=20"`
	CurrentPrice  *float64               `json:"current_price,omitempty" binding:"omitempty,gte=0"`
	PurchaseDate  *string                `json:"purchase_date,omitempty"`
	Notes         *string                `json:"notes,omitempty" binding:"omitempty,max=1000"`
	Type          string                 `json:"type" binding:"required,oneof=stock etf bond crypto real_estate gold cash other"`
	Name          string                 `json:"name" binding:"required,min=1,max=255"`
	Currency      string                 `json:"currency,omitempty" binding:"omitempty,len=3"`
	Quantity      float64                `json:"quantity" binding:"required,gt=0"`
	PurchasePrice float64                `json:"purchase_price" binding:"required,gte=0"`
}

// UpdateAssetRequest represents the request body for updating an asset
type UpdateAssetRequest struct {
	Metadata      map[string]interface{} `json:"metadata,omitempty"`
	Type          *string                `json:"type,omitempty" binding:"omitempty,oneof=stock etf bond crypto real_estate gold cash other"`
	Name          *string                `json:"name,omitempty" binding:"omitempty,min=1,max=255"`
	Symbol        *string                `json:"symbol,omitempty" binding:"omitempty,max=20"`
	Quantity      *float64               `json:"quantity,omitempty" binding:"omitempty,gt=0"`
	PurchasePrice *float64               `json:"purchase_price,omitempty" binding:"omitempty,gte=0"`
	CurrentPrice  *float64               `json:"current_price,omitempty" binding:"omitempty,gte=0"`
	Currency      *string                `json:"currency,omitempty" binding:"omitempty,len=3"`
	PurchaseDate  *string                `json:"purchase_date,omitempty"`
	Notes         *string                `json:"notes,omitempty" binding:"omitempty,max=1000"`
}

// AssetResponse represents an asset in API responses
type AssetResponse struct {
	Metadata        map[string]interface{} `json:"metadata,omitempty"`
	Symbol          *string                `json:"symbol,omitempty"`
	CurrentPrice    *float64               `json:"current_price,omitempty"`
	PurchaseDate    *string                `json:"purchase_date,omitempty"`
	Notes           *string                `json:"notes,omitempty"`
	GainLoss        *float64               `json:"gain_loss,omitempty"`
	GainLossPercent *float64               `json:"gain_loss_percent,omitempty"`
	ID              string                 `json:"id"`
	Type            string                 `json:"type"`
	Name            string                 `json:"name"`
	Currency        string                 `json:"currency"`
	CreatedAt       string                 `json:"created_at"`
	UpdatedAt       string                 `json:"updated_at"`
	Quantity        float64                `json:"quantity"`
	PurchasePrice   float64                `json:"purchase_price"`
	TotalValue      float64                `json:"total_value"`
	TotalCost       float64                `json:"total_cost"`
}

// ListAssetsResponse represents the response for listing assets
type ListAssetsResponse struct {
	Assets     []AssetResponse `json:"assets"`
	Pagination PaginationInfo  `json:"pagination"`
}

// PaginationInfo represents pagination metadata
type PaginationInfo struct {
	TotalCount int64 `json:"total_count"`
	Page       int   `json:"page"`
	PerPage    int   `json:"per_page"`
	TotalPages int   `json:"total_pages"`
}

// ====================================
// Handlers
// ====================================

// Create handles POST /api/v1/assets
// @Summary Create a new asset
// @Description Creates a new investment asset for the authenticated user
// @Tags assets
// @Accept json
// @Produce json
// @Param request body CreateAssetRequest true "Asset data"
// @Success 201 {object} response.Response{data=AssetResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/assets [post]
func (h *AssetHandler) Create(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	var req CreateAssetRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request: "+err.Error())
		return
	}

	// Parse purchase date if provided
	var purchaseDate *time.Time
	if req.PurchaseDate != nil {
		parsed, parseErr := time.Parse("2006-01-02", *req.PurchaseDate)
		if parseErr != nil {
			response.BadRequest(c, "Invalid purchase_date format. Use YYYY-MM-DD")
			return
		}
		purchaseDate = &parsed
	}

	// Build use case input
	input := usecases.CreateAssetInput{
		UserID:        userID,
		Type:          req.Type,
		Name:          req.Name,
		Symbol:        req.Symbol,
		Quantity:      req.Quantity,
		PurchasePrice: req.PurchasePrice,
		CurrentPrice:  req.CurrentPrice,
		Currency:      req.Currency,
		PurchaseDate:  purchaseDate,
		Metadata:      req.Metadata,
		Notes:         req.Notes,
	}

	asset, err := h.createAssetUC.Execute(c.Request.Context(), input)
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Created(c, toAssetResponse(asset))
}

// List handles GET /api/v1/assets
// @Summary List user's assets
// @Description Returns a paginated list of assets for the authenticated user
// @Tags assets
// @Produce json
// @Param type query string false "Filter by asset type"
// @Param symbol query string false "Filter by symbol"
// @Param currency query string false "Filter by currency"
// @Param page query int false "Page number (default: 1)"
// @Param per_page query int false "Items per page (default: 20, max: 100)"
// @Success 200 {object} response.Response{data=ListAssetsResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/assets [get]
func (h *AssetHandler) List(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	// Parse query parameters
	var typeFilter, symbolFilter, currencyFilter *string
	if t := c.Query("type"); t != "" {
		typeFilter = &t
	}
	if s := c.Query("symbol"); s != "" {
		symbolFilter = &s
	}
	if cur := c.Query("currency"); cur != "" {
		currencyFilter = &cur
	}

	page := 1
	if p := c.Query("page"); p != "" {
		if parsed, err := strconv.Atoi(p); err == nil && parsed > 0 {
			page = parsed
		}
	}

	perPage := 20
	if pp := c.Query("per_page"); pp != "" {
		if parsed, err := strconv.Atoi(pp); err == nil && parsed > 0 && parsed <= 100 {
			perPage = parsed
		}
	}

	input := usecases.ListAssetsInput{
		UserID:   userID,
		Type:     typeFilter,
		Symbol:   symbolFilter,
		Currency: currencyFilter,
		Page:     page,
		PerPage:  perPage,
	}

	output, err := h.listAssetsUC.Execute(c.Request.Context(), input)
	if err != nil {
		response.InternalError(c, "Failed to list assets")
		return
	}

	// Convert to response
	assetResponses := make([]AssetResponse, len(output.Assets))
	for i, asset := range output.Assets {
		assetResponses[i] = toAssetResponse(&asset)
	}

	listResponse := ListAssetsResponse{
		Assets: assetResponses,
		Pagination: PaginationInfo{
			TotalCount: output.TotalCount,
			Page:       output.Page,
			PerPage:    output.PerPage,
			TotalPages: output.TotalPages,
		},
	}

	response.Success(c, listResponse)
}

// GetByID handles GET /api/v1/assets/:id
// @Summary Get asset by ID
// @Description Returns a specific asset by its ID
// @Tags assets
// @Produce json
// @Param id path string true "Asset ID"
// @Success 200 {object} response.Response{data=AssetResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/assets/{id} [get]
func (h *AssetHandler) GetByID(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "Invalid asset ID format")
		return
	}

	asset, err := h.getAssetUC.Execute(c.Request.Context(), assetID, userID)
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Success(c, toAssetResponse(asset))
}

// Update handles PUT /api/v1/assets/:id
// @Summary Update an asset
// @Description Updates an existing asset
// @Tags assets
// @Accept json
// @Produce json
// @Param id path string true "Asset ID"
// @Param request body UpdateAssetRequest true "Updated asset data"
// @Success 200 {object} response.Response{data=AssetResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/assets/{id} [put]
func (h *AssetHandler) Update(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "Invalid asset ID format")
		return
	}

	var req UpdateAssetRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "Invalid request: "+bindErr.Error())
		return
	}

	// Parse purchase date if provided
	var purchaseDate *time.Time
	if req.PurchaseDate != nil {
		parsed, parseErr := time.Parse("2006-01-02", *req.PurchaseDate)
		if parseErr != nil {
			response.BadRequest(c, "Invalid purchase_date format. Use YYYY-MM-DD")
			return
		}
		purchaseDate = &parsed
	}

	input := usecases.UpdateAssetInput{
		AssetID:       assetID,
		UserID:        userID,
		Type:          req.Type,
		Name:          req.Name,
		Symbol:        req.Symbol,
		Quantity:      req.Quantity,
		PurchasePrice: req.PurchasePrice,
		CurrentPrice:  req.CurrentPrice,
		Currency:      req.Currency,
		PurchaseDate:  purchaseDate,
		Metadata:      req.Metadata,
		Notes:         req.Notes,
	}

	asset, err := h.updateAssetUC.Execute(c.Request.Context(), input)
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Success(c, toAssetResponse(asset))
}

// Delete handles DELETE /api/v1/assets/:id
// @Summary Delete an asset
// @Description Deletes an asset by its ID
// @Tags assets
// @Produce json
// @Param id path string true "Asset ID"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/assets/{id} [delete]
func (h *AssetHandler) Delete(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "Invalid asset ID format")
		return
	}

	if err := h.deleteAssetUC.Execute(c.Request.Context(), assetID, userID); err != nil {
		handleAssetError(c, err)
		return
	}

	response.Success(c, map[string]string{"message": "Asset deleted successfully"})
}

// ====================================
// Helper Functions
// ====================================

// toAssetResponse converts an Asset entity to AssetResponse DTO
func toAssetResponse(asset *entities.Asset) AssetResponse {
	resp := AssetResponse{
		ID:              asset.ID.String(),
		Type:            string(asset.Type),
		Name:            asset.Name,
		Symbol:          asset.Symbol,
		Quantity:        asset.Quantity,
		PurchasePrice:   asset.PurchasePrice,
		CurrentPrice:    asset.CurrentPrice,
		Currency:        asset.Currency,
		Notes:           asset.Notes,
		TotalValue:      asset.TotalValue(),
		TotalCost:       asset.TotalCost(),
		GainLoss:        asset.GainLoss(),
		GainLossPercent: asset.GainLossPercent(),
		CreatedAt:       asset.CreatedAt.Format(time.RFC3339),
		UpdatedAt:       asset.UpdatedAt.Format(time.RFC3339),
	}

	if asset.PurchaseDate != nil {
		date := asset.PurchaseDate.Format("2006-01-02")
		resp.PurchaseDate = &date
	}

	// Parse metadata if available
	if len(asset.Metadata) > 2 {
		var metadata map[string]interface{}
		if err := json.Unmarshal(asset.Metadata, &metadata); err == nil {
			resp.Metadata = metadata
		}
	}

	return resp
}

// handleAssetError handles asset-related errors and sends appropriate responses
func handleAssetError(c *gin.Context, err error) {
	switch {
	case errors.Is(err, usecases.ErrAssetNotFound) || errors.Is(err, infraRepo.ErrAssetNotFound):
		response.NotFound(c, "Asset not found")
	case errors.Is(err, usecases.ErrInvalidAssetType):
		response.BadRequest(c, "Invalid asset type")
	case errors.Is(err, usecases.ErrInvalidQuantity):
		response.BadRequest(c, "Quantity must be greater than 0")
	case errors.Is(err, usecases.ErrInvalidPrice):
		response.BadRequest(c, "Price must be non-negative")
	case errors.Is(err, usecases.ErrAssetNameRequired):
		response.BadRequest(c, "Asset name is required")
	case errors.Is(err, usecases.ErrUnauthorizedAccess):
		response.Forbidden(c, "You don't have access to this asset")
	default:
		response.InternalError(c, "An error occurred while processing your request")
	}
}

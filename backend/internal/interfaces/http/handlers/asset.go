package handlers

import (
	"errors"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// AssetHandler handles HTTP requests for asset operations
type AssetHandler struct {
	useCases    *usecases.AssetUseCases
	autofillSvc *services.AutofillService
}

// NewAssetHandler creates a new AssetHandler
func NewAssetHandler(uc *usecases.AssetUseCases, autofillSvc *services.AutofillService) *AssetHandler {
	return &AssetHandler{
		useCases:    uc,
		autofillSvc: autofillSvc,
	}
}

// --- Request/Response DTOs ---

// CreateAssetRequest represents the request body for creating an asset (v2 - JSONB)
type CreateAssetRequest struct {
	CoreData     map[string]interface{} `json:"core_data" binding:"required"`
	ExtendedData map[string]interface{} `json:"extended_data,omitempty"`
	Type         string                 `json:"type" binding:"required"`
	Name         string                 `json:"name" binding:"required"`
}

// UpdateAssetRequest represents the request body for updating an asset
type UpdateAssetRequest struct {
	CoreData     map[string]interface{} `json:"core_data,omitempty"`
	ExtendedData map[string]interface{} `json:"extended_data,omitempty"`
	Type         *string                `json:"type,omitempty"`
	Name         *string                `json:"name,omitempty"`
}

// AutofillRequest represents the request body for auto-filling asset data
type AutofillRequest struct {
	CoreData map[string]interface{} `json:"core_data" binding:"required"`
	Type     string                 `json:"type" binding:"required"`
}

// AssetResponse represents the response for a single asset
//
//nolint:govet // fieldalignment: keep logical field grouping for readability
type AssetResponse struct {
	CoreData        map[string]interface{} `json:"core_data"`
	ExtendedData    map[string]interface{} `json:"extended_data,omitempty"`
	GainLoss        *float64               `json:"gain_loss,omitempty"`
	GainLossPercent *float64               `json:"gain_loss_percent,omitempty"`
	Type            string                 `json:"type"`
	Name            string                 `json:"name"`
	ID              string                 `json:"id"`
	CreatedAt       string                 `json:"created_at"`
	UpdatedAt       string                 `json:"updated_at"`
	TotalValue      float64                `json:"total_value"`
	TotalCost       float64                `json:"total_cost"`
}

// AutofillResponse represents the response for auto-fill
type AutofillResponse struct {
	ExtendedData map[string]interface{} `json:"extended_data"`
	APISources   []string               `json:"api_sources,omitempty"`
}

// ListAssetsResponse represents the response for listing assets
type ListAssetsResponse struct {
	Assets     []AssetResponse `json:"assets"`
	TotalCount int64           `json:"total_count"`
	Page       int             `json:"page"`
	PerPage    int             `json:"per_page"`
	TotalPages int             `json:"total_pages"`
}

// --- Helper functions ---

// toAssetResponse converts an entity.Asset to AssetResponse
func toAssetResponse(asset *entities.Asset) AssetResponse {
	coreData, _ := asset.GetCoreDataMap()
	extendedData, _ := asset.GetExtendedDataMap()

	resp := AssetResponse{
		ID:              asset.ID.String(),
		Type:            string(asset.Type),
		Name:            asset.Name,
		CoreData:        coreData,
		ExtendedData:    extendedData,
		TotalValue:      asset.TotalValue(),
		TotalCost:       asset.TotalCost(),
		GainLoss:        asset.GainLoss(),
		GainLossPercent: asset.GainLossPercent(),
		CreatedAt:       asset.CreatedAt.Format("2006-01-02T15:04:05Z"),
		UpdatedAt:       asset.UpdatedAt.Format("2006-01-02T15:04:05Z"),
	}
	return resp
}

// --- Handler methods ---

// Create handles creating a new asset
// @Summary Create a new asset
// @Tags assets
// @Accept json
// @Produce json
// @Param body body CreateAssetRequest true "Asset data"
// @Success 201 {object} AssetResponse
// @Router /api/v1/assets [post]
func (h *AssetHandler) Create(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	var req CreateAssetRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "invalid request body: "+bindErr.Error())
		return
	}

	output, err := h.useCases.CreateAsset(c.Request.Context(), usecases.CreateAssetInput{
		UserID:       userID,
		Type:         req.Type,
		Name:         req.Name,
		CoreData:     req.CoreData,
		ExtendedData: req.ExtendedData,
	})
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Created(c, toAssetResponse(output.Asset))
}

// List handles listing all assets for the authenticated user
// @Summary List assets
// @Tags assets
// @Produce json
// @Param type query string false "Filter by type"
// @Param symbol query string false "Filter by symbol"
// @Param currency query string false "Filter by currency"
// @Param page query int false "Page number" default(1)
// @Param per_page query int false "Items per page" default(20)
// @Success 200 {object} ListAssetsResponse
// @Router /api/v1/assets [get]
func (h *AssetHandler) List(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	input := usecases.ListAssetsInput{
		UserID: userID,
	}

	// Parse optional filters
	if typeStr := c.Query("type"); typeStr != "" {
		input.Type = &typeStr
	}
	if symbol := c.Query("symbol"); symbol != "" {
		input.Symbol = &symbol
	}
	if currency := c.Query("currency"); currency != "" {
		input.Currency = &currency
	}

	// Parse pagination
	if page := c.Query("page"); page != "" {
		var p int
		if _, parseErr := parseIntFromString(page, &p); parseErr == nil && p > 0 {
			input.Page = p
		}
	}
	if perPage := c.Query("per_page"); perPage != "" {
		var pp int
		if _, parseErr := parseIntFromString(perPage, &pp); parseErr == nil && pp > 0 {
			input.PerPage = pp
		}
	}

	output, err := h.useCases.ListAssets(c.Request.Context(), input)
	if err != nil {
		handleAssetError(c, err)
		return
	}

	// Convert to response
	assetResponses := make([]AssetResponse, len(output.Assets))
	for i := range output.Assets {
		assetResponses[i] = toAssetResponse(&output.Assets[i])
	}

	response.Success(c, ListAssetsResponse{
		Assets:     assetResponses,
		TotalCount: output.TotalCount,
		Page:       output.Page,
		PerPage:    output.PerPage,
		TotalPages: output.TotalPages,
	})
}

// GetByID handles getting a single asset by ID
// @Summary Get asset by ID
// @Tags assets
// @Produce json
// @Param id path string true "Asset ID"
// @Success 200 {object} AssetResponse
// @Router /api/v1/assets/{id} [get]
func (h *AssetHandler) GetByID(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "invalid asset ID")
		return
	}

	output, err := h.useCases.GetAsset(c.Request.Context(), usecases.GetAssetInput{
		AssetID: assetID,
		UserID:  userID,
	})
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Success(c, toAssetResponse(output.Asset))
}

// Update handles updating an existing asset
// @Summary Update an asset
// @Tags assets
// @Accept json
// @Produce json
// @Param id path string true "Asset ID"
// @Param body body UpdateAssetRequest true "Update data"
// @Success 200 {object} AssetResponse
// @Router /api/v1/assets/{id} [put]
func (h *AssetHandler) Update(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "invalid asset ID")
		return
	}

	var req UpdateAssetRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "invalid request body: "+bindErr.Error())
		return
	}

	output, err := h.useCases.UpdateAsset(c.Request.Context(), usecases.UpdateAssetInput{
		AssetID:      assetID,
		UserID:       userID,
		Type:         req.Type,
		Name:         req.Name,
		CoreData:     req.CoreData,
		ExtendedData: req.ExtendedData,
	})
	if err != nil {
		handleAssetError(c, err)
		return
	}

	response.Success(c, toAssetResponse(output.Asset))
}

// Delete handles deleting an asset
// @Summary Delete an asset
// @Tags assets
// @Param id path string true "Asset ID"
// @Success 204
// @Router /api/v1/assets/{id} [delete]
func (h *AssetHandler) Delete(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	assetID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		response.BadRequest(c, "invalid asset ID")
		return
	}

	err = h.useCases.DeleteAsset(c.Request.Context(), usecases.DeleteAssetInput{
		AssetID: assetID,
		UserID:  userID,
	})
	if err != nil {
		handleAssetError(c, err)
		return
	}

	c.JSON(http.StatusNoContent, nil)
}

// Autofill handles auto-filling asset extended data from market APIs
// @Summary Auto-fill asset data
// @Tags assets
// @Accept json
// @Produce json
// @Param body body AutofillRequest true "Asset type and core data"
// @Success 200 {object} AutofillResponse
// @Router /api/v1/assets/autofill [post]
func (h *AssetHandler) Autofill(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "unauthorized")
		return
	}

	var req AutofillRequest
	if bindErr := c.ShouldBindJSON(&req); bindErr != nil {
		response.BadRequest(c, "invalid request body: "+bindErr.Error())
		return
	}

	assetType := entities.AssetType(req.Type)
	if !assetType.IsValid() {
		response.BadRequest(c, "invalid asset type: "+req.Type)
		return
	}

	if h.autofillSvc == nil {
		response.Error(c, http.StatusServiceUnavailable, "SERVICE_UNAVAILABLE", "autofill service not available")
		return
	}

	extendedData, apiSources, err := h.autofillSvc.Fill(c.Request.Context(), assetType, req.CoreData)
	if err != nil {
		response.InternalError(c, "autofill partially failed")
		return
	}

	response.Success(c, AutofillResponse{
		ExtendedData: extendedData,
		APISources:   apiSources,
	})
}

// GetSchemas returns the form schemas for all asset types
// @Summary Get asset form schemas
// @Tags assets
// @Produce json
// @Success 200 {array} entities.AssetFormSchema
// @Router /api/v1/assets/schemas [get]
func (h *AssetHandler) GetSchemas(c *gin.Context) {
	schemas := entities.AllFormSchemas()
	response.Success(c, gin.H{"schemas": schemas})
}

// --- Error handling ---

func handleAssetError(c *gin.Context, err error) {
	switch {
	case errors.Is(err, usecases.ErrInvalidAssetType):
		response.BadRequest(c, err.Error())
	case errors.Is(err, usecases.ErrAssetNotFound):
		response.NotFound(c, "asset not found")
	case errors.Is(err, usecases.ErrUnauthorized):
		response.Forbidden(c, "access denied")
	case errors.Is(err, usecases.ErrMissingRequiredData):
		response.BadRequest(c, err.Error())
	default:
		response.InternalError(c, "internal server error")
	}
}

// parseIntFromString is a helper to parse an int from a string
func parseIntFromString(s string, out *int) (int, error) { //nolint:unparam // kept for API clarity
	var val int
	_, err := strings.NewReader(s).Read([]byte{})
	if err != nil {
		return 0, err
	}
	// Simple parsing
	for _, c := range s {
		if c < '0' || c > '9' {
			return 0, errors.New("invalid integer")
		}
		val = val*10 + int(c-'0')
	}
	*out = val
	return val, nil
}

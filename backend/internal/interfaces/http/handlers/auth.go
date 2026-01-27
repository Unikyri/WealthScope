package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/Unikyri/WealthScope/backend/internal/application/usecases"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// AuthHandler handles authentication-related endpoints
type AuthHandler struct {
	syncUserUseCase *usecases.SyncUserUseCase
}

// NewAuthHandler creates a new AuthHandler
func NewAuthHandler(syncUserUseCase *usecases.SyncUserUseCase) *AuthHandler {
	return &AuthHandler{
		syncUserUseCase: syncUserUseCase,
	}
}

// SyncRequest represents the request body for user sync
type SyncRequest struct {
	DisplayName string `json:"display_name"`
}

// UserResponse represents the user data in responses
type UserResponse struct {
	ID          string `json:"id"`
	Email       string `json:"email"`
	DisplayName string `json:"display_name,omitempty"`
	AvatarURL   string `json:"avatar_url,omitempty"`
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string `json:"updated_at"`
}

// SyncResponse represents the response for user sync
type SyncResponse struct {
	User    UserResponse `json:"user"`
	Created bool         `json:"created"`
}

// Sync handles POST /api/v1/auth/sync
// @Summary Sync user from Supabase Auth
// @Description Synchronizes user data from Supabase Auth to local database
// @Tags auth
// @Accept json
// @Produce json
// @Param request body SyncRequest false "Sync request"
// @Success 200 {object} response.Response{data=SyncResponse}
// @Success 201 {object} response.Response{data=SyncResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/auth/sync [post]
func (h *AuthHandler) Sync(c *gin.Context) {
	// Get user ID from context (set by auth middleware)
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User ID not found in context")
		return
	}

	// Get email from context
	email := middleware.GetUserEmail(c)
	if email == "" {
		response.BadRequest(c, "Email not found in token")
		return
	}

	// Parse request body (optional)
	var req SyncRequest
	_ = c.ShouldBindJSON(&req) // Ignore error, display_name is optional

	// Execute use case
	input := usecases.SyncUserInput{
		UserID:      userID,
		Email:       email,
		DisplayName: req.DisplayName,
	}

	output, err := h.syncUserUseCase.Execute(c.Request.Context(), input)
	if err != nil {
		response.InternalError(c, "Failed to sync user: "+err.Error())
		return
	}

	// Build response
	userResp := UserResponse{
		ID:          output.User.ID.String(),
		Email:       output.User.Email,
		DisplayName: output.User.DisplayName,
		AvatarURL:   output.User.AvatarURL,
		CreatedAt:   output.User.CreatedAt.Format("2006-01-02T15:04:05Z07:00"),
		UpdatedAt:   output.User.UpdatedAt.Format("2006-01-02T15:04:05Z07:00"),
	}

	syncResp := SyncResponse{
		User:    userResp,
		Created: output.Created,
	}

	if output.Created {
		c.JSON(http.StatusCreated, response.Response{
			Success: true,
			Data:    syncResp,
			Meta: &response.Meta{
				RequestID: c.GetString("request_id"),
			},
		})
		return
	}

	response.Success(c, syncResp)
}

// Me handles GET /api/v1/auth/me
// @Summary Get current user
// @Description Returns the currently authenticated user's profile
// @Tags auth
// @Produce json
// @Success 200 {object} response.Response{data=UserResponse}
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Security BearerAuth
// @Router /api/v1/auth/me [get]
func (h *AuthHandler) Me(c *gin.Context) {
	// Get user ID from context
	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User ID not found in context")
		return
	}

	email := middleware.GetUserEmail(c)

	// For now, just return info from the token
	// In the future, we could fetch from database for more details
	userResp := UserResponse{
		ID:    userID.String(),
		Email: email,
	}

	response.Success(c, userResp)
}

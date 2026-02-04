package handlers

import (
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/application/services"
	"github.com/Unikyri/WealthScope/backend/internal/infrastructure/ai"
	"github.com/Unikyri/WealthScope/backend/internal/interfaces/http/middleware"
	"github.com/Unikyri/WealthScope/backend/pkg/response"
)

// ChatHandler handles AI chat-related HTTP requests.
type ChatHandler struct {
	aiService *services.AIService
}

// NewChatHandler creates a new ChatHandler.
func NewChatHandler(aiService *services.AIService) *ChatHandler {
	return &ChatHandler{
		aiService: aiService,
	}
}

// ChatRequest represents the request body for chat endpoint.
type ChatRequest struct {
	ConversationID *uuid.UUID `json:"conversation_id"`
	Message        string     `json:"message" binding:"required,min=1,max=4000"`
}

// CreateConversationRequest represents the request body for creating a conversation.
type CreateConversationRequest struct {
	Title string `json:"title" binding:"max=255"`
}

// UpdateConversationRequest represents the request body for updating a conversation.
type UpdateConversationRequest struct {
	Title string `json:"title" binding:"required,min=1,max=255"`
}

// MessageResponse represents a message in API responses.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type MessageResponse struct {
	ID             uuid.UUID `json:"id"`
	ConversationID uuid.UUID `json:"conversation_id"`
	Role           string    `json:"role"`
	Content        string    `json:"content"`
	CreatedAt      time.Time `json:"created_at"`
}

// ConversationResponse represents a conversation in API responses.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type ConversationResponse struct {
	ID        uuid.UUID `json:"id"`
	Title     string    `json:"title"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// ConversationWithMessagesResponse represents a conversation with messages.
type ConversationWithMessagesResponse struct {
	Conversation ConversationResponse `json:"conversation"`
	Messages     []MessageResponse    `json:"messages"`
}

// ConversationListResponse represents a list of conversations.
type ConversationListResponse struct {
	Conversations []ConversationResponse `json:"conversations"`
	Total         int                    `json:"total"`
	Limit         int                    `json:"limit"`
	Offset        int                    `json:"offset"`
}

// ChatResponse represents the response from the chat endpoint.
//
//nolint:govet // fieldalignment: keep JSON field order for readability
type ChatResponseDTO struct {
	ConversationID uuid.UUID       `json:"conversation_id"`
	UserMessage    MessageResponse `json:"user_message"`
	AIMessage      MessageResponse `json:"ai_message"`
}

// WelcomeResponse represents the welcome endpoint response.
type WelcomeResponse struct {
	Message              string   `json:"message"`
	ConversationStarters []string `json:"conversation_starters"`
}

// Chat handles POST /api/v1/ai/chat
// @Summary Send a message to the AI
// @Description Sends a message to the AI and returns the response
// @Tags AI
// @Accept json
// @Produce json
// @Param request body ChatRequest true "Chat request"
// @Success 200 {object} response.Response{data=ChatResponseDTO}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/chat [post]
func (h *ChatHandler) Chat(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	var req ChatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request: "+err.Error())
		return
	}

	// Build user context (can be enhanced with portfolio data)
	userCtx := ai.UserContext{
		HasPortfolio:  false, // TODO: Get from portfolio service
		PreferredLang: c.GetHeader("Accept-Language"),
	}
	if strings.HasPrefix(userCtx.PreferredLang, "es") {
		userCtx.PreferredLang = "es"
	} else {
		userCtx.PreferredLang = "en"
	}

	chatReq := services.ChatRequest{
		UserID:         userID,
		ConversationID: req.ConversationID,
		Message:        req.Message,
		UserContext:    userCtx,
	}

	result, err := h.aiService.Chat(c.Request.Context(), chatReq)
	if err != nil {
		if strings.Contains(err.Error(), "limit reached") {
			response.BadRequest(c, err.Error())
			return
		}
		response.InternalError(c, "Failed to process chat: "+err.Error())
		return
	}

	response.Success(c, ChatResponseDTO{
		ConversationID: result.ConversationID,
		UserMessage: MessageResponse{
			ID:             result.UserMessage.ID,
			ConversationID: result.UserMessage.ConversationID,
			Role:           result.UserMessage.Role,
			Content:        result.UserMessage.Content,
			CreatedAt:      result.UserMessage.CreatedAt,
		},
		AIMessage: MessageResponse{
			ID:             result.AIMessage.ID,
			ConversationID: result.AIMessage.ConversationID,
			Role:           result.AIMessage.Role,
			Content:        result.AIMessage.Content,
			CreatedAt:      result.AIMessage.CreatedAt,
		},
	})
}

// CreateConversation handles POST /api/v1/ai/conversations
// @Summary Create a new conversation
// @Description Creates a new AI conversation
// @Tags AI
// @Accept json
// @Produce json
// @Param request body CreateConversationRequest true "Create conversation request"
// @Success 201 {object} response.Response{data=ConversationResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/conversations [post]
func (h *ChatHandler) CreateConversation(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	var req CreateConversationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request: "+err.Error())
		return
	}

	conv, err := h.aiService.CreateConversation(c.Request.Context(), userID, req.Title)
	if err != nil {
		if strings.Contains(err.Error(), "limit reached") {
			response.BadRequest(c, err.Error())
			return
		}
		response.InternalError(c, "Failed to create conversation: "+err.Error())
		return
	}

	response.Created(c, ConversationResponse{
		ID:        conv.ID,
		Title:     conv.Title,
		CreatedAt: conv.CreatedAt,
		UpdatedAt: conv.UpdatedAt,
	})
}

// ListConversations handles GET /api/v1/ai/conversations
// @Summary List conversations
// @Description Lists all conversations for the authenticated user
// @Tags AI
// @Produce json
// @Param limit query int false "Limit (default 20, max 100)"
// @Param offset query int false "Offset (default 0)"
// @Success 200 {object} response.Response{data=ConversationListResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/conversations [get]
func (h *ChatHandler) ListConversations(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "20"))
	offset, _ := strconv.Atoi(c.DefaultQuery("offset", "0"))

	conversations, total, err := h.aiService.ListConversations(c.Request.Context(), userID, limit, offset)
	if err != nil {
		response.InternalError(c, "Failed to list conversations: "+err.Error())
		return
	}

	convResponses := make([]ConversationResponse, len(conversations))
	for i, conv := range conversations {
		convResponses[i] = ConversationResponse{
			ID:        conv.ID,
			Title:     conv.Title,
			CreatedAt: conv.CreatedAt,
			UpdatedAt: conv.UpdatedAt,
		}
	}

	response.Success(c, ConversationListResponse{
		Conversations: convResponses,
		Total:         total,
		Limit:         limit,
		Offset:        offset,
	})
}

// GetConversation handles GET /api/v1/ai/conversations/:id
// @Summary Get a conversation
// @Description Gets a conversation with all its messages
// @Tags AI
// @Produce json
// @Param id path string true "Conversation ID"
// @Success 200 {object} response.Response{data=ConversationWithMessagesResponse}
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/conversations/{id} [get]
func (h *ChatHandler) GetConversation(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	convIDStr := c.Param("id")
	convID, err := uuid.Parse(convIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid conversation ID")
		return
	}

	result, err := h.aiService.GetConversation(c.Request.Context(), convID, userID)
	if err != nil {
		response.InternalError(c, "Failed to get conversation: "+err.Error())
		return
	}
	if result == nil {
		response.NotFound(c, "Conversation not found")
		return
	}

	msgResponses := make([]MessageResponse, len(result.Messages))
	for i, msg := range result.Messages {
		msgResponses[i] = MessageResponse{
			ID:             msg.ID,
			ConversationID: msg.ConversationID,
			Role:           msg.Role,
			Content:        msg.Content,
			CreatedAt:      msg.CreatedAt,
		}
	}

	response.Success(c, ConversationWithMessagesResponse{
		Conversation: ConversationResponse{
			ID:        result.Conversation.ID,
			Title:     result.Conversation.Title,
			CreatedAt: result.Conversation.CreatedAt,
			UpdatedAt: result.Conversation.UpdatedAt,
		},
		Messages: msgResponses,
	})
}

// UpdateConversation handles PUT /api/v1/ai/conversations/:id
// @Summary Update a conversation
// @Description Updates a conversation's title
// @Tags AI
// @Accept json
// @Produce json
// @Param id path string true "Conversation ID"
// @Param request body UpdateConversationRequest true "Update request"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/conversations/{id} [put]
func (h *ChatHandler) UpdateConversation(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	convIDStr := c.Param("id")
	convID, err := uuid.Parse(convIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid conversation ID")
		return
	}

	var req UpdateConversationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		response.BadRequest(c, "Invalid request: "+err.Error())
		return
	}

	if err := h.aiService.UpdateConversationTitle(c.Request.Context(), convID, userID, req.Title); err != nil {
		if strings.Contains(err.Error(), "not found") {
			response.NotFound(c, "Conversation not found")
			return
		}
		response.InternalError(c, "Failed to update conversation: "+err.Error())
		return
	}

	response.Success(c, gin.H{"message": "Conversation updated successfully"})
}

// DeleteConversation handles DELETE /api/v1/ai/conversations/:id
// @Summary Delete a conversation
// @Description Deletes a conversation and all its messages
// @Tags AI
// @Produce json
// @Param id path string true "Conversation ID"
// @Success 200 {object} response.Response
// @Failure 400 {object} response.Response
// @Failure 401 {object} response.Response
// @Failure 404 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/conversations/{id} [delete]
func (h *ChatHandler) DeleteConversation(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	userID, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	convIDStr := c.Param("id")
	convID, err := uuid.Parse(convIDStr)
	if err != nil {
		response.BadRequest(c, "Invalid conversation ID")
		return
	}

	if err := h.aiService.DeleteConversation(c.Request.Context(), convID, userID); err != nil {
		if strings.Contains(err.Error(), "not found") {
			response.NotFound(c, "Conversation not found")
			return
		}
		response.InternalError(c, "Failed to delete conversation: "+err.Error())
		return
	}

	response.Success(c, gin.H{"message": "Conversation deleted successfully"})
}

// Welcome handles GET /api/v1/ai/welcome
// @Summary Get welcome message
// @Description Gets a personalized welcome message and conversation starters
// @Tags AI
// @Produce json
// @Success 200 {object} response.Response{data=WelcomeResponse}
// @Failure 401 {object} response.Response
// @Failure 500 {object} response.Response
// @Router /api/v1/ai/welcome [get]
func (h *ChatHandler) Welcome(c *gin.Context) {
	if h.aiService == nil || !h.aiService.IsEnabled() {
		response.InternalError(c, "AI service is not available")
		return
	}

	_, ok := middleware.GetUserID(c)
	if !ok {
		response.Unauthorized(c, "User not authenticated")
		return
	}

	// Get language preference
	lang := c.GetHeader("Accept-Language")
	if strings.HasPrefix(lang, "es") {
		lang = "es"
	} else {
		lang = "en"
	}

	// TODO: Get portfolio status from portfolio service
	hasPortfolio := false

	userCtx := ai.UserContext{
		HasPortfolio:  hasPortfolio,
		PreferredLang: lang,
	}

	response.Success(c, WelcomeResponse{
		Message:              h.aiService.GetWelcomeMessage(userCtx),
		ConversationStarters: h.aiService.GetConversationStarters(hasPortfolio, lang),
	})
}

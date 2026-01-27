package usecases

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// SyncUserInput represents the input for syncing a user
type SyncUserInput struct {
	UserID      uuid.UUID
	Email       string
	DisplayName string
}

// SyncUserOutput represents the output of syncing a user
type SyncUserOutput struct {
	User    *entities.User
	Created bool
}

// SyncUserUseCase handles syncing user from Supabase Auth to local database
type SyncUserUseCase struct {
	userRepo repositories.UserRepository
}

// NewSyncUserUseCase creates a new SyncUserUseCase
func NewSyncUserUseCase(userRepo repositories.UserRepository) *SyncUserUseCase {
	return &SyncUserUseCase{
		userRepo: userRepo,
	}
}

// Execute syncs a user from Supabase Auth to the local database
func (uc *SyncUserUseCase) Execute(ctx context.Context, input SyncUserInput) (*SyncUserOutput, error) {
	// Try to find existing user
	existingUser, err := uc.userRepo.FindByID(ctx, input.UserID)
	if err == nil && existingUser != nil {
		// User exists, update profile if display name provided
		if input.DisplayName != "" {
			existingUser.UpdateProfile(input.DisplayName, "")
			if err := uc.userRepo.Update(ctx, existingUser); err != nil {
				return nil, fmt.Errorf("failed to update user: %w", err)
			}
		}
		return &SyncUserOutput{
			User:    existingUser,
			Created: false,
		}, nil
	}

	// User doesn't exist, create new
	now := time.Now().UTC()
	newUser := &entities.User{
		ID:          input.UserID,
		Email:       input.Email,
		DisplayName: input.DisplayName,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	if err := uc.userRepo.Create(ctx, newUser); err != nil {
		return nil, fmt.Errorf("failed to create user: %w", err)
	}

	return &SyncUserOutput{
		User:    newUser,
		Created: true,
	}, nil
}

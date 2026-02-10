package repositories

import (
	"context"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// UserRepository defines the interface for user data access
type UserRepository interface {
	// Create creates a new user
	Create(ctx context.Context, user *entities.User) error

	// FindByID finds a user by their ID
	FindByID(ctx context.Context, id uuid.UUID) (*entities.User, error)

	// FindByEmail finds a user by their email
	FindByEmail(ctx context.Context, email string) (*entities.User, error)

	// Update updates an existing user
	Update(ctx context.Context, user *entities.User) error

	// Upsert creates or updates a user based on ID
	Upsert(ctx context.Context, user *entities.User) error

	// Delete deletes a user by their ID
	Delete(ctx context.Context, id uuid.UUID) error
}

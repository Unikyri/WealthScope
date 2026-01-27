package repositories

import (
	"context"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
	"github.com/Unikyri/WealthScope/backend/internal/domain/repositories"
)

// Ensure PostgresUserRepository implements UserRepository
var _ repositories.UserRepository = (*PostgresUserRepository)(nil)

// ErrUserNotFound is returned when a user is not found
var ErrUserNotFound = errors.New("user not found")

// PostgresUserRepository implements UserRepository using GORM
type PostgresUserRepository struct {
	db *gorm.DB
}

// NewPostgresUserRepository creates a new PostgresUserRepository
func NewPostgresUserRepository(db *gorm.DB) *PostgresUserRepository {
	return &PostgresUserRepository{db: db}
}

// Create creates a new user
func (r *PostgresUserRepository) Create(ctx context.Context, user *entities.User) error {
	model := FromUserEntity(user)
	result := r.db.WithContext(ctx).Create(model)
	if result.Error != nil {
		return fmt.Errorf("failed to create user: %w", result.Error)
	}
	return nil
}

// FindByID finds a user by their ID
func (r *PostgresUserRepository) FindByID(ctx context.Context, id uuid.UUID) (*entities.User, error) {
	var model UserModel
	result := r.db.WithContext(ctx).Where("id = ?", id).First(&model)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, ErrUserNotFound
		}
		return nil, fmt.Errorf("failed to find user: %w", result.Error)
	}
	return model.ToEntity(), nil
}

// FindByEmail finds a user by their email
func (r *PostgresUserRepository) FindByEmail(ctx context.Context, email string) (*entities.User, error) {
	var model UserModel
	result := r.db.WithContext(ctx).Where("email = ?", email).First(&model)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, ErrUserNotFound
		}
		return nil, fmt.Errorf("failed to find user by email: %w", result.Error)
	}
	return model.ToEntity(), nil
}

// Update updates an existing user
func (r *PostgresUserRepository) Update(ctx context.Context, user *entities.User) error {
	model := FromUserEntity(user)
	result := r.db.WithContext(ctx).Save(model)
	if result.Error != nil {
		return fmt.Errorf("failed to update user: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return ErrUserNotFound
	}
	return nil
}

// Upsert creates or updates a user based on ID
func (r *PostgresUserRepository) Upsert(ctx context.Context, user *entities.User) error {
	model := FromUserEntity(user)

	// Try to find existing user
	var existing UserModel
	result := r.db.WithContext(ctx).Where("id = ?", user.ID).First(&existing)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			// User doesn't exist, create new
			createResult := r.db.WithContext(ctx).Create(model)
			if createResult.Error != nil {
				return fmt.Errorf("failed to create user: %w", createResult.Error)
			}
			return nil
		}
		return fmt.Errorf("failed to check user existence: %w", result.Error)
	}

	// User exists, update
	updateResult := r.db.WithContext(ctx).Model(&existing).Updates(map[string]interface{}{
		"email":        model.Email,
		"display_name": model.DisplayName,
		"avatar_url":   model.AvatarURL,
		"updated_at":   model.UpdatedAt,
	})
	if updateResult.Error != nil {
		return fmt.Errorf("failed to update user: %w", updateResult.Error)
	}

	return nil
}

// Delete deletes a user by their ID
func (r *PostgresUserRepository) Delete(ctx context.Context, id uuid.UUID) error {
	result := r.db.WithContext(ctx).Delete(&UserModel{}, "id = ?", id)
	if result.Error != nil {
		return fmt.Errorf("failed to delete user: %w", result.Error)
	}
	if result.RowsAffected == 0 {
		return ErrUserNotFound
	}
	return nil
}

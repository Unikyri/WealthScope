package repositories

import (
	"time"

	"github.com/google/uuid"

	"github.com/Unikyri/WealthScope/backend/internal/domain/entities"
)

// UserModel is the GORM model for the users table
type UserModel struct {
	CreatedAt   time.Time `gorm:"column:created_at;autoCreateTime"`
	UpdatedAt   time.Time `gorm:"column:updated_at;autoUpdateTime"`
	Email       string    `gorm:"uniqueIndex;not null"`
	DisplayName string    `gorm:"column:display_name"`
	AvatarURL   string    `gorm:"column:avatar_url"`
	ID          uuid.UUID `gorm:"type:uuid;primaryKey"`
}

// TableName returns the table name for GORM
func (UserModel) TableName() string {
	return "users"
}

// ToEntity converts UserModel to domain User entity
func (m *UserModel) ToEntity() *entities.User {
	return &entities.User{
		ID:          m.ID,
		Email:       m.Email,
		DisplayName: m.DisplayName,
		AvatarURL:   m.AvatarURL,
		CreatedAt:   m.CreatedAt,
		UpdatedAt:   m.UpdatedAt,
	}
}

// FromEntity creates a UserModel from a domain User entity
func FromUserEntity(user *entities.User) *UserModel {
	return &UserModel{
		ID:          user.ID,
		Email:       user.Email,
		DisplayName: user.DisplayName,
		AvatarURL:   user.AvatarURL,
		CreatedAt:   user.CreatedAt,
		UpdatedAt:   user.UpdatedAt,
	}
}

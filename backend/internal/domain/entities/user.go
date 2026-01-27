package entities

import (
	"time"

	"github.com/google/uuid"
)

// User represents a user in the system
type User struct {
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	Email       string    `json:"email"`
	DisplayName string    `json:"display_name,omitempty"`
	AvatarURL   string    `json:"avatar_url,omitempty"`
	ID          uuid.UUID `json:"id"`
}

// NewUser creates a new User with the given ID and email
func NewUser(id uuid.UUID, email string) *User {
	now := time.Now().UTC()
	return &User{
		ID:        id,
		Email:     email,
		CreatedAt: now,
		UpdatedAt: now,
	}
}

// UpdateProfile updates the user's profile information
func (u *User) UpdateProfile(displayName, avatarURL string) {
	if displayName != "" {
		u.DisplayName = displayName
	}
	if avatarURL != "" {
		u.AvatarURL = avatarURL
	}
	u.UpdatedAt = time.Now().UTC()
}

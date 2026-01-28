package repositories

import (
	"os"
	"testing"
	"time"

	"github.com/google/uuid"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func openTestGormDB(t *testing.T) *gorm.DB {
	t.Helper()

	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		t.Skip("DATABASE_URL not set; skipping DB-backed tests")
	}

	// PreferSimpleProtocol avoids prepared statement caching conflicts (common with poolers like PgBouncer).
	db, err := gorm.Open(postgres.New(postgres.Config{DSN: dsn, PreferSimpleProtocol: true}), &gorm.Config{
		Logger:                 logger.Default.LogMode(logger.Silent),
		SkipDefaultTransaction: true,
	})
	if err != nil {
		t.Fatalf("failed to connect to DB: %v", err)
	}
	return db
}

func beginTx(t *testing.T, db *gorm.DB) *gorm.DB {
	t.Helper()
	tx := db.Begin()
	if tx.Error != nil {
		t.Fatalf("failed to begin tx: %v", tx.Error)
	}
	t.Cleanup(func() {
		_ = tx.Rollback().Error
	})
	return tx
}

func ensureUserExists(t *testing.T, tx *gorm.DB, userID uuid.UUID) {
	t.Helper()
	// Minimal insert to satisfy FK assets_user_id_fkey; RLS is bypassed for direct DB connection.
	email := "test+" + userID.String() + "@example.com"
	now := time.Now().UTC()
	if err := tx.Exec(
		"INSERT INTO users (id, email, created_at, updated_at) VALUES (?, ?, ?, ?) ON CONFLICT (id) DO NOTHING",
		userID, email, now, now,
	).Error; err != nil {
		t.Fatalf("failed to ensure user exists: %v", err)
	}
}

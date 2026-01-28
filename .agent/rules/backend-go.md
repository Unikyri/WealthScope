---
description: Go backend development rules for WealthScope. Apply when working on backend/ directory, Go files, API handlers, or database operations.
globs:
  - "backend/**/*.go"
  - "**/go.mod"
  - "**/go.sum"
alwaysApply: false
---

# Go Backend Rules - WealthScope

## Architecture

Follow Clean Architecture with these layers:

```
internal/
├── domain/         # Entities, repository interfaces, domain errors
├── application/    # Use cases, business logic orchestration
├── infrastructure/ # External implementations (DB, APIs, cache)
└── interfaces/     # HTTP handlers, DTOs, middleware
```

**Dependency Rule**: Dependencies point inward. Domain has no external dependencies.

## Go Version

Use Go 1.23 features when beneficial:
- Range over functions
- Enhanced type inference
- Improved error handling

## Code Standards

### Naming

```go
// Files: snake_case.go
// Packages: lowercase, single word
// Interfaces: verb-er suffix or behavior description
// Exported: PascalCase
// Private: camelCase

type AssetRepository interface { ... }  // Good
type IAssetRepository interface { ... } // Bad - no I prefix
```

### Error Handling

```go
// Always wrap errors with context
if err != nil {
    return fmt.Errorf("failed to create asset: %w", err)
}

// Use domain errors for business logic
var (
    ErrAssetNotFound = errors.New("asset not found")
    ErrInvalidAssetType = errors.New("invalid asset type")
)

// Never panic in application code
```

### Context

```go
// Context always first parameter
func (s *Service) CreateAsset(ctx context.Context, input CreateAssetInput) (*Asset, error)

// Respect context cancellation
select {
case <-ctx.Done():
    return ctx.Err()
default:
    // continue
}
```

### HTTP Handlers

```go
// Use DTOs for request/response
type CreateAssetRequest struct {
    Type     string  `json:"type" binding:"required,oneof=stock etf bond crypto real_estate gold other"`
    Symbol   string  `json:"symbol" binding:"omitempty,max=20"`
    Name     string  `json:"name" binding:"required,max=255"`
    Quantity float64 `json:"quantity" binding:"required,gt=0"`
}

// Standard response format
func respondSuccess(c *gin.Context, data interface{}) {
    c.JSON(http.StatusOK, Response{
        Success: true,
        Data:    data,
        Meta:    Meta{RequestID: c.GetString("request_id")},
    })
}
```

### Database

```go
// Use GORM with explicit selects
db.Select("id", "name", "value").Where("user_id = ?", userID).Find(&assets)

// Always use parameterized queries (GORM does this automatically)
// Never concatenate user input into queries

// Use transactions for multi-step operations
tx := db.Begin()
defer func() {
    if r := recover(); r != nil {
        tx.Rollback()
    }
}()
```

### Logging

```go
// Use structured logging with Zap
logger.Info("Asset created",
    zap.String("user_id", userID.String()),
    zap.String("asset_id", asset.ID.String()),
    zap.String("type", asset.Type),
)

// Never log sensitive data (passwords, tokens, full financial data)
```

## Project Structure

```go
// cmd/api/main.go - Entry point
func main() {
    cfg := config.Load()
    db := database.Connect(cfg.DatabaseURL)
    router := http.NewRouter(db, cfg)
    router.Run(cfg.Port)
}

// internal/domain/asset/entity.go
type Asset struct {
    ID            uuid.UUID
    UserID        uuid.UUID
    Type          AssetType
    // ...
}

// internal/domain/asset/repository.go
type Repository interface {
    Create(ctx context.Context, asset *Asset) error
    FindByID(ctx context.Context, id uuid.UUID) (*Asset, error)
    // ...
}

// internal/application/asset/create_asset.go
type CreateAssetUseCase struct {
    repo Repository
}
func (uc *CreateAssetUseCase) Execute(ctx context.Context, input Input) (*Asset, error)

// internal/infrastructure/persistence/postgres/asset_repository.go
type PostgresAssetRepository struct {
    db *gorm.DB
}
func (r *PostgresAssetRepository) Create(ctx context.Context, asset *Asset) error
```

## Testing

```go
// Test file naming: *_test.go in same package
// Use table-driven tests

func TestCreateAsset(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateAssetInput
        wantErr bool
    }{
        {"valid stock", CreateAssetInput{Type: "stock", Symbol: "AAPL"}, false},
        {"missing name", CreateAssetInput{Type: "stock"}, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // test logic
        })
    }
}
```

## Security

- Validate all inputs at handler level
- Use RLS in Supabase for data isolation
- Never expose internal errors to clients
- Rate limit sensitive endpoints
- Log security events

## Dependencies

Preferred packages:
- Web: `github.com/gin-gonic/gin`
- ORM: `gorm.io/gorm`
- UUID: `github.com/google/uuid`
- Config: `github.com/spf13/viper`
- Logging: `go.uber.org/zap`
- Validation: `github.com/go-playground/validator/v10`

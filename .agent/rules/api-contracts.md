---
description: API contract design rules for WealthScope. Apply when designing endpoints, creating DTOs, or working on API documentation.
globs:
  - "**/dto/**"
  - "**/handlers/**"
  - "**/interfaces/http/**"
  - "**/*_request.go"
  - "**/*_response.go"
alwaysApply: false
---

# API Contract Rules - WealthScope

## Base URL Structure

```
https://api.wealthscope.app/api/v1/{resource}
```

## HTTP Methods

| Method | Purpose | Idempotent | Request Body |
|--------|---------|------------|--------------|
| GET | Retrieve | Yes | No |
| POST | Create | No | Yes |
| PUT | Replace | Yes | Yes |
| PATCH | Update | Yes | Yes |
| DELETE | Remove | Yes | No |

## Response Format

### Success Response

```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "request_id": "550e8400-e29b-41d4-a716-446655440000",
    "timestamp": "2026-01-26T12:00:00Z"
  }
}
```

### Paginated Response

```json
{
  "success": true,
  "data": [ ... ],
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-01-26T12:00:00Z",
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 100,
      "total_pages": 5,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable error message",
    "details": {
      "field": "quantity",
      "reason": "must be greater than 0"
    }
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-01-26T12:00:00Z"
  }
}
```

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| VALIDATION_ERROR | 400 | Invalid input data |
| UNAUTHORIZED | 401 | Authentication required |
| FORBIDDEN | 403 | Permission denied |
| NOT_FOUND | 404 | Resource not found |
| CONFLICT | 409 | Resource conflict |
| RATE_LIMITED | 429 | Too many requests |
| INTERNAL_ERROR | 500 | Server error |
| SERVICE_UNAVAILABLE | 503 | External service down |

## Request Validation

### Go Validation Tags

```go
type CreateAssetRequest struct {
    Type          string   `json:"type" binding:"required,oneof=stock etf bond crypto real_estate gold other"`
    Symbol        *string  `json:"symbol" binding:"omitempty,max=20,alphanum"`
    Name          string   `json:"name" binding:"required,min=1,max=255"`
    Quantity      float64  `json:"quantity" binding:"required,gt=0"`
    PurchasePrice float64  `json:"purchase_price" binding:"required,gte=0"`
    PurchaseDate  *string  `json:"purchase_date" binding:"omitempty,datetime=2006-01-02"`
    Currency      string   `json:"currency" binding:"omitempty,len=3,alpha"`
    Notes         *string  `json:"notes" binding:"omitempty,max=1000"`
}
```

### Common Validation Rules

- Required strings: `binding:"required,min=1"`
- Optional strings: `binding:"omitempty,max=N"`
- Positive numbers: `binding:"required,gt=0"`
- Non-negative: `binding:"required,gte=0"`
- Enum values: `binding:"required,oneof=value1 value2"`
- Email: `binding:"required,email"`
- UUID: `binding:"required,uuid"`
- Date: `binding:"required,datetime=2006-01-02"`

## Pagination

### Request

```
GET /api/v1/assets?page=1&per_page=20&sort_by=created_at&sort_order=desc
```

### Default Values

- `page`: 1
- `per_page`: 20 (max: 100)
- `sort_by`: created_at
- `sort_order`: desc

## Filtering

Use query parameters for filtering:

```
GET /api/v1/assets?type=stock&min_value=1000&created_after=2024-01-01
```

## Resource Naming

```
/api/v1/assets                    # Collection
/api/v1/assets/{id}               # Single resource
/api/v1/assets/{id}/valuations    # Nested collection
/api/v1/portfolio/summary         # Action on resource
/api/v1/scenarios/run             # Action (verb for non-CRUD)
```

## Authentication

All requests must include:

```
Authorization: Bearer <jwt_token>
```

## Rate Limiting Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1706270460
```

## Request ID Tracing

Every request gets a unique ID:

```go
func RequestIDMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        requestID := c.GetHeader("X-Request-ID")
        if requestID == "" {
            requestID = uuid.New().String()
        }
        c.Set("request_id", requestID)
        c.Header("X-Request-ID", requestID)
        c.Next()
    }
}
```

## Versioning

- Version in URL path: `/api/v1/`
- Breaking changes require new version
- Deprecation via header: `X-API-Deprecated: true`
- Sunset date via header: `X-API-Sunset: 2026-06-01`

## DTOs vs Entities

```go
// Entity (domain layer) - internal representation
type Asset struct {
    ID            uuid.UUID
    UserID        uuid.UUID
    Type          AssetType
    Symbol        *string
    Name          string
    Quantity      decimal.Decimal
    PurchasePrice decimal.Decimal
    // Internal fields
    CreatedAt     time.Time
    UpdatedAt     time.Time
}

// Request DTO - what client sends
type CreateAssetRequest struct {
    Type          string  `json:"type"`
    Symbol        *string `json:"symbol,omitempty"`
    Name          string  `json:"name"`
    Quantity      float64 `json:"quantity"`
    PurchasePrice float64 `json:"purchase_price"`
}

// Response DTO - what client receives
type AssetResponse struct {
    ID            string   `json:"id"`
    Type          string   `json:"type"`
    Symbol        *string  `json:"symbol,omitempty"`
    Name          string   `json:"name"`
    Quantity      float64  `json:"quantity"`
    PurchasePrice float64  `json:"purchase_price"`
    CurrentPrice  *float64 `json:"current_price,omitempty"`
    CurrentValue  *float64 `json:"current_value,omitempty"`
    GainLoss      *float64 `json:"gain_loss,omitempty"`
    CreatedAt     string   `json:"created_at"`
    UpdatedAt     string   `json:"updated_at"`
}
```

## OpenAPI Documentation

Document all endpoints:

```yaml
paths:
  /api/v1/assets:
    post:
      summary: Create a new asset
      tags: [Assets]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateAssetRequest'
      responses:
        '201':
          description: Asset created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/AssetResponse'
        '400':
          $ref: '#/components/responses/ValidationError'
        '401':
          $ref: '#/components/responses/Unauthorized'
```

---
description: Security rules for WealthScope. Apply when implementing authentication, authorization, handling sensitive data, or working with external APIs.
alwaysApply: true
---

# Security Rules - WealthScope

## CRITICAL: Always Apply These Rules

### Authentication

```go
// ALWAYS validate JWT on protected endpoints
func AuthMiddleware(jwtSecret string) gin.HandlerFunc {
    return func(c *gin.Context) {
        token := extractBearerToken(c)
        if token == "" {
            c.AbortWithStatusJSON(401, errorResponse("UNAUTHORIZED", "Missing token"))
            return
        }
        
        claims, err := validateJWT(token, jwtSecret)
        if err != nil {
            c.AbortWithStatusJSON(401, errorResponse("INVALID_TOKEN", "Invalid or expired token"))
            return
        }
        
        c.Set("user_id", claims.Subject)
        c.Next()
    }
}
```

### Authorization

```go
// ALWAYS verify resource ownership
func (h *AssetHandler) GetAsset(c *gin.Context) {
    userID := c.GetString("user_id")  // From auth middleware
    assetID := c.Param("id")
    
    asset, err := h.repo.FindByID(c, assetID)
    if err != nil {
        c.JSON(404, errorResponse("NOT_FOUND", "Asset not found"))
        return
    }
    
    // CRITICAL: Check ownership
    if asset.UserID.String() != userID {
        c.JSON(403, errorResponse("FORBIDDEN", "Access denied"))
        return
    }
    
    c.JSON(200, asset)
}
```

### Input Validation

```go
// ALWAYS validate user input
type CreateAssetRequest struct {
    Type     string  `binding:"required,oneof=stock etf bond crypto real_estate gold other"`
    Symbol   string  `binding:"omitempty,max=20,alphanum"`  // Prevent injection
    Name     string  `binding:"required,max=255"`
    Quantity float64 `binding:"required,gt=0,lt=1000000000"` // Reasonable limits
}

// NEVER trust client input for:
// - User ID (extract from JWT)
// - Permissions/roles
// - Prices/valuations (validate server-side)
```

### SQL Injection Prevention

```go
// ALWAYS use parameterized queries
// GORM does this automatically

// GOOD
db.Where("user_id = ?", userID).Find(&assets)
db.Where("symbol = ? AND type = ?", symbol, assetType).First(&asset)

// BAD - Never do this
db.Raw("SELECT * FROM assets WHERE user_id = '" + userID + "'")
```

### XSS Prevention

```dart
// ALWAYS sanitize user-generated content before display
// Flutter's Text widget escapes by default, but be careful with:
// - HTML rendering (avoid or use html_unescape carefully)
// - WebViews
// - Markdown rendering

// GOOD
Text(asset.name);  // Automatically escaped

// DANGEROUS
HtmlWidget(userContent);  // Could contain scripts
```

### Sensitive Data

```go
// NEVER log sensitive data
logger.Info("User logged in",
    zap.String("user_id", user.ID),
    zap.String("email", maskEmail(user.Email)),  // Mask it
    // NEVER: zap.String("password", password)
    // NEVER: zap.String("token", token)
    // NEVER: zap.Any("portfolio", portfolio)  // Full financial data
)

func maskEmail(email string) string {
    parts := strings.Split(email, "@")
    if len(parts) != 2 {
        return "***"
    }
    return parts[0][:min(2, len(parts[0]))] + "***@" + parts[1]
}

// NEVER expose internal errors to clients
if err != nil {
    logger.Error("Database error", zap.Error(err))  // Log full error
    c.JSON(500, errorResponse("INTERNAL_ERROR", "An error occurred"))  // Generic message
}
```

### API Keys

```go
// NEVER hardcode secrets
// ALWAYS use environment variables

// GOOD
apiKey := os.Getenv("OPENAI_API_KEY")
if apiKey == "" {
    log.Fatal("OPENAI_API_KEY not set")
}

// BAD
apiKey := "sk-1234567890abcdef..."  // Never commit this
```

### Rate Limiting

```go
// ALWAYS rate limit sensitive endpoints
func RateLimitMiddleware(requestsPerMinute int) gin.HandlerFunc {
    limiter := rate.NewLimiter(rate.Every(time.Minute/time.Duration(requestsPerMinute)), requestsPerMinute)
    
    return func(c *gin.Context) {
        if !limiter.Allow() {
            c.AbortWithStatusJSON(429, errorResponse("RATE_LIMITED", "Too many requests"))
            return
        }
        c.Next()
    }
}

// Apply stricter limits to:
// - Authentication endpoints
// - AI/expensive operations
// - File uploads
```

### HTTPS

```go
// ALWAYS redirect HTTP to HTTPS in production
// ALWAYS set secure headers

func SecurityHeaders() gin.HandlerFunc {
    return func(c *gin.Context) {
        c.Header("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
        c.Header("X-Content-Type-Options", "nosniff")
        c.Header("X-Frame-Options", "DENY")
        c.Header("X-XSS-Protection", "1; mode=block")
        c.Header("Content-Security-Policy", "default-src 'self'")
        c.Next()
    }
}
```

### CORS

```go
// ALWAYS configure CORS properly
func CORSConfig() cors.Config {
    return cors.Config{
        AllowOrigins:     []string{"https://wealthscope.app"},  // Specific origins
        AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE"},
        AllowHeaders:     []string{"Authorization", "Content-Type"},
        AllowCredentials: true,
        MaxAge:           12 * time.Hour,
    }
}

// NEVER use AllowAllOrigins in production
```

### External API Calls

```go
// ALWAYS validate URLs before fetching
func validateExternalURL(urlStr string) error {
    u, err := url.Parse(urlStr)
    if err != nil {
        return err
    }
    
    // Block internal networks
    if u.Hostname() == "localhost" || strings.HasPrefix(u.Hostname(), "127.") {
        return errors.New("internal URLs not allowed")
    }
    
    // Allowlist external services
    allowed := []string{"api.openai.com", "query1.finance.yahoo.com"}
    for _, host := range allowed {
        if strings.HasSuffix(u.Hostname(), host) {
            return nil
        }
    }
    
    return errors.New("host not in allowlist")
}
```

### Prompt Injection Prevention

```go
// ALWAYS sanitize user input before sending to LLMs
func sanitizeForAI(input string) string {
    dangerous := []string{
        "ignore previous instructions",
        "disregard all prior",
        "system:",
        "assistant:",
        "you are now",
    }
    
    sanitized := strings.ToLower(input)
    for _, pattern := range dangerous {
        if strings.Contains(sanitized, pattern) {
            return "[FILTERED INPUT]"
        }
    }
    return input
}

// ALWAYS validate AI responses
func validateAIResponse(response string) error {
    // Check for unexpectedly long responses
    // Check for unexpected formats
    // Validate JSON structure if expected
}
```

### File Uploads

```go
// ALWAYS validate file uploads
func validateUpload(file *multipart.FileHeader) error {
    // Check size
    if file.Size > 10*1024*1024 {  // 10MB max
        return errors.New("file too large")
    }
    
    // Check extension
    ext := strings.ToLower(filepath.Ext(file.Filename))
    allowed := map[string]bool{".jpg": true, ".jpeg": true, ".png": true, ".pdf": true}
    if !allowed[ext] {
        return errors.New("file type not allowed")
    }
    
    // Check MIME type (don't trust extension alone)
    // Scan for malware (in production)
    
    return nil
}
```

### Flutter Security

```dart
// ALWAYS use flutter_secure_storage for tokens
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);

// NEVER store tokens in SharedPreferences
// SharedPreferences are not encrypted

// ALWAYS use HTTPS
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.wealthscope.app',  // HTTPS only
));

// Certificate pinning (for production)
dio.httpClientAdapter = IOHttpClientAdapter()
  ..onHttpClientCreate = (client) {
    client.badCertificateCallback = (cert, host, port) => false;
    return client;
  };
```

## Security Checklist

Before every PR:

- [ ] Authentication required on protected endpoints
- [ ] Resource ownership verified
- [ ] Input validated and sanitized
- [ ] No sensitive data in logs
- [ ] No hardcoded secrets
- [ ] SQL queries parameterized
- [ ] Rate limiting on sensitive endpoints
- [ ] Error messages don't leak internal details

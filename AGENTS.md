# WealthScope - AI Agent Instructions

## Project Overview

WealthScope is a mobile-first investment intelligence application that consolidates all user assets (stocks, real estate, gold, bonds, crypto) into a single intelligent dashboard. The product acts as a "personal CFO" providing AI-powered insights.

**Timeline**: 3-week hackathon  
**Team**: 1 Senior Full-Stack (Go backend) + 1 Junior Frontend (Flutter)

## Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| Backend | Go | 1.23 |
| Web Framework | Gin | Latest |
| ORM | GORM | Latest |
| Frontend | Flutter | 3.x |
| State Management | Riverpod | 2.x |
| Database | PostgreSQL | Supabase |
| Auth | Supabase Auth | - |
| AI/LLM | OpenAI GPT-4o | - |
| Payments | RevenueCat | - |
| Hosting | Railway (backend) | - |

## Project Structure

```
WealthScope/
├── backend/                 # Go 1.23 backend
│   ├── cmd/api/            # Entry point
│   ├── internal/
│   │   ├── domain/         # Entities, interfaces
│   │   ├── application/    # Use cases
│   │   ├── infrastructure/ # External implementations
│   │   └── interfaces/     # HTTP handlers, DTOs
│   ├── pkg/                # Shared utilities
│   └── migrations/         # SQL migrations
├── frontend/               # Flutter app
│   ├── lib/
│   │   ├── core/          # Config, theme, network
│   │   ├── features/      # Feature modules
│   │   └── shared/        # Shared widgets
│   └── test/
└── docs/                   # Additional documentation
```

## Architecture Principles

1. **Clean Architecture**: Domain logic isolated from frameworks
2. **API-First**: Backend exposes REST API, frontend consumes it
3. **Feature-First** (Flutter): Each feature self-contained
4. **Repository Pattern**: Data access abstracted behind interfaces
5. **Security by Design**: OWASP compliance, input validation

## Code Conventions

### Go Backend

```go
// File naming: snake_case.go
// Package naming: lowercase, single word
// Exported functions: PascalCase
// Private functions: camelCase
// Interfaces: end with -er or describe behavior

// Example structure
type AssetRepository interface {
    Create(ctx context.Context, asset *Asset) error
    FindByID(ctx context.Context, id uuid.UUID) (*Asset, error)
}

// Error handling: return errors, don't panic
if err != nil {
    return fmt.Errorf("failed to create asset: %w", err)
}

// Context: always first parameter
func (s *Service) DoSomething(ctx context.Context, input Input) error
```

### Flutter/Dart

```dart
// File naming: snake_case.dart
// Class naming: PascalCase
// Variables/functions: camelCase
// Constants: camelCase or SCREAMING_SNAKE_CASE

// Feature structure
features/
  assets/
    data/
      repositories/
      models/
    domain/
      entities/
      usecases/
    presentation/
      screens/
      widgets/
      providers/

// Riverpod providers
final assetListProvider = FutureProvider.autoDispose<List<Asset>>((ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.getAll();
});
```

## API Conventions

- Base URL: `/api/v1/`
- Authentication: Bearer token in `Authorization` header
- Response format: `{ "success": bool, "data": ..., "meta": { "request_id": ... } }`
- Error format: `{ "success": false, "error": { "code": "...", "message": "..." } }`
- HTTP methods: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove)

## Security Requirements

- All endpoints require authentication except `/health` and auth callbacks
- Input validation on all user inputs
- Parameterized queries (GORM handles this)
- No sensitive data in logs
- Rate limiting on API endpoints
- CORS configured for allowed origins only

## Key Documentation

Refer to the wiki for detailed specifications:

- `WealthScope.wiki/Product-Definition.md` - Product requirements
- `WealthScope.wiki/System-Architecture.md` - Technical architecture
- `WealthScope.wiki/API-Design.md` - API endpoints and contracts
- `WealthScope.wiki/Data-Model.md` - Database schema
- `WealthScope.wiki/AI-Integration.md` - OpenAI integration details
- `WealthScope.wiki/Shadow-Pricing.md` - Illiquid asset valuation
- `WealthScope.wiki/Security-Privacy.md` - Security requirements
- `WealthScope.wiki/Sprint-Plan.md` - Development timeline
- `WealthScope.wiki/CI-CD-GitFlow.md` - Git workflow and CI/CD

## Git Workflow

### Branches

| Branch | Purpose |
|--------|---------|
| `main` | Production, always stable |
| `develop` | Integration branch |
| `feature/*` | New features |
| `hotfix/*` | Urgent fixes from main |

### Commit Convention

```bash
feat: add new feature
fix: bug fix
docs: documentation
chore: maintenance
test: add tests
refactor: code refactor
```

### Workflow

```bash
# New feature
git checkout develop && git pull
git checkout -b feature/my-feature
# ... work and commit ...
git push -u origin feature/my-feature
# Create PR to develop

# Hotfix
git checkout main && git pull
git checkout -b hotfix/fix-name
# ... fix and commit ...
# Create PR to main, then sync develop
```

## AI Assistant Guidelines

When helping with this project:

1. **Respect the architecture**: Follow Clean Architecture layers
2. **Match coding style**: Use existing patterns as reference
3. **Security first**: Validate inputs, handle errors properly
4. **Test coverage**: Write tests for critical paths
5. **Documentation**: Update wiki if architecture changes
6. **Performance**: Consider caching, avoid N+1 queries
7. **User experience**: Loading states, error handling, accessibility

## Environment Variables

```bash
# Backend
DATABASE_URL=postgres://...
SUPABASE_JWT_SECRET=...
OPENAI_API_KEY=sk-...
REVENUECAT_API_KEY=sk_...
REVENUECAT_WEBHOOK_SECRET=whsec_...
YAHOO_FINANCE_API_KEY=...

# Frontend (compile-time)
REVENUECAT_IOS_KEY=appl_...
REVENUECAT_ANDROID_KEY=goog_...
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=eyJ...
API_BASE_URL=https://api.wealthscope.app
```

## Quick Commands

```bash
# Backend
cd backend
go run cmd/api/main.go          # Run locally
go test ./...                   # Run tests
go build -o api cmd/api/main.go # Build binary

# Frontend
cd frontend
flutter run                     # Run on device
flutter test                    # Run tests
flutter build ios              # Build iOS
flutter build apk              # Build Android

# Database
migrate -path ./migrations -database "$DATABASE_URL" up   # Run migrations
migrate -path ./migrations -database "$DATABASE_URL" down 1 # Rollback
```

## Current Sprint Focus

Refer to `WealthScope.wiki/Sprint-Plan.md` for current priorities.

**Week 1**: Foundation (Auth, Assets, Dashboard)  
**Week 2**: AI Features (OCR, What-If, Chat, Shadow Pricing)  
**Week 3**: Polish (Briefings, Paywall, Testing, Demo)

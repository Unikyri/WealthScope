## US-5.1 Backend Automated Tests Report

### 1) Document metadata
- **User Story**: #119 ([US-5.1] Tests Automatizados Backend)
- **Tasks**: #120 (T-5.1.1), #121 (T-5.1.2), #122 (T-5.1.3)
- **Branch**: `feature/backend-tests`
- **Date**: 2026-01-28
- **Environment**:
  - Local backend running on `localhost:8080` connected to Supabase Postgres
  - DB pooler note: Supabase PgBouncer can trigger prepared statement cache conflicts; tests use `PreferSimpleProtocol` in test mode.

### 2) What was implemented

#### T-5.1.1 AssetRepository tests (DB-backed)
- Added DB-backed unit tests for `PostgresAssetRepository` covering:
  - Create / FindByID / FindByUserID (filters + pagination) / Update / Delete (soft delete)
  - CountByUserID / GetTotalValueByUserID
  - FindBySymbol / FindListedAssets / UpdateCurrentPriceBySymbol / ListUserIDsWithListedAssets
- Isolation strategy:
  - Use DB transactions (`BEGIN` + rollback on cleanup) to avoid polluting Supabase.
  - Seed `users` row to satisfy FK `assets_user_id_fkey`.

#### T-5.1.2 Portfolio tests
- Added unit test coverage for portfolio risk use case pagination behavior.
- DB-backed tests validate `GetPortfolioSummary` calculations and the “current_price fallback to purchase_price”.

#### T-5.1.3 Integration tests (endpoints)
- Added integration tests using Gin + `httptest` covering:
  - Assets CRUD endpoints
  - Portfolio summary and portfolio risk endpoints
  - Unauthorized requests (missing token)
- Auth strategy:
  - Mint HS256 JWTs with `SUPABASE_JWT_SECRET` (claims include `sub` as UUID).
  - Seed `users` row for the test user to satisfy FK constraints.

### 3) How tests were executed

#### Go tests
- **Command**: `go test ./...`
- **Command (coverage)**: `go test ./... -coverprofile=coverage` then `go tool cover -func coverage`

#### TestSprite
- Generated and executed via MCP with local server running.
- Generated artifacts under `testsprite_tests/` including:
  - `testsprite_tests/tmp/code_summary.json`
  - `testsprite_tests/tmp/raw_report.md`
  - `testsprite_tests/testsprite-mcp-test-report.md` (completed report)

### 4) Coverage results (critical paths)

#### AssetRepository (critical path)
Function-level coverage highlights from `go tool cover -func coverage`:
- `internal/infrastructure/repositories/postgres_asset_repository.go`
  - `Create`: **80.0%**
  - `FindByID`: **85.7%**
  - `FindByUserID`: **86.2%**
  - `Update`: **71.4%**
  - `CountByUserID`: **80.0%**
  - `GetTotalValueByUserID`: **80.0%**
  - `GetPortfolioSummary`: **93.5%**

These satisfy the **>70%** target for the AssetRepository critical path.

#### Portfolio (critical path)
- `internal/application/usecases/portfolio_usecases.go`:
  - `Execute`: **100.0%**
- Portfolio summary calculation is exercised via DB-backed repository test (`GetPortfolioSummary` **93.5%**).

### 5) TestSprite results and findings
- TestSprite black-box tests largely failed due to:
  - JWT generation not matching WealthScope’s Supabase-compatible HS256 JWT expectations (401s).
  - Health endpoint JSON structure mismatch (WealthScope uses `{success,data,meta}` envelope).
- See: `testsprite_tests/testsprite-mcp-test-report.md` for the completed TestSprite report.

### 6) Key gaps / follow-ups
- Increase non-critical package coverage (e.g., `pricing_service`, `postgres_user_repository`, `postgres_price_history_repository`) if we want overall coverage to rise; not required for US-5.1 acceptance criteria as written.
- If we want TestSprite to pass:
  - Provide a valid token strategy (HS256 + correct claims), or configure a dedicated “test auth mode”.
  - Update assertions to the API response envelope shape.


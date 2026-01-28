# API Implementation - WealthScope Frontend

## ✅ API Structure Complete

The API integration has been fully implemented following the [API Design documentation](https://github.com/Unikyri/WealthScope/wiki/API-Design).

---

## 📂 Structure

```
lib/
├── core/
│   ├── network/
│   │   ├── dio_client.dart              ✅ HTTP client with interceptors
│   │   ├── auth_interceptor.dart        ✅ Auto JWT token injection
│   │   ├── error_interceptor.dart       ✅ Error handling
│   │   ├── api_response.dart            ✅ Standard response wrapper
│   │   ├── api_response.g.dart          ✅ Generated
│   │   ├── api_error.dart               ✅ Standard error wrapper
│   │   └── api_error.g.dart             ✅ Generated
│   └── errors/
│       └── failures.dart                ✅ Application failures
└── features/
    └── assets/
        ├── data/
        │   ├── datasources/
        │   │   └── asset_remote_data_source.dart  ✅ HTTP calls
        │   ├── repositories/
        │   │   └── asset_repository_impl.dart     ✅ Repository impl
        │   ├── providers/
        │   │   └── asset_repository_provider.dart ✅ Riverpod providers
        │   └── models/
        │       └── asset_dto.dart                 ✅ Data Transfer Object
        ├── domain/
        │   ├── entities/
        │   │   └── stock_asset.dart               ✅ Domain entity
        │   └── repositories/
        │       └── asset_repository.dart          ✅ Abstract contract
        └── presentation/
            └── providers/
                └── assets_provider.dart           ✅ UI state providers
```

---

## 🔧 Configuration

### Base URL
**DioClient** automatically uses versioned API:
```dart
baseUrl: '${AppConfig.apiBaseUrl}/api/v1'
```

### Environments
```dart
// Development
apiBaseUrl: 'http://localhost:8080'

// Production
apiBaseUrl: 'https://wealthscope-production.up.railway.app'
```

---

## 🔐 Authentication

**Auto-injected** via `AuthInterceptor`:
```dart
Authorization: Bearer <jwt_token>
```

Token is retrieved from `Supabase.instance.client.auth.currentSession`.

---

## 📡 Endpoints Implemented

### Assets

| Method | Endpoint | Description | Implementation |
|--------|----------|-------------|----------------|
| POST | `/api/v1/assets` | Create asset | ✅ `createAsset()` |
| GET | `/api/v1/assets` | List assets | ✅ `getAssets()` |
| GET | `/api/v1/assets/{id}` | Get asset | ✅ `getAssetById()` |
| PUT | `/api/v1/assets/{id}` | Update asset | ✅ `updateAsset()` |
| DELETE | `/api/v1/assets/{id}` | Delete asset | ✅ `deleteAsset()` |
| GET | `/api/v1/assets?type=x` | Filter by type | ✅ `getAssetsByType()` |

### Query Parameters Support
```dart
- type: Filter by asset type
- page: Page number
- per_page: Items per page
- sort_by: Sort field
- sort_order: asc/desc
```

---

## 📦 Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-01-28T10:00:00Z"
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": { ... }
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "2026-01-28T10:00:00Z"
  }
}
```

---

## 🚨 Error Handling

### HTTP Status Codes Mapped to Failures

| Status | Error Code | Failure Type |
|--------|------------|--------------|
| 400 | VALIDATION_ERROR | `ValidationFailure` |
| 401 | AUTHENTICATION_REQUIRED | `AuthFailure` |
| 403 | PERMISSION_DENIED | `AuthFailure` |
| 404 | NOT_FOUND | `NotFoundFailure` |
| 422 | BUSINESS_LOGIC_ERROR | `ValidationFailure` |
| 429 | RATE_LIMIT_EXCEEDED | `ServerFailure` |
| 500 | INTERNAL_SERVER_ERROR | `ServerFailure` |
| 503 | SERVICE_UNAVAILABLE | `ServerFailure` |
| Timeout | - | `NetworkFailure` |
| No Connection | - | `NetworkFailure` |

### Error Interceptor Flow
```
DioException → ErrorInterceptor → Parse API Error → Convert to Failure → Attach to Exception
```

---

## 🔄 Usage Example

### 1. Fetch all assets
```dart
@riverpod
Future<List<StockAsset>> allAssets(AllAssetsRef ref) async {
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAssets();
}
```

### 2. Create asset
```dart
final repository = ref.read(assetRepositoryProvider);
final newAsset = StockAsset(...);

try {
  final created = await repository.addAsset(newAsset);
  // Success
} on ValidationFailure catch (e) {
  // Handle validation error
} on AuthFailure catch (e) {
  // Handle auth error
} on NetworkFailure catch (e) {
  // Handle network error
}
```

### 3. Pull-to-refresh
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(allAssetsProvider);
    await ref.read(allAssetsProvider.future);
  },
  child: ListView(...),
)
```

---

## 🎯 Data Flow

```
UI (Screen)
    ↓
Provider (Riverpod)
    ↓
Repository (Interface)
    ↓
RepositoryImpl
    ↓
RemoteDataSource (Dio)
    ↓
Backend API
```

**Reverse flow:**
```
Backend API → DTO → Domain Entity → Provider → UI
```

---

## ⚠️ Important Notes

### Token Refresh
If a 401 error occurs, `AuthInterceptor` automatically triggers `Supabase.auth.refreshSession()`.

### Error Propagation
All repository methods throw `Failure` objects (not exceptions), which can be caught and handled appropriately.

### DTO ↔ Entity Mapping
```dart
// DTO to Domain
final entity = dto.toDomain();

// Domain to DTO
final dto = AssetDto.fromDomain(entity);
```

### Code Generation
After creating/modifying DTOs or providers:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🚀 Next Steps

### To add new endpoints:

1. **Add method to RemoteDataSource**
   ```dart
   Future<SomeDto> newEndpoint() async {
     final response = await _dio.get('/new-endpoint');
     return SomeDto.fromJson(response.data['data']);
   }
   ```

2. **Add method to Repository interface**
   ```dart
   abstract class SomeRepository {
     Future<SomeEntity> newMethod();
   }
   ```

3. **Implement in RepositoryImpl**
   ```dart
   @override
   Future<SomeEntity> newMethod() async {
     try {
       final dto = await _remoteDataSource.newEndpoint();
       return dto.toDomain();
     } on DioException catch (e) {
       throw _extractFailure(e);
     }
   }
   ```

4. **Create Riverpod provider**
   ```dart
   @riverpod
   Future<SomeEntity> someData(SomeDataRef ref) async {
     final repository = ref.watch(someRepositoryProvider);
     return await repository.newMethod();
   }
   ```

---

## ✅ Checklist

- [x] DioClient with versioned base URL
- [x] AuthInterceptor (JWT auto-injection)
- [x] ErrorInterceptor (standard error handling)
- [x] ApiResponse wrapper (success format)
- [x] ApiError wrapper (error format)
- [x] AssetRemoteDataSource (all CRUD endpoints)
- [x] AssetRepositoryImpl (domain layer)
- [x] Repository providers (Riverpod)
- [x] Integration with presentation providers
- [x] Code generation complete
- [x] No compilation errors

---

## 📚 References

- [API Design Wiki](https://github.com/Unikyri/WealthScope/wiki/API-Design)
- [AGENTS.md](./AGENTS.md) - Project architecture
- [RULES.md](./RULES.md) - Coding standards
- [SKILLS.md](./SKILLS.md) - Implementation procedures

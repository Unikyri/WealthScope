# API Compatibility Analysis

## Authentication Flow Verification

### WealthScope API Requirements (from Wiki)

The API expects:
- **JWT Tokens from Supabase Auth**
- **Authorization Header**: `Authorization: Bearer <jwt_token>`
- **Token Structure**:
  ```json
  {
    "sub": "user-uuid",
    "email": "user@example.com",
    "aud": "authenticated",
    "exp": 1234567890,
    "iat": 1234567800
  }
  ```

### Our Implementation Compatibility ✅

Our `AuthService` uses `supabase_flutter` which:

1. **Registration (`signUp`)** ✅
   - Creates user in Supabase Auth
   - Automatically generates JWT token
   - Returns `AuthResponse` with user and session
   - Token available via `response.session.accessToken`

2. **Login (`signIn`)** ✅
   - Authenticates with Supabase
   - Returns JWT token in session
   - Token auto-refreshed by Supabase client

3. **Current User** ✅
   - `currentUser` getter provides authenticated user
   - Contains UUID matching API's `sub` field

4. **Session Management** ✅
   - Supabase client handles token storage
   - Auto-refresh before expiration
   - `authStateChanges` stream for state monitoring

### API Client Integration

To use authenticated endpoints, we'll need to:

```dart
// Get current JWT token
final session = Supabase.instance.client.auth.currentSession;
final token = session?.accessToken;

// Add to Dio client headers
dio.options.headers = {
  'Authorization': 'Bearer $token',
};
```

### Endpoints We'll Use

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/v1/assets` | GET | List assets | Ready |
| `/api/v1/assets` | POST | Create asset | Ready |
| `/api/v1/portfolio/summary` | GET | Portfolio data | Ready |
| `/api/v1/portfolio/risk` | GET | Risk analysis | Ready |
| `/api/v1/scenarios/run` | POST | What-if analysis | Ready |
| `/api/v1/chat/message` | POST | AI Assistant | Ready |
| `/api/v1/briefings` | GET | Decision briefings | Ready |
| `/api/v1/users/me` | GET | User profile | Ready |

### Required Next Steps

1. **Create Dio Client with Interceptor**
   ```dart
   // lib/core/network/dio_client.dart
   class DioClient {
     final Dio dio;
     
     DioClient(this.dio) {
       dio.interceptors.add(AuthInterceptor());
     }
   }
   
   class AuthInterceptor extends Interceptor {
     @override
     void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
       final token = Supabase.instance.client.auth.currentSession?.accessToken;
       if (token != null) {
         options.headers['Authorization'] = 'Bearer $token';
       }
       handler.next(options);
     }
   }
   ```

2. **Environment Configuration**
   ```dart
   // lib/core/constants/api_constants.dart
   class ApiConstants {
     static const baseUrl = String.fromEnvironment(
       'API_BASE_URL',
       defaultValue: 'http://localhost:8080/api/v1',
     );
   }
   ```

3. **Response Models**
   - Create DTOs matching API response format
   - Use `json_serializable` for parsing
   - Map to domain entities

### Compatibility Summary

✅ **Authentication**: Fully compatible  
✅ **Token Format**: Matches exactly (Supabase JWT)  
✅ **Session Management**: Handled by Supabase  
✅ **Auto-refresh**: Built-in  
✅ **State Monitoring**: Available via stream  

### Potential Issues & Solutions

| Issue | Solution |
|-------|----------|
| Token expiration | Supabase auto-refreshes |
| Network errors | Implement retry interceptor |
| Rate limiting | Add rate limit handler |
| Error parsing | Create error mapper |

### Conclusion

Our current `AuthService` implementation is **100% compatible** with the WealthScope API requirements. The Supabase Auth integration provides:

- JWT tokens in the exact format expected
- Automatic token management
- Secure session storage
- Stream-based state updates

**No changes needed to AuthService** for API compatibility. Next sprint should focus on:
1. Creating the Dio client with auth interceptor
2. Implementing repository layer for API calls
3. Creating DTOs for API responses

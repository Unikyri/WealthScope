# Logout Feature Implementation

## Overview

Complete logout functionality that properly cleans up Supabase session, secure storage tokens, and local cache.

## Architecture

### Data Layer

#### AuthService ([auth_service.dart](../data/services/auth_service.dart))

```dart
class AuthService {
  final SupabaseClient _supabase;
  final SecureStorageService _secureStorage;

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _clearLocalData();
    } catch (e) {
      // Log error but continue with local cleanup
      await _clearLocalData();
      rethrow;
    }
  }

  /// Clear all local data including tokens and cache
  Future<void> _clearLocalData() async {
    // Clears secure storage tokens
    await _secureStorage.clearTokens();
    
    // Clears Hive cache
    final cacheBox = await Hive.openBox('cache');
    await cacheBox.clear();
  }
}
```

**Key Features:**
- ✅ Calls `supabase.auth.signOut()`
- ✅ Clears tokens from secure storage
- ✅ Clears Hive local cache
- ✅ Graceful error handling - continues cleanup even if Supabase call fails

### Presentation Layer

#### LogoutProvider ([logout_provider.dart](../presentation/providers/logout_provider.dart))

Riverpod AsyncNotifier that manages the logout state:

```dart
@riverpod
class Logout extends _$Logout {
  Future<void> signOut() async {
    state = const AsyncLoading();
    
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
    });
  }
}
```

**State Management:**
- `AsyncData<void>` - Idle or successful logout
- `AsyncLoading<void>` - Logout in progress
- `AsyncError` - Logout failed

## Usage

### Simple Usage

```dart
class MyProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LogoutButton(
      onLogoutSuccess: () {
        // Optional: Handle post-logout actions
      },
    );
  }
}
```

### Custom Implementation

```dart
class CustomLogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);

    return logoutState.when(
      data: (_) => IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await ref.read(logoutProvider.notifier).signOut();
          
          if (context.mounted) {
            context.go('/login');
          }
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

### Manual Logout Call

```dart
Future<void> performLogout(WidgetRef ref) async {
  // Call logout
  await ref.read(logoutProvider.notifier).signOut();
  
  // Check state
  final state = ref.read(logoutProvider);
  state.when(
    data: (_) => print('Logout successful'),
    loading: () => print('Still logging out...'),
    error: (error, stack) => print('Logout failed: $error'),
  );
}
```

## What Gets Cleared

1. **Supabase Session**
   - Server-side session invalidated
   - Auth tokens revoked

2. **Secure Storage**
   - Access token removed
   - Refresh token removed
   - All stored credentials cleared

3. **Local Cache (Hive)**
   - All cached data cleared
   - Fresh start on next login

## Error Handling

### Graceful Degradation

Even if Supabase logout fails (network error, etc.), local data is still cleared:

```dart
try {
  await _supabase.auth.signOut();  // May fail
  await _clearLocalData();          // Always attempted
} catch (e) {
  await _clearLocalData();          // Cleanup guaranteed
  rethrow;
}
```

### UI Error States

The `LogoutButton` widget handles all states:

- **Loading**: Shows spinner, button disabled
- **Error**: Shows retry option with error message
- **Success**: Navigates to login screen

## Testing

### Unit Test Example

```dart
test('signOut clears all local data', () async {
  // Arrange
  final mockSupabase = MockSupabaseClient();
  final mockStorage = MockSecureStorageService();
  final authService = AuthService(mockSupabase, mockStorage);

  // Act
  await authService.signOut();

  // Assert
  verify(mockSupabase.auth.signOut()).called(1);
  verify(mockStorage.clearTokens()).called(1);
});
```

### Integration Test

```dart
testWidgets('logout button navigates to login', (tester) async {
  // Arrange
  await tester.pumpWidget(MyApp());
  
  // Act
  await tester.tap(find.byType(LogoutButton));
  await tester.pumpAndSettle();
  
  // Confirm dialog
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.byType(LoginScreen), findsOneWidget);
});
```

## Files Modified/Created

### Created
- ✅ `lib/features/auth/presentation/providers/logout_provider.dart`
- ✅ `lib/features/auth/presentation/widgets/logout_button.dart`
- ✅ `lib/features/auth/presentation/LOGOUT_IMPLEMENTATION.md`

### Modified
- ✅ `lib/features/auth/data/services/auth_service.dart`
  - Added `SecureStorageService` dependency
  - Enhanced `signOut()` method
  - Added `_clearLocalData()` helper
  
- ✅ `lib/features/auth/data/providers/auth_service_provider.dart`
  - Injected `secureStorageProvider` dependency

- ✅ `lib/features/auth/presentation/auth_presentation.dart`
  - Exported `logout_provider.dart`

## Acceptance Criteria ✅

- ✅ `supabase.auth.signOut()` called
- ✅ Tokens removed from secure storage
- ✅ Local cache cleared (Hive)
- ✅ Errors handled gracefully
- ✅ UI states properly managed (loading, error, success)
- ✅ Navigation to login screen after logout
- ✅ Confirmation dialog before logout

## Time Spent

Estimated: 1 hour  
Actual: ~45 minutes

## Related Issues

Part of #44 (User Story)

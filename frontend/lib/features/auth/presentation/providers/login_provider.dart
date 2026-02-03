import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';
import 'package:wealthscope_app/features/auth/data/providers/user_sync_service_provider.dart';

part 'login_provider.g.dart';

/// State for login form
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool obscurePassword;
  final bool isButtonDisabled;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
    this.isButtonDisabled = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? obscurePassword,
    bool? isButtonDisabled,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isButtonDisabled: isButtonDisabled ?? this.isButtonDisabled,
    );
  }
}

/// Provider for login form logic
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return const LoginState();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Start 3-second cooldown after error
  void _startCooldown() {
    state = state.copyWith(isButtonDisabled: true);
    Future.delayed(const Duration(seconds: 3), () {
      state = state.copyWith(isButtonDisabled: false);
    });
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Check if button is disabled
    if (state.isButtonDisabled) {
      return false;
    }

    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      // Get auth service
      final authService = ref.read(authServiceProvider);

      // Attempt login with Supabase signInWithPassword
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      if (result.session != null) {
        // Login successful - session is automatically saved by Supabase
        debugPrint('✅ Login successful: ${result.user?.email}');
        
        // Sync user with backend to ensure they exist in the local database
        try {
          final syncService = ref.read(userSyncServiceProvider);
          await syncService.syncUserWithBackend();
          debugPrint('✅ User synced with backend after login');
        } catch (syncError) {
          // Log sync error but don't fail login
          // User can still use the app, sync can be retried later
          debugPrint('⚠️ Backend sync failed: $syncError');
        }
        
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        // Login failed without exception
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Incorrect email or password',
        );
        _startCooldown();
        return false;
      }
    } on AuthException catch (e) {
      debugPrint('❌ Login failed with AuthException: ${e.message}');
      
      final errorMessage = _mapAuthError(e);
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      _startCooldown();
      return false;
    } catch (e) {
      debugPrint('❌ Login failed with error: $e');
      
      // Check for network errors
      String errorMessage = 'An error occurred. Please try again.';
      if (e.toString().toLowerCase().contains('network') ||
          e.toString().toLowerCase().contains('connection')) {
        errorMessage = 'Connection error. Check your internet.';
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      _startCooldown();
      return false;
    }
  }

  /// Map Supabase AuthException to user-friendly messages
  String _mapAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    // Invalid login credentials
    if (message.contains('invalid login credentials') || 
        message.contains('invalid email or password') ||
        message.contains('invalid password')) {
      return 'Incorrect email or password';
    }
    
    // Email not confirmed
    if (message.contains('email not confirmed') ||
        message.contains('not confirmed')) {
      return 'Please confirm your email';
    }
    
    // Too many requests / Rate limit
    if (message.contains('too many requests') || 
        message.contains('rate limit') ||
        message.contains('too many')) {
      return 'Too many attempts. Wait a moment.';
    }
    
    // Network error
    if (message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout')) {
      return 'Connection error. Check your internet.';
    }
    
    // Default error
    return 'An error occurred. Please try again.';
  }
}

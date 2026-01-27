import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';

part 'login_provider.g.dart';

/// State for login form
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool obscurePassword;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? obscurePassword,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
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
    state = state.copyWith(errorMessage: '');
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        errorMessage: 'All fields are required',
      );
      return false;
    }

    if (!_isValidEmail(email)) {
      state = state.copyWith(
        errorMessage: 'Invalid email',
      );
      return false;
    }

    if (password.length < 6) {
      state = state.copyWith(
        errorMessage: 'Password must be at least 6 characters',
      );
      return false;
    }

    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      // Get auth service
      final authService = ref.read(authServiceProvider);

      // Attempt login
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Login successful
        state = state.copyWith(isLoading: false);
        debugPrint('✅ Login successful: ${result.user?.email}');
        return true;
      } else {
        // Login failed
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed. Please check your credentials.',
        );
        return false;
      }
    } on AuthException catch (e) {
      debugPrint('❌ Login failed with AuthException: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getAuthErrorMessage(e.message),
      );
      return false;
    } catch (e) {
      debugPrint('❌ Login failed with error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error. Please try again.',
      );
      return false;
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Get user-friendly error message from Supabase error
  String _getAuthErrorMessage(String message) {
    if (message.toLowerCase().contains('invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (message.toLowerCase().contains('email not confirmed')) {
      return 'Please confirm your email before logging in';
    }
    if (message.toLowerCase().contains('user not found')) {
      return 'No account exists with this email';
    }
    if (message.toLowerCase().contains('too many requests')) {
      return 'Too many attempts. Please try again later';
    }
    return 'Login failed. Please check your credentials.';
  }
}

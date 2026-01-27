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
  final bool isCooldownActive;
  final int cooldownSeconds;
  final int failedAttempts;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
    this.isCooldownActive = false,
    this.cooldownSeconds = 0,
    this.failedAttempts = 0,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? obscurePassword,
    bool? isCooldownActive,
    int? cooldownSeconds,
    int? failedAttempts,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isCooldownActive: isCooldownActive ?? this.isCooldownActive,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }
}

/// Provider for login form logic
@riverpod
class LoginNotifier extends _$LoginNotifier {
  static const int _maxFailedAttempts = 3;
  static const int _cooldownSeconds = 30;

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

  /// Start cooldown timer after too many failed attempts
  void _startCooldown() {
    state = state.copyWith(
      isCooldownActive: true,
      cooldownSeconds: _cooldownSeconds,
    );

    // Countdown timer
    for (int i = _cooldownSeconds; i > 0; i--) {
      Future.delayed(Duration(seconds: _cooldownSeconds - i), () {
        if (state.isCooldownActive) {
          state = state.copyWith(cooldownSeconds: i - 1);
        }
      });
    }

    // End cooldown and reset attempts
    Future.delayed(Duration(seconds: _cooldownSeconds), () {
      state = state.copyWith(
        isCooldownActive: false,
        cooldownSeconds: 0,
        failedAttempts: 0,
      );
    });
  }

  /// Login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Check if cooldown is active
    if (state.isCooldownActive) {
      state = state.copyWith(
        errorMessage: 'Too many attempts. Please wait ${state.cooldownSeconds} seconds.',
      );
      return false;
    }

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

      // Attempt login with Supabase signInWithPassword
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      if (result.session != null) {
        // Login successful - session is automatically saved by Supabase
        state = state.copyWith(
          isLoading: false,
          failedAttempts: 0,
        );
        debugPrint('✅ Login successful: ${result.user?.email}');
        debugPrint('✅ Session saved automatically');
        return true;
      } else {
        // Login failed - increment failed attempts
        final newFailedAttempts = state.failedAttempts + 1;
        
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed. Please check your credentials.',
          failedAttempts: newFailedAttempts,
        );

        // Start cooldown if max attempts reached
        if (newFailedAttempts >= _maxFailedAttempts) {
          _startCooldown();
        }

        return false;
      }
    } on AuthException catch (e) {
      debugPrint('❌ Login failed with AuthException: ${e.message}');
      
      final newFailedAttempts = state.failedAttempts + 1;
      final errorMessage = _mapAuthError(e);

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
        failedAttempts: newFailedAttempts,
      );

      // Start cooldown if max attempts reached
      if (newFailedAttempts >= _maxFailedAttempts) {
        _startCooldown();
      }

      return false;
    } catch (e) {
      debugPrint('❌ Login failed with error: $e');
      
      final newFailedAttempts = state.failedAttempts + 1;

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error. Please try again.',
        failedAttempts: newFailedAttempts,
      );

      // Start cooldown if max attempts reached
      if (newFailedAttempts >= _maxFailedAttempts) {
        _startCooldown();
      }

      return false;
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Map Supabase AuthException to user-friendly messages
  String _mapAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') || 
        message.contains('invalid email or password')) {
      return 'Invalid email or password';
    }
    if (message.contains('email not confirmed')) {
      return 'Please confirm your email before logging in';
    }
    if (message.contains('user not found')) {
      return 'No account exists with this email';
    }
    if (message.contains('too many requests') || 
        message.contains('rate limit')) {
      return 'Too many attempts. Please try again later';
    }
    if (message.contains('network')) {
      return 'Network error. Please check your connection';
    }
    
    return 'Login failed. Please check your credentials.';
  }
}

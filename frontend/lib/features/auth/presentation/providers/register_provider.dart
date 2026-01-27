import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/auth/data/auth_data.dart';

part 'register_provider.g.dart';

/// State for register form
class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptedTerms;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptedTerms = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptedTerms,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}

/// Provider for register form logic
@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() {
    return const RegisterState();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  /// Toggle terms acceptance
  void toggleTerms() {
    state = state.copyWith(acceptedTerms: !state.acceptedTerms);
  }

  /// Register user with email and password
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    if (password != confirmPassword) {
      state = state.copyWith(
        errorMessage: 'Passwords do not match',
      );
      return false;
    }

    if (!state.acceptedTerms) {
      state = state.copyWith(
        errorMessage: 'You must accept the terms and conditions',
      );
      return false;
    }

    // Set loading state
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Error creating account',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Parse error message from exception
  String _parseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('already registered')) {
      return 'This email is already registered';
    } else if (errorStr.contains('invalid email')) {
      return 'Invalid email';
    } else if (errorStr.contains('weak password')) {
      return 'Weak password';
    }
    return 'Error creating account. Please try again.';
  }
}

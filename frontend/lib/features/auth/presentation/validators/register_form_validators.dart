/// Form validators for registration screen
/// Provides validation logic for email, password, and password confirmation
class RegisterFormValidators {
  /// Validates email field
  /// 
  /// Returns error message if:
  /// - Field is empty
  /// - Email format is invalid (doesn't match regex pattern)
  /// 
  /// Returns null if validation passes
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Validates password field
  /// 
  /// Returns error message if:
  /// - Field is empty
  /// - Password is less than 8 characters
  /// - Password doesn't contain at least one uppercase letter (optional but recommended)
  /// - Password doesn't contain at least one number (optional but recommended)
  /// 
  /// Returns null if validation passes
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Optional: Check for uppercase letter (recommended)
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must have at least one uppercase letter';
    }
    // Optional: Check for at least one number (recommended)
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must have at least one number';
    }
    return null;
  }

  /// Validates password confirmation field
  /// 
  /// Returns error message if:
  /// - Field is empty
  /// - Confirmation doesn't match the password
  /// 
  /// Returns null if validation passes
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Password confirmation is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}

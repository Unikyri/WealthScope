/// Form validators for login screen
/// Provides validation logic for email and password fields
class LoginFormValidators {
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
  /// - Password is less than 6 characters (lenient for login)
  /// 
  /// Returns null if validation passes
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

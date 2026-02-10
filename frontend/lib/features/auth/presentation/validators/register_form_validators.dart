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
      return 'El email es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
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
      return 'La contraseña es requerida';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    // Optional: Check for uppercase letter (recommended)
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'La contraseña debe tener al menos una mayúscula';
    }
    // Optional: Check for at least one number (recommended)
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'La contraseña debe tener al menos un número';
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
      return 'La confirmación de contraseña es requerida';
    }
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}

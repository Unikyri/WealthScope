/// Validators for asset forms
/// Provides validation methods for common asset form fields
class AssetValidators {
  /// Validates asset name field
  /// 
  /// Rules:
  /// - Required field
  /// - Max 255 characters
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length > 255) {
      return 'El nombre es muy largo (max 255)';
    }
    return null;
  }

  /// Validates quantity field
  /// 
  /// Rules:
  /// - Required field
  /// - Must be a valid number
  /// - Must be greater than 0
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'La cantidad es requerida';
    }
    final qty = double.tryParse(value);
    if (qty == null) {
      return 'Ingresa un numero valido';
    }
    if (qty <= 0) {
      return 'La cantidad debe ser mayor a 0';
    }
    return null;
  }

  /// Validates price field (optional)
  /// 
  /// Rules:
  /// - Optional field (can be empty)
  /// - If provided, must be a valid number
  /// - If provided, must be >= 0
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final price = double.tryParse(value.replaceAll(',', ''));
    if (price == null) {
      return 'Ingresa un precio valido';
    }
    if (price < 0) {
      return 'El precio no puede ser negativo';
    }
    return null;
  }

  /// Validates symbol field (e.g., stock ticker)
  /// 
  /// Rules:
  /// - Can be required or optional
  /// - Max 10 characters
  static String? validateSymbol(String? value, {bool required = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'El simbolo es requerido';
    }
    if (value != null && value.length > 10) {
      return 'Simbolo muy largo (max 10)';
    }
    return null;
  }

  /// Validates address field
  /// 
  /// Rules:
  /// - Required field
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La direccion es requerida';
    }
    return null;
  }

  /// Validates date field
  /// 
  /// Rules:
  /// - Required field
  /// - Cannot be in the future
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'La fecha es requerida';
    }
    if (value.isAfter(DateTime.now())) {
      return 'La fecha no puede ser futura';
    }
    return null;
  }

  /// Validates weight field (for precious metals)
  /// 
  /// Rules:
  /// - Required field
  /// - Must be a valid number
  /// - Must be greater than 0
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'El peso es requerido';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Ingresa un peso valido';
    }
    if (weight <= 0) {
      return 'El peso debe ser mayor a 0';
    }
    return null;
  }

  /// Validates area field (for real estate)
  /// 
  /// Rules:
  /// - Optional field
  /// - If provided, must be a valid number
  /// - If provided, must be greater than 0
  static String? validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final area = double.tryParse(value);
    if (area == null) {
      return 'Ingresa un area valida';
    }
    if (area <= 0) {
      return 'El area debe ser mayor a 0';
    }
    return null;
  }

  /// Validates value/estimated value field
  /// 
  /// Rules:
  /// - Required field
  /// - Must be a valid number
  /// - Must be greater than 0
  static String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'El valor es requerido';
    }
    final val = double.tryParse(value.replaceAll(',', ''));
    if (val == null) {
      return 'Ingresa un valor valido';
    }
    if (val <= 0) {
      return 'El valor debe ser mayor a 0';
    }
    return null;
  }
}

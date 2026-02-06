import 'package:flutter/material.dart' as flutter;

/// Supported currencies for the application
enum Currency {
  usd,
  eur,
  gbp,
  jpy,
  cad,
  aud,
  chf,
  cny;

  /// Display name for the currency
  String get displayName {
    switch (this) {
      case Currency.usd:
        return 'US Dollar';
      case Currency.eur:
        return 'Euro';
      case Currency.gbp:
        return 'British Pound';
      case Currency.jpy:
        return 'Japanese Yen';
      case Currency.cad:
        return 'Canadian Dollar';
      case Currency.aud:
        return 'Australian Dollar';
      case Currency.chf:
        return 'Swiss Franc';
      case Currency.cny:
        return 'Chinese Yuan';
    }
  }

  /// Currency symbol
  String get symbol {
    switch (this) {
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.gbp:
        return '£';
      case Currency.jpy:
        return '¥';
      case Currency.cad:
        return 'C\$';
      case Currency.aud:
        return 'A\$';
      case Currency.chf:
        return 'CHF';
      case Currency.cny:
        return '¥';
    }
  }

  /// Currency code (ISO 4217)
  String get code {
    switch (this) {
      case Currency.usd:
        return 'USD';
      case Currency.eur:
        return 'EUR';
      case Currency.gbp:
        return 'GBP';
      case Currency.jpy:
        return 'JPY';
      case Currency.cad:
        return 'CAD';
      case Currency.aud:
        return 'AUD';
      case Currency.chf:
        return 'CHF';
      case Currency.cny:
        return 'CNY';
    }
  }

  /// Flag emoji for the currency
  String get flag {
    switch (this) {
      case Currency.usd:
        return '🇺🇸';
      case Currency.eur:
        return '🇪🇺';
      case Currency.gbp:
        return '🇬🇧';
      case Currency.jpy:
        return '🇯🇵';
      case Currency.cad:
        return '🇨🇦';
      case Currency.aud:
        return '🇦🇺';
      case Currency.chf:
        return '🇨🇭';
      case Currency.cny:
        return '🇨🇳';
    }
  }

  /// Icon for the currency
  flutter.IconData get icon {
    return flutter.Icons.attach_money;
  }

  /// Convert from string
  static Currency fromString(String value) {
    return Currency.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => Currency.usd,
    );
  }
}

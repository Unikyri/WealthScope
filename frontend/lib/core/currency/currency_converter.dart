import 'package:wealthscope_app/core/currency/currency.dart';

/// Currency converter utility
/// 
/// Handles conversion between different currencies
/// In production, this would fetch real-time exchange rates from an API
class CurrencyConverter {
  // Mock exchange rates (USD base)
  // In production: fetch from API like exchangerate-api.com or similar
  static const Map<Currency, double> _exchangeRates = {
    Currency.usd: 1.0,
    Currency.eur: 0.92,
    Currency.gbp: 0.79,
    Currency.jpy: 149.50,
    Currency.cad: 1.35,
    Currency.aud: 1.52,
    Currency.chf: 0.87,
    Currency.cny: 7.24,
  };

  /// Convert amount from one currency to another
  static double convert({
    required double amount,
    required Currency from,
    required Currency to,
  }) {
    if (from == to) return amount;

    // Convert from source currency to USD
    final amountInUsd = amount / _exchangeRates[from]!;

    // Convert from USD to target currency
    return amountInUsd * _exchangeRates[to]!;
  }

  /// Format currency value with symbol and proper decimal places
  static String format({
    required double amount,
    required Currency currency,
    int? decimalDigits,
  }) {
    // JPY doesn't use decimal places
    final decimals = decimalDigits ?? (currency == Currency.jpy ? 0 : 2);
    final formatted = amount.toStringAsFixed(decimals);

    // Add thousand separators
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    final formattedNumber = decimals > 0 && decimalPart.isNotEmpty
        ? '${buffer.toString()}.$decimalPart'
        : buffer.toString();

    return '${currency.symbol}$formattedNumber';
  }

  /// Get exchange rate between two currencies
  static double getRate({
    required Currency from,
    required Currency to,
  }) {
    if (from == to) return 1.0;
    
    final fromRate = _exchangeRates[from]!;
    final toRate = _exchangeRates[to]!;
    
    return toRate / fromRate;
  }

  /// Get all available exchange rates from a base currency
  static Map<Currency, double> getAllRates(Currency base) {
    return Currency.values.asMap().map((_, currency) {
      return MapEntry(
        currency,
        getRate(from: base, to: currency),
      );
    });
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/currency/currency.dart';
import 'package:wealthscope_app/core/currency/currency_converter.dart';
import 'package:wealthscope_app/core/currency/currency_provider.dart';

/// Extension for formatting currency values based on user preference
extension CurrencyFormatting on WidgetRef {
  /// Format a USD value to the user's preferred currency
  /// 
  /// Example:
  /// ```dart
  /// final formatted = ref.formatCurrency(1000.0);
  /// // Returns: $1,000.00 (if USD selected)
  /// // Returns: €920.00 (if EUR selected)
  /// ```
  String formatCurrency(
    double usdAmount, {
    int? decimalDigits,
    bool convertFromUsd = true,
  }) {
    final selectedCurrencyAsync = watch(selectedCurrencyProvider);
    final currency = selectedCurrencyAsync.asData?.value ?? Currency.usd;

    // Convert amount if needed
    final convertedAmount = convertFromUsd
        ? CurrencyConverter.convert(
            amount: usdAmount,
            from: Currency.usd,
            to: currency,
          )
        : usdAmount;

    // Format with currency symbol
    return CurrencyConverter.format(
      amount: convertedAmount,
      currency: currency,
      decimalDigits: decimalDigits,
    );
  }

  /// Get the current selected currency
  Currency getCurrentCurrency() {
    final selectedCurrencyAsync = watch(selectedCurrencyProvider);
    return selectedCurrencyAsync.asData?.value ?? Currency.usd;
  }

  /// Convert amount from USD to user's preferred currency
  double convertFromUsd(double usdAmount) {
    final currency = getCurrentCurrency();
    return CurrencyConverter.convert(
      amount: usdAmount,
      from: Currency.usd,
      to: currency,
    );
  }
}

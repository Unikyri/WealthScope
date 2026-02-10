import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthscope_app/core/currency/currency.dart';

part 'currency_provider.g.dart';

/// Provider for managing user's preferred currency
/// Persists the selection using SharedPreferences
@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  static const String _storageKey = 'selected_currency';

  @override
  Future<Currency> build() async {
    return await _loadCurrencyPreference();
  }

  /// Load currency preference from SharedPreferences
  Future<Currency> _loadCurrencyPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currencyString = prefs.getString(_storageKey);
      
      if (currencyString != null) {
        return Currency.fromString(currencyString);
      }
    } catch (e) {
      // If loading fails, return default
    }
    
    return Currency.usd; // Default currency
  }

  /// Set the preferred currency and persist it
  Future<void> setCurrency(Currency currency) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, currency.name);
      state = AsyncValue.data(currency);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Get current currency synchronously (returns USD if not loaded)
  Currency getCurrent() {
    return state.asData?.value ?? Currency.usd;
  }
}

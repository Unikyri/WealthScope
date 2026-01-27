import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

part 'stock_form_provider.g.dart';

/// State for the stock form
class StockFormState {
  const StockFormState({
    this.isLoading = false,
    this.error,
    this.savedAsset,
  });

  final bool isLoading;
  final String? error;
  final StockAsset? savedAsset;

  StockFormState copyWith({
    bool? isLoading,
    String? error,
    StockAsset? savedAsset,
  }) {
    return StockFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedAsset: savedAsset ?? this.savedAsset,
    );
  }
}

/// Stock Form Provider
/// Manages the state and business logic for the stock/ETF form.
@riverpod
class StockForm extends _$StockForm {
  @override
  StockFormState build() {
    return const StockFormState();
  }

  /// Search for stock symbols (mock implementation for now)
  Future<List<String>> searchSymbols(String query) async {
    if (query.isEmpty) return [];

    // Mock symbols - replace with real API call later
    final mockSymbols = [
      'AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA',
      'META', 'NVDA', 'SPY', 'VOO', 'QQQ',
      'VTI', 'IVV', 'VEA', 'AGG', 'BND',
    ];

    await Future.delayed(const Duration(milliseconds: 300));

    return mockSymbols
        .where((symbol) => symbol.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Submit the form and save the asset
  Future<void> submitForm(StockAsset asset) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual repository call
      // await ref.read(assetRepositoryProvider).addAsset(asset);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        isLoading: false,
        savedAsset: asset,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save asset: ${e.toString()}',
      );
    }
  }

  /// Reset the form state
  void reset() {
    state = const StockFormState();
  }
}

/// Selected Currency Provider
/// Manages the selected currency for the form.
@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  @override
  Currency build() {
    return Currency.usd;
  }

  void setCurrency(Currency currency) {
    state = currency;
  }
}

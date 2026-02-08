// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing user's preferred currency
/// Persists the selection using SharedPreferences

@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider = SelectedCurrencyProvider._();

/// Provider for managing user's preferred currency
/// Persists the selection using SharedPreferences
final class SelectedCurrencyProvider
    extends $AsyncNotifierProvider<SelectedCurrency, Currency> {
  /// Provider for managing user's preferred currency
  /// Persists the selection using SharedPreferences
  SelectedCurrencyProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedCurrencyProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedCurrencyHash();

  @$internal
  @override
  SelectedCurrency create() => SelectedCurrency();
}

String _$selectedCurrencyHash() => r'87c3420c5fa4fc408254240fa2822fd6f48d7a87';

/// Provider for managing user's preferred currency
/// Persists the selection using SharedPreferences

abstract class _$SelectedCurrency extends $AsyncNotifier<Currency> {
  FutureOr<Currency> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Currency>, Currency>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Currency>, Currency>,
        AsyncValue<Currency>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

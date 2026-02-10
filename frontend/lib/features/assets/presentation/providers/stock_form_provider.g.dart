// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stock Form Provider
/// Manages the state and business logic for the stock/ETF form.

@ProviderFor(StockForm)
final stockFormProvider = StockFormProvider._();

/// Stock Form Provider
/// Manages the state and business logic for the stock/ETF form.
final class StockFormProvider
    extends $NotifierProvider<StockForm, StockFormState> {
  /// Stock Form Provider
  /// Manages the state and business logic for the stock/ETF form.
  StockFormProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'stockFormProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$stockFormHash();

  @$internal
  @override
  StockForm create() => StockForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockFormState>(value),
    );
  }
}

String _$stockFormHash() => r'925c89c6bf6091996e162ad6a19f74aa7e368fc3';

/// Stock Form Provider
/// Manages the state and business logic for the stock/ETF form.

abstract class _$StockForm extends $Notifier<StockFormState> {
  StockFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StockFormState, StockFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<StockFormState, StockFormState>,
        StockFormState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Selected Currency Provider
/// Manages the selected currency for the form.

@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider = SelectedCurrencyProvider._();

/// Selected Currency Provider
/// Manages the selected currency for the form.
final class SelectedCurrencyProvider
    extends $NotifierProvider<SelectedCurrency, Currency> {
  /// Selected Currency Provider
  /// Manages the selected currency for the form.
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Currency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Currency>(value),
    );
  }
}

String _$selectedCurrencyHash() => r'398938655e715466f6e4eb9dafd8bf4177f1a727';

/// Selected Currency Provider
/// Manages the selected currency for the form.

abstract class _$SelectedCurrency extends $Notifier<Currency> {
  Currency build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Currency, Currency>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Currency, Currency>, Currency, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

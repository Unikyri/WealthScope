// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockFormHash() => r'2f55fbeff46158a71088398e20261591ca02a5ad';

/// Stock Form Provider
/// Manages the state and business logic for the stock/ETF form.
///
/// Copied from [StockForm].
@ProviderFor(StockForm)
final stockFormProvider =
    AutoDisposeNotifierProvider<StockForm, StockFormState>.internal(
  StockForm.new,
  name: r'stockFormProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$stockFormHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StockForm = AutoDisposeNotifier<StockFormState>;
String _$selectedCurrencyHash() => r'398938655e715466f6e4eb9dafd8bf4177f1a727';

/// Selected Currency Provider
/// Manages the selected currency for the form.
///
/// Copied from [SelectedCurrency].
@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider =
    AutoDisposeNotifierProvider<SelectedCurrency, Currency>.internal(
  SelectedCurrency.new,
  name: r'selectedCurrencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCurrency = AutoDisposeNotifier<Currency>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

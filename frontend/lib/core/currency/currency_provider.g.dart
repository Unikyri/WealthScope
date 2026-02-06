// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedCurrencyHash() => r'f32b782bd875e1853072f086d07a4f059c9bceb7';

/// Provider for managing user's preferred currency
/// Persists the selection using SharedPreferences
///
/// Copied from [SelectedCurrency].
@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider =
    AutoDisposeAsyncNotifierProvider<SelectedCurrency, Currency>.internal(
  SelectedCurrency.new,
  name: r'selectedCurrencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCurrency = AutoDisposeAsyncNotifier<Currency>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

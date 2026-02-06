// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portfolioHistoryHash() => r'30dc6d943d83d04ac347452606086508a358b5b9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PortfolioHistory
    extends BuildlessAutoDisposeAsyncNotifier<List<PortfolioHistoryPoint>> {
  late final String period;

  FutureOr<List<PortfolioHistoryPoint>> build(
    String period,
  );
}

/// Provider for portfolio history data
///
/// Copied from [PortfolioHistory].
@ProviderFor(PortfolioHistory)
const portfolioHistoryProvider = PortfolioHistoryFamily();

/// Provider for portfolio history data
///
/// Copied from [PortfolioHistory].
class PortfolioHistoryFamily
    extends Family<AsyncValue<List<PortfolioHistoryPoint>>> {
  /// Provider for portfolio history data
  ///
  /// Copied from [PortfolioHistory].
  const PortfolioHistoryFamily();

  /// Provider for portfolio history data
  ///
  /// Copied from [PortfolioHistory].
  PortfolioHistoryProvider call(
    String period,
  ) {
    return PortfolioHistoryProvider(
      period,
    );
  }

  @override
  PortfolioHistoryProvider getProviderOverride(
    covariant PortfolioHistoryProvider provider,
  ) {
    return call(
      provider.period,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'portfolioHistoryProvider';
}

/// Provider for portfolio history data
///
/// Copied from [PortfolioHistory].
class PortfolioHistoryProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PortfolioHistory, List<PortfolioHistoryPoint>> {
  /// Provider for portfolio history data
  ///
  /// Copied from [PortfolioHistory].
  PortfolioHistoryProvider(
    String period,
  ) : this._internal(
          () => PortfolioHistory()..period = period,
          from: portfolioHistoryProvider,
          name: r'portfolioHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$portfolioHistoryHash,
          dependencies: PortfolioHistoryFamily._dependencies,
          allTransitiveDependencies:
              PortfolioHistoryFamily._allTransitiveDependencies,
          period: period,
        );

  PortfolioHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final String period;

  @override
  FutureOr<List<PortfolioHistoryPoint>> runNotifierBuild(
    covariant PortfolioHistory notifier,
  ) {
    return notifier.build(
      period,
    );
  }

  @override
  Override overrideWith(PortfolioHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: PortfolioHistoryProvider._internal(
        () => create()..period = period,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PortfolioHistory,
      List<PortfolioHistoryPoint>> createElement() {
    return _PortfolioHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PortfolioHistoryProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PortfolioHistoryRef
    on AutoDisposeAsyncNotifierProviderRef<List<PortfolioHistoryPoint>> {
  /// The parameter `period` of this provider.
  String get period;
}

class _PortfolioHistoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PortfolioHistory,
        List<PortfolioHistoryPoint>> with PortfolioHistoryRef {
  _PortfolioHistoryProviderElement(super.provider);

  @override
  String get period => (origin as PortfolioHistoryProvider).period;
}

String _$selectedPeriodHash() => r'350c80e7ccd28df347529c47fe73b7233cdbbb9b';

/// Provider for selected period
///
/// Copied from [SelectedPeriod].
@ProviderFor(SelectedPeriod)
final selectedPeriodProvider =
    AutoDisposeNotifierProvider<SelectedPeriod, String>.internal(
  SelectedPeriod.new,
  name: r'selectedPeriodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPeriodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedPeriod = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

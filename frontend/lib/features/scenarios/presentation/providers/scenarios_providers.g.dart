// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenarios_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scenariosRepositoryHash() =>
    r'2ae2918d63e9add750eaa25f331c53f233e99036';

/// Provider for ScenariosRepository
///
/// Copied from [scenariosRepository].
@ProviderFor(scenariosRepository)
final scenariosRepositoryProvider =
    AutoDisposeProvider<ScenariosRepository>.internal(
  scenariosRepository,
  name: r'scenariosRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scenariosRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScenariosRepositoryRef = AutoDisposeProviderRef<ScenariosRepository>;
String _$scenarioTemplatesHash() => r'a51aa204d1de7758e8621ce6003a44cc348616c9';

/// Provider to get scenario templates
///
/// Copied from [scenarioTemplates].
@ProviderFor(scenarioTemplates)
final scenarioTemplatesProvider =
    AutoDisposeFutureProvider<List<ScenarioTemplateEntity>>.internal(
  scenarioTemplates,
  name: r'scenarioTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scenarioTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScenarioTemplatesRef
    = AutoDisposeFutureProviderRef<List<ScenarioTemplateEntity>>;
String _$historicalStatsHash() => r'5e4c0a141dcc37abc22c86f8d6a3a9b91fe024d8';

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

/// Provider to get historical stats for a symbol
///
/// Copied from [historicalStats].
@ProviderFor(historicalStats)
const historicalStatsProvider = HistoricalStatsFamily();

/// Provider to get historical stats for a symbol
///
/// Copied from [historicalStats].
class HistoricalStatsFamily extends Family<AsyncValue<HistoricalStatsEntity>> {
  /// Provider to get historical stats for a symbol
  ///
  /// Copied from [historicalStats].
  const HistoricalStatsFamily();

  /// Provider to get historical stats for a symbol
  ///
  /// Copied from [historicalStats].
  HistoricalStatsProvider call({
    required String symbol,
    String period = '1Y',
  }) {
    return HistoricalStatsProvider(
      symbol: symbol,
      period: period,
    );
  }

  @override
  HistoricalStatsProvider getProviderOverride(
    covariant HistoricalStatsProvider provider,
  ) {
    return call(
      symbol: provider.symbol,
      period: provider.period,
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
  String? get name => r'historicalStatsProvider';
}

/// Provider to get historical stats for a symbol
///
/// Copied from [historicalStats].
class HistoricalStatsProvider
    extends AutoDisposeFutureProvider<HistoricalStatsEntity> {
  /// Provider to get historical stats for a symbol
  ///
  /// Copied from [historicalStats].
  HistoricalStatsProvider({
    required String symbol,
    String period = '1Y',
  }) : this._internal(
          (ref) => historicalStats(
            ref as HistoricalStatsRef,
            symbol: symbol,
            period: period,
          ),
          from: historicalStatsProvider,
          name: r'historicalStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$historicalStatsHash,
          dependencies: HistoricalStatsFamily._dependencies,
          allTransitiveDependencies:
              HistoricalStatsFamily._allTransitiveDependencies,
          symbol: symbol,
          period: period,
        );

  HistoricalStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.symbol,
    required this.period,
  }) : super.internal();

  final String symbol;
  final String period;

  @override
  Override overrideWith(
    FutureOr<HistoricalStatsEntity> Function(HistoricalStatsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HistoricalStatsProvider._internal(
        (ref) => create(ref as HistoricalStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        symbol: symbol,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HistoricalStatsEntity> createElement() {
    return _HistoricalStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoricalStatsProvider &&
        other.symbol == symbol &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, symbol.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HistoricalStatsRef
    on AutoDisposeFutureProviderRef<HistoricalStatsEntity> {
  /// The parameter `symbol` of this provider.
  String get symbol;

  /// The parameter `period` of this provider.
  String get period;
}

class _HistoricalStatsProviderElement
    extends AutoDisposeFutureProviderElement<HistoricalStatsEntity>
    with HistoricalStatsRef {
  _HistoricalStatsProviderElement(super.provider);

  @override
  String get symbol => (origin as HistoricalStatsProvider).symbol;
  @override
  String get period => (origin as HistoricalStatsProvider).period;
}

String _$runSimulationHash() => r'13e074254e991e50ea2b95e392310760bef2525d';

/// Provider to run simulation
///
/// Copied from [RunSimulation].
@ProviderFor(RunSimulation)
final runSimulationProvider = AutoDisposeAsyncNotifierProvider<RunSimulation,
    SimulationResultEntity?>.internal(
  RunSimulation.new,
  name: r'runSimulationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$runSimulationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RunSimulation = AutoDisposeAsyncNotifier<SimulationResultEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

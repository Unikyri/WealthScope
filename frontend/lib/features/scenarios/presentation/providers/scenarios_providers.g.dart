// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scenarios_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for ScenariosRepository

@ProviderFor(scenariosRepository)
final scenariosRepositoryProvider = ScenariosRepositoryProvider._();

/// Provider for ScenariosRepository

final class ScenariosRepositoryProvider extends $FunctionalProvider<
    ScenariosRepository,
    ScenariosRepository,
    ScenariosRepository> with $Provider<ScenariosRepository> {
  /// Provider for ScenariosRepository
  ScenariosRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scenariosRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scenariosRepositoryHash();

  @$internal
  @override
  $ProviderElement<ScenariosRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScenariosRepository create(Ref ref) {
    return scenariosRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScenariosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScenariosRepository>(value),
    );
  }
}

String _$scenariosRepositoryHash() =>
    r'db46c312f23d4bb69298913a65c22cb7c50cf691';

/// Provider to get scenario templates

@ProviderFor(scenarioTemplates)
final scenarioTemplatesProvider = ScenarioTemplatesProvider._();

/// Provider to get scenario templates

final class ScenarioTemplatesProvider extends $FunctionalProvider<
        AsyncValue<List<ScenarioTemplateEntity>>,
        List<ScenarioTemplateEntity>,
        FutureOr<List<ScenarioTemplateEntity>>>
    with
        $FutureModifier<List<ScenarioTemplateEntity>>,
        $FutureProvider<List<ScenarioTemplateEntity>> {
  /// Provider to get scenario templates
  ScenarioTemplatesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'scenarioTemplatesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scenarioTemplatesHash();

  @$internal
  @override
  $FutureProviderElement<List<ScenarioTemplateEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ScenarioTemplateEntity>> create(Ref ref) {
    return scenarioTemplates(ref);
  }
}

String _$scenarioTemplatesHash() => r'4e0940cc40eca3324a3d1fe0517ac8c35b971104';

/// Provider to get historical stats for a symbol

@ProviderFor(historicalStats)
final historicalStatsProvider = HistoricalStatsFamily._();

/// Provider to get historical stats for a symbol

final class HistoricalStatsProvider extends $FunctionalProvider<
        AsyncValue<HistoricalStatsEntity>,
        HistoricalStatsEntity,
        FutureOr<HistoricalStatsEntity>>
    with
        $FutureModifier<HistoricalStatsEntity>,
        $FutureProvider<HistoricalStatsEntity> {
  /// Provider to get historical stats for a symbol
  HistoricalStatsProvider._(
      {required HistoricalStatsFamily super.from,
      required ({
        String symbol,
        String period,
      })
          super.argument})
      : super(
          retry: null,
          name: r'historicalStatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$historicalStatsHash();

  @override
  String toString() {
    return r'historicalStatsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<HistoricalStatsEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<HistoricalStatsEntity> create(Ref ref) {
    final argument = this.argument as ({
      String symbol,
      String period,
    });
    return historicalStats(
      ref,
      symbol: argument.symbol,
      period: argument.period,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HistoricalStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$historicalStatsHash() => r'3a41db45b5bd94f0a3ab3371c2513bb7e2db8985';

/// Provider to get historical stats for a symbol

final class HistoricalStatsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<HistoricalStatsEntity>,
            ({
              String symbol,
              String period,
            })> {
  HistoricalStatsFamily._()
      : super(
          retry: null,
          name: r'historicalStatsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider to get historical stats for a symbol

  HistoricalStatsProvider call({
    required String symbol,
    String period = '1Y',
  }) =>
      HistoricalStatsProvider._(argument: (
        symbol: symbol,
        period: period,
      ), from: this);

  @override
  String toString() => r'historicalStatsProvider';
}

/// Provider to run simulation

@ProviderFor(RunSimulation)
final runSimulationProvider = RunSimulationProvider._();

/// Provider to run simulation
final class RunSimulationProvider
    extends $AsyncNotifierProvider<RunSimulation, SimulationResultEntity?> {
  /// Provider to run simulation
  RunSimulationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'runSimulationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$runSimulationHash();

  @$internal
  @override
  RunSimulation create() => RunSimulation();
}

String _$runSimulationHash() => r'704635243bb67eb9682225328028dee65414c760';

/// Provider to run simulation

abstract class _$RunSimulation extends $AsyncNotifier<SimulationResultEntity?> {
  FutureOr<SimulationResultEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<SimulationResultEntity?>, SimulationResultEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<SimulationResultEntity?>,
            SimulationResultEntity?>,
        AsyncValue<SimulationResultEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

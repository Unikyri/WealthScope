// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Simulator Provider
/// Manages What-If scenario simulations

@ProviderFor(Simulator)
final simulatorProvider = SimulatorProvider._();

/// Simulator Provider
/// Manages What-If scenario simulations
final class SimulatorProvider
    extends $NotifierProvider<Simulator, AsyncValue<ScenarioResult?>> {
  /// Simulator Provider
  /// Manages What-If scenario simulations
  SimulatorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'simulatorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$simulatorHash();

  @$internal
  @override
  Simulator create() => Simulator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ScenarioResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ScenarioResult?>>(value),
    );
  }
}

String _$simulatorHash() => r'd7f749126a518fad7527518b6970867eb8f1701c';

/// Simulator Provider
/// Manages What-If scenario simulations

abstract class _$Simulator extends $Notifier<AsyncValue<ScenarioResult?>> {
  AsyncValue<ScenarioResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<ScenarioResult?>, AsyncValue<ScenarioResult?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ScenarioResult?>, AsyncValue<ScenarioResult?>>,
        AsyncValue<ScenarioResult?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

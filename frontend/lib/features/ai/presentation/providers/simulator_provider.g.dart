// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$simulatorHash() => r'a2b99c6ee2cbe045fee06b471b5e243b6841b299';

/// Simulator Provider
/// Manages What-If scenario simulations
///
/// Copied from [Simulator].
@ProviderFor(Simulator)
final simulatorProvider = AutoDisposeNotifierProvider<Simulator,
    AsyncValue<ScenarioResult?>>.internal(
  Simulator.new,
  name: r'simulatorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$simulatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Simulator = AutoDisposeNotifier<AsyncValue<ScenarioResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

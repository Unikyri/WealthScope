// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for portfolio performance metrics

@ProviderFor(Performance)
final performanceProvider = PerformanceProvider._();

/// Provider for portfolio performance metrics
final class PerformanceProvider
    extends $AsyncNotifierProvider<Performance, PortfolioPerformance> {
  /// Provider for portfolio performance metrics
  PerformanceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'performanceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$performanceHash();

  @$internal
  @override
  Performance create() => Performance();
}

String _$performanceHash() => r'547eaf797af16f949ff401631a18423ad68eb249';

/// Provider for portfolio performance metrics

abstract class _$Performance extends $AsyncNotifier<PortfolioPerformance> {
  FutureOr<PortfolioPerformance> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<PortfolioPerformance>, PortfolioPerformance>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<PortfolioPerformance>, PortfolioPerformance>,
        AsyncValue<PortfolioPerformance>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

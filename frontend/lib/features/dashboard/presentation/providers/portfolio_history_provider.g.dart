// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for portfolio history data

@ProviderFor(PortfolioHistory)
final portfolioHistoryProvider = PortfolioHistoryFamily._();

/// Provider for portfolio history data
final class PortfolioHistoryProvider extends $AsyncNotifierProvider<
    PortfolioHistory, List<PortfolioHistoryPoint>> {
  /// Provider for portfolio history data
  PortfolioHistoryProvider._(
      {required PortfolioHistoryFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'portfolioHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$portfolioHistoryHash();

  @override
  String toString() {
    return r'portfolioHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PortfolioHistory create() => PortfolioHistory();

  @override
  bool operator ==(Object other) {
    return other is PortfolioHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$portfolioHistoryHash() => r'01429bd7c5145350832938d709f4a27d5a02f9a0';

/// Provider for portfolio history data

final class PortfolioHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
            PortfolioHistory,
            AsyncValue<List<PortfolioHistoryPoint>>,
            List<PortfolioHistoryPoint>,
            FutureOr<List<PortfolioHistoryPoint>>,
            String> {
  PortfolioHistoryFamily._()
      : super(
          retry: null,
          name: r'portfolioHistoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for portfolio history data

  PortfolioHistoryProvider call(
    String period,
  ) =>
      PortfolioHistoryProvider._(argument: period, from: this);

  @override
  String toString() => r'portfolioHistoryProvider';
}

/// Provider for portfolio history data

abstract class _$PortfolioHistory
    extends $AsyncNotifier<List<PortfolioHistoryPoint>> {
  late final _$args = ref.$arg as String;
  String get period => _$args;

  FutureOr<List<PortfolioHistoryPoint>> build(
    String period,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<PortfolioHistoryPoint>>,
        List<PortfolioHistoryPoint>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PortfolioHistoryPoint>>,
            List<PortfolioHistoryPoint>>,
        AsyncValue<List<PortfolioHistoryPoint>>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Provider for selected period

@ProviderFor(SelectedPeriod)
final selectedPeriodProvider = SelectedPeriodProvider._();

/// Provider for selected period
final class SelectedPeriodProvider
    extends $NotifierProvider<SelectedPeriod, String> {
  /// Provider for selected period
  SelectedPeriodProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedPeriodProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedPeriodHash();

  @$internal
  @override
  SelectedPeriod create() => SelectedPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedPeriodHash() => r'350c80e7ccd28df347529c47fe73b7233cdbbb9b';

/// Provider for selected period

abstract class _$SelectedPeriod extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for PortfolioRepository

@ProviderFor(portfolioRepository)
final portfolioRepositoryProvider = PortfolioRepositoryProvider._();

/// Provider for PortfolioRepository

final class PortfolioRepositoryProvider extends $FunctionalProvider<
    PortfolioRepository,
    PortfolioRepository,
    PortfolioRepository> with $Provider<PortfolioRepository> {
  /// Provider for PortfolioRepository
  PortfolioRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'portfolioRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$portfolioRepositoryHash();

  @$internal
  @override
  $ProviderElement<PortfolioRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PortfolioRepository create(Ref ref) {
    return portfolioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PortfolioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PortfolioRepository>(value),
    );
  }
}

String _$portfolioRepositoryHash() =>
    r'25a44b90a8d3eb97f3a9b5dcfd0ad6e630c81856';

/// Provider to fetch portfolio summary

@ProviderFor(portfolioSummary)
final portfolioSummaryProvider = PortfolioSummaryProvider._();

/// Provider to fetch portfolio summary

final class PortfolioSummaryProvider extends $FunctionalProvider<
        AsyncValue<PortfolioSummary>,
        PortfolioSummary,
        FutureOr<PortfolioSummary>>
    with $FutureModifier<PortfolioSummary>, $FutureProvider<PortfolioSummary> {
  /// Provider to fetch portfolio summary
  PortfolioSummaryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'portfolioSummaryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$portfolioSummaryHash();

  @$internal
  @override
  $FutureProviderElement<PortfolioSummary> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioSummary> create(Ref ref) {
    return portfolioSummary(ref);
  }
}

String _$portfolioSummaryHash() => r'4da1de30f3c5cdec8a217adfac8a01e69cf2e00c';

/// Provider to fetch portfolio risk analysis

@ProviderFor(portfolioRiskAnalysis)
final portfolioRiskAnalysisProvider = PortfolioRiskAnalysisProvider._();

/// Provider to fetch portfolio risk analysis

final class PortfolioRiskAnalysisProvider extends $FunctionalProvider<
        AsyncValue<PortfolioRiskAnalysis>,
        PortfolioRiskAnalysis,
        FutureOr<PortfolioRiskAnalysis>>
    with
        $FutureModifier<PortfolioRiskAnalysis>,
        $FutureProvider<PortfolioRiskAnalysis> {
  /// Provider to fetch portfolio risk analysis
  PortfolioRiskAnalysisProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'portfolioRiskAnalysisProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$portfolioRiskAnalysisHash();

  @$internal
  @override
  $FutureProviderElement<PortfolioRiskAnalysis> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioRiskAnalysis> create(Ref ref) {
    return portfolioRiskAnalysis(ref);
  }
}

String _$portfolioRiskAnalysisHash() =>
    r'228a2239a10e3c4bfc8ebeb9ae5c30131eb0022c';

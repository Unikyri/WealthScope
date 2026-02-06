// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portfolioRepositoryHash() =>
    r'876027183d3e2f469809311a885c4f3ca415f088';

/// Provider for PortfolioRepository
///
/// Copied from [portfolioRepository].
@ProviderFor(portfolioRepository)
final portfolioRepositoryProvider =
    AutoDisposeProvider<PortfolioRepository>.internal(
  portfolioRepository,
  name: r'portfolioRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioRepositoryRef = AutoDisposeProviderRef<PortfolioRepository>;
String _$portfolioSummaryHash() => r'fb3ea7e4664615db54c1338332f86a8b25bc9394';

/// Provider to fetch portfolio summary
///
/// Copied from [portfolioSummary].
@ProviderFor(portfolioSummary)
final portfolioSummaryProvider =
    AutoDisposeFutureProvider<PortfolioSummary>.internal(
  portfolioSummary,
  name: r'portfolioSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioSummaryRef = AutoDisposeFutureProviderRef<PortfolioSummary>;
String _$portfolioRiskAnalysisHash() =>
    r'002b0f4b294ebcacd3a529205cf15561552dffe5';

/// Provider to fetch portfolio risk analysis
///
/// Copied from [portfolioRiskAnalysis].
@ProviderFor(portfolioRiskAnalysis)
final portfolioRiskAnalysisProvider =
    AutoDisposeFutureProvider<PortfolioRiskAnalysis>.internal(
  portfolioRiskAnalysis,
  name: r'portfolioRiskAnalysisProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioRiskAnalysisHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioRiskAnalysisRef
    = AutoDisposeFutureProviderRef<PortfolioRiskAnalysis>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardRemoteDataSourceHash() =>
    r'a4f7c6298a068e9fecd8bcbaecd2ecaaf03ad743';

/// Dashboard Remote Data Source Provider
///
/// Copied from [dashboardRemoteDataSource].
@ProviderFor(dashboardRemoteDataSource)
final dashboardRemoteDataSourceProvider =
    AutoDisposeProvider<DashboardRemoteDataSource>.internal(
  dashboardRemoteDataSource,
  name: r'dashboardRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRemoteDataSourceRef
    = AutoDisposeProviderRef<DashboardRemoteDataSource>;
String _$dashboardRepositoryHash() =>
    r'549ed3bf6fadfd480e6fcf35725c3a706b557ecb';

/// Dashboard Repository Provider
///
/// Copied from [dashboardRepository].
@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider =
    AutoDisposeProvider<DashboardRepository>.internal(
  dashboardRepository,
  name: r'dashboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardRepositoryRef = AutoDisposeProviderRef<DashboardRepository>;
String _$portfolioSummaryHash() => r'befeaeb286ad09168e50b15c59386c2cbbc07138';

/// Portfolio Summary Provider
/// Fetches and caches the portfolio summary data
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

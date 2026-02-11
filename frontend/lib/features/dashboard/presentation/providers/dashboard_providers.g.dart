// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dashboard Remote Data Source Provider

@ProviderFor(dashboardRemoteDataSource)
final dashboardRemoteDataSourceProvider = DashboardRemoteDataSourceProvider._();

/// Dashboard Remote Data Source Provider

final class DashboardRemoteDataSourceProvider extends $FunctionalProvider<
    DashboardRemoteDataSource,
    DashboardRemoteDataSource,
    DashboardRemoteDataSource> with $Provider<DashboardRemoteDataSource> {
  /// Dashboard Remote Data Source Provider
  DashboardRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DashboardRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardRemoteDataSource create(Ref ref) {
    return dashboardRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRemoteDataSource>(value),
    );
  }
}

String _$dashboardRemoteDataSourceHash() =>
    r'f89b31e8f0104a07595c537db305debaa5db4ba2';

/// Dashboard Repository Provider

@ProviderFor(dashboardRepository)
final dashboardRepositoryProvider = DashboardRepositoryProvider._();

/// Dashboard Repository Provider

final class DashboardRepositoryProvider extends $FunctionalProvider<
    DashboardRepository,
    DashboardRepository,
    DashboardRepository> with $Provider<DashboardRepository> {
  /// Dashboard Repository Provider
  DashboardRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<DashboardRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DashboardRepository create(Ref ref) {
    return dashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardRepository>(value),
    );
  }
}

String _$dashboardRepositoryHash() =>
    r'a7b06005e2acc2e75692bf0b4db948023e8384c2';

/// Portfolio Summary Provider
/// Fetches and caches the portfolio summary data

@ProviderFor(dashboardPortfolioSummary)
final dashboardPortfolioSummaryProvider = DashboardPortfolioSummaryProvider._();

/// Portfolio Summary Provider
/// Fetches and caches the portfolio summary data

final class DashboardPortfolioSummaryProvider extends $FunctionalProvider<
        AsyncValue<PortfolioSummary>,
        PortfolioSummary,
        FutureOr<PortfolioSummary>>
    with $FutureModifier<PortfolioSummary>, $FutureProvider<PortfolioSummary> {
  /// Portfolio Summary Provider
  /// Fetches and caches the portfolio summary data
  DashboardPortfolioSummaryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardPortfolioSummaryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardPortfolioSummaryHash();

  @$internal
  @override
  $FutureProviderElement<PortfolioSummary> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioSummary> create(Ref ref) {
    return dashboardPortfolioSummary(ref);
  }
}

String _$dashboardPortfolioSummaryHash() =>
    r'828d164509811d45288103d37ac5930e73d86af4';

/// Portfolio Risk Provider
/// Fetches and caches the portfolio risk analysis data

@ProviderFor(dashboardPortfolioRisk)
final dashboardPortfolioRiskProvider = DashboardPortfolioRiskProvider._();

/// Portfolio Risk Provider
/// Fetches and caches the portfolio risk analysis data

final class DashboardPortfolioRiskProvider extends $FunctionalProvider<
        AsyncValue<PortfolioRisk>, PortfolioRisk, FutureOr<PortfolioRisk>>
    with $FutureModifier<PortfolioRisk>, $FutureProvider<PortfolioRisk> {
  /// Portfolio Risk Provider
  /// Fetches and caches the portfolio risk analysis data
  DashboardPortfolioRiskProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardPortfolioRiskProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardPortfolioRiskHash();

  @$internal
  @override
  $FutureProviderElement<PortfolioRisk> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PortfolioRisk> create(Ref ref) {
    return dashboardPortfolioRisk(ref);
  }
}

String _$dashboardPortfolioRiskHash() =>
    r'49cfaa9c511f5cb24afc17c856466c633a2648e8';

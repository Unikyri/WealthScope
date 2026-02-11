import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client_provider.dart';
import 'package:wealthscope_app/features/dashboard/data/datasources/dashboard_remote_source.dart';
import 'package:wealthscope_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'dashboard_providers.g.dart';

/// Dashboard Remote Data Source Provider
@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(
  Ref ref,
) {
  final dio = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dio);
}

/// Dashboard Repository Provider
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final remoteSource = ref.watch(dashboardRemoteDataSourceProvider);
  return DashboardRepositoryImpl(remoteSource);
}

/// Portfolio Summary Provider
/// Fetches and caches the portfolio summary data
@riverpod
Future<PortfolioSummary> dashboardPortfolioSummary(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);

  final result = await repository.getPortfolioSummary();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
}

/// Portfolio Risk Provider
/// Fetches and caches the portfolio risk analysis data
@riverpod
Future<PortfolioRisk> dashboardPortfolioRisk(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);

  final result = await repository.getPortfolioRisk();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (risk) => risk,
  );
}

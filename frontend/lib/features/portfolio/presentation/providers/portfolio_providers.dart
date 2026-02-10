import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../../dashboard/domain/entities/portfolio_summary.dart';
import '../../data/datasources/portfolio_remote_datasource.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../domain/repositories/portfolio_repository.dart';

part 'portfolio_providers.g.dart';

/// Provider for PortfolioRepository
@riverpod
PortfolioRepository portfolioRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = PortfolioRemoteDataSource(dio);
  return PortfolioRepositoryImpl(dataSource);
}

/// Provider to fetch portfolio summary
@riverpod
Future<PortfolioSummary> portfolioSummary(Ref ref) async {
  final repository = ref.watch(portfolioRepositoryProvider);
  final result = await repository.getSummary();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
}

/// Provider to fetch portfolio risk analysis
@riverpod
Future<PortfolioRiskAnalysis> portfolioRiskAnalysis(
  Ref ref,
) async {
  final repository = ref.watch(portfolioRepositoryProvider);
  final result = await repository.getRiskAnalysis();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (analysis) => analysis,
  );
}

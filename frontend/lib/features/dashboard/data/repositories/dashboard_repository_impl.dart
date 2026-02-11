import 'package:fpdart/fpdart.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/dashboard/data/datasources/dashboard_remote_source.dart';
import 'package:wealthscope_app/features/dashboard/data/models/portfolio_risk_dto.dart';
import 'package:wealthscope_app/features/dashboard/data/models/portfolio_summary_dto.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Dashboard Repository Implementation
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteSource;

  DashboardRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, PortfolioSummary>> getPortfolioSummary() async {
    try {
      final dto = await _remoteSource.getPortfolioSummary();
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PortfolioRisk>> getPortfolioRisk() async {
    try {
      final dto = await _remoteSource.getPortfolioRisk();
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

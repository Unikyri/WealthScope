import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../dashboard/domain/entities/portfolio_summary.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_remote_datasource.dart';
import '../models/portfolio_dto.dart';

/// Implementation of PortfolioRepository
class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource _remoteDataSource;

  PortfolioRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PortfolioSummary>> getSummary() async {
    try {
      final dto = await _remoteDataSource.getSummary();
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PortfolioRiskAnalysis>> getRiskAnalysis() async {
    try {
      final dto = await _remoteDataSource.getRiskAnalysis();
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

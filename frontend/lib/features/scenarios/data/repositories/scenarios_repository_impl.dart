import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/scenario_entity.dart';
import '../../domain/repositories/scenarios_repository.dart';
import '../datasources/scenarios_remote_datasource.dart';
import '../models/scenario_dto.dart';

/// Implementation of ScenariosRepository
class ScenariosRepositoryImpl implements ScenariosRepository {
  final ScenariosRemoteDataSource _remoteDataSource;

  ScenariosRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SimulationResultEntity>> simulate({
    required String type,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final dto = await _remoteDataSource.simulate(
        type: type,
        parameters: parameters,
      );
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HistoricalStatsEntity>> getHistoricalStats({
    required String symbol,
    String period = '1Y',
  }) async {
    try {
      final dto = await _remoteDataSource.getHistoricalStats(
        symbol: symbol,
        period: period,
      );
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScenarioTemplateEntity>>> getTemplates() async {
    try {
      final dtos = await _remoteDataSource.getTemplates();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

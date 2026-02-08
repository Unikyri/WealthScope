import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insights_repository.dart';
import '../datasources/insights_remote_datasource.dart';
import '../models/insight_dto.dart';

/// Implementation of InsightsRepository
class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource _remoteDataSource;

  InsightsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<InsightEntity>>> listInsights({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) async {
    try {
      final dtos = await _remoteDataSource.listInsights(
        type: type,
        category: category,
        priority: priority,
        unread: unread,
        limit: limit,
        offset: offset,
      );
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InsightEntity>> getDailyBriefing() async {
    try {
      final dto = await _remoteDataSource.getDailyBriefing();
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, InsightEntity>> getInsightById(String id) async {
    try {
      final dto = await _remoteDataSource.getInsightById(id);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InsightEntity>>> generateInsights() async {
    try {
      final dtos = await _remoteDataSource.generateInsights();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

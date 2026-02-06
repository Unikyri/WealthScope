import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insights_repository.dart';
import '../datasources/insights_remote_datasource.dart';
import '../models/insight_dto.dart';

/// Implementation of InsightsRepository
class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource _remoteDataSource;

  InsightsRepositoryImpl(this._remoteDataSource);

  @override
  Future<InsightListEntity> listInsights({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) async {
    try {
      final dto = await _remoteDataSource.listInsights(
        type: type,
        category: category,
        priority: priority,
        unread: unread,
        limit: limit,
        offset: offset,
      );
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to list insights: ${e.toString()}');
    }
  }

  @override
  Future<InsightEntity> getDailyBriefing() async {
    try {
      final dto = await _remoteDataSource.getDailyBriefing();
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to get daily briefing: ${e.toString()}');
    }
  }

  @override
  Future<InsightEntity> getInsightById(String id) async {
    try {
      final dto = await _remoteDataSource.getInsightById(id);
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to get insight: ${e.toString()}');
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _remoteDataSource.markAsRead(id);
    } catch (e) {
      throw Exception('Failed to mark insight as read: ${e.toString()}');
    }
  }

  @override
  Future<UnreadCountEntity> getUnreadCount() async {
    try {
      final dto = await _remoteDataSource.getUnreadCount();
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to get unread count: ${e.toString()}');
    }
  }

  @override
  Future<List<InsightEntity>> generateInsights() async {
    try {
      final dtos = await _remoteDataSource.generateInsights();
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to generate insights: ${e.toString()}');
    }
  }
}

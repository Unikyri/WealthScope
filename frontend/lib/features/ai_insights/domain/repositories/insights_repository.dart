import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insight_entity.dart';

/// Abstract Repository for AI Insights
/// Pure Dart - Defines contract
abstract class InsightsRepository {
  /// List all insights with optional filters
  Future<Either<Failure, List<InsightEntity>>> listInsights({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  });

  /// Get today's daily briefing
  Future<Either<Failure, InsightEntity>> getDailyBriefing();

  /// Get insight by ID
  Future<Either<Failure, InsightEntity>> getInsightById(String id);

  /// Mark insight as read
  Future<Either<Failure, void>> markAsRead(String id);

  /// Get unread insight count
  Future<Either<Failure, int>> getUnreadCount();

  /// Force generate new insights
  Future<Either<Failure, List<InsightEntity>>> generateInsights();
}

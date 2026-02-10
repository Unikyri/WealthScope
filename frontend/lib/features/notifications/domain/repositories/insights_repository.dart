import '../entities/insight_entity.dart';

/// Abstract repository for AI Insights
abstract class InsightsRepository {
  /// Get list of insights with optional filters
  Future<InsightListEntity> listInsights({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  });

  /// Get today's daily briefing
  Future<InsightEntity> getDailyBriefing();

  /// Get specific insight by ID
  Future<InsightEntity> getInsightById(String id);

  /// Mark insight as read
  Future<void> markAsRead(String id);

  /// Get unread insights count
  Future<UnreadCountEntity> getUnreadCount();

  /// Generate new insights
  Future<List<InsightEntity>> generateInsights();
}

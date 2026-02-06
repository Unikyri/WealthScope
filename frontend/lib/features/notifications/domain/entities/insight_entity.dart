/// Insight entity from AI Insights API
class InsightEntity {
  final String id;
  final String type; // daily_briefing, alert, recommendation
  final String category; // risk, performance, opportunity, general
  final String priority; // high, medium, low
  final String title;
  final String content;
  final List<String> actionItems;
  final List<String> relatedSymbols;
  final bool isRead;
  final DateTime createdAt;

  const InsightEntity({
    required this.id,
    required this.type,
    required this.category,
    required this.priority,
    required this.title,
    required this.content,
    required this.actionItems,
    required this.relatedSymbols,
    required this.isRead,
    required this.createdAt,
  });
}

/// Insight list response entity
class InsightListEntity {
  final List<InsightEntity> insights;
  final int total;
  final int limit;
  final int offset;
  final int unreadCount;

  const InsightListEntity({
    required this.insights,
    required this.total,
    required this.limit,
    required this.offset,
    required this.unreadCount,
  });
}

/// Unread count entity
class UnreadCountEntity {
  final int count;

  const UnreadCountEntity({required this.count});
}

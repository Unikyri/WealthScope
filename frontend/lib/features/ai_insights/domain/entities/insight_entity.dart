/// Domain Entity for AI Insights
/// Pure Dart - No Flutter dependencies
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

  InsightEntity copyWith({
    String? id,
    String? type,
    String? category,
    String? priority,
    String? title,
    String? content,
    List<String>? actionItems,
    List<String>? relatedSymbols,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return InsightEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      content: content ?? this.content,
      actionItems: actionItems ?? this.actionItems,
      relatedSymbols: relatedSymbols ?? this.relatedSymbols,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

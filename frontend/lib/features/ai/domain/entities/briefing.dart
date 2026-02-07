/// Domain entity representing the AI Daily Briefing (Insight).
/// Matches the API response format from /api/v1/ai/insights/daily
class Briefing {
  final String id;
  final String type;
  final String title;
  final String content; // Markdown content
  final String priority;
  final String category;
  final List<String> actionItems;
  final bool isRead;
  final DateTime createdAt;

  const Briefing({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.priority,
    required this.category,
    required this.actionItems,
    required this.isRead,
    required this.createdAt,
  });

  factory Briefing.fromJson(Map<String, dynamic> json) {
    return Briefing(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'daily_briefing',
      title: json['title'] as String? ?? 'Daily Briefing',
      content: json['content'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
      category: json['category'] as String? ?? 'general',
      actionItems: (json['action_items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Notification preferences entity
/// Manages user preferences for different notification types
class NotificationPreferences {
  final bool priceAlerts;
  final bool dailyBriefing;
  final bool portfolioAlerts;
  final bool aiInsights;

  const NotificationPreferences({
    required this.priceAlerts,
    required this.dailyBriefing,
    required this.portfolioAlerts,
    required this.aiInsights,
  });

  /// Default preferences (all enabled)
  factory NotificationPreferences.defaults() {
    return const NotificationPreferences(
      priceAlerts: true,
      dailyBriefing: true,
      portfolioAlerts: true,
      aiInsights: true,
    );
  }

  /// Create from JSON
  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      priceAlerts: json['priceAlerts'] as bool? ?? true,
      dailyBriefing: json['dailyBriefing'] as bool? ?? true,
      portfolioAlerts: json['portfolioAlerts'] as bool? ?? true,
      aiInsights: json['aiInsights'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'priceAlerts': priceAlerts,
      'dailyBriefing': dailyBriefing,
      'portfolioAlerts': portfolioAlerts,
      'aiInsights': aiInsights,
    };
  }

  /// Copy with method for immutable updates
  NotificationPreferences copyWith({
    bool? priceAlerts,
    bool? dailyBriefing,
    bool? portfolioAlerts,
    bool? aiInsights,
  }) {
    return NotificationPreferences(
      priceAlerts: priceAlerts ?? this.priceAlerts,
      dailyBriefing: dailyBriefing ?? this.dailyBriefing,
      portfolioAlerts: portfolioAlerts ?? this.portfolioAlerts,
      aiInsights: aiInsights ?? this.aiInsights,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationPreferences &&
        other.priceAlerts == priceAlerts &&
        other.dailyBriefing == dailyBriefing &&
        other.portfolioAlerts == portfolioAlerts &&
        other.aiInsights == aiInsights;
  }

  @override
  int get hashCode {
    return Object.hash(
      priceAlerts,
      dailyBriefing,
      portfolioAlerts,
      aiInsights,
    );
  }
}

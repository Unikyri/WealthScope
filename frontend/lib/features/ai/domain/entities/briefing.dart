/// Domain entity representing the AI Morning Briefing.
class Briefing {
  final String summary;
  final List<BriefingInsight> insights;
  final List<BriefingAlert> alerts;
  final PortfolioSnapshot portfolioSnapshot;
  final DateTime generatedAt;

  const Briefing({
    required this.summary,
    required this.insights,
    required this.alerts,
    required this.portfolioSnapshot,
    required this.generatedAt,
  });

  factory Briefing.fromJson(Map<String, dynamic> json) {
    return Briefing(
      summary: json['summary'] as String? ?? '',
      insights: (json['insights'] as List<dynamic>?)
              ?.map((e) => BriefingInsight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => BriefingAlert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      portfolioSnapshot: PortfolioSnapshot.fromJson(
          json['portfolio_snapshot'] as Map<String, dynamic>? ?? {}),
      generatedAt: DateTime.tryParse(json['generated_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// Individual insight for the briefing.
class BriefingInsight {
  final String type;
  final String title;
  final String description;
  final String? symbol;
  final double? changePercent;
  final String priority;

  const BriefingInsight({
    required this.type,
    required this.title,
    required this.description,
    this.symbol,
    this.changePercent,
    this.priority = 'medium',
  });

  factory BriefingInsight.fromJson(Map<String, dynamic> json) {
    return BriefingInsight(
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      symbol: json['symbol'] as String?,
      changePercent: (json['change_percent'] as num?)?.toDouble(),
      priority: json['priority'] as String? ?? 'medium',
    );
  }
}

/// Alert within a briefing.
class BriefingAlert {
  final String type;
  final String message;
  final String severity;
  final String? actionUrl;

  const BriefingAlert({
    required this.type,
    required this.message,
    required this.severity,
    this.actionUrl,
  });

  factory BriefingAlert.fromJson(Map<String, dynamic> json) {
    return BriefingAlert(
      type: json['type'] as String? ?? 'info',
      message: json['message'] as String? ?? '',
      severity: json['severity'] as String? ?? 'low',
      actionUrl: json['action_url'] as String?,
    );
  }
}

/// Portfolio snapshot for the briefing.
class PortfolioSnapshot {
  final double totalValue;
  final double dayChange;
  final double dayChangePercent;
  final int assetCount;

  const PortfolioSnapshot({
    required this.totalValue,
    required this.dayChange,
    required this.dayChangePercent,
    required this.assetCount,
  });

  factory PortfolioSnapshot.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshot(
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      dayChange: (json['day_change'] as num?)?.toDouble() ?? 0.0,
      dayChangePercent: (json['day_change_percent'] as num?)?.toDouble() ?? 0.0,
      assetCount: json['asset_count'] as int? ?? 0,
    );
  }
}

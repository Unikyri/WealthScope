import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/ai_insights/presentation/providers/insights_providers.dart';
import '../../domain/entities/notification.dart';

part 'notifications_provider.g.dart';

/// Backwards compatibility: Convert insights to notifications format
/// Backwards compatibility: Convert insights to notifications format
@riverpod
Future<List<AppNotification>> notifications(Ref ref) async {
  // Use insightsListProvider from insights_providers.dart
  final insightsList = await ref.watch(insightsListProvider().future);
  
  return insightsList.map((insight) {
    return AppNotification(
      id: insight.id,
      title: insight.title,
      message: _truncateContent(insight.content),
      type: _mapInsightTypeToNotificationType(insight.type),
      timestamp: insight.createdAt,
      isRead: insight.isRead,
      assetId: insight.relatedSymbols.isNotEmpty ? insight.relatedSymbols.first : null,
      actionUrl: null,
    );
  }).toList();
}

/// Truncate long content for notification preview
String _truncateContent(String content) {
  // Remove markdown headers and excessive whitespace
  final cleaned = content
      .replaceAll(RegExp(r'#+\s*'), '') // Remove markdown headers
      .replaceAll(RegExp(r'\*\*'), '') // Remove bold markers
      .replaceAll(RegExp(r'\n+'), ' ') // Replace newlines with space
      .trim();
  
  // Limit to 200 characters
  if (cleaned.length <= 200) return cleaned;
  
  // Find last complete word before 200 chars
  final truncated = cleaned.substring(0, 200);
  final lastSpace = truncated.lastIndexOf(' ');
  
  return lastSpace > 0 
      ? '${truncated.substring(0, lastSpace)}...'
      : '${truncated}...';
}

/// Provider for unread notifications count (backwards compatibility)
@riverpod
Future<int> unreadNotificationsCount(Ref ref) async {
  // Watch the insights count directly to ensure reactivity
  final count = await ref.watch(unreadInsightsCountProvider.future);
  return count;
}

/// Helper to map insight type to notification type
NotificationType _mapInsightTypeToNotificationType(String insightType) {
  switch (insightType) {
    case 'alert':
      return NotificationType.priceAlert;
    case 'recommendation':
      return NotificationType.aiInsight;
    case 'daily_briefing':
      return NotificationType.portfolioUpdate;
    default:
      return NotificationType.system;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../features/ai_insights/presentation/providers/insights_providers.dart';
import '../../domain/entities/notification.dart';

part 'notifications_provider.g.dart';

/// Simple notifications provider that maps insights to notifications
/// Uses FutureProvider for simplicity
@riverpod
Future<List<AppNotification>> notifications(Ref ref) async {
  print('🔔 [NOTIFICATIONS_PROVIDER] Ejecutando notifications provider...');
  // Get insights list
  final insights = await ref.watch(defaultInsightsListProvider.future);
  print('🔔 [NOTIFICATIONS_PROVIDER] Insights obtenidos: ${insights.length} items');
  
  // Convert to notifications
  return insights.map((insight) {
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

/// Simple unread count provider
@riverpod
Future<int> unreadNotificationsCount(Ref ref) async {
  print('🔢 [UNREAD_COUNT_PROVIDER] Ejecutando unreadNotificationsCount provider...');
  final count = await ref.watch(unreadInsightsCountProvider.future);
  print('🔢 [UNREAD_COUNT_PROVIDER] Count obtenido: $count');
  return count;
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

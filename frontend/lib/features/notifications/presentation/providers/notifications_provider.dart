import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/insights_remote_datasource.dart';
import '../../data/repositories/insights_repository_impl.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insights_repository.dart';
import '../../domain/entities/notification.dart';

part 'notifications_provider.g.dart';

/// Provider for InsightsRepository
@riverpod
InsightsRepository insightsRepository(InsightsRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = InsightsRemoteDataSource(dio);
  return InsightsRepositoryImpl(dataSource);
}

/// Provider to fetch insights list with optional filters
@riverpod
Future<InsightListEntity> insightsList(
  InsightsListRef ref, {
  String? type,
  String? category,
  String? priority,
  bool? unread,
  int limit = 20,
  int offset = 0,
}) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return await repository.listInsights(
    type: type,
    category: category,
    priority: priority,
    unread: unread,
    limit: limit,
    offset: offset,
  );
}

/// Provider to get daily briefing
@riverpod
Future<InsightEntity> dailyBriefing(DailyBriefingRef ref) async {
  final repository = ref.watch(insightsRepositoryProvider);
  return await repository.getDailyBriefing();
}

/// Provider for unread count
@riverpod
Future<int> unreadInsightsCount(UnreadInsightsCountRef ref) async {
  final repository = ref.watch(insightsRepositoryProvider);
  final result = await repository.getUnreadCount();
  return result.count;
}

/// Provider to mark insight as read
@riverpod
class MarkInsightAsRead extends _$MarkInsightAsRead {
  @override
  FutureOr<void> build() {}

  Future<void> mark(String id) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(insightsRepositoryProvider);
      await repository.markAsRead(id);
      state = const AsyncData(null);
      
      // Use refresh instead of invalidate for immediate update
      ref.refresh(unreadInsightsCountProvider);
      ref.refresh(unreadNotificationsCountProvider);
      ref.refresh(notificationsProvider);
      ref.refresh(insightsListProvider(limit: 20, offset: 0));
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Backwards compatibility: Convert insights to notifications format
@riverpod
Future<List<AppNotification>> notifications(NotificationsRef ref) async {
  final insightsAsync = await ref.watch(insightsListProvider(
    limit: 20,
    offset: 0,
  ).future);
  
  return insightsAsync.insights.map((insight) {
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
Future<int> unreadNotificationsCount(UnreadNotificationsCountRef ref) async {
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

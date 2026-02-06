# Notifications API Integration - Quick Reference

## Overview
Complete integration of AI Insights API endpoints into the notifications feature.

## API Endpoints Integrated

### List Insights
```dart
GET /api/v1/ai/insights
Query Parameters:
- type: string (daily_briefing, alert, recommendation)
- category: string (risk, performance, opportunity, general)
- priority: string (high, medium, low)
- unread: boolean
- limit: int (default 20, max 100)
- offset: int (default 0)
```

### Daily Briefing
```dart
GET /api/v1/ai/insights/daily
Returns today's daily briefing or generates a new one
```

### Get Insight by ID
```dart
GET /api/v1/ai/insights/{id}
```

### Mark as Read
```dart
PUT /api/v1/ai/insights/{id}/read
```

### Unread Count
```dart
GET /api/v1/ai/insights/unread/count
Returns: { "count": int }
```

### Generate New Insights
```dart
POST /api/v1/ai/insights/generate
Forces generation of new insights based on current portfolio analysis
```

## Architecture

### Domain Layer
```
lib/features/notifications/domain/
├── entities/
│   ├── notification.dart (existing)
│   └── insight_entity.dart (new)
└── repositories/
    └── insights_repository.dart (new)
```

**InsightEntity**: Domain representation of an AI insight
- id, type, category, priority
- title, content, actionItems
- relatedSymbols, isRead, createdAt

### Data Layer
```
lib/features/notifications/data/
├── models/
│   └── insight_dto.dart (new with Freezed)
├── datasources/
│   └── insights_remote_datasource.dart (new)
└── repositories/
    └── insights_repository_impl.dart (new)
```

**InsightDto**: DTO with json_serializable
- Maps snake_case API fields to camelCase
- Extension methods to convert to domain entities

### Presentation Layer
```
lib/features/notifications/presentation/
├── providers/
│   └── notifications_provider.dart (updated)
├── screens/
│   └── notifications_screen.dart (updated)
└── widgets/
    └── notification_card.dart (updated)
```

## Providers

### insightsRepositoryProvider
```dart
@riverpod
InsightsRepository insightsRepository(InsightsRepositoryRef ref)
```
Provides the repository instance with Dio client.

### insightsListProvider
```dart
@riverpod
Future<InsightListEntity> insightsList(
  InsightsListRef ref, {
  String? type,
  String? category,
  String? priority,
  bool? unread,
  int limit = 20,
  int offset = 0,
})
```
Fetches insights with optional filters.

### dailyBriefingProvider
```dart
@riverpod
Future<InsightEntity> dailyBriefing(DailyBriefingRef ref)
```
Gets today's daily briefing.

### unreadInsightsCountProvider
```dart
@riverpod
Future<int> unreadInsightsCount(UnreadInsightsCountRef ref)
```
Returns count of unread insights.

### markInsightAsReadProvider
```dart
@riverpod
class MarkInsightAsRead extends _$MarkInsightAsRead {
  Future<void> mark(String id) async
}
```
Marks an insight as read and invalidates related providers.

### notificationsProvider (Backwards Compatibility)
```dart
@riverpod
Future<List<AppNotification>> notifications(NotificationsRef ref)
```
Converts InsightEntity to AppNotification for existing UI.

## Usage Examples

### Display Notifications List
```dart
Consumer(
  builder: (context, ref, _) {
    final notificationsAsync = ref.watch(notificationsProvider);
    
    return notificationsAsync.when(
      data: (notifications) => ListView.builder(...),
      loading: () => NotificationsListSkeleton(),
      error: (e, st) => ErrorWidget(e),
    );
  },
)
```

### Show Unread Count Badge
```dart
Consumer(
  builder: (context, ref, _) {
    final unreadAsync = ref.watch(unreadNotificationsCountProvider);
    
    return unreadAsync.when(
      data: (count) => Badge(
        label: Text('$count'),
        child: Icon(Icons.notifications),
      ),
      loading: () => Icon(Icons.notifications),
      error: (_, __) => Icon(Icons.notifications_off),
    );
  },
)
```

### Mark Insight as Read
```dart
await ref.read(markInsightAsReadProvider.notifier).mark(insightId);
// Automatically refreshes insights list and unread count
```

### Fetch Daily Briefing
```dart
final dailyAsync = ref.watch(dailyBriefingProvider);

dailyAsync.when(
  data: (insight) => DailyBriefingCard(insight: insight),
  loading: () => Skeleton(),
  error: (e, st) => ErrorState(),
);
```

### Filter Insights
```dart
// Show only unread alerts
final alertsAsync = ref.watch(
  insightsListProvider(
    type: 'alert',
    unread: true,
    limit: 10,
  ),
);

// Show high priority recommendations
final recsAsync = ref.watch(
  insightsListProvider(
    type: 'recommendation',
    priority: 'high',
  ),
);
```

## Data Flow

1. **UI requests data**: `ref.watch(notificationsProvider)`
2. **Provider fetches**: Calls `insightsListProvider`
3. **Repository called**: `InsightsRepositoryImpl.listInsights()`
4. **DataSource hits API**: `InsightsRemoteDataSource` via Dio
5. **Response mapped**: `InsightDto` → `InsightEntity` → `AppNotification`
6. **UI updates**: Widget rebuilds with new data

## Migration from Mock Data

### Before (Mock)
```dart
@riverpod
class Notifications extends _$Notifications {
  @override
  List<AppNotification> build() {
    return _generateMockNotifications();
  }
}
```

### After (Real API)
```dart
@riverpod
Future<List<AppNotification>> notifications(NotificationsRef ref) async {
  final insights = await ref.watch(insightsListProvider(...).future);
  return insights.insights.map((i) => i.toNotification()).toList();
}
```

## Error Handling

All repository methods wrap API calls in try-catch:
```dart
try {
  final dto = await _remoteDataSource.listInsights(...);
  return dto.toDomain();
} catch (e) {
  throw Exception('Failed to list insights: ${e.toString()}');
}
```

UI handles errors via AsyncValue:
```dart
notificationsAsync.when(
  data: (data) => SuccessWidget(),
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(
    message: error.toString(),
    onRetry: () => ref.invalidate(notificationsProvider),
  ),
);
```

## Testing the Integration

### 1. Check if insights load
```dart
flutter run
# Navigate to Notifications screen
# Should see real insights from API (or empty state if none)
```

### 2. Test mark as read
```dart
# Tap on unread notification
# Unread indicator should disappear
# Unread count badge should decrease
```

### 3. Test refresh
```dart
# Pull down to refresh on notifications screen
# Should re-fetch insights from API
```

### 4. Test error states
```dart
# Turn off network
# Navigate to notifications
# Should show error message with retry button
```

## API Response Examples

### List Insights Response
```json
{
  "success": true,
  "data": {
    "insights": [
      {
        "id": "uuid",
        "type": "alert",
        "category": "risk",
        "priority": "high",
        "title": "High Risk Alert",
        "content": "Your portfolio has...",
        "action_items": ["Review allocation", "Consider rebalancing"],
        "related_symbols": ["AAPL", "TSLA"],
        "is_read": false,
        "created_at": "2026-02-06T10:00:00Z"
      }
    ],
    "total": 15,
    "limit": 20,
    "offset": 0,
    "unread_count": 5
  },
  "meta": {
    "request_id": "req-123"
  }
}
```

### Daily Briefing Response
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "type": "daily_briefing",
    "category": "general",
    "priority": "medium",
    "title": "Daily Portfolio Briefing",
    "content": "Good morning! Your portfolio...",
    "action_items": ["Check AAPL earnings"],
    "related_symbols": ["AAPL", "MSFT"],
    "is_read": false,
    "created_at": "2026-02-06T06:00:00Z"
  }
}
```

### Unread Count Response
```json
{
  "success": true,
  "data": {
    "count": 5
  }
}
```

## Next Steps / Enhancements

1. **Add Filters UI**: Allow users to filter by type/category/priority
2. **Add Daily Briefing Card**: Prominent card for daily briefing
3. **Push Notifications**: Integrate with FCM for push notifications
4. **Notification Settings**: Allow users to configure notification preferences
5. **Action Items**: Make action items clickable/actionable
6. **Related Assets**: Link related symbols to asset detail screens

## Files Created/Modified

### Created
- `lib/features/notifications/domain/entities/insight_entity.dart`
- `lib/features/notifications/domain/repositories/insights_repository.dart`
- `lib/features/notifications/data/models/insight_dto.dart`
- `lib/features/notifications/data/datasources/insights_remote_datasource.dart`
- `lib/features/notifications/data/repositories/insights_repository_impl.dart`

### Modified
- `lib/features/notifications/presentation/providers/notifications_provider.dart`
- `lib/features/notifications/presentation/screens/notifications_screen.dart`
- `lib/features/notifications/presentation/widgets/notification_card.dart`

## Dependencies Used
- `riverpod_annotation`: State management with code generation
- `freezed`: Immutable DTOs
- `json_serializable`: JSON parsing
- `dio`: HTTP client (via dioClientProvider)

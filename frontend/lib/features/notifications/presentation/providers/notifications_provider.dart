import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/notification.dart';

part 'notifications_provider.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  List<AppNotification> build() {
    return _generateMockNotifications();
  }

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
  }

  void dismiss(String notificationId) {
    state = state.where((n) => n.id != notificationId).toList();
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  Future<void> refresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    state = _generateMockNotifications();
  }

  List<AppNotification> _generateMockNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        title: 'Price Alert: Bitcoin',
        message: 'BTC reached your target price of \$45,000',
        type: NotificationType.priceAlert,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        assetId: 'btc-001',
      ),
      AppNotification(
        id: '2',
        title: 'Portfolio Milestone',
        message: 'Congratulations! Your portfolio gained +10% this month',
        type: NotificationType.milestone,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      AppNotification(
        id: '3',
        title: 'AI Insight',
        message: 'Consider rebalancing your tech stock allocation',
        type: NotificationType.insight,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'Market Alert',
        message: 'High volatility detected in your portfolio',
        type: NotificationType.alert,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: 'Investment Insight',
        message: 'Diversification opportunity detected',
        type: NotificationType.insight,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}

@riverpod
int unreadNotificationsCount(UnreadNotificationsCountRef ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
}

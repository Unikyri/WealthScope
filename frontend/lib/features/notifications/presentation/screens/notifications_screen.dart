import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_list_skeleton.dart';
import 'package:wealthscope_app/shared/widgets/empty_state.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Show unread count badge
          Consumer(
            builder: (context, ref, _) {
              final unreadAsync = ref.watch(unreadNotificationsCountProvider);
              return unreadAsync.when(
                data: (count) => count > 0
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text('$count unread'),
                          backgroundColor: theme.colorScheme.primary,
                          labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState(context);
          }
          
          final groupedNotifications = _groupNotificationsByDate(notifications);
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadNotificationsCountProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _calculateTotalItems(groupedNotifications),
              itemBuilder: (context, index) {
                return _buildGroupedItem(context, ref, groupedNotifications, index);
              },
            ),
          );
        },
        loading: () => const NotificationsListSkeleton(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text('Failed to load notifications'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(notificationsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, List<AppNotification>> _groupNotificationsByDate(
      List<AppNotification> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final Map<String, List<AppNotification>> grouped = {
      'Today': [],
      'Yesterday': [],
      'This Week': [],
      'Older': [],
    };

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      if (notificationDate.isAtSameMomentAs(today)) {
        grouped['Today']!.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        grouped['Yesterday']!.add(notification);
      } else if (notificationDate.isAfter(weekAgo)) {
        grouped['This Week']!.add(notification);
      } else {
        grouped['Older']!.add(notification);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  int _calculateTotalItems(Map<String, List<AppNotification>> grouped) {
    int total = 0;
    for (final entry in grouped.entries) {
      total += 1 + entry.value.length; // 1 for header + notifications
    }
    return total;
  }

  Widget _buildGroupedItem(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<AppNotification>> grouped,
    int index,
  ) {
    int currentIndex = 0;

    for (final entry in grouped.entries) {
      final groupName = entry.key;
      final groupNotifications = entry.value;
      final groupSize = 1 + groupNotifications.length;

      if (index < currentIndex + groupSize) {
        final relativeIndex = index - currentIndex;

        // First item is the header
        if (relativeIndex == 0) {
          return _buildGroupHeader(context, groupName);
        }

        // Rest are notifications
        final notification = groupNotifications[relativeIndex - 1];
        return NotificationCard(notification: notification);
      }

      currentIndex += groupSize;
    }

    return const SizedBox.shrink();
  }

  Widget _buildGroupHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const EmptyState.notifications();
  }
}

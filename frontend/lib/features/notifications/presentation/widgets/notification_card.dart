import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/notification.dart';
import '../providers/notifications_provider.dart';

class NotificationCard extends ConsumerWidget {
  final AppNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationStyle = _getNotificationStyle(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ref.read(notificationsProvider.notifier).dismiss(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification dismissed'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: notification.isRead ? 0 : 2,
        color: notification.isRead
            ? theme.colorScheme.surface
            : theme.colorScheme.primaryContainer.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              ref.read(notificationsProvider.notifier).markAsRead(notification.id);
            }
            _handleNotificationTap(context, notification);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIcon(context, notificationStyle),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  notification.message,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                        _handleActionTap(context, notification);
                      },
                      icon: Icon(notificationStyle.actionIcon, size: 18),
                      label: Text(notificationStyle.actionLabel),
                      style: TextButton.styleFrom(
                        foregroundColor: notificationStyle.color,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ref.read(notificationsProvider.notifier).dismiss(notification.id);
                      },
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Dismiss'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, _NotificationStyle style) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: style.color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(style.icon, color: style.color, size: 24),
    );
  }

  _NotificationStyle _getNotificationStyle(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return _NotificationStyle(
          icon: Icons.warning,
          color: Colors.orange,
          actionIcon: Icons.visibility,
          actionLabel: 'View Asset',
        );
      case NotificationType.insight:
        return _NotificationStyle(
          icon: Icons.lightbulb,
          color: Colors.blue,
          actionIcon: Icons.insights,
          actionLabel: 'View Insight',
        );
      case NotificationType.milestone:
        return _NotificationStyle(
          icon: Icons.celebration,
          color: Colors.green,
          actionIcon: Icons.pie_chart,
          actionLabel: 'View Portfolio',
        );
      case NotificationType.priceAlert:
        return _NotificationStyle(
          icon: Icons.trending_up,
          color: Colors.purple,
          actionIcon: Icons.visibility,
          actionLabel: 'View Asset',
        );
    }
  }

  void _handleNotificationTap(BuildContext context, AppNotification notification) {
    // Handle tap based on notification type
    switch (notification.type) {
      case NotificationType.alert:
      case NotificationType.priceAlert:
        if (notification.assetId != null) {
          context.push('/assets/${notification.assetId}');
        }
        break;
      case NotificationType.insight:
        context.push('/ai-advisor');
        break;
      case NotificationType.milestone:
        context.push('/dashboard');
        break;
    }
  }

  void _handleActionTap(BuildContext context, AppNotification notification) {
    _handleNotificationTap(context, notification);
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _NotificationStyle {
  final IconData icon;
  final Color color;
  final IconData actionIcon;
  final String actionLabel;

  const _NotificationStyle({
    required this.icon,
    required this.color,
    required this.actionIcon,
    required this.actionLabel,
  });
}

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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: notification.isRead ? 0 : 2,
      color: notification.isRead
          ? theme.colorScheme.surface
          : theme.colorScheme.primaryContainer.withOpacity(0.1),
      child: InkWell(
        onTap: () async {
          if (!notification.isRead) {
            try {
              await ref.read(markInsightAsReadProvider.notifier).mark(notification.id);
            } catch (e) {
              // Handle error silently or show a snackbar
            }
          }
          if (notification.assetId != null) {
            // Navigate to asset detail
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildIcon(context),
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
                  if (notification.assetId != null)
                    TextButton.icon(
                      onPressed: () async {
                        if (!notification.isRead) {
                          try {
                            await ref.read(markInsightAsReadProvider.notifier).mark(notification.id);
                          } catch (e) {
                            // Handle error
                          }
                        }
                        // Navigate to asset
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View Asset'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;
    Color color;

    switch (notification.type) {
      case NotificationType.priceAlert:
        iconData = Icons.trending_up;
        color = Colors.green;
        break;
      case NotificationType.portfolioUpdate:
        iconData = Icons.pie_chart;
        color = theme.colorScheme.primary;
        break;
      case NotificationType.aiInsight:
        iconData = Icons.psychology;
        color = Colors.purple;
        break;
      case NotificationType.documentProcessed:
        iconData = Icons.check_circle;
        color = const Color(0xFF00897B);
        break;
      case NotificationType.system:
        iconData = Icons.info;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 24),
    );
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

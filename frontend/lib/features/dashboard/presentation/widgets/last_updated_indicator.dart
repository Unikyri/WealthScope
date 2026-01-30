import 'package:flutter/material.dart';

/// Widget that displays when the portfolio data was last updated
/// Shows relative time (e.g., "Updated 5 minutes ago")
class LastUpdatedIndicator extends StatelessWidget {
  final DateTime lastUpdated;

  const LastUpdatedIndicator({
    required this.lastUpdated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimeAgo(lastUpdated),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// Formats the time difference as a relative time string
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Updated now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Updated $minutes min ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Updated ${hours}h ago';
    } else {
      final days = difference.inDays;
      return 'Updated ${days}d ago';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/price_status.dart';

/// Price Status Chip
/// Displays an indicator showing if prices are updated or cached
class PriceStatusChip extends StatelessWidget {
  final DateTime lastUpdated;
  final bool? isMarketOpen;

  const PriceStatusChip({
    required this.lastUpdated,
    this.isMarketOpen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final diff = now.difference(lastUpdated);

    final PriceStatus status;
    final String label;
    final Color color;

    if (isMarketOpen == false) {
      status = PriceStatus.marketClosed;
      label = 'Market Closed';
      color = theme.colorScheme.outline;
    } else if (diff.inMinutes < 5) {
      status = PriceStatus.current;
      label = 'Prices Updated';
      color = theme.colorScheme.primary;
    } else if (diff.inMinutes < 60) {
      status = PriceStatus.cached;
      label = '${diff.inMinutes} min ago';
      color = theme.colorScheme.tertiary;
    } else {
      status = PriceStatus.stale;
      label = 'Prices May Be Outdated';
      color = theme.colorScheme.error;
    }

    return Chip(
      avatar: Icon(
        _getIcon(status),
        size: 16,
        color: color,
      ),
      label: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: color,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(
        color: color.withOpacity(0.3),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  IconData _getIcon(PriceStatus status) {
    switch (status) {
      case PriceStatus.current:
        return Icons.check_circle;
      case PriceStatus.cached:
        return Icons.access_time;
      case PriceStatus.stale:
        return Icons.warning;
      case PriceStatus.marketClosed:
        return Icons.schedule;
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

/// Shows price update age with color by freshness.
/// - Green: < 5 min
/// - Yellow: 5-30 min
/// - Grey: > 30 min
/// - Scout plan: "Delayed 15 min" or "At close" (no real-time)
class PriceFreshnessIndicator extends StatefulWidget {
  final DateTime? lastUpdated;
  final bool isScoutPlan;
  final bool compact;

  const PriceFreshnessIndicator({
    super.key,
    this.lastUpdated,
    this.isScoutPlan = false,
    this.compact = false,
  });

  @override
  State<PriceFreshnessIndicator> createState() => _PriceFreshnessIndicatorState();
}

class _PriceFreshnessIndicatorState extends State<PriceFreshnessIndicator> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresh "hace X min" every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isScout = widget.isScoutPlan;


    if (isScout) {
      return _buildScoutLabel(theme);
    }

    if (widget.lastUpdated == null) {
      return widget.compact
          ? _compactChip('N/A', AppTheme.textGrey)
          : _buildLabel(theme, 'N/A', AppTheme.textGrey);
    }

    final since = DateTime.now().difference(widget.lastUpdated!);
    final (label, color) = _getLabelAndColor(since);
    return widget.compact ? _compactChip(label, color) : _buildLabel(theme, label, color);
  }

  (String, Color) _getLabelAndColor(Duration since) {
    final minutes = since.inMinutes;
    if (minutes < 1) {
      return ('Updated now', AppTheme.emeraldAccent);
    }
    if (minutes < 5) {
      return ('Updated $minutes min ago', AppTheme.emeraldAccent);
    }
    if (minutes < 30) {
      return ('Updated $minutes min ago', Colors.amber);
    }
    return ('Updated $minutes min ago', AppTheme.textGrey);
  }

  Widget _buildScoutLabel(ThemeData theme) {
    const label = 'Delayed 15 min';
    final color = Colors.amber;
    return widget.compact ? _compactChip(label, color) : _buildLabel(theme, label, color);
  }

  Widget _compactChip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLabel(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.schedule, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

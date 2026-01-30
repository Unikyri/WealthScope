import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

/// Configuration for alert appearance based on severity
class _AlertConfig {
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;

  const _AlertConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}

/// Card widget displaying risk alerts with severity-based styling
class RiskAlertCard extends StatelessWidget {
  final RiskAlert alert;

  const RiskAlertCard({
    required this.alert,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(context, alert.severity);

    return Card(
      elevation: 0,
      color: config.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: config.iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              config.icon,
              color: config.iconColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: config.textColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: config.textColor.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns alert configuration based on severity level
  _AlertConfig _getConfig(BuildContext context, AlertSeverity severity) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (severity) {
      case AlertSeverity.critical:
        return _AlertConfig(
          backgroundColor: colorScheme.errorContainer,
          iconColor: colorScheme.error,
          textColor: colorScheme.onErrorContainer,
          icon: Icons.error,
        );
      case AlertSeverity.warning:
        return _AlertConfig(
          backgroundColor: const Color(0xFFFFF4E5),
          iconColor: const Color(0xFFFF9800),
          textColor: const Color(0xFF663C00),
          icon: Icons.warning_amber,
        );
      case AlertSeverity.info:
        return _AlertConfig(
          backgroundColor: colorScheme.primaryContainer,
          iconColor: colorScheme.primary,
          textColor: colorScheme.onPrimaryContainer,
          icon: Icons.info_outline,
        );
    }
  }
}

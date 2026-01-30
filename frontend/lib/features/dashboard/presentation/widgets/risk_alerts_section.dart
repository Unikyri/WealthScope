import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/risk_alert_card.dart';

/// Risk Alerts Section Widget
/// Displays risk alerts for the user's portfolio
class RiskAlertsSection extends StatelessWidget {
  final List<RiskAlert> alerts;

  const RiskAlertsSection({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Risk Alerts',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...alerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RiskAlertCard(alert: alert),
            )),
      ],
    );
  }
}

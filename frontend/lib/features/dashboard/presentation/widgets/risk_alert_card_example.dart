import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/risk_alert_card.dart';

/// Example usage of RiskAlertCard widget
/// 
/// This file demonstrates how to use the RiskAlertCard widget
/// with different severity levels.
class RiskAlertCardExample extends StatelessWidget {
  const RiskAlertCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Alert Card Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Critical Alert Example
            RiskAlertCard(
              alert: RiskAlert(
                id: '1',
                severity: AlertSeverity.critical,
                title: 'Critical Risk Detected',
                message: 'Your portfolio has significant concentration risk. '
                    'Over 80% is invested in a single asset.',
                timestamp: DateTime.now(),
              ),
            ),
            const SizedBox(height: 16),

            // Warning Alert Example
            RiskAlertCard(
              alert: RiskAlert(
                id: '2',
                severity: AlertSeverity.warning,
                title: 'High Concentration in Technology',
                message: '65% of your portfolio is in Technology sector. '
                    'Consider diversifying to reduce risk.',
                timestamp: DateTime.now(),
              ),
            ),
            const SizedBox(height: 16),

            // Info Alert Example
            RiskAlertCard(
              alert: RiskAlert(
                id: '3',
                severity: AlertSeverity.info,
                title: 'Portfolio Rebalancing Suggestion',
                message: 'Based on your investment goals, consider rebalancing '
                    'your portfolio to maintain your target allocation.',
                timestamp: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

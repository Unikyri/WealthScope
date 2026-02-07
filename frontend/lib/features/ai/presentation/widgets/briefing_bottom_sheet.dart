import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/briefing.dart';

/// A beautiful bottom sheet that displays the AI Morning Briefing.
class MorningBriefingBottomSheet extends ConsumerWidget {
  final Briefing briefing;

  const MorningBriefingBottomSheet({
    super.key,
    required this.briefing,
  });

  /// Shows the briefing bottom sheet.
  static Future<void> show(BuildContext context, Briefing briefing) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => MorningBriefingBottomSheet(briefing: briefing),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting
              _buildHeader(context, colorScheme, textTheme),
              const SizedBox(height: 24),

              // Portfolio Snapshot Card
              _buildPortfolioCard(context, colorScheme, textTheme),
              const SizedBox(height: 20),

              // AI Summary
              _buildSummarySection(colorScheme, textTheme),
              const SizedBox(height: 24),

              // Alerts Section
              if (briefing.alerts.isNotEmpty) ...[
                _buildAlertsSection(colorScheme, textTheme),
                const SizedBox(height: 24),
              ],

              // Insights Section
              if (briefing.insights.isNotEmpty)
                _buildInsightsSection(colorScheme, textTheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour < 12) {
      greeting = 'Good Morning';
      icon = Icons.wb_sunny_outlined;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      icon = Icons.wb_cloudy_outlined;
    } else {
      greeting = 'Good Evening';
      icon = Icons.nights_stay_outlined;
    }

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Here\'s your financial briefing',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final snapshot = briefing.portfolioSnapshot;
    final isPositive = snapshot.dayChange >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Value',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer.withAlpha(180),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatNumber(snapshot.totalValue)}',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: changeColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}\$${_formatNumber(snapshot.dayChange.abs())} (${snapshot.dayChangePercent.toStringAsFixed(2)}%)',
                style: textTheme.bodyMedium?.copyWith(
                  color: changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimaryContainer.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${snapshot.assetCount} assets',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'AI Summary',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant.withAlpha(50),
            ),
          ),
          child: Text(
            briefing.summary.isEmpty
                ? 'Your portfolio is performing steadily. No major changes detected today.'
                : briefing.summary,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Alerts',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...briefing.alerts.map((alert) => _buildAlertCard(alert, colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildAlertCard(
    BriefingAlert alert,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    Color alertColor;
    IconData alertIcon;

    switch (alert.severity.toLowerCase()) {
      case 'high':
        alertColor = Colors.red;
        alertIcon = Icons.error;
        break;
      case 'medium':
        alertColor = Colors.orange;
        alertIcon = Icons.warning;
        break;
      default:
        alertColor = Colors.blue;
        alertIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: alertColor.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: alertColor.withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(alertIcon, color: alertColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            Text(
              'Today\'s Insights',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...briefing.insights.map((insight) => _buildInsightCard(insight, colorScheme, textTheme)),
      ],
    );
  }

  Widget _buildInsightCard(
    BriefingInsight insight,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    Color typeColor;
    IconData typeIcon;

    switch (insight.type.toLowerCase()) {
      case 'market':
        typeColor = Colors.blue;
        typeIcon = Icons.show_chart;
        break;
      case 'opportunity':
        typeColor = Colors.green;
        typeIcon = Icons.trending_up;
        break;
      case 'risk':
        typeColor = Colors.orange;
        typeIcon = Icons.shield_outlined;
        break;
      default:
        typeColor = colorScheme.primary;
        typeIcon = Icons.insights;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(typeIcon, color: typeColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  insight.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (insight.changePercent != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (insight.changePercent! >= 0 ? Colors.green : Colors.red)
                        .withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${insight.changePercent! >= 0 ? '+' : ''}${insight.changePercent!.toStringAsFixed(1)}%',
                    style: textTheme.labelSmall?.copyWith(
                      color: insight.changePercent! >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2);
  }
}

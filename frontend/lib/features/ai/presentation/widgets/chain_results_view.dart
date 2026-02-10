import 'package:flutter/material.dart';
import '../../domain/entities/chain_result.dart';

/// Widget that displays the results of a chain scenario simulation.
class ChainResultsView extends StatelessWidget {
  final ChainResult result;
  final VoidCallback? onDismiss;

  const ChainResultsView({
    super.key,
    required this.result,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Cumulative Impact Card
                  _buildCumulativeImpactCard(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Steps Timeline
                  _buildStepsTimeline(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Risk Assessment
                  _buildRiskAssessment(colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // AI Explanation
                  _buildAIExplanation(colorScheme, textTheme),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.route, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chain Simulation',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${result.steps.length} scenarios simulated',
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

  Widget _buildCumulativeImpactCard(ColorScheme colorScheme, TextTheme textTheme) {
    final impact = result.cumulativeImpact;
    final isPositive = impact.absoluteChange >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPositive
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: changeColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cumulative Impact',
            style: textTheme.labelLarge?.copyWith(
              color: changeColor.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}\$${_formatNumber(impact.absoluteChange)}',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: changeColor.shade800,
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${impact.percentChange.toStringAsFixed(2)}% change',
                      style: textTheme.bodyMedium?.copyWith(
                        color: changeColor.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: changeColor,
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildValueLabel('Before', impact.valueBefore, colorScheme, textTheme),
              Icon(Icons.arrow_forward, color: changeColor, size: 20),
              _buildValueLabel('After', impact.valueAfter, colorScheme, textTheme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueLabel(
    String label,
    double value,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          '\$${_formatNumber(value)}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsTimeline(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timeline, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Scenario Steps',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...result.steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == result.steps.length - 1;
          return _buildStepCard(step, index, isLast, colorScheme, textTheme);
        }),
      ],
    );
  }

  Widget _buildStepCard(
    ChainStep step,
    int index,
    bool isLast,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isPositive = step.impact.absoluteChange >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Step content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.scenarioType.replaceAll('_', ' ').toUpperCase(),
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: changeColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${isPositive ? '+' : ''}${step.impact.percentChange.toStringAsFixed(1)}%',
                          style: textTheme.labelSmall?.copyWith(
                            color: changeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (step.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskAssessment(ColorScheme colorScheme, TextTheme textTheme) {
    final risk = result.riskAssessment;
    Color riskColor;
    IconData riskIcon;

    switch (risk.level.toLowerCase()) {
      case 'high':
        riskColor = Colors.red;
        riskIcon = Icons.warning_amber;
        break;
      case 'medium':
        riskColor = Colors.orange;
        riskIcon = Icons.info_outline;
        break;
      default:
        riskColor = Colors.green;
        riskIcon = Icons.check_circle_outline;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: riskColor.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(riskIcon, color: riskColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Assessment: ${risk.level.toUpperCase()}',
                      style: textTheme.titleSmall?.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Score: ${risk.score}/100',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (risk.summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              risk.summary,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
          if (risk.warnings.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...risk.warnings.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      w,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildAIExplanation(ColorScheme colorScheme, TextTheme textTheme) {
    if (result.aiExplanation.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'AI Analysis',
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
            color: colorScheme.surfaceContainerHighest.withAlpha(80),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant.withAlpha(50)),
          ),
          child: Text(
            result.aiExplanation,
            style: textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _formatNumber(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2);
  }
}

extension _ColorBrightness on Color {
  Color get shade700 => HSLColor.fromColor(this).withLightness(0.35).toColor();
  Color get shade800 => HSLColor.fromColor(this).withLightness(0.25).toColor();
}

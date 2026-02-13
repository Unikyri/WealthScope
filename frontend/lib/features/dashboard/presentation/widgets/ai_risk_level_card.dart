import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';

/// Risk level classification based on risk score (0-100)
enum RiskLevel {
  low,
  medium,
  high,
  critical,
}

/// AI-driven Risk Level Card
/// Non-clickable, informational card that displays real portfolio risk data
/// from the backend endpoint /api/v1/portfolio/risk.
class AiRiskLevelCard extends ConsumerWidget {
  final List<AssetTypeBreakdown> breakdownByType;

  const AiRiskLevelCard({
    super.key,
    required this.breakdownByType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskAsync = ref.watch(dashboardPortfolioRiskProvider);

    return riskAsync.when(
      data: (risk) => _buildCard(context, risk),
      loading: () => _buildShimmer(context),
      error: (_, __) => _buildErrorCard(context),
    );
  }

  Widget _buildCard(BuildContext context, PortfolioRisk risk) {
    final level = _classifyRisk(risk.riskScore);
    final color = _riskColor(level);
    final label = _riskLabel(level);
    final subtext = _riskSubtext(risk);

    return _RiskCardShell(
      iconColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header row
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                'RISK LEVEL',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          // Value + gauge + subtext
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 6),
              // Mini risk gauge bar
              _RiskGauge(score: risk.riskScore, color: color),
              const SizedBox(height: 6),
              Text(
                subtext,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Diversification Score: 100 - riskScore (100 = well diversified)
              const SizedBox(height: 4),
              Text(
                _diversificationScoreText(risk),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textGrey,
                    ),
              ),
              // Concentration bars by asset class
              if (breakdownByType.isNotEmpty) ...[
                const SizedBox(height: 6),
                _ConcentrationBars(breakdownByType: breakdownByType),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardGrey,
      highlightColor: AppTheme.cardGrey.withValues(alpha: 0.5),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return _RiskCardShell(
      iconColor: AppTheme.textGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, size: 16,
                  color: AppTheme.textGrey),
              const SizedBox(width: 6),
              Text(
                'RISK LEVEL',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          Text(
            'N/A',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textGrey,
                ),
          ),
        ],
      ),
    );
  }

  RiskLevel _classifyRisk(int riskScore) {
    if (riskScore <= 30) return RiskLevel.low;
    if (riskScore <= 60) return RiskLevel.medium;
    if (riskScore <= 80) return RiskLevel.high;
    return RiskLevel.critical;
  }

  Color _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppTheme.emeraldAccent;
      case RiskLevel.medium:
        return Colors.amber;
      case RiskLevel.high:
        return Colors.orange;
      case RiskLevel.critical:
        return AppTheme.alertRed;
    }
  }

  String _riskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
      case RiskLevel.critical:
        return 'Critical';
    }
  }

  String _diversificationScoreText(PortfolioRisk risk) {
    final score = 100 - risk.riskScore;
    final label =
        score <= 30 ? 'Low' : score <= 60 ? 'Medium' : 'High';
    return 'Diversification: $score/100 ($label)';
  }

  String _riskSubtext(PortfolioRisk risk) {
    // Prioritize critical alerts as subtext
    final criticalAlerts =
        risk.alerts.where((a) => a.severity.name == 'critical');
    if (criticalAlerts.isNotEmpty) {
      return criticalAlerts.first.title;
    }

    // Fall back to diversification level description
    switch (risk.diversificationLevel.toLowerCase()) {
      case 'good':
        return 'Well diversified';
      case 'moderate':
        return 'Moderately diversified';
      case 'poor':
        return 'Low diversification';
      default:
        return 'Score: ${risk.riskScore}/100';
    }
  }
}

/// Card shell for the risk card with watermark shield icon.
class _RiskCardShell extends StatelessWidget {
  final Color iconColor;
  final Widget child;

  const _RiskCardShell({
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Watermark icon
            Positioned(
              right: -10,
              top: -10,
              child: Transform.rotate(
                angle: 0.2,
                child: Icon(
                  Icons.shield_outlined,
                  size: 80,
                  color: iconColor.withValues(alpha: 0.07),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal gauge bar showing risk score 0-100.
class _RiskGauge extends StatelessWidget {
  final int score;
  final Color color;

  const _RiskGauge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: score / 100.0,
          backgroundColor: Colors.white.withValues(alpha: 0.08),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

/// Concentration bars by asset class with color coding.
/// Green <30%, yellow 30-60%, orange 60-80%, red >80%
class _ConcentrationBars extends StatelessWidget {
  final List<AssetTypeBreakdown> breakdownByType;

  const _ConcentrationBars({required this.breakdownByType});

  @override
  Widget build(BuildContext context) {
    final sorted = List<AssetTypeBreakdown>.from(breakdownByType)
      ..sort((a, b) => b.percent.compareTo(a.percent));
    final visible = sorted.take(5).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: visible
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _ConcentrationBarRow(
                  type: item.type,
                  percent: item.percent,
                ),
              ))
          .toList(),
    );
  }
}

class _ConcentrationBarRow extends StatelessWidget {
  final String type;
  final double percent;

  const _ConcentrationBarRow({
    required this.type,
    required this.percent,
  });

  Color _concentrationColor(double pct) {
    if (pct < 30) return AppTheme.emeraldAccent;
    if (pct < 60) return Colors.amber;
    if (pct < 80) return Colors.orange;
    return AppTheme.alertRed;
  }

  String _typeLabel(String typeString) {
    final t = AssetType.fromString(typeString);
    switch (t) {
      case AssetType.realEstate:
        return 'Real Est.';
      case AssetType.etf:
        return 'ETF';
      default:
        return typeString.isNotEmpty
            ? typeString[0].toUpperCase() + typeString.substring(1)
            : typeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _concentrationColor(percent);
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            _typeLabel(type),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textGrey,
                  fontSize: 10,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            '${percent.round()}%',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        if (percent >= 70)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 12,
              color: percent >= 85 ? AppTheme.alertRed : Colors.amber,
            ),
          ),
      ],
    );
  }
}

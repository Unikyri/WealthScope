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
              // Asset class breakdown chips
              if (breakdownByType.length >= 2) ...[
                const SizedBox(height: 6),
                _AssetBreakdownChips(breakdownByType: breakdownByType),
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

/// Compact asset class breakdown chips shown below the card content.
class _AssetBreakdownChips extends StatelessWidget {
  final List<AssetTypeBreakdown> breakdownByType;

  const _AssetBreakdownChips({required this.breakdownByType});

  @override
  Widget build(BuildContext context) {
    final sorted = List<AssetTypeBreakdown>.from(breakdownByType)
      ..sort((a, b) => b.percent.compareTo(a.percent));
    final visible = sorted.take(3).toList();
    final remaining = sorted.length - 3;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        ...visible.map((item) => _Chip(
              label: _typeLabel(item.type),
              color: _typeColor(item.type),
            )),
        if (remaining > 0)
          Text(
            '+$remaining',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.textGrey,
                  fontSize: 10,
                ),
          ),
      ],
    );
  }

  String _typeLabel(String typeString) {
    final type = AssetType.fromString(typeString);
    switch (type) {
      case AssetType.realEstate:
        return 'Real Est.';
      case AssetType.etf:
        return 'ETF';
      default:
        return typeString[0].toUpperCase() + typeString.substring(1);
    }
  }

  Color _typeColor(String typeString) {
    final type = AssetType.fromString(typeString);
    switch (type) {
      case AssetType.crypto:
        return AppTheme.electricBlue;
      case AssetType.stock:
        return AppTheme.emeraldAccent;
      case AssetType.realEstate:
        return Colors.purpleAccent;
      case AssetType.cash:
        return AppTheme.textGrey;
      case AssetType.etf:
        return Colors.amber;
      case AssetType.gold:
        return Colors.orange;
      case AssetType.bond:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

/// Small colored chip showing an asset type label.
class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

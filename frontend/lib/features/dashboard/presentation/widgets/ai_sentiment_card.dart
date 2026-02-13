import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';

/// Sentiment level derived from portfolio performance
enum SentimentLevel {
  bullish,
  neutral,
  bearish,
}

/// AI-driven Sentiment Card
/// Non-clickable, informational card that derives sentiment from real
/// portfolio performance data (gainLossPercent).
class AiSentimentCard extends ConsumerWidget {
  final List<AssetTypeBreakdown> breakdownByType;

  const AiSentimentCard({
    super.key,
    required this.breakdownByType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardPortfolioSummaryProvider);

    return summaryAsync.when(
      data: (summary) => _buildCard(context, summary),
      loading: () => _buildShimmer(context),
      error: (_, __) => _buildErrorCard(context),
    );
  }

  Widget _buildCard(BuildContext context, PortfolioSummary summary) {
    final sentiment = _deriveSentiment(summary.gainLossPercent);
    final color = _sentimentColor(sentiment);
    final label = _sentimentLabel(sentiment);
    final subtext = _sentimentSubtext(summary.gainLossPercent);

    return _CardShell(
      iconColor: color,
      watermarkIcon: Icons.auto_awesome,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header row
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                'SENTIMENT',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
            ],
          ),
          // Value + subtext
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
              const SizedBox(height: 4),
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
                _AssetBreakdownChips(
                  breakdownByType: breakdownByType,
                ),
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
    return _CardShell(
      iconColor: AppTheme.textGrey,
      watermarkIcon: Icons.auto_awesome,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppTheme.textGrey),
              const SizedBox(width: 6),
              Text(
                'SENTIMENT',
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

  SentimentLevel _deriveSentiment(double gainLossPercent) {
    if (gainLossPercent > 5) return SentimentLevel.bullish;
    if (gainLossPercent < -2) return SentimentLevel.bearish;
    return SentimentLevel.neutral;
  }

  Color _sentimentColor(SentimentLevel level) {
    switch (level) {
      case SentimentLevel.bullish:
        return AppTheme.emeraldAccent;
      case SentimentLevel.neutral:
        return Colors.amber;
      case SentimentLevel.bearish:
        return AppTheme.alertRed;
    }
  }

  String _sentimentLabel(SentimentLevel level) {
    switch (level) {
      case SentimentLevel.bullish:
        return 'Bullish';
      case SentimentLevel.neutral:
        return 'Neutral';
      case SentimentLevel.bearish:
        return 'Bearish';
    }
  }

  String _sentimentSubtext(double gainLossPercent) {
    final sign = gainLossPercent >= 0 ? '+' : '';
    return 'Portfolio $sign${gainLossPercent.toStringAsFixed(1)}%';
  }
}

/// Reusable card shell with watermark icon and dark theme styling.
/// Used by both AiSentimentCard and AiRiskLevelCard.
class _CardShell extends StatelessWidget {
  final Color iconColor;
  final IconData watermarkIcon;
  final Widget child;

  const _CardShell({
    required this.iconColor,
    required this.watermarkIcon,
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
                  watermarkIcon,
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

/// Compact asset class breakdown chips shown below the card content.
class _AssetBreakdownChips extends StatelessWidget {
  final List<AssetTypeBreakdown> breakdownByType;

  const _AssetBreakdownChips({required this.breakdownByType});

  @override
  Widget build(BuildContext context) {
    // Sort by percent descending, take top 3
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
      case AssetType.bond:
        return Colors.teal;
      case AssetType.liability:
        return AppTheme.alertRed;
      case AssetType.custom:
        return Colors.grey;
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

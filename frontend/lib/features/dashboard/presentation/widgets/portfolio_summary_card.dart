import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/core/currency/currency_extensions.dart';
import 'dart:ui';

/// Portfolio Summary Card Widget
/// Displays the total portfolio value in Titanium Luxury style
class PortfolioSummaryCard extends ConsumerWidget {
  final PortfolioSummary summary;

  const PortfolioSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPositive = summary.gainLoss >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.carbonSurface,
        border: Border.all(
          color: AppTheme.titaniumSilver.withOpacity(0.3),
          width: 1,
        ),
        // No shadows
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL BALANCE',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.titaniumSilver.withOpacity(0.8),
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.titaniumSilver.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CustomIcons.assets,
                        size: 14,
                        color: AppTheme.mutedGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${summary.assetCount} NODES',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.titaniumSilver,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Total Value - Titanium/Gold Gradient Text could be nice, but simple solid is cleaner for now
            Text(
              _formatCurrency(summary.totalValue, ref),
              style: theme.textTheme.displayMedium?.copyWith(
                color: AppTheme.titaniumSilver,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                fontFamily: 'SpaceMono',
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              children: [
                // Gain/Loss Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPositive 
                        ? theme.colorScheme.secondary.withOpacity(0.1) 
                        : AppTheme.alertRed.withOpacity(0.1),
                    border: Border.all(
                      color: isPositive ? theme.colorScheme.secondary : AppTheme.alertRed,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? CustomIcons.trendingUp : CustomIcons.trendingDown,
                        color: isPositive ? theme.colorScheme.secondary : AppTheme.alertRed,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${isPositive ? "+" : ""}${_formatCurrency(summary.gainLoss.abs(), ref)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isPositive ? theme.colorScheme.secondary : AppTheme.alertRed,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${isPositive ? "+" : ""}${summary.gainLossPercent.toStringAsFixed(2)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isPositive ? theme.colorScheme.secondary : AppTheme.alertRed,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value, WidgetRef ref) {
    final converted = ref.convertFromUsd(value);
    final currency = ref.getCurrentCurrency();
    final symbol = currency.symbol;
    
    if (converted >= 1000000000) {
      return '$symbol${(converted / 1000000000).toStringAsFixed(2)}B';
    } else if (converted >= 1000000) {
      return '$symbol${(converted / 1000000).toStringAsFixed(2)}M';
    } else if (converted >= 1000) {
      return '$symbol${(converted / 1000).toStringAsFixed(2)}K';
    } else {
      return '$symbol${converted.toStringAsFixed(2)}';
    }
  }
}

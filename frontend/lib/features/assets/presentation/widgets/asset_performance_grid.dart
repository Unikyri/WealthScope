import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:intl/intl.dart';

class AssetPerformanceGrid extends StatelessWidget {
  final StockAsset asset;

  const AssetPerformanceGrid({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();
    
    // Calculate values (mock if null)
    final totalValue = asset.totalValue ?? (asset.quantity * (asset.currentPrice ?? asset.purchasePrice));
    final costBasis = asset.totalCost ?? (asset.quantity * asset.purchasePrice);
    final gainLoss = asset.gainLoss ?? (totalValue - costBasis);
    final isPositive = gainLoss >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              Icon(Icons.analytics_rounded, color: AppTheme.electricBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Key Statistics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            padding: EdgeInsets.zero,
            children: [
              _buildMetricCard(
                'Total Value',
                formatCurrency.format(totalValue),
                null,
              ),
              _buildMetricCard(
                'Holdings',
                '${asset.quantity} ${asset.symbol}',
                null,
              ),
              _buildMetricCard(
                'Avg. Cost',
                formatCurrency.format(asset.purchasePrice),
                null,
              ),
              _buildMetricCard(
                'Total P&L',
                formatCurrency.format(gainLoss),
                isPositive ? AppTheme.emeraldAccent : AppTheme.alertRed,
                glow: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color? valueColor, {bool glow = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: glow && valueColor != null
            ? [
                BoxShadow(
                  color: valueColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppTheme.textGrey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Manrope', // Monospace-like for numbers
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

/// Asset Card Widget
/// Modern card design displaying asset information
class AssetCard extends StatelessWidget {
  const AssetCard({
    super.key,
    required this.asset,
  });

  final StockAsset asset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasGainLoss = asset.gainLoss != null;
    final isPositive = hasGainLoss && (asset.gainLossPercent ?? 0) >= 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/assets/${asset.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Asset Icon with gradient
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getTypeColor(asset.type),
                        _getTypeColor(asset.type).withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getTypeColor(asset.type).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getTypeIcon(asset.type),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Asset Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Asset Name
                      Text(
                        asset.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Quantity
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 14,
                            color: AppTheme.textGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${asset.quantity.toStringAsFixed(_getDecimalPlaces())} ${_getUnitLabel()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Value Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Total Value
                    Text(
                      '${asset.currency.symbol}${_formatValue(asset.totalValue ?? asset.totalInvested)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Gain/Loss Badge
                    if (hasGainLoss)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (isPositive
                                  ? AppTheme.emeraldAccent
                                  : AppTheme.errorRed)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (isPositive
                                    ? AppTheme.emeraldAccent
                                    : AppTheme.errorRed)
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 12,
                              color: isPositive
                                  ? AppTheme.emeraldAccent
                                  : AppTheme.errorRed,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(asset.gainLossPercent ?? 0).abs().toStringAsFixed(1)}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isPositive
                                    ? AppTheme.emeraldAccent
                                    : AppTheme.errorRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 4),
                // Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textGrey.withOpacity(0.5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get icon based on asset type
  IconData _getTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return Icons.show_chart;
      case AssetType.etf:
        return Icons.pie_chart;
      case AssetType.bond:
        return Icons.receipt_long;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.realEstate:
        return Icons.home;
      case AssetType.gold:
        return Icons.diamond;
      case AssetType.cash:
        return Icons.account_balance_wallet;
      case AssetType.other:
        return Icons.business;
    }
  }

  /// Get color based on asset type
  Color _getTypeColor(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return AppTheme.electricBlue;
      case AssetType.etf:
        return AppTheme.purpleAccent;
      case AssetType.bond:
        return AppTheme.accentBlue;
      case AssetType.crypto:
        return const Color(0xFFF7931A); // Bitcoin orange
      case AssetType.realEstate:
        return const Color(0xFF4CAF50); // Green
      case AssetType.gold:
        return const Color(0xFFFFD700); // Gold
      case AssetType.cash:
        return const Color(0xFF00BCD4); // Cyan
      case AssetType.other:
        return AppTheme.textGrey;
    }
  }

  /// Get unit label based on asset type
  String _getUnitLabel() {
    switch (asset.type) {
      case AssetType.stock:
      case AssetType.etf:
        return asset.quantity == 1 ? 'share' : 'shares';
      case AssetType.crypto:
        return 'units';
      case AssetType.bond:
        return 'bonds';
      case AssetType.realEstate:
        return 'properties';
      case AssetType.gold:
        return 'oz';
      case AssetType.cash:
        return asset.currency.code;
      case AssetType.other:
        return 'units';
    }
  }

  /// Get decimal places for quantity display
  int _getDecimalPlaces() {
    switch (asset.type) {
      case AssetType.crypto:
        return 8; // Crypto typically needs more precision
      case AssetType.gold:
        return 3; // Gold in troy ounces
      case AssetType.stock:
      case AssetType.etf:
      case AssetType.bond:
      case AssetType.realEstate:
      case AssetType.cash:
      case AssetType.other:
        return asset.quantity % 1 == 0 ? 0 : 2;
    }
  }

  /// Format value to readable string (K, M notation for large numbers)
  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

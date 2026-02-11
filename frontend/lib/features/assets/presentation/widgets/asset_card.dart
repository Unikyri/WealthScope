import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/shared/widgets/asset_icon_resolver.dart';

/// Asset Card Widget
/// Modern 3-row card design displaying asset information with real data.
///
/// Layout:
/// ```
/// [Icon 44px] | Name (bold)          | $12,500.00 (bold)
///             | AAPL - Stock         | +5.23%  arrow_up
///             | 10 shares @ $125.00  | +$625.00
/// ```
class AssetCard extends StatelessWidget {
  const AssetCard({
    super.key,
    required this.asset,
  });

  final StockAsset asset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changePercent = asset.gainLossPercent ?? 0.0;
    final hasGainLoss = asset.gainLoss != null;
    final isPositive = changePercent >= 0;
    final changeColor = AppTheme.getChangeColor(changePercent);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Asset Icon via AssetIconResolver (Hero for smooth transition to detail)
                HeroMode(
                  enabled: !MediaQuery.of(context).disableAnimations,
                  child: Hero(
                    tag: asset.id != null
                        ? 'asset-icon-${asset.id}'
                        : 'asset-icon-${asset.symbol}-${asset.name.hashCode}',
                    child: AssetIconResolver(
                      symbol: asset.symbol,
                      assetType: asset.type,
                      name: asset.name,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Left column: Name, Symbol+Type, Quantity
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Asset Name
                      Text(
                        asset.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // Row 2: Symbol + Type
                      Text(
                        asset.symbol.isNotEmpty
                            ? '${asset.symbol} \u2022 ${asset.type.displayName}'
                            : asset.type.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // Row 3: Quantity @ Purchase Price
                      Text(
                        '${asset.quantity.toStringAsFixed(_getDecimalPlaces())} ${_getUnitLabel()} @ ${asset.currency.symbol}${_formatCompact(asset.purchasePrice)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textGrey.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Right column: Value, Change %, Change $
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Row 1: Total Value
                    Text(
                      '${asset.currency.symbol}${_formatValue(asset.totalValue ?? asset.totalInvested)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Row 2: Gain/Loss Percentage Badge
                    if (hasGainLoss)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 11,
                              color: changeColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${changePercent.abs().toStringAsFixed(2)}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: changeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (hasGainLoss) const SizedBox(height: 3),
                    // Row 3: Gain/Loss Dollar Amount
                    if (hasGainLoss)
                      Text(
                        _formatGainLoss(asset.gainLoss!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: changeColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format gain/loss as signed currency string
  String _formatGainLoss(double value) {
    final prefix = value >= 0 ? '+' : '';
    if (value.abs() >= 1000000) {
      return '$prefix${asset.currency.symbol}${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '$prefix${asset.currency.symbol}${(value / 1000).toStringAsFixed(1)}K';
    }
    return '$prefix${asset.currency.symbol}${value.toStringAsFixed(2)}';
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
        return 8;
      case AssetType.gold:
        return 3;
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
    return value.toStringAsFixed(2);
  }

  /// Format compact number for purchase price display
  String _formatCompact(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 10000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2);
  }
}

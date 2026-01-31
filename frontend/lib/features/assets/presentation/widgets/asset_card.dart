import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

/// Asset Card Widget
/// Reusable widget to display an asset in a list.
/// 
/// Displays:
/// - Icon based on asset type
/// - Asset name and symbol (if applicable)
/// - Quantity with unit label
/// - Total value
/// - Percentage change (green/red based on positive/negative)
/// 
/// Tapping the card navigates to asset detail screen.
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => context.push('/assets/${asset.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Asset Type Icon with Hero animation
              Hero(
                tag: 'asset-icon-${asset.id}',
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(theme, asset.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(asset.type),
                    color: _getTypeColor(theme, asset.type),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Asset Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Asset Name and Symbol
                    Text(
                      _getDisplayName(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Quantity with unit
                    Text(
                      '${asset.quantity.toStringAsFixed(_getDecimalPlaces())} ${_getUnitLabel()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    // Current Price (if available and has symbol)
                    if (asset.currentPrice != null && asset.symbol.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${asset.currency.symbol}${asset.currentPrice!.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Value and Performance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Percentage Change with direction indicator
                  if (hasGainLoss)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: isPositive
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.error,
                          size: 20,
                        ),
                        Text(
                          '${isPositive ? '+' : ''}${asset.gainLossPercent!.toStringAsFixed(1)}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isPositive
                                ? theme.colorScheme.tertiary
                                : theme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (hasGainLoss) const SizedBox(height: 4),
                  // Total Value
                  Text(
                    '${asset.currency.symbol}${_formatValue(asset.totalValue ?? asset.totalInvested)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get display name with symbol if available
  String _getDisplayName() {
    final hasSymbol = asset.symbol.isNotEmpty;
    if (hasSymbol && asset.type != AssetType.realEstate && asset.type != AssetType.gold) {
      return '${asset.name} (${asset.symbol})';
    }
    return asset.name;
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
  Color _getTypeColor(ThemeData theme, AssetType type) {
    switch (type) {
      case AssetType.stock:
        return theme.colorScheme.primary;
      case AssetType.etf:
        return theme.colorScheme.secondary;
      case AssetType.bond:
        return theme.colorScheme.tertiary;
      case AssetType.crypto:
        return const Color(0xFFF7931A); // Bitcoin orange
      case AssetType.realEstate:
        return const Color(0xFF4CAF50); // Green
      case AssetType.gold:
        return const Color(0xFFFFD700); // Gold
      case AssetType.cash:
        return const Color(0xFF00BCD4); // Cyan
      case AssetType.other:
        return theme.colorScheme.surfaceContainerHighest;
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

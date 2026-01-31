import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

/// Allocation Legend Widget
/// Displays a legend for the asset allocation pie chart with colors, percentages, and values
/// Supports selection highlighting and tap interactions
class AllocationLegend extends StatelessWidget {
  final List<AssetTypeBreakdown> allocations;
  final int? selectedIndex;
  final Function(int)? onTap;

  const AllocationLegend({
    super.key,
    required this.allocations,
    this.selectedIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: allocations.asMap().entries.map((entry) {
        final index = entry.key;
        final allocation = entry.value;
        final isSelected = index == selectedIndex;

        return InkWell(
          onTap: onTap != null ? () => onTap!(index) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Color indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getTypeColor(allocation.type),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                // Asset type label
                Expanded(
                  child: Text(
                    _getTypeLabel(allocation.type),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                // Percentage
                Text(
                  '${allocation.percent.toStringAsFixed(0)}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                // Value
                Text(
                  _formatCurrency(allocation.value),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Get localized label for asset type
  /// Returns English label for the asset type
  String _getTypeLabel(String typeString) {
    final type = _parseAssetType(typeString);

    switch (type) {
      case AssetType.stock:
        return 'Stocks';
      case AssetType.etf:
        return 'ETFs';
      case AssetType.bond:
        return 'Bonds';
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.realEstate:
        return 'Real Estate';
      case AssetType.gold:
        return 'Gold';
      case AssetType.cash:
        return 'Cash';
      case AssetType.other:
        return 'Other';
    }
  }

  /// Get color for asset type
  /// Returns consistent colors matching the pie chart using theme colors
  Color _getTypeColor(String typeString) {
    final type = _parseAssetType(typeString);

    switch (type) {
      case AssetType.stock:
        return AppTheme.getChartColor(0);  // Indigo
      case AssetType.etf:
        return AppTheme.getChartColor(4);  // Violet
      case AssetType.bond:
        return AppTheme.getChartColor(3);  // Pink
      case AssetType.crypto:
        return AppTheme.getChartColor(6);  // Orange
      case AssetType.realEstate:
        return AppTheme.getChartColor(1);  // Emerald
      case AssetType.gold:
        return AppTheme.getChartColor(2);  // Amber
      case AssetType.cash:
        return AppTheme.getChartColor(5);  // Cyan
      case AssetType.other:
        return AppTheme.neutralColor;
    }
  }

  /// Parse type string to AssetType enum
  AssetType _parseAssetType(String typeString) {
    try {
      return AssetType.fromString(typeString);
    } catch (e) {
      return AssetType.other;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      // Billions
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      // Millions
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      // Thousands
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
    }
  }
}

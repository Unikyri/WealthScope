import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Asset Type Filter Chips Widget
/// Displays horizontal scrollable filter chips for asset types
class AssetTypeFilterChips extends StatelessWidget {
  const AssetTypeFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AssetType? selected;
  final ValueChanged<AssetType?> onSelected;

  /// Map of asset types to their corresponding icons
  static const Map<AssetType, IconData> _assetTypeIcons = {
    AssetType.stock: Icons.trending_up,
    AssetType.etf: Icons.pie_chart,
    AssetType.realEstate: Icons.home,
    AssetType.gold: Icons.diamond,
    AssetType.bond: Icons.account_balance,
    AssetType.crypto: Icons.currency_bitcoin,
    AssetType.other: Icons.category,
  };

  IconData _getTypeIcon(AssetType type) {
    return _assetTypeIcons[type] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
              selectedColor: theme.colorScheme.primaryContainer,
              checkmarkColor: theme.colorScheme.primary,
              showCheckmark: true,
            ),
          ),
          
          // Asset type chips
          ...AssetType.values.map((type) {
            final icon = _getTypeIcon(type);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: selected == type
                    ? null
                    : Icon(icon, size: 18),
                label: Text(type.displayName),
                selected: selected == type,
                onSelected: (_) => onSelected(type),
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
                showCheckmark: true,
              ),
            );
          }),
        ],
      ),
    );
  }
}

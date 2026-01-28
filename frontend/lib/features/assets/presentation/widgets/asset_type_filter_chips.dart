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
            ),
          ),
          
          // Asset type chips
          ...AssetType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.displayName),
                selected: selected == type,
                onSelected: (_) => onSelected(type),
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
              ),
            );
          }),
        ],
      ),
    );
  }
}

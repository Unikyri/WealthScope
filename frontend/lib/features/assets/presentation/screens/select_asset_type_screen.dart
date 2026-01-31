import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_card.dart';

/// Asset Type Selection Screen
/// Allows users to select the type of asset they want to add to their portfolio.
class SelectAssetTypeScreen extends ConsumerWidget {
  const SelectAssetTypeScreen({super.key});

  /// Map of asset types to their corresponding icons
  static const Map<AssetType, IconData> _assetTypeIcons = {
    AssetType.stock: Icons.trending_up,
    AssetType.etf: Icons.pie_chart,
    AssetType.bond: Icons.account_balance,
    AssetType.crypto: Icons.currency_bitcoin,
    AssetType.realEstate: Icons.home,
    AssetType.gold: Icons.diamond,
    AssetType.cash: Icons.account_balance_wallet,
    AssetType.other: Icons.category,
  };

  void _onAssetTypeSelected(BuildContext context, AssetType type) {
    // Navigate to specific form based on asset type
    if (type == AssetType.stock || type == AssetType.etf) {
      // Use dedicated stock/ETF form
      context.push('/assets/add-stock?type=${type.toApiString()}');
    } else {
      // Use generic asset form for other types
      context.push('/assets/add?type=${type.toApiString()}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Asset'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'What type of asset do you want to add?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Asset type grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: AssetType.values.length,
                  itemBuilder: (context, index) {
                    final assetType = AssetType.values[index];
                    final icon = _assetTypeIcons[assetType] ?? Icons.category;

                    return AssetTypeCard(
                      type: assetType,
                      icon: icon,
                      onTap: () => _onAssetTypeSelected(context, assetType),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

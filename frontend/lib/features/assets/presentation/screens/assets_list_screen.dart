import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_card.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_list_skeleton.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_filter_chips.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/empty_assets_view.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/error_view.dart';

/// Assets List Screen
/// Main screen for displaying all user assets with filtering capabilities
class AssetsListScreen extends ConsumerWidget {
  const AssetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assetsAsync = ref.watch(searchedAssetsProvider);
    final selectedType = ref.watch(selectedAssetTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Assets',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/assets/add'),
            tooltip: 'Add Asset',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          AssetTypeFilterChips(
            selected: selectedType,
            onSelected: (type) {
              ref.read(selectedAssetTypeProvider.notifier).select(type);
            },
          ),

          // Asset list with state handling
          Expanded(
            child: assetsAsync.when(
              data: (assets) {
                // Empty state
                if (assets.isEmpty) {
                  return const EmptyAssetsView();
                }

                // Data state - show list
                return RefreshIndicator(
                  onRefresh: () async {
                    // Refresh assets
                    ref.invalidate(allAssetsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      return AssetCard(asset: assets[index]);
                    },
                  ),
                );
              },
              loading: () {
                // Loading state - show skeleton
                return const AssetListSkeleton();
              },
              error: (error, stack) {
                // Error state
                return ErrorView(
                  message: error.toString(),
                  onRetry: () {
                    // Retry fetching assets
                    ref.invalidate(allAssetsProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/assets/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Asset'),
      ),
    );
  }
}

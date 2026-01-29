import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_card.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_list_skeleton.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_filter_chips.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/delete_asset_dialog.dart';
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
                // Empty state with pull-to-refresh support
                if (assets.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      // Invalidate provider to force reload
                      ref.invalidate(allAssetsProvider);
                      // Wait for the refresh to complete
                      await ref.read(allAssetsProvider.future);
                    },
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 500, // Minimum height for pull-to-refresh
                        child: EmptyAssetsView(),
                      ),
                    ),
                  );
                }

                // Data state - show list with pull-to-refresh
                return RefreshIndicator(
                  onRefresh: () async {
                    // Invalidate provider to force reload
                    ref.invalidate(allAssetsProvider);
                    // Wait for the refresh to complete
                    await ref.read(allAssetsProvider.future);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      return Dismissible(
                        key: Key(asset.id ?? 'asset-$index'),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          // Show confirmation dialog
                          return await showDeleteAssetDialog(context, asset);
                        },
                        onDismissed: (direction) async {
                          try {
                            // Delete asset from backend
                            await ref
                                .read(assetRepositoryProvider)
                                .deleteAsset(asset.id!);

                            // Invalidate cache to refresh list
                            ref.invalidate(allAssetsProvider);

                            // Show success message
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${asset.name} deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      // TODO: Implement undo if time permits
                                    },
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            // Show error message
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete: $e'),
                                  backgroundColor:
                                      theme.colorScheme.error,
                                ),
                              );
                            }
                            // Refresh list to restore item
                            ref.invalidate(allAssetsProvider);
                          }
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: theme.colorScheme.onError,
                            size: 28,
                          ),
                        ),
                        child: AssetCard(asset: asset),
                      );
                    },
                  ),
                );
              },
              loading: () {
                // Loading state - show skeleton
                return const AssetListSkeleton();
              },
              error: (error, stack) {
                // Error state with pull-to-refresh support
                return RefreshIndicator(
                  onRefresh: () async {
                    // Invalidate provider to retry
                    ref.invalidate(allAssetsProvider);
                    // Wait for the refresh to complete
                    await ref.read(allAssetsProvider.future);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 500, // Minimum height for pull-to-refresh
                      child: ErrorView(
                        message: error.toString(),
                        onRetry: () {
                          // Retry fetching assets
                          ref.invalidate(allAssetsProvider);
                        },
                      ),
                    ),
                  ),
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

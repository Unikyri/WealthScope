import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
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
    final allAssets = ref.watch(allAssetsProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Modern App Bar
          SliverAppBar(
            backgroundColor: AppTheme.midnightBlue,
            elevation: 0,
            pinned: true,
            toolbarHeight: 80,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.electricBlue.withOpacity(0.1),
                    AppTheme.midnightBlue,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title and subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'My Assets',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 2),
                            allAssets.whenOrNull(
                                  data: (assets) => Text(
                                    '${assets.length} ${assets.length == 1 ? 'asset' : 'assets'} in portfolio',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ) ??
                                const SizedBox.shrink(),
                          ],
                        ),
                      ),
                      // Add Button
                      ElevatedButton.icon(
                        onPressed: () => context.push('/assets/select-type'),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text(
                          'Add',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.electricBlue,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Search IconButton
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          color: Colors.white,
                          onPressed: () {
                            // TODO: Implement search functionality
                          },
                          tooltip: 'Search',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Filter Chips
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            sliver: SliverToBoxAdapter(
              child: AssetTypeFilterChips(
                selected: selectedType,
                onSelected: (type) {
                  ref.read(selectedAssetTypeProvider.notifier).select(type);
                },
              ),
            ),
          ),

          // Asset List or Empty State
          assetsAsync.when(
            data: (assets) {
              print('🟠 [AssetsList] Received ${assets.length} assets');

              if (assets.isEmpty) {
                print(
                    '⚠️ [AssetsList] Assets list is empty, showing empty view');
                return SliverFillRemaining(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      print('🔄 [AssetsList] Refreshing assets...');
                      ref.invalidate(allAssetsProvider);
                      await ref.read(allAssetsProvider.future);
                    },
                    child: const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 500,
                        child: EmptyAssetsView(),
                      ),
                    ),
                  ),
                );
              }

              print('✅ [AssetsList] Building list with ${assets.length} items');
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Dismissible(
                                key: Key(asset.id ?? 'asset-$index'),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await showDeleteAssetDialog(
                                      context, asset);
                                },
                                onDismissed: (direction) async {
                                  ref
                                      .read(allAssetsProvider.notifier)
                                      .removeAsset(asset.id!);

                                  try {
                                    await ref
                                        .read(assetRepositoryProvider)
                                        .deleteAsset(asset.id!);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('${asset.name} deleted'),
                                          backgroundColor:
                                              AppTheme.emeraldAccent,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to delete: $e'),
                                          backgroundColor:
                                              theme.colorScheme.error,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                    await ref
                                        .read(allAssetsProvider.notifier)
                                        .refresh();
                                  }
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorRed,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Delete',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: AssetCard(asset: asset),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: assets.length,
                  ),
                ),
              );
            },
            loading: () {
              print('⏳ [AssetsList] Loading assets...');
              return const SliverFillRemaining(
                child: AssetListSkeleton(),
              );
            },
            error: (error, stack) {
              print('❌ [AssetsList] Error loading assets: $error');
              return SliverFillRemaining(
                child: RefreshIndicator(
                  onRefresh: () async {
                    print('🔄 [AssetsList] Retrying after error...');
                    ref.invalidate(allAssetsProvider);
                    await ref.read(allAssetsProvider.future);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 500,
                      child: ErrorView(
                        message: error.toString(),
                        onRetry: () {
                          print('🔄 [AssetsList] Retry button pressed');
                          ref.invalidate(allAssetsProvider);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_card.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_list_skeleton.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_filter_chips.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/delete_asset_dialog.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/empty_assets_view.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/domain/plan_limits.dart';

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
    final isPremiumAsync = ref.watch(isPremiumProvider);

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
                    AppTheme.electricBlue.withValues(alpha: 0.1),
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
                                  data: (assets) {
                                    final isPremium =
                                        isPremiumAsync.value ?? false;
                                    final countText = isPremium
                                        ? '${assets.length} assets \u2022 Unlimited'
                                        : '${assets.length}/${PlanLimits.scoutMaxAssets} assets';
                                    return Text(
                                      countText,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textGrey,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
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
              if (assets.isEmpty) {
                return SliverFillRemaining(
                  child: RefreshIndicator(
                    onRefresh: () async {
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

              // Build grouped or flat list
              final shouldGroup = selectedType == null;
              final widgets = <Widget>[];

              if (shouldGroup) {
                // Group assets by type
                final grouped = <AssetType, List<StockAsset>>{};
                for (final asset in assets) {
                  grouped.putIfAbsent(asset.type, () => []).add(asset);
                }
                // Sort groups by total value descending
                final sortedGroups = grouped.entries.toList()
                  ..sort((a, b) {
                    final totalA = a.value
                        .fold<double>(0, (s, a) => s + (a.totalValue ?? 0));
                    final totalB = b.value
                        .fold<double>(0, (s, a) => s + (a.totalValue ?? 0));
                    return totalB.compareTo(totalA);
                  });

                var animIndex = 0;
                for (var gi = 0; gi < sortedGroups.length; gi++) {
                  final group = sortedGroups[gi];
                  final groupTotal = group.value
                      .fold<double>(0, (s, a) => s + (a.totalValue ?? 0));

                  // Section header
                  widgets.add(
                    Padding(
                      padding: EdgeInsets.only(
                        top: gi == 0 ? 0 : 20,
                        bottom: 12,
                      ),
                      child: _AssetGroupHeader(
                        type: group.key,
                        count: group.value.length,
                        totalValue: groupTotal,
                      ),
                    ),
                  );

                  // Asset cards in this group
                  for (final asset in group.value) {
                    widgets.add(
                      _buildAnimatedDismissibleCard(
                        context: context,
                        ref: ref,
                        theme: theme,
                        asset: asset,
                        index: animIndex++,
                      ),
                    );
                  }
                }
              } else {
                // Flat list (when filter is active)
                for (var i = 0; i < assets.length; i++) {
                  widgets.add(
                    _buildAnimatedDismissibleCard(
                      context: context,
                      ref: ref,
                      theme: theme,
                      asset: assets[i],
                      index: i,
                    ),
                  );
                }
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => widgets[index],
                    childCount: widgets.length,
                  ),
                ),
              );
            },
            loading: () {
              return const SliverFillRemaining(
                child: AssetListSkeleton(),
              );
            },
            error: (error, stack) {
              return SliverFillRemaining(
                child: RefreshIndicator(
                  onRefresh: () async {
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

  /// Build an animated, dismissible asset card
  Widget _buildAnimatedDismissibleCard({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeData theme,
    required StockAsset asset,
    required int index,
  }) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: Key(asset.id ?? 'asset-$index'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDeleteAssetDialog(context, asset);
              },
              onDismissed: (direction) async {
                ref.read(allAssetsProvider.notifier).removeAsset(asset.id!);

                try {
                  await ref
                      .read(assetRepositoryProvider)
                      .deleteAsset(asset.id!);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${asset.name} deleted'),
                        backgroundColor: AppTheme.emeraldAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete: $e'),
                        backgroundColor: theme.colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  await ref.read(allAssetsProvider.notifier).refresh();
                }
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Delete',
                      style: theme.textTheme.labelSmall?.copyWith(
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
  }
}

/// Section header for grouped asset list
class _AssetGroupHeader extends StatelessWidget {
  const _AssetGroupHeader({
    required this.type,
    required this.count,
    required this.totalValue,
  });

  final AssetType type;
  final int count;
  final double totalValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.deepBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Type Icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _getTypeColor(type).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTypeIcon(type),
              color: _getTypeColor(type),
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          // Type Name + Count
          Expanded(
            child: Text(
              '${type.displayName} ($count)',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          // Total Group Value
          Text(
            '\$${_formatGroupValue(totalValue)}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textGrey,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

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

  Color _getTypeColor(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return AppTheme.electricBlue;
      case AssetType.etf:
        return AppTheme.purpleAccent;
      case AssetType.bond:
        return AppTheme.accentBlue;
      case AssetType.crypto:
        return const Color(0xFFF7931A);
      case AssetType.realEstate:
        return const Color(0xFF4CAF50);
      case AssetType.gold:
        return const Color(0xFFFFD700);
      case AssetType.cash:
        return const Color(0xFF00BCD4);
      case AssetType.other:
        return AppTheme.textGrey;
    }
  }

  String _formatGroupValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/portfolio_history_provider.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section_with_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/last_updated_indicator.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_summary_card.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_history_chart.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';

/// Dashboard Screen
/// Main screen displaying portfolio overview
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(portfolioSummaryProvider);
    final currentUserEmail = ref.watch(currentUserProvider)?.email;

    // Extract first name from email
    final userName = currentUserEmail?.split('@').first.capitalize() ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Your Financial Summary',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(portfolioSummaryProvider);
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(portfolioSummaryProvider);
          await ref.read(portfolioSummaryProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: summaryAsync.when(
            data: (summary) {
              // Check if portfolio is empty
              if (summary.totalValue == 0 && summary.breakdownByType.isEmpty) {
                return EmptyDashboard(
                  onAddAsset: () => context.go('/assets/select-type'),
                );
              }

              print('🔴 [Dashboard] Portfolio summary loaded successfully');
              print('🔴 [Dashboard] Total value: \$${summary.totalValue}');
              print('🔴 [Dashboard] Asset count: ${summary.assetCount}');
              
              final assetsAsync = ref.watch(allAssetsProvider);
              print('🔴 [Dashboard] Watching allAssetsProvider...');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Portfolio Card
                  PortfolioSummaryCard(summary: summary),
                  const SizedBox(height: 8),
                  LastUpdatedIndicator(lastUpdated: summary.lastUpdated),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const QuickActionsRow(),
                  const SizedBox(height: 24),

                  // Quick Stats Row
                  _QuickStatsRow(summary: summary),
                  const SizedBox(height: 24),

                  // Portfolio History Chart
                  _PortfolioHistorySection(),
                  const SizedBox(height: 24),

                  // Asset Allocation Pie Chart
                  if (summary.breakdownByType.isNotEmpty) ...[
                    EnhancedAllocationSection(
                      allocations: summary.breakdownByType,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Top Assets Section
                  assetsAsync.when(
                    data: (assets) {
                      print('✅ [Dashboard] Assets loaded: ${assets.length}');
                      if (assets.isEmpty) {
                        print('⚠️ [Dashboard] No assets to display');
                        return const SizedBox.shrink();
                      }
                      
                      print('🔴 [Dashboard] Sorting ${assets.length} assets by value...');
                      // Sort by total value and take top 3
                      final sortedAssets = List<dynamic>.from(assets)
                        ..sort((a, b) => 
                          (b.totalValue ?? 0).compareTo(a.totalValue ?? 0));
                      final topAssets = sortedAssets.take(3).toList();
                      
                      print('🔴 [Dashboard] Top ${topAssets.length} assets selected');
                      for (var asset in topAssets) {
                        print('   - ${asset.name}: \$${asset.totalValue}');
                      }

                      return _TopAssetsCard(assets: topAssets);
                    },
                    loading: () {
                      print('⏳ [Dashboard] Assets loading...');
                      return const SizedBox.shrink();
                    },
                    error: (error, stack) {
                      print('❌ [Dashboard] Assets error: $error');
                      print('❌ [Dashboard] Stack: $stack');
                      return const SizedBox.shrink();
                    },
                  ),
                  
                  const SizedBox(height: 80), // Space for FAB
                ],
              );
            },
            loading: () => const DashboardSkeleton(),
            error: (error, _) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(portfolioSummaryProvider),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/assets/select-type'),
        icon: const Icon(Icons.add),
        label: const Text('Add Asset'),
      ),
    );
  }
}

/// Extension to capitalize string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Quick Stats Row Widget
class _QuickStatsRow extends StatelessWidget {
  final dynamic summary;

  const _QuickStatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.account_balance_wallet,
            label: 'Assets',
            value: '${summary.assetCount}',
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            label: 'Gain/Loss',
            value: _formatCurrency(summary.gainLoss),
            color: summary.gainLoss >= 0 ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.pie_chart,
            label: 'Types',
            value: '${summary.breakdownByType.length}',
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double value) {
    if (value.abs() >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value.abs() >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value.abs() >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Top Assets Card Widget
class _TopAssetsCard extends ConsumerWidget {
  final List<dynamic> assets;

  const _TopAssetsCard({required this.assets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Assets',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/assets'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...assets.asMap().entries.map((entry) {
              final index = entry.key;
              final asset = entry.value;
              final isLast = index == assets.length - 1;

              return Column(
                children: [
                  _AssetListItem(asset: asset),
                  if (!isLast) const Divider(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Asset List Item Widget
class _AssetListItem extends StatelessWidget {
  final dynamic asset;

  const _AssetListItem({required this.asset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.push('/assets/${asset.id}'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Asset Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getTypeColor(asset.type.toApiString(), theme).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(asset.type.toApiString()),
                color: _getTypeColor(asset.type.toApiString(), theme),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Asset Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (asset.symbol != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      asset.symbol!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Value
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(asset.totalValue ?? 0),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${asset.quantity.toStringAsFixed(0)} units',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'stock':
        return Icons.show_chart;
      case 'etf':
        return Icons.pie_chart;
      case 'bond':
        return Icons.receipt_long;
      case 'crypto':
        return Icons.currency_bitcoin;
      case 'real_estate':
        return Icons.home;
      case 'gold':
        return Icons.star;
      case 'cash':
        return Icons.account_balance_wallet;
      default:
        return Icons.inventory_2;
    }
  }

  Color _getTypeColor(String type, ThemeData theme) {
    switch (type.toLowerCase()) {
      case 'stock':
        return Colors.blue;
      case 'etf':
        return Colors.purple;
      case 'bond':
        return Colors.green;
      case 'crypto':
        return Colors.orange;
      case 'real_estate':
        return Colors.brown;
      case 'gold':
        return Colors.amber;
      case 'cash':
        return Colors.teal;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}

/// Portfolio History Section Widget
class _PortfolioHistorySection extends ConsumerWidget {
  const _PortfolioHistorySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final historyAsync = ref.watch(portfolioHistoryProvider(selectedPeriod));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            historyAsync.when(
              data: (data) => PortfolioHistoryChart(
                data: data,
                period: selectedPeriod,
                onPeriodChanged: (period) {
                  ref.read(selectedPeriodProvider.notifier).setPeriod(period);
                },
              ),
              loading: () => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SizedBox(
                height: 300,
                child: Center(
                  child: Text(
                    'Error loading history',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

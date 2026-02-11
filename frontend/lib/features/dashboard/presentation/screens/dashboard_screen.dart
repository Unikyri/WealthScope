import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:wealthscope_app/shared/widgets/asset_icon_resolver.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/ai_risk_level_card.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/ai_sentiment_card.dart';
import 'package:wealthscope_app/features/dashboard/domain/prompt_generator.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/ai_prompt_bar.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section_with_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';
import 'package:wealthscope_app/shared/widgets/speed_dial_fab.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/crypto_net_worth_hero.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/premium_widgets.dart';

/// Dashboard Screen - Crypto Blue Pivot
/// Matches HTML Reference structure
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('🏠 [DASHBOARD_SCREEN] Build (Crypto Blue)');
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(dashboardPortfolioSummaryProvider);
    final currentUserEmail = ref.watch(currentUserProvider)?.email;
    final userName = currentUserEmail?.split('@').first.capitalize() ?? 'User';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(dashboardPortfolioSummaryProvider.future),
            ref.refresh(allAssetsProvider.future),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Top App Bar (Header)
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
              elevation: 0,
              pinned: true,
              centerTitle: false,
              title: Row(
                children: [
                  // User Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.cardGrey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://ui-avatars.com/api/?name=User&background=137FEC&color=fff'), // Placeholder
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                      ),
                      Text(
                        userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                // Premium Badge
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: const PremiumBadge(),
                ),
                // Notifications
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                ),
              ],
            ),

            // Main Content
            summaryAsync.when(
              data: (summary) {
                final assetsAsync = ref.watch(allAssetsProvider);

                return SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 1. Hero Sparkline Card
                      CryptoNetWorthHero(
                        totalValue: summary.totalValue,
                        change: summary.gainLoss,
                        changePercent: summary.gainLossPercent,
                      ),

                      const SizedBox(height: 16),

                      // 2. AI Contextual Prompt Bar
                      Builder(builder: (context) {
                        final assetsAsync = ref.watch(allAssetsProvider);
                        final prompts = assetsAsync.when(
                          data: (assets) => PromptGenerator.generate(
                            assets: assets
                                .map((a) => AssetInfo(
                                      name: a.name,
                                      symbol: a.symbol,
                                      type: a.type.toApiString(),
                                      totalValue: a.totalValue ?? 0,
                                    ))
                                .toList(),
                            breakdown: summary.breakdownByType
                                .map((b) => TypeBreakdown(
                                      type: b.type,
                                      percent: b.percent,
                                    ))
                                .toList(),
                          ),
                          loading: () => PromptGenerator.defaultPrompts(),
                          error: (_, __) => PromptGenerator.defaultPrompts(),
                        );

                        return AiPromptBar(
                          prompts: prompts,
                          onPromptTap: (prompt) {
                            context.push(
                                '/ai-chat?prompt=${Uri.encodeComponent(prompt)}');
                          },
                        );
                      }),

                      const SizedBox(height: 8),

                      // 3. Asset Allocation Donut
                      if (summary.breakdownByType.isNotEmpty) ...[
                        EnhancedAllocationSection(
                          allocations: summary.breakdownByType,
                          totalValue: summary.totalValue,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // 4. AI-driven Sentiment & Risk Cards
                      SizedBox(
                        height: 180,
                        child: Row(
                          children: [
                            Expanded(
                              child: AiSentimentCard(
                                breakdownByType: summary.breakdownByType,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AiRiskLevelCard(
                                breakdownByType: summary.breakdownByType,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 5. Top Movers
                      const _SectionHeader(title: 'Top Movers'),
                      const SizedBox(height: 12),
                      assetsAsync.when(
                        data: (assets) {
                          if (assets.isEmpty) return const SizedBox.shrink();

                          // Show biggest holdings first as proxy for 'top movers'
                          final sortedAssets = List<StockAsset>.from(assets)
                            ..sort((a, b) => (b.totalValue ?? 0)
                                .compareTo(a.totalValue ?? 0));
                          final topAssets = sortedAssets.take(3).toList();

                          return Column(
                            children: topAssets
                                .map((asset) => _TopMoverItem(asset: asset))
                                .toList(),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 24), // Bottom spacing
                    ]),
                  ),
                );
              },
              loading: () =>
                  const SliverFillRemaining(child: DashboardSkeleton()),
              error: (e, _) => SliverFillRemaining(
                  child: ErrorView(message: e.toString(), onRetry: () {})),
            ),
          ],
        ),
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: SpeedDialFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}

class _TopMoverItem extends StatelessWidget {
  final StockAsset asset;

  const _TopMoverItem({required this.asset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changePercent = asset.gainLossPercent ?? 0.0;
    final isPositive = changePercent >= 0;
    final changeColor = AppTheme.getChangeColor(changePercent);

    return GestureDetector(
      onTap: () {
        if (asset.id != null) {
          context.push('/assets/${asset.id}');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            // Asset Icon (resolved by type and symbol)
            AssetIconResolver(
              symbol: asset.symbol,
              assetType: asset.type,
              name: asset.name,
              size: 40,
            ),
            const SizedBox(width: 12),
            // Name & Symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    asset.symbol.isNotEmpty ? asset.symbol : 'ASSET',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Value & Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(asset.totalValue ?? 0),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isPositive ? "+" : ""}${changePercent.toStringAsFixed(2)}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: changeColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

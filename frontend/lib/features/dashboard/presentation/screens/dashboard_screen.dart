import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section_with_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_news_section.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';
import 'package:wealthscope_app/shared/widgets/tech_card.dart';
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
      backgroundColor: theme.colorScheme.background,
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
              backgroundColor: theme.colorScheme.background.withOpacity(0.9),
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
                  margin: const EdgeInsets.only(right: 8),
                  child: const PremiumBadge(),
                ),
                // Sync Status
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.cardGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync,
                          size: 14, color: AppTheme.emeraldAccent),
                      const SizedBox(width: 4),
                      Text(
                        'SYNCED',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.textGrey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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

                      const SizedBox(height: 24),

                      // 3. Asset Allocation Donut
                      if (summary.breakdownByType.isNotEmpty) ...[
                        EnhancedAllocationSection(
                          allocations: summary.breakdownByType,
                          totalValue: summary.totalValue,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // 4. Intelligence Grid (Sentiment & Risk)
                      const _IntelligenceGrid(),

                      const SizedBox(height: 24),

                      // 5. Top Movers
                      const _SectionHeader(title: 'Top Movers'),
                      const SizedBox(height: 12),
                      assetsAsync.when(
                        data: (assets) {
                          if (assets.isEmpty) return const SizedBox.shrink();

                          // Convert to local model or generic mock for UI if needed
                          // Sorting rationale: Show biggest holdings first as proxy for 'top movers' for now
                          final sortedAssets = List<dynamic>.from(assets)
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

class _IntelligenceGrid extends StatelessWidget {
  const _IntelligenceGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: const [
        _GridCard(
          icon: CustomIcons.trendingUp,
          watermarkIcon: CustomIcons.trendingUp, // Rocket/Trending
          iconColor: AppTheme.emeraldAccent,
          label: 'Sentiment',
          value: 'Bullish',
          subtext: 'Market is hot',
        ),
        _GridCard(
          icon: Icons.security,
          watermarkIcon: Icons.security,
          iconColor: Colors.amber,
          label: 'Risk Level',
          value: 'Medium',
          subtext: 'Balanced Portfolio',
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final IconData icon;
  final IconData watermarkIcon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtext;

  const _GridCard({
    required this.icon,
    required this.watermarkIcon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(24), // Match new theme
        border:
            Border.all(color: Colors.white.withOpacity(0.02)), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Watermark Icon
            Positioned(
              right: -10,
              top: -10,
              child: Transform.rotate(
                angle: 0.2, // Slight tilt
                child: Icon(
                  watermarkIcon,
                  size: 80,
                  color: iconColor.withOpacity(0.07), // Very subtle
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: iconColor),
                      const SizedBox(width: 8),
                      Text(
                        label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.textGrey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            subtext,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: iconColor,
                                    ),
                          ),
                          const SizedBox(width: 4),
                          Icon(CustomIcons.arrowRight,
                              size: 10, color: iconColor),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopMoverItem extends ConsumerWidget {
  final dynamic asset;

  const _TopMoverItem({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Mock change percentage for demo as it might not be in asset model
    final mockChange = 5.2;

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
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.deepBlue,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(CustomIcons.assets, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            // Name
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
                  ),
                  Text(
                    asset.symbol ?? 'ASSET',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            // Value
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
                  children: [
                    Text(
                      '+$mockChange%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.emeraldAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_upward,
                        size: 12, color: AppTheme.emeraldAccent),
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

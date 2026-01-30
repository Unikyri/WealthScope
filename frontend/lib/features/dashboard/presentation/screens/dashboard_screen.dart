import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/enhanced_allocation_section_with_legend.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/empty_dashboard.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/error_view.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/last_updated_indicator.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/portfolio_summary_card.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/price_status_chip.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/risk_alerts_section.dart';
import 'package:wealthscope_app/features/dashboard/presentation/widgets/top_assets_section.dart';
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
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
              if (summary.totalValue == 0 && summary.allocations.isEmpty) {
                return EmptyDashboard(
                  onAddAsset: () => context.go('/assets/select-type'),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PortfolioSummaryCard(summary: summary),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LastUpdatedIndicator(
                          lastUpdated: summary.lastUpdated,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceStatusChip(
                        lastUpdated: summary.lastUpdated,
                        isMarketOpen: summary.isMarketOpen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (summary.allocations.isNotEmpty) ...[
                    EnhancedAllocationSection(allocations: summary.allocations),
                    const SizedBox(height: 24),
                  ],
                  if (summary.alerts.isNotEmpty) ...[
                    RiskAlertsSection(alerts: summary.alerts),
                    const SizedBox(height: 24),
                  ],
                  if (summary.topAssets.isNotEmpty) ...[
                    TopAssetsSection(topAssets: summary.topAssets),
                  ],
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


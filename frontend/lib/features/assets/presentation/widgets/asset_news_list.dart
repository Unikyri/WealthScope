import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/news/presentation/providers/asset_news_provider.dart';
import 'package:wealthscope_app/shared/widgets/news_card.dart';
import 'package:wealthscope_app/shared/widgets/shimmer_box.dart';

/// Displays news articles related to a specific asset with a 3-level fallback:
/// 1. Symbol-specific news
/// 2. Category/type-related news
/// 3. General trending financial news
///
/// Never shows a generic empty state. Always provides informative feedback.
class AssetNewsList extends ConsumerWidget {
  final String symbol;
  final AssetType assetType;

  const AssetNewsList({
    super.key,
    required this.symbol,
    required this.assetType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(
      assetNewsProvider(symbol, assetType.toApiString()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.newspaper, color: AppTheme.electricBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Related News',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Content based on async state
        newsAsync.when(
          data: (result) {
            final articles = result.articles.take(3).toList();

            if (articles.isEmpty) {
              return _buildNoNewsMessage(context);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source indicator for fallback levels
                if (result.source == NewsSource.category)
                  _buildSourceIndicator(
                    context,
                    'Related ${assetType.displayName} news',
                    Icons.category_rounded,
                  ),
                if (result.source == NewsSource.trending)
                  _buildSourceIndicator(
                    context,
                    'Trending in markets',
                    Icons.trending_up_rounded,
                  ),

                // News cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NewsCard(
                        article: articles[index],
                        relatedSymbols: null,
                        sentiment: null,
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => _buildLoadingSkeleton(context),
          error: (error, _) => _buildErrorState(context, ref),
        ),
      ],
    );
  }

  /// Subtle chip indicating the source of the news (category or trending).
  Widget _buildSourceIndicator(
      BuildContext context, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.electricBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.electricBlue.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppTheme.electricBlue),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.electricBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shimmer loading skeleton (3 compact cards).
  Widget _buildLoadingSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShimmerContainer(
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.cardGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Image placeholder
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Network error state with retry.
  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: AppTheme.textGrey,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              'Could not load news',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check your connection and try again',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textGrey,
                  ),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(
                  assetNewsProvider(symbol, assetType.toApiString()),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.electricBlue,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Informative message when absolutely no news are available (extreme case).
  Widget _buildNoNewsMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.newspaper_rounded,
              color: AppTheme.textGrey,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              'Stay informed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'News for this sector updates periodically',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textGrey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

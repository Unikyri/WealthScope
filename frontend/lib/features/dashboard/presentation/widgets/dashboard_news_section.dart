import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/personalized_news_item.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/shared/widgets/news_card.dart';

/// Compact news section for dashboard
/// Shows personalized news based on user portfolio (latest 5 in carousel)
class DashboardNewsSection extends ConsumerWidget {
  const DashboardNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final newsAsync = ref.watch(dashboardPersonalizedNewsProvider);

    return newsAsync.when(
      loading: () => const _NewsSectionSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        final latestNews = items.take(5).toList();
        if (latestNews.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              'Add assets to see personalized news',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          );
        }
        return _NewsSectionContent(items: latestNews);
      },
    );
  }
}

class _NewsSectionContent extends StatelessWidget {
  const _NewsSectionContent({required this.items});

  final List<PersonalizedNewsItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 24,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Latest Financial News',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => context.push('/news'),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('See All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal scrollable news cards
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : 12,
                ),
                child: _buildNewsCard(context, item),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(BuildContext context, PersonalizedNewsItem item) {
    return Stack(
      children: [
        NewsCard(
          article: item.article,
          isCompact: true,
          sentiment: _getSentiment(item.article),
          relatedSymbols:
              item.isPortfolioRelevant ? item.relatedSymbols : null,
        ),
        if (item.isPortfolioRelevant)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Relevante para tu portfolio',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
      ],
    );
  }

  static NewsSentiment _getSentiment(NewsArticle article) {
    final titleLower = article.title.toLowerCase();
    if (titleLower.contains('surge') ||
        titleLower.contains('rally') ||
        titleLower.contains('gain') ||
        titleLower.contains('up')) {
      return NewsSentiment.positive;
    } else if (titleLower.contains('fall') ||
        titleLower.contains('drop') ||
        titleLower.contains('decline') ||
        titleLower.contains('crash')) {
      return NewsSentiment.negative;
    }
    return NewsSentiment.neutral;
  }
}

class _NewsSectionSkeleton extends StatelessWidget {
  const _NewsSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.newspaper, size: 24, color: shimmerColor),
              const SizedBox(width: 8),
              Container(
                width: 160,
                height: 24,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

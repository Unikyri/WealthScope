import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/features/news/presentation/providers/news_provider.dart';
import 'package:wealthscope_app/shared/widgets/news_card.dart';

/// Compact news section for dashboard
/// Shows latest 5 news in a horizontal scrollable carousel
class DashboardNewsSection extends ConsumerWidget {
  const DashboardNewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final newsState = ref.watch(newsProvider);

    // Get latest 5 articles
    final latestNews = newsState.articles.take(5).toList();

    if (latestNews.isEmpty) {
      return const SizedBox.shrink();
    }

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
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: latestNews.length,
            itemBuilder: (context, index) {
              final article = latestNews[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == latestNews.length - 1 ? 0 : 12,
                ),
                child: NewsCard(
                  article: article,
                  isCompact: true,
                  sentiment: _getSentiment(article),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Get sentiment for an article (mock implementation)
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

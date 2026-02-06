import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/features/news/presentation/providers/news_provider.dart';
import 'package:wealthscope_app/shared/widgets/news_card.dart';

/// News Screen with filtering, search, and pagination
class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(newsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsState = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                style: theme.textTheme.titleLarge,
                onSubmitted: (value) {
                  ref.read(newsProvider.notifier).search(value);
                },
              )
            : const Text('Financial News'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
                ref.read(newsProvider.notifier).clearSearch();
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          _buildCategoryFilters(newsState.selectedCategory),
          
          // News list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(newsProvider.notifier).refresh(),
              child: newsState.articles.isEmpty && newsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : newsState.articles.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: newsState.articles.length +
                              (newsState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == newsState.articles.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final article = newsState.articles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: NewsCard(
                                article: article,
                                relatedSymbols: _getRelatedSymbols(article),
                                sentiment: _getSentiment(article),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(NewsCategory selectedCategory) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: NewsCategory.values.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(newsProvider.notifier).filterByCategory(category);
                }
              },
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No news found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  /// Get related symbols for an article (mock implementation)
  List<String>? _getRelatedSymbols(NewsArticle article) {
    // Mock logic - in real app, this would come from article data
    final category = article.category;
    if (category == NewsCategory.stocks) {
      return ['AAPL', 'TSLA'];
    } else if (category == NewsCategory.crypto) {
      return ['BTC', 'ETH'];
    } else if (category == NewsCategory.forex) {
      return ['EUR/USD', 'GBP/USD'];
    }
    return null;
  }

  /// Get sentiment for an article (mock implementation)
  NewsSentiment? _getSentiment(NewsArticle article) {
    // Mock logic - in real app, this would be analyzed from content
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

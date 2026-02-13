import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/features/news/presentation/providers/asset_news_provider.dart';

part 'news_provider.g.dart';

/// State for news with pagination
class NewsState {
  final List<NewsArticle> articles;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;
  final NewsCategory selectedCategory;
  final String searchQuery;

  const NewsState({
    this.articles = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
    this.selectedCategory = NewsCategory.all,
    this.searchQuery = '',
  });

  NewsState copyWith({
    List<NewsArticle>? articles,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
    NewsCategory? selectedCategory,
    String? searchQuery,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// News provider with pagination, filtering, and search
@riverpod
class News extends _$News {
  static const int _pageSize = 10;

  @override
  NewsState build() {
    // Load initial news after first build
    Future.microtask(() => _loadInitialNews());
    return const NewsState();
  }

  /// Load initial news from backend API
  Future<void> _loadInitialNews() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final datasource = ref.read(newsRemoteDatasourceProvider);

      // Check if provider is still mounted after async gap
      if (!ref.mounted) return;

      List<NewsArticle> articles;
      if (state.searchQuery.isNotEmpty) {
        articles = await datasource.search(
          state.searchQuery,
          limit: _pageSize * 3,
        );
      } else if (state.selectedCategory == NewsCategory.all) {
        articles = await datasource.getTrending(limit: _pageSize * 2);
      } else {
        final keyword = _categoryToSearchKeyword(state.selectedCategory);
        articles = await datasource.search(keyword, limit: _pageSize * 2);
      }

      if (!ref.mounted) return;

      state = state.copyWith(
        articles: articles,
        isLoading: false,
        currentPage: 1,
        hasMore: false, // Backend does not support pagination yet
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        articles: [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  String _categoryToSearchKeyword(NewsCategory category) {
    switch (category) {
      case NewsCategory.stocks:
        return 'stock market';
      case NewsCategory.crypto:
        return 'cryptocurrency';
      case NewsCategory.forex:
        return 'forex';
      case NewsCategory.all:
        return 'financial markets';
    }
  }

  /// Refresh news (pull-to-refresh)
  Future<void> refresh() async {
    state = state.copyWith(
      articles: [],
      currentPage: 1,
      hasMore: true,
      error: null,
    );
    await _loadInitialNews();
  }

  /// Load more news (pagination)
  /// Backend does not support pagination yet; loadMore is a no-op.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    // No-op: backend /news and /news/search do not support page/offset
  }

  /// Filter by category
  Future<void> filterByCategory(NewsCategory category) async {
    if (state.selectedCategory == category) return;

    state = state.copyWith(
      selectedCategory: category,
      articles: [],
      currentPage: 1,
      hasMore: true,
    );

    await _loadInitialNews();
  }

  /// Search news
  Future<void> search(String query) async {
    if (state.searchQuery == query) return;

    state = state.copyWith(
      searchQuery: query,
      articles: [],
      currentPage: 1,
      hasMore: true,
    );

    await _loadInitialNews();
  }

  /// Clear search
  Future<void> clearSearch() async {
    await search('');
  }

}

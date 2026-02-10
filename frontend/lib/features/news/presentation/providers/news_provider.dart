import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

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

  /// Load initial news
  Future<void> _loadInitialNews() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Check if provider is still mounted after async gap
      if (!ref.mounted) return;
      
      final articles = _getMockArticles(
        page: 1,
        category: state.selectedCategory,
        searchQuery: state.searchQuery,
      );

      state = state.copyWith(
        articles: articles,
        isLoading: false,
        currentPage: 1,
        hasMore: articles.length >= _pageSize,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Check if provider is still mounted after async gap
      if (!ref.mounted) return;
      
      final newArticles = _getMockArticles(
        page: state.currentPage + 1,
        category: state.selectedCategory,
        searchQuery: state.searchQuery,
      );

      state = state.copyWith(
        articles: [...state.articles, ...newArticles],
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: newArticles.length >= _pageSize,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
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

  /// Generate mock news articles
  List<NewsArticle> _getMockArticles({
    required int page,
    required NewsCategory category,
    required String searchQuery,
  }) {
    final allArticles = _generateMockData();

    // Filter by category
    var filtered = category == NewsCategory.all
        ? allArticles
        : allArticles.where((a) => a.category == category.value).toList();

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              a.description.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Paginate
    final startIndex = (page - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= filtered.length) {
      return [];
    }

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  /// Generate mock news data
  List<NewsArticle> _generateMockData() {
    final now = DateTime.now();

    return [
      // Stocks
      NewsArticle(
        id: '1',
        title: 'Tech Stocks Rally as AI Boom Continues',
        description:
            'Major tech companies see significant gains as artificial intelligence investments pay off.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/tech1/800/400',
        source: 'Financial Times',
        author: 'John Smith',
        publishedAt: now.subtract(const Duration(hours: 2)),
        category: 'stocks',
        url: 'https://example.com/tech-stocks-rally',
        tags: ['tech', 'AI', 'stocks'],
      ),
      NewsArticle(
        id: '2',
        title: 'Energy Sector Faces Headwinds Amid Policy Changes',
        description:
            'New regulations impact energy companies as government shifts focus to renewables.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/energy1/800/400',
        source: 'Bloomberg',
        author: 'Sarah Johnson',
        publishedAt: now.subtract(const Duration(hours: 5)),
        category: 'stocks',
        url: 'https://example.com/energy-sector',
        tags: ['energy', 'policy', 'stocks'],
      ),
      NewsArticle(
        id: '3',
        title: 'Banking Sector Reports Strong Q4 Earnings',
        description:
            'Major banks exceed analyst expectations with robust quarterly results.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/bank1/800/400',
        source: 'Reuters',
        author: 'Michael Chen',
        publishedAt: now.subtract(const Duration(hours: 8)),
        category: 'stocks',
        url: 'https://example.com/banking-earnings',
        tags: ['banking', 'earnings', 'stocks'],
      ),

      // Crypto
      NewsArticle(
        id: '4',
        title: 'Bitcoin Surges Past \$50,000 Mark',
        description:
            'Cryptocurrency reaches new milestone amid institutional adoption.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/bitcoin1/800/400',
        source: 'CoinDesk',
        author: 'Alex Rivera',
        publishedAt: now.subtract(const Duration(hours: 1)),
        category: 'crypto',
        url: 'https://example.com/bitcoin-surge',
        tags: ['bitcoin', 'crypto', 'milestone'],
      ),
      NewsArticle(
        id: '5',
        title: 'Ethereum 2.0 Upgrade Boosts Network Performance',
        description:
            'Major blockchain upgrade delivers promised scalability improvements.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/eth1/800/400',
        source: 'Crypto News',
        author: 'Emma Davis',
        publishedAt: now.subtract(const Duration(hours: 3)),
        category: 'crypto',
        url: 'https://example.com/ethereum-upgrade',
        tags: ['ethereum', 'crypto', 'technology'],
      ),
      NewsArticle(
        id: '6',
        title: 'DeFi Protocols See Record TVL Growth',
        description:
            'Decentralized finance platforms attract billions in new capital.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/defi1/800/400',
        source: 'DeFi Pulse',
        author: 'James Wilson',
        publishedAt: now.subtract(const Duration(hours: 6)),
        category: 'crypto',
        url: 'https://example.com/defi-growth',
        tags: ['DeFi', 'crypto', 'TVL'],
      ),

      // Forex
      NewsArticle(
        id: '7',
        title: 'Dollar Strengthens Against Major Currencies',
        description:
            'USD gains ground as Fed signals continued hawkish stance.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/usd1/800/400',
        source: 'FX Street',
        author: 'Robert Martinez',
        publishedAt: now.subtract(const Duration(hours: 4)),
        category: 'forex',
        url: 'https://example.com/dollar-strength',
        tags: ['USD', 'forex', 'Fed'],
      ),
      NewsArticle(
        id: '8',
        title: 'Euro Zone Inflation Data Impacts EUR/USD Pair',
        description:
            'Latest economic indicators drive currency market volatility.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/eur1/800/400',
        source: 'ForexLive',
        author: 'Linda Brown',
        publishedAt: now.subtract(const Duration(hours: 7)),
        category: 'forex',
        url: 'https://example.com/euro-inflation',
        tags: ['EUR', 'forex', 'inflation'],
      ),
      NewsArticle(
        id: '9',
        title: 'Yen Weakens as BOJ Maintains Ultra-Loose Policy',
        description:
            'Japanese currency falls to multi-year lows against dollar.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/jpy1/800/400',
        source: 'Forex Factory',
        author: 'David Kim',
        publishedAt: now.subtract(const Duration(hours: 10)),
        category: 'forex',
        url: 'https://example.com/yen-weakness',
        tags: ['JPY', 'forex', 'BOJ'],
      ),

      // More stocks
      NewsArticle(
        id: '10',
        title: 'Healthcare Stocks Rally on FDA Approvals',
        description:
            'Pharmaceutical companies surge after drug approval announcements.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/health1/800/400',
        source: 'MedTech Today',
        author: 'Patricia Lee',
        publishedAt: now.subtract(const Duration(days: 1)),
        category: 'stocks',
        url: 'https://example.com/healthcare-rally',
        tags: ['healthcare', 'FDA', 'stocks'],
      ),
      NewsArticle(
        id: '11',
        title: 'Retail Sector Struggles with Changing Consumer Habits',
        description:
            'Traditional retailers face challenges as e-commerce continues to dominate.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/retail1/800/400',
        source: 'Retail Gazette',
        author: 'Thomas Anderson',
        publishedAt: now.subtract(const Duration(days: 1, hours: 2)),
        category: 'stocks',
        url: 'https://example.com/retail-challenges',
        tags: ['retail', 'e-commerce', 'stocks'],
      ),
      NewsArticle(
        id: '12',
        title: 'Automotive Industry Embraces Electric Vehicle Transition',
        description:
            'Major car manufacturers announce ambitious EV production targets.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/auto1/800/400',
        source: 'Auto News',
        author: 'Jennifer White',
        publishedAt: now.subtract(const Duration(days: 1, hours: 5)),
        category: 'stocks',
        url: 'https://example.com/ev-transition',
        tags: ['automotive', 'EV', 'stocks'],
      ),

      // More crypto
      NewsArticle(
        id: '13',
        title: 'NFT Market Shows Signs of Recovery',
        description:
            'Digital collectibles gain traction with new utility features.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/nft1/800/400',
        source: 'NFT Evening',
        author: 'Marcus Johnson',
        publishedAt: now.subtract(const Duration(days: 1, hours: 8)),
        category: 'crypto',
        url: 'https://example.com/nft-recovery',
        tags: ['NFT', 'crypto', 'digital art'],
      ),
      NewsArticle(
        id: '14',
        title: 'Major Exchange Announces New Staking Rewards',
        description:
            'Cryptocurrency platform introduces enhanced yield opportunities.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/stake1/800/400',
        source: 'Crypto Briefing',
        author: 'Sophia Martinez',
        publishedAt: now.subtract(const Duration(days: 2)),
        category: 'crypto',
        url: 'https://example.com/staking-rewards',
        tags: ['staking', 'crypto', 'yield'],
      ),

      // More forex
      NewsArticle(
        id: '15',
        title: 'Pound Sterling Rebounds on Strong GDP Data',
        description:
            'British currency gains strength following positive economic reports.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/gbp1/800/400',
        source: 'UK Finance News',
        author: 'Oliver Thompson',
        publishedAt: now.subtract(const Duration(days: 2, hours: 3)),
        category: 'forex',
        url: 'https://example.com/pound-rebound',
        tags: ['GBP', 'forex', 'GDP'],
      ),
      NewsArticle(
        id: '16',
        title: 'Australian Dollar Falls on China Concerns',
        description:
            'AUD weakens as traders worry about Chinese economic slowdown.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/aud1/800/400',
        source: 'Asia FX',
        author: 'Rachel Zhang',
        publishedAt: now.subtract(const Duration(days: 2, hours: 6)),
        category: 'forex',
        url: 'https://example.com/aud-falls',
        tags: ['AUD', 'forex', 'China'],
      ),

      // Additional variety
      NewsArticle(
        id: '17',
        title: 'Semiconductor Stocks Rise on Supply Chain Improvements',
        description:
            'Chip makers benefit from easing global supply constraints.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/semi1/800/400',
        source: 'Tech Insider',
        author: 'Kevin Park',
        publishedAt: now.subtract(const Duration(days: 3)),
        category: 'stocks',
        url: 'https://example.com/semiconductor-rise',
        tags: ['semiconductor', 'supply chain', 'stocks'],
      ),
      NewsArticle(
        id: '18',
        title: 'Web3 Gaming Platforms Attract Major Investment',
        description:
            'Blockchain-based games secure funding from venture capital.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/web3game1/800/400',
        source: 'Gaming Finance',
        author: 'Lisa Chen',
        publishedAt: now.subtract(const Duration(days: 3, hours: 4)),
        category: 'crypto',
        url: 'https://example.com/web3-gaming',
        tags: ['Web3', 'gaming', 'crypto'],
      ),
      NewsArticle(
        id: '19',
        title: 'Central Banks Signal Coordinated Policy Shift',
        description:
            'Global monetary authorities adjust strategies amid inflation concerns.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/central1/800/400',
        source: 'Central Banking',
        author: 'William Garcia',
        publishedAt: now.subtract(const Duration(days: 4)),
        category: 'forex',
        url: 'https://example.com/central-banks',
        tags: ['central banks', 'policy', 'forex'],
      ),
      NewsArticle(
        id: '20',
        title: 'Real Estate Investment Trusts See Renewed Interest',
        description:
            'REITs attract investors seeking yield in low-rate environment.',
        content:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        imageUrl: 'https://picsum.photos/seed/reit1/800/400',
        source: 'Property Weekly',
        author: 'Amanda Scott',
        publishedAt: now.subtract(const Duration(days: 4, hours: 8)),
        category: 'stocks',
        url: 'https://example.com/reit-interest',
        tags: ['REIT', 'real estate', 'stocks'],
      ),
    ];
  }
}

import 'package:dio/dio.dart';
import 'package:wealthscope_app/features/news/data/models/news_article_dto.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

/// Remote data source for news API calls.
///
/// Communicates with the backend endpoints:
/// - `GET /news/symbol/:symbol` (Level 1)
/// - `GET /news/search?q=keywords` (Level 2)
/// - `GET /news/trending` (Level 3)
class NewsRemoteDatasource {
  final Dio _dio;

  NewsRemoteDatasource(this._dio);

  /// Level 1: Fetch news by asset symbol.
  Future<List<NewsArticle>> getBySymbol(String symbol,
      {int limit = 5}) async {
    final response = await _dio.get(
      '/news/symbol/$symbol',
      queryParameters: {'limit': limit},
    );
    return _parseArticles(response);
  }

  /// Level 2: Search news by keywords.
  Future<List<NewsArticle>> search(String keywords,
      {int limit = 5}) async {
    final response = await _dio.get(
      '/news/search',
      queryParameters: {'q': keywords, 'limit': limit},
    );
    return _parseArticles(response);
  }

  /// Fetch news for multiple symbols in a single request.
  /// Uses GET /news?symbols=AAPL,TSLA,BTC
  Future<List<NewsArticle>> getBySymbols(List<String> symbols,
      {int limit = 15}) async {
    if (symbols.isEmpty) return getTrending(limit: limit);
    final response = await _dio.get(
      '/news',
      queryParameters: {'symbols': symbols.join(','), 'limit': limit},
    );
    return _parseArticles(response);
  }

  /// Level 3: Fetch trending/general financial news.
  Future<List<NewsArticle>> getTrending({int limit = 5}) async {
    final response = await _dio.get(
      '/news/trending',
      queryParameters: {'limit': limit},
    );
    return _parseArticles(response);
  }

  /// Parse the standard API response into a list of domain [NewsArticle].
  ///
  /// Expected response structure:
  /// ```json
  /// { "success": true, "data": { "articles": [...] } }
  /// ```
  List<NewsArticle> _parseArticles(Response response) {
    final data = response.data;
    if (data == null) return [];

    // Handle the wrapped response format
    final Map<String, dynamic> body;
    if (data is Map<String, dynamic>) {
      body = data;
    } else {
      return [];
    }

    // Extract articles from nested data.articles
    final dynamic innerData = body['data'];
    final List<dynamic>? articles;

    if (innerData is Map<String, dynamic>) {
      articles = innerData['articles'] as List<dynamic>?;
    } else if (innerData is List<dynamic>) {
      articles = innerData;
    } else {
      // Try top-level articles key
      articles = body['articles'] as List<dynamic>?;
    }

    if (articles == null || articles.isEmpty) return [];

    return articles
        .whereType<Map<String, dynamic>>()
        .map((json) => NewsArticleDto.fromJson(json).toDomain())
        .toList();
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/news/data/datasources/news_remote_datasource.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/features/news/domain/news_category_mapper.dart';

part 'asset_news_provider.g.dart';

/// The source level from which news were obtained.
enum NewsSource {
  /// News specific to the asset symbol (Level 1).
  symbol,

  /// News related to the asset category/type (Level 2).
  category,

  /// General trending financial news (Level 3).
  trending,

  /// No news could be fetched at any level.
  none,
}

/// Result object containing news articles and their source level.
class AssetNewsResult {
  final List<NewsArticle> articles;
  final NewsSource source;

  const AssetNewsResult({
    required this.articles,
    required this.source,
  });
}

/// Provides a [NewsRemoteDatasource] singleton backed by [DioClient].
@riverpod
NewsRemoteDatasource newsRemoteDatasource(Ref ref) {
  return NewsRemoteDatasource(DioClient.instance);
}

/// Fetches news for an asset using a 3-level fallback strategy:
///
/// 1. **Symbol** -- news mentioning the specific ticker (e.g. AAPL).
/// 2. **Category** -- news matching the asset type keywords (e.g. "cryptocurrency").
/// 3. **Trending** -- general trending financial news.
///
/// [symbol] may be null/empty for assets without a ticker (e.g. real estate).
/// [assetTypeStr] is the API-format string of the asset type.
@riverpod
Future<AssetNewsResult> assetNews(
  Ref ref,
  String? symbol,
  String assetTypeStr,
) async {
  final datasource = ref.watch(newsRemoteDatasourceProvider);
  final assetType = AssetType.fromString(assetTypeStr);

  // Level 1: News by symbol
  if (symbol != null && symbol.isNotEmpty) {
    try {
      final articles = await datasource.getBySymbol(symbol);
      if (articles.isNotEmpty) {
        return AssetNewsResult(articles: articles, source: NewsSource.symbol);
      }
    } catch (_) {
      // Fall through to Level 2
    }
  }

  // Level 2: News by category keywords
  final keyword = NewsCategoryMapper.getPrimaryKeyword(assetType);
  try {
    final articles = await datasource.search(keyword);
    if (articles.isNotEmpty) {
      return AssetNewsResult(articles: articles, source: NewsSource.category);
    }
  } catch (_) {
    // Fall through to Level 3
  }

  // Level 3: Trending news
  try {
    final articles = await datasource.getTrending();
    if (articles.isNotEmpty) {
      return AssetNewsResult(articles: articles, source: NewsSource.trending);
    }
  } catch (_) {
    // All levels exhausted
  }

  return const AssetNewsResult(articles: [], source: NewsSource.none);
}

import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

/// Relevance level for news articles relative to user portfolio.
enum RelevanceLevel {
  /// News that mentions a user asset directly (e.g. from getBySymbol).
  direct,

  /// News from asset type/category (e.g. from search by keyword).
  sector,

  /// General trending financial news.
  general,
}

/// News article with relevance metadata for personalized dashboard display.
class PersonalizedNewsItem {
  const PersonalizedNewsItem({
    required this.article,
    required this.relatedSymbols,
    required this.level,
    required this.relevanceScore,
  });

  final NewsArticle article;
  final List<String> relatedSymbols;
  final RelevanceLevel level;
  final int relevanceScore;

  /// Whether this article is directly relevant to user portfolio (shows badge).
  bool get isPortfolioRelevant => relatedSymbols.isNotEmpty;
}

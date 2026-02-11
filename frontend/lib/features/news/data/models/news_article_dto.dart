import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

/// DTO that maps the backend JSON response to the domain [NewsArticle] entity.
///
/// Backend fields differ from frontend entity:
/// - `image_url` (snake_case) -> `imageUrl`
/// - `published_at` (ISO 8601 string) -> `publishedAt` (DateTime)
/// - `provider` -> mapped as `author`
/// - `symbols` (List) -> mapped as `tags`
class NewsArticleDto {
  final String id;
  final String title;
  final String description;
  final String? content;
  final String? imageUrl;
  final String source;
  final String? provider;
  final List<String>? symbols;
  final double? sentiment;
  final String? publishedAt;
  final String url;

  NewsArticleDto.fromJson(Map<String, dynamic> json)
      : id = json['id']?.toString() ?? '',
        title = json['title']?.toString() ?? '',
        description = json['description']?.toString() ?? '',
        content = json['content']?.toString(),
        imageUrl = json['image_url']?.toString(),
        source = json['source']?.toString() ?? '',
        provider = json['provider']?.toString(),
        symbols = (json['symbols'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        sentiment = (json['sentiment'] as num?)?.toDouble(),
        publishedAt = json['published_at']?.toString(),
        url = json['url']?.toString() ?? '';

  /// Convert DTO to domain entity.
  NewsArticle toDomain() {
    return NewsArticle(
      id: id,
      title: title,
      description: description,
      content: content ?? '',
      imageUrl: imageUrl ?? '',
      source: source,
      author: provider ?? source,
      publishedAt: _parseDate(publishedAt),
      category: '',
      url: url,
      tags: symbols ?? [],
    );
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    return DateTime.tryParse(dateStr) ?? DateTime.now();
  }
}

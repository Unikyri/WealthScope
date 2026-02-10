/// News article entity
/// Represents a financial news article
class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String source;
  final String author;
  final DateTime publishedAt;
  final String category; // 'all', 'stocks', 'crypto', 'forex'
  final String url;
  final List<String> tags;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.source,
    required this.author,
    required this.publishedAt,
    required this.category,
    required this.url,
    required this.tags,
  });

  /// Get time ago string (e.g., "2 hours ago")
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Copy with method for immutable updates
  NewsArticle copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? imageUrl,
    String? source,
    String? author,
    DateTime? publishedAt,
    String? category,
    String? url,
    List<String>? tags,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      category: category ?? this.category,
      url: url ?? this.url,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsArticle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// News category enum
enum NewsCategory {
  all,
  stocks,
  crypto,
  forex;

  String get displayName {
    switch (this) {
      case NewsCategory.all:
        return 'All';
      case NewsCategory.stocks:
        return 'Stocks';
      case NewsCategory.crypto:
        return 'Crypto';
      case NewsCategory.forex:
        return 'Forex';
    }
  }

  String get value {
    return name;
  }

  static NewsCategory fromString(String value) {
    return NewsCategory.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => NewsCategory.all,
    );
  }
}

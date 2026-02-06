import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

void main() {
  group('NewsArticle', () {
    test('should create news article with all required fields', () {
      final publishedAt = DateTime(2024, 1, 15);
      final article = NewsArticle(
        id: '1',
        title: 'Test Article',
        description: 'Test description',
        content: 'Test content',
        imageUrl: 'https://example.com/image.jpg',
        source: 'Test Source',
        author: 'Test Author',
        publishedAt: publishedAt,
        category: 'stocks',
        url: 'https://example.com/article',
        tags: ['test', 'article'],
      );

      expect(article.id, '1');
      expect(article.title, 'Test Article');
      expect(article.category, 'stocks');
      expect(article.tags.length, 2);
    });

    test('getTimeAgo should return correct time string', () {
      final now = DateTime.now();
      
      // Just now
      final justNow = NewsArticle(
        id: '1',
        title: 'Test',
        description: 'Test',
        content: 'Test',
        imageUrl: '',
        source: 'Test',
        author: 'Test',
        publishedAt: now,
        category: 'stocks',
        url: '',
        tags: [],
      );
      expect(justNow.getTimeAgo(), 'Just now');

      // Hours ago
      final hoursAgo = NewsArticle(
        id: '1',
        title: 'Test',
        description: 'Test',
        content: 'Test',
        imageUrl: '',
        source: 'Test',
        author: 'Test',
        publishedAt: now.subtract(const Duration(hours: 3)),
        category: 'stocks',
        url: '',
        tags: [],
      );
      expect(hoursAgo.getTimeAgo(), '3 hours ago');

      // Days ago
      final daysAgo = NewsArticle(
        id: '1',
        title: 'Test',
        description: 'Test',
        content: 'Test',
        imageUrl: '',
        source: 'Test',
        author: 'Test',
        publishedAt: now.subtract(const Duration(days: 2)),
        category: 'stocks',
        url: '',
        tags: [],
      );
      expect(daysAgo.getTimeAgo(), '2 days ago');
    });

    test('copyWith should update only specified fields', () {
      final original = NewsArticle(
        id: '1',
        title: 'Original Title',
        description: 'Original description',
        content: 'Original content',
        imageUrl: 'https://example.com/original.jpg',
        source: 'Original Source',
        author: 'Original Author',
        publishedAt: DateTime.now(),
        category: 'stocks',
        url: 'https://example.com/original',
        tags: ['original'],
      );

      final updated = original.copyWith(
        title: 'Updated Title',
        category: 'crypto',
      );

      expect(updated.title, 'Updated Title');
      expect(updated.category, 'crypto');
      expect(updated.description, 'Original description'); // Unchanged
      expect(updated.source, 'Original Source'); // Unchanged
    });

    test('equality should work based on id', () {
      final article1 = NewsArticle(
        id: '1',
        title: 'Article 1',
        description: 'Desc 1',
        content: 'Content 1',
        imageUrl: '',
        source: 'Source',
        author: 'Author',
        publishedAt: DateTime.now(),
        category: 'stocks',
        url: '',
        tags: [],
      );

      final article2 = NewsArticle(
        id: '1',
        title: 'Different Title',
        description: 'Different desc',
        content: 'Different content',
        imageUrl: '',
        source: 'Source',
        author: 'Author',
        publishedAt: DateTime.now(),
        category: 'crypto',
        url: '',
        tags: [],
      );

      final article3 = NewsArticle(
        id: '2',
        title: 'Article 1',
        description: 'Desc 1',
        content: 'Content 1',
        imageUrl: '',
        source: 'Source',
        author: 'Author',
        publishedAt: DateTime.now(),
        category: 'stocks',
        url: '',
        tags: [],
      );

      expect(article1, equals(article2)); // Same ID
      expect(article1, isNot(equals(article3))); // Different ID
    });
  });

  group('NewsCategory', () {
    test('should have correct display names', () {
      expect(NewsCategory.all.displayName, 'All');
      expect(NewsCategory.stocks.displayName, 'Stocks');
      expect(NewsCategory.crypto.displayName, 'Crypto');
      expect(NewsCategory.forex.displayName, 'Forex');
    });

    test('should have correct values', () {
      expect(NewsCategory.all.value, 'all');
      expect(NewsCategory.stocks.value, 'stocks');
      expect(NewsCategory.crypto.value, 'crypto');
      expect(NewsCategory.forex.value, 'forex');
    });

    test('fromString should parse correctly', () {
      expect(NewsCategory.fromString('stocks'), NewsCategory.stocks);
      expect(NewsCategory.fromString('CRYPTO'), NewsCategory.crypto);
      expect(NewsCategory.fromString('forex'), NewsCategory.forex);
      expect(NewsCategory.fromString('invalid'), NewsCategory.all);
    });
  });
}

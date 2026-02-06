import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';

/// Sentiment types for news articles
enum NewsSentiment {
  positive,
  neutral,
  negative;

  Color get color {
    switch (this) {
      case NewsSentiment.positive:
        return Colors.green;
      case NewsSentiment.neutral:
        return Colors.grey;
      case NewsSentiment.negative:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case NewsSentiment.positive:
        return Icons.trending_up;
      case NewsSentiment.neutral:
        return Icons.trending_flat;
      case NewsSentiment.negative:
        return Icons.trending_down;
    }
  }
}

/// Reusable news card widget with all features
/// 
/// Features:
/// - Image with placeholder fallback
/// - Title truncation (max 2 lines)
/// - Source and time metadata
/// - Related symbols as chips
/// - Sentiment indicator
/// - Tap to open article
class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final List<String>? relatedSymbols;
  final NewsSentiment? sentiment;
  final VoidCallback? onTap;
  final bool isCompact;

  const NewsCard({
    super.key,
    required this.article,
    this.relatedSymbols,
    this.sentiment,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? () => _openArticle(context, article),
        child: isCompact ? _buildCompactLayout(context) : _buildFullLayout(context),
      ),
    );
  }

  /// Full layout for news screen
  Widget _buildFullLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        _buildImageSection(context),

        // Content section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and sentiment row
              _buildMetadataRow(context),
              
              const SizedBox(height: 8),
              
              // Title
              Text(
                article.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Description
              if (article.description.isNotEmpty)
                Text(
                  article.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Related symbols chips
              if (relatedSymbols != null && relatedSymbols!.isNotEmpty)
                _buildSymbolChips(context),
              
              if (relatedSymbols != null && relatedSymbols!.isNotEmpty)
                const SizedBox(height: 12),
              
              // Source and time
              _buildSourceRow(context),
            ],
          ),
        ),
      ],
    );
  }

  /// Compact layout for dashboard carousel
  Widget _buildCompactLayout(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with overlays
          Stack(
            children: [
              _buildImageSection(context, height: 120),
              
              // Category badge
              Positioned(
                top: 8,
                left: 8,
                child: _buildCategoryBadge(context),
              ),
              
              // Time badge
              Positioned(
                bottom: 8,
                right: 8,
                child: _buildTimeBadge(context),
              ),
              
              // Sentiment indicator
              if (sentiment != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildSentimentIndicator(context),
                ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  article.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Source
                Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        article.source,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build image section with placeholder fallback
  Widget _buildImageSection(BuildContext context, {double? height}) {
    return SizedBox(
      height: height ?? 200,
      width: double.infinity,
      child: article.imageUrl.isNotEmpty
          ? Image.network(
              article.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildImagePlaceholder(context);
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder(context);
              },
            )
          : _buildImagePlaceholder(context),
    );
  }

  /// Build image placeholder
  Widget _buildImagePlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.newspaper,
          size: 48,
          color: theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Build metadata row with category and sentiment
  Widget _buildMetadataRow(BuildContext context) {
    return Row(
      children: [
        _buildCategoryBadge(context),
        
        if (sentiment != null) ...[
          const SizedBox(width: 8),
          _buildSentimentIndicator(context),
        ],
        
        const Spacer(),
        
        _buildTimeBadge(context),
      ],
    );
  }

  /// Build category badge
  Widget _buildCategoryBadge(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(article.category, theme),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        article.category.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  /// Build sentiment indicator
  Widget _buildSentimentIndicator(BuildContext context) {
    if (sentiment == null) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: sentiment!.color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        sentiment!.icon,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  /// Build time badge
  Widget _buildTimeBadge(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        article.getTimeAgo(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  /// Build source row
  Widget _buildSourceRow(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          Icons.article_outlined,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            article.source,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.access_time,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 4),
        Text(
          article.getTimeAgo(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  /// Build symbol chips
  Widget _buildSymbolChips(BuildContext context) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: relatedSymbols!.map((symbol) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.show_chart,
                size: 14,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                symbol,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Get category color
  Color _getCategoryColor(String category, ThemeData theme) {
    switch (category.toLowerCase()) {
      case 'stocks':
        return Colors.blue;
      case 'crypto':
        return Colors.orange;
      case 'forex':
        return Colors.green;
      default:
        return theme.colorScheme.primary;
    }
  }

  /// Open article in in-app webview
  static void _openArticle(BuildContext context, NewsArticle article) {
    context.push(
      '/news/article?url=${Uri.encodeComponent(article.url)}&title=${Uri.encodeComponent(article.title)}',
    );
  }
}

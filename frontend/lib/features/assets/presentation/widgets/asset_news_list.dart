import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/news/presentation/providers/news_provider.dart';
import 'package:wealthscope_app/shared/widgets/news_card.dart';

class AssetNewsList extends ConsumerStatefulWidget {
  final String symbol;

  const AssetNewsList({
    super.key,
    required this.symbol,
  });

  @override
  ConsumerState<AssetNewsList> createState() => _AssetNewsListState();
}

class _AssetNewsListState extends ConsumerState<AssetNewsList> {
  
  @override
  void initState() {
    super.initState();
    // Trigger search for this symbol when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).search(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    
    // We limit to 3 articles for the detail view
    final articles = newsState.articles.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.newspaper, color: AppTheme.electricBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Related News',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        if (newsState.isLoading && articles.isEmpty)
          const Center(child: CircularProgressIndicator())
        else if (articles.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'No recent news found for ${widget.symbol}',
              style: TextStyle(color: AppTheme.textGrey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: NewsCard(
                  article: articles[index],
                  relatedSymbols: null, // Don't show tags in this condensed view
                  sentiment: null,
                ),
              );
            },
          ),
      ],
    );
  }
}

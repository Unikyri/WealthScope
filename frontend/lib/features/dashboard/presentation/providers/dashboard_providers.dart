import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/dashboard/data/datasources/dashboard_remote_source.dart';
import 'package:wealthscope_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/personalized_news_item.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_risk.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';
import 'package:wealthscope_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:wealthscope_app/features/news/data/datasources/news_remote_datasource.dart';
import 'package:wealthscope_app/features/news/domain/entities/news_article.dart';
import 'package:wealthscope_app/features/news/presentation/providers/asset_news_provider.dart';

part 'dashboard_providers.g.dart';

/// Dashboard Remote Data Source Provider
@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(
  Ref ref,
) {
  final dio = ref.watch(dioClientProvider);
  return DashboardRemoteDataSource(dio);
}

/// Dashboard Repository Provider
@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  final remoteSource = ref.watch(dashboardRemoteDataSourceProvider);
  return DashboardRepositoryImpl(remoteSource);
}

/// Portfolio Summary Provider
/// Fetches and caches the portfolio summary data
@riverpod
Future<PortfolioSummary> dashboardPortfolioSummary(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);

  final result = await repository.getPortfolioSummary();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
}

/// Portfolio Risk Provider
/// Fetches and caches the portfolio risk analysis data
@riverpod
Future<PortfolioRisk> dashboardPortfolioRisk(Ref ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);

  final result = await repository.getPortfolioRisk();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (risk) => risk,
  );
}

const int _maxPersonalizedNewsArticles = 12;
const int _maxSymbolsToFetch = 8;

/// Personalized news for dashboard based on user portfolio.
/// Fetches news for symbols in user assets, aggregates by portfolio weight,
/// deduplicates, scores by relevance, and falls back to trending if empty.
@riverpod
Future<List<PersonalizedNewsItem>> dashboardPersonalizedNews(Ref ref) async {
  final datasource = ref.watch(newsRemoteDatasourceProvider);
  final assets = await ref.read(allAssetsProvider.future);
  final summary = await ref.read(dashboardPortfolioSummaryProvider.future);

  final totalValue = summary.totalValue;
  if (totalValue <= 0 || assets.isEmpty) {
    return _fetchTrendingAsPersonalized(datasource);
  }

  final symbolWeights = <String, double>{};
  for (final asset in assets) {
    if (asset.symbol.isNotEmpty) {
      final value = asset.totalValue ?? 0;
      if (value > 0) {
        symbolWeights[asset.symbol] =
            (symbolWeights[asset.symbol] ?? 0) + (value / totalValue) * 100;
      }
    }
  }

  final symbolsByWeight = (symbolWeights.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)))
      .map((e) => e.key)
      .take(_maxSymbolsToFetch)
      .toList();

  if (symbolsByWeight.isEmpty) {
    return _fetchTrendingAsPersonalized(datasource);
  }

  final newsBySymbol = <String, List<NewsArticle>>{};
  for (final symbol in symbolsByWeight) {
    try {
      final articles = await datasource.getBySymbol(symbol, limit: 5);
      if (articles.isNotEmpty) {
        newsBySymbol[symbol] = articles;
      }
    } catch (_) {
      // Skip symbol on error
    }
  }

  if (newsBySymbol.isEmpty) {
    return _fetchTrendingAsPersonalized(datasource);
  }

  final symbolWeightsMap = {
    for (var e in symbolWeights.entries) e.key: e.value
  };
  return _aggregateByPortfolioWeight(symbolWeightsMap, newsBySymbol);
}

Future<List<PersonalizedNewsItem>> _fetchTrendingAsPersonalized(
    NewsRemoteDatasource datasource) async {
  try {
    final articles = await datasource.getTrending(limit: 10);
    return articles
        .map((a) => PersonalizedNewsItem(
              article: a,
              relatedSymbols: [],
              level: RelevanceLevel.general,
              relevanceScore: 10,
            ))
        .toList();
  } catch (_) {
    return [];
  }
}

List<PersonalizedNewsItem> _aggregateByPortfolioWeight(
  Map<String, double> symbolWeights,
  Map<String, List<NewsArticle>> newsBySymbol,
) {
  final symbolsByWeight = (symbolWeights.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)))
      .map((e) => e.key)
      .toList();

  final result = <String, PersonalizedNewsItem>{};
  var totalSlotsUsed = 0;

  for (final symbol in symbolsByWeight) {
    if (totalSlotsUsed >= _maxPersonalizedNewsArticles) break;
    final weight = symbolWeights[symbol] ?? 0;
    final quota = (weight / 100 * _maxPersonalizedNewsArticles).ceil();
    final articles = newsBySymbol[symbol] ?? [];
    var taken = 0;

    for (final article in articles) {
      if (taken >= quota || totalSlotsUsed >= _maxPersonalizedNewsArticles) break;
      if (result.containsKey(article.id)) {
        final existing = result[article.id]!;
        final mergedSymbols =
            {...existing.relatedSymbols, symbol}.toList();
        result[article.id] = PersonalizedNewsItem(
          article: article,
          relatedSymbols: mergedSymbols,
          level: RelevanceLevel.direct,
          relevanceScore: 100,
        );
      } else {
        result[article.id] = PersonalizedNewsItem(
          article: article,
          relatedSymbols: [symbol],
          level: RelevanceLevel.direct,
          relevanceScore: 100,
        );
        taken++;
        totalSlotsUsed++;
      }
    }
  }

  final list = result.values.toList();
  list.sort((a, b) {
    final scoreCompare = b.relevanceScore.compareTo(a.relevanceScore);
    if (scoreCompare != 0) return scoreCompare;
    return b.article.publishedAt.compareTo(a.article.publishedAt);
  });
  return list.take(_maxPersonalizedNewsArticles).toList();
}

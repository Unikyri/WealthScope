import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/insights_remote_datasource.dart';
import '../../data/repositories/insights_repository_impl.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/repositories/insights_repository.dart';

part 'insights_providers.g.dart';

/// Provider for InsightsRepository
@riverpod
InsightsRepository insightsRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = InsightsRemoteDataSource(dio);
  return InsightsRepositoryImpl(dataSource);
}

/// Provider to fetch insights list
@riverpod
Future<List<InsightEntity>> insightsList(
  Ref ref, {
  String? type,
  String? category,
  String? priority,
  bool? unread,
  int? limit,
  int? offset,
}) async {
  final repository = ref.watch(insightsRepositoryProvider);
  final result = await repository.listInsights(
    type: type,
    category: category,
    priority: priority,
    unread: unread,
    limit: limit,
    offset: offset,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (insights) => insights,
  );
}

/// Provider to fetch daily briefing
@riverpod
Future<InsightEntity> dailyBriefing(Ref ref) async {
  final repository = ref.watch(insightsRepositoryProvider);
  final result = await repository.getDailyBriefing();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (insight) => insight,
  );
}

/// Provider to fetch unread count
@riverpod
Future<int> unreadInsightsCount(Ref ref) async {
  final repository = ref.watch(insightsRepositoryProvider);
  final result = await repository.getUnreadCount();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (count) => count,
  );
}

/// Provider to mark insight as read
@riverpod
class MarkInsightAsRead extends _$MarkInsightAsRead {
  @override
  FutureOr<void> build() {}

  Future<void> call(String id) async {
    state = const AsyncLoading();
    final repository = ref.read(insightsRepositoryProvider);
    final result = await repository.markAsRead(id);
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) => const AsyncData(null),
    );
    
    // Invalidate insights list to refresh
    ref.invalidate(insightsListProvider);
    ref.invalidate(unreadInsightsCountProvider);
  }
}

/// Provider to generate new insights
@riverpod
class GenerateInsights extends _$GenerateInsights {
  @override
  FutureOr<List<InsightEntity>> build() => [];

  Future<void> generate() async {
    state = const AsyncLoading();
    final repository = ref.read(insightsRepositoryProvider);
    final result = await repository.generateInsights();
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (insights) => AsyncData(insights),
    );
    
    // Invalidate insights list to refresh
    ref.invalidate(insightsListProvider);
  }
}

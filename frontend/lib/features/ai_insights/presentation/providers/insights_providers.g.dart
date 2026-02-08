// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for InsightsRepository

@ProviderFor(insightsRepository)
final insightsRepositoryProvider = InsightsRepositoryProvider._();

/// Provider for InsightsRepository

final class InsightsRepositoryProvider extends $FunctionalProvider<
    InsightsRepository,
    InsightsRepository,
    InsightsRepository> with $Provider<InsightsRepository> {
  /// Provider for InsightsRepository
  InsightsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'insightsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$insightsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InsightsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InsightsRepository create(Ref ref) {
    return insightsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightsRepository>(value),
    );
  }
}

String _$insightsRepositoryHash() =>
    r'92764bfa84a034059c88d024f85d74eb87e03458';

/// Provider to fetch insights list

@ProviderFor(insightsList)
final insightsListProvider = InsightsListFamily._();

/// Provider to fetch insights list

final class InsightsListProvider extends $FunctionalProvider<
        AsyncValue<List<InsightEntity>>,
        List<InsightEntity>,
        FutureOr<List<InsightEntity>>>
    with
        $FutureModifier<List<InsightEntity>>,
        $FutureProvider<List<InsightEntity>> {
  /// Provider to fetch insights list
  InsightsListProvider._(
      {required InsightsListFamily super.from,
      required ({
        String? type,
        String? category,
        String? priority,
        bool? unread,
        int? limit,
        int? offset,
      })
          super.argument})
      : super(
          retry: null,
          name: r'insightsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$insightsListHash();

  @override
  String toString() {
    return r'insightsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<InsightEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<InsightEntity>> create(Ref ref) {
    final argument = this.argument as ({
      String? type,
      String? category,
      String? priority,
      bool? unread,
      int? limit,
      int? offset,
    });
    return insightsList(
      ref,
      type: argument.type,
      category: argument.category,
      priority: argument.priority,
      unread: argument.unread,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InsightsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$insightsListHash() => r'c5544631c4bb303e696f9efe2dc91c1f3809cdd9';

/// Provider to fetch insights list

final class InsightsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<InsightEntity>>,
            ({
              String? type,
              String? category,
              String? priority,
              bool? unread,
              int? limit,
              int? offset,
            })> {
  InsightsListFamily._()
      : super(
          retry: null,
          name: r'insightsListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider to fetch insights list

  InsightsListProvider call({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) =>
      InsightsListProvider._(argument: (
        type: type,
        category: category,
        priority: priority,
        unread: unread,
        limit: limit,
        offset: offset,
      ), from: this);

  @override
  String toString() => r'insightsListProvider';
}

/// Provider to fetch default insights list (no parameters)
/// Simple FutureProvider without keepAlive

@ProviderFor(defaultInsightsList)
final defaultInsightsListProvider = DefaultInsightsListProvider._();

/// Provider to fetch default insights list (no parameters)
/// Simple FutureProvider without keepAlive

final class DefaultInsightsListProvider extends $FunctionalProvider<
        AsyncValue<List<InsightEntity>>,
        List<InsightEntity>,
        FutureOr<List<InsightEntity>>>
    with
        $FutureModifier<List<InsightEntity>>,
        $FutureProvider<List<InsightEntity>> {
  /// Provider to fetch default insights list (no parameters)
  /// Simple FutureProvider without keepAlive
  DefaultInsightsListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'defaultInsightsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$defaultInsightsListHash();

  @$internal
  @override
  $FutureProviderElement<List<InsightEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<InsightEntity>> create(Ref ref) {
    return defaultInsightsList(ref);
  }
}

String _$defaultInsightsListHash() =>
    r'b6ad23cccefff22983fb00f369dc29fc20122f35';

/// Provider to fetch daily briefing

@ProviderFor(dailyBriefing)
final dailyBriefingProvider = DailyBriefingProvider._();

/// Provider to fetch daily briefing

final class DailyBriefingProvider extends $FunctionalProvider<
        AsyncValue<InsightEntity>, InsightEntity, FutureOr<InsightEntity>>
    with $FutureModifier<InsightEntity>, $FutureProvider<InsightEntity> {
  /// Provider to fetch daily briefing
  DailyBriefingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dailyBriefingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dailyBriefingHash();

  @$internal
  @override
  $FutureProviderElement<InsightEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<InsightEntity> create(Ref ref) {
    return dailyBriefing(ref);
  }
}

String _$dailyBriefingHash() => r'd94c086af3c063a1c72828c45f4ea9a6d7c22857';

/// Provider to fetch unread count

@ProviderFor(unreadInsightsCount)
final unreadInsightsCountProvider = UnreadInsightsCountProvider._();

/// Provider to fetch unread count

final class UnreadInsightsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provider to fetch unread count
  UnreadInsightsCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'unreadInsightsCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$unreadInsightsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unreadInsightsCount(ref);
  }
}

String _$unreadInsightsCountHash() =>
    r'f690003646017e1181ddd8396a0965f3003d0e97';

/// Provider to mark insight as read

@ProviderFor(MarkInsightAsRead)
final markInsightAsReadProvider = MarkInsightAsReadProvider._();

/// Provider to mark insight as read
final class MarkInsightAsReadProvider
    extends $AsyncNotifierProvider<MarkInsightAsRead, void> {
  /// Provider to mark insight as read
  MarkInsightAsReadProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'markInsightAsReadProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$markInsightAsReadHash();

  @$internal
  @override
  MarkInsightAsRead create() => MarkInsightAsRead();
}

String _$markInsightAsReadHash() => r'e784a5727a6ceefadd352a807e02c09251022c56';

/// Provider to mark insight as read

abstract class _$MarkInsightAsRead extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider to generate new insights

@ProviderFor(GenerateInsights)
final generateInsightsProvider = GenerateInsightsProvider._();

/// Provider to generate new insights
final class GenerateInsightsProvider
    extends $AsyncNotifierProvider<GenerateInsights, List<InsightEntity>> {
  /// Provider to generate new insights
  GenerateInsightsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'generateInsightsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generateInsightsHash();

  @$internal
  @override
  GenerateInsights create() => GenerateInsights();
}

String _$generateInsightsHash() => r'acdead84b68be09530fa8cf3068175eaf14a3459';

/// Provider to generate new insights

abstract class _$GenerateInsights extends $AsyncNotifier<List<InsightEntity>> {
  FutureOr<List<InsightEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<InsightEntity>>, List<InsightEntity>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<InsightEntity>>, List<InsightEntity>>,
        AsyncValue<List<InsightEntity>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

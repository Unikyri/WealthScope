// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$insightsRepositoryHash() =>
    r'a049b3541c0c446f4c70a75bf623a27a98ab09d4';

/// Provider for InsightsRepository
///
/// Copied from [insightsRepository].
@ProviderFor(insightsRepository)
final insightsRepositoryProvider =
    AutoDisposeProvider<InsightsRepository>.internal(
  insightsRepository,
  name: r'insightsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$insightsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InsightsRepositoryRef = AutoDisposeProviderRef<InsightsRepository>;
String _$insightsListHash() => r'4eb6772ae5b176fcadb8080010e82e8c6dfac582';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider to fetch insights list
///
/// Copied from [insightsList].
@ProviderFor(insightsList)
const insightsListProvider = InsightsListFamily();

/// Provider to fetch insights list
///
/// Copied from [insightsList].
class InsightsListFamily extends Family<AsyncValue<List<InsightEntity>>> {
  /// Provider to fetch insights list
  ///
  /// Copied from [insightsList].
  const InsightsListFamily();

  /// Provider to fetch insights list
  ///
  /// Copied from [insightsList].
  InsightsListProvider call({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) {
    return InsightsListProvider(
      type: type,
      category: category,
      priority: priority,
      unread: unread,
      limit: limit,
      offset: offset,
    );
  }

  @override
  InsightsListProvider getProviderOverride(
    covariant InsightsListProvider provider,
  ) {
    return call(
      type: provider.type,
      category: provider.category,
      priority: provider.priority,
      unread: provider.unread,
      limit: provider.limit,
      offset: provider.offset,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'insightsListProvider';
}

/// Provider to fetch insights list
///
/// Copied from [insightsList].
class InsightsListProvider
    extends AutoDisposeFutureProvider<List<InsightEntity>> {
  /// Provider to fetch insights list
  ///
  /// Copied from [insightsList].
  InsightsListProvider({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) : this._internal(
          (ref) => insightsList(
            ref as InsightsListRef,
            type: type,
            category: category,
            priority: priority,
            unread: unread,
            limit: limit,
            offset: offset,
          ),
          from: insightsListProvider,
          name: r'insightsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$insightsListHash,
          dependencies: InsightsListFamily._dependencies,
          allTransitiveDependencies:
              InsightsListFamily._allTransitiveDependencies,
          type: type,
          category: category,
          priority: priority,
          unread: unread,
          limit: limit,
          offset: offset,
        );

  InsightsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.category,
    required this.priority,
    required this.unread,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final String? type;
  final String? category;
  final String? priority;
  final bool? unread;
  final int? limit;
  final int? offset;

  @override
  Override overrideWith(
    FutureOr<List<InsightEntity>> Function(InsightsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InsightsListProvider._internal(
        (ref) => create(ref as InsightsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        category: category,
        priority: priority,
        unread: unread,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<InsightEntity>> createElement() {
    return _InsightsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InsightsListProvider &&
        other.type == type &&
        other.category == category &&
        other.priority == priority &&
        other.unread == unread &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, priority.hashCode);
    hash = _SystemHash.combine(hash, unread.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InsightsListRef on AutoDisposeFutureProviderRef<List<InsightEntity>> {
  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `priority` of this provider.
  String? get priority;

  /// The parameter `unread` of this provider.
  bool? get unread;

  /// The parameter `limit` of this provider.
  int? get limit;

  /// The parameter `offset` of this provider.
  int? get offset;
}

class _InsightsListProviderElement
    extends AutoDisposeFutureProviderElement<List<InsightEntity>>
    with InsightsListRef {
  _InsightsListProviderElement(super.provider);

  @override
  String? get type => (origin as InsightsListProvider).type;
  @override
  String? get category => (origin as InsightsListProvider).category;
  @override
  String? get priority => (origin as InsightsListProvider).priority;
  @override
  bool? get unread => (origin as InsightsListProvider).unread;
  @override
  int? get limit => (origin as InsightsListProvider).limit;
  @override
  int? get offset => (origin as InsightsListProvider).offset;
}

String _$dailyBriefingHash() => r'5084a7646b110078fc886e4014dee6658a714a8a';

/// Provider to fetch daily briefing
///
/// Copied from [dailyBriefing].
@ProviderFor(dailyBriefing)
final dailyBriefingProvider = AutoDisposeFutureProvider<InsightEntity>.internal(
  dailyBriefing,
  name: r'dailyBriefingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyBriefingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyBriefingRef = AutoDisposeFutureProviderRef<InsightEntity>;
String _$unreadInsightsCountHash() =>
    r'24d04e5eabbe4cd78a57309d258b7f04398a3976';

/// Provider to fetch unread count
///
/// Copied from [unreadInsightsCount].
@ProviderFor(unreadInsightsCount)
final unreadInsightsCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadInsightsCount,
  name: r'unreadInsightsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadInsightsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadInsightsCountRef = AutoDisposeFutureProviderRef<int>;
String _$markInsightAsReadHash() => r'e784a5727a6ceefadd352a807e02c09251022c56';

/// Provider to mark insight as read
///
/// Copied from [MarkInsightAsRead].
@ProviderFor(MarkInsightAsRead)
final markInsightAsReadProvider =
    AutoDisposeAsyncNotifierProvider<MarkInsightAsRead, void>.internal(
  MarkInsightAsRead.new,
  name: r'markInsightAsReadProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$markInsightAsReadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarkInsightAsRead = AutoDisposeAsyncNotifier<void>;
String _$generateInsightsHash() => r'acdead84b68be09530fa8cf3068175eaf14a3459';

/// Provider to generate new insights
///
/// Copied from [GenerateInsights].
@ProviderFor(GenerateInsights)
final generateInsightsProvider = AutoDisposeAsyncNotifierProvider<
    GenerateInsights, List<InsightEntity>>.internal(
  GenerateInsights.new,
  name: r'generateInsightsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateInsightsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GenerateInsights = AutoDisposeAsyncNotifier<List<InsightEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

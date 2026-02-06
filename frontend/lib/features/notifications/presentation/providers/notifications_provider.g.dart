// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

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
String _$insightsListHash() => r'700c848205e934a2787b5d1f95d25a486c1146c6';

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

/// Provider to fetch insights list with optional filters
///
/// Copied from [insightsList].
@ProviderFor(insightsList)
const insightsListProvider = InsightsListFamily();

/// Provider to fetch insights list with optional filters
///
/// Copied from [insightsList].
class InsightsListFamily extends Family<AsyncValue<InsightListEntity>> {
  /// Provider to fetch insights list with optional filters
  ///
  /// Copied from [insightsList].
  const InsightsListFamily();

  /// Provider to fetch insights list with optional filters
  ///
  /// Copied from [insightsList].
  InsightsListProvider call({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int limit = 20,
    int offset = 0,
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

/// Provider to fetch insights list with optional filters
///
/// Copied from [insightsList].
class InsightsListProvider
    extends AutoDisposeFutureProvider<InsightListEntity> {
  /// Provider to fetch insights list with optional filters
  ///
  /// Copied from [insightsList].
  InsightsListProvider({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int limit = 20,
    int offset = 0,
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
  final int limit;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<InsightListEntity> Function(InsightsListRef provider) create,
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
  AutoDisposeFutureProviderElement<InsightListEntity> createElement() {
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
mixin InsightsListRef on AutoDisposeFutureProviderRef<InsightListEntity> {
  /// The parameter `type` of this provider.
  String? get type;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `priority` of this provider.
  String? get priority;

  /// The parameter `unread` of this provider.
  bool? get unread;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _InsightsListProviderElement
    extends AutoDisposeFutureProviderElement<InsightListEntity>
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
  int get limit => (origin as InsightsListProvider).limit;
  @override
  int get offset => (origin as InsightsListProvider).offset;
}

String _$dailyBriefingHash() => r'247d911cbabe0de3dd77c6859aaa43cfe89a56f1';

/// Provider to get daily briefing
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
    r'beccb1ef9ec4fb51321052a8ee9be638ec071afa';

/// Provider for unread count
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
String _$notificationsHash() => r'973a3a4346756b33bc104f4cf8bd9e90562fddab';

/// Backwards compatibility: Convert insights to notifications format
///
/// Copied from [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeFutureProvider<List<AppNotification>>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsRef = AutoDisposeFutureProviderRef<List<AppNotification>>;
String _$unreadNotificationsCountHash() =>
    r'011be3fdb4818724bea18013d4010b3467c2eb0b';

/// Provider for unread notifications count (backwards compatibility)
///
/// Copied from [unreadNotificationsCount].
@ProviderFor(unreadNotificationsCount)
final unreadNotificationsCountProvider =
    AutoDisposeFutureProvider<int>.internal(
  unreadNotificationsCount,
  name: r'unreadNotificationsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnreadNotificationsCountRef = AutoDisposeFutureProviderRef<int>;
String _$markInsightAsReadHash() => r'6c641eeb131f42fa93bd63e36201905f72057c6f';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

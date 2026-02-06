// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conversationsRepositoryHash() =>
    r'd605e9d42ad2e103fc774c7a27884ad85d1d1268';

/// Provider for ConversationsRepository
///
/// Copied from [conversationsRepository].
@ProviderFor(conversationsRepository)
final conversationsRepositoryProvider =
    AutoDisposeProvider<ConversationsRepository>.internal(
  conversationsRepository,
  name: r'conversationsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conversationsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConversationsRepositoryRef
    = AutoDisposeProviderRef<ConversationsRepository>;
String _$conversationsListHash() => r'8e442ba9ce3cee301733e2b648fdd57dfb17b8db';

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

/// Provider to list conversations
///
/// Copied from [conversationsList].
@ProviderFor(conversationsList)
const conversationsListProvider = ConversationsListFamily();

/// Provider to list conversations
///
/// Copied from [conversationsList].
class ConversationsListFamily
    extends Family<AsyncValue<List<ConversationEntity>>> {
  /// Provider to list conversations
  ///
  /// Copied from [conversationsList].
  const ConversationsListFamily();

  /// Provider to list conversations
  ///
  /// Copied from [conversationsList].
  ConversationsListProvider call({
    int? limit,
    int? offset,
  }) {
    return ConversationsListProvider(
      limit: limit,
      offset: offset,
    );
  }

  @override
  ConversationsListProvider getProviderOverride(
    covariant ConversationsListProvider provider,
  ) {
    return call(
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
  String? get name => r'conversationsListProvider';
}

/// Provider to list conversations
///
/// Copied from [conversationsList].
class ConversationsListProvider
    extends AutoDisposeFutureProvider<List<ConversationEntity>> {
  /// Provider to list conversations
  ///
  /// Copied from [conversationsList].
  ConversationsListProvider({
    int? limit,
    int? offset,
  }) : this._internal(
          (ref) => conversationsList(
            ref as ConversationsListRef,
            limit: limit,
            offset: offset,
          ),
          from: conversationsListProvider,
          name: r'conversationsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationsListHash,
          dependencies: ConversationsListFamily._dependencies,
          allTransitiveDependencies:
              ConversationsListFamily._allTransitiveDependencies,
          limit: limit,
          offset: offset,
        );

  ConversationsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int? limit;
  final int? offset;

  @override
  Override overrideWith(
    FutureOr<List<ConversationEntity>> Function(ConversationsListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationsListProvider._internal(
        (ref) => create(ref as ConversationsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ConversationEntity>> createElement() {
    return _ConversationsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationsListProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationsListRef
    on AutoDisposeFutureProviderRef<List<ConversationEntity>> {
  /// The parameter `limit` of this provider.
  int? get limit;

  /// The parameter `offset` of this provider.
  int? get offset;
}

class _ConversationsListProviderElement
    extends AutoDisposeFutureProviderElement<List<ConversationEntity>>
    with ConversationsListRef {
  _ConversationsListProviderElement(super.provider);

  @override
  int? get limit => (origin as ConversationsListProvider).limit;
  @override
  int? get offset => (origin as ConversationsListProvider).offset;
}

String _$conversationHash() => r'9e2e6b1ce2a8972a2f3bda132dcc572eb56a82ce';

/// Provider to get conversation with messages
///
/// Copied from [conversation].
@ProviderFor(conversation)
const conversationProvider = ConversationFamily();

/// Provider to get conversation with messages
///
/// Copied from [conversation].
class ConversationFamily
    extends Family<AsyncValue<ConversationWithMessagesEntity>> {
  /// Provider to get conversation with messages
  ///
  /// Copied from [conversation].
  const ConversationFamily();

  /// Provider to get conversation with messages
  ///
  /// Copied from [conversation].
  ConversationProvider call(
    String id,
  ) {
    return ConversationProvider(
      id,
    );
  }

  @override
  ConversationProvider getProviderOverride(
    covariant ConversationProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'conversationProvider';
}

/// Provider to get conversation with messages
///
/// Copied from [conversation].
class ConversationProvider
    extends AutoDisposeFutureProvider<ConversationWithMessagesEntity> {
  /// Provider to get conversation with messages
  ///
  /// Copied from [conversation].
  ConversationProvider(
    String id,
  ) : this._internal(
          (ref) => conversation(
            ref as ConversationRef,
            id,
          ),
          from: conversationProvider,
          name: r'conversationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$conversationHash,
          dependencies: ConversationFamily._dependencies,
          allTransitiveDependencies:
              ConversationFamily._allTransitiveDependencies,
          id: id,
        );

  ConversationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ConversationWithMessagesEntity> Function(ConversationRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConversationProvider._internal(
        (ref) => create(ref as ConversationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ConversationWithMessagesEntity>
      createElement() {
    return _ConversationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConversationRef
    on AutoDisposeFutureProviderRef<ConversationWithMessagesEntity> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ConversationProviderElement
    extends AutoDisposeFutureProviderElement<ConversationWithMessagesEntity>
    with ConversationRef {
  _ConversationProviderElement(super.provider);

  @override
  String get id => (origin as ConversationProvider).id;
}

String _$welcomeMessageHash() => r'597e3d5c87432db2092a3076eba08058f68bedb7';

/// Provider to get welcome message
///
/// Copied from [welcomeMessage].
@ProviderFor(welcomeMessage)
final welcomeMessageProvider =
    AutoDisposeFutureProvider<WelcomeMessageEntity>.internal(
  welcomeMessage,
  name: r'welcomeMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$welcomeMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WelcomeMessageRef = AutoDisposeFutureProviderRef<WelcomeMessageEntity>;
String _$createConversationHash() =>
    r'a3ff9a088ffaa164b6697c7b57eafff5e1f4642b';

/// Provider to create conversation
///
/// Copied from [CreateConversation].
@ProviderFor(CreateConversation)
final createConversationProvider = AutoDisposeAsyncNotifierProvider<
    CreateConversation, ConversationEntity?>.internal(
  CreateConversation.new,
  name: r'createConversationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createConversationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateConversation = AutoDisposeAsyncNotifier<ConversationEntity?>;
String _$updateConversationHash() =>
    r'5a44edede5bc4b2e812771a2d5ac8f089ff0cf91';

/// Provider to update conversation
///
/// Copied from [UpdateConversation].
@ProviderFor(UpdateConversation)
final updateConversationProvider =
    AutoDisposeAsyncNotifierProvider<UpdateConversation, void>.internal(
  UpdateConversation.new,
  name: r'updateConversationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateConversationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateConversation = AutoDisposeAsyncNotifier<void>;
String _$deleteConversationHash() =>
    r'8bf7999f9c23dbc72e31d183050c4cb8b50133d9';

/// Provider to delete conversation
///
/// Copied from [DeleteConversation].
@ProviderFor(DeleteConversation)
final deleteConversationProvider =
    AutoDisposeAsyncNotifierProvider<DeleteConversation, void>.internal(
  DeleteConversation.new,
  name: r'deleteConversationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteConversationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DeleteConversation = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

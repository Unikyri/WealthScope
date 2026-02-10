// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for ConversationsRepository

@ProviderFor(conversationsRepository)
final conversationsRepositoryProvider = ConversationsRepositoryProvider._();

/// Provider for ConversationsRepository

final class ConversationsRepositoryProvider extends $FunctionalProvider<
    ConversationsRepository,
    ConversationsRepository,
    ConversationsRepository> with $Provider<ConversationsRepository> {
  /// Provider for ConversationsRepository
  ConversationsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'conversationsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$conversationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConversationsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConversationsRepository create(Ref ref) {
    return conversationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationsRepository>(value),
    );
  }
}

String _$conversationsRepositoryHash() =>
    r'1671bf563fd134716e6b3b71e51a093b6aa4df02';

/// Provider to list conversations

@ProviderFor(conversationsList)
final conversationsListProvider = ConversationsListFamily._();

/// Provider to list conversations

final class ConversationsListProvider extends $FunctionalProvider<
        AsyncValue<List<ConversationEntity>>,
        List<ConversationEntity>,
        FutureOr<List<ConversationEntity>>>
    with
        $FutureModifier<List<ConversationEntity>>,
        $FutureProvider<List<ConversationEntity>> {
  /// Provider to list conversations
  ConversationsListProvider._(
      {required ConversationsListFamily super.from,
      required ({
        int? limit,
        int? offset,
      })
          super.argument})
      : super(
          retry: null,
          name: r'conversationsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$conversationsListHash();

  @override
  String toString() {
    return r'conversationsListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ConversationEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ConversationEntity>> create(Ref ref) {
    final argument = this.argument as ({
      int? limit,
      int? offset,
    });
    return conversationsList(
      ref,
      limit: argument.limit,
      offset: argument.offset,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationsListHash() => r'f6087def88013698921090136d1eb86364a9f581';

/// Provider to list conversations

final class ConversationsListFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ConversationEntity>>,
            ({
              int? limit,
              int? offset,
            })> {
  ConversationsListFamily._()
      : super(
          retry: null,
          name: r'conversationsListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider to list conversations

  ConversationsListProvider call({
    int? limit,
    int? offset,
  }) =>
      ConversationsListProvider._(argument: (
        limit: limit,
        offset: offset,
      ), from: this);

  @override
  String toString() => r'conversationsListProvider';
}

/// Provider to get conversation with messages

@ProviderFor(conversation)
final conversationProvider = ConversationFamily._();

/// Provider to get conversation with messages

final class ConversationProvider extends $FunctionalProvider<
        AsyncValue<ConversationWithMessagesEntity>,
        ConversationWithMessagesEntity,
        FutureOr<ConversationWithMessagesEntity>>
    with
        $FutureModifier<ConversationWithMessagesEntity>,
        $FutureProvider<ConversationWithMessagesEntity> {
  /// Provider to get conversation with messages
  ConversationProvider._(
      {required ConversationFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'conversationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$conversationHash();

  @override
  String toString() {
    return r'conversationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConversationWithMessagesEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ConversationWithMessagesEntity> create(Ref ref) {
    final argument = this.argument as String;
    return conversation(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationHash() => r'1859aae0b3e669a1e95f1e73adc37e338d297b0d';

/// Provider to get conversation with messages

final class ConversationFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<ConversationWithMessagesEntity>,
            String> {
  ConversationFamily._()
      : super(
          retry: null,
          name: r'conversationProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider to get conversation with messages

  ConversationProvider call(
    String id,
  ) =>
      ConversationProvider._(argument: id, from: this);

  @override
  String toString() => r'conversationProvider';
}

/// Provider to get welcome message

@ProviderFor(welcomeMessage)
final welcomeMessageProvider = WelcomeMessageProvider._();

/// Provider to get welcome message

final class WelcomeMessageProvider extends $FunctionalProvider<
        AsyncValue<WelcomeMessageEntity>,
        WelcomeMessageEntity,
        FutureOr<WelcomeMessageEntity>>
    with
        $FutureModifier<WelcomeMessageEntity>,
        $FutureProvider<WelcomeMessageEntity> {
  /// Provider to get welcome message
  WelcomeMessageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'welcomeMessageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$welcomeMessageHash();

  @$internal
  @override
  $FutureProviderElement<WelcomeMessageEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WelcomeMessageEntity> create(Ref ref) {
    return welcomeMessage(ref);
  }
}

String _$welcomeMessageHash() => r'0cffbb2f3b72af187c3eab524749b82645bf2ca4';

/// Provider to create conversation

@ProviderFor(CreateConversation)
final createConversationProvider = CreateConversationProvider._();

/// Provider to create conversation
final class CreateConversationProvider
    extends $AsyncNotifierProvider<CreateConversation, ConversationEntity?> {
  /// Provider to create conversation
  CreateConversationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'createConversationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$createConversationHash();

  @$internal
  @override
  CreateConversation create() => CreateConversation();
}

String _$createConversationHash() =>
    r'a3ff9a088ffaa164b6697c7b57eafff5e1f4642b';

/// Provider to create conversation

abstract class _$CreateConversation
    extends $AsyncNotifier<ConversationEntity?> {
  FutureOr<ConversationEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ConversationEntity?>, ConversationEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ConversationEntity?>, ConversationEntity?>,
        AsyncValue<ConversationEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider to update conversation

@ProviderFor(UpdateConversation)
final updateConversationProvider = UpdateConversationProvider._();

/// Provider to update conversation
final class UpdateConversationProvider
    extends $AsyncNotifierProvider<UpdateConversation, void> {
  /// Provider to update conversation
  UpdateConversationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateConversationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateConversationHash();

  @$internal
  @override
  UpdateConversation create() => UpdateConversation();
}

String _$updateConversationHash() =>
    r'5a44edede5bc4b2e812771a2d5ac8f089ff0cf91';

/// Provider to update conversation

abstract class _$UpdateConversation extends $AsyncNotifier<void> {
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

/// Provider to delete conversation

@ProviderFor(DeleteConversation)
final deleteConversationProvider = DeleteConversationProvider._();

/// Provider to delete conversation
final class DeleteConversationProvider
    extends $AsyncNotifierProvider<DeleteConversation, void> {
  /// Provider to delete conversation
  DeleteConversationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'deleteConversationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$deleteConversationHash();

  @$internal
  @override
  DeleteConversation create() => DeleteConversation();
}

String _$deleteConversationHash() =>
    r'8bf7999f9c23dbc72e31d183050c4cb8b50133d9';

/// Provider to delete conversation

abstract class _$DeleteConversation extends $AsyncNotifier<void> {
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

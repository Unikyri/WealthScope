// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiRepository)
final aiRepositoryProvider = AiRepositoryProvider._();

final class AiRepositoryProvider
    extends $FunctionalProvider<AIRepository, AIRepository, AIRepository>
    with $Provider<AIRepository> {
  AiRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AIRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AIRepository create(Ref ref) {
    return aiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AIRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AIRepository>(value),
    );
  }
}

String _$aiRepositoryHash() => r'5cbd2f7c703f33ebd8f2223d61343ae4f35a76b1';

@ProviderFor(AiChat)
final aiChatProvider = AiChatProvider._();

final class AiChatProvider
    extends $AsyncNotifierProvider<AiChat, List<ChatMessage>> {
  AiChatProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiChatProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiChatHash();

  @$internal
  @override
  AiChat create() => AiChat();
}

String _$aiChatHash() => r'0f0dc7bb8d50ec23941fc7ecba739943dc99ebab';

abstract class _$AiChat extends $AsyncNotifier<List<ChatMessage>> {
  FutureOr<List<ChatMessage>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ChatMessage>>, List<ChatMessage>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<ChatMessage>>, List<ChatMessage>>,
        AsyncValue<List<ChatMessage>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AiIsTyping)
final aiIsTypingProvider = AiIsTypingProvider._();

final class AiIsTypingProvider extends $NotifierProvider<AiIsTyping, bool> {
  AiIsTypingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiIsTypingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiIsTypingHash();

  @$internal
  @override
  AiIsTyping create() => AiIsTyping();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$aiIsTypingHash() => r'944da31eff73414aed4240628422fecf7ae0bdd2';

abstract class _$AiIsTyping extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiRepositoryHash() => r'381ee9a0491c03059b417a6b365c4596f4a0d572';

/// See also [aiRepository].
@ProviderFor(aiRepository)
final aiRepositoryProvider = AutoDisposeProvider<AIRepository>.internal(
  aiRepository,
  name: r'aiRepositoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiRepositoryRef = AutoDisposeProviderRef<AIRepository>;
String _$aiChatHash() => r'2d7e3b786b8b59fbad514241edd6f91adf29a3d8';

/// See also [AiChat].
@ProviderFor(AiChat)
final aiChatProvider =
    AutoDisposeAsyncNotifierProvider<AiChat, List<ChatMessage>>.internal(
  AiChat.new,
  name: r'aiChatProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiChatHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiChat = AutoDisposeAsyncNotifier<List<ChatMessage>>;
String _$aiIsTypingHash() => r'944da31eff73414aed4240628422fecf7ae0bdd2';

/// See also [AiIsTyping].
@ProviderFor(AiIsTyping)
final aiIsTypingProvider =
    AutoDisposeNotifierProvider<AiIsTyping, bool>.internal(
  AiIsTyping.new,
  name: r'aiIsTypingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiIsTypingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiIsTyping = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

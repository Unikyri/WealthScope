import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/conversations_remote_datasource.dart';
import '../../data/repositories/conversations_repository_impl.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/conversations_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'conversations_providers.g.dart';

/// Provider for ConversationsRepository
@riverpod
ConversationsRepository conversationsRepository(
  Ref ref,
) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = ConversationsRemoteDataSource(dio);
  return ConversationsRepositoryImpl(dataSource);
}

/// Provider to list conversations
@riverpod
Future<List<ConversationEntity>> conversationsList(
  Ref ref, {
  int? limit,
  int? offset,
}) async {
  final repository = ref.watch(conversationsRepositoryProvider);
  return await repository.listConversations(
    limit: limit,
    offset: offset,
  );
}

/// Provider to get conversation with messages
@riverpod
Future<ConversationWithMessagesEntity> conversation(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(conversationsRepositoryProvider);
  return await repository.getConversation(id);
}

/// Provider to get welcome message
@riverpod
Future<WelcomeMessageEntity> welcomeMessage(Ref ref) async {
  final repository = ref.watch(conversationsRepositoryProvider);
  return await repository.getWelcomeMessage();
}

/// Provider to create conversation
@riverpod
class CreateConversation extends _$CreateConversation {
  @override
  FutureOr<ConversationEntity?> build() => null;

  Future<ConversationEntity> create(String title) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(conversationsRepositoryProvider);
      final conversation = await repository.createConversation(title: title);
      state = AsyncData(conversation);
      
      // Invalidate list to refresh
      ref.invalidate(conversationsListProvider);
      
      return conversation;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Provider to update conversation
@riverpod
class UpdateConversation extends _$UpdateConversation {
  @override
  FutureOr<void> build() {}

  Future<void> updateTitle({required String id, required String title}) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(conversationsRepositoryProvider);
      await repository.updateConversation(id: id, title: title);
      state = const AsyncData(null);
      
      // Invalidate list and specific conversation to refresh
      ref.invalidate(conversationsListProvider);
      ref.invalidate(conversationProvider(id));
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

/// Provider to delete conversation
@riverpod
class DeleteConversation extends _$DeleteConversation {
  @override
  FutureOr<void> build() {}

  Future<void> delete(String id) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(conversationsRepositoryProvider);
      await repository.deleteConversation(id);
      state = const AsyncData(null);
      
      // Invalidate list to refresh
      ref.invalidate(conversationsListProvider);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
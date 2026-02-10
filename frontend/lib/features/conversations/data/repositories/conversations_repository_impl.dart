import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/conversations_repository.dart';
import '../datasources/conversations_remote_datasource.dart';
import '../models/conversation_dto.dart';

/// Implementation of ConversationsRepository
class ConversationsRepositoryImpl implements ConversationsRepository {
  final ConversationsRemoteDataSource _remoteDataSource;

  ConversationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ConversationEntity>> listConversations({
    int? limit,
    int? offset,
  }) async {
    try {
      final dto = await _remoteDataSource.listConversations(
        limit: limit,
        offset: offset,
      );
      return dto.conversations.map((c) => c.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to list conversations: ${e.toString()}');
    }
  }

  @override
  Future<ConversationEntity> createConversation({
    required String title,
  }) async {
    try {
      final dto = await _remoteDataSource.createConversation(title: title);
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to create conversation: ${e.toString()}');
    }
  }

  @override
  Future<ConversationWithMessagesEntity> getConversation(
    String id,
  ) async {
    try {
      final dto = await _remoteDataSource.getConversation(id);
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to get conversation: ${e.toString()}');
    }
  }

  @override
  Future<void> updateConversation({
    required String id,
    required String title,
  }) async {
    try {
      await _remoteDataSource.updateConversation(id: id, title: title);
    } catch (e) {
      throw Exception('Failed to update conversation: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteConversation(String id) async {
    try {
      await _remoteDataSource.deleteConversation(id);
    } catch (e) {
      throw Exception('Failed to delete conversation: ${e.toString()}');
    }
  }

  @override
  Future<WelcomeMessageEntity> getWelcomeMessage() async {
    try {
      final dto = await _remoteDataSource.getWelcomeMessage();
      return dto.toDomain();
    } catch (e) {
      throw Exception('Failed to get welcome message: ${e.toString()}');
    }
  }
}

import '../entities/conversation_entity.dart';

/// Abstract Repository for AI Conversations
abstract class ConversationsRepository {
  /// List all conversations
  Future<List<ConversationEntity>> listConversations({
    int? limit,
    int? offset,
  });

  /// Create a new conversation
  Future<ConversationEntity> createConversation({
    required String title,
  });

  /// Get conversation with all messages
  Future<ConversationWithMessagesEntity> getConversation(
    String id,
  );

  /// Update conversation title
  Future<void> updateConversation({
    required String id,
    required String title,
  });

  /// Delete conversation
  Future<void> deleteConversation(String id);

  /// Get welcome message and conversation starters
  Future<WelcomeMessageEntity> getWelcomeMessage();
}

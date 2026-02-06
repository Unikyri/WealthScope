/// Domain Entity for AI Conversation
class ConversationEntity {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Domain Entity for Conversation with Messages
class ConversationWithMessagesEntity {
  final ConversationEntity conversation;
  final List<MessageEntity> messages;

  const ConversationWithMessagesEntity({
    required this.conversation,
    required this.messages,
  });
}

/// Domain Entity for Message
class MessageEntity {
  final String id;
  final String conversationId;
  final String role;
  final String content;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
}

/// Domain Entity for Welcome Message
class WelcomeMessageEntity {
  final String message;
  final List<String> conversationStarters;

  const WelcomeMessageEntity({
    required this.message,
    required this.conversationStarters,
  });
}

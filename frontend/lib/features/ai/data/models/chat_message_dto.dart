import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';

part 'chat_message_dto.freezed.dart';
part 'chat_message_dto.g.dart';

@freezed
class ChatMessageDTO with _$ChatMessageDTO {
  const ChatMessageDTO._();
  
  const factory ChatMessageDTO({
    required String id,
    required String content,
    required String role,
    required String timestamp,
    @Default(false) bool isError,
  }) = _ChatMessageDTO;

  factory ChatMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDTOFromJson(json);

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      content: content,
      role: _roleFromString(role),
      timestamp: DateTime.parse(timestamp),
      isError: isError,
    );
  }

  static MessageRole _roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.assistant;
    }
  }
}

extension ChatMessageToDTO on ChatMessage {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
    };
  }
}

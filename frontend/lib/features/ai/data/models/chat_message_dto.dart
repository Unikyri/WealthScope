import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';

part 'chat_message_dto.freezed.dart';
part 'chat_message_dto.g.dart';

@freezed
class ChatMessageDTO with _$ChatMessageDTO {
  const ChatMessageDTO._();
  
  const factory ChatMessageDTO({
    required String id,
    required String role,
    required String content,
    required String createdAt,
  }) = _ChatMessageDTO;

  factory ChatMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDTOFromJson(json);

  ChatMessage toDomain() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

extension ChatMessageToDTO on ChatMessage {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

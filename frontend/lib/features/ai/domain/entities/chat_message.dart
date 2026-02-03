import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required MessageRole role,
    required DateTime timestamp,
    @Default(false) bool isError,
  }) = _ChatMessage;
}

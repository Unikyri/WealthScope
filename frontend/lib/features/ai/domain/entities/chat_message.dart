import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum MessageRole {
  user,
  assistant,
  system,
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String role, // 'user' or 'assistant'
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
abstract class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    required ChatMessage userMessage,
    required ChatMessage aiMessage,
    required String conversationId,
    int? tokensUsed,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
}

@freezed
abstract class InsightsResponse with _$InsightsResponse {
  const factory InsightsResponse({
    required String summary,
    required List<String> keyPoints,
    String? briefing,
    double? sentimentScore,
    String? sentimentTrend,
  }) = _InsightsResponse;

  factory InsightsResponse.fromJson(Map<String, dynamic> json) =>
      _$InsightsResponseFromJson(json);
}

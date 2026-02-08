// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };

_ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) =>
    _ChatResponse(
      userMessage:
          ChatMessage.fromJson(json['user_message'] as Map<String, dynamic>),
      aiMessage:
          ChatMessage.fromJson(json['ai_message'] as Map<String, dynamic>),
      conversationId: json['conversation_id'] as String,
      tokensUsed: (json['tokens_used'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatResponseToJson(_ChatResponse instance) =>
    <String, dynamic>{
      'user_message': instance.userMessage.toJson(),
      'ai_message': instance.aiMessage.toJson(),
      'conversation_id': instance.conversationId,
      'tokens_used': instance.tokensUsed,
    };

_InsightsResponse _$InsightsResponseFromJson(Map<String, dynamic> json) =>
    _InsightsResponse(
      summary: json['summary'] as String,
      keyPoints: (json['key_points'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      briefing: json['briefing'] as String?,
    );

Map<String, dynamic> _$InsightsResponseToJson(_InsightsResponse instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'key_points': instance.keyPoints,
      'briefing': instance.briefing,
    };

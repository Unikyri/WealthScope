// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$ChatResponseImpl _$$ChatResponseImplFromJson(Map<String, dynamic> json) =>
    _$ChatResponseImpl(
      message: ChatMessage.fromJson(json['message'] as Map<String, dynamic>),
      conversationId: json['conversation_id'] as String,
      tokensUsed: (json['tokens_used'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ChatResponseImplToJson(_$ChatResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message.toJson(),
      'conversation_id': instance.conversationId,
      'tokens_used': instance.tokensUsed,
    };

_$InsightsResponseImpl _$$InsightsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InsightsResponseImpl(
      summary: json['summary'] as String,
      keyPoints: (json['key_points'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      briefing: json['briefing'] as String?,
    );

Map<String, dynamic> _$$InsightsResponseImplToJson(
        _$InsightsResponseImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'key_points': instance.keyPoints,
      'briefing': instance.briefing,
    };

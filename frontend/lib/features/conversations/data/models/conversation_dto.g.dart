// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationDtoImpl _$$ConversationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$ConversationDtoImplToJson(
        _$ConversationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$MessageDtoImpl _$$MessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessageDtoImpl(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$MessageDtoImplToJson(_$MessageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

_$ConversationWithMessagesDtoImpl _$$ConversationWithMessagesDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationWithMessagesDtoImpl(
      conversation: ConversationDto.fromJson(
          json['conversation'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConversationWithMessagesDtoImplToJson(
        _$ConversationWithMessagesDtoImpl instance) =>
    <String, dynamic>{
      'conversation': instance.conversation.toJson(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

_$ConversationListDtoImpl _$$ConversationListDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationListDtoImpl(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$$ConversationListDtoImplToJson(
        _$ConversationListDtoImpl instance) =>
    <String, dynamic>{
      'conversations': instance.conversations.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

_$WelcomeMessageDtoImpl _$$WelcomeMessageDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WelcomeMessageDtoImpl(
      message: json['message'] as String,
      conversationStarters: (json['conversation_starters'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$WelcomeMessageDtoImplToJson(
        _$WelcomeMessageDtoImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversation_starters': instance.conversationStarters,
    };

_$CreateConversationRequestDtoImpl _$$CreateConversationRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateConversationRequestDtoImpl(
      title: json['title'] as String,
    );

Map<String, dynamic> _$$CreateConversationRequestDtoImplToJson(
        _$CreateConversationRequestDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

_$UpdateConversationRequestDtoImpl _$$UpdateConversationRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateConversationRequestDtoImpl(
      title: json['title'] as String,
    );

Map<String, dynamic> _$$UpdateConversationRequestDtoImplToJson(
        _$UpdateConversationRequestDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

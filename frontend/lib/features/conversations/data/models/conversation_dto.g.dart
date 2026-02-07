// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ConversationDtoToJson(_ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

_ConversationWithMessagesDto _$ConversationWithMessagesDtoFromJson(
        Map<String, dynamic> json) =>
    _ConversationWithMessagesDto(
      conversation: ConversationDto.fromJson(
          json['conversation'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConversationWithMessagesDtoToJson(
        _ConversationWithMessagesDto instance) =>
    <String, dynamic>{
      'conversation': instance.conversation.toJson(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

_ConversationListDto _$ConversationListDtoFromJson(Map<String, dynamic> json) =>
    _ConversationListDto(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationListDtoToJson(
        _ConversationListDto instance) =>
    <String, dynamic>{
      'conversations': instance.conversations.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
    };

_WelcomeMessageDto _$WelcomeMessageDtoFromJson(Map<String, dynamic> json) =>
    _WelcomeMessageDto(
      message: json['message'] as String,
      conversationStarters: (json['conversation_starters'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WelcomeMessageDtoToJson(_WelcomeMessageDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'conversation_starters': instance.conversationStarters,
    };

_CreateConversationRequestDto _$CreateConversationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _CreateConversationRequestDto(
      title: json['title'] as String,
    );

Map<String, dynamic> _$CreateConversationRequestDtoToJson(
        _CreateConversationRequestDto instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

_UpdateConversationRequestDto _$UpdateConversationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _UpdateConversationRequestDto(
      title: json['title'] as String,
    );

Map<String, dynamic> _$UpdateConversationRequestDtoToJson(
        _UpdateConversationRequestDto instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

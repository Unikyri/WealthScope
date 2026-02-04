// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageDTOImpl _$$ChatMessageDTOImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageDTOImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$ChatMessageDTOImplToJson(
        _$ChatMessageDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageDTOImpl _$$ChatMessageDTOImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageDTOImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      role: json['role'] as String,
      timestamp: json['timestamp'] as String,
      isError: json['is_error'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageDTOImplToJson(
        _$ChatMessageDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'role': instance.role,
      'timestamp': instance.timestamp,
      'is_error': instance.isError,
    };

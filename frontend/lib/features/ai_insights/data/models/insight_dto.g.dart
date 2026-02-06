// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsightDtoImpl _$$InsightDtoImplFromJson(Map<String, dynamic> json) =>
    _$InsightDtoImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      actionItems: (json['action_items'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      relatedSymbols: (json['related_symbols'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$InsightDtoImplToJson(_$InsightDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'category': instance.category,
      'priority': instance.priority,
      'title': instance.title,
      'content': instance.content,
      'action_items': instance.actionItems,
      'related_symbols': instance.relatedSymbols,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InsightDto _$InsightDtoFromJson(Map<String, dynamic> json) => _InsightDto(
      id: json['id'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      actionItems: (json['action_items'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      relatedSymbols: (json['related_symbols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$InsightDtoToJson(_InsightDto instance) =>
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

_InsightListDto _$InsightListDtoFromJson(Map<String, dynamic> json) =>
    _InsightListDto(
      insights: (json['insights'] as List<dynamic>)
          .map((e) => InsightDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$InsightListDtoToJson(_InsightListDto instance) =>
    <String, dynamic>{
      'insights': instance.insights.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'limit': instance.limit,
      'offset': instance.offset,
      'unread_count': instance.unreadCount,
    };

_UnreadCountDto _$UnreadCountDtoFromJson(Map<String, dynamic> json) =>
    _UnreadCountDto(
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$UnreadCountDtoToJson(_UnreadCountDto instance) =>
    <String, dynamic>{
      'count': instance.count,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      success: json['success'] as bool,
      data: fromJsonT(json['data']),
      meta: json['meta'] == null
          ? null
          : ResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': toJsonT(instance.data),
      'meta': instance.meta?.toJson(),
    };

PaginatedApiResponse<T> _$PaginatedApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PaginatedApiResponse<T>(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
      meta: json['meta'] == null
          ? null
          : PaginatedMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedApiResponseToJson<T>(
  PaginatedApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.map(toJsonT).toList(),
      'meta': instance.meta?.toJson(),
    };

ResponseMeta _$ResponseMetaFromJson(Map<String, dynamic> json) => ResponseMeta(
      requestId: json['request_id'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$ResponseMetaToJson(ResponseMeta instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'timestamp': instance.timestamp,
    };

PaginatedMeta _$PaginatedMetaFromJson(Map<String, dynamic> json) =>
    PaginatedMeta(
      requestId: json['request_id'] as String,
      timestamp: json['timestamp'] as String,
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedMetaToJson(PaginatedMeta instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'timestamp': instance.timestamp,
      'pagination': instance.pagination.toJson(),
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      page: (json['page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'total': instance.total,
      'total_pages': instance.totalPages,
    };

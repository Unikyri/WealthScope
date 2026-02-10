// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    ApiErrorResponse(
      success: json['success'] as bool,
      error: ApiError.fromJson(json['error'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : ErrorMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiErrorResponseToJson(ApiErrorResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error.toJson(),
      'meta': instance.meta?.toJson(),
    };

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
    };

ErrorMeta _$ErrorMetaFromJson(Map<String, dynamic> json) => ErrorMeta(
      requestId: json['request_id'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$ErrorMetaToJson(ErrorMeta instance) => <String, dynamic>{
      'request_id': instance.requestId,
      'timestamp': instance.timestamp,
    };

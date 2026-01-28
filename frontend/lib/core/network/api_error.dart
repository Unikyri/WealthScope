import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

/// Standard API Error Response
/// Matches the backend error format from API documentation
@JsonSerializable()
class ApiErrorResponse {
  const ApiErrorResponse({
    required this.success,
    required this.error,
    this.meta,
  });

  final bool success;
  final ApiError error;
  final ErrorMeta? meta;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);
}

/// Error details
@JsonSerializable()
class ApiError {
  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final Map<String, dynamic>? details;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

/// Error metadata
@JsonSerializable()
class ErrorMeta {
  const ErrorMeta({
    required this.requestId,
    required this.timestamp,
  });

  @JsonKey(name: 'request_id')
  final String requestId;
  final String timestamp;

  factory ErrorMeta.fromJson(Map<String, dynamic> json) =>
      _$ErrorMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMetaToJson(this);
}

/// Error codes from API documentation
class ApiErrorCode {
  static const String validationError = 'VALIDATION_ERROR';
  static const String authenticationRequired = 'AUTHENTICATION_REQUIRED';
  static const String permissionDenied = 'PERMISSION_DENIED';
  static const String notFound = 'NOT_FOUND';
  static const String businessLogicError = 'BUSINESS_LOGIC_ERROR';
  static const String rateLimitExceeded = 'RATE_LIMIT_EXCEEDED';
  static const String internalServerError = 'INTERNAL_SERVER_ERROR';
  static const String serviceUnavailable = 'SERVICE_UNAVAILABLE';
}

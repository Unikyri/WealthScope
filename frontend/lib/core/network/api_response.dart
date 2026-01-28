import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Standard API Response wrapper
/// Matches the backend response format from API documentation
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.data,
    this.meta,
  });

  final bool success;
  final T data;
  final ResponseMeta? meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

/// Paginated API Response
@JsonSerializable(genericArgumentFactories: true)
class PaginatedApiResponse<T> {
  const PaginatedApiResponse({
    required this.success,
    required this.data,
    this.meta,
  });

  final bool success;
  final List<T> data;
  final PaginatedMeta? meta;

  factory PaginatedApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedApiResponseToJson(this, toJsonT);
}

/// Response metadata
@JsonSerializable()
class ResponseMeta {
  const ResponseMeta({
    required this.requestId,
    required this.timestamp,
  });

  @JsonKey(name: 'request_id')
  final String requestId;
  final String timestamp;

  factory ResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseMetaToJson(this);
}

/// Paginated metadata
@JsonSerializable()
class PaginatedMeta extends ResponseMeta {
  const PaginatedMeta({
    required super.requestId,
    required super.timestamp,
    required this.pagination,
  });

  final Pagination pagination;

  factory PaginatedMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMetaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaginatedMetaToJson(this);
}

/// Pagination information
@JsonSerializable()
class Pagination {
  const Pagination({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;
  final int total;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

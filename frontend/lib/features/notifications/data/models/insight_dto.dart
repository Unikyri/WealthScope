import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/insight_entity.dart';

part 'insight_dto.freezed.dart';
part 'insight_dto.g.dart';

@freezed
class InsightDto with _$InsightDto {
  const factory InsightDto({
    required String id,
    required String type,
    required String category,
    required String priority,
    required String title,
    required String content,
    @JsonKey(name: 'action_items') @Default([]) List<String> actionItems,
    @JsonKey(name: 'related_symbols') @Default([]) List<String> relatedSymbols,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _InsightDto;

  factory InsightDto.fromJson(Map<String, dynamic> json) =>
      _$InsightDtoFromJson(json);
}

@freezed
class InsightListDto with _$InsightListDto {
  const factory InsightListDto({
    required List<InsightDto> insights,
    required int total,
    required int limit,
    required int offset,
    @JsonKey(name: 'unread_count') required int unreadCount,
  }) = _InsightListDto;

  factory InsightListDto.fromJson(Map<String, dynamic> json) =>
      _$InsightListDtoFromJson(json);
}

@freezed
class UnreadCountDto with _$UnreadCountDto {
  const factory UnreadCountDto({
    required int count,
  }) = _UnreadCountDto;

  factory UnreadCountDto.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountDtoFromJson(json);
}

/// Extensions to convert DTOs to Domain Entities
extension InsightDtoX on InsightDto {
  InsightEntity toDomain() {
    return InsightEntity(
      id: id,
      type: type,
      category: category,
      priority: priority,
      title: title,
      content: content,
      actionItems: actionItems,
      relatedSymbols: relatedSymbols,
      isRead: isRead,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

extension InsightListDtoX on InsightListDto {
  InsightListEntity toDomain() {
    return InsightListEntity(
      insights: insights.map((dto) => dto.toDomain()).toList(),
      total: total,
      limit: limit,
      offset: offset,
      unreadCount: unreadCount,
    );
  }
}

extension UnreadCountDtoX on UnreadCountDto {
  UnreadCountEntity toDomain() {
    return UnreadCountEntity(count: count);
  }
}

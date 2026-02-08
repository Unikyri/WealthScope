import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/insight_entity.dart';

part 'insight_dto.freezed.dart';
part 'insight_dto.g.dart';

/// Data Transfer Object for Insights
@freezed
abstract class InsightDto with _$InsightDto {
  const factory InsightDto({
    required String id,
    required String type,
    required String category,
    required String priority,
    required String title,
    required String content,
    @JsonKey(name: 'action_items') required List<String> actionItems,
    @JsonKey(name: 'related_symbols') required List<String> relatedSymbols,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _InsightDto;

  factory InsightDto.fromJson(Map<String, dynamic> json) =>
      _$InsightDtoFromJson(json);
}

/// Extension to convert DTO to Domain Entity
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

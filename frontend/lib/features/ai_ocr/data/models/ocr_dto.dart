import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/ocr_entity.dart';

part 'ocr_dto.freezed.dart';
part 'ocr_dto.g.dart';

@freezed
class ExtractedAssetDto with _$ExtractedAssetDto {
  const factory ExtractedAssetDto({
    required String name,
    String? symbol,
    required String type,
    required double quantity,
    @JsonKey(name: 'purchase_price') required double purchasePrice,
    required String currency,
    @JsonKey(name: 'total_value') double? totalValue,
    required double confidence,
  }) = _ExtractedAssetDto;

  factory ExtractedAssetDto.fromJson(Map<String, dynamic> json) =>
      _$ExtractedAssetDtoFromJson(json);
}

@freezed
class OCRResultDto with _$OCRResultDto {
  const factory OCRResultDto({
    @JsonKey(name: 'document_type') required String documentType,
    required List<ExtractedAssetDto> assets,
    required List<String> warnings,
  }) = _OCRResultDto;

  factory OCRResultDto.fromJson(Map<String, dynamic> json) =>
      _$OCRResultDtoFromJson(json);
}

@freezed
class OCRConfirmationDto with _$OCRConfirmationDto {
  const factory OCRConfirmationDto({
    @JsonKey(name: 'asset_ids') required List<String> assetIds,
    @JsonKey(name: 'created_count') required int createdCount,
  }) = _OCRConfirmationDto;

  factory OCRConfirmationDto.fromJson(Map<String, dynamic> json) =>
      _$OCRConfirmationDtoFromJson(json);
}

/// Extensions to convert DTOs to Domain Entities
extension ExtractedAssetDtoX on ExtractedAssetDto {
  ExtractedAssetEntity toDomain() {
    return ExtractedAssetEntity(
      name: name,
      symbol: symbol,
      type: type,
      quantity: quantity,
      purchasePrice: purchasePrice,
      currency: currency,
      totalValue: totalValue,
      confidence: confidence,
    );
  }
}

extension OCRResultDtoX on OCRResultDto {
  OCRResultEntity toDomain() {
    return OCRResultEntity(
      documentType: documentType,
      assets: assets.map((dto) => dto.toDomain()).toList(),
      warnings: warnings,
    );
  }
}

extension OCRConfirmationDtoX on OCRConfirmationDto {
  OCRConfirmationEntity toDomain() {
    return OCRConfirmationEntity(
      assetIds: assetIds,
      createdCount: createdCount,
    );
  }
}

/// Request DTO for confirming assets
@freezed
class ConfirmAssetsRequestDto with _$ConfirmAssetsRequestDto {
  const factory ConfirmAssetsRequestDto({
    required List<ConfirmAssetDto> assets,
  }) = _ConfirmAssetsRequestDto;

  factory ConfirmAssetsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmAssetsRequestDtoFromJson(json);
}

@freezed
class ConfirmAssetDto with _$ConfirmAssetDto {
  const factory ConfirmAssetDto({
    required String name,
    String? symbol,
    required String type,
    required double quantity,
    @JsonKey(name: 'purchase_price') required double purchasePrice,
    required String currency,
  }) = _ConfirmAssetDto;

  factory ConfirmAssetDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmAssetDtoFromJson(json);
}

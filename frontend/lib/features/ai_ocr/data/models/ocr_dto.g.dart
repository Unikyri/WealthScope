// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExtractedAssetDto _$ExtractedAssetDtoFromJson(Map<String, dynamic> json) =>
    _ExtractedAssetDto(
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      currency: json['currency'] as String,
      totalValue: (json['total_value'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ExtractedAssetDtoToJson(_ExtractedAssetDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'type': instance.type,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'currency': instance.currency,
      'total_value': instance.totalValue,
      'confidence': instance.confidence,
    };

_OCRResultDto _$OCRResultDtoFromJson(Map<String, dynamic> json) =>
    _OCRResultDto(
      documentType: json['document_type'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => ExtractedAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      warnings:
          (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OCRResultDtoToJson(_OCRResultDto instance) =>
    <String, dynamic>{
      'document_type': instance.documentType,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
      'warnings': instance.warnings,
    };

_OCRConfirmationDto _$OCRConfirmationDtoFromJson(Map<String, dynamic> json) =>
    _OCRConfirmationDto(
      assetIds:
          (json['asset_ids'] as List<dynamic>).map((e) => e as String).toList(),
      createdCount: (json['created_count'] as num).toInt(),
    );

Map<String, dynamic> _$OCRConfirmationDtoToJson(_OCRConfirmationDto instance) =>
    <String, dynamic>{
      'asset_ids': instance.assetIds,
      'created_count': instance.createdCount,
    };

_ConfirmAssetsRequestDto _$ConfirmAssetsRequestDtoFromJson(
        Map<String, dynamic> json) =>
    _ConfirmAssetsRequestDto(
      assets: (json['assets'] as List<dynamic>)
          .map((e) => ConfirmAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConfirmAssetsRequestDtoToJson(
        _ConfirmAssetsRequestDto instance) =>
    <String, dynamic>{
      'assets': instance.assets.map((e) => e.toJson()).toList(),
    };

_ConfirmAssetDto _$ConfirmAssetDtoFromJson(Map<String, dynamic> json) =>
    _ConfirmAssetDto(
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$ConfirmAssetDtoToJson(_ConfirmAssetDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'type': instance.type,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'currency': instance.currency,
    };

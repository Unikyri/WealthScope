// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedAssetDtoImpl _$$ExtractedAssetDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ExtractedAssetDtoImpl(
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      currency: json['currency'] as String,
      totalValue: (json['total_value'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$$ExtractedAssetDtoImplToJson(
        _$ExtractedAssetDtoImpl instance) =>
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

_$OCRResultDtoImpl _$$OCRResultDtoImplFromJson(Map<String, dynamic> json) =>
    _$OCRResultDtoImpl(
      documentType: json['document_type'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => ExtractedAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      warnings:
          (json['warnings'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$OCRResultDtoImplToJson(_$OCRResultDtoImpl instance) =>
    <String, dynamic>{
      'document_type': instance.documentType,
      'assets': instance.assets.map((e) => e.toJson()).toList(),
      'warnings': instance.warnings,
    };

_$OCRConfirmationDtoImpl _$$OCRConfirmationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OCRConfirmationDtoImpl(
      assetIds:
          (json['asset_ids'] as List<dynamic>).map((e) => e as String).toList(),
      createdCount: (json['created_count'] as num).toInt(),
    );

Map<String, dynamic> _$$OCRConfirmationDtoImplToJson(
        _$OCRConfirmationDtoImpl instance) =>
    <String, dynamic>{
      'asset_ids': instance.assetIds,
      'created_count': instance.createdCount,
    };

_$ConfirmAssetsRequestDtoImpl _$$ConfirmAssetsRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConfirmAssetsRequestDtoImpl(
      assets: (json['assets'] as List<dynamic>)
          .map((e) => ConfirmAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConfirmAssetsRequestDtoImplToJson(
        _$ConfirmAssetsRequestDtoImpl instance) =>
    <String, dynamic>{
      'assets': instance.assets.map((e) => e.toJson()).toList(),
    };

_$ConfirmAssetDtoImpl _$$ConfirmAssetDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConfirmAssetDtoImpl(
      name: json['name'] as String,
      symbol: json['symbol'] as String?,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$$ConfirmAssetDtoImplToJson(
        _$ConfirmAssetDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'type': instance.type,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'currency': instance.currency,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDto _$AssetDtoFromJson(Map<String, dynamic> json) => AssetDto(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      type: json['type'] as String,
      name: json['name'] as String,
      coreData: json['core_data'] as Map<String, dynamic>?,
      extendedData: json['extended_data'] as Map<String, dynamic>? ?? const {},
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      totalValue: (json['total_value'] as num?)?.toDouble(),
      gainLoss: (json['gain_loss'] as num?)?.toDouble(),
      gainLossPercent: (json['gain_loss_percent'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AssetDtoToJson(AssetDto instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'name': instance.name,
      'core_data': instance.coreData,
      'extended_data': instance.extendedData,
      'total_cost': instance.totalCost,
      'total_value': instance.totalValue,
      'gain_loss': instance.gainLoss,
      'gain_loss_percent': instance.gainLossPercent,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

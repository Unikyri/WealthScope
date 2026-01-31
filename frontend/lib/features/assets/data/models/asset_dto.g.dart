// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDto _$AssetDtoFromJson(Map<String, dynamic> json) => AssetDto(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      type: json['type'] as String,
      symbol: json['symbol'] as String?,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      purchaseDate: json['purchase_date'] as String?,
      currency: json['currency'] as String?,
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      totalValue: (json['total_value'] as num?)?.toDouble(),
      gainLoss: (json['gain_loss'] as num?)?.toDouble(),
      gainLossPercent: (json['gain_loss_percent'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AssetDtoToJson(AssetDto instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'symbol': instance.symbol,
      'name': instance.name,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'purchase_date': instance.purchaseDate,
      'currency': instance.currency,
      'current_price': instance.currentPrice,
      'total_cost': instance.totalCost,
      'total_value': instance.totalValue,
      'gain_loss': instance.gainLoss,
      'gain_loss_percent': instance.gainLossPercent,
      'metadata': instance.metadata,
      'notes': instance.notes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

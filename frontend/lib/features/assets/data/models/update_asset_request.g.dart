// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_asset_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAssetRequest _$UpdateAssetRequestFromJson(Map<String, dynamic> json) =>
    UpdateAssetRequest(
      type: json['type'] as String?,
      name: json['name'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      currency: json['currency'] as String?,
      currentPrice: (json['current_price'] as num?)?.toDouble(),
      purchaseDate: json['purchase_date'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$UpdateAssetRequestToJson(UpdateAssetRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'symbol': instance.symbol,
      'currency': instance.currency,
      'current_price': instance.currentPrice,
      'purchase_date': instance.purchaseDate,
      'metadata': instance.metadata,
      'notes': instance.notes,
    };

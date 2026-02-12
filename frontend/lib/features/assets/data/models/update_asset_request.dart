import 'package:json_annotation/json_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

part 'update_asset_request.g.dart';

/// Update Asset Request DTO
/// Maps to PUT /api/v1/assets/{id} request body
@JsonSerializable()
class UpdateAssetRequest {
  const UpdateAssetRequest({
    this.type,
    this.name,
    this.quantity,
    this.purchasePrice,
    this.symbol,
    this.currency,
    this.currentPrice,
    this.purchaseDate,
    this.metadata,
    this.notes,
  });

  /// Asset type: stock, etf, bond, crypto, real_estate, gold, cash, other
  final String? type;

  /// Asset name
  final String? name;

  /// Quantity purchased
  final double? quantity;

  /// Purchase price per unit
  @JsonKey(name: 'purchase_price')
  final double? purchasePrice;

  /// Stock symbol
  final String? symbol;

  /// Currency code (e.g., USD, EUR)
  final String? currency;

  /// Current price per unit
  @JsonKey(name: 'current_price')
  final double? currentPrice;

  /// Purchase date in ISO 8601 format
  @JsonKey(name: 'purchase_date')
  final String? purchaseDate;

  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Notes about the asset
  final String? notes;

  factory UpdateAssetRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAssetRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final coreData = <String, dynamic>{
      if (notes != null) 'notes': notes,
      if (currency != null) 'currency': currency,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
    };

    // Helper to add if not null
    void add(String key, dynamic value) {
      if (value != null) coreData[key] = value;
    }

    if (type != null) {
      final assetType = AssetType.fromString(type!);
      
      switch (assetType) {
        case AssetType.stock:
        case AssetType.etf:
          add('ticker', symbol);
          if (quantity != null) coreData['quantity'] = quantity;
          if (purchasePrice != null) coreData['purchase_price_per_share'] = purchasePrice;
          if (purchaseDate != null) coreData['trade_date'] = purchaseDate;
          break;
        case AssetType.crypto:
          add('symbol', symbol);
          if (quantity != null) coreData['quantity'] = quantity;
          if (purchasePrice != null) coreData['purchase_price'] = purchasePrice;
          if (purchaseDate != null) coreData['purchase_date'] = purchaseDate;
          break;
        case AssetType.bond:
          add('cusip', symbol);
          if (quantity != null) coreData['face_value'] = quantity;
          if (purchasePrice != null) coreData['purchase_price_percent'] = purchasePrice;
          if (purchaseDate != null) coreData['trade_date'] = purchaseDate;
          break;
        case AssetType.realEstate:
          if (purchasePrice != null) coreData['purchase_price'] = purchasePrice;
          break;
        case AssetType.cash:
          if (quantity != null) coreData['balance'] = quantity;
          if (name != null) coreData['bank_name'] = name;
          if (currency != null) coreData['currency'] = currency;
          break;
        default:
          add('symbol', symbol);
          if (quantity != null) coreData['quantity'] = quantity;
          if (purchasePrice != null) coreData['purchase_price'] = purchasePrice;
      }
    }

    // Merge metadata
    if (metadata != null) {
      coreData.addAll(metadata!);
    }

    final map = <String, dynamic>{
      if (type != null) 'type': type,
      if (name != null) 'name': name,
    };

    if (coreData.isNotEmpty) {
      map['core_data'] = coreData;
    }

    if (currentPrice != null) {
       map['extended_data'] = {'current_price': currentPrice};
    }

    return map;
  }
}

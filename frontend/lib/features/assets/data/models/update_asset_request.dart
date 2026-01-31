import 'package:json_annotation/json_annotation.dart';

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

  Map<String, dynamic> toJson() => _$UpdateAssetRequestToJson(this);
}

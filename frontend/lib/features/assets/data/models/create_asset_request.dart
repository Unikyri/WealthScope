import 'package:json_annotation/json_annotation.dart';

part 'create_asset_request.g.dart';

/// Create Asset Request DTO
/// Maps to POST /api/v1/assets request body
@JsonSerializable()
class CreateAssetRequest {
  const CreateAssetRequest({
    required this.type,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    this.symbol,
    this.currency,
    this.currentPrice,
    this.purchaseDate,
    this.metadata,
    this.notes,
  });

  /// Asset type: stock, etf, bond, crypto, real_estate, gold, cash, other
  final String type;

  /// Asset name (required)
  final String name;

  /// Quantity purchased (required)
  final double quantity;

  /// Purchase price per unit (required)
  @JsonKey(name: 'purchase_price')
  final double purchasePrice;

  /// Stock symbol (optional, but recommended for stocks/etfs)
  final String? symbol;

  /// Currency code (e.g., USD, EUR)
  final String? currency;

  /// Current price per unit (optional)
  @JsonKey(name: 'current_price')
  final double? currentPrice;

  /// Purchase date in ISO 8601 format (optional)
  @JsonKey(name: 'purchase_date')
  final String? purchaseDate;

  /// Additional metadata (optional)
  final Map<String, dynamic>? metadata;

  /// Notes about the asset (optional)
  final String? notes;

  factory CreateAssetRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAssetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAssetRequestToJson(this);
}

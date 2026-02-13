import 'package:json_annotation/json_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

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

  /// Asset type (API string format)
  final String type;

  final String name;
  final double quantity;

  @JsonKey(name: 'purchase_price')
  final double purchasePrice;

  final String? symbol;
  final String? currency;

  @JsonKey(name: 'current_price')
  final double? currentPrice;

  @JsonKey(name: 'purchase_date')
  final String? purchaseDate;

  final Map<String, dynamic>? metadata;
  final String? notes;

  factory CreateAssetRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAssetRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final coreData = <String, dynamic>{
      if (notes != null) 'notes': notes,
      if (currency != null) 'currency': currency,
      if (purchaseDate != null) 'purchase_date': purchaseDate, // Generic fallback
    };

    // Helper to add if not null
    void add(String key, dynamic value) {
      if (value != null) coreData[key] = value;
    }

    final assetType = AssetType.fromString(type);

    switch (assetType) {
      case AssetType.stock:
      case AssetType.etf:
        add('ticker', symbol);
        coreData['quantity'] = quantity;
        coreData['purchase_price_per_share'] = purchasePrice;
        if (purchaseDate != null) coreData['trade_date'] = purchaseDate;
        break;
      case AssetType.crypto:
        add('symbol', symbol);
        coreData['quantity'] = quantity;
        coreData['purchase_price'] = purchasePrice;
        if (purchaseDate != null) coreData['purchase_date'] = purchaseDate;
        break;
      case AssetType.bond:
        // For Bond, symbol is CUSIP/ISIN.
        // Assuming user puts CUSIP in symbol field.
        add('cusip', symbol);
        coreData['face_value'] = quantity;
        coreData['purchase_price_percent'] = purchasePrice;
        if (purchaseDate != null) coreData['trade_date'] = purchaseDate;
        break;
      case AssetType.realEstate:
        coreData['quantity'] = 1.0;
        if (purchasePrice != null) coreData['purchase_price'] = purchasePrice; // Address etc come from metadata
        break;
      case AssetType.cash:
        coreData['balance'] = quantity;
        coreData['bank_name'] = name;
        coreData['currency'] = currency ?? 'USD';
        break;
      case AssetType.custom:
      case AssetType.liability:
        // Use standard fields for custom
        add('symbol', symbol);
        coreData['quantity'] = quantity;
        coreData['purchase_price'] = purchasePrice;
        break;
      default:
        add('symbol', symbol);
        coreData['quantity'] = quantity;
        coreData['purchase_price'] = purchasePrice;
    }

    // Merge metadata into core_data
    if (metadata != null) {
      coreData.addAll(metadata!);
    }

    final map = <String, dynamic>{
      'type': type,
      'name': name,
      'core_data': coreData,
    };

    if (currentPrice != null) {
       // current_price usually goes to extended_data or ignored on create (fetched from API)
       // But if user manually sets it, we might want to pass it.
       // Backend v2 might expect manual overrides in extended_data or core_data?
       // The schema says auto_fill_fields includes current_price.
       // For now, let's put it in core_data as an override or dedicated field.
       // Or extended_data.
       map['extended_data'] = {'current_price': currentPrice};
    }

    return map;
  }
}

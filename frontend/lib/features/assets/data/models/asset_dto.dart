import 'package:json_annotation/json_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

part 'asset_dto.g.dart';

/// Asset Data Transfer Object
/// Maps to GET /api/v1/assets response from backend API
@JsonSerializable()
class AssetDto {
  const AssetDto({
    this.id,
    this.userId,
    required this.type,
    required this.name,
    required this.coreData,
    this.extendedData = const {},
    this.totalCost,
    this.totalValue,
    this.gainLoss,
    this.gainLossPercent,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  
  @JsonKey(name: 'user_id')
  final String? userId;
  
  final String type;
  final String name;

  @JsonKey(name: 'core_data')
  final Map<String, dynamic> coreData;

  @JsonKey(name: 'extended_data')
  final Map<String, dynamic> extendedData;
  
  @JsonKey(name: 'total_cost')
  final double? totalCost;
  
  @JsonKey(name: 'total_value')
  final double? totalValue;
  
  @JsonKey(name: 'gain_loss')
  final double? gainLoss;
  
  @JsonKey(name: 'gain_loss_percent')
  final double? gainLossPercent;
  
  @JsonKey(name: 'created_at')
  final String? createdAt;
  
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  factory AssetDto.fromJson(Map<String, dynamic> json) => _$AssetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDtoToJson(this);

  /// Helper getter for symbol to support search filtering
  String? get symbol {
    if (coreData.containsKey('ticker')) return coreData['ticker']?.toString();
    if (coreData.containsKey('symbol')) return coreData['symbol']?.toString();
    if (coreData.containsKey('cusip')) return coreData['cusip']?.toString();
    if (coreData.containsKey('isin')) return coreData['isin']?.toString();
    if (coreData.containsKey('currency')) return coreData['currency']?.toString();
    return null;
  }

  /// Convert DTO to Domain Entity
  StockAsset toDomain() {
    final assetType = AssetType.fromString(type);
    
    // Extract common fields from core_data based on type
    String symbol = '';
    double quantity = 0.0;
    double purchasePrice = 0.0;
    String? purchaseDateStr;
    String currencyCode = 'USD';
    String? notes;
    
    // Helper to safely get double
    double getDouble(String key) {
      final val = coreData[key];
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    // Helper to safely get string
    String getString(String key) => coreData[key]?.toString() ?? '';

    switch (assetType) {
      case AssetType.stock:
      case AssetType.etf:
        symbol = getString('ticker');
        quantity = getDouble('quantity');
        purchasePrice = getDouble('purchase_price_per_share');
        purchaseDateStr = getString('trade_date');
        break;
      case AssetType.crypto:
        symbol = getString('symbol');
        quantity = getDouble('quantity');
        purchasePrice = getDouble('purchase_price');
        purchaseDateStr = getString('purchase_date');
        break;
      case AssetType.bond:
        symbol = getString('cusip'); // Use CUSIP as symbol
        if (symbol.isEmpty) symbol = getString('isin');
        quantity = getDouble('face_value'); // Use face value as quantity representation
        purchasePrice = getDouble('purchase_price_percent'); // Price as % of par
        purchaseDateStr = getString('trade_date');
        break;
      case AssetType.realEstate:
        symbol = ''; 
        quantity = 1.0; 
        purchasePrice = getDouble('purchase_price');
        // Address is in core_data but not mapped to symbol/qty
        break;
      case AssetType.custom:
      case AssetType.liability:
        // These map to 'custom' or specific liability logic
        symbol = getString('symbol');
        quantity = getDouble('quantity');
        if (quantity == 0) quantity = 1.0; 
        purchasePrice = getDouble('purchase_price');
        break;
      case AssetType.cash:
        symbol = getString('currency');
        quantity = getDouble('balance');
        purchasePrice = 1.0;
        currencyCode = getString('currency');
        break;
      default:
        quantity = 1.0;
    }

    // Common optional fields in core_data
    if (coreData.containsKey('currency')) {
      currencyCode = getString('currency');
    }
    if (coreData.containsKey('notes')) {
      notes = getString('notes');
    }
    if (coreData.containsKey('purchase_date') && purchaseDateStr == null) {
      purchaseDateStr = getString('purchase_date');
    }

    // Current price from extended_data
    double? currentPrice;
    if (extendedData.containsKey('current_price')) {
      final val = extendedData['current_price'];
      if (val is num) currentPrice = val.toDouble();
    }

    // Merge core and extended data for metadata
    final metadata = <String, dynamic>{
      ...coreData,
      ...extendedData,
    };

    return StockAsset(
      id: id,
      userId: userId,
      type: assetType,
      symbol: symbol,
      name: name,
      quantity: quantity,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDateStr != null ? DateTime.tryParse(purchaseDateStr) : null,
      currency: Currency.fromString(currencyCode),
      currentPrice: currentPrice,
      totalCost: totalCost,
      totalValue: totalValue,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
      metadata: metadata,
      notes: notes,
      isActive: true, // Backend doesn't send isActive in v2 yet? assuming true
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }

  /// Create DTO from Domain Entity
  factory AssetDto.fromDomain(StockAsset asset) {
    // Construct core_data based on type
    final coreData = <String, dynamic>{
      if (asset.notes != null) 'notes': asset.notes,
      'currency': asset.currency.code,
    };

    switch (asset.type) {
      case AssetType.stock:
      case AssetType.etf:
        coreData['ticker'] = asset.symbol;
        coreData['quantity'] = asset.quantity;
        coreData['purchase_price_per_share'] = asset.purchasePrice;
        if (asset.purchaseDate != null) {
          coreData['trade_date'] = asset.purchaseDate!.toIso8601String();
        }
        break;
      case AssetType.crypto:
        coreData['symbol'] = asset.symbol;
        coreData['quantity'] = asset.quantity;
        coreData['purchase_price'] = asset.purchasePrice;
        if (asset.purchaseDate != null) {
          coreData['purchase_date'] = asset.purchaseDate!.toIso8601String();
        }
        break;
      case AssetType.bond:
        coreData['cusip'] = asset.symbol;
        coreData['face_value'] = asset.quantity;
        coreData['purchase_price_percent'] = asset.purchasePrice;
        if (asset.purchaseDate != null) {
          coreData['trade_date'] = asset.purchaseDate!.toIso8601String();
        }
        break;
      case AssetType.realEstate:
        coreData['purchase_price'] = asset.purchasePrice;
        // Address usually in metadata for RE
        if (asset.metadata.containsKey('address')) {
          coreData['address'] = asset.metadata['address'];
        }
        break;
      case AssetType.cash:
        coreData['balance'] = asset.quantity;
        coreData['bank_name'] = asset.name; // Map name to bank_name? or separate?
        // Cash validation requires bank_name
        break;
      default:
        coreData['quantity'] = asset.quantity;
        coreData['purchase_price'] = asset.purchasePrice;
    }

    // Add any other metadata to core_data if they aren't already there
    asset.metadata.forEach((key, value) {
      if (!coreData.containsKey(key)) {
        coreData[key] = value;
      }
    });

    return AssetDto(
      id: asset.id,
      userId: asset.userId,
      type: asset.type.toApiString(),
      name: asset.name,
      coreData: coreData,
      extendedData: {}, // extended_data usually read-only or from API
      totalCost: asset.totalCost,
      totalValue: asset.totalValue,
      gainLoss: asset.gainLoss,
      gainLossPercent: asset.gainLossPercent,
      createdAt: asset.createdAt?.toIso8601String(),
      updatedAt: asset.updatedAt?.toIso8601String(),
    );
  }
}
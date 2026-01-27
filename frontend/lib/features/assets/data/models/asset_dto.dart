import 'package:json_annotation/json_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

part 'asset_dto.g.dart';

/// Asset Data Transfer Object
/// Maps to the assets table in PostgreSQL via Supabase
@JsonSerializable()
class AssetDto {
  const AssetDto({
    this.id,
    required this.userId,
    required this.type,
    this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    this.purchaseDate,
    this.currency,
    this.currentPrice,
    this.currentValue,
    this.lastPriceUpdate,
    this.metadata,
    this.notes,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  
  @JsonKey(name: 'user_id')
  final String userId;
  
  final String type;
  final String? symbol;
  final String name;
  final double quantity;
  
  @JsonKey(name: 'purchase_price')
  final double purchasePrice;
  
  @JsonKey(name: 'purchase_date')
  final String? purchaseDate; // ISO date string
  
  final String? currency;
  
  @JsonKey(name: 'current_price')
  final double? currentPrice;
  
  @JsonKey(name: 'current_value')
  final double? currentValue;
  
  @JsonKey(name: 'last_price_update')
  final String? lastPriceUpdate; // ISO timestamp
  
  final Map<String, dynamic>? metadata;
  final String? notes;
  
  @JsonKey(name: 'is_active')
  final bool? isActive;
  
  @JsonKey(name: 'created_at')
  final String? createdAt; // ISO timestamp
  
  @JsonKey(name: 'updated_at')
  final String? updatedAt; // ISO timestamp

  factory AssetDto.fromJson(Map<String, dynamic> json) => _$AssetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AssetDtoToJson(this);

  /// Convert DTO to Domain Entity
  StockAsset toDomain() {
    return StockAsset(
      id: id,
      userId: userId,
      type: AssetType.fromString(type),
      symbol: symbol ?? '',
      name: name,
      quantity: quantity,
      purchasePrice: purchasePrice,
      purchaseDate: purchaseDate != null ? DateTime.parse(purchaseDate!) : null,
      currency: Currency.fromString(currency ?? 'USD'),
      currentPrice: currentPrice,
      currentValue: currentValue,
      lastPriceUpdate: lastPriceUpdate != null ? DateTime.parse(lastPriceUpdate!) : null,
      metadata: metadata ?? {},
      notes: notes,
      isActive: isActive ?? true,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// Create DTO from Domain Entity
  factory AssetDto.fromDomain(StockAsset asset) {
    return AssetDto(
      id: asset.id,
      userId: asset.userId,
      type: asset.type.label.toLowerCase(),
      symbol: asset.symbol,
      name: asset.name,
      quantity: asset.quantity,
      purchasePrice: asset.purchasePrice,
      purchaseDate: asset.purchaseDate?.toIso8601String(),
      currency: asset.currency.code,
      currentPrice: asset.currentPrice,
      currentValue: asset.currentValue,
      lastPriceUpdate: asset.lastPriceUpdate?.toIso8601String(),
      metadata: asset.metadata.isNotEmpty ? asset.metadata : null,
      notes: asset.notes,
      isActive: asset.isActive,
      createdAt: asset.createdAt?.toIso8601String(),
      updatedAt: asset.updatedAt?.toIso8601String(),
    );
  }
}

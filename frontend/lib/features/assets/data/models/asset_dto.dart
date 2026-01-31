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
    this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    this.purchaseDate,
    this.currency,
    this.currentPrice,
    this.totalCost,
    this.totalValue,
    this.gainLoss,
    this.gainLossPercent,
    this.metadata,
    this.notes,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  
  @JsonKey(name: 'user_id')
  final String? userId;
  
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
  
  @JsonKey(name: 'total_cost')
  final double? totalCost;
  
  @JsonKey(name: 'total_value')
  final double? totalValue;
  
  @JsonKey(name: 'gain_loss')
  final double? gainLoss;
  
  @JsonKey(name: 'gain_loss_percent')
  final double? gainLossPercent;
  
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

  /// Convert to JSON for POST/PUT requests (excludes read-only fields)
  /// This method is deprecated - use CreateAssetRequest/UpdateAssetRequest instead
  @Deprecated('Use CreateAssetRequest for POST and UpdateAssetRequest for PUT')
  Map<String, dynamic> toCreateJson() {
    return {
      'type': type,
      'name': name,
      'symbol': symbol,
      'quantity': quantity,
      'purchase_price': purchasePrice,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (currency != null) 'currency': currency,
      if (currentPrice != null) 'current_price': currentPrice,
      if (metadata != null && metadata!.isNotEmpty) 'metadata': metadata,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

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
      totalCost: totalCost,
      totalValue: totalValue,
      gainLoss: gainLoss,
      gainLossPercent: gainLossPercent,
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
      type: asset.type.toApiString(),
      symbol: asset.symbol,
      name: asset.name,
      quantity: asset.quantity,
      purchasePrice: asset.purchasePrice,
      purchaseDate: asset.purchaseDate?.toIso8601String(),
      currency: asset.currency.code,
      currentPrice: asset.currentPrice,
      totalCost: asset.totalCost,
      totalValue: asset.totalValue,
      gainLoss: asset.gainLoss,
      gainLossPercent: asset.gainLossPercent,
      metadata: asset.metadata.isNotEmpty ? asset.metadata : null,
      notes: asset.notes,
      isActive: asset.isActive,
      createdAt: asset.createdAt?.toIso8601String(),
      updatedAt: asset.updatedAt?.toIso8601String(),
    );
  }
}
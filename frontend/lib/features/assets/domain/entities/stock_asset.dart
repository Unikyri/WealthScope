import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';

/// Stock/ETF Asset Entity
/// Represents a stock or ETF asset in the portfolio.
/// Matches the database schema from assets table.
class StockAsset {
  const StockAsset({
    this.id,
    required this.userId,
    required this.type,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    this.purchaseDate,
    required this.currency,
    this.currentPrice,
    this.currentValue,
    this.lastPriceUpdate,
    this.metadata = const {},
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Database primary key
  final String? id;
  
  // Foreign key to users table
  final String userId;
  
  // Asset identification
  final AssetType type;
  final String symbol; // Required for stocks/ETFs
  final String name;
  
  // Quantities and values
  final double quantity; // Must be > 0
  final double purchasePrice; // Must be >= 0
  final DateTime? purchaseDate;
  final Currency currency;
  
  // Current valuation (cached from price service)
  final double? currentPrice;
  final double? currentValue;
  final DateTime? lastPriceUpdate;
  
  // Type-specific metadata (JSONB in DB)
  // For stocks/ETFs: {"exchange": "NASDAQ", "sector": "Technology", "industry": "Consumer Electronics", "country": "USA"}
  final Map<String, dynamic> metadata;
  
  // Audit fields
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Total invested amount
  double get totalInvested => quantity * purchasePrice;
  
  /// Current gain/loss amount
  double? get gainLoss => currentValue != null ? currentValue! - totalInvested : null;
  
  /// Current gain/loss percentage
  double? get gainLossPercent => totalInvested > 0 && gainLoss != null
      ? (gainLoss! / totalInvested * 100)
      : null;

  /// Create a copy with updated fields
  StockAsset copyWith({
    String? id,
    String? userId,
    AssetType? type,
    String? symbol,
    String? name,
    double? quantity,
    double? purchasePrice,
    DateTime? purchaseDate,
    Currency? currency,
    double? currentPrice,
    double? currentValue,
    DateTime? lastPriceUpdate,
    Map<String, dynamic>? metadata,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockAsset(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      currency: currency ?? this.currency,
      currentPrice: currentPrice ?? this.currentPrice,
      currentValue: currentValue ?? this.currentValue,
      lastPriceUpdate: lastPriceUpdate ?? this.lastPriceUpdate,
      metadata: metadata ?? this.metadata,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

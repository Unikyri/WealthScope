import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';

/// Stock/ETF Asset Entity
/// Represents a stock or ETF asset in the portfolio.
/// Matches the API response from GET /api/v1/assets
class StockAsset {
  const StockAsset({
    this.id,
    this.userId,
    required this.type,
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    this.purchaseDate,
    required this.currency,
    this.currentPrice,
    this.totalCost,
    this.totalValue,
    this.gainLoss,
    this.gainLossPercent,
    this.metadata = const {},
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  // Database primary key
  final String? id;
  
  // Foreign key to users table (optional since backend knows from JWT)
  final String? userId;
  
  // Asset identification
  final AssetType type;
  final String symbol; // Required for stocks/ETFs
  final String name;
  
  // Quantities and values
  final double quantity; // Must be > 0
  final double purchasePrice; // Must be >= 0
  final DateTime? purchaseDate;
  final Currency currency;
  
  // Current valuation (calculated by backend)
  final double? currentPrice;
  final double? totalCost;      // quantity * purchase_price (from API)
  final double? totalValue;     // quantity * current_price (from API)
  final double? gainLoss;       // total_value - total_cost (from API)
  final double? gainLossPercent; // (gain_loss / total_cost) * 100 (from API)
  
  // Type-specific metadata (JSONB in DB)
  // For stocks/ETFs: {"exchange": "NASDAQ", "sector": "Technology", "industry": "Consumer Electronics", "country": "USA"}
  final Map<String, dynamic> metadata;
  
  // Audit fields
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Total invested amount (prefer totalCost from API if available)
  double get totalInvested => totalCost ?? (quantity * purchasePrice);

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
    double? totalCost,
    double? totalValue,
    double? gainLoss,
    double? gainLossPercent,
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
      totalCost: totalCost ?? this.totalCost,
      totalValue: totalValue ?? this.totalValue,
      gainLoss: gainLoss ?? this.gainLoss,
      gainLossPercent: gainLossPercent ?? this.gainLossPercent,
      metadata: metadata ?? this.metadata,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

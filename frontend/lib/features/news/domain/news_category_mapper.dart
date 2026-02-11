import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Maps asset types to relevant news search keywords for the fallback system.
///
/// Used by the asset news provider when symbol-specific news are unavailable,
/// allowing a graceful fallback to category-relevant news.
class NewsCategoryMapper {
  NewsCategoryMapper._();

  static const _typeToKeywords = <AssetType, List<String>>{
    AssetType.stock: ['stock market', 'equities', 'earnings'],
    AssetType.etf: ['ETF', 'index funds', 'market indices'],
    AssetType.crypto: ['cryptocurrency', 'blockchain', 'bitcoin'],
    AssetType.bond: ['bonds', 'fixed income', 'interest rates', 'treasury'],
    AssetType.realEstate: ['real estate', 'housing market', 'property'],
    AssetType.gold: ['gold', 'precious metals', 'commodities'],
    AssetType.cash: ['savings', 'interest rates', 'banking'],
    AssetType.other: ['financial markets', 'investing'],
  };

  /// Get the primary keyword for API search (Level 2 fallback).
  static String getPrimaryKeyword(AssetType type) {
    return _typeToKeywords[type]?.first ?? 'financial markets';
  }

  /// Get all keywords associated with a given asset type.
  static List<String> getKeywords(AssetType type) {
    return _typeToKeywords[type] ?? ['financial markets', 'investing'];
  }
}

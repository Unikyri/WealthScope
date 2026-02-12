/// Asset Type Enumeration
/// Defines the different types of assets that can be added to the portfolio.
/// Matches API types: stock, etf, bond, crypto, real_estate, gold, cash, other
enum AssetType {
  stock('Stock', 'Stocks'),
  etf('ETF', 'ETFs'),
  bond('Bond', 'Bonds'),
  crypto('Crypto', 'Cryptocurrency'),
  realEstate('Real Estate', 'Real Estate'),
  gold('Gold', 'Gold'),
  cash('Cash', 'Cash'),
  custom('Custom', 'Custom Asset'),
  liability('Liability', 'Liability'),
  other('Other', 'Other');

  const AssetType(this.label, this.displayName);

  final String label;
  final String displayName;

  /// Convert string to AssetType enum
  /// Handles both snake_case (API format) and label format
  static AssetType fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('_', '');
    
    switch (normalized) {
      case 'stock':
        return AssetType.stock;
      case 'etf':
        return AssetType.etf;
      case 'bond':
        return AssetType.bond;
      case 'crypto':
      case 'cryptocurrency':
        return AssetType.crypto;
      case 'realestate':
        return AssetType.realEstate;
      case 'gold':
        return AssetType.gold;
      case 'cash':
        return AssetType.cash;
      case 'custom':
        return AssetType.custom;
      case 'liability':
        return AssetType.liability;
      case 'other':
      default:
        return AssetType.other;
    }
  }
  
  /// Whether this asset type requires Sentinel (premium) plan.
  /// All asset types are available for free and premium plans.
  bool get isPremiumOnly => false;

  /// Convert to API format (snake_case)
  String toApiString() {
    switch (this) {
      case AssetType.stock:
        return 'stock';
      case AssetType.etf:
        return 'etf';
      case AssetType.bond:
        return 'bond';
      case AssetType.crypto:
        return 'crypto';
      case AssetType.realEstate:
        return 'real_estate';

      case AssetType.cash:
        return 'cash';
      case AssetType.custom:
        return 'custom';
      case AssetType.liability:
        return 'liability';
      // Map legacy frontend types to 'custom' on backend if needed, 
      // but for now keeping 'other' as 'other' since backend valid_types has 'custom' but not 'other'?
      // Wait, backend validation list says: AssetTypeCustom... but also AssetTypeOther was removed?
      // Checking backend file again: var ValidAssetTypes = []AssetType{... AssetTypeCustom, AssetTypeLiability}
      // So 'other' and 'gold' should map to 'custom'.
      case AssetType.gold:
        return 'custom'; // Gold is now a custom asset category
      case AssetType.other:
        return 'custom'; // Other is now a custom asset category
    }
  }
}

/// Asset Type Enumeration
/// Defines the different types of assets that can be added to the portfolio.
/// Matches API types: stock, etf, bond, crypto, real_estate, cash, custom, liability
enum AssetType {
  stock('Stock', 'Stocks'),
  etf('ETF', 'ETFs'),
  bond('Bond', 'Bonds'),
  crypto('Crypto', 'Cryptocurrency'),
  realEstate('Real Estate', 'Real Estate'),
  cash('Cash', 'Cash'),
  custom('Custom', 'Custom Asset'),
  liability('Liability', 'Liabilities');

  const AssetType(this.label, this.displayName);

  final String label;
  final String displayName;

  /// Convert string to AssetType enum
  /// Handles both snake_case (API format) and label format
  static AssetType fromString(String value) {
    // Normalize: remove underscores and convert to lower case
    final normalized = value.toLowerCase().replaceAll('_', '');
    
    switch (normalized) {
      case 'stock':
      case 'stocks':
        return AssetType.stock;
      case 'etf':
      case 'etfs':
        return AssetType.etf;
      case 'bond':
      case 'bonds':
        return AssetType.bond;
      case 'crypto':
      case 'cryptocurrency':
        return AssetType.crypto;
      case 'realestate':
        return AssetType.realEstate;
      case 'cash':
        return AssetType.cash;
      case 'custom':
      case 'customasset':
      case 'gold': // Legacy mapping
      case 'other': // Legacy mapping
        return AssetType.custom;
      case 'liability':
      case 'liabilities':
        return AssetType.liability;
      default:
        // Default to custom instead of throwing or returning a removed 'other' type
        return AssetType.custom;
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
    }
  }
}

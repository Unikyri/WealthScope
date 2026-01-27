/// Asset Type Enumeration
/// Defines the different types of assets that can be added to the portfolio.
enum AssetType {
  stock('Stock', 'Stocks'),
  etf('ETF', 'ETFs'),
  realEstate('Real Estate', 'Real Estate'),
  gold('Gold', 'Gold'),
  bond('Bond', 'Bonds'),
  crypto('Crypto', 'Cryptocurrency'),
  other('Other', 'Other');

  const AssetType(this.label, this.displayName);

  final String label;
  final String displayName;

  /// Convert string to AssetType enum
  static AssetType fromString(String value) {
    return AssetType.values.firstWhere(
      (type) => type.label.toLowerCase() == value.toLowerCase(),
      orElse: () => AssetType.other,
    );
  }
}

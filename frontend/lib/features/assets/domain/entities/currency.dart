/// Currency Enumeration
/// Defines supported currencies for asset transactions.
enum Currency {
  usd('USD', '\$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  jpy('JPY', '¥', 'Japanese Yen'),
  cad('CAD', 'C\$', 'Canadian Dollar'),
  aud('AUD', 'A\$', 'Australian Dollar'),
  chf('CHF', 'CHF', 'Swiss Franc'),
  cny('CNY', '¥', 'Chinese Yuan');

  const Currency(this.code, this.symbol, this.name);

  final String code;
  final String symbol;
  final String name;

  /// Convert string to Currency enum
  static Currency fromString(String value) {
    return Currency.values.firstWhere(
      (currency) => currency.code.toLowerCase() == value.toLowerCase(),
      orElse: () => Currency.usd,
    );
  }
}

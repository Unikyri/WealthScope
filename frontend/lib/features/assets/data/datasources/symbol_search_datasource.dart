import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Information about a financial symbol.
class SymbolInfo {
  const SymbolInfo({
    required this.symbol,
    required this.name,
    required this.type,
    this.exchange,
  });

  final String symbol;
  final String name;
  final AssetType type;
  final String? exchange;
}

/// Local datasource for symbol search.
///
/// Provides a catalog of popular stock and crypto symbols for
/// client-side autocomplete. No backend endpoint is needed.
class SymbolSearchDatasource {
  SymbolSearchDatasource._();

  static final SymbolSearchDatasource instance = SymbolSearchDatasource._();

  /// Search symbols matching [query] filtered by [type].
  ///
  /// Matches against symbol prefix and name substring.
  /// Results are sorted: exact symbol match first, then prefix, then name match.
  List<SymbolInfo> search(String query, AssetType type) {
    if (query.trim().isEmpty) return const [];

    final q = query.trim().toLowerCase();
    final catalog = _getCatalog(type);

    final results = catalog.where((s) {
      final sym = s.symbol.toLowerCase();
      final name = s.name.toLowerCase();
      return sym.startsWith(q) || name.contains(q);
    }).toList();

    // Sort: exact symbol match > prefix > name match
    results.sort((a, b) {
      final aSym = a.symbol.toLowerCase();
      final bSym = b.symbol.toLowerCase();

      final aExact = aSym == q;
      final bExact = bSym == q;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      final aPrefix = aSym.startsWith(q);
      final bPrefix = bSym.startsWith(q);
      if (aPrefix && !bPrefix) return -1;
      if (!aPrefix && bPrefix) return 1;

      return aSym.compareTo(bSym);
    });

    return results.take(10).toList();
  }

  List<SymbolInfo> _getCatalog(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return _stocks;
      case AssetType.etf:
        return _etfs;
      case AssetType.crypto:
        return _cryptos;
      default:
        return const [];
    }
  }

  // ---------------------------------------------------------------------------
  // Stock Catalog (~50 popular symbols)
  // ---------------------------------------------------------------------------
  static const _stocks = <SymbolInfo>[
    SymbolInfo(symbol: 'AAPL', name: 'Apple Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'MSFT', name: 'Microsoft Corporation', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'GOOGL', name: 'Alphabet Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'AMZN', name: 'Amazon.com Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'NVDA', name: 'NVIDIA Corporation', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'META', name: 'Meta Platforms Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'TSLA', name: 'Tesla Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'BRK.B', name: 'Berkshire Hathaway', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'JPM', name: 'JPMorgan Chase & Co.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'V', name: 'Visa Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'JNJ', name: 'Johnson & Johnson', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'WMT', name: 'Walmart Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'MA', name: 'Mastercard Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'PG', name: 'Procter & Gamble', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'UNH', name: 'UnitedHealth Group', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'HD', name: 'Home Depot Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'DIS', name: 'Walt Disney Company', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'PYPL', name: 'PayPal Holdings', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'ADBE', name: 'Adobe Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'NFLX', name: 'Netflix Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'CRM', name: 'Salesforce Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'INTC', name: 'Intel Corporation', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'AMD', name: 'Advanced Micro Devices', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'CSCO', name: 'Cisco Systems', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'PEP', name: 'PepsiCo Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'KO', name: 'Coca-Cola Company', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'COST', name: 'Costco Wholesale', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'AVGO', name: 'Broadcom Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'TMO', name: 'Thermo Fisher Scientific', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'ABT', name: 'Abbott Laboratories', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'MRK', name: 'Merck & Co.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'LLY', name: 'Eli Lilly and Company', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'ORCL', name: 'Oracle Corporation', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'ACN', name: 'Accenture plc', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'NKE', name: 'Nike Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'XOM', name: 'Exxon Mobil Corp.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'CVX', name: 'Chevron Corporation', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'QCOM', name: 'QUALCOMM Inc.', type: AssetType.stock, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'T', name: 'AT&T Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'VZ', name: 'Verizon Communications', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'BA', name: 'Boeing Company', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'CAT', name: 'Caterpillar Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'GS', name: 'Goldman Sachs Group', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'MS', name: 'Morgan Stanley', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'SQ', name: 'Block Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'SHOP', name: 'Shopify Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'UBER', name: 'Uber Technologies', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'SNAP', name: 'Snap Inc.', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'SPOT', name: 'Spotify Technology', type: AssetType.stock, exchange: 'NYSE'),
    SymbolInfo(symbol: 'PLTR', name: 'Palantir Technologies', type: AssetType.stock, exchange: 'NYSE'),
  ];

  // ---------------------------------------------------------------------------
  // ETF Catalog (~15 popular ETFs)
  // ---------------------------------------------------------------------------
  static const _etfs = <SymbolInfo>[
    SymbolInfo(symbol: 'SPY', name: 'SPDR S&P 500 ETF', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'QQQ', name: 'Invesco QQQ Trust', type: AssetType.etf, exchange: 'NASDAQ'),
    SymbolInfo(symbol: 'VTI', name: 'Vanguard Total Stock Market', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'VOO', name: 'Vanguard S&P 500', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'IWM', name: 'iShares Russell 2000', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'VEA', name: 'Vanguard FTSE Developed', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'VWO', name: 'Vanguard FTSE Emerging', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'BND', name: 'Vanguard Total Bond Market', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'GLD', name: 'SPDR Gold Shares', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'AGG', name: 'iShares Core US Aggregate', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'ARKK', name: 'ARK Innovation ETF', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'XLF', name: 'Financial Select Sector', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'XLK', name: 'Technology Select Sector', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'DIA', name: 'SPDR Dow Jones Industrial', type: AssetType.etf, exchange: 'NYSE'),
    SymbolInfo(symbol: 'EEM', name: 'iShares MSCI Emerging Markets', type: AssetType.etf, exchange: 'NYSE'),
  ];

  // ---------------------------------------------------------------------------
  // Crypto Catalog (~30 popular cryptocurrencies)
  // ---------------------------------------------------------------------------
  static const _cryptos = <SymbolInfo>[
    SymbolInfo(symbol: 'BTC', name: 'Bitcoin', type: AssetType.crypto),
    SymbolInfo(symbol: 'ETH', name: 'Ethereum', type: AssetType.crypto),
    SymbolInfo(symbol: 'BNB', name: 'BNB', type: AssetType.crypto),
    SymbolInfo(symbol: 'SOL', name: 'Solana', type: AssetType.crypto),
    SymbolInfo(symbol: 'XRP', name: 'Ripple', type: AssetType.crypto),
    SymbolInfo(symbol: 'ADA', name: 'Cardano', type: AssetType.crypto),
    SymbolInfo(symbol: 'DOGE', name: 'Dogecoin', type: AssetType.crypto),
    SymbolInfo(symbol: 'AVAX', name: 'Avalanche', type: AssetType.crypto),
    SymbolInfo(symbol: 'DOT', name: 'Polkadot', type: AssetType.crypto),
    SymbolInfo(symbol: 'MATIC', name: 'Polygon', type: AssetType.crypto),
    SymbolInfo(symbol: 'LINK', name: 'Chainlink', type: AssetType.crypto),
    SymbolInfo(symbol: 'UNI', name: 'Uniswap', type: AssetType.crypto),
    SymbolInfo(symbol: 'SHIB', name: 'Shiba Inu', type: AssetType.crypto),
    SymbolInfo(symbol: 'LTC', name: 'Litecoin', type: AssetType.crypto),
    SymbolInfo(symbol: 'ATOM', name: 'Cosmos', type: AssetType.crypto),
    SymbolInfo(symbol: 'XLM', name: 'Stellar', type: AssetType.crypto),
    SymbolInfo(symbol: 'ALGO', name: 'Algorand', type: AssetType.crypto),
    SymbolInfo(symbol: 'FTM', name: 'Fantom', type: AssetType.crypto),
    SymbolInfo(symbol: 'NEAR', name: 'NEAR Protocol', type: AssetType.crypto),
    SymbolInfo(symbol: 'APE', name: 'ApeCoin', type: AssetType.crypto),
    SymbolInfo(symbol: 'ICP', name: 'Internet Computer', type: AssetType.crypto),
    SymbolInfo(symbol: 'FIL', name: 'Filecoin', type: AssetType.crypto),
    SymbolInfo(symbol: 'AAVE', name: 'Aave', type: AssetType.crypto),
    SymbolInfo(symbol: 'GRT', name: 'The Graph', type: AssetType.crypto),
    SymbolInfo(symbol: 'SAND', name: 'The Sandbox', type: AssetType.crypto),
    SymbolInfo(symbol: 'MANA', name: 'Decentraland', type: AssetType.crypto),
    SymbolInfo(symbol: 'AXS', name: 'Axie Infinity', type: AssetType.crypto),
    SymbolInfo(symbol: 'CRO', name: 'Cronos', type: AssetType.crypto),
    SymbolInfo(symbol: 'OP', name: 'Optimism', type: AssetType.crypto),
    SymbolInfo(symbol: 'ARB', name: 'Arbitrum', type: AssetType.crypto),
  ];
}

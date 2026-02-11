import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Resolves the correct icon/logo for a given asset based on its type and symbol.
///
/// Resolution chain (with fallback):
/// 1. Crypto symbol -> CoinGecko CDN image
/// 2. Stock/ETF symbol -> Clearbit Logo API image
/// 3. Known asset type -> Material icon with type-specific color
/// 4. Fallback -> Colored circle with name initials
class AssetIconResolver extends StatelessWidget {
  final String? symbol;
  final AssetType assetType;
  final String name;
  final double size;

  const AssetIconResolver({
    super.key,
    required this.symbol,
    required this.assetType,
    required this.name,
    this.size = 40,
  });

  // ---------------------------------------------------------------------------
  // Crypto symbol -> CoinGecko CDN image URLs (T-12.4.2)
  // ---------------------------------------------------------------------------
  static const _cryptoImageUrls = <String, String>{
    'BTC':
        'https://assets.coingecko.com/coins/images/1/small/bitcoin.png',
    'ETH':
        'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
    'SOL':
        'https://assets.coingecko.com/coins/images/4128/small/solana.png',
    'BNB':
        'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
    'XRP':
        'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
    'ADA':
        'https://assets.coingecko.com/coins/images/975/small/cardano.png',
    'DOGE':
        'https://assets.coingecko.com/coins/images/5/small/dogecoin.png',
    'DOT':
        'https://assets.coingecko.com/coins/images/12171/small/polkadot.png',
    'AVAX':
        'https://assets.coingecko.com/coins/images/12559/small/Avalanche_Circle_RedWhite_Trans.png',
    'MATIC':
        'https://assets.coingecko.com/coins/images/4713/small/polygon.png',
    'POL':
        'https://assets.coingecko.com/coins/images/4713/small/polygon.png',
    'LINK':
        'https://assets.coingecko.com/coins/images/877/small/chainlink-new-logo.png',
    'UNI':
        'https://assets.coingecko.com/coins/images/12504/small/uniswap-logo.png',
    'LTC':
        'https://assets.coingecko.com/coins/images/2/small/litecoin.png',
    'SHIB':
        'https://assets.coingecko.com/coins/images/11939/small/shiba.png',
    'ATOM':
        'https://assets.coingecko.com/coins/images/1481/small/cosmos_hub.png',
  };

  // ---------------------------------------------------------------------------
  // Stock symbol -> company domain for Clearbit Logo API (T-12.4.3)
  // ---------------------------------------------------------------------------
  static const _symbolToDomain = <String, String>{
    'AAPL': 'apple.com',
    'GOOGL': 'google.com',
    'GOOG': 'google.com',
    'META': 'meta.com',
    'MSFT': 'microsoft.com',
    'AMZN': 'amazon.com',
    'TSLA': 'tesla.com',
    'NVDA': 'nvidia.com',
    'JPM': 'jpmorganchase.com',
    'V': 'visa.com',
    'MA': 'mastercard.com',
    'DIS': 'thewaltdisneycompany.com',
    'NFLX': 'netflix.com',
    'PYPL': 'paypal.com',
    'INTC': 'intel.com',
    'AMD': 'amd.com',
    'CRM': 'salesforce.com',
    'ORCL': 'oracle.com',
    'CSCO': 'cisco.com',
    'IBM': 'ibm.com',
    'BA': 'boeing.com',
    'WMT': 'walmart.com',
    'KO': 'coca-cola.com',
    'PEP': 'pepsico.com',
    'MCD': 'mcdonalds.com',
    'NKE': 'nike.com',
    'ADBE': 'adobe.com',
    'UBER': 'uber.com',
    'ABNB': 'airbnb.com',
    'SNAP': 'snap.com',
    'SQ': 'squareup.com',
    'SPOT': 'spotify.com',
    'SHOP': 'shopify.com',
    'ZM': 'zoom.us',
    'COIN': 'coinbase.com',
  };

  // ---------------------------------------------------------------------------
  // Type-specific icon and color mappings
  // ---------------------------------------------------------------------------
  static const _bitcoinOrange = Color(0xFFF7931A);
  static const _goldColor = Color(0xFFFFD700);
  static const _realEstateGreen = Color(0xFF4CAF50);
  static const _cashCyan = Color(0xFF00BCD4);

  static IconData _getTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return Icons.show_chart;
      case AssetType.etf:
        return Icons.pie_chart;
      case AssetType.bond:
        return Icons.receipt_long;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.realEstate:
        return Icons.home;
      case AssetType.gold:
        return Icons.diamond;
      case AssetType.cash:
        return Icons.account_balance_wallet;
      case AssetType.other:
        return Icons.business;
    }
  }

  static Color _getTypeColor(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return AppTheme.electricBlue;
      case AssetType.etf:
        return AppTheme.purpleAccent;
      case AssetType.bond:
        return AppTheme.accentBlue;
      case AssetType.crypto:
        return _bitcoinOrange;
      case AssetType.realEstate:
        return _realEstateGreen;
      case AssetType.gold:
        return _goldColor;
      case AssetType.cash:
        return _cashCyan;
      case AssetType.other:
        return AppTheme.textGrey;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final upperSymbol = symbol?.toUpperCase() ?? '';

    // 1. Crypto with known image URL
    if (assetType == AssetType.crypto && _cryptoImageUrls.containsKey(upperSymbol)) {
      return _networkIcon(
        imageUrl: _cryptoImageUrls[upperSymbol]!,
        backgroundColor: AppTheme.deepBlue,
      );
    }

    // 2. Stock/ETF with known company domain
    if ((assetType == AssetType.stock || assetType == AssetType.etf) &&
        _symbolToDomain.containsKey(upperSymbol)) {
      final domain = _symbolToDomain[upperSymbol]!;
      return _networkIcon(
        imageUrl: 'https://logo.clearbit.com/$domain?size=80',
        backgroundColor: Colors.white,
      );
    }

    // 3. Known type without specific logo -> type icon
    if (assetType != AssetType.other || upperSymbol.isEmpty) {
      return _typeIcon();
    }

    // 4. Fallback -> initials
    return _initialsFallback();
  }

  /// Builds a circular network image with loading/error fallback.
  Widget _networkIcon({
    required String imageUrl,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Container(
          color: backgroundColor,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: size,
            height: size,
            fit: BoxFit.contain,
            placeholder: (_, __) => _typeIcon(),
            errorWidget: (_, __, ___) => _initialsFallback(),
            fadeInDuration: const Duration(milliseconds: 200),
          ),
        ),
      ),
    );
  }

  /// Builds a type-specific Material icon inside a colored circle.
  Widget _typeIcon() {
    final color = _getTypeColor(assetType);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getTypeIcon(assetType),
        color: color,
        size: size * 0.5,
      ),
    );
  }

  /// Builds a colored circle with the first 1-2 initials of the asset name.
  Widget _initialsFallback() {
    final initials = name.length >= 2
        ? '${name[0]}${name[1]}'.toUpperCase()
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');
    final color = _colorFromName(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Generates a deterministic color from a name string via simple hash.
  static Color _colorFromName(String name) {
    const palette = [
      AppTheme.electricBlue,
      AppTheme.emeraldAccent,
      AppTheme.purpleAccent,
      AppTheme.accentBlue,
      Color(0xFFF7931A), // orange
      Color(0xFF4CAF50), // green
      Color(0xFFE91E63), // pink
      Color(0xFF00BCD4), // cyan
    ];
    final hash = name.codeUnits.fold<int>(0, (sum, c) => sum + c);
    return palette[hash % palette.length];
  }
}

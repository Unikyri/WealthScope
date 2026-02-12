import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Shared utilities for asset type icon and color resolution.
///
/// Used across AssetIconResolver, allocation legend, asset type cards,
/// and filter chips to ensure consistent visual treatment of asset types.
/// Fallback chain for individual assets: crypto/stock logo -> type icon -> initials.
class AssetTypeUtils {
  AssetTypeUtils._();

  static const _bitcoinOrange = Color(0xFFF7931A);
  static const _goldColor = Color(0xFFFFD700);
  static const _realEstateGreen = Color(0xFF4CAF50);
  static const _cashCyan = Color(0xFF00BCD4);

  /// Returns the Material icon for the given asset type.
  static IconData getTypeIcon(AssetType type) {
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
      case AssetType.cash:
        return Icons.account_balance_wallet;
      case AssetType.custom:
        return Icons.category;
      case AssetType.liability:
        return Icons.money_off; 
    }
  }

  /// Returns the theme color for the given asset type.
  static Color getTypeColor(AssetType type) {
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
      case AssetType.cash:
        return _cashCyan;
      case AssetType.custom:
        return AppTheme.textGrey;
      case AssetType.liability:
        return AppTheme.errorRed;
    }
  }
}

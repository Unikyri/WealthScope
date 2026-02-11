import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Rich visual card for selecting an asset type.
///
/// Displays a colored icon, type name, and short description.
/// Used in the asset type selection grid (Step 1 of Add Asset flow).
class AssetTypeSelectorCard extends StatelessWidget {
  const AssetTypeSelectorCard({
    required this.type,
    required this.onTap,
    super.key,
  });

  final AssetType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = getTypeColor(type);
    final icon = getTypeIcon(type);
    final description = getTypeDescription(type);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with colored circular background
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                // Type name
                Text(
                  type.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static IconData getTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return Icons.trending_up;
      case AssetType.etf:
        return Icons.pie_chart;
      case AssetType.bond:
        return Icons.receipt_long;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.realEstate:
        return Icons.home_rounded;
      case AssetType.gold:
        return Icons.diamond;
      case AssetType.cash:
        return Icons.account_balance_wallet;
      case AssetType.other:
        return Icons.category;
    }
  }

  static Color getTypeColor(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return AppTheme.electricBlue;
      case AssetType.etf:
        return AppTheme.purpleAccent;
      case AssetType.bond:
        return const Color(0xFF4CAF50);
      case AssetType.crypto:
        return const Color(0xFFF7931A);
      case AssetType.realEstate:
        return const Color(0xFF009688);
      case AssetType.gold:
        return const Color(0xFFFFD700);
      case AssetType.cash:
        return const Color(0xFF00BCD4);
      case AssetType.other:
        return AppTheme.textGrey;
    }
  }

  static String getTypeDescription(AssetType type) {
    switch (type) {
      case AssetType.stock:
        return 'Company shares';
      case AssetType.etf:
        return 'Exchange-traded funds';
      case AssetType.bond:
        return 'Fixed income';
      case AssetType.crypto:
        return 'Cryptocurrencies';
      case AssetType.realEstate:
        return 'Properties';
      case AssetType.gold:
        return 'Precious metals';
      case AssetType.cash:
        return 'Savings & deposits';
      case AssetType.other:
        return 'Other assets';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/utils/asset_type_utils.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';

/// Rich visual card for selecting an asset type.
///
/// Displays a colored icon, type name, and short description.
/// Used in the asset type selection grid (Step 1 of Add Asset flow).
/// Supports premium badge and locked state for Sentinel-only asset types.
class AssetTypeSelectorCard extends StatelessWidget {
  const AssetTypeSelectorCard({
    required this.type,
    required this.onTap,
    this.isPremiumType = false,
    this.isLocked = false,
    super.key,
  });

  final AssetType type;
  final VoidCallback onTap;

  /// Whether this asset type is a premium (Sentinel) exclusive.
  final bool isPremiumType;

  /// Whether the card is locked (Scout user + premium type).
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final color = AssetTypeUtils.getTypeColor(type);
    final icon = AssetTypeUtils.getTypeIcon(type);
    final description = getTypeDescription(type);

    return Stack(
      children: [
        Opacity(
          opacity: isLocked ? 0.5 : 1.0,
          child: Container(
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
          ),
        ),

        // PRO badge for premium asset types
        if (isPremiumType)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.electricBlue, AppTheme.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        // Lock icon overlay for locked types
        if (isLocked)
          Positioned(
            bottom: 8,
            right: 8,
            child: Icon(
              Icons.lock_outline,
              size: 16,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }

  static IconData getTypeIcon(AssetType type) => AssetTypeUtils.getTypeIcon(type);
  static Color getTypeColor(AssetType type) => AssetTypeUtils.getTypeColor(type);

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

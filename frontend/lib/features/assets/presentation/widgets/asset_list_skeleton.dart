import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Asset List Skeleton
/// Displays shimmer loading effect while assets are being fetched.
/// Matches the exact structure of AssetCard for a seamless transition.
class AssetListSkeleton extends StatelessWidget {
  const AssetListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Show 5 placeholder cards
      itemBuilder: (context, index) => const AssetCardSkeleton(),
    );
  }
}

/// Asset Card Skeleton
/// Individual skeleton card that matches AssetCard structure.
/// Features animated shimmer effect for a polished loading experience.
class AssetCardSkeleton extends StatelessWidget {
  const AssetCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surfaceContainerHighest;
    final highlightColor = theme.colorScheme.surfaceContainerLow;
    final shimmerColor = theme.colorScheme.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Asset Type Icon Placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Asset Information Placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Asset Name Placeholder
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Quantity Placeholder
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Value and Performance Placeholders
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Percentage Change Placeholder
                    Container(
                      width: 50,
                      height: 14,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Total Value Placeholder
                    Container(
                      width: 70,
                      height: 16,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

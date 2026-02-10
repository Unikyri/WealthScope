import 'package:flutter/material.dart';

/// Top Assets Section Widget
/// DEPRECATED: TopAsset entity removed from API
/// This widget is kept for backward compatibility but returns empty widget
class TopAssetsSection extends StatelessWidget {
  final List<dynamic> topAssets;

  const TopAssetsSection({
    super.key,
    required this.topAssets,
  });

  @override
  Widget build(BuildContext context) {
    // TopAsset no longer exists in API response
    // Return empty widget for now
    return const SizedBox.shrink();
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer Box
/// Reusable shimmer placeholder component with theme-aware colors.
/// Used to create skeleton loading UI elements throughout the app.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Theme-aware shimmer colors
    final baseColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerHighest;
    final highlightColor = isDark
        ? theme.colorScheme.surfaceContainerLow
        : theme.colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer Container
/// Wrapper that applies shimmer effect to child widgets.
/// Use this when you have a complex skeleton structure.
class ShimmerContainer extends StatelessWidget {
  final Widget child;

  const ShimmerContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerHighest;
    final highlightColor = isDark
        ? theme.colorScheme.surfaceContainerLow
        : theme.colorScheme.surface;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}

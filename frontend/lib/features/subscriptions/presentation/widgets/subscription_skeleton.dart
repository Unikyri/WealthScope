import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/shared/widgets/shimmer_box.dart';

/// Subscription Skeleton
/// Displays shimmer skeleton for subscription/paywall screen loading state.
/// Matches the structure of SubscriptionScreen paywall layout.
class SubscriptionSkeleton extends StatelessWidget {
  const SubscriptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerColor = theme.colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.midnightBlue,
        elevation: 0,
        leading: const SizedBox.shrink(),
        title: Container(
          width: 140,
          height: 20,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      body: ShimmerContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero section placeholder (crown/icon)
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title placeholder
              Center(
                child: Container(
                  width: 180,
                  height: 28,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle placeholder
              Center(
                child: Container(
                  width: 260,
                  height: 18,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Features list placeholders
              ...List.generate(4, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 32),

              // "Elige tu plan" placeholder
              Container(
                width: 140,
                height: 24,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              // Package cards placeholders
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 24),

              // CTA button placeholder
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),

              // Restore link placeholder
              Center(
                child: Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

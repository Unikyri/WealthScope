import 'package:flutter/material.dart';

/// Reusable logo widget for splash screen
///
/// Displays the WealthScope app logo with consistent styling
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: 80,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'WealthScope',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Empty Assets View
/// Displayed when the user has no assets in their portfolio
class EmptyAssetsView extends StatelessWidget {
  const EmptyAssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty portfolio illustration
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 120,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              'You don\'t have any assets yet',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Subtitle/Description
            Text(
              'Start by adding your first investment to see your portfolio here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // CTA Button
            ElevatedButton.icon(
              onPressed: () => context.push('/assets/select-type'),
              icon: const Icon(Icons.add),
              label: const Text('Add my first asset'),
            ),
          ],
        ),
      ),
    );
  }
}

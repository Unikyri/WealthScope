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
            // Illustration/Icon
            Icon(
              Icons.wallet_outlined,
              size: 120,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              'No Assets Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              'Start building your portfolio by adding your first asset',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // CTA Button
            FilledButton.icon(
              onPressed: () => context.push('/assets/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add First Asset'),
            ),
          ],
        ),
      ),
    );
  }
}

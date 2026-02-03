import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';

/// Extracted Assets Screen
/// Displays assets extracted from a document
/// TODO: Implement full functionality to review and add extracted assets
class ExtractedAssetsScreen extends ConsumerWidget {
  final OcrResult result;

  const ExtractedAssetsScreen({
    required this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extracted Assets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Success header
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Processed',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'Found ${result.extractedAssets.length} assets',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Extracted assets list
          ...result.extractedAssets.map(
            (asset) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.trending_up,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                title: Text(asset.name),
                subtitle: asset.symbol != null
                    ? Text(asset.symbol!)
                    : null,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (asset.value != null)
                      Text(
                        '\$${asset.value!.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (asset.quantity != null)
                      Text(
                        '${asset.quantity} shares',
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          FilledButton.icon(
            onPressed: () {
              // TODO: Implement bulk add to portfolio
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add All to Portfolio'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

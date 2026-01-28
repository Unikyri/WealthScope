import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_detail_header.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_info_section.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_metadata_section.dart';

/// Asset Detail Screen
/// Displays complete information about a specific asset including
/// header with large icon and price, investment details, and type-specific metadata
class AssetDetailScreen extends ConsumerWidget {
  final String assetId;
  
  const AssetDetailScreen({
    required this.assetId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assetAsync = ref.watch(assetDetailProvider(assetId));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asset Details',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit screen
              context.push('/assets/$assetId/edit');
            },
            tooltip: 'Edit Asset',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
            tooltip: 'Delete Asset',
          ),
        ],
      ),
      body: assetAsync.when(
        data: (asset) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with large icon, name, symbol, current price, daily change
                AssetDetailHeader(asset: asset),
                const SizedBox(height: 24),
                
                // Investment details section
                AssetInfoSection(asset: asset),
                const SizedBox(height: 24),
                
                // Type-specific metadata
                AssetMetadataSection(asset: asset),
              ],
            ),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading asset',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(assetDetailProvider(assetId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Asset'),
        content: const Text(
          'Are you sure you want to delete this asset? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              
              // Show loading indicator
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deleting asset...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
              
              try {
                // TODO: Implement delete functionality via repository
                // await ref.read(assetRepositoryProvider).deleteAsset(assetId);
                
                // Invalidate the assets list to refresh
                ref.invalidate(allAssetsProvider);
                
                if (context.mounted) {
                  // Navigate back
                  context.pop();
                  
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Asset deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete asset: $e'),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

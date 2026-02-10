import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ocr_provider.dart';

/// Extracted Assets Screen
/// Review, edit, and confirm extracted assets from documents
class ExtractedAssetsScreen extends ConsumerStatefulWidget {
  final OcrResult result;

  const ExtractedAssetsScreen({
    required this.result,
    super.key,
  });

  @override
  ConsumerState<ExtractedAssetsScreen> createState() =>
      _ExtractedAssetsScreenState();
}

class _ExtractedAssetsScreenState extends ConsumerState<ExtractedAssetsScreen> {
  late List<ExtractedAsset> _assets;
  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    _assets = List.from(widget.result.extractedAssets);
    // Select all by default
    _selectedIndices.addAll(List.generate(_assets.length, (i) => i));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Extracted Assets'),
        actions: [
          TextButton(
            onPressed: _selectedIndices.isEmpty ? null : _confirmAssets,
            child: const Text('Import'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Document info card
          if (widget.result.rawData != null)
            _DocumentInfoCard(
              documentType: widget.result.documentType,
              rawData: widget.result.rawData!,
            ),

          // Select all toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_selectedIndices.length} of ${_assets.length} selected',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedIndices.length == _assets.length) {
                        _selectedIndices.clear();
                      } else {
                        _selectedIndices
                            .addAll(List.generate(_assets.length, (i) => i));
                      }
                    });
                  },
                  child: Text(
                    _selectedIndices.length == _assets.length
                        ? 'Deselect All'
                        : 'Select All',
                  ),
                ),
              ],
            ),
          ),

          // Assets list
          Expanded(
            child: _assets.isEmpty
                ? const _NoAssetsFound()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _assets.length,
                    itemBuilder: (context, index) {
                      final asset = _assets[index];
                      return _ExtractedAssetCard(
                        asset: asset,
                        isSelected: _selectedIndices.contains(index),
                        onToggle: () {
                          setState(() {
                            if (_selectedIndices.contains(index)) {
                              _selectedIndices.remove(index);
                            } else {
                              _selectedIndices.add(index);
                            }
                          });
                        },
                        onEdit: () => _editAsset(index),
                        onDelete: () => _deleteAsset(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAssets() async {
    final selectedAssets = _selectedIndices.map((i) => _assets[i]).toList();

    try {
      await ref.read(ocrProvider.notifier).confirmAssets(selectedAssets);

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${selectedAssets.length} assets imported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing assets: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editAsset(int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditAssetSheet(
        asset: _assets[index],
        onSave: (edited) {
          setState(() {
            _assets[index] = edited;
          });
        },
      ),
    );
  }

  void _deleteAsset(int index) {
    setState(() {
      _selectedIndices.remove(index);
      _assets.removeAt(index);

      // Adjust remaining indices
      final newIndices = <int>{};
      for (final i in _selectedIndices) {
        if (i < index) {
          newIndices.add(i);
        } else if (i > index) {
          newIndices.add(i - 1);
        }
      }
      _selectedIndices
        ..clear()
        ..addAll(newIndices);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Asset deleted')),
    );
  }
}

// ============================================================================
// Supporting Widgets
// ============================================================================

class _DocumentInfoCard extends StatelessWidget {
  final String documentType;
  final Map<String, dynamic> rawData;

  const _DocumentInfoCard({
    required this.documentType,
    required this.rawData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filename = rawData['filename'] as String?;
    final processedAt = rawData['processed_at'] as String?;

    return Card(
      margin: const EdgeInsets.all(16),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Document: ${filename ?? 'Unknown'}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${_formatDocumentType(documentType)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            if (processedAt != null)
              Text(
                'Processed: ${_formatDateTime(processedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDocumentType(String type) {
    return type.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatDateTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }
}

class _NoAssetsFound extends StatelessWidget {
  const _NoAssetsFound();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No assets found',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try uploading a different document',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtractedAssetCard extends StatelessWidget {
  final ExtractedAsset asset;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExtractedAssetCard({
    required this.asset,
    required this.isSelected,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: (_) => onToggle(),
              ),
              const SizedBox(width: 8),

              // Asset info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            asset.name,
                            style: theme.textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (asset.symbol != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              asset.symbol!,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _buildAssetDetails(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ConfidenceIndicator(confidence: asset.confidence),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
                tooltip: 'Edit asset',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
                color: theme.colorScheme.error,
                tooltip: 'Delete asset',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildAssetDetails() {
    final parts = <String>[];

    if (asset.assetType != null) {
      parts.add(asset.assetType!);
    }

    if (asset.quantity != null) {
      parts.add('${asset.quantity} units');
    }

    if (asset.value != null) {
      parts.add('\$${asset.value!.toStringAsFixed(2)}');
    }

    return parts.join(' • ');
  }
}

class _ConfidenceIndicator extends StatelessWidget {
  final double confidence;

  const _ConfidenceIndicator({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = confidence >= 0.7
        ? Colors.green
        : confidence >= 0.5
            ? Colors.orange
            : Colors.red;

    return Row(
      children: [
        Text(
          'Confidence: ',
          style: theme.textTheme.bodySmall,
        ),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: confidence.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(confidence * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EditAssetSheet extends StatefulWidget {
  final ExtractedAsset asset;
  final ValueChanged<ExtractedAsset> onSave;

  const _EditAssetSheet({
    required this.asset,
    required this.onSave,
  });

  @override
  State<_EditAssetSheet> createState() => _EditAssetSheetState();
}

class _EditAssetSheetState extends State<_EditAssetSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _symbolController;
  late final TextEditingController _quantityController;
  late final TextEditingController _valueController;
  late final TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.asset.name);
    _symbolController = TextEditingController(text: widget.asset.symbol ?? '');
    _quantityController = TextEditingController(
      text: widget.asset.quantity?.toString() ?? '',
    );
    _valueController = TextEditingController(
      text: widget.asset.value?.toString() ?? '',
    );
    _typeController = TextEditingController(
      text: widget.asset.assetType ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    _valueController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Asset',
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Form fields
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Asset Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _symbolController,
              decoration: const InputDecoration(
                labelText: 'Symbol (Optional)',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Asset Type (Optional)',
                border: OutlineInputBorder(),
                hintText: 'e.g., stock, bond, crypto',
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save button
            FilledButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final edited = ExtractedAsset(
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim().isEmpty
          ? null
          : _symbolController.text.trim().toUpperCase(),
      quantity: double.tryParse(_quantityController.text),
      value: double.tryParse(_valueController.text),
      assetType: _typeController.text.trim().isEmpty
          ? null
          : _typeController.text.trim(),
      confidence: widget.asset.confidence,
    );

    widget.onSave(edited);
    Navigator.of(context).pop();
  }
}

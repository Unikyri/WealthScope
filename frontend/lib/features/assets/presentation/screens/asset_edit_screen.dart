import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/core/utils/asset_validators.dart';
import 'package:wealthscope_app/core/utils/snackbar_utils.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';

/// Asset Edit Screen
/// Allows editing an existing asset by pre-populating the form with current data
class AssetEditScreen extends ConsumerStatefulWidget {
  final String assetId;

  const AssetEditScreen({
    required this.assetId,
    super.key,
  });

  @override
  ConsumerState<AssetEditScreen> createState() => _AssetEditScreenState();
}

class _AssetEditScreenState extends ConsumerState<AssetEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Asset type icons mapping
  static const Map<AssetType, IconData> _assetTypeIcons = {
    AssetType.stock: Icons.trending_up,
    AssetType.etf: Icons.pie_chart,
    AssetType.realEstate: Icons.home,
    AssetType.gold: Icons.diamond,
    AssetType.bond: Icons.account_balance,
    AssetType.crypto: Icons.currency_bitcoin,
    AssetType.other: Icons.category,
  };
  
  late TextEditingController _symbolController;
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;
  
  // Metadata controllers
  late TextEditingController _exchangeController;
  late TextEditingController _sectorController;
  late TextEditingController _industryController;
  late TextEditingController _metalTypeController;
  late TextEditingController _purityController;
  late TextEditingController _weightController;
  late TextEditingController _addressController;
  late TextEditingController _areaController;
  
  DateTime? _selectedDate;
  Currency _selectedCurrency = Currency.usd;
  bool _isLoading = false;
  StockAsset? _originalAsset;

  @override
  void initState() {
    super.initState();
    _initControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssetData();
    });
  }

  void _initControllers() {
    _symbolController = TextEditingController();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    _notesController = TextEditingController();
    _exchangeController = TextEditingController();
    _sectorController = TextEditingController();
    _industryController = TextEditingController();
    _metalTypeController = TextEditingController();
    _purityController = TextEditingController();
    _weightController = TextEditingController();
    _addressController = TextEditingController();
    _areaController = TextEditingController();
  }

  void _loadAssetData() {
    final assetAsync = ref.read(assetDetailProvider(widget.assetId));
    
    assetAsync.whenData((asset) {
      if (asset != null && mounted) {
        setState(() {
          _originalAsset = asset;
          
          // Basic fields
          _symbolController.text = asset.symbol;
          _nameController.text = asset.name;
          _quantityController.text = asset.quantity.toString();
          _priceController.text = asset.purchasePrice.toString();
          _notesController.text = asset.notes ?? '';
          _selectedDate = asset.purchaseDate;
          _selectedCurrency = asset.currency;
          
          // Metadata fields based on type
          final metadata = asset.metadata;
          
          // Stock/ETF metadata
          if (metadata['exchange'] != null) {
            _exchangeController.text = metadata['exchange'].toString();
          }
          if (metadata['sector'] != null) {
            _sectorController.text = metadata['sector'].toString();
          }
          if (metadata['industry'] != null) {
            _industryController.text = metadata['industry'].toString();
          }
          
          // Gold/Precious Metals metadata
          if (metadata['metal_type'] != null) {
            _metalTypeController.text = metadata['metal_type'].toString();
          }
          if (metadata['purity'] != null) {
            _purityController.text = metadata['purity'].toString();
          }
          if (metadata['weight_grams'] != null) {
            _weightController.text = metadata['weight_grams'].toString();
          }
          
          // Real Estate metadata
          if (metadata['address'] != null) {
            _addressController.text = metadata['address'].toString();
          }
          if (metadata['area_sqm'] != null) {
            _areaController.text = metadata['area_sqm'].toString();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _exchangeController.dispose();
    _sectorController.dispose();
    _industryController.dispose();
    _metalTypeController.dispose();
    _purityController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_originalAsset == null) {
      SnackbarUtils.showError(context, 'Asset data not loaded');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Build metadata based on asset type
      final metadata = <String, dynamic>{};
      
      if (_originalAsset!.type == AssetType.stock || 
          _originalAsset!.type == AssetType.etf) {
        if (_exchangeController.text.isNotEmpty) {
          metadata['exchange'] = _exchangeController.text.trim();
        }
        if (_sectorController.text.isNotEmpty) {
          metadata['sector'] = _sectorController.text.trim();
        }
        if (_industryController.text.isNotEmpty) {
          metadata['industry'] = _industryController.text.trim();
        }
      } else if (_originalAsset!.type == AssetType.gold) {
        if (_metalTypeController.text.isNotEmpty) {
          metadata['metal_type'] = _metalTypeController.text.trim();
        }
        if (_purityController.text.isNotEmpty) {
          metadata['purity'] = double.tryParse(_purityController.text);
        }
        if (_weightController.text.isNotEmpty) {
          metadata['weight_grams'] = double.tryParse(_weightController.text);
        }
      } else if (_originalAsset!.type == AssetType.realEstate) {
        if (_addressController.text.isNotEmpty) {
          metadata['address'] = _addressController.text.trim();
        }
        if (_areaController.text.isNotEmpty) {
          metadata['area_sqm'] = double.tryParse(_areaController.text);
        }
      }
      
      // Create updated asset
      final updatedAsset = StockAsset(
        id: _originalAsset!.id,
        userId: _originalAsset!.userId,
        type: _originalAsset!.type,
        symbol: _symbolController.text.trim().toUpperCase(),
        name: _nameController.text.trim(),
        quantity: double.parse(_quantityController.text),
        purchasePrice: double.parse(_priceController.text),
        purchaseDate: _selectedDate,
        currency: _selectedCurrency,
        metadata: metadata,
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        // Preserve fields that shouldn't be edited
        currentPrice: _originalAsset!.currentPrice,
        currentValue: _originalAsset!.currentValue,
        lastPriceUpdate: _originalAsset!.lastPriceUpdate,
        isActive: _originalAsset!.isActive,
        createdAt: _originalAsset!.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final repository = ref.read(assetRepositoryProvider);
      await repository.updateAsset(updatedAsset);
      
      // Invalidate cache to refresh data
      ref.invalidate(assetDetailProvider(widget.assetId));
      ref.invalidate(allAssetsProvider);
      
      if (!mounted) return;
      
      SnackbarUtils.showSuccess(context, 'Asset updated successfully');
      context.pop();
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(
        context,
        'Failed to update asset: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assetAsync = ref.watch(assetDetailProvider(widget.assetId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Asset'),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _handleSave,
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      body: assetAsync.when(
        data: (asset) {
          if (asset == null) {
            return Center(
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
                    'Asset not found',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          
          return _buildForm(asset);
        },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(StockAsset asset) {
    final theme = Theme.of(context);
    
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Asset Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _assetTypeIcons[asset.type] ?? Icons.category,
                  size: 16,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  asset.type.displayName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Common Fields
          _buildSymbolField(asset),
          const SizedBox(height: 16),
          
          _buildNameField(),
          const SizedBox(height: 16),
          
          _buildQuantityField(),
          const SizedBox(height: 16),
          
          _buildPriceField(),
          const SizedBox(height: 16),
          
          _buildDateField(),
          const SizedBox(height: 16),
          
          _buildCurrencyField(),
          const SizedBox(height: 24),
          
          // Type-specific metadata
          ..._buildMetadataFields(asset),
          
          // Notes field
          _buildNotesField(),
          const SizedBox(height: 32),
          
          // Warning text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Changes will update your portfolio calculations',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolField(StockAsset asset) {
    return TextFormField(
      controller: _symbolController,
      decoration: const InputDecoration(
        labelText: 'Symbol',
        hintText: 'Enter symbol',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.label),
      ),
      textCapitalization: TextCapitalization.characters,
      validator: AssetValidators.validateSymbol,
      enabled: !_isLoading,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        hintText: 'Enter asset name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business),
      ),
      textCapitalization: TextCapitalization.words,
      validator: AssetValidators.validateName,
      enabled: !_isLoading,
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: const InputDecoration(
        labelText: 'Quantity',
        hintText: 'Enter quantity',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.numbers),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
      ],
      validator: AssetValidators.validateQuantity,
      enabled: !_isLoading,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        labelText: 'Purchase Price',
        hintText: 'Enter purchase price',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
        suffixText: _selectedCurrency.code,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: AssetValidators.validatePrice,
      enabled: !_isLoading,
    );
  }

  Widget _buildDateField() {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return InkWell(
      onTap: _isLoading ? null : _selectDate,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Purchase Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _selectedDate != null
              ? dateFormat.format(_selectedDate!)
              : 'Select date',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: _selectedDate != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyField() {
    return DropdownButtonFormField<Currency>(
      value: _selectedCurrency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
      ),
      items: Currency.values.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text('${currency.code} - ${currency.symbol}'),
        );
      }).toList(),
      onChanged: _isLoading
          ? null
          : (value) {
              if (value != null) {
                setState(() => _selectedCurrency = value);
              }
            },
    );
  }

  List<Widget> _buildMetadataFields(StockAsset asset) {
    final type = asset.type;
    
    if (type == AssetType.stock || type == AssetType.etf) {
      return [
        // Metadata Section Header
        Text(
          'Additional Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _exchangeController,
          decoration: const InputDecoration(
            labelText: 'Exchange (Optional)',
            hintText: 'e.g., NYSE, NASDAQ',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.currency_exchange),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _sectorController,
          decoration: const InputDecoration(
            labelText: 'Sector (Optional)',
            hintText: 'e.g., Technology, Healthcare',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _industryController,
          decoration: const InputDecoration(
            labelText: 'Industry (Optional)',
            hintText: 'e.g., Software, Pharmaceuticals',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business_center),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
      ];
    } else if (type == AssetType.gold) {
      return [
        Text(
          'Precious Metal Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _metalTypeController,
          decoration: const InputDecoration(
            labelText: 'Metal Type (Optional)',
            hintText: 'e.g., Gold, Silver, Platinum',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.diamond),
          ),
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _purityController,
          decoration: const InputDecoration(
            labelText: 'Purity (Optional)',
            hintText: 'e.g., 99.9',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.percent),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _weightController,
          decoration: const InputDecoration(
            labelText: 'Weight in Grams (Optional)',
            hintText: 'Enter weight',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.monitor_weight),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
      ];
    } else if (type == AssetType.realEstate) {
      return [
        Text(
          'Property Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address (Optional)',
            hintText: 'Enter property address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          maxLines: 2,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _areaController,
          decoration: const InputDecoration(
            labelText: 'Area in sqm (Optional)',
            hintText: 'Enter area',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.square_foot),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          enabled: !_isLoading,
        ),
        const SizedBox(height: 24),
      ];
    }
    
    return [];
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
        hintText: 'Add any additional notes',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.notes),
      ),
      maxLines: 3,
      enabled: !_isLoading,
    );
  }
}

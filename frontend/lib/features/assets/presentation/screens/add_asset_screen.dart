import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/utils/asset_validators.dart';
import 'package:wealthscope_app/core/utils/snackbar_utils.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/stock_form_provider.dart';

/// Generic Asset Form Screen
/// Provides a form for adding assets (Real Estate, Gold, Bond, Crypto, Cash, Other)
class AddAssetScreen extends ConsumerStatefulWidget {
  final AssetType? assetType;

  const AddAssetScreen({
    this.assetType,
    super.key,
  });

  @override
  ConsumerState<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends ConsumerState<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _currentPriceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  late AssetType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.assetType ?? AssetType.other;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _currentPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _title {
    switch (_selectedType) {
      case AssetType.realEstate:
        return 'New Real Estate';
      case AssetType.gold:
        return 'New Gold';
      case AssetType.bond:
        return 'New Bond';
      case AssetType.crypto:
        return 'New Cryptocurrency';
      case AssetType.cash:
        return 'New Cash';
      case AssetType.other:
        return 'New Asset';
      default:
        return 'New Asset';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      SnackbarUtils.showError(
          context, 'Authentication error. Please log in again.');
      return;
    }

    final currency = ref.read(selectedCurrencyProvider);

    final asset = StockAsset(
      userId: userId,
      type: _selectedType,
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim(),
      quantity: double.parse(_quantityController.text),
      purchasePrice: double.parse(_priceController.text),
      currentPrice: _currentPriceController.text.isNotEmpty
          ? double.parse(_currentPriceController.text)
          : null,
      purchaseDate: _selectedDate,
      currency: currency,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    await ref.read(stockFormProvider.notifier).submitForm(asset);

    final state = ref.read(stockFormProvider);

    if (!mounted) return;

    if (state.error != null) {
      SnackbarUtils.showError(context, state.error!);
    } else if (state.savedAsset != null) {
      SnackbarUtils.showSuccess(
        context,
        '${_selectedType.label} added successfully',
      );
      context.go('/assets');
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
    final formState = ref.watch(stockFormProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Asset Type Badge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getAssetIcon(_selectedType),
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedType.label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: _getNameLabel(_selectedType),
                hintText: _getNameHint(_selectedType),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label),
              ),
              textCapitalization: TextCapitalization.words,
              validator: AssetValidators.validateName,
            ),
            const SizedBox(height: 16),

            // Symbol Field (optional for most types)
            if (_selectedType != AssetType.realEstate &&
                _selectedType != AssetType.cash)
              TextFormField(
                controller: _symbolController,
                decoration: InputDecoration(
                  labelText: 'Symbol (Optional)',
                  hintText: _getSymbolHint(_selectedType),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.tag),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            if (_selectedType != AssetType.realEstate &&
                _selectedType != AssetType.cash)
              const SizedBox(height: 16),

            // Quantity Field
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: _getQuantityLabel(_selectedType),
                hintText: 'Enter quantity',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
              ],
              validator: AssetValidators.validateQuantity,
            ),
            const SizedBox(height: 16),

            // Purchase Price Field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: _getPriceLabel(_selectedType),
                hintText: 'Enter purchase price',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: selectedCurrency.code,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: AssetValidators.validatePrice,
            ),
            const SizedBox(height: 16),

            // Current Price Field (optional)
            TextFormField(
              controller: _currentPriceController,
              decoration: InputDecoration(
                labelText: 'Current Price (Optional)',
                hintText: 'Enter current market price',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.trending_up),
                suffixText: selectedCurrency.code,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 16),

            // Purchase Date Field
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Purchase Date (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                      : 'Select date',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Currency Selector
            DropdownButtonFormField<Currency>(
              value: selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Row(
                    children: [
                      Text(
                        currency.symbol,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text('${currency.code} - ${currency.name}'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  ref.read(selectedCurrencyProvider.notifier).state = currency;
                }
              },
            ),
            const SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any additional notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),

            // Submit Button
            FilledButton(
              onPressed: formState.isLoading ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: formState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Add ${_selectedType.label}',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAssetIcon(AssetType type) {
    switch (type) {
      case AssetType.realEstate:
        return Icons.home;
      case AssetType.gold:
        return Icons.diamond;
      case AssetType.bond:
        return Icons.account_balance;
      case AssetType.crypto:
        return Icons.currency_bitcoin;
      case AssetType.cash:
        return Icons.account_balance_wallet;
      case AssetType.other:
        return Icons.category;
      default:
        return Icons.attach_money;
    }
  }

  String _getNameLabel(AssetType type) {
    switch (type) {
      case AssetType.realEstate:
        return 'Property Name';
      case AssetType.gold:
        return 'Gold Product Name';
      case AssetType.bond:
        return 'Bond Name';
      case AssetType.crypto:
        return 'Cryptocurrency Name';
      case AssetType.cash:
        return 'Account Name';
      case AssetType.other:
        return 'Asset Name';
      default:
        return 'Asset Name';
    }
  }

  String _getNameHint(AssetType type) {
    switch (type) {
      case AssetType.realEstate:
        return 'e.g., Downtown Apartment';
      case AssetType.gold:
        return 'e.g., Gold Bullion';
      case AssetType.bond:
        return 'e.g., US Treasury Bond';
      case AssetType.crypto:
        return 'e.g., Bitcoin';
      case AssetType.cash:
        return 'e.g., Savings Account';
      case AssetType.other:
        return 'e.g., Collectible Art';
      default:
        return 'Enter name';
    }
  }

  String _getSymbolHint(AssetType type) {
    switch (type) {
      case AssetType.crypto:
        return 'e.g., BTC';
      case AssetType.bond:
        return 'e.g., ISIN code';
      case AssetType.gold:
        return 'e.g., XAU';
      default:
        return 'Enter symbol';
    }
  }

  String _getQuantityLabel(AssetType type) {
    switch (type) {
      case AssetType.realEstate:
        return 'Property Units';
      case AssetType.gold:
        return 'Weight (oz)';
      case AssetType.cash:
        return 'Amount';
      default:
        return 'Quantity';
    }
  }

  String _getPriceLabel(AssetType type) {
    switch (type) {
      case AssetType.realEstate:
        return 'Purchase Price per Unit';
      case AssetType.gold:
        return 'Price per Ounce';
      case AssetType.cash:
        return 'Initial Amount (use 1 for quantity)';
      default:
        return 'Purchase Price';
    }
  }
}

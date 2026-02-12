import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/utils/asset_validators.dart';
import 'package:wealthscope_app/core/utils/snackbar_utils.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/asset_form_submission_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/stock_form_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/symbol_search_field.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_card.dart';

/// Generic Asset Form Screen
/// Step 2 of the Add Asset flow.
/// Shows only the fields relevant for the selected asset type.
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
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  late AssetType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.assetType ?? AssetType.other;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stockFormProvider.notifier).reset();
      ref.read(assetFormSubmissionProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Visibility rules per asset type
  // ---------------------------------------------------------------------------
  bool get _showSymbol =>
      _selectedType == AssetType.crypto ||
      _selectedType == AssetType.bond ||
      _selectedType == AssetType.other;

  bool get _showQuantity => _selectedType != AssetType.realEstate;

  bool get _showPrice => _selectedType != AssetType.cash;

  bool get _showDate =>
      _selectedType != AssetType.cash;

  bool get _useSymbolSearch => _selectedType == AssetType.crypto;

  // ---------------------------------------------------------------------------
  // Dynamic labels
  // ---------------------------------------------------------------------------
  String get _quantityLabel {
    switch (_selectedType) {
      case AssetType.cash:
        return 'Amount';
      case AssetType.gold:
        return 'Weight (oz)';
      case AssetType.other:
        return 'Units';
      default:
        return 'Quantity';
    }
  }

  String get _priceLabel {
    switch (_selectedType) {
      case AssetType.realEstate:
        return 'Estimated Value';
      case AssetType.gold:
        return 'Price per Ounce';
      default:
        return 'Purchase Price';
    }
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

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      SnackbarUtils.showError(
          context, 'Authentication error. Please log in again.');
      return;
    }

    final currency = ref.read(selectedCurrencyProvider);

    // For types without quantity (realEstate) use 1 as default
    final quantity = _showQuantity && _quantityController.text.isNotEmpty
        ? double.parse(_quantityController.text)
        : 1.0;

    // For cash, price = quantity (amount), and purchase price = 1
    final purchasePrice = _showPrice && _priceController.text.isNotEmpty
        ? double.parse(_priceController.text)
        : 1.0;

    final asset = StockAsset(
      userId: userId,
      type: _selectedType,
      name: _nameController.text.trim(),
      symbol: _symbolController.text.trim(),
      quantity: quantity,
      purchasePrice: purchasePrice,
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
      _clearForm();
      context.go('/assets');
    }
  }

  void _clearForm() {
    _nameController.clear();
    _symbolController.clear();
    _quantityController.clear();
    _priceController.clear();
    _notesController.clear();
    setState(() => _selectedDate = null);
    ref.read(stockFormProvider.notifier).reset();
    ref.read(assetFormSubmissionProvider.notifier).reset();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.electricBlue,
              surface: AppTheme.cardGrey,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(stockFormProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final typeColor = AssetTypeSelectorCard.getTypeColor(_selectedType);

    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.midnightBlue,
        elevation: 0,
        title: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            // Step indicator + type badge row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.electricBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Step 2 of 2',
                    style: TextStyle(
                      color: AppTheme.electricBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AssetTypeSelectorCard.getTypeIcon(_selectedType),
                        color: typeColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedType.label,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ----- Name Field (always visible) -----
            _buildFormField(
              controller: _nameController,
              label: _getNameLabel(_selectedType),
              hint: _getNameHint(_selectedType),
              icon: Icons.label_outline,
              textCapitalization: TextCapitalization.words,
              validator: AssetValidators.validateName,
            ),

            // ----- Symbol Field (type-dependent) -----
            if (_showSymbol && _useSymbolSearch) ...[
              const SizedBox(height: 16),
              SymbolSearchField(
                assetType: _selectedType,
                controller: _symbolController,
                label: 'Symbol',
                onSymbolSelected: (symbol) {
                  _symbolController.text = symbol.symbol;
                  if (_nameController.text.isEmpty) {
                    _nameController.text = symbol.name;
                  }
                },
              ),
            ] else if (_showSymbol) ...[
              const SizedBox(height: 16),
              _buildFormField(
                controller: _symbolController,
                label: 'Symbol (Optional)',
                hint: _getSymbolHint(_selectedType),
                icon: Icons.tag,
                textCapitalization: TextCapitalization.characters,
              ),
            ],

            // ----- Quantity Field (type-dependent) -----
            if (_showQuantity) ...[
              const SizedBox(height: 16),
              _buildFormField(
                controller: _quantityController,
                label: _quantityLabel,
                hint: 'Enter $_quantityLabel'.toLowerCase(),
                icon: Icons.numbers,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                ],
                validator: AssetValidators.validateQuantity,
              ),
            ],

            // ----- Purchase Price / Estimated Value (type-dependent) -----
            if (_showPrice) ...[
              const SizedBox(height: 16),
              _buildFormField(
                controller: _priceController,
                label: _priceLabel,
                hint: 'Enter ${_priceLabel.toLowerCase()}',
                icon: Icons.attach_money,
                suffixText: selectedCurrency.code,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: AssetValidators.validatePrice,
              ),
            ],

            // ----- Currency Selector (always visible) -----
            const SizedBox(height: 16),
            DropdownButtonFormField<Currency>(
              initialValue: selectedCurrency,
              dropdownColor: AppTheme.cardGrey,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Currency',
                labelStyle: TextStyle(color: AppTheme.textGrey),
                filled: true,
                fillColor: AppTheme.cardGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.electricBlue),
                ),
                prefixIcon: Icon(Icons.money, color: AppTheme.textGrey),
              ),
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Row(
                    children: [
                      Text(
                        currency.symbol,
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currency.code} - ${currency.name}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  ref.read(selectedCurrencyProvider.notifier).setCurrency(currency);
                }
              },
            ),

            // ----- Purchase Date (type-dependent) -----
            if (_showDate) ...[
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Purchase Date (Optional)',
                    labelStyle: TextStyle(color: AppTheme.textGrey),
                    filled: true,
                    fillColor: AppTheme.cardGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: AppTheme.textGrey,
                    ),
                    suffixIcon: _selectedDate != null
                        ? IconButton(
                            icon: Icon(Icons.clear, color: AppTheme.textGrey),
                            onPressed: () =>
                                setState(() => _selectedDate = null),
                          )
                        : null,
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                        : 'Select date',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? Colors.white
                          : AppTheme.textGrey,
                    ),
                  ),
                ),
              ),
            ],

            // ----- Notes (always visible) -----
            const SizedBox(height: 16),
            _buildFormField(
              controller: _notesController,
              label: 'Notes (Optional)',
              hint: 'Add any additional notes',
              icon: Icons.note_outlined,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: formState.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: formState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Add ${_selectedType.label}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reusable dark-themed text form field
  // ---------------------------------------------------------------------------
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? suffixText,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: AppTheme.textGrey),
        hintStyle: TextStyle(color: AppTheme.textGrey.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppTheme.textGrey, size: 20),
        suffixText: suffixText,
        suffixStyle: TextStyle(color: AppTheme.textGrey),
        filled: true,
        fillColor: AppTheme.cardGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.electricBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.errorRed),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Label helpers
  // ---------------------------------------------------------------------------
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
      case AssetType.bond:
        return 'e.g., ISIN code';
      case AssetType.gold:
        return 'e.g., XAU';
      default:
        return 'Enter symbol';
    }
  }
}

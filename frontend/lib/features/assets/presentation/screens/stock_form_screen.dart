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

/// Stock/ETF Form Screen
/// Step 2 of the Add Asset flow for stocks and ETFs.
/// Uses SymbolSearchField with local catalog for autocomplete.
class StockFormScreen extends ConsumerStatefulWidget {
  const StockFormScreen({
    required this.type,
    super.key,
  });

  final AssetType type;

  @override
  ConsumerState<StockFormScreen> createState() => _StockFormScreenState();
}

class _StockFormScreenState extends ConsumerState<StockFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _exchangeController = TextEditingController();
  final _sectorController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _exchangeController.dispose();
    _sectorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isStock => widget.type == AssetType.stock;

  String get _title => _isStock ? 'New Stock' : 'New ETF';

  Future<void> _handleSubmit() async {
    final formState = ref.read(stockFormProvider);
    if (formState.isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      SnackbarUtils.showError(
          context, 'Authentication error. Please log in again.');
      return;
    }

    final currency = ref.read(selectedCurrencyProvider);

    // Build metadata for stock/ETF
    final metadata = <String, dynamic>{};
    if (_exchangeController.text.isNotEmpty) {
      metadata['exchange'] = _exchangeController.text.trim();
    }
    if (_sectorController.text.isNotEmpty) {
      metadata['sector'] = _sectorController.text.trim();
    }

    final asset = StockAsset(
      userId: userId,
      symbol: _symbolController.text.trim().toUpperCase(),
      name: _nameController.text.trim(),
      quantity: double.parse(_quantityController.text),
      purchasePrice: double.parse(_priceController.text),
      purchaseDate: _selectedDate,
      currency: currency,
      type: widget.type,
      metadata: metadata,
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
        'Asset added successfully',
      );
      _clearForm();
      ref.read(stockFormProvider.notifier).reset();
      ref.read(assetFormSubmissionProvider.notifier).reset();
      if (mounted) context.pop();
    }
  }

  void _clearForm() {
    _symbolController.clear();
    _nameController.clear();
    _quantityController.clear();
    _priceController.clear();
    _exchangeController.clear();
    _sectorController.clear();
    _notesController.clear();
    setState(() => _selectedDate = null);
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

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(stockFormProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final typeColor = AssetTypeSelectorCard.getTypeColor(widget.type);

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
            // Step indicator + type badge
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AssetTypeSelectorCard.getTypeIcon(widget.type),
                        color: typeColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.type.label,
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

            // Company Name field - primary selector, auto-fills symbol, exchange, sector
            SymbolSearchField(
              assetType: widget.type,
              controller: _nameController,
              label: _isStock ? 'Company Name' : 'Fund Name',
              searchByCompanyName: true,
              validator: AssetValidators.validateName,
              onSymbolSelected: (symbol) {
                setState(() {
                  _nameController.text = symbol.name;
                  _symbolController.text = symbol.symbol;
                  _exchangeController.text = symbol.exchange ?? '';
                  _sectorController.text = symbol.sector ?? '';
                });
              },
            ),
            const SizedBox(height: 16),

            // Symbol field - auto-filled when company selected, editable for manual override
            _buildFormField(
              controller: _symbolController,
              label: 'Symbol',
              hint: 'Auto-filled when selected above',
              icon: Icons.tag,
              textCapitalization: TextCapitalization.characters,
              validator: (value) =>
                  AssetValidators.validateSymbol(value, required: true),
            ),
            const SizedBox(height: 16),

            // Quantity Field
            _buildFormField(
              controller: _quantityController,
              label: _isStock ? 'Shares' : 'Units',
              hint: 'Enter quantity',
              icon: Icons.numbers,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
              ],
              validator: AssetValidators.validateQuantity,
            ),
            const SizedBox(height: 16),

            // Price Field
            _buildFormField(
              controller: _priceController,
              label: 'Purchase Price',
              hint: 'Enter purchase price',
              icon: Icons.attach_money,
              suffixText: selectedCurrency.code,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Purchase price is required';
                }
                final price = double.tryParse(value);
                if (price == null) return 'Enter a valid price';
                if (price < 0) return 'Price cannot be negative';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Currency Dropdown
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
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.electricBlue),
                ),
                prefixIcon: Icon(Icons.monetization_on, color: AppTheme.textGrey),
              ),
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(
                    '${currency.code} - ${currency.name}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  ref
                      .read(selectedCurrencyProvider.notifier)
                      .setCurrency(currency);
                }
              },
              validator: (value) {
                if (value == null) return 'Currency is required';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Purchase Date Field
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
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  prefixIcon:
                      Icon(Icons.calendar_today, color: AppTheme.textGrey),
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
                      ? DateFormat.yMMMd().format(_selectedDate!)
                      : 'Select date',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? Colors.white
                        : AppTheme.textGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Additional Information Section
            Text(
              'Additional Information (Optional)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Exchange Field
            _buildFormField(
              controller: _exchangeController,
              label: 'Exchange',
              hint: 'e.g., NASDAQ, NYSE',
              icon: Icons.account_balance_outlined,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),

            // Sector Field
            _buildFormField(
              controller: _sectorController,
              label: 'Sector',
              hint: 'e.g., Technology, Healthcare',
              icon: Icons.category_outlined,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Notes Field
            _buildFormField(
              controller: _notesController,
              label: 'Notes',
              hint: 'Any additional notes about this investment',
              icon: Icons.note_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Summary Card
            if (_quantityController.text.isNotEmpty &&
                _priceController.text.isNotEmpty)
              _SummaryCard(
                quantity: double.tryParse(_quantityController.text),
                price: double.tryParse(_priceController.text),
                currency: selectedCurrency,
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
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
                  : const Text(
                      'Save Asset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
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
}

/// Summary Card Widget
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.quantity,
    required this.price,
    required this.currency,
  });

  final double? quantity;
  final double? price;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    if (quantity == null || price == null) return const SizedBox.shrink();

    final total = quantity! * price!;
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Investment Summary',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Quantity', quantity!.toStringAsFixed(4)),
          const SizedBox(height: 6),
          _summaryRow('Price per unit', formatter.format(price)),
          Divider(
            height: 20,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          _summaryRow(
            'Total Invested',
            formatter.format(total),
            isBold: true,
            valueColor: AppTheme.electricBlue,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textGrey,
            fontSize: isBold ? 14 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

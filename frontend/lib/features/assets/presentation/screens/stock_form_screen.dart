import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/core/utils/asset_validators.dart';
import 'package:wealthscope_app/core/utils/snackbar_utils.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_metadata.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/stock_form_provider.dart';

/// Stock/ETF Form Screen
/// Provides a form for adding stocks and ETFs to the portfolio.
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
  final _industryController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedSymbol;

  @override
  void dispose() {
    _symbolController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _exchangeController.dispose();
    _sectorController.dispose();
    _industryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isStock => widget.type == AssetType.stock;

  String get _title => _isStock ? 'New Stock' : 'New ETF';

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (!mounted) return;
      SnackbarUtils.showError(context, 'Authentication error. Please log in again.');
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
    if (_industryController.text.isNotEmpty) {
      metadata['industry'] = _industryController.text.trim();
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
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await ref.read(stockFormProvider.notifier).submitForm(asset);

    final state = ref.read(stockFormProvider);

    if (!mounted) return;

    if (state.error != null) {
      SnackbarUtils.showError(context, state.error!);
    } else if (state.savedAsset != null) {
      SnackbarUtils.showSuccess(
        context, 
        '${_isStock ? 'Stock' : 'ETF'} added successfully',
      );
      context.pop();
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
            // Symbol Field with Autocomplete
            _SymbolAutocompleteField(
              controller: _symbolController,
              onSymbolSelected: (symbol) {
                setState(() {
                  _selectedSymbol = symbol;
                  _symbolController.text = symbol;
                });
              },
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                hintText: 'Enter company name',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business),
              ),
              textCapitalization: TextCapitalization.words,
              validator: AssetValidators.validateName,
            ),
            const SizedBox(height: 16),

            // Quantity Field
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
              ],
              validator: AssetValidators.validateQuantity,
            ),
            const SizedBox(height: 16),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Purchase Price',
                hintText: 'Enter purchase price',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: selectedCurrency.code,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El precio de compra es requerido';
                }
                final price = double.tryParse(value);
                if (price == null) {
                  return 'Ingresa un precio valido';
                }
                if (price < 0) {
                  return 'El precio no puede ser negativo';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Currency Dropdown
            DropdownButtonFormField<Currency>(
              value: selectedCurrency,
              decoration: InputDecoration(
                labelText: 'Currency',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.monetization_on),
              ),
              items: Currency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text('${currency.code} - ${currency.name}'),
                );
              }).toList(),
              onChanged: (currency) {
                if (currency != null) {
                  ref.read(selectedCurrencyProvider.notifier).setCurrency(currency);
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Currency is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Purchase Date Field
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Purchase Date (Optional)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: _selectedDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                        )
                      : null,
                ),
                child: Text(
                  _selectedDate != null
                      ? DateFormat.yMMMd().format(_selectedDate!)
                      : 'Select date',
                  style: _selectedDate != null
                      ? theme.textTheme.bodyLarge
                      : theme.textTheme.bodyLarge?.copyWith(
                          color: theme.hintColor,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Metadata Section Header
            Text(
              'Additional Information (Optional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Exchange Field
            TextFormField(
              controller: _exchangeController,
              decoration: InputDecoration(
                labelText: 'Exchange',
                hintText: 'e.g., NASDAQ, NYSE',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.account_balance_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),

            // Sector Field
            TextFormField(
              controller: _sectorController,
              decoration: InputDecoration(
                labelText: 'Sector',
                hintText: 'e.g., Technology, Healthcare',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Industry Field
            TextFormField(
              controller: _industryController,
              decoration: InputDecoration(
                labelText: 'Industry',
                hintText: 'e.g., Consumer Electronics',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.factory_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Notes Field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional notes about this investment',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.note_outlined),
              ),
              maxLines: 3,
              maxLength: 500,
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
          child: ElevatedButton(
            onPressed: formState.isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Symbol Autocomplete Field Widget
class _SymbolAutocompleteField extends ConsumerStatefulWidget {
  const _SymbolAutocompleteField({
    required this.controller,
    required this.onSymbolSelected,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSymbolSelected;

  @override
  ConsumerState<_SymbolAutocompleteField> createState() =>
      _SymbolAutocompleteFieldState();
}

class _SymbolAutocompleteFieldState
    extends ConsumerState<_SymbolAutocompleteField> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return await ref
            .read(stockFormProvider.notifier)
            .searchSymbols(textEditingValue.text);
      },
      onSelected: widget.onSymbolSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        // Sync with parent controller
        controller.text = widget.controller.text;
        controller.selection = widget.controller.selection;

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Symbol',
            hintText: 'Enter symbol (e.g., AAPL)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
          ),
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) => AssetValidators.validateSymbol(value, required: true),
          onChanged: (value) {
            widget.controller.text = value;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 300),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.trending_up, size: 20),
                    title: Text(
                      option,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
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
    final theme = Theme.of(context);

    if (quantity == null || price == null) {
      return const SizedBox.shrink();
    }

    final total = quantity! * price!;
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investment Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  quantity!.toStringAsFixed(4),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price per unit:',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  formatter.format(price),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Invested:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatter.format(total),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

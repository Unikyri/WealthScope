import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/core/utils/asset_validators.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/gold_form_provider.dart';

/// Gold & Precious Metals Form Screen
/// Form for adding gold and precious metals to the portfolio
class GoldFormScreen extends ConsumerStatefulWidget {
  const GoldFormScreen({super.key});

  @override
  ConsumerState<GoldFormScreen> createState() => _GoldFormScreenState();
}

class _GoldFormScreenState extends ConsumerState<GoldFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _purchasePriceController = TextEditingController();

  bool _showValidationErrors = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _purchasePriceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select purchase date',
    );

    if (picked != null) {
      ref.read(goldFormProvider.notifier).updatePurchaseDate(picked);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _showValidationErrors = true);

    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref.read(goldFormProvider.notifier).submit();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Precious metal added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(goldFormProvider);
    final validationErrors =
        _showValidationErrors ? formState.validate() : <String, String?>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Precious Metal'),
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              'Save',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name Field
            _NameField(
              controller: _nameController,
              errorText: validationErrors['name'],
              onChanged: (value) =>
                  ref.read(goldFormProvider.notifier).updateName(value),
            ),
            const SizedBox(height: 16),

            // Weight Field
            _WeightField(
              controller: _weightController,
              errorText: validationErrors['weightOz'],
              onChanged: (value) =>
                  ref.read(goldFormProvider.notifier).updateWeightOz(value),
            ),
            const SizedBox(height: 16),

            // Purity Dropdown
            _PurityDropdown(
              value: formState.purity,
              onChanged: (purity) =>
                  ref.read(goldFormProvider.notifier).updatePurity(purity),
            ),
            const SizedBox(height: 16),

            // Form Dropdown
            _FormDropdown(
              value: formState.form,
              onChanged: (form) =>
                  ref.read(goldFormProvider.notifier).updateForm(form),
            ),
            const SizedBox(height: 16),

            // Purchase Price Field
            _PurchasePriceField(
              controller: _purchasePriceController,
              errorText: validationErrors['purchasePrice'],
              onChanged: (value) => ref
                  .read(goldFormProvider.notifier)
                  .updatePurchasePrice(value),
            ),
            const SizedBox(height: 16),

            // Purchase Date Picker
            _PurchaseDateField(
              purchaseDate: formState.purchaseDate,
              errorText: validationErrors['purchaseDate'],
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),

            // Estimated Value Card (if calculable)
            if (formState.weightOz != null && formState.purity != null)
              _EstimatedValueCard(
                estimatedValue:
                    ref.read(goldFormProvider.notifier).calculateCurrentValue(),
              ),
            if (formState.weightOz != null && formState.purity != null)
              const SizedBox(height: 16),

            // Info Card
            _InfoCard(),
          ],
        ),
      ),
    );
  }
}

/// Name Input Field
class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Name/Description *',
        hintText: 'e.g., 1oz Gold Bar',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.label),
      ),
      textCapitalization: TextCapitalization.words,
      validator: AssetValidators.validateName,
      onChanged: onChanged,
    );
  }
}

/// Weight Input Field
class _WeightField extends StatelessWidget {
  const _WeightField({
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Weight *',
        hintText: '1.0',
        suffixText: 'oz',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.scale),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      validator: AssetValidators.validateWeight,
      onChanged: onChanged,
    );
  }
}

/// Purity Dropdown
class _PurityDropdown extends StatelessWidget {
  const _PurityDropdown({
    required this.value,
    required this.onChanged,
  });

  final MetalPurity? value;
  final ValueChanged<MetalPurity?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MetalPurity>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Purity',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.verified),
      ),
      items: MetalPurity.values
          .map(
            (purity) => DropdownMenuItem(
              value: purity,
              child: Text(purity.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Form Dropdown
class _FormDropdown extends StatelessWidget {
  const _FormDropdown({
    required this.value,
    required this.onChanged,
  });

  final MetalForm? value;
  final ValueChanged<MetalForm?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MetalForm>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Form',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: MetalForm.values
          .map(
            (form) => DropdownMenuItem(
              value: form,
              child: Text(form.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Purchase Price Input Field
class _PurchasePriceField extends StatelessWidget {
  const _PurchasePriceField({
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Purchase Price',
        hintText: '2000.00',
        prefixText: 'USD ',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.attach_money),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      validator: AssetValidators.validatePrice,
      onChanged: onChanged,
    );
  }
}

/// Purchase Date Field
class _PurchaseDateField extends StatelessWidget {
  const _PurchaseDateField({
    required this.purchaseDate,
    required this.onTap,
    this.errorText,
  });

  final DateTime? purchaseDate;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    final displayText = purchaseDate != null
        ? dateFormat.format(purchaseDate!)
        : 'Select date';

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Purchase Date',
          border: const OutlineInputBorder(),
          errorText: errorText,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayText,
              style: TextStyle(
                color: purchaseDate != null ? null : Colors.grey,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

/// Estimated Value Card
class _EstimatedValueCard extends StatelessWidget {
  const _EstimatedValueCard({
    required this.estimatedValue,
  });

  final double? estimatedValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    if (estimatedValue == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: theme.colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Current Value',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(estimatedValue),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info Card
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Fields marked with * are required. '
              'Weight should be in troy ounces (oz). '
              'Estimated value is calculated based on current market prices.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

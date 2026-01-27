import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/real_estate_form_provider.dart';

/// Real Estate Form Screen
/// Form for adding real estate assets to the portfolio
class RealEstateFormScreen extends ConsumerStatefulWidget {
  const RealEstateFormScreen({super.key});

  @override
  ConsumerState<RealEstateFormScreen> createState() =>
      _RealEstateFormScreenState();
}

class _RealEstateFormScreenState extends ConsumerState<RealEstateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();

  bool _showValidationErrors = false;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Seleccionar fecha de compra',
    );

    if (picked != null) {
      ref.read(realEstateFormProvider.notifier).updatePurchaseDate(picked);
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _showValidationErrors = true);

    if (_formKey.currentState?.validate() ?? false) {
      final success =
          await ref.read(realEstateFormProvider.notifier).submit();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bien raíz agregado exitosamente'),
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
    final formState = ref.watch(realEstateFormProvider);
    final validationErrors =
        _showValidationErrors ? formState.validate() : <String, String?>{};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Bien Raíz'),
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: Text(
              'Guardar',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name Field
            _NameField(
              controller: _nameController,
              errorText: validationErrors['name'],
              onChanged: (value) =>
                  ref.read(realEstateFormProvider.notifier).updateName(value),
            ),
            const SizedBox(height: 16),

            // Estimated Value Field
            _EstimatedValueField(
              controller: _valueController,
              errorText: validationErrors['estimatedValue'],
              onChanged: (value) => ref
                  .read(realEstateFormProvider.notifier)
                  .updateEstimatedValue(value),
            ),
            const SizedBox(height: 16),

            // Address Field
            _AddressField(
              controller: _addressController,
              errorText: validationErrors['address'],
              onChanged: (value) =>
                  ref.read(realEstateFormProvider.notifier).updateAddress(value),
            ),
            const SizedBox(height: 16),

            // Area Field with Unit Selector
            _AreaField(
              controller: _areaController,
              errorText: validationErrors['area'],
              currentUnit: formState.areaUnit,
              onAreaChanged: (value) =>
                  ref.read(realEstateFormProvider.notifier).updateArea(value),
              onUnitChanged: (unit) => ref
                  .read(realEstateFormProvider.notifier)
                  .updateAreaUnit(unit),
            ),
            const SizedBox(height: 16),

            // Property Type Dropdown
            _PropertyTypeDropdown(
              value: formState.propertyType,
              onChanged: (type) => ref
                  .read(realEstateFormProvider.notifier)
                  .updatePropertyType(type),
            ),
            const SizedBox(height: 16),

            // Purchase Date Picker
            _PurchaseDateField(
              purchaseDate: formState.purchaseDate,
              errorText: validationErrors['purchaseDate'],
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),

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
        labelText: 'Nombre de la propiedad *',
        hintText: 'Ej: Apartamento en Miami',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.home),
      ),
      textCapitalization: TextCapitalization.words,
      onChanged: onChanged,
    );
  }
}

/// Estimated Value Input Field
class _EstimatedValueField extends StatelessWidget {
  const _EstimatedValueField({
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
        labelText: 'Valor estimado *',
        hintText: '250000',
        prefixText: 'USD ',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.attach_money),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      onChanged: onChanged,
    );
  }
}

/// Address Input Field
class _AddressField extends StatelessWidget {
  const _AddressField({
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
        labelText: 'Dirección *',
        hintText: '123 Main St, Miami, FL',
        border: const OutlineInputBorder(),
        errorText: errorText,
        prefixIcon: const Icon(Icons.location_on),
        alignLabelWithHint: true,
      ),
      maxLines: 2,
      textCapitalization: TextCapitalization.words,
      onChanged: onChanged,
    );
  }
}

/// Area Input Field with Unit Selector
class _AreaField extends StatelessWidget {
  const _AreaField({
    required this.controller,
    required this.currentUnit,
    required this.onAreaChanged,
    required this.onUnitChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final AreaUnit currentUnit;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<AreaUnit> onUnitChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Área',
              hintText: '150',
              border: const OutlineInputBorder(),
              errorText: errorText,
              prefixIcon: const Icon(Icons.square_foot),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: onAreaChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<AreaUnit>(
            value: currentUnit,
            decoration: const InputDecoration(
              labelText: 'Unidad',
              border: OutlineInputBorder(),
            ),
            items: AreaUnit.values
                .map(
                  (unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit.label),
                  ),
                )
                .toList(),
            onChanged: (unit) {
              if (unit != null) onUnitChanged(unit);
            },
          ),
        ),
      ],
    );
  }
}

/// Property Type Dropdown
class _PropertyTypeDropdown extends StatelessWidget {
  const _PropertyTypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final PropertyType? value;
  final ValueChanged<PropertyType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PropertyType>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Tipo de propiedad',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business),
      ),
      items: PropertyType.values
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(type.label),
            ),
          )
          .toList(),
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
    final dateFormat = DateFormat('dd/MM/yyyy');
    final displayText = purchaseDate != null
        ? dateFormat.format(purchaseDate!)
        : 'Seleccionar fecha';

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha de compra',
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
              'Los campos marcados con * son obligatorios. '
              'El valor estimado será usado para calcular tu patrimonio total.',
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

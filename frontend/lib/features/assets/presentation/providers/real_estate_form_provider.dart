import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_metadata.dart';

part 'real_estate_form_provider.g.dart';

/// Property Type Enum
enum PropertyType {
  apartment('apartment', 'Apartamento'),
  house('house', 'Casa'),
  land('land', 'Terreno'),
  commercial('commercial', 'Comercial'),
  other('other', 'Otro');

  const PropertyType(this.value, this.label);
  final String value;
  final String label;
}

/// Area Unit Enum
enum AreaUnit {
  squareMeters('m2', 'm²'),
  squareFeet('sqft', 'sqft');

  const AreaUnit(this.value, this.label);
  final String value;
  final String label;
}

/// Real Estate Form State
class RealEstateFormState {
  const RealEstateFormState({
    this.name = '',
    this.estimatedValue,
    this.address = '',
    this.area,
    this.areaUnit = AreaUnit.squareMeters,
    this.propertyType,
    this.purchaseDate,
    this.notes = '',
  });

  final String name;
  final double? estimatedValue;
  final String address;
  final double? area;
  final AreaUnit areaUnit;
  final PropertyType? propertyType;
  final DateTime? purchaseDate;
  final String notes;

  RealEstateFormState copyWith({
    String? name,
    double? estimatedValue,
    String? address,
    double? area,
    AreaUnit? areaUnit,
    PropertyType? propertyType,
    DateTime? purchaseDate,
    String? notes,
  }) {
    return RealEstateFormState(
      name: name ?? this.name,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      address: address ?? this.address,
      area: area ?? this.area,
      areaUnit: areaUnit ?? this.areaUnit,
      propertyType: propertyType ?? this.propertyType,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
    );
  }

  /// Validate form data
  Map<String, String?> validate() {
    final errors = <String, String?>{};

    if (name.trim().isEmpty) {
      errors['name'] = 'El nombre es requerido';
    }

    if (estimatedValue == null) {
      errors['estimatedValue'] = 'El valor estimado es requerido';
    } else if (estimatedValue! <= 0) {
      errors['estimatedValue'] = 'El valor debe ser mayor a 0';
    }

    if (address.trim().isEmpty) {
      errors['address'] = 'La dirección es requerida';
    }

    if (area != null && area! <= 0) {
      errors['area'] = 'El área debe ser mayor a 0';
    }

    if (purchaseDate != null && purchaseDate!.isAfter(DateTime.now())) {
      errors['purchaseDate'] = 'La fecha no puede ser futura';
    }

    return errors;
  }

  /// Check if form is valid
  bool get isValid => validate().isEmpty;

  /// Convert to RealEstateMetadata
  RealEstateMetadata toMetadata() {
    // Convert area to square meters if needed
    final areaSqm = area != null && areaUnit == AreaUnit.squareFeet
        ? area! * 0.092903 // Convert sqft to m2
        : area;

    return RealEstateMetadata(
      propertyType: propertyType?.value,
      address: address.trim(),
      areaSqm: areaSqm,
    );
  }
}

/// Real Estate Form Provider
@riverpod
class RealEstateForm extends _$RealEstateForm {
  @override
  RealEstateFormState build() {
    return const RealEstateFormState();
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateEstimatedValue(String value) {
    final parsed = double.tryParse(value.replaceAll(',', ''));
    state = state.copyWith(estimatedValue: parsed);
  }

  void updateAddress(String value) {
    state = state.copyWith(address: value);
  }

  void updateArea(String value) {
    final parsed = double.tryParse(value.replaceAll(',', ''));
    state = state.copyWith(area: parsed);
  }

  void updateAreaUnit(AreaUnit value) {
    state = state.copyWith(areaUnit: value);
  }

  void updatePropertyType(PropertyType? value) {
    state = state.copyWith(propertyType: value);
  }

  void updatePurchaseDate(DateTime? value) {
    state = state.copyWith(purchaseDate: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void reset() {
    state = const RealEstateFormState();
  }

  /// Submit form (placeholder for now)
  Future<bool> submit() async {
    if (!state.isValid) {
      return false;
    }

    // TODO: Implement actual submission to repository
    // final metadata = state.toMetadata();
    // await ref.read(assetRepositoryProvider).createAsset(...)

    return true;
  }
}

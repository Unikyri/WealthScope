import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_metadata.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/currency.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/asset_form_submission_provider.dart';

part 'gold_form_provider.g.dart';

/// Metal Purity Enum
enum MetalPurity {
  k24_9999('0.9999', '24k (99.99%)', 0.9999),
  k24_999('0.999', '24k (99.9%)', 0.999),
  k22('0.916', '22k (91.6%)', 0.916),
  k18('0.750', '18k (75%)', 0.750),
  k14('0.583', '14k (58.3%)', 0.583),
  k10('0.417', '10k (41.7%)', 0.417);

  const MetalPurity(this.value, this.label, this.purityFraction);
  final String value;
  final String label;
  final double purityFraction;
}

/// Metal Form Enum
enum MetalForm {
  bar('bar', 'Bar'),
  coin('coin', 'Coin'),
  jewelry('jewelry', 'Jewelry'),
  other('other', 'Other');

  const MetalForm(this.value, this.label);
  final String value;
  final String label;
}

/// Gold Form State
class GoldFormState {
  const GoldFormState({
    this.name = '',
    this.weightOz,
    this.purity,
    this.form,
    this.purchasePrice,
    this.purchaseDate,
    this.notes = '',
  });

  final String name;
  final double? weightOz;
  final MetalPurity? purity;
  final MetalForm? form;
  final double? purchasePrice;
  final DateTime? purchaseDate;
  final String notes;

  GoldFormState copyWith({
    String? name,
    double? weightOz,
    MetalPurity? purity,
    MetalForm? form,
    double? purchasePrice,
    DateTime? purchaseDate,
    String? notes,
  }) {
    return GoldFormState(
      name: name ?? this.name,
      weightOz: weightOz ?? this.weightOz,
      purity: purity ?? this.purity,
      form: form ?? this.form,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
    );
  }

  /// Validate form data
  Map<String, String?> validate() {
    final errors = <String, String?>{};

    if (name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (weightOz == null) {
      errors['weightOz'] = 'Weight is required';
    } else if (weightOz! <= 0) {
      errors['weightOz'] = 'Weight must be greater than 0';
    }

    if (purchasePrice != null && purchasePrice! < 0) {
      errors['purchasePrice'] = 'Purchase price cannot be negative';
    }

    if (purchaseDate != null && purchaseDate!.isAfter(DateTime.now())) {
      errors['purchaseDate'] = 'Date cannot be in the future';
    }

    return errors;
  }

  /// Check if form is valid
  bool get isValid => validate().isEmpty;

  /// Convert to GoldMetadata
  GoldMetadata toMetadata() {
    return GoldMetadata(
      weightOz: weightOz,
      purity: purity?.purityFraction,
      form: form?.value,
    );
  }
}

/// Gold Form Provider
@riverpod
class GoldForm extends _$GoldForm {
  @override
  GoldFormState build() {
    return const GoldFormState();
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateWeightOz(String value) {
    final parsed = double.tryParse(value.replaceAll(',', ''));
    state = state.copyWith(weightOz: parsed);
  }

  void updatePurity(MetalPurity? value) {
    state = state.copyWith(purity: value);
  }

  void updateForm(MetalForm? value) {
    state = state.copyWith(form: value);
  }

  void updatePurchasePrice(String value) {
    final parsed = double.tryParse(value.replaceAll(',', ''));
    state = state.copyWith(purchasePrice: parsed);
  }

  void updatePurchaseDate(DateTime value) {
    state = state.copyWith(purchaseDate: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void reset() {
    state = const GoldFormState();
  }

  /// Submit form and create gold asset via API
  Future<bool> submit() async {
    if (!state.isValid) return false;

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Build asset entity
      final asset = StockAsset(
        userId: userId,
        type: AssetType.gold,
        symbol: 'GOLD',
        name: state.name,
        quantity: state.weightOz ?? 0.0,
        purchasePrice: state.purchasePrice ?? 0.0,
        purchaseDate: state.purchaseDate,
        currency: Currency.usd,
        metadata: state.toMetadata().toJson(),
        notes: state.notes.isEmpty ? null : state.notes,
      );

      // Submit via API
      await ref.read(assetFormSubmissionProvider.notifier).submitCreate(asset);

      // Check result
      final submissionState = ref.read(assetFormSubmissionProvider);
      if (submissionState.error != null) {
        return false;
      }

      reset();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculate current market value based on weight and purity
  /// (In production, this would fetch current market prices)
  double? calculateCurrentValue() {
    if (state.weightOz == null || state.purity == null) return null;

    // Placeholder: Assume $2000/oz for pure gold
    const goldPricePerOz = 2000.0;
    return state.weightOz! * state.purity!.purityFraction * goldPricePerOz;
  }
}

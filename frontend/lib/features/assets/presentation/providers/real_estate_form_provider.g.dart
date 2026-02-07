// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_estate_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Real Estate Form Provider

@ProviderFor(RealEstateForm)
final realEstateFormProvider = RealEstateFormProvider._();

/// Real Estate Form Provider
final class RealEstateFormProvider
    extends $NotifierProvider<RealEstateForm, RealEstateFormState> {
  /// Real Estate Form Provider
  RealEstateFormProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'realEstateFormProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$realEstateFormHash();

  @$internal
  @override
  RealEstateForm create() => RealEstateForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RealEstateFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RealEstateFormState>(value),
    );
  }
}

String _$realEstateFormHash() => r'cba58ae2f94f091b0be3dad8f38d82d33cf1213a';

/// Real Estate Form Provider

abstract class _$RealEstateForm extends $Notifier<RealEstateFormState> {
  RealEstateFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RealEstateFormState, RealEstateFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RealEstateFormState, RealEstateFormState>,
        RealEstateFormState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

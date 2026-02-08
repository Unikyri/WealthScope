// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gold_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gold Form Provider

@ProviderFor(GoldForm)
final goldFormProvider = GoldFormProvider._();

/// Gold Form Provider
final class GoldFormProvider
    extends $NotifierProvider<GoldForm, GoldFormState> {
  /// Gold Form Provider
  GoldFormProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'goldFormProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$goldFormHash();

  @$internal
  @override
  GoldForm create() => GoldForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoldFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoldFormState>(value),
    );
  }
}

String _$goldFormHash() => r'b30a13d749066532aee4dc5509dbaaf0afcb9086';

/// Gold Form Provider

abstract class _$GoldForm extends $Notifier<GoldFormState> {
  GoldFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GoldFormState, GoldFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GoldFormState, GoldFormState>,
        GoldFormState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

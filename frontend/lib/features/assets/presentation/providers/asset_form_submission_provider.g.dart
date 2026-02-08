// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_form_submission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Asset Form Submission Provider
/// Manages the submission of asset creation/update forms to the backend API.
/// Handles loading states, success, and error scenarios.

@ProviderFor(AssetFormSubmission)
final assetFormSubmissionProvider = AssetFormSubmissionProvider._();

/// Asset Form Submission Provider
/// Manages the submission of asset creation/update forms to the backend API.
/// Handles loading states, success, and error scenarios.
final class AssetFormSubmissionProvider
    extends $NotifierProvider<AssetFormSubmission, AssetFormSubmissionState> {
  /// Asset Form Submission Provider
  /// Manages the submission of asset creation/update forms to the backend API.
  /// Handles loading states, success, and error scenarios.
  AssetFormSubmissionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetFormSubmissionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetFormSubmissionHash();

  @$internal
  @override
  AssetFormSubmission create() => AssetFormSubmission();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetFormSubmissionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetFormSubmissionState>(value),
    );
  }
}

String _$assetFormSubmissionHash() =>
    r'68bb1a14637942470c8f94ce39e661d38a496abe';

/// Asset Form Submission Provider
/// Manages the submission of asset creation/update forms to the backend API.
/// Handles loading states, success, and error scenarios.

abstract class _$AssetFormSubmission
    extends $Notifier<AssetFormSubmissionState> {
  AssetFormSubmissionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AssetFormSubmissionState, AssetFormSubmissionState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AssetFormSubmissionState, AssetFormSubmissionState>,
        AssetFormSubmissionState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

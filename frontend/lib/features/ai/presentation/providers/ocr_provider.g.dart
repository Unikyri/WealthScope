// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// OCR Provider
/// Manages document processing and OCR operations

@ProviderFor(Ocr)
final ocrProvider = OcrProvider._();

/// OCR Provider
/// Manages document processing and OCR operations
final class OcrProvider extends $NotifierProvider<Ocr, AsyncValue<OcrResult?>> {
  /// OCR Provider
  /// Manages document processing and OCR operations
  OcrProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ocrProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ocrHash();

  @$internal
  @override
  Ocr create() => Ocr();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<OcrResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<OcrResult?>>(value),
    );
  }
}

String _$ocrHash() => r'8473f63006b0a06610e9e83783773f0562d07a67';

/// OCR Provider
/// Manages document processing and OCR operations

abstract class _$Ocr extends $Notifier<AsyncValue<OcrResult?>> {
  AsyncValue<OcrResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<OcrResult?>, AsyncValue<OcrResult?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<OcrResult?>, AsyncValue<OcrResult?>>,
        AsyncValue<OcrResult?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

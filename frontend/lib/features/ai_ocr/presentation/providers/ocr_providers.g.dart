// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for OCRRepository

@ProviderFor(ocrRepository)
final ocrRepositoryProvider = OcrRepositoryProvider._();

/// Provider for OCRRepository

final class OcrRepositoryProvider
    extends $FunctionalProvider<OCRRepository, OCRRepository, OCRRepository>
    with $Provider<OCRRepository> {
  /// Provider for OCRRepository
  OcrRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ocrRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ocrRepositoryHash();

  @$internal
  @override
  $ProviderElement<OCRRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OCRRepository create(Ref ref) {
    return ocrRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OCRRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OCRRepository>(value),
    );
  }
}

String _$ocrRepositoryHash() => r'30b0f67151d047dba9a35bde4691dc021429d60d';

/// Provider to process document with OCR

@ProviderFor(ProcessDocument)
final processDocumentProvider = ProcessDocumentProvider._();

/// Provider to process document with OCR
final class ProcessDocumentProvider
    extends $AsyncNotifierProvider<ProcessDocument, OCRResultEntity?> {
  /// Provider to process document with OCR
  ProcessDocumentProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'processDocumentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$processDocumentHash();

  @$internal
  @override
  ProcessDocument create() => ProcessDocument();
}

String _$processDocumentHash() => r'4bb569e659d9604ef8163dfeada849929f220eeb';

/// Provider to process document with OCR

abstract class _$ProcessDocument extends $AsyncNotifier<OCRResultEntity?> {
  FutureOr<OCRResultEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<OCRResultEntity?>, OCRResultEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<OCRResultEntity?>, OCRResultEntity?>,
        AsyncValue<OCRResultEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider to confirm OCR assets

@ProviderFor(ConfirmOCRAssets)
final confirmOCRAssetsProvider = ConfirmOCRAssetsProvider._();

/// Provider to confirm OCR assets
final class ConfirmOCRAssetsProvider
    extends $AsyncNotifierProvider<ConfirmOCRAssets, OCRConfirmationEntity?> {
  /// Provider to confirm OCR assets
  ConfirmOCRAssetsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'confirmOCRAssetsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$confirmOCRAssetsHash();

  @$internal
  @override
  ConfirmOCRAssets create() => ConfirmOCRAssets();
}

String _$confirmOCRAssetsHash() => r'd5dd85625b25e43c5683136358b040d8d2a84faa';

/// Provider to confirm OCR assets

abstract class _$ConfirmOCRAssets
    extends $AsyncNotifier<OCRConfirmationEntity?> {
  FutureOr<OCRConfirmationEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<OCRConfirmationEntity?>, OCRConfirmationEntity?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<OCRConfirmationEntity?>, OCRConfirmationEntity?>,
        AsyncValue<OCRConfirmationEntity?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

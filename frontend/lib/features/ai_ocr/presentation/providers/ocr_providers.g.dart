// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrRepositoryHash() => r'1fcadbc567c03094a5b0ca77256b0f599fe52a24';

/// Provider for OCRRepository
///
/// Copied from [ocrRepository].
@ProviderFor(ocrRepository)
final ocrRepositoryProvider = AutoDisposeProvider<OCRRepository>.internal(
  ocrRepository,
  name: r'ocrRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ocrRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OcrRepositoryRef = AutoDisposeProviderRef<OCRRepository>;
String _$processDocumentHash() => r'4bb569e659d9604ef8163dfeada849929f220eeb';

/// Provider to process document with OCR
///
/// Copied from [ProcessDocument].
@ProviderFor(ProcessDocument)
final processDocumentProvider = AutoDisposeAsyncNotifierProvider<
    ProcessDocument, OCRResultEntity?>.internal(
  ProcessDocument.new,
  name: r'processDocumentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$processDocumentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProcessDocument = AutoDisposeAsyncNotifier<OCRResultEntity?>;
String _$confirmOCRAssetsHash() => r'd5dd85625b25e43c5683136358b040d8d2a84faa';

/// Provider to confirm OCR assets
///
/// Copied from [ConfirmOCRAssets].
@ProviderFor(ConfirmOCRAssets)
final confirmOCRAssetsProvider = AutoDisposeAsyncNotifierProvider<
    ConfirmOCRAssets, OCRConfirmationEntity?>.internal(
  ConfirmOCRAssets.new,
  name: r'confirmOCRAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$confirmOCRAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConfirmOCRAssets = AutoDisposeAsyncNotifier<OCRConfirmationEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

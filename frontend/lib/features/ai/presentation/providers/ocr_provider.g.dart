// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ocrHash() => r'8473f63006b0a06610e9e83783773f0562d07a67';

/// OCR Provider
/// Manages document processing and OCR operations
///
/// Copied from [Ocr].
@ProviderFor(Ocr)
final ocrProvider =
    AutoDisposeNotifierProvider<Ocr, AsyncValue<OcrResult?>>.internal(
  Ocr.new,
  name: r'ocrProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ocrHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Ocr = AutoDisposeNotifier<AsyncValue<OcrResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

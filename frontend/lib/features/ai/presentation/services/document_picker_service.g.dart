// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_picker_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentPickerService)
final documentPickerServiceProvider = DocumentPickerServiceProvider._();

final class DocumentPickerServiceProvider extends $FunctionalProvider<
    DocumentPickerService,
    DocumentPickerService,
    DocumentPickerService> with $Provider<DocumentPickerService> {
  DocumentPickerServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'documentPickerServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$documentPickerServiceHash();

  @$internal
  @override
  $ProviderElement<DocumentPickerService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentPickerService create(Ref ref) {
    return documentPickerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentPickerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentPickerService>(value),
    );
  }
}

String _$documentPickerServiceHash() =>
    r'6e67a9c973232490683d9321e0273ac1d83b9650';

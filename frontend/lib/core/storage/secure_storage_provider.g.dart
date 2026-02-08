// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the secure storage service.
/// Returns a singleton instance of [SecureStorageService].

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

/// Provider for the secure storage service.
/// Returns a singleton instance of [SecureStorageService].

final class SecureStorageProvider extends $FunctionalProvider<
    SecureStorageService,
    SecureStorageService,
    SecureStorageService> with $Provider<SecureStorageService> {
  /// Provider for the secure storage service.
  /// Returns a singleton instance of [SecureStorageService].
  SecureStorageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'secureStorageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorageService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStorageService create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorageService>(value),
    );
  }
}

String _$secureStorageHash() => r'c032f21d630c1eab845b23a171feca7df6b2844c';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio Client Provider
/// Provides the configured Dio instance for API calls

@ProviderFor(dioClient)
final dioClientProvider = DioClientProvider._();

/// Dio Client Provider
/// Provides the configured Dio instance for API calls

final class DioClientProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio Client Provider
  /// Provides the configured Dio instance for API calls
  DioClientProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dioClientProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dioClientHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dioClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioClientHash() => r'63cfee0a060ea6259143afde462e15c10d297812';

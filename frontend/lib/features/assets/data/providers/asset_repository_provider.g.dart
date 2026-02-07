// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for Asset Remote Data Source

@ProviderFor(assetRemoteDataSource)
final assetRemoteDataSourceProvider = AssetRemoteDataSourceProvider._();

/// Provider for Asset Remote Data Source

final class AssetRemoteDataSourceProvider extends $FunctionalProvider<
    AssetRemoteDataSource,
    AssetRemoteDataSource,
    AssetRemoteDataSource> with $Provider<AssetRemoteDataSource> {
  /// Provider for Asset Remote Data Source
  AssetRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AssetRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetRemoteDataSource create(Ref ref) {
    return assetRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetRemoteDataSource>(value),
    );
  }
}

String _$assetRemoteDataSourceHash() =>
    r'e13587e34918eaf3ef96958247938eeb1b1ba244';

/// Provider for Asset Repository

@ProviderFor(assetRepository)
final assetRepositoryProvider = AssetRepositoryProvider._();

/// Provider for Asset Repository

final class AssetRepositoryProvider extends $FunctionalProvider<AssetRepository,
    AssetRepository, AssetRepository> with $Provider<AssetRepository> {
  /// Provider for Asset Repository
  AssetRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetRepositoryHash();

  @$internal
  @override
  $ProviderElement<AssetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetRepository create(Ref ref) {
    return assetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetRepository>(value),
    );
  }
}

String _$assetRepositoryHash() => r'3422f7027163da9df16b996b9b016c333a20a979';

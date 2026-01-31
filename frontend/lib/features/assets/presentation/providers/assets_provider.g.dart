// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredAssetsHash() => r'5a5d9893b7d6efa75efcff1a4d0c4c9f90e3e957';

/// Provider for filtered assets based on selected type
/// This provider automatically updates when the filter changes
///
/// Copied from [filteredAssets].
@ProviderFor(filteredAssets)
final filteredAssetsProvider =
    AutoDisposeFutureProvider<List<StockAsset>>.internal(
  filteredAssets,
  name: r'filteredAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredAssetsRef = AutoDisposeFutureProviderRef<List<StockAsset>>;
String _$searchedAssetsHash() => r'f18f12f21513e77fb4b2ad4f1fe0e70386ebc585';

/// Provider for searched assets
/// Returns filtered assets based on search query
///
/// Copied from [searchedAssets].
@ProviderFor(searchedAssets)
final searchedAssetsProvider =
    AutoDisposeFutureProvider<List<StockAsset>>.internal(
  searchedAssets,
  name: r'searchedAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SearchedAssetsRef = AutoDisposeFutureProviderRef<List<StockAsset>>;
String _$assetDetailHash() => r'f0f2295fe97a81c0f2d389a370887bb21c6b541a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset
///
/// Copied from [assetDetail].
@ProviderFor(assetDetail)
const assetDetailProvider = AssetDetailFamily();

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset
///
/// Copied from [assetDetail].
class AssetDetailFamily extends Family<AsyncValue<StockAsset>> {
  /// Provider for fetching a single asset by ID
  /// This provider fetches detailed information for a specific asset
  ///
  /// Copied from [assetDetail].
  const AssetDetailFamily();

  /// Provider for fetching a single asset by ID
  /// This provider fetches detailed information for a specific asset
  ///
  /// Copied from [assetDetail].
  AssetDetailProvider call(
    String assetId,
  ) {
    return AssetDetailProvider(
      assetId,
    );
  }

  @override
  AssetDetailProvider getProviderOverride(
    covariant AssetDetailProvider provider,
  ) {
    return call(
      provider.assetId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetDetailProvider';
}

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset
///
/// Copied from [assetDetail].
class AssetDetailProvider extends AutoDisposeFutureProvider<StockAsset> {
  /// Provider for fetching a single asset by ID
  /// This provider fetches detailed information for a specific asset
  ///
  /// Copied from [assetDetail].
  AssetDetailProvider(
    String assetId,
  ) : this._internal(
          (ref) => assetDetail(
            ref as AssetDetailRef,
            assetId,
          ),
          from: assetDetailProvider,
          name: r'assetDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetDetailHash,
          dependencies: AssetDetailFamily._dependencies,
          allTransitiveDependencies:
              AssetDetailFamily._allTransitiveDependencies,
          assetId: assetId,
        );

  AssetDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String assetId;

  @override
  Override overrideWith(
    FutureOr<StockAsset> Function(AssetDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetDetailProvider._internal(
        (ref) => create(ref as AssetDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<StockAsset> createElement() {
    return _AssetDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetDetailProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetDetailRef on AutoDisposeFutureProviderRef<StockAsset> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _AssetDetailProviderElement
    extends AutoDisposeFutureProviderElement<StockAsset> with AssetDetailRef {
  _AssetDetailProviderElement(super.provider);

  @override
  String get assetId => (origin as AssetDetailProvider).assetId;
}

String _$selectedAssetTypeHash() => r'0c728901cd16e576e2636227e3c7633934ab9d3e';

/// Provider for selected asset type filter
/// This provider manages the current filter state for the asset list
///
/// Copied from [SelectedAssetType].
@ProviderFor(SelectedAssetType)
final selectedAssetTypeProvider =
    AutoDisposeNotifierProvider<SelectedAssetType, AssetType?>.internal(
  SelectedAssetType.new,
  name: r'selectedAssetTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAssetTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedAssetType = AutoDisposeNotifier<AssetType?>;
String _$allAssetsHash() => r'e4b6a858ddd5891418047419e1f1f35b3d2243d5';

/// Provider for fetching all assets
/// This provider fetches the complete list of user assets from the backend
/// Supports optimistic updates for delete operations
///
/// Copied from [AllAssets].
@ProviderFor(AllAssets)
final allAssetsProvider =
    AutoDisposeAsyncNotifierProvider<AllAssets, List<StockAsset>>.internal(
  AllAssets.new,
  name: r'allAssetsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllAssets = AutoDisposeAsyncNotifier<List<StockAsset>>;
String _$assetSearchHash() => r'a05e4bad77e105e770b074481b8781880d16bc4e';

/// Provider for asset search functionality
/// This provider handles searching assets by symbol or name
///
/// Copied from [AssetSearch].
@ProviderFor(AssetSearch)
final assetSearchProvider =
    AutoDisposeNotifierProvider<AssetSearch, String>.internal(
  AssetSearch.new,
  name: r'assetSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$assetSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AssetSearch = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for selected asset type filter
/// This provider manages the current filter state for the asset list

@ProviderFor(SelectedAssetType)
final selectedAssetTypeProvider = SelectedAssetTypeProvider._();

/// Provider for selected asset type filter
/// This provider manages the current filter state for the asset list
final class SelectedAssetTypeProvider
    extends $NotifierProvider<SelectedAssetType, AssetType?> {
  /// Provider for selected asset type filter
  /// This provider manages the current filter state for the asset list
  SelectedAssetTypeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedAssetTypeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedAssetTypeHash();

  @$internal
  @override
  SelectedAssetType create() => SelectedAssetType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetType?>(value),
    );
  }
}

String _$selectedAssetTypeHash() => r'0c728901cd16e576e2636227e3c7633934ab9d3e';

/// Provider for selected asset type filter
/// This provider manages the current filter state for the asset list

abstract class _$SelectedAssetType extends $Notifier<AssetType?> {
  AssetType? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AssetType?, AssetType?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AssetType?, AssetType?>, AssetType?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for fetching all assets
/// This provider fetches the complete list of user assets from the backend
/// Supports optimistic updates for delete operations

@ProviderFor(AllAssets)
final allAssetsProvider = AllAssetsProvider._();

/// Provider for fetching all assets
/// This provider fetches the complete list of user assets from the backend
/// Supports optimistic updates for delete operations
final class AllAssetsProvider
    extends $AsyncNotifierProvider<AllAssets, List<StockAsset>> {
  /// Provider for fetching all assets
  /// This provider fetches the complete list of user assets from the backend
  /// Supports optimistic updates for delete operations
  AllAssetsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'allAssetsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$allAssetsHash();

  @$internal
  @override
  AllAssets create() => AllAssets();
}

String _$allAssetsHash() => r'e4b6a858ddd5891418047419e1f1f35b3d2243d5';

/// Provider for fetching all assets
/// This provider fetches the complete list of user assets from the backend
/// Supports optimistic updates for delete operations

abstract class _$AllAssets extends $AsyncNotifier<List<StockAsset>> {
  FutureOr<List<StockAsset>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StockAsset>>, List<StockAsset>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<StockAsset>>, List<StockAsset>>,
        AsyncValue<List<StockAsset>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for filtered assets based on selected type
/// This provider automatically updates when the filter changes

@ProviderFor(filteredAssets)
final filteredAssetsProvider = FilteredAssetsProvider._();

/// Provider for filtered assets based on selected type
/// This provider automatically updates when the filter changes

final class FilteredAssetsProvider extends $FunctionalProvider<
        AsyncValue<List<StockAsset>>,
        List<StockAsset>,
        FutureOr<List<StockAsset>>>
    with $FutureModifier<List<StockAsset>>, $FutureProvider<List<StockAsset>> {
  /// Provider for filtered assets based on selected type
  /// This provider automatically updates when the filter changes
  FilteredAssetsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredAssetsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredAssetsHash();

  @$internal
  @override
  $FutureProviderElement<List<StockAsset>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<StockAsset>> create(Ref ref) {
    return filteredAssets(ref);
  }
}

String _$filteredAssetsHash() => r'8205438f9efa3af2b2dc03f5e31d3cc53ca80f56';

/// Provider for asset search functionality
/// This provider handles searching assets by symbol or name

@ProviderFor(AssetSearch)
final assetSearchProvider = AssetSearchProvider._();

/// Provider for asset search functionality
/// This provider handles searching assets by symbol or name
final class AssetSearchProvider extends $NotifierProvider<AssetSearch, String> {
  /// Provider for asset search functionality
  /// This provider handles searching assets by symbol or name
  AssetSearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'assetSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetSearchHash();

  @$internal
  @override
  AssetSearch create() => AssetSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$assetSearchHash() => r'a05e4bad77e105e770b074481b8781880d16bc4e';

/// Provider for asset search functionality
/// This provider handles searching assets by symbol or name

abstract class _$AssetSearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for searched assets
/// Returns filtered assets based on search query

@ProviderFor(searchedAssets)
final searchedAssetsProvider = SearchedAssetsProvider._();

/// Provider for searched assets
/// Returns filtered assets based on search query

final class SearchedAssetsProvider extends $FunctionalProvider<
        AsyncValue<List<StockAsset>>,
        List<StockAsset>,
        FutureOr<List<StockAsset>>>
    with $FutureModifier<List<StockAsset>>, $FutureProvider<List<StockAsset>> {
  /// Provider for searched assets
  /// Returns filtered assets based on search query
  SearchedAssetsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchedAssetsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchedAssetsHash();

  @$internal
  @override
  $FutureProviderElement<List<StockAsset>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<StockAsset>> create(Ref ref) {
    return searchedAssets(ref);
  }
}

String _$searchedAssetsHash() => r'383a8034c470ae302add42f045f0f9bd04eff641';

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset

@ProviderFor(assetDetail)
final assetDetailProvider = AssetDetailFamily._();

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset

final class AssetDetailProvider extends $FunctionalProvider<
        AsyncValue<StockAsset>, StockAsset, FutureOr<StockAsset>>
    with $FutureModifier<StockAsset>, $FutureProvider<StockAsset> {
  /// Provider for fetching a single asset by ID
  /// This provider fetches detailed information for a specific asset
  AssetDetailProvider._(
      {required AssetDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'assetDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$assetDetailHash();

  @override
  String toString() {
    return r'assetDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StockAsset> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StockAsset> create(Ref ref) {
    final argument = this.argument as String;
    return assetDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetDetailHash() => r'17ad7e9b12d0a2ccc379f3b1aab61339072b1969';

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset

final class AssetDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StockAsset>, String> {
  AssetDetailFamily._()
      : super(
          retry: null,
          name: r'assetDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for fetching a single asset by ID
  /// This provider fetches detailed information for a specific asset

  AssetDetailProvider call(
    String assetId,
  ) =>
      AssetDetailProvider._(argument: assetId, from: this);

  @override
  String toString() => r'assetDetailProvider';
}

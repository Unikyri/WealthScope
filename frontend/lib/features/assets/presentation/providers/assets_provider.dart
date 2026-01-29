import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

part 'assets_provider.g.dart';

/// Provider for selected asset type filter
/// This provider manages the current filter state for the asset list
@riverpod
class SelectedAssetType extends _$SelectedAssetType {
  @override
  AssetType? build() {
    return null; // null means "All"
  }

  void select(AssetType? type) {
    state = type;
  }

  void reset() {
    state = null;
  }
}

/// Provider for fetching all assets
/// This provider fetches the complete list of user assets from the backend
/// Supports optimistic updates for delete operations
@riverpod
class AllAssets extends _$AllAssets {
  @override
  Future<List<StockAsset>> build() async {
    final repository = ref.watch(assetRepositoryProvider);
    return await repository.getAssets();
  }

  /// Optimistically remove an asset from the list
  /// Updates the UI immediately without waiting for the backend
  void removeAsset(String assetId) {
    state = state.whenData((assets) {
      return assets.where((asset) => asset.id != assetId).toList();
    });
  }

  /// Refresh the asset list from the backend
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(assetRepositoryProvider);
      return await repository.getAssets();
    });
  }
}

/// Provider for filtered assets based on selected type
/// This provider automatically updates when the filter changes
@riverpod
Future<List<StockAsset>> filteredAssets(FilteredAssetsRef ref) async {
  final selectedType = ref.watch(selectedAssetTypeProvider);
  final allAssetsList = await ref.watch(allAssetsProvider.future);

  // If no filter is selected, return all assets
  if (selectedType == null) {
    return allAssetsList;
  }

  // Filter by selected type
  return allAssetsList.where((asset) => asset.type == selectedType).toList();
}

/// Provider for asset search functionality
/// This provider handles searching assets by symbol or name
@riverpod
class AssetSearch extends _$AssetSearch {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Provider for searched assets
/// Returns filtered assets based on search query
@riverpod
Future<List<StockAsset>> searchedAssets(SearchedAssetsRef ref) async {
  final query = ref.watch(assetSearchProvider);
  final allAssetsList = await ref.watch(filteredAssetsProvider.future);

  if (query.isEmpty) {
    return allAssetsList;
  }

  final lowerQuery = query.toLowerCase();
  return allAssetsList.where((asset) {
    return asset.symbol.toLowerCase().contains(lowerQuery) ||
        asset.name.toLowerCase().contains(lowerQuery);
  }).toList();
}

/// Provider for fetching a single asset by ID
/// This provider fetches detailed information for a specific asset
@riverpod
Future<StockAsset> assetDetail(AssetDetailRef ref, String assetId) async {
  final repository = ref.watch(assetRepositoryProvider);
  final asset = await repository.getAssetById(assetId);
  
  if (asset == null) {
    throw Exception('Asset not found');
  }
  
  return asset;
}

import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

/// Asset Repository Interface
/// Defines the contract for asset data operations.
/// Implementation will be in data layer.
abstract class AssetRepository {
  /// Add a new asset to the user's portfolio
  Future<StockAsset> addAsset(StockAsset asset);

  /// Get all assets for the current user
  Future<List<StockAsset>> getAssets();

  /// Get assets filtered by type
  Future<List<StockAsset>> getAssetsByType(String type);

  /// Get a specific asset by ID
  Future<StockAsset?> getAssetById(String id);

  /// Update an existing asset
  Future<StockAsset> updateAsset(StockAsset asset);

  /// Delete an asset (soft delete - sets is_active = false)
  Future<void> deleteAsset(String id);

  /// Search assets by symbol or name
  Future<List<StockAsset>> searchAssets(String query);
}

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/assets/data/datasources/asset_remote_data_source.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';
import 'package:wealthscope_app/features/assets/data/models/create_asset_request.dart';
import 'package:wealthscope_app/features/assets/data/models/update_asset_request.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/domain/repositories/asset_repository.dart';

/// Asset Repository Implementation
/// Implements the asset repository interface using remote data source
class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDataSource _remoteDataSource;

  AssetRepositoryImpl(this._remoteDataSource);

  @override
  Future<StockAsset> addAsset(StockAsset asset) async {
    try {
      // Convert domain entity to create request DTO
      final request = CreateAssetRequest(
        type: asset.type.toApiString(),
        name: asset.name,
        quantity: asset.quantity,
        purchasePrice: asset.purchasePrice,
        symbol: asset.symbol.isNotEmpty ? asset.symbol : null,
        currency: asset.currency.code,
        currentPrice: asset.currentPrice,
        purchaseDate: asset.purchaseDate != null 
            ? DateFormat('yyyy-MM-dd').format(asset.purchaseDate!)
            : null,
        metadata: asset.metadata.isNotEmpty ? asset.metadata : null,
        notes: asset.notes,
      );
      
      final result = await _remoteDataSource.createAsset(request);
      return result.toDomain();
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to add asset: $e');
    }
  }

  @override
  Future<List<StockAsset>> getAssets() async {
    try {
      print('🔵 [AssetRepository] Fetching assets from API...');
      final dtos = await _remoteDataSource.getAssets();
      print('🔵 [AssetRepository] Received ${dtos.length} assets from API');
      
      final assets = dtos.map((dto) {
        print('🔵 [AssetRepository] Converting DTO: ${dto.name} (${dto.type})');
        return dto.toDomain();
      }).toList();
      
      print('✅ [AssetRepository] Successfully converted ${assets.length} assets');
      return assets;
    } on DioException catch (e) {
      print('❌ [AssetRepository] DioException: ${e.message}');
      print('❌ [AssetRepository] Status: ${e.response?.statusCode}');
      print('❌ [AssetRepository] Response: ${e.response?.data}');
      throw _extractFailure(e);
    } catch (e) {
      print('❌ [AssetRepository] Unexpected error: $e');
      throw UnexpectedFailure('Failed to get assets: $e');
    }
  }

  @override
  Future<List<StockAsset>> getAssetsByType(String type) async {
    try {
      final dtos = await _remoteDataSource.getAssetsByType(type);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to get assets by type: $e');
    }
  }

  @override
  Future<StockAsset?> getAssetById(String id) async {
    try {
      final dto = await _remoteDataSource.getAssetById(id);
      return dto.toDomain();
    } on DioException catch (e) {
      // If 404, return null instead of throwing
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to get asset: $e');
    }
  }

  @override
  Future<StockAsset> updateAsset(StockAsset asset) async {
    try {
      print('🔵 [AssetRepository] Updating asset: ${asset.name} (${asset.id})');
      
      if (asset.id == null) {
        throw const ValidationFailure('Asset ID is required for update');
      }
      
      // Convert domain entity to update request DTO
      final request = UpdateAssetRequest(
        type: asset.type.toApiString(),
        name: asset.name,
        quantity: asset.quantity,
        purchasePrice: asset.purchasePrice,
        symbol: asset.symbol.isNotEmpty ? asset.symbol : null,
        currency: asset.currency.code,
        currentPrice: asset.currentPrice,
        purchaseDate: asset.purchaseDate != null
            ? DateFormat('yyyy-MM-dd').format(asset.purchaseDate!)
            : null,
        metadata: asset.metadata.isNotEmpty ? asset.metadata : null,
        notes: asset.notes,
      );
      
      print('🔵 [AssetRepository] Update request: ${request.toJson()}');
      
      final result = await _remoteDataSource.updateAsset(asset.id!, request);
      print('✅ [AssetRepository] Asset updated successfully');
      return result.toDomain();
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to update asset: $e');
    }
  }

  @override
  Future<void> deleteAsset(String id) async {
    try {
      await _remoteDataSource.deleteAsset(id);
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to delete asset: $e');
    }
  }

  @override
  Future<List<StockAsset>> searchAssets(String query) async {
    try {
      final dtos = await _remoteDataSource.searchAssets(query);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
      throw UnexpectedFailure('Failed to search assets: $e');
    }
  }

  /// Extract Failure from DioException
  /// The ErrorInterceptor already attached a Failure object
  Failure _extractFailure(DioException e) {
    if (e.error is Failure) {
      return e.error as Failure;
    }
    return UnexpectedFailure('Network error: ${e.message}');
  }
}

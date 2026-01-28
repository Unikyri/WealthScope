import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/assets/data/datasources/asset_remote_data_source.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';
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
      final dto = AssetDto.fromDomain(asset);
      final result = await _remoteDataSource.createAsset(dto);
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
      final dtos = await _remoteDataSource.getAssets();
      return dtos.map((dto) => dto.toDomain()).toList();
    } on DioException catch (e) {
      throw _extractFailure(e);
    } catch (e) {
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
      if (asset.id == null) {
        throw const ValidationFailure('Asset ID is required for update');
      }
      
      final dto = AssetDto.fromDomain(asset);
      final result = await _remoteDataSource.updateAsset(asset.id!, dto);
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

import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/network/api_response.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';

/// Asset Remote Data Source
/// Handles all HTTP requests related to assets using the backend API
class AssetRemoteDataSource {
  final Dio _dio;

  AssetRemoteDataSource(this._dio);

  /// Create a new asset
  /// POST /api/v1/assets
  Future<AssetDto> createAsset(AssetDto asset) async {
    final response = await _dio.post(
      '/assets',
      data: asset.toJson(),
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return AssetDto.fromJson(apiResponse.data);
  }

  /// Get all assets for the current user
  /// GET /api/v1/assets
  Future<List<AssetDto>> getAssets({
    String? type,
    int page = 1,
    int perPage = 20,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final response = await _dio.get(
      '/assets',
      queryParameters: {
        if (type != null) 'type': type,
        'page': page,
        'per_page': perPage,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );

    final apiResponse = PaginatedApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return apiResponse.data.map((json) => AssetDto.fromJson(json)).toList();
  }

  /// Get a specific asset by ID
  /// GET /api/v1/assets/{id}
  Future<AssetDto> getAssetById(String id) async {
    final response = await _dio.get('/assets/$id');

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return AssetDto.fromJson(apiResponse.data);
  }

  /// Update an existing asset
  /// PUT /api/v1/assets/{id}
  Future<AssetDto> updateAsset(String id, AssetDto asset) async {
    final response = await _dio.put(
      '/assets/$id',
      data: asset.toJson(),
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return AssetDto.fromJson(apiResponse.data);
  }

  /// Delete an asset
  /// DELETE /api/v1/assets/{id}
  Future<void> deleteAsset(String id) async {
    await _dio.delete('/assets/$id');
  }

  /// Get assets by type
  /// GET /api/v1/assets?type={type}
  Future<List<AssetDto>> getAssetsByType(String type) async {
    return getAssets(type: type);
  }

  /// Search assets by symbol or name
  /// This uses the base getAssets with filtering on frontend
  /// TODO: If backend adds dedicated search endpoint, update this
  Future<List<AssetDto>> searchAssets(String query) async {
    final allAssets = await getAssets();
    
    final lowerQuery = query.toLowerCase();
    return allAssets.where((asset) {
      final symbolMatch = asset.symbol?.toLowerCase().contains(lowerQuery) ?? false;
      final nameMatch = asset.name.toLowerCase().contains(lowerQuery);
      return symbolMatch || nameMatch;
    }).toList();
  }
}

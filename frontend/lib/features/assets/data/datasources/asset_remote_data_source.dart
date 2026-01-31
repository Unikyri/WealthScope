import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/network/api_response.dart';
import 'package:wealthscope_app/features/assets/data/models/asset_dto.dart';
import 'package:wealthscope_app/features/assets/data/models/create_asset_request.dart';
import 'package:wealthscope_app/features/assets/data/models/update_asset_request.dart';

/// Asset Remote Data Source
/// Handles all HTTP requests related to assets using the backend API
class AssetRemoteDataSource {
  final Dio _dio;

  AssetRemoteDataSource(this._dio);

  /// Create a new asset
  /// POST /api/v1/assets
  Future<AssetDto> createAsset(CreateAssetRequest request) async {
    final response = await _dio.post(
      '/assets',
      data: request.toJson(),
    );

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    return AssetDto.fromJson(apiResponse.data);
  }

  /// Get all assets for the current user
  /// GET /api/v1/assets with pagination
  Future<List<AssetDto>> getAssets({
    String? type,
    String? symbol,
    String? currency,
    int page = 1,
    int perPage = 20,
  }) async {
    print('🟣 [AssetDataSource] GET /assets (page: $page, perPage: $perPage)');
    
    final response = await _dio.get(
      '/assets',
      queryParameters: {
        if (type != null) 'type': type,
        if (symbol != null) 'symbol': symbol,
        if (currency != null) 'currency': currency,
        'page': page,
        'per_page': perPage,
      },
    );

    print('🟣 [AssetDataSource] Response status: ${response.statusCode}');
    print('🟣 [AssetDataSource] Response data: ${response.data}');

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    print('🟣 [AssetDataSource] ApiResponse success: ${apiResponse.success}');
    print('🟣 [AssetDataSource] ApiResponse data keys: ${apiResponse.data.keys}');

    // API returns {assets: [...], pagination: {...}}
    final data = apiResponse.data;
    final assetsList = data['assets'] as List<dynamic>;
    
    print('🟣 [AssetDataSource] Assets list length: ${assetsList.length}');
    
    final dtos = <AssetDto>[];
    for (var i = 0; i < assetsList.length; i++) {
      try {
        final json = assetsList[i] as Map<String, dynamic>;
        print('🟣 [AssetDataSource] Parsing asset $i: ${json['name']}');
        print('🟣 [AssetDataSource] JSON keys: ${json.keys.toList()}');
        print('🟣 [AssetDataSource] Full JSON: $json');
        
        final dto = AssetDto.fromJson(json);
        print('✅ [AssetDataSource] Successfully parsed: ${dto.name}');
        dtos.add(dto);
      } catch (e, stack) {
        print('❌ [AssetDataSource] Failed to parse asset $i: $e');
        print('❌ [AssetDataSource] Stack: $stack');
        print('❌ [AssetDataSource] JSON was: ${assetsList[i]}');
        rethrow;
      }
    }
    
    print('✅ [AssetDataSource] Returning ${dtos.length} DTOs');
    return dtos;
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
  Future<AssetDto> updateAsset(String id, UpdateAssetRequest request) async {
    final response = await _dio.put(
      '/assets/$id',
      data: request.toJson(),
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

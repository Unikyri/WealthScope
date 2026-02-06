import 'package:dio/dio.dart';
import '../models/ocr_dto.dart';

/// Remote Data Source for AI OCR
class OCRRemoteDataSource {
  final Dio _dio;

  OCRRemoteDataSource(this._dio);

  /// POST /api/v1/ai/ocr
  Future<OCRResultDto> processDocument({
    required String filePath,
    String? documentHint,
  }) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
      if (documentHint != null) 'document_hint': documentHint,
    });

    final response = await _dio.post(
      '/ai/ocr',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return OCRResultDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /api/v1/ai/ocr/confirm
  Future<OCRConfirmationDto> confirmAssets({
    required List<ConfirmAssetDto> assets,
  }) async {
    final request = ConfirmAssetsRequestDto(assets: assets);

    final response = await _dio.post(
      '/ai/ocr/confirm',
      data: request.toJson(),
    );

    return OCRConfirmationDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}

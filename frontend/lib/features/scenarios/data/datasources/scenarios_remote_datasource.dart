import 'package:dio/dio.dart';
import '../models/scenario_dto.dart';

/// Remote Data Source for Scenarios
class ScenariosRemoteDataSource {
  final Dio _dio;

  ScenariosRemoteDataSource(this._dio);

  /// POST /api/v1/ai/simulate
  Future<SimulationResultDto> simulate({
    required String type,
    required Map<String, dynamic> parameters,
  }) async {
    final request = SimulateRequestDto(
      type: type,
      parameters: parameters,
    );

    final response = await _dio.post(
      '/ai/simulate',
      data: request.toJson(),
    );

    return SimulationResultDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// GET /api/v1/ai/scenarios/historical
  Future<HistoricalStatsDto> getHistoricalStats({
    required String symbol,
    String period = '1Y',
  }) async {
    final response = await _dio.get(
      '/ai/scenarios/historical',
      queryParameters: {
        'symbol': symbol,
        'period': period,
      },
    );

    return HistoricalStatsDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// GET /api/v1/ai/scenarios/templates
  Future<List<ScenarioTemplateDto>> getTemplates() async {
    final response = await _dio.get('/ai/scenarios/templates');

    final templates = (response.data['data']['templates'] as List)
        .map((json) => ScenarioTemplateDto.fromJson(json as Map<String, dynamic>))
        .toList();

    return templates;
  }
}

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
    print('🚀 [SCENARIOS_DS] simulate called');
    print('   Type: $type');
    print('   Parameters: $parameters');
    
    final request = SimulateRequestDto(
      type: type,
      parameters: parameters,
    );

    print('🌐 [SCENARIOS_DS] Sending POST to /ai/simulate');
    print('   Request body: ${request.toJson()}');
    
    final response = await _dio.post(
      '/ai/simulate',
      data: request.toJson(),
    );

    print('✅ [SCENARIOS_DS] Response received');
    print('   Status: ${response.statusCode}');
    print('   Data keys: ${response.data?.keys}');

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

  /// POST /api/v1/ai/simulate/chain
  Future<Map<String, dynamic>> simulateChain({
    required List<Map<String, dynamic>> scenarios,
    String? query,
  }) async {
    final response = await _dio.post(
      '/ai/simulate/chain',
      data: {
        'scenarios': scenarios,
        if (query != null) 'query': query,
      },
    );

    return response.data['data'] as Map<String, dynamic>;
  }
}


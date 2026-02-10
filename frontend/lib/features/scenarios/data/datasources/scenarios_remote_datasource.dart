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
    try {
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
        options: Options(
          sendTimeout: const Duration(seconds: 180), // 3 minutes for AI simulation
          receiveTimeout: const Duration(seconds: 180),
        ),
      );

      print('✅ [SCENARIOS_DS] Response received');
      print('   Status: ${response.statusCode}');
      print('   Data keys: ${response.data?.keys}');

      return SimulationResultDto.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print('❌ [SCENARIOS_DS] Error: ${e.type}');
      
      // Handle timeout errors specifically
      if (e.type == DioExceptionType.sendTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('La simulación está tardando más de lo esperado. Esto puede deberse a la complejidad del escenario. Por favor, intenta nuevamente.');
      }
      
      // Extract error message from API response
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('error') && errorData['error'] is Map) {
          final errorInfo = errorData['error'] as Map<String, dynamic>;
          final errorMessage = errorInfo['message'] as String?;
          if (errorMessage != null) {
            throw Exception(errorMessage);
          }
        }
      }
      throw Exception('Error en simulación: ${e.message}');
    }
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
    try {
      final response = await _dio.post(
        '/ai/simulate/chain',
        data: {
          'scenarios': scenarios,
          if (query != null) 'query': query,
        },
        options: Options(
          sendTimeout: const Duration(seconds: 180), // 3 minutes for chain simulation
          receiveTimeout: const Duration(seconds: 180),
        ),
      );

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      // Handle timeout errors specifically
      if (e.type == DioExceptionType.sendTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('La simulación en cadena está tardando más de lo esperado. Por favor, intenta nuevamente.');
      }
      
      // Extract error message from API response
      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        if (errorData.containsKey('error') && errorData['error'] is Map) {
          final errorInfo = errorData['error'] as Map<String, dynamic>;
          final errorMessage = errorInfo['message'] as String?;
          if (errorMessage != null) {
            throw Exception(errorMessage);
          }
        }
      }
      throw Exception('Error en simulación en cadena: ${e.message}');
    }
  }
}


import 'package:dio/dio.dart';
import '../models/insight_dto.dart';

/// Remote Data Source for AI Insights
class InsightsRemoteDataSource {
  final Dio _dio;

  InsightsRemoteDataSource(this._dio);

  /// GET /api/v1/ai/insights
  Future<List<InsightDto>> listInsights({
    String? type,
    String? category,
    String? priority,
    bool? unread,
    int? limit,
    int? offset,
  }) async {
    print('🚀 [DATASOURCE] Llamando API: GET /ai/insights - params: type=$type, category=$category, priority=$priority, unread=$unread, limit=$limit, offset=$offset');
    final response = await _dio.get(
      '/ai/insights',
      queryParameters: {
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (priority != null) 'priority': priority,
        if (unread != null) 'unread': unread,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );
    print('✅ [DATASOURCE] API Response recibido: GET /ai/insights - status: ${response.statusCode}');

    final insights = (response.data['data']['insights'] as List)
        .map((json) => InsightDto.fromJson(json as Map<String, dynamic>))
        .toList();
    print('✅ [DATASOURCE] Insights parseados: ${insights.length} items');

    return insights;
  }

  /// GET /api/v1/ai/insights/daily
  Future<InsightDto> getDailyBriefing() async {
    final response = await _dio.get('/ai/insights/daily');
    return InsightDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// GET /api/v1/ai/insights/{id}
  Future<InsightDto> getInsightById(String id) async {
    final response = await _dio.get('/ai/insights/$id');
    return InsightDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// PUT /api/v1/ai/insights/{id}/read
  Future<void> markAsRead(String id) async {
    await _dio.put('/ai/insights/$id/read');
  }

  /// GET /api/v1/ai/insights/unread/count
  Future<int> getUnreadCount() async {
    print('🚀 [DATASOURCE] Llamando API: GET /ai/insights/unread/count');
    final response = await _dio.get('/ai/insights/unread/count');
    final count = response.data['data']['count'] as int;
    print('✅ [DATASOURCE] API Response recibido: count=$count');
    return count;
  }

  /// POST /api/v1/ai/insights/generate
  Future<List<InsightDto>> generateInsights() async {
    final response = await _dio.post('/ai/insights/generate');
    final insights = (response.data['data'] as List)
        .map((json) => InsightDto.fromJson(json as Map<String, dynamic>))
        .toList();
    return insights;
  }
}

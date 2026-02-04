import 'package:dio/dio.dart';
import 'package:wealthscope_app/features/ai/data/models/chat_message_dto.dart';

class AIRemoteDataSource {
  final Dio _dio;

  AIRemoteDataSource(this._dio);

  Future<Map<String, dynamic>> sendMessage({
    required String message,
    String? conversationId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/ai/chat',
        data: {
          'message': message,
          if (conversationId != null) 'conversation_id': conversationId,
        },
      );

      return response.data['data'];
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getInsights({bool includeBriefing = true}) async {
    try {
      final response = await _dio.get(
        '/api/v1/ai/insights',
        queryParameters: {
          'include_briefing': includeBriefing,
        },
      );

      return response.data['data'];
    } on DioException catch (e) {
      throw Exception('Failed to get insights: ${e.message}');
    }
  }

  Future<List<ChatMessageDTO>> getChatHistory() async {
    try {
      final response = await _dio.get('/api/ai/history');

      final List<dynamic> data = response.data;
      return data.map((json) => ChatMessageDTO.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get chat history: ${e.message}');
    }
  }

  Future<void> clearHistory() async {
    try {
      await _dio.delete('/api/ai/history');
    } on DioException catch (e) {
      throw Exception('Failed to clear history: ${e.message}');
    }
  }
}

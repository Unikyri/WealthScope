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
        '/ai/chat',
        data: {
          'message': message,
          if (conversationId != null) 'conversation_id': conversationId,
        },
      );

      return response.data['data'];
    } on DioException catch (e) {
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
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getInsights({bool includeBriefing = true}) async {
    try {
      final response = await _dio.get(
        '/ai/insights',
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
      final response = await _dio.get('/ai/history');

      final List<dynamic> data = response.data;
      return data.map((json) => ChatMessageDTO.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to get chat history: ${e.message}');
    }
  }

  Future<void> clearHistory() async {
    try {
      await _dio.delete('/ai/history');
    } on DioException catch (e) {
      throw Exception('Failed to clear history: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getBriefing() async {
    try {
      final response = await _dio.get('/ai/insights/daily');
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('Failed to get briefing: ${e.message}');
    }
  }
}


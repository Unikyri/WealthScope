import 'package:dio/dio.dart';
import 'package:wealthscope_app/features/ai/data/models/chat_message_dto.dart';

class AIRemoteDataSource {
  final Dio _dio;

  AIRemoteDataSource(this._dio);

  Future<ChatMessageDTO> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/api/ai/chat',
        data: {
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return ChatMessageDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
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

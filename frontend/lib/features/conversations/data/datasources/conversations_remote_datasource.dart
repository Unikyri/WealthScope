import 'package:dio/dio.dart';
import '../models/conversation_dto.dart';

/// Remote Data Source for AI Conversations
class ConversationsRemoteDataSource {
  final Dio _dio;

  ConversationsRemoteDataSource(this._dio);

  /// GET /api/v1/ai/conversations
  Future<ConversationListDto> listConversations({
    int? limit,
    int? offset,
  }) async {
    final response = await _dio.get(
      '/ai/conversations',
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );

    return ConversationListDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// POST /api/v1/ai/conversations
  Future<ConversationDto> createConversation({
    required String title,
  }) async {
    final request = CreateConversationRequestDto(title: title);

    final response = await _dio.post(
      '/ai/conversations',
      data: request.toJson(),
    );

    return ConversationDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// GET /api/v1/ai/conversations/{id}
  Future<ConversationWithMessagesDto> getConversation(String id) async {
    final response = await _dio.get('/ai/conversations/$id');

    return ConversationWithMessagesDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// PUT /api/v1/ai/conversations/{id}
  Future<void> updateConversation({
    required String id,
    required String title,
  }) async {
    final request = UpdateConversationRequestDto(title: title);

    await _dio.put(
      '/ai/conversations/$id',
      data: request.toJson(),
    );
  }

  /// DELETE /api/v1/ai/conversations/{id}
  Future<void> deleteConversation(String id) async {
    await _dio.delete('/ai/conversations/$id');
  }

  /// GET /api/v1/ai/welcome
  Future<WelcomeMessageDto> getWelcomeMessage() async {
    final response = await _dio.get('/ai/welcome');

    return WelcomeMessageDto.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}

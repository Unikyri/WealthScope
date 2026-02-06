import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/network/dio_client_provider.dart';
import 'package:wealthscope_app/features/ai/data/datasources/ai_remote_data_source.dart';
import 'package:wealthscope_app/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';
import 'package:wealthscope_app/features/ai/domain/repositories/ai_repository.dart';

part 'ai_chat_provider.g.dart';

// Repository Provider
@riverpod
AIRepository aiRepository(AiRepositoryRef ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = AIRemoteDataSource(dio);
  return AIRepositoryImpl(dataSource);
}

// Chat State Provider with keepAlive to persist history
@Riverpod(keepAlive: true)
class AiChat extends _$AiChat {
  String? _conversationId;

  @override
  Future<List<ChatMessage>> build() async {
    // Load existing conversation or start fresh
    return [];
  }

  Future<void> sendMessage(String content) async {
    final currentMessages = state.value ?? [];
    
    // Add user message immediately (optimistic update)
    final userMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
    );
    
    state = AsyncData([...currentMessages, userMessage]);
    
    // Set typing indicator
    ref.read(aiIsTypingProvider.notifier).state = true;
    
    try {
      final repository = ref.read(aiRepositoryProvider);
      final result = await repository.sendMessage(
        message: content,
        conversationId: _conversationId,
      );
      
      await result.fold(
        (failure) {
          // Remove optimistic user message on error
          state = AsyncData(currentMessages);
          throw Exception(failure.message);
        },
        (response) {
          _conversationId = response.conversationId;
          
          // Replace optimistic user message with the actual one and add AI response
          final messages = [...currentMessages, response.userMessage, response.aiMessage];
          state = AsyncData(messages);
        },
      );
    } catch (e) {
      // Remove optimistic user message on error
      state = AsyncData(currentMessages);
      rethrow;
    } finally {
      ref.read(aiIsTypingProvider.notifier).state = false;
    }
  }

  void newConversation() {
    _conversationId = null;
    state = const AsyncData([]);
  }
}

// Typing Indicator Provider
@riverpod
class AiIsTyping extends _$AiIsTyping {
  @override
  bool build() => false;
}

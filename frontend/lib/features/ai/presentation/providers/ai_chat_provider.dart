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

// Chat State Provider
@riverpod
class AiChat extends _$AiChat {
  @override
  Future<List<ChatMessage>> build() async {
    // Load initial chat history
    final repository = ref.read(aiRepositoryProvider);
    final result = await repository.getChatHistory();
    
    return result.fold(
      (failure) => [],
      (messages) => messages,
    );
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message immediately
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    state = AsyncData([...?state.value, userMessage]);
    
    // Set typing indicator
    ref.read(aiIsTypingProvider.notifier).state = true;

    // Send message to backend
    final repository = ref.read(aiRepositoryProvider);
    final result = await repository.sendMessage(content);

    result.fold(
      (failure) {
        // Add error message
        final errorMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Sorry, I encountered an error: ${failure.message}',
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
          isError: true,
        );
        state = AsyncData([...?state.value, errorMessage]);
      },
      (aiResponse) {
        // Add AI response
        state = AsyncData([...?state.value, aiResponse]);
      },
    );

    // Clear typing indicator
    ref.read(aiIsTypingProvider.notifier).state = false;
  }

  Future<void> newConversation() async {
    final repository = ref.read(aiRepositoryProvider);
    await repository.clearHistory();
    state = const AsyncData([]);
  }
}

// Typing Indicator Provider
@riverpod
class AiIsTyping extends _$AiIsTyping {
  @override
  bool build() => false;
}

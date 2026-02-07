import 'package:fpdart/fpdart.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/ai/domain/entities/briefing.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';

abstract class AIRepository {
  Future<Either<Failure, ChatResponse>> sendMessage({
    required String message,
    String? conversationId,
  });
  
  Future<Either<Failure, InsightsResponse>> getInsights({
    bool includeBriefing = true,
  });
  
  Future<Either<Failure, Briefing>> getBriefing();
  
  Future<Either<Failure, List<ChatMessage>>> getChatHistory();
  Future<Either<Failure, void>> clearHistory();
}


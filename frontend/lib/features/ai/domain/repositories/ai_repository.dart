import 'package:fpdart/fpdart.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';

abstract class AIRepository {
  Future<Either<Failure, ChatMessage>> sendMessage(String message);
  Future<Either<Failure, List<ChatMessage>>> getChatHistory();
  Future<Either<Failure, void>> clearHistory();
}

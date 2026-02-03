import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/ai/data/datasources/ai_remote_data_source.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';
import 'package:wealthscope_app/features/ai/domain/repositories/ai_repository.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource _remoteDataSource;

  AIRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ChatMessage>> sendMessage(String message) async {
    try {
      final dto = await _remoteDataSource.sendMessage(message);
      return Right(dto.toDomain());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatHistory() async {
    try {
      final dtos = await _remoteDataSource.getChatHistory();
      return Right(dtos.map((dto) => dto.toDomain()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await _remoteDataSource.clearHistory();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../ai/domain/entities/chain_result.dart';
import '../entities/scenario_entity.dart';

/// Abstract Repository for Scenarios
abstract class ScenariosRepository {
  /// Run a what-if scenario simulation
  Future<Either<Failure, SimulationResultEntity>> simulate({
    required String type,
    required Map<String, dynamic> parameters,
  });

  /// Run a chain of scenario simulations
  Future<Either<Failure, ChainResult>> simulateChain({
    required List<Map<String, dynamic>> scenarios,
    String? query,
  });

  /// Get historical statistics for a symbol
  Future<Either<Failure, HistoricalStatsEntity>> getHistoricalStats({
    required String symbol,
    String period = '1Y',
  });

  /// Get predefined scenario templates
  Future<Either<Failure, List<ScenarioTemplateEntity>>> getTemplates();
}


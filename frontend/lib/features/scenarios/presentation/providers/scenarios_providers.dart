import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/scenarios_remote_datasource.dart';
import '../../data/repositories/scenarios_repository_impl.dart';
import '../../domain/entities/scenario_entity.dart';
import '../../domain/repositories/scenarios_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'scenarios_providers.g.dart';

/// Provider for ScenariosRepository
@riverpod
ScenariosRepository scenariosRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  final dataSource = ScenariosRemoteDataSource(dio);
  return ScenariosRepositoryImpl(dataSource);
}

/// Provider to get scenario templates
@riverpod
Future<List<ScenarioTemplateEntity>> scenarioTemplates(
  Ref ref,
) async {
  final repository = ref.watch(scenariosRepositoryProvider);
  final result = await repository.getTemplates();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (templates) => templates,
  );
}

/// Provider to get historical stats for a symbol
@riverpod
Future<HistoricalStatsEntity> historicalStats(
  Ref ref, {
  required String symbol,
  String period = '1Y',
}) async {
  final repository = ref.watch(scenariosRepositoryProvider);
  final result = await repository.getHistoricalStats(
    symbol: symbol,
    period: period,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
}

/// Provider to run simulation
@riverpod
class RunSimulation extends _$RunSimulation {
  @override
  FutureOr<SimulationResultEntity?> build() => null;

  Future<void> simulate({
    required String type,
    required Map<String, dynamic> parameters,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(scenariosRepositoryProvider);
    final result = await repository.simulate(
      type: type,
      parameters: parameters,
    );
    state = result.fold(
      (failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (simulationResult) => AsyncData(simulationResult),
    );
  }

  void clearResult() {
    state = const AsyncData(null);
  }
}

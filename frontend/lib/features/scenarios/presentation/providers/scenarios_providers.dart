import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_client_provider.dart';
import '../../data/datasources/scenarios_remote_datasource.dart';
import '../../data/repositories/scenarios_repository_impl.dart';
import '../../domain/entities/scenario_entity.dart';
import '../../domain/repositories/scenarios_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/features/auth/data/services/user_sync_service.dart';

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
  FutureOr<SimulationResultEntity?> build() {
    ref.keepAlive();
    return null;
  }

  /// Ensures the user is synced in the backend database.
  /// This is critical because the backend needs the user record to simulate.
  Future<void> _ensureUserSynced() async {
    try {
      print('🔄 [SIMULATE] Syncing user with backend...');
      final syncService = UserSyncService(DioClient.instance);
      await syncService.syncUserWithBackend();
      print('✅ [SIMULATE] User synced successfully');
    } catch (e) {
      print('⚠️ [SIMULATE] User sync failed (may already exist): $e');
      // Don't throw - user might already be synced
    }
  }

  Future<void> simulate({
    required String type,
    required Map<String, dynamic> parameters,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(scenariosRepositoryProvider);

      // Step 1: Ensure user is synced in backend DB before simulating
      await _ensureUserSynced();

      if (!ref.mounted) return;

      // Step 2: Try simulate
      print('🚀 [SIMULATE] Calling /ai/simulate (type: $type)');
      var result = await repository.simulate(
        type: type,
        parameters: parameters,
      );

      if (!ref.mounted) return;

      // Step 3: If 401, try refresh token + sync + retry once
      final isAuth401 = result.fold(
        (failure) =>
            failure.message.contains('401') ||
            failure.message.contains('Authentication required') ||
            failure.message.contains('Unauthorized'),
        (_) => false,
      );

      if (isAuth401) {
        print('🔄 [SIMULATE] Got 401 - refreshing token and re-syncing...');

        try {
          // Refresh the Supabase session to get a fresh token
          final refreshResponse =
              await Supabase.instance.client.auth.refreshSession();

          if (!ref.mounted) return;

          if (refreshResponse.session != null) {
            print('✅ [SIMULATE] Token refreshed - Expiry: '
                '${DateTime.fromMillisecondsSinceEpoch(refreshResponse.session!.expiresAt! * 1000)}');

            // Re-sync user with fresh token
            await _ensureUserSynced();

            if (!ref.mounted) return;

            // Wait a moment for backend to process
            await Future.delayed(const Duration(milliseconds: 300));

            if (!ref.mounted) return;

            // Retry simulate
            print('🔄 [SIMULATE] Retrying simulation with fresh token...');
            result = await repository.simulate(
              type: type,
              parameters: parameters,
            );

            if (!ref.mounted) return;
          } else {
            print('❌ [SIMULATE] Token refresh returned null session');
          }
        } catch (refreshError) {
          print('❌ [SIMULATE] Refresh/sync error: $refreshError');
        }
      }

      // Step 4: Set final state
      if (ref.mounted) {
        state = result.fold(
          (failure) {
            print('❌ [SIMULATE] Final error: ${failure.message}');
            return AsyncError(Exception(failure.message), StackTrace.current);
          },
          (simulationResult) {
            print('✅ [SIMULATE] Simulation completed successfully!');
            return AsyncData(simulationResult);
          },
        );
      }
    } catch (e, stackTrace) {
      print('❌ [SIMULATE] Exception: $e');
      if (ref.mounted) {
        state = AsyncError(e, stackTrace);
      }
    }
  }

  void clearResult() {
    state = const AsyncData(null);
  }
}

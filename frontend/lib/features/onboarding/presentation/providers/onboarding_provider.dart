import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthscope_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:wealthscope_app/features/onboarding/domain/repositories/onboarding_repository.dart';

part 'onboarding_provider.g.dart';

/// Provider for SharedPreferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// Provider for OnboardingRepository
@Riverpod(keepAlive: true)
Future<OnboardingRepository> onboardingRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return OnboardingRepositoryImpl(prefs);
}

/// Onboarding state notifier
@riverpod
class Onboarding extends _$Onboarding {
  @override
  Future<bool> build() async {
    final repository = await ref.watch(onboardingRepositoryProvider.future);
    return await repository.hasCompletedOnboarding();
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final repository = await ref.read(onboardingRepositoryProvider.future);
    await repository.completeOnboarding();
    state = const AsyncValue.data(true);
  }

  /// Reset onboarding state (for testing)
  Future<void> resetOnboarding() async {
    final repository = await ref.read(onboardingRepositoryProvider.future);
    await repository.resetOnboarding();
    state = const AsyncValue.data(false);
  }
}

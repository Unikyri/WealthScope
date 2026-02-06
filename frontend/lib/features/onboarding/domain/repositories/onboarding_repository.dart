/// Abstract repository for onboarding state management
abstract class OnboardingRepository {
  /// Check if onboarding has been completed
  Future<bool> hasCompletedOnboarding();

  /// Mark onboarding as completed
  Future<void> completeOnboarding();

  /// Reset onboarding state (for testing)
  Future<void> resetOnboarding();
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthscope_app/features/onboarding/domain/repositories/onboarding_repository.dart';

/// Implementation of OnboardingRepository using SharedPreferences
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const String _onboardingKey = 'has_completed_onboarding';
  final SharedPreferences _prefs;

  OnboardingRepositoryImpl(this._prefs);

  @override
  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  @override
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingKey);
  }
}

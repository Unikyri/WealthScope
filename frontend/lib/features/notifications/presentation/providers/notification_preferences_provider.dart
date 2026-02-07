import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthscope_app/features/notifications/domain/entities/notification_preferences.dart';

part 'notification_preferences_provider.g.dart';

/// Provider for managing notification preferences
/// Persists user's notification settings to SharedPreferences
@riverpod
class NotificationPreferencesNotifier extends _$NotificationPreferencesNotifier {
  static const String _storageKey = 'notification_preferences';

  @override
  Future<NotificationPreferences> build() async {
    return await _loadPreferences();
  }

  /// Load notification preferences from SharedPreferences
  Future<NotificationPreferences> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return NotificationPreferences.fromJson(json);
      }
    } catch (e) {
      // If loading fails, return defaults
    }
    
    return NotificationPreferences.defaults();
  }

  /// Save preferences to SharedPreferences
  Future<void> _savePreferences(NotificationPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(preferences.toJson());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      // Handle error silently or log
    }
  }

  /// Toggle price alerts
  Future<void> togglePriceAlerts(bool value) async {
    final currentPrefs = state.asData?.value ?? NotificationPreferences.defaults();
    final newPrefs = currentPrefs.copyWith(priceAlerts: value);
    
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
    
    // TODO: Sync with backend
    // await _syncWithBackend(newPrefs);
  }

  /// Toggle daily briefing
  Future<void> toggleDailyBriefing(bool value) async {
    final currentPrefs = state.asData?.value ?? NotificationPreferences.defaults();
    final newPrefs = currentPrefs.copyWith(dailyBriefing: value);
    
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
    
    // TODO: Sync with backend
  }

  /// Toggle portfolio alerts
  Future<void> togglePortfolioAlerts(bool value) async {
    final currentPrefs = state.asData?.value ?? NotificationPreferences.defaults();
    final newPrefs = currentPrefs.copyWith(portfolioAlerts: value);
    
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
    
    // TODO: Sync with backend
  }

  /// Toggle AI insights
  Future<void> toggleAiInsights(bool value) async {
    final currentPrefs = state.asData?.value ?? NotificationPreferences.defaults();
    final newPrefs = currentPrefs.copyWith(aiInsights: value);
    
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
    
    // TODO: Sync with backend
  }

  /// Enable all notifications
  Future<void> enableAll() async {
    final newPrefs = NotificationPreferences.defaults();
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
  }

  /// Disable all notifications
  Future<void> disableAll() async {
    final newPrefs = const NotificationPreferences(
      priceAlerts: false,
      dailyBriefing: false,
      portfolioAlerts: false,
      aiInsights: false,
    );
    state = AsyncValue.data(newPrefs);
    await _savePreferences(newPrefs);
  }

  // Future method to sync with backend (placeholder)
  // Future<void> _syncWithBackend(NotificationPreferences prefs) async {
  //   final dio = ref.read(dioClientProvider);
  //   await dio.put('/user/notification-preferences', data: prefs.toJson());
  // }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/notifications/domain/entities/notification_preferences.dart';

void main() {
  group('NotificationPreferences', () {
    test('should create default preferences with all enabled', () {
      final prefs = NotificationPreferences.defaults();

      expect(prefs.priceAlerts, true);
      expect(prefs.dailyBriefing, true);
      expect(prefs.portfolioAlerts, true);
      expect(prefs.aiInsights, true);
    });

    test('should convert to and from JSON correctly', () {
      final prefs = const NotificationPreferences(
        priceAlerts: true,
        dailyBriefing: false,
        portfolioAlerts: true,
        aiInsights: false,
      );

      final json = prefs.toJson();
      final restored = NotificationPreferences.fromJson(json);

      expect(restored.priceAlerts, prefs.priceAlerts);
      expect(restored.dailyBriefing, prefs.dailyBriefing);
      expect(restored.portfolioAlerts, prefs.portfolioAlerts);
      expect(restored.aiInsights, prefs.aiInsights);
    });

    test('should handle missing JSON fields with defaults', () {
      final json = <String, dynamic>{'priceAlerts': false};
      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.priceAlerts, false);
      expect(prefs.dailyBriefing, true); // Default
      expect(prefs.portfolioAlerts, true); // Default
      expect(prefs.aiInsights, true); // Default
    });

    test('copyWith should update only specified fields', () {
      final original = NotificationPreferences.defaults();
      
      final updated = original.copyWith(
        priceAlerts: false,
        aiInsights: false,
      );

      expect(updated.priceAlerts, false);
      expect(updated.dailyBriefing, true); // Unchanged
      expect(updated.portfolioAlerts, true); // Unchanged
      expect(updated.aiInsights, false);
    });

    test('equality should work correctly', () {
      final prefs1 = const NotificationPreferences(
        priceAlerts: true,
        dailyBriefing: false,
        portfolioAlerts: true,
        aiInsights: false,
      );

      final prefs2 = const NotificationPreferences(
        priceAlerts: true,
        dailyBriefing: false,
        portfolioAlerts: true,
        aiInsights: false,
      );

      final prefs3 = const NotificationPreferences(
        priceAlerts: false,
        dailyBriefing: false,
        portfolioAlerts: true,
        aiInsights: false,
      );

      expect(prefs1, equals(prefs2));
      expect(prefs1, isNot(equals(prefs3)));
    });
  });
}

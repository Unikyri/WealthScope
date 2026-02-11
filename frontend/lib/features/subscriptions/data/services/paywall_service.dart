import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// Service for handling RevenueCat Paywalls and Customer Center
class PaywallService {
  /// Present the RevenueCat Paywall
  /// 
  /// This shows a pre-built paywall UI configured in RevenueCat Dashboard.
  /// Returns [PaywallResult] indicating what happened (purchased, cancelled, etc.)
  Future<PaywallResult?> presentPaywall({
    String? offering,
  }) async {
    if (kIsWeb) {
      debugPrint('⚠️ Paywall not supported on web');
      return null;
    }

    try {
      final result = await RevenueCatUI.presentPaywall(
        offering: offering,
      );
      
      debugPrint('✅ Paywall result: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error presenting paywall: $e');
      return null;
    }
  }

  /// Present the RevenueCat Paywall if needed
  /// 
  /// This checks if the user needs to see the paywall before showing it.
  /// Returns [PaywallResult] indicating what happened.
  Future<PaywallResult?> presentPaywallIfNeeded({
    String? offering,
  }) async {
    if (kIsWeb) {
      debugPrint('⚠️ Paywall not supported on web');
      return null;
    }

    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded(
        offering: offering,
      );
      
      debugPrint('✅ Paywall if needed result: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Error presenting paywall if needed: $e');
      return null;
    }
  }

  /// Present the Customer Center
  /// 
  /// This shows a pre-built UI for managing subscriptions, viewing purchase history,
  /// and accessing support.
  Future<void> presentCustomerCenter() async {
    if (kIsWeb) {
      debugPrint('⚠️ Customer Center not supported on web');
      return;
    }

    try {
      await RevenueCatUI.presentCustomerCenter();
      debugPrint('✅ Customer center presented');
    } catch (e) {
      debugPrint('❌ Error presenting customer center: $e');
    }
  }

  /// Check if the paywall should be displayed
  /// 
  /// This is useful for conditionally showing the paywall based on
  /// the user's subscription status.
  Future<bool> shouldDisplayPaywall() async {
    if (kIsWeb) {
      return false;
    }

    try {
      // You can add custom logic here to determine if paywall should be shown
      // For example, check if user has active subscription
      return true;
    } catch (e) {
      debugPrint('❌ Error checking if paywall should display: $e');
      return false;
    }
  }
}

/// Provider for PaywallService
final paywallServiceProvider = Provider<PaywallService>((ref) {
  return PaywallService();
});

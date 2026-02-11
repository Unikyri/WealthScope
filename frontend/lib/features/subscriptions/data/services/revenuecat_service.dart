import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/constants/app_config.dart';

/// RevenueCat Service - Handles all subscription logic for WealthScope.
///
/// Uses the modern PurchasesConfiguration API and PurchaseParams.
/// Provides native Paywall and Customer Center via purchases_ui_flutter.
class RevenueCatService {
  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------

  /// RevenueCat API key (test mode for Daikyri's Company)
  static const String _apiKey = 'test_cvHzhXqGThHnlDkpmKyEhQXbrrj';

  /// Entitlement ID configured in RevenueCat dashboard
  static const String entitlementId = "Daikyri's Company Pro";

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initialize RevenueCat SDK with modern PurchasesConfiguration.
  ///
  /// - Sets debug logging in non-production builds.
  /// - Configures automatic in-app message display.
  /// - Optionally logs in the user if [userId] is provided.
  Future<void> initialize({String? userId}) async {
    // RevenueCat does not support web
    if (kIsWeb) {
      debugPrint('RevenueCat: web platform not supported, skipping init');
      return;
    }

    // Enable debug logging for development
    await Purchases.setLogLevel(LogLevel.debug);

    final config = PurchasesConfiguration(_apiKey)
      ..appUserID = userId
      ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat()
      ..shouldShowInAppMessagesAutomatically = true;

    await Purchases.configure(config);

    debugPrint('RevenueCat: initialized successfully');
  }

  // ---------------------------------------------------------------------------
  // Customer Info & Entitlement Checks
  // ---------------------------------------------------------------------------

  /// Get current customer info from RevenueCat (cached by default).
  Future<CustomerInfo> getCustomerInfo() async {
    if (kIsWeb) {
      throw UnsupportedError('RevenueCat not supported on web');
    }
    return await Purchases.getCustomerInfo();
  }

  /// Check if the user has the premium entitlement active.
  Future<bool> isPremium() async {
    try {
      final info = await getCustomerInfo();
      return info.entitlements.active.containsKey(entitlementId);
    } catch (e) {
      debugPrint('RevenueCat: error checking premium status: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Offerings & Purchases
  // ---------------------------------------------------------------------------

  /// Get available offerings from RevenueCat.
  Future<Offerings?> getOfferings() async {
    if (kIsWeb) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('RevenueCat: error getting offerings: $e');
      return null;
    }
  }

  /// Purchase a package using the modern PurchaseParams API.
  ///
  /// Returns [CustomerInfo] on success, `null` on cancellation.
  /// Throws on unexpected errors.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final params = PurchaseParams.package(package);
      final result = await Purchases.purchase(params);
      debugPrint('RevenueCat: purchase successful');
      return result.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('RevenueCat: user cancelled purchase');
        return null;
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        debugPrint('RevenueCat: purchase not allowed');
        return null;
      }
      debugPrint('RevenueCat: purchase error: $e');
      rethrow;
    }
  }

  /// Restore previous purchases.
  Future<CustomerInfo?> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      debugPrint('RevenueCat: purchases restored');
      return info;
    } catch (e) {
      debugPrint('RevenueCat: error restoring purchases: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // User Identity
  // ---------------------------------------------------------------------------

  /// Log in a user with their Supabase user ID.
  Future<LogInResult?> login(String userId) async {
    try {
      final result = await Purchases.logIn(userId);
      debugPrint('RevenueCat: user logged in: $userId');
      return result;
    } catch (e) {
      debugPrint('RevenueCat: error logging in: $e');
      return null;
    }
  }

  /// Log out the current user (reverts to anonymous).
  Future<CustomerInfo?> logout() async {
    try {
      final info = await Purchases.logOut();
      debugPrint('RevenueCat: user logged out');
      return info;
    } catch (e) {
      debugPrint('RevenueCat: error logging out: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Native Paywall & Customer Center (purchases_ui_flutter)
  // ---------------------------------------------------------------------------

  /// Present the native RevenueCat Paywall.
  Future<void> presentPaywall() async {
    if (kIsWeb) return;
    try {
      await RevenueCatUI.presentPaywall();
    } catch (e) {
      debugPrint('RevenueCat: error presenting paywall: $e');
    }
  }

  /// Present the native Paywall only if the user does NOT have the entitlement.
  Future<void> presentPaywallIfNeeded() async {
    if (kIsWeb) return;
    try {
      await RevenueCatUI.presentPaywallIfNeeded(entitlementId);
    } catch (e) {
      debugPrint('RevenueCat: error presenting paywall if needed: $e');
    }
  }

  /// Present the RevenueCat Customer Center for subscription management.
  Future<void> presentCustomerCenter() async {
    if (kIsWeb) return;
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      debugPrint('RevenueCat: error presenting customer center: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Subscription Management URL
  // ---------------------------------------------------------------------------

  /// Get the store-specific management URL for the user's subscription.
  Future<String?> getManagementURL() async {
    try {
      final info = await getCustomerInfo();
      return info.managementURL;
    } catch (e) {
      debugPrint('RevenueCat: error getting management URL: $e');
      return null;
    }
  }
}

// =============================================================================
// Riverpod Providers
// =============================================================================

/// Singleton service instance.
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService();
});

/// Current customer info (async, cached by RevenueCat SDK).
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  try {
    return await service.getCustomerInfo();
  } catch (e) {
    return null;
  }
});

/// Whether the current user has premium (Sentinel) access.
///
/// When [AppConfig.isTrialMode] is `true`, this always returns `true`
/// so all premium features are unlocked during development and demos.
final isPremiumProvider = FutureProvider<bool>((ref) async {
  // Trial mode bypasses RevenueCat check
  if (AppConfig.isTrialMode) return true;

  final service = ref.watch(revenueCatServiceProvider);
  return await service.isPremium();
});

/// Available offerings from RevenueCat.
final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  return await service.getOfferings();
});

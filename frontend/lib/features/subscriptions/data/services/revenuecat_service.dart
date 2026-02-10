import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// RevenueCat Service - Handles all subscription logic
class RevenueCatService {
  static const String _testStoreApiKey = 'YOUR_TEST_STORE_API_KEY';
  static const String _appleApiKey = 'YOUR_APPLE_API_KEY';
  static const String _googleApiKey = 'YOUR_GOOGLE_API_KEY';
  
  static const String premiumEntitlementId = 'premium';

  /// Initialize RevenueCat SDK
  Future<void> initialize({String? userId}) async {
    // RevenueCat doesn't fully support web, skip initialization on web
    if (kIsWeb) {
      print('⚠️ RevenueCat not supported on web platform');
      return;
    }
    
    await Purchases.setDebugLogsEnabled(true);
    
    PurchasesConfiguration configuration;
    
    if (Platform.isIOS) {
      // iOS configuration
      configuration = PurchasesConfiguration(_appleApiKey);
    } else if (Platform.isAndroid) {
      // Android configuration
      configuration = PurchasesConfiguration(_googleApiKey);
    } else {
      throw UnsupportedError('Platform not supported');
    }

    // Set user ID if provided (for PurchasesConfiguration)
    // Note: appUserID should be set directly in PurchasesConfiguration constructor
    await Purchases.configure(configuration);
    
    // If userId is provided, log in after configuration
    if (userId != null) {
      try {
        await Purchases.logIn(userId);
      } catch (e) {
        print('⚠️ Could not log in user: $e');
      }
    }
    
    print('✅ RevenueCat initialized successfully');
  }

  /// Get current customer info
  Future<CustomerInfo> getCustomerInfo() async {
    if (kIsWeb) {
      throw UnsupportedError('RevenueCat not supported on web');
    }
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      print('❌ Error getting customer info: $e');
      rethrow;
    }
  }

  /// Check if user has premium subscription
  Future<bool> isPremium() async {
    try {
      final customerInfo = await getCustomerInfo();
      final entitlement = customerInfo.entitlements.all[premiumEntitlementId];
      return entitlement?.isActive ?? false;
    } catch (e) {
      print('❌ Error checking premium status: $e');
      return false;
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    if (kIsWeb) {
      return null;
    }
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print('❌ Error getting offerings: $e');
      return null;
    }
  }

  /// Purchase a package
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      print('✅ Purchase successful');
      return purchaseResult.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        print('ℹ️ User cancelled the purchase');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        print('❌ User not allowed to purchase');
      } else {
        print('❌ Purchase error: $e');
      }
      return null;
    } catch (e) {
      print('❌ Unexpected purchase error: $e');
      return null;
    }
  }

  /// Restore purchases
  Future<CustomerInfo?> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      print('✅ Purchases restored');
      return customerInfo;
    } catch (e) {
      print('❌ Error restoring purchases: $e');
      return null;
    }
  }

  /// Login with user ID
  Future<LogInResult?> login(String userId) async {
    try {
      final result = await Purchases.logIn(userId);
      print('✅ User logged in: $userId');
      return result;
    } catch (e) {
      print('❌ Error logging in: $e');
      return null;
    }
  }

  /// Logout
  Future<CustomerInfo?> logout() async {
    try {
      final customerInfo = await Purchases.logOut();
      print('✅ User logged out');
      return customerInfo;
    } catch (e) {
      print('❌ Error logging out: $e');
      return null;
    }
  }

  /// Get management URL for subscriptions
  Future<String?> getManagementURL() async {
    try {
      final customerInfo = await getCustomerInfo();
      return customerInfo.managementURL;
    } catch (e) {
      print('❌ Error getting management URL: $e');
      return null;
    }
  }
}

/// Provider for RevenueCat service
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService();
});

/// Provider for customer info
final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  try {
    return await service.getCustomerInfo();
  } catch (e) {
    return null;
  }
});

/// Provider to check if user is premium
final isPremiumProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  return await service.isPremium();
});

/// Provider for available offerings
final offeringsProvider = FutureProvider<Offerings?>((ref) async {
  final service = ref.watch(revenueCatServiceProvider);
  return await service.getOfferings();
});

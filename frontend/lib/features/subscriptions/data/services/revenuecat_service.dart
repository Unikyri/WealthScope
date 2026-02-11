import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/constants/app_config.dart';

/// RevenueCat Service - Handles all subscription logic
class RevenueCatService {
  // API Key from environment variables (configured in .env)
  static String get _apiKey => AppConfig.revenueCatApiKey;
  
  // Entitlement ID from environment variables (configured in .env)
  static String get premiumEntitlementId => AppConfig.premiumEntitlementId;

  /// Initialize RevenueCat SDK
  Future<void> initialize({String? userId}) async {
    // RevenueCat doesn't fully support web, skip initialization on web
    if (kIsWeb) {
      debugPrint('⚠️ RevenueCat not supported on web platform');
      return;
    }
    
    // Enable debug logs for development
    await Purchases.setDebugLogsEnabled(true);
    
    try {
      // Create configuration with API key
      // For test mode, same key works for both iOS and Android
      PurchasesConfiguration configuration;
      
      if (Platform.isIOS || Platform.isAndroid) {
        // Create configuration with optional user ID
        if (userId != null) {
          configuration = PurchasesConfiguration(_apiKey)..appUserID = userId;
        } else {
          configuration = PurchasesConfiguration(_apiKey);
        }
      } else {
        throw UnsupportedError('Platform not supported');
      }

      // Configure RevenueCat
      await Purchases.configure(configuration);
      
      // If userId is provided and wasn't set in configuration, log in after
      if (userId != null) {
        try {
          await Purchases.logIn(userId);
          debugPrint('✅ User logged in: $userId');
        } catch (e) {
          debugPrint('⚠️ Could not log in user: $e');
        }
      }
      
      debugPrint('✅ RevenueCat initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing RevenueCat: $e');
      rethrow;
    }
  }

  /// Get current customer info
  Future<CustomerInfo> getCustomerInfo() async {
    if (kIsWeb) {
      throw UnsupportedError('RevenueCat not supported on web');
    }
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      debugPrint('✅ Customer info retrieved successfully');
      return customerInfo;
    } catch (e) {
      debugPrint('❌ Error getting customer info: $e');
      rethrow;
    }
  }

  /// Check if user has premium subscription (WeatherScope Pro)
  Future<bool> isPremium() async {
    try {
      final customerInfo = await getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[premiumEntitlementId];
      final isActive = entitlement?.isActive ?? false;
      debugPrint('Premium status: $isActive');
      return isActive;
    } catch (e) {
      debugPrint('❌ Error checking premium status: $e');
      return false;
    }
  }

  /// Get available offerings
  Future<Offerings?> getOfferings() async {
    if (kIsWeb) {
      return null;
    }
    try {
      final offerings = await Purchases.getOfferings();
      debugPrint('✅ Offerings retrieved: ${offerings.current?.identifier}');
      return offerings;
    } catch (e) {
      debugPrint('❌ Error getting offerings: $e');
      return null;
    }
  }

  /// Get specific products by their identifiers
  /// Product IDs: 'monthly', 'yearly', 'lifetime'
  Future<List<StoreProduct>?> getProducts(List<String> productIds) async {
    if (kIsWeb) {
      return null;
    }
    try {
      final products = await Purchases.getProducts(productIds);
      debugPrint('✅ Products retrieved: ${products.length}');
      return products;
    } catch (e) {
      debugPrint('❌ Error getting products: $e');
      return null;
    }
  }

  /// Purchase a package
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      debugPrint('✅ Purchase successful: ${package.identifier}');
      return purchaseResult.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('ℹ️ User cancelled the purchase');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        debugPrint('❌ User not allowed to purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        debugPrint('ℹ️ Product already purchased');
      } else {
        debugPrint('❌ Purchase error: $errorCode - $e');
      }
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected purchase error: $e');
      return null;
    }
  }

  /// Purchase a product directly by its StoreProduct
  Future<CustomerInfo?> purchaseProduct(StoreProduct product) async {
    try {
      final purchaseResult = await Purchases.purchaseStoreProduct(product);
      debugPrint('✅ Purchase successful: ${product.identifier}');
      return purchaseResult.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('ℹ️ User cancelled the purchase');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        debugPrint('❌ User not allowed to purchase');
      } else if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
        debugPrint('ℹ️ Product already purchased');
      } else {
        debugPrint('❌ Purchase error: $errorCode - $e');
      }
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected purchase error: $e');
      return null;
    }
  }

  /// Restore purchases
  Future<CustomerInfo?> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      debugPrint('✅ Purchases restored successfully');
      return customerInfo;
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
      return null;
    }
  }

  /// Login with user ID
  Future<LogInResult?> login(String userId) async {
    if (kIsWeb) {
      return null;
    }
    try {
      final result = await Purchases.logIn(userId);
      debugPrint('✅ User logged in: $userId');
      return result;
    } catch (e) {
      debugPrint('❌ Error logging in: $e');
      return null;
    }
  }

  /// Logout
  Future<CustomerInfo?> logout() async {
    if (kIsWeb) {
      return null;
    }
    try {
      final customerInfo = await Purchases.logOut();
      debugPrint('✅ User logged out');
      return customerInfo;
    } catch (e) {
      debugPrint('❌ Error logging out: $e');
      return null;
    }
  }

  /// Get management URL for subscriptions
  Future<String?> getManagementURL() async {
    try {
      final customerInfo = await getCustomerInfo();
      final url = customerInfo.managementURL;
      debugPrint('Management URL: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Error getting management URL: $e');
      return null;
    }
  }

  /// Check if a specific entitlement is active
  Future<bool> hasEntitlement(String entitlementId) async {
    try {
      final customerInfo = await getCustomerInfo();
      final entitlement = customerInfo.entitlements.active[entitlementId];
      return entitlement?.isActive ?? false;
    } catch (e) {
      debugPrint('❌ Error checking entitlement: $e');
      return false;
    }
  }

  /// Get all active entitlements
  Future<Map<String, EntitlementInfo>> getActiveEntitlements() async {
    try {
      final customerInfo = await getCustomerInfo();
      return customerInfo.entitlements.active;
    } catch (e) {
      debugPrint('❌ Error getting active entitlements: $e');
      return {};
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

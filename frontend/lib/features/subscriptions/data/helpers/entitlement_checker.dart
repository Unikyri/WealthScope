import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// Entitlement Checker Utility
/// 
/// Provides helper methods for checking user entitlements.
/// Entitlement ID: 'WeatherScope Pro'
class EntitlementChecker {
  static const String proEntitlement = 'WeatherScope Pro';

  /// Check if user has WeatherScope Pro
  static Future<bool> hasProAccess(WidgetRef ref) async {
    try {
      final revenueCat = ref.read(revenueCatServiceProvider);
      return await revenueCat.hasEntitlement(proEntitlement);
    } catch (e) {
      debugPrint('Error checking pro access: $e');
      return false;
    }
  }

  /// Check if user has any active subscription
  static Future<bool> hasActiveSubscription(WidgetRef ref) async {
    try {
      return await ref.read(isPremiumProvider.future);
    } catch (e) {
      debugPrint('Error checking active subscription: $e');
      return false;
    }
  }

  /// Get all active entitlements
  static Future<Map<String, dynamic>> getActiveEntitlements(WidgetRef ref) async {
    try {
      final revenueCat = ref.read(revenueCatServiceProvider);
      final entitlements = await revenueCat.getActiveEntitlements();
      
      return entitlements.map((key, value) => MapEntry(
        key,
        {
          'isActive': value.isActive,
          'identifier': value.identifier,
          'productIdentifier': value.productIdentifier,
          'expirationDate': value.expirationDate,
          'willRenew': value.willRenew,
          'periodType': value.periodType.name,
          'store': value.store.name,
        },
      ));
    } catch (e) {
      debugPrint('Error getting active entitlements: $e');
      return {};
    }
  }

  /// Check if user should see premium features
  static Future<bool> shouldShowPremiumFeatures(WidgetRef ref) async {
    return await hasActiveSubscription(ref);
  }

  /// Check if user should see paywall
  static Future<bool> shouldShowPaywall(WidgetRef ref) async {
    final hasAccess = await hasActiveSubscription(ref);
    return !hasAccess;
  }
}

/// Widget that conditionally shows content based on entitlement
class EntitlementGate extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;
  final String entitlementId;
  final bool showLoader;

  const EntitlementGate({
    super.key,
    required this.child,
    this.fallback,
    this.entitlementId = EntitlementChecker.proEntitlement,
    this.showLoader = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return child;
        }
        return fallback ?? _buildDefaultFallback(context);
      },
      loading: () => showLoader
          ? const Center(child: CircularProgressIndicator())
          : child,
      error: (error, stack) {
        debugPrint('Error checking entitlement: $error');
        return child; // Graceful fallback
      },
    );
  }

  Widget _buildDefaultFallback(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Contenido Premium',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Esta función requiere WealthScope Pro',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider extensions for easy entitlement checking
extension EntitlementRefExtension on WidgetRef {
  /// Quick method to check if user has pro access
  Future<bool> hasProAccess() async {
    return await EntitlementChecker.hasProAccess(this);
  }

  /// Quick method to check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    return await EntitlementChecker.hasActiveSubscription(this);
  }

  /// Quick method to check if paywall should be shown
  Future<bool> shouldShowPaywall() async {
    return await EntitlementChecker.shouldShowPaywall(this);
  }
}

/// Mixin for easy entitlement checking in StatefulWidgets
mixin EntitlementMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<bool> checkProAccess() async {
    return await EntitlementChecker.hasProAccess(ref);
  }

  Future<bool> checkActiveSubscription() async {
    return await EntitlementChecker.hasActiveSubscription(ref);
  }

  Future<bool> shouldShowPaywall() async {
    return await EntitlementChecker.shouldShowPaywall(ref);
  }

  /// Show paywall if user doesn't have access
  Future<bool> requireProAccess(BuildContext context) async {
    final hasAccess = await checkProAccess();
    
    if (!hasAccess) {
      // Navigate to paywall or show dialog
      // Implementation depends on your navigation setup
      return false;
    }
    
    return true;
  }
}

/// Decorator for functions that require premium access
class PremiumFeatureGuard {
  final WidgetRef ref;

  PremiumFeatureGuard(this.ref);

  /// Execute a function only if user has premium access
  /// Returns true if executed, false if blocked
  Future<bool> execute(Future<void> Function() action) async {
    final hasAccess = await EntitlementChecker.hasProAccess(ref);
    
    if (hasAccess) {
      await action();
      return true;
    }
    
    debugPrint('⚠️ Premium feature access denied');
    return false;
  }

  /// Execute with custom fallback
  Future<T> executeOrFallback<T>({
    required Future<T> Function() action,
    required T fallback,
  }) async {
    final hasAccess = await EntitlementChecker.hasProAccess(ref);
    
    if (hasAccess) {
      return await action();
    }
    
    return fallback;
  }
}

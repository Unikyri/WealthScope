import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/paywall_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// RevenueCat Paywall Screen using PaywallView
/// 
/// This displays the paywall configured in RevenueCat Dashboard.
/// It provides a seamless, pre-built UI for subscription purchases.
class PaywallScreen extends ConsumerWidget {
  final String? offering;
  final VoidCallback? onPurchaseCompleted;
  final VoidCallback? onRestoreCompleted;

  const PaywallScreen({
    super.key,
    this.offering,
    this.onPurchaseCompleted,
    this.onRestoreCompleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      body: SafeArea(
        child: PaywallView(
          offering: offering,
          onPurchaseCompleted: (customerInfo) {
            debugPrint('✅ Purchase completed in PaywallView');
            // Invalidate providers to refresh subscription status
            ref.invalidate(customerInfoProvider);
            ref.invalidate(isPremiumProvider);
            
            // Callback
            onPurchaseCompleted?.call();
            
            // Show success message
            _showSuccessMessage(context);
            
            // Navigate back or to main screen
            if (context.canPop()) {
              context.pop();
            }
          },
          onRestoreCompleted: (customerInfo) {
            debugPrint('✅ Restore completed in PaywallView');
            // Invalidate providers to refresh subscription status
            ref.invalidate(customerInfoProvider);
            ref.invalidate(isPremiumProvider);
            
            // Callback
            onRestoreCompleted?.call();
            
            // Show success message
            _showRestoreMessage(context);
          },
          onDismiss: () {
            debugPrint('ℹ️ Paywall dismissed');
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🎉 ¡Bienvenido a WealthScope Pro!'),
        backgroundColor: AppTheme.electricBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showRestoreMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Compras restauradas exitosamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Alternative: Full-screen paywall modal
/// 
/// Use this method to present the paywall as a modal overlay.
class PaywallModal {
  static Future<PaywallResult?> show(
    BuildContext context, {
    String? offering,
  }) async {
    final paywallService = PaywallService();
    return await paywallService.presentPaywall(offering: offering);
  }

  static Future<PaywallResult?> showIfNeeded(
    BuildContext context, {
    String? offering,
  }) async {
    final paywallService = PaywallService();
    return await paywallService.presentPaywallIfNeeded(offering: offering);
  }
}

/// Widget that wraps content and shows paywall when needed
class PaywallGate extends ConsumerWidget {
  final Widget child;
  final String? offering;
  final bool autoPresent;

  const PaywallGate({
    super.key,
    required this.child,
    this.offering,
    this.autoPresent = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return child;
        }

        // Auto-present paywall if configured
        if (autoPresent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _presentPaywall(context, ref);
          });
        }

        // Show locked state
        return _buildLockedState(context, ref);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => child, // Graceful fallback
    );
  }

  Widget _buildLockedState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: AppTheme.textGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'Contenido Premium',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Actualiza a Pro para acceder a esta función',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _presentPaywall(context, ref),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.electricBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ver Planes'),
          ),
        ],
      ),
    );
  }

  Future<void> _presentPaywall(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push<PaywallResult>(
      MaterialPageRoute(
        builder: (context) => PaywallScreen(
          offering: offering,
          onPurchaseCompleted: () {
            ref.invalidate(isPremiumProvider);
            ref.invalidate(customerInfoProvider);
          },
        ),
        fullscreenDialog: true,
      ),
    );

    debugPrint('Paywall result: $result');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/paywall_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// Customer Center Button Widget
/// 
/// Displays a button that opens the RevenueCat Customer Center.
/// This allows users to manage their subscriptions, view purchase history, etc.
class CustomerCenterButton extends ConsumerWidget {
  final String? label;
  final IconData? icon;
  final bool showIcon;

  const CustomerCenterButton({
    super.key,
    this.label,
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: showIcon
          ? Icon(icon ?? Icons.settings, color: Colors.white)
          : null,
      title: Text(
        label ?? 'Administrar Suscripción',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: () => _openCustomerCenter(context, ref),
    );
  }

  Future<void> _openCustomerCenter(BuildContext context, WidgetRef ref) async {
    final paywallService = ref.read(paywallServiceProvider);
    
    try {
      await paywallService.presentCustomerCenter();
      
      // Refresh customer info after closing Customer Center
      ref.invalidate(customerInfoProvider);
      ref.invalidate(isPremiumProvider);
    } catch (e) {
      debugPrint('Error opening customer center: $e');
      
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el centro de usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Simple elevated button version of Customer Center
class CustomerCenterElevatedButton extends ConsumerWidget {
  final String? label;
  final VoidCallback? onPressed;

  const CustomerCenterElevatedButton({
    super.key,
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => _openCustomerCenter(context, ref),
      icon: const Icon(Icons.settings),
      label: Text(label ?? 'Administrar Suscripción'),
    );
  }

  Future<void> _openCustomerCenter(BuildContext context, WidgetRef ref) async {
    final paywallService = ref.read(paywallServiceProvider);
    
    try {
      await paywallService.presentCustomerCenter();
      
      // Refresh customer info after closing Customer Center
      ref.invalidate(customerInfoProvider);
      ref.invalidate(isPremiumProvider);
      
      onPressed?.call();
    } catch (e) {
      debugPrint('Error opening customer center: $e');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el centro de usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Helper class to open Customer Center programmatically
class CustomerCenterHelper {
  /// Open the Customer Center
  static Future<void> open(BuildContext context, WidgetRef ref) async {
    final paywallService = ref.read(paywallServiceProvider);
    
    try {
      await paywallService.presentCustomerCenter();
      
      // Refresh customer info after closing Customer Center
      ref.invalidate(customerInfoProvider);
      ref.invalidate(isPremiumProvider);
    } catch (e) {
      debugPrint('Error opening customer center: $e');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el centro de usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Check if user should see Customer Center
  /// (typically for premium users only)
  static Future<bool> shouldShow(WidgetRef ref) async {
    try {
      final isPremium = await ref.read(isPremiumProvider.future);
      return isPremium;
    } catch (e) {
      return false;
    }
  }
}

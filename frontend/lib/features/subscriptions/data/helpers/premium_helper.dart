import 'package:flutter/material.dart';
import '../presentation/screens/premium_paywall_screen.dart';

/// Premium Feature Helper - Navegar al Paywall
/// 
/// Facilita mostrar el paywall desde cualquier parte de la app
class PremiumHelper {
  /// Muestra el paywall de premium como modal
  static Future<bool?> showPaywall(BuildContext context) async {
    return await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const PremiumPaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  /// Muestra el paywall como bottom sheet (alternativa)
  static Future<bool?> showPaywallBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PremiumPaywallScreen(),
    );
  }
}

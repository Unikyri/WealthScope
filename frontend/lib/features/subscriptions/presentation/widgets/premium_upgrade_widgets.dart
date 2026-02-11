import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../subscriptions/data/helpers/premium_helper.dart';
import '../../../subscriptions/data/services/revenuecat_service.dart';

/// Widget de ejemplo para agregar botón "Upgrade to Premium" en el dashboard
/// 
/// Este widget verifica si el usuario es premium y muestra un botón si no lo es
class PremiumUpgradeButton extends ConsumerWidget {
  final bool compact;
  
  const PremiumUpgradeButton({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener estado de premium
    final revenueCatService = ref.watch(revenueCatServiceProvider);
    
    return FutureBuilder<bool>(
      future: revenueCatService.isPremium(),
      builder: (context, snapshot) {
        // Si está cargando, mostrar placeholder
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        
        // Si ya es premium, no mostrar el botón
        final isPremium = snapshot.data ?? false;
        if (isPremium) {
          return const SizedBox.shrink();
        }
        
        // No es premium, mostrar botón de upgrade
        return _buildUpgradeButton(context);
      },
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    if (compact) {
      return IconButton(
        onPressed: () => _showPaywall(context),
        icon: const Icon(Icons.workspace_premium),
        tooltip: 'Upgrade to Premium',
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF00D9FF).withOpacity(0.1),
          foregroundColor: const Color(0xFF00D9FF),
        ),
      );
    }
    
    return ElevatedButton.icon(
      onPressed: () => _showPaywall(context),
      icon: const Icon(Icons.workspace_premium),
      label: const Text('Upgrade to Premium'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D9FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _showPaywall(BuildContext context) async {
    final result = await PremiumHelper.showPaywall(context);
    
    if (result == true) {
      // Usuario completó la compra
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido a WealthScope Premium! 🎉'),
            backgroundColor: Color(0xFF00D9FF),
          ),
        );
      }
    }
  }
}

/// Banner de upgrade más llamativo para dashboard
class PremiumUpgradeBanner extends ConsumerWidget {
  const PremiumUpgradeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueCatService = ref.watch(revenueCatServiceProvider);
    
    return FutureBuilder<bool>(
      future: revenueCatService.isPremium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        
        final isPremium = snapshot.data ?? false;
        if (isPremium) {
          return const SizedBox.shrink();
        }
        
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00D9FF).withOpacity(0.2),
                const Color(0xFF0099FF).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00D9FF).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showPaywall(context),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D9FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Color(0xFF00D9FF),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upgrade to Premium',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Unlock unlimited tracking, AI insights & more',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF00D9FF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPaywall(BuildContext context) async {
    await PremiumHelper.showPaywall(context);
  }
}

/// Badge "Premium" para mostrar junto al nombre de usuario o en perfil
class PremiumBadge extends ConsumerWidget {
  final double size;
  
  const PremiumBadge({
    super.key,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueCatService = ref.watch(revenueCatServiceProvider);
    
    return FutureBuilder<bool>(
      future: revenueCatService.isPremium(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        
        final isPremium = snapshot.data ?? false;
        if (!isPremium) {
          return const SizedBox.shrink();
        }
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.4,
            vertical: size * 0.2,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00D9FF), Color(0xFF0099FF)],
            ),
            borderRadius: BorderRadius.circular(size * 0.4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                size: size * 0.8,
                color: Colors.white,
              ),
              SizedBox(width: size * 0.2),
              Text(
                'PRO',
                style: TextStyle(
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================
// REVENUECAT QUICK START EXAMPLES
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/paywall_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/helpers/entitlement_checker.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/paywall_widgets.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/customer_center_widgets.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/premium_widgets.dart';

// ============================================
// EXAMPLE 1: Check Premium Status
// ============================================

class PremiumStatusExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return Text('✨ User is Premium!');
        } else {
          return Text('🔓 User is Free');
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Text('Error checking status'),
    );
  }
}

// ============================================
// EXAMPLE 2: Show Paywall Button
// ============================================

class ShowPaywallButtonExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Method 1: Navigate to PaywallScreen
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaywallScreen(
              onPurchaseCompleted: () {
                print('Purchase successful!');
              },
            ),
            fullscreenDialog: true,
          ),
        );

        // Method 2: Show as modal
        // final result = await PaywallModal.show(context);
        
        // Method 3: Direct service call
        // final paywallService = ref.read(paywallServiceProvider);
        // await paywallService.presentPaywall();
      },
      child: Text('Ver Planes Premium'),
    );
  }
}

// ============================================
// EXAMPLE 3: Premium Feature Gate
// ============================================

class PremiumFeatureGateExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaywallGate(
      autoPresent: false,
      child: Column(
        children: [
          Text('🎨 Advanced AI Features'),
          Text('✨ Unlimited Queries'),
          Text('📊 Advanced Analytics'),
        ],
      ),
    );
  }
}

// ============================================
// EXAMPLE 4: Check Entitlement
// ============================================

class EntitlementCheckExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: EntitlementChecker.hasProAccess(ref),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return PremiumContent();
        }
        return FreeContent();
      },
    );
  }
}

// ============================================
// EXAMPLE 5: Customer Center Button
// ============================================

class CustomerCenterButtonExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return CustomerCenterButton(
            label: 'Administrar Suscripción',
            icon: Icons.settings,
          );
        }
        return SizedBox.shrink();
      },
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
    );
  }
}

// ============================================
// EXAMPLE 6: Restore Purchases
// ============================================

class RestorePurchasesExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        final revenueCat = ref.read(revenueCatServiceProvider);
        
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        final customerInfo = await revenueCat.restorePurchases();
        
        // Close loading
        Navigator.of(context).pop();

        if (customerInfo != null) {
          // Refresh providers
          ref.invalidate(isPremiumProvider);
          ref.invalidate(customerInfoProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Compras restauradas exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ No se encontraron compras'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: Text('Restaurar Compras'),
    );
  }
}

// ============================================
// EXAMPLE 7: Premium Badge in AppBar
// ============================================

class AppBarWithPremiumBadgeExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text('WealthScope'),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: PremiumBadge(),
        ),
      ],
    );
  }
}

// ============================================
// EXAMPLE 8: Limit Free User Actions
// ============================================

class LimitedActionsExample extends ConsumerStatefulWidget {
  @override
  ConsumerState<LimitedActionsExample> createState() => _LimitedActionsExampleState();
}

class _LimitedActionsExampleState extends ConsumerState<LimitedActionsExample> with EntitlementMixin {
  int _freeQueriesUsed = 0;
  static const int _maxFreeQueries = 5;

  Future<void> _performAction() async {
    final isPremium = await checkProAccess();

    if (!isPremium) {
      if (_freeQueriesUsed >= _maxFreeQueries) {
        // Show paywall
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaywallScreen(),
            fullscreenDialog: true,
          ),
        );
        return;
      }

      setState(() {
        _freeQueriesUsed++;
      });
    }

    // Perform the action
    print('Action performed!');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_freeQueriesUsed > 0)
          Text(
            'Consultas restantes: ${_maxFreeQueries - _freeQueriesUsed}/$_maxFreeQueries',
          ),
        ElevatedButton(
          onPressed: _performAction,
          child: Text('Consultar AI'),
        ),
      ],
    );
  }
}

// ============================================
// EXAMPLE 9: Get Customer Info
// ============================================

class CustomerInfoExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerInfoAsync = ref.watch(customerInfoProvider);

    return customerInfoAsync.when(
      data: (customerInfo) {
        if (customerInfo == null) {
          return Text('No customer info available');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${customerInfo.originalAppUserId}'),
            Text('Active Entitlements: ${customerInfo.entitlements.active.keys.join(", ")}'),
            if (customerInfo.managementURL != null)
              Text('Management URL: ${customerInfo.managementURL}'),
          ],
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}

// ============================================
// EXAMPLE 10: Get Available Offerings
// ============================================

class OfferingsExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offeringsAsync = ref.watch(offeringsProvider);

    return offeringsAsync.when(
      data: (offerings) {
        if (offerings?.current == null) {
          return Text('No offerings available');
        }

        final packages = offerings!.current!.availablePackages;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return ListTile(
              title: Text(package.storeProduct.title),
              subtitle: Text(package.storeProduct.description),
              trailing: Text(package.storeProduct.priceString),
              onTap: () async {
                final revenueCat = ref.read(revenueCatServiceProvider);
                await revenueCat.purchasePackage(package);
              },
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => Text('Error loading offerings'),
    );
  }
}

// ============================================
// EXAMPLE 11: Purchase Specific Product
// ============================================

class PurchaseProductExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final revenueCat = ref.read(revenueCatServiceProvider);

        // Get products
        final products = await revenueCat.getProducts([
          'monthly',
          'yearly',
          'lifetime',
        ]);

        if (products != null && products.isNotEmpty) {
          // Purchase first product (monthly)
          final customerInfo = await revenueCat.purchaseProduct(products[0]);

          if (customerInfo != null) {
            // Refresh providers
            ref.invalidate(isPremiumProvider);
            ref.invalidate(customerInfoProvider);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Purchase successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      },
      child: Text('Purchase Monthly'),
    );
  }
}

// ============================================
// EXAMPLE 12: Login/Logout User
// ============================================

class LoginLogoutExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final revenueCat = ref.read(revenueCatServiceProvider);
            await revenueCat.login('user_123');
            
            // Refresh providers
            ref.invalidate(isPremiumProvider);
            ref.invalidate(customerInfoProvider);
          },
          child: Text('Login User'),
        ),
        ElevatedButton(
          onPressed: () async {
            final revenueCat = ref.read(revenueCatServiceProvider);
            await revenueCat.logout();
            
            // Refresh providers
            ref.invalidate(isPremiumProvider);
            ref.invalidate(customerInfoProvider);
          },
          child: Text('Logout User'),
        ),
      ],
    );
  }
}

// ============================================
// EXAMPLE 13: Entitlement Gate Widget
// ============================================

class EntitlementGateWidgetExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EntitlementGate(
      entitlementId: 'WeatherScope Pro',
      showLoader: true,
      child: Column(
        children: [
          Text('🎉 Premium Content!'),
          Text('You have access to all features'),
        ],
      ),
      fallback: Column(
        children: [
          Text('🔒 Locked Content'),
          ElevatedButton(
            onPressed: () async {
              await PaywallModal.show(context);
            },
            child: Text('Unlock Premium'),
          ),
        ],
      ),
    );
  }
}

// ============================================
// EXAMPLE 14: Premium Feature Guard
// ============================================

class PremiumFeatureGuardExample extends ConsumerWidget {
  Future<void> _executePremiumAction(WidgetRef ref) async {
    final guard = PremiumFeatureGuard(ref);

    final success = await guard.execute(() async {
      // This only runs if user has premium
      print('Performing premium action...');
      await Future.delayed(Duration(seconds: 1));
      print('Premium action completed!');
    });

    if (!success) {
      print('User needs premium access');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _executePremiumAction(ref),
      child: Text('Execute Premium Action'),
    );
  }
}

// ============================================
// EXAMPLE 15: Settings Screen Integration
// ============================================

class SettingsScreenExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: ListView(
        children: [
          // Premium Badge Section
          isPremiumAsync.when(
            data: (isPremium) {
              if (isPremium) {
                return Container(
                  color: Colors.blue.withOpacity(0.2),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Estado: Premium Activo'),
                    ],
                  ),
                );
              } else {
                return ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Obtener Premium'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PaywallScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                );
              }
            },
            loading: () => SizedBox.shrink(),
            error: (_, __) => SizedBox.shrink(),
          ),

          Divider(),

          // Customer Center
          CustomerCenterButton(
            label: 'Administrar Suscripción',
            icon: Icons.card_membership,
          ),

          // Restore Purchases
          ListTile(
            leading: Icon(Icons.restore),
            title: Text('Restaurar Compras'),
            onTap: () async {
              final revenueCat = ref.read(revenueCatServiceProvider);
              await revenueCat.restorePurchases();
              ref.invalidate(isPremiumProvider);
            },
          ),

          Divider(),

          // Other settings...
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
          ),
        ],
      ),
    );
  }
}

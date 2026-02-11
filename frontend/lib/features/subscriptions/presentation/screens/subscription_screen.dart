import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Subscription/Paywall Screen
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isLoading = false;
  String? _selectedPackageId;

  @override
  Widget build(BuildContext context) {
    final offeringsAsync = ref.watch(offeringsProvider);
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      body: SafeArea(
        child: isPremiumAsync.when(
          data: (isPremium) {
            if (isPremium) {
              return _buildPremiumActiveView();
            }
            return _buildPaywallView(offeringsAsync);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _buildPaywallView(offeringsAsync),
        ),
      ),
    );
  }

  /// View when user already has premium
  Widget _buildPremiumActiveView() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(isPremium: true),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.electricBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIconsFill.crownSimple,
                    size: 80,
                    color: AppTheme.electricBlue,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '¡Eres Premium!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Disfruta de todas las funciones premium de WealthScope',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildPremiumFeaturesList(),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _manageSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cardGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Administrar Suscripción'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Paywall view for non-premium users
  Widget _buildPaywallView(AsyncValue<Offerings?> offeringsAsync) {
    return offeringsAsync.when(
      data: (offerings) {
        if (offerings == null || offerings.current == null) {
          return _buildNoOfferingsView();
        }

        final packages = offerings.current!.availablePackages;
        
        return CustomScrollView(
          slivers: [
            _buildAppBar(isPremium: false),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(),
                    const SizedBox(height: 32),
                    
                    // Features List
                    _buildPremiumFeaturesList(),
                    const SizedBox(height: 32),
                    
                    // Packages
                    Text(
                      'Elige tu plan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...packages.map((package) => _buildPackageCard(package)),
                    
                    const SizedBox(height: 24),
                    
                    // Purchase Button
                    if (_selectedPackageId != null)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handlePurchase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.electricBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Restore Button
                    TextButton(
                      onPressed: _restorePurchases,
                      child: Text(
                        'Restaurar Compras',
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Terms
                    Text(
                      'Al suscribirte, aceptas nuestros Términos y Condiciones',
                      style: TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => SliverFillRemaining(
        child: Center(
          child: Text(
            'Error al cargar planes: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar({required bool isPremium}) {
    return SliverAppBar(
      backgroundColor: AppTheme.midnightBlue,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(PhosphorIconsRegular.x, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        isPremium ? 'Premium' : 'Obtén Premium',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.electricBlue.withOpacity(0.3),
            AppTheme.electricBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.electricBlue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIconsFill.crownSimple,
            size: 64,
            color: AppTheme.electricBlue,
          ),
          const SizedBox(height: 16),
          Text(
            'WealthScope Premium',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Desbloquea todo el potencial de tu portafolio',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeaturesList() {
    final features = [
      {
        'icon': PhosphorIconsRegular.sparkle,
        'title': 'Análisis AI Ilimitado',
        'description': 'Consultas sin límite con nuestro asesor financiero IA',
      },
      {
        'icon': PhosphorIconsRegular.chartLineUp,
        'title': 'Simulaciones What-If Avanzadas',
        'description': 'Simula escenarios complejos y en cadena',
      },
      {
        'icon': PhosphorIconsRegular.bell,
        'title': 'Alertas Personalizadas',
        'description': 'Recibe notificaciones sobre cambios importantes',
      },
      {
        'icon': PhosphorIconsRegular.newspaper,
        'title': 'Noticias Premium',
        'description': 'Acceso a análisis y noticias exclusivas',
      },
      {
        'icon': PhosphorIconsRegular.cloudArrowUp,
        'title': 'Sincronización en la Nube',
        'description': 'Accede a tu portafolio desde cualquier dispositivo',
      },
      {
        'icon': PhosphorIconsRegular.shieldCheck,
        'title': 'Soporte Prioritario',
        'description': 'Atención preferencial y respuesta rápida',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: AppTheme.electricBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPackageCard(Package package) {
    final isSelected = _selectedPackageId == package.identifier;
    final product = package.storeProduct;
    final isAnnual = package.identifier.toLowerCase().contains('annual') ||
        package.identifier.toLowerCase().contains('year');
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPackageId = package.identifier),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.electricBlue
                    : Colors.white.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.electricBlue
                          : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.electricBlue : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Package info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title.replaceAll(RegExp(r'\s*\(.*?\)'), ''),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isAnnual) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.emeraldAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Ahorra 83%',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.emeraldAccent,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.priceString,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.electricBlue,
                      ),
                    ),
                    if (isAnnual)
                      Text(
                        '~\$0.83/mes',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // "Mejor Valor" badge para plan anual
          if (isAnnual)
            Positioned(
              top: 0,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.electricBlue,
                      AppTheme.electricBlue.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.electricBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIconsFill.star,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'MEJOR VALOR',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoOfferingsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.cardGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                PhosphorIconsRegular.package,
                size: 64,
                color: AppTheme.electricBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Configura tus planes',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No hay planes de suscripción disponibles aún.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.electricBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.electricBlue.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        PhosphorIconsRegular.lightbulb,
                        color: AppTheme.electricBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Próximos pasos:',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.electricBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSetupStep('1', 'Ve a RevenueCat Dashboard'),
                  const SizedBox(height: 8),
                  _buildSetupStep('2', 'Crea productos en Test Store'),
                  const SizedBox(height: 8),
                  _buildSetupStep('3', 'Configura el entitlement "premium"'),
                  const SizedBox(height: 8),
                  _buildSetupStep('4', 'Crea el offering "default"'),
                  const SizedBox(height: 16),
                  Text(
                    '📖 Ver guía: REVENUECAT_TEST_STORE_SETUP.md',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Try native RevenueCat Paywall
            ElevatedButton.icon(
              onPressed: () async {
                await ref
                    .read(revenueCatServiceProvider)
                    .presentPaywall();
              },
              icon: const Icon(Icons.storefront),
              label: const Text('Open Paywall'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackageId == null) return;

    setState(() => _isLoading = true);

    try {
      final offerings = await ref.read(revenueCatServiceProvider).getOfferings();
      final package = offerings?.current?.availablePackages
          .firstWhere((p) => p.identifier == _selectedPackageId);

      if (package == null) {
        throw Exception('Package not found');
      }

      final customerInfo = await ref
          .read(revenueCatServiceProvider)
          .purchasePackage(package);

      if (customerInfo != null && mounted) {
        // Refresh providers
        ref.invalidate(isPremiumProvider);
        ref.invalidate(customerInfoProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Suscripción activada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoading = true);

    try {
      final customerInfo =
          await ref.read(revenueCatServiceProvider).restorePurchases();

      if (customerInfo != null && mounted) {
        ref.invalidate(isPremiumProvider);
        ref.invalidate(customerInfoProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compras restauradas exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al restaurar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSetupStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.electricBlue.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.electricBlue,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.electricBlue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Open RevenueCat Customer Center for subscription management.
  Future<void> _manageSubscription() async {
    await ref.read(revenueCatServiceProvider).presentCustomerCenter();
  }
}

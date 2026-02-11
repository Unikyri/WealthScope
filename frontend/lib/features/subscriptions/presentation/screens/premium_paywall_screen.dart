import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Premium Paywall Screen - Modern Design for WealthScope
///
/// Diseño premium con:
/// - Fondo oscuro (#0A0E17) minimalista
/// - Header compacto con badge PREMIUM
/// - Lista de beneficios simplificada con iconos cyan
/// - Cards de planes con diseño moderno
/// - Botón de acción destacado con gradiente
/// - Footer con enlaces discretos
class PremiumPaywallScreen extends ConsumerStatefulWidget {
  const PremiumPaywallScreen({super.key});

  @override
  ConsumerState<PremiumPaywallScreen> createState() =>
      _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends ConsumerState<PremiumPaywallScreen> {
  Offering? _currentOffering;
  Package? _selectedPackage;
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    // Solo cargar RevenueCat en plataformas soportadas
    if (_isRevenueCatSupported()) {
      _loadOfferings();
    } else {
      setState(() => _isLoading = false);
    }
  }

  bool _isRevenueCatSupported() {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid ||
          Platform.isIOS ||
          Platform.isMacOS ||
          Platform.isWindows;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadOfferings() async {
    try {
      setState(() => _isLoading = true);

      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;

      if (offering != null && offering.availablePackages.isNotEmpty) {
        setState(() {
          _currentOffering = offering;
          // Seleccionar el paquete anual por defecto
          _selectedPackage =
              offering.annual ?? offering.availablePackages.first;
        });
      }
    } catch (e) {
      debugPrint('Error loading offerings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _purchasePackage() async {
    if (_selectedPackage == null || _isPurchasing) return;

    setState(() => _isPurchasing = true);

    try {
      final customerInfo = await Purchases.purchasePackage(_selectedPackage!);

      if (customerInfo.entitlements.active.containsKey('premium')) {
        if (mounted) {
          // Cerrar paywall con éxito
          Navigator.of(context).pop(true);

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '¡Bienvenido a WealthScope Premium! 🎉',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF00D9FF),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isPurchasing = true);

    try {
      final customerInfo = await Purchases.restorePurchases();

      if (customerInfo.entitlements.active.containsKey('premium')) {
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Compra restaurada exitosamente!'),
              backgroundColor: Color(0xFF00D9FF),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se encontraron compras anteriores'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al restaurar: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar mensaje si no está soportado
    if (!_isRevenueCatSupported()) {
      return _buildUnsupportedPlatform(context);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00E5FF),
                ),
              )
            : Stack(
                children: [
                  // Contenido principal con scroll
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // Botón cerrar (top right)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Header / Hero Section
                        _buildHeroSection(),
                        const SizedBox(height: 30),

                        // Benefits List
                        _buildBenefitsList(),
                        const SizedBox(height: 40),

                        // Plans Section
                        _buildPlansSection(),
                        const SizedBox(height: 40),

                        // Action Button
                        _buildActionButton(),
                        const SizedBox(height: 25),

                        // Footer Links
                        _buildFooterLinks(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Loading overlay
                  if (_isPurchasing)
                    Container(
                      color: Colors.black87,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF00E5FF),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Procesando compra...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  // === UI BUILDING METHODS ===

  Widget _buildUnsupportedPlatform(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.web_outlined,
                  size: 80,
                  color: Color(0xFF00E5FF),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Premium no disponible en Web',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Para acceder a WealthScope Premium, descarga nuestra app para móvil o escritorio.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: const Color(0xFF0A0E17),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Entendido',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Badge PREMIUM
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF00E5FF), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'WEALTHSCOPE PREMIUM',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Título principal
          const Text(
            'Toma el control total de tus inversiones',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Subtítulo
          Text(
            'Análisis profesional, alertas inteligentes y sincronización ilimitada',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList() {
    final benefits = [
      {
        'icon': Icons.smart_toy_outlined,
        'text': 'Asesor IA ilimitado para tu cartera'
      },
      {
        'icon': Icons.sync_outlined,
        'text': 'Sincronización con Binance, XTB y más'
      },
      {
        'icon': Icons.shield_outlined,
        'text': 'Análisis de riesgo y diversificación'
      },
      {
        'icon': Icons.notifications_outlined,
        'text': 'Alertas de precios y vencimientos'
      },
      {
        'icon': Icons.insights_outlined,
        'text': 'Informes personalizados exportables'
      },
      {
        'icon': Icons.trending_up_outlined,
        'text': 'Actualización en tiempo real 24/7'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: benefits.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 24,
                  color: const Color(0xFF00E5FF),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['text'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlansSection() {
    if (_currentOffering == null ||
        _currentOffering!.availablePackages.isEmpty) {
      return _buildMockPlans();
    }

    final packages = _currentOffering!.availablePackages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: packages.map((package) {
          final isSelected = _selectedPackage?.identifier == package.identifier;
          final isAnnual = package.packageType == PackageType.annual;

          return _buildPlanCard(
            isSelected: isSelected,
            isAnnual: isAnnual,
            title: isAnnual ? 'Plan Anual' : 'Plan Mensual',
            subtitle: isAnnual
                ? 'Menos de €0.85 al mes'
                : 'Acceso total, sin compromiso',
            price: isAnnual ? '€10.00/año' : '€1.00/mes',
            savings: isAnnual ? 'Ahorra 17%' : null,
            onTap: () {
              setState(() {
                _selectedPackage = package;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMockPlans() {
    // Planes de demostración cuando RevenueCat no está disponible
    final isMonthlySelected = _selectedPackage == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildPlanCard(
            isSelected: isMonthlySelected,
            isAnnual: false,
            title: 'Plan Mensual',
            subtitle: 'Acceso total, sin compromiso',
            price: '\$1.00/mes',
            savings: null,
            onTap: () {
              setState(() {
                _selectedPackage = null; // Mock monthly
              });
            },
          ),
          _buildPlanCard(
            isSelected: !isMonthlySelected,
            isAnnual: true,
            title: 'Plan Anual',
            subtitle: 'Menos de \$0.85 al mes',
            price: '\$10.00/año',
            savings: 'Ahorra 17%',
            onTap: () {
              setState(() {
                _selectedPackage = _currentOffering?.annual; // Mock annual
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required bool isSelected,
    required bool isAnnual,
    required String title,
    required String subtitle,
    required String price,
    String? savings,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF00E5FF) : const Color(0xFF1F2937),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (savings != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        savings,
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Badge "MEJOR VALOR" para plan anual seleccionado
            if (isAnnual && isSelected)
              Positioned(
                top: -12,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'MEJOR VALOR',
                    style: TextStyle(
                      color: Color(0xFF0A0E17),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00E5FF), Color(0xFF00B4DB)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isPurchasing ? null : _purchasePackage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Comenzar Prueba Gratuita',
              style: TextStyle(
                color: Color(0xFF0A0E17),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterLink('Restaurar', _restorePurchases),
        const SizedBox(width: 20),
        _buildFooterLink('Términos', () {
          // TODO: Implementar
        }),
        const SizedBox(width: 20),
        _buildFooterLink('Privacidad', () {
          // TODO: Implementar
        }),
      ],
    );
  }

  Widget _buildFooterLink(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isPurchasing ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

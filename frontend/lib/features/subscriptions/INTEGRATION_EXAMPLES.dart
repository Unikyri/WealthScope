// EJEMPLO: Cómo integrar Premium Checks en pantallas existentes

// ============================================
// EJEMPLO 1: Limitar número de consultas AI
// ============================================

// En ai_chat_screen.dart o similar:
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/premium_widgets.dart';

class AIChatScreenExample extends ConsumerStatefulWidget {
  @override
  ConsumerState<AIChatScreenExample> createState() => _AIChatScreenExampleState();
}

class _AIChatScreenExampleState extends ConsumerState<AIChatScreenExample> {
  int _freeQueriesCount = 0;
  static const int _maxFreeQueries = 5;

  @override
  Widget build(BuildContext context) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        // Si es premium, permitir uso ilimitado
        if (isPremium) {
          return _buildChatInterface();
        }

        // Si no es premium y alcanzó el límite, mostrar lock
        if (_freeQueriesCount >= _maxFreeQueries) {
          return Center(
            child: PremiumFeatureLock(
              featureName: 'Consultas Ilimitadas',
              description: 'Has usado tus $maxFreeQueries consultas gratuitas. Obtén Premium para consultas ilimitadas.',
            ),
          );
        }

        // Mostrar interfaz con contador
        return Column(
          children: [
            _buildFreeQueriesWarning(),
            Expanded(child: _buildChatInterface()),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => _buildChatInterface(), // En caso de error, permitir uso
    );
  }

  Widget _buildFreeQueriesWarning() {
    final remaining = _maxFreeQueries - _freeQueriesCount;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        border: Border(
          bottom: BorderSide(color: Colors.orange.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Consultas restantes: $remaining/$_maxFreeQueries',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/subscription'),
            child: Text('Obtener Premium'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String message) async {
    final isPremium = await ref.read(isPremiumProvider.future);
    
    if (!isPremium) {
      if (_freeQueriesCount >= _maxFreeQueries) {
        _showPremiumDialog();
        return;
      }
      setState(() => _freeQueriesCount++);
    }

    // Enviar mensaje...
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Límite Alcanzado'),
        content: Text('Has usado todas tus consultas gratuitas. Obtén Premium para consultas ilimitadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/subscription');
            },
            child: Text('Obtener Premium'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInterface() {
    return Container(); // Tu interfaz de chat
  }
}

// ============================================
// EJEMPLO 2: Bloquear función completa
// ============================================

// En what_if_screen.dart:
class WhatIfAdvancedFeature extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (!isPremium) {
          return PremiumFeatureLock(
            featureName: 'Simulaciones en Cadena',
            description: 'Las simulaciones avanzadas en cadena son una función premium.',
          );
        }

        return _buildAdvancedSimulator();
      },
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => _buildAdvancedSimulator(),
    );
  }

  Widget _buildAdvancedSimulator() {
    return Container(); // Tu simulador avanzado
  }
}

// ============================================
// EJEMPLO 3: Mostrar badge en feature específica
// ============================================

// En cualquier pantalla que quieras marcar como premium:
class FeatureScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature Premium'),
        actions: [
          const PremiumBadge(), // Mostrar badge
        ],
      ),
      body: ...,
    );
  }
}

// ============================================
// EJEMPLO 4: Limitar exportaciones/compartir
// ============================================

class ExportFeature extends ConsumerWidget {
  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final isPremium = await ref.read(isPremiumProvider.future);

    if (!isPremium) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Función Premium'),
          content: Text('La exportación de datos es una función premium.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/subscription');
              },
              child: Text('Obtener Premium'),
            ),
          ],
        ),
      );
      return;
    }

    // Continuar con exportación...
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _exportData(context, ref),
      child: Text('Exportar Datos'),
    );
  }
}

// ============================================
// EJEMPLO 5: Premium badge en lista de assets
// ============================================

// En assets_list_screen.dart:
Widget _buildPremiumFeatureTile() {
  return ListTile(
    leading: Icon(PhosphorIconsRegular.cloudArrowUp),
    title: Text('Sincronización en la Nube'),
    subtitle: Text('Accede a tus activos desde cualquier dispositivo'),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.electricBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.lock_outline, size: 20),
      ],
    ),
    onTap: () => context.push('/subscription'),
  );
}

// ============================================
// EJEMPLO 6: Helper functions útiles
// ============================================

// Crear un archivo: lib/core/utils/premium_helpers.dart
class PremiumHelpers {
  /// Verifica si el usuario es premium y muestra dialog si no lo es
  static Future<bool> requirePremium(
    BuildContext context,
    WidgetRef ref,
    String featureName,
  ) async {
    final isPremium = await ref.read(isPremiumProvider.future);

    if (!isPremium) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Función Premium'),
          content: Text('$featureName requiere una suscripción Premium.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/subscription');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
              ),
              child: Text('Ver Planes'),
            ),
          ],
        ),
      );
    }

    return isPremium;
  }

  /// Muestra un bottom sheet con info de premium
  static void showPremiumSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsFill.crownSimple,
              size: 48,
              color: AppTheme.electricBlue,
            ),
            SizedBox(height: 16),
            Text(
              'Desbloquea Premium',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Obtén acceso completo a todas las funciones',
              style: TextStyle(color: AppTheme.textGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/subscription');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Ver Planes Premium'),
            ),
          ],
        ),
      ),
    );
  }
}

// Uso:
Future<void> onPremiumFeatureTapped() async {
  final canProceed = await PremiumHelpers.requirePremium(
    context,
    ref,
    'Análisis AI Avanzado',
  );

  if (canProceed) {
    // Ejecutar función premium
  }
}

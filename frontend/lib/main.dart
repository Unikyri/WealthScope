import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/constants/app_config.dart';
import 'features/subscriptions/data/services/revenuecat_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with error handling
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  } catch (e) {
    // Log error but continue app execution
    // The splash screen will handle the absence of valid credentials
    debugPrint('⚠️ Supabase initialization failed: $e');
    debugPrint('App will continue with limited functionality');
  }

  runApp(
    ProviderScope(
      child: _AppInitializer(),
    ),
  );
}

class _AppInitializer extends ConsumerStatefulWidget {
  const _AppInitializer();

  @override
  ConsumerState<_AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends ConsumerState<_AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeRevenueCat();
  }

  Future<void> _initializeRevenueCat() async {
    try {
      final revenueCatService = ref.read(revenueCatServiceProvider);
      await revenueCatService.initialize();
    } catch (e) {
      debugPrint('⚠️ RevenueCat initialization failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const WealthScopeApp();
  }
}

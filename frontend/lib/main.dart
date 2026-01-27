import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'core/constants/app_config.dart';

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
    const ProviderScope(
      child: WealthScopeApp(),
    ),
  );
}

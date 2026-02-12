/// Application Configuration
/// Central configuration for environment-specific values
class AppConfig {
  AppConfig._();

  // ---------------------------------------------------------------------------
  // Trial Mode
  // ---------------------------------------------------------------------------

  /// Trial mode: when active the user has full Sentinel (premium) access.
  ///
  /// **IMPORTANT**: Set to `false` for release/production builds.
  /// In debug, use the "Entrar a Trial" button on the subscription screen instead.
  /// In production, trials are controlled via RevenueCat trial periods.
  static const bool isTrialMode = false;

  /// Whether the app is running in a debug (assert-enabled) build.
  static bool get isDebug {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }

  // ---------------------------------------------------------------------------
  // Backend
  // ---------------------------------------------------------------------------

  /// Backend API Base URL
  /// Railway deployment URL for production backend
  /// For local testing: 'http://localhost:8080'
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://wealthscope-production.up.railway.app',
  );

  // ---------------------------------------------------------------------------
  // Supabase
  // ---------------------------------------------------------------------------

  /// Supabase Configuration
  /// Project URL from Supabase Dashboard
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jdgnyhxoagatsdlnbrjo.supabase.co',
  );

  /// Supabase Anon Key (safe for frontend use)
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpkZ255aHhvYWdhdHNkbG5icmpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0ODEwMTAsImV4cCI6MjA4NTA1NzAxMH0.dQO322CEN2J8L_BuFrCr4BybpU2ErHryECJMeTFJlvA',
  );

  // ---------------------------------------------------------------------------
  // Environment
  // ---------------------------------------------------------------------------

  /// Environment
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Check if running in production
  static bool get isProduction => environment == 'production';

  /// Check if running in development
  static bool get isDevelopment => environment == 'development';
}

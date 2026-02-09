import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';
import 'package:wealthscope_app/features/onboarding/presentation/providers/onboarding_provider.dart';

/// Splash Screen with automatic session verification
///
/// This screen is displayed when the app starts. It checks if there's
/// a valid authentication session and redirects accordingly:
/// - To /dashboard if valid session exists
/// - To /login if no session or session expired
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _errorMessage;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Checks authentication status and redirects accordingly
  Future<void> _checkAuthStatus() async {
    try {
      // Minimum splash duration for better UX
      await Future.delayed(const Duration(seconds: 1));

      // Check if mounted before navigation
      if (!mounted) return;

      // Check if Supabase is initialized
      if (!Supabase.instance.isInitialized) {
        throw Exception('Supabase not initialized. Check your configuration.');
      }

      // Check if onboarding has been completed
      final onboardingState = await ref.read(onboardingProvider.future);
      if (!onboardingState) {
        // First time user - show onboarding
        if (!mounted) return;
        context.go('/onboarding-cinematic');
        return;
      }

      final authService = ref.read(authServiceProvider);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        // Verify that the token hasn't expired
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null && !session.isExpired) {
          if (!mounted) return;
          context.go('/dashboard');
          return;
        }
      }

      // No valid session, redirect to login
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      // Handle any errors during session check
      debugPrint('Error checking auth status: $e');
      
      if (!mounted) return;
      
      // Show error state
      setState(() {
        _hasError = true;
        _errorMessage = _getErrorMessage(e);
      });
      
      // Wait a bit and redirect to login anyway
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      context.go('/login');
    }
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('not initialized') || 
        errorStr.contains('supabase')) {
      return 'Configuration Error\nCheck Supabase credentials';
    } else if (errorStr.contains('network') || 
               errorStr.contains('connection')) {
      return 'Network Error\nCheck your internet connection';
    } else {
      return 'Unexpected Error\nRedirecting to login...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              _hasError ? Icons.error_outline : Icons.account_balance_wallet,
              size: 80,
              color: _hasError ? colorScheme.error : colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'WealthScope',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator or error message
            if (_hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage ?? 'Connection Error',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Redirecting to login...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

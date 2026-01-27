import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/login_screen.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/register_screen.dart';
import 'package:wealthscope_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:wealthscope_app/features/splash/presentation/screens/splash_screen.dart';

/// Application Router Configuration
/// Define all app routes here using GoRouter.
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // TODO: Add dashboard route
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const _InitialScreen(),
      ),
    ],
  );
}

/// Temporary initial screen
class _InitialScreen extends StatelessWidget {
  const _InitialScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('WealthScope - Initial Screen'),
      ),
    );
  }
}

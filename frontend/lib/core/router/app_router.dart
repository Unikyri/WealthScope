import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

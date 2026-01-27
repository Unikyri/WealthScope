import 'package:go_router/go_router.dart';

/// Application Router Configuration
/// Define all app routes here using GoRouter.
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Routes will be added here as features are implemented
      // Example:
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => const DashboardScreen(),
      // ),
    ],
  );
}

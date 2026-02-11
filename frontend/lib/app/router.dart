import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/router/app_router.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';

/// Router Provider
/// Provides the GoRouter instance with auth guard
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authState,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;
      
      // Define auth routes (public routes)
      final isAuthRoute = location == '/login' || 
                          location == '/register' ||
                          location == '/splash' ||
                          location == '/onboarding';
      
      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }
      
      // If authenticated and trying to access login/register
      if (isAuthenticated && (location == '/login' || location == '/register')) {
        return '/dashboard';
      }
      
      // No redirect needed
      return null;
    },
    routes: AppRouter.routes,
  );
});

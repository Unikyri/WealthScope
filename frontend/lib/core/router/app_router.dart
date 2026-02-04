import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/add_asset_screen.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/asset_detail_screen.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/asset_edit_screen.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/assets_list_screen.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/select_asset_type_screen.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/stock_form_screen.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/login_screen.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/register_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/ai_chat_screen.dart';
import 'package:wealthscope_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:wealthscope_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:wealthscope_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:wealthscope_app/shared/widgets/main_shell.dart';

/// Application Router Configuration
/// Define all app routes here using GoRouter.
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: routes,
  );

  /// List of all application routes
  /// Used by the routerProvider with auth guard
  static final List<RouteBase> routes = [
      // Auth routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Protected routes with shell
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/assets',
            name: 'assets',
            builder: (context, state) => const AssetsListScreen(),
            routes: [
              GoRoute(
                path: 'select-type',
                name: 'assets-select-type',
                builder: (context, state) => const SelectAssetTypeScreen(),
              ),
              GoRoute(
                path: 'add',
                name: 'assets-add',
                builder: (context, state) {
                  // Get asset type from query parameter
                  final typeStr = state.uri.queryParameters['type'];
                  final assetType = typeStr != null 
                      ? AssetType.fromString(typeStr) 
                      : null;
                  return AddAssetScreen(assetType: assetType);
                },
              ),
              GoRoute(
                path: 'add-stock',
                name: 'assets-add-stock',
                builder: (context, state) {
                  final typeStr = state.uri.queryParameters['type'] ?? 'stock';
                  final type = AssetType.fromString(typeStr);
                  return StockFormScreen(type: type);
                },
              ),
              GoRoute(
                path: ':id',
                name: 'assets-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return AssetDetailScreen(assetId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'assets-edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AssetEditScreen(assetId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/ai-chat',
            name: 'ai-chat',
            builder: (context, state) => const AIChatScreen(),
          ),
        ],
      ),
    ];
}

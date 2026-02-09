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
import 'package:wealthscope_app/features/ai/presentation/screens/ai_advisor_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/ai_chat_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/briefing_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/document_upload_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/what_if_screen.dart';
import 'package:wealthscope_app/features/conversations/presentation/screens/conversation_chat_screen.dart';
import 'package:wealthscope_app/features/conversations/presentation/screens/conversations_list_screen.dart';
import 'package:wealthscope_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:wealthscope_app/features/news/presentation/screens/article_webview_screen.dart';
import 'package:wealthscope_app/features/news/presentation/screens/news_screen.dart';
import 'package:wealthscope_app/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:wealthscope_app/features/onboarding/presentation/screens/onboarding_cinematic.dart';
import 'package:wealthscope_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:wealthscope_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:wealthscope_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:wealthscope_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:wealthscope_app/shared/widgets/main_shell.dart';
import 'package:wealthscope_app/features/ai_command/presentation/screens/ai_command_center_screen.dart';

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
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding-cinematic',
        name: 'onboarding-cinematic',
        builder: (context, state) => const OnboardingCinematic(),
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
            path: '/ai-advisor',
            name: 'ai-advisor',
            builder: (context, state) => const AIAdvisorScreen(),
          ),
          GoRoute(
            path: '/ai-briefing',
            name: 'ai-briefing',
            builder: (context, state) => const BriefingScreen(),
          ),
          GoRoute(
            path: '/ai-chat',
            name: 'ai-chat',
            builder: (context, state) => const AIChatScreen(),
            routes: [
              GoRoute(
                path: ':conversationId',
                name: 'ai-chat-conversation',
                builder: (context, state) {
                  final conversationId = state.pathParameters['conversationId']!;
                  return ConversationChatScreen(conversationId: conversationId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/conversations',
            name: 'conversations',
            builder: (context, state) => const ConversationsListScreen(),
          ),
          GoRoute(
            path: '/document-upload',
            name: 'document-upload',
            builder: (context, state) => const DocumentUploadScreen(),
          ),
          GoRoute(
            path: '/what-if',
            name: 'what-if',
            builder: (context, state) => const WhatIfScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/news',
            name: 'news',
            builder: (context, state) => const NewsScreen(),
            routes: [
              GoRoute(
                path: 'article',
                name: 'article-webview',
                builder: (context, state) {
                  final url = state.uri.queryParameters['url'] ?? '';
                  final title = state.uri.queryParameters['title'] ?? 'Article';
                  return ArticleWebViewScreen(
                    url: url,
                    title: title,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/ai-command',
            name: 'ai-command',
            builder: (context, state) => const AiCommandCenterScreen(),
          ),
        ],
      ),
    ];
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';

/// MainShell wraps the main navigation structure of the app
/// with a bottom navigation bar for protected routes
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _MainBottomNavigationBar(),
    );
  }
}

class _MainBottomNavigationBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final unreadCountAsync = ref.watch(unreadNotificationsCountProvider);
    final unreadCount = unreadCountAsync.valueOrNull ?? 0;
    
    // Format badge label: show "9+" for 10 or more
    final badgeLabel = unreadCount > 9 ? '9+' : '$unreadCount';
    
    // Determine selected index based on current route
    int selectedIndex = 0;
    if (location.startsWith('/dashboard')) {
      selectedIndex = 0;
    } else if (location.startsWith('/assets')) {
      selectedIndex = 1;
    } else if (location.startsWith('/ai-advisor') || 
               location.startsWith('/ai-chat') || 
               location.startsWith('/what-if')) {
      selectedIndex = 2;
    } else if (location.startsWith('/profile')) {
      selectedIndex = 3;
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/assets');
            break;
          case 2:
            context.go('/ai-advisor');
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: Badge(
            label: Text(badgeLabel),
            isLabelVisible: unreadCount > 0,
            child: const Icon(Icons.dashboard_outlined),
          ),
          selectedIcon: Badge(
            label: Text(badgeLabel),
            isLabelVisible: unreadCount > 0,
            child: const Icon(Icons.dashboard),
          ),
          label: 'Dashboard',
        ),
        const NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Assets',
        ),
        const NavigationDestination(
          icon: Icon(Icons.psychology_outlined),
          selectedIcon: Icon(Icons.psychology),
          label: 'AI Advisor',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

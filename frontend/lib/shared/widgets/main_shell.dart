import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/shared/widgets/constellation_background.dart';

import 'package:wealthscope_app/shared/widgets/custom_bottom_nav_bar.dart';
import 'package:wealthscope_app/shared/widgets/speed_dial_fab.dart';

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
    return Stack(
      children: [
        // Background Layer
        const ConstellationBackground(
          particleCount: 80,
          interactive: true,
        ),

        // Main Content Layer
        Scaffold(
          backgroundColor:
              Colors.transparent, // Allow background to show through
          extendBody: true, // Body extends behind nav so FAB overlaps naturally
          body: child,
          floatingActionButton: const SpeedDialFab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _MainBottomNavigationBar(),
        ),
      ],
    );
  }
}

// Custom Bottom Navigation Bar implementation
class _MainBottomNavigationBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

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

    return CustomBottomNavBar(
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
    );
  }
}

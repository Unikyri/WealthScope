import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/auth/presentation/providers/logout_provider.dart';

/// A button widget that handles user logout
/// 
/// Usage:
/// ```dart
/// LogoutButton(
///   onLogoutSuccess: () {
///     // Optional callback after successful logout
///   },
/// )
/// ```
class LogoutButton extends ConsumerWidget {
  const LogoutButton({
    super.key,
    this.onLogoutSuccess,
  });

  final VoidCallback? onLogoutSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);

    return logoutState.when(
      data: (_) => ElevatedButton.icon(
        onPressed: () => _handleLogout(context, ref),
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
      ),
      loading: () => ElevatedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        label: const Text('Logging out...'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
      ),
      error: (error, stack) => ElevatedButton.icon(
        onPressed: () => _handleLogout(context, ref),
        icon: const Icon(Icons.error_outline),
        label: const Text('Retry Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    // Perform logout
    await ref.read(logoutProvider.notifier).signOut();

    // Check if logout was successful
    final state = ref.read(logoutProvider);
    if (!context.mounted) return;

    state.when(
      data: (_) {
        // Logout successful - navigate to login screen
        onLogoutSuccess?.call();
        context.go('/login');
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
          ),
        );
      },
      loading: () {}, // Still loading
      error: (error, stack) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _handleLogout(context, ref),
            ),
          ),
        );
      },
    );
  }
}

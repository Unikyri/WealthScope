import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/auth/presentation/providers/logout_provider.dart';
import 'package:wealthscope_app/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:wealthscope_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:wealthscope_app/features/profile/presentation/widgets/logout_confirmation_dialog.dart';

/// Profile Screen
/// Displays user profile information and settings
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('No active session'),
            );
          }

          return ListView(
            children: [
              const SizedBox(height: 24),
              // Avatar Section
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              // Name
              if (profile.fullName != null)
                Center(
                  child: Text(
                    profile.fullName!,
                    style: textTheme.headlineSmall,
                  ),
                ),
              const SizedBox(height: 8),
              // Email
              Center(
                child: Text(
                  profile.email,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              // Profile Options
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/settings');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.notifications_outlined,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/notifications');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.article_outlined,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Financial News'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/news');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.security_outlined,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Security'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.help_outline,
                  color: colorScheme.onSurface,
                ),
                title: const Text('Help'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              const Divider(),
              // Debug Options (Development only)
              ListTile(
                leading: Icon(
                  Icons.replay,
                  color: colorScheme.secondary,
                ),
                title: Text(
                  'Reset Onboarding',
                  style: TextStyle(color: colorScheme.secondary),
                ),
                subtitle: const Text('View onboarding again'),
                onTap: () => _resetOnboarding(context, ref),
              ),
              const Divider(),
              // Logout Button
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: colorScheme.error,
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () => _showLogoutConfirmation(context, ref),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading profile',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: () async {
          await _handleLogout(context, ref);
        },
      ),
    );
  }

  Future<void> _resetOnboarding(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Onboarding'),
        content: const Text('This will reset the onboarding state and navigate you to the onboarding screen. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(onboardingProvider.notifier).resetOnboarding();
      if (context.mounted) {
        context.go('/onboarding');
      }
    }
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    if (context.mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Perform logout
    await ref.read(logoutProvider.notifier).signOut();

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Navigate to login
    if (context.mounted) {
      context.go('/login');
    }
  }
}

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
              
              // General Section
              _buildSectionHeader(context, 'General'),
              _buildSettingsTile(
                context: context,
                icon: Icons.tune_rounded,
                title: 'Preferences',
                subtitle: 'Currency, theme',
                onTap: () {
                  context.push('/settings');
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle: 'Data preferences, security',
                onTap: () {
                  // TODO: Navigate to privacy settings
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.help_outline_rounded,
                title: 'Support',
                subtitle: 'Troubleshooting, help',
                onTap: () {
                  // TODO: Navigate to support
                },
              ),
              
              const SizedBox(height: 24),
              
              // Account Section
              _buildSectionHeader(context, 'Account'),
              _buildSettingsTile(
                context: context,
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your alerts and insights',
                onTap: () {
                  context.push('/notifications');
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.article_outlined,
                title: 'Financial News',
                subtitle: 'Stay updated with market trends',
                onTap: () {
                  context.push('/news');
                },
              ),
              
              const SizedBox(height: 24),
              
              // About Section
              _buildSectionHeader(context, 'About'),
              _buildSettingsTile(
                context: context,
                icon: Icons.info_outline_rounded,
                title: 'About WealthScope',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.description_outlined,
                title: 'Terms & Privacy',
                subtitle: 'Legal information',
                onTap: () {
                  // TODO: Navigate to terms
                },
              ),
              
              const SizedBox(height: 24),
              
              // Debug Options (Development only)
              _buildSectionHeader(context, 'Development'),
              _buildSettingsTile(
                context: context,
                icon: Icons.replay_rounded,
                title: 'Reset Onboarding',
                subtitle: 'View onboarding again',
                iconColor: colorScheme.secondary,
                onTap: () => _resetOnboarding(context, ref),
              ),
              
              const SizedBox(height: 24),
              
              // Logout Button
              _buildSettingsTile(
                context: context,
                icon: Icons.logout_rounded,
                title: 'Sign Out',
                subtitle: 'Logout from your account',
                iconColor: colorScheme.error,
                titleColor: colorScheme.error,
                showTrailing: false,
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

  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build settings tile with icon, title, subtitle
  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showTrailing = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon with background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Trailing arrow
              if (showTrailing)
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

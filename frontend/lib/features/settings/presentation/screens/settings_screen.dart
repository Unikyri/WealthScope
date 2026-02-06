import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/auth/presentation/providers/logout_provider.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';
import 'package:wealthscope_app/core/theme/theme_provider.dart';
import 'package:wealthscope_app/shared/widgets/theme_selection_dialog.dart';
import 'package:wealthscope_app/core/currency/currency_provider.dart';
import 'package:wealthscope_app/shared/widgets/currency_selector_dialog.dart';
import 'package:wealthscope_app/features/notifications/presentation/providers/notification_preferences_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final userEmail = authState.userEmail;
    final currentTheme = ref.watch(themeModeProvider);
    final currentCurrencyAsync = ref.watch(selectedCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, 'Account'),
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: userEmail ?? 'Not logged in',
            onTap: () {
              context.push('/profile');
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // TODO: Navigate to change password screen
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.email_outlined,
            title: 'Email Preferences',
            onTap: () {
              // TODO: Navigate to email preferences screen
            },
          ),
          const Divider(height: 32),

          // Notifications Section
          _buildSectionHeader(context, 'Notifications'),
          _buildNotificationToggles(context, ref),
          const Divider(height: 32),

          // Privacy & Security Section
          _buildSectionHeader(context, 'Privacy & Security'),
          _buildSettingsTile(
            context,
            icon: Icons.fingerprint,
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            trailing: Switch(
              value: false, // TODO: Connect to actual state
              onChanged: (value) {
                // TODO: Handle biometric toggle
              },
            ),
            onTap: null,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.security,
            title: 'Two-Factor Authentication',
            subtitle: 'Add extra security layer',
            onTap: () {
              // TODO: Navigate to 2FA setup
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          const Divider(height: 32),

          // App Settings Section
          _buildSectionHeader(context, 'App Settings'),
          _buildSettingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: currentTheme.displayName,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ThemeSelectionDialog(),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              // TODO: Navigate to language settings
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.attach_money,
            title: 'Currency',
            subtitle: currentCurrencyAsync.when(
              data: (currency) => '${currency.flag} ${currency.code}',
              loading: () => 'Loading...',
              error: (_, __) => 'USD',
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const CurrencySelectorDialog(),
              );
            },
          ),
          const Divider(height: 32),

          // Data & Storage Section
          _buildSectionHeader(context, 'Data & Storage'),
          _buildSettingsTile(
            context,
            icon: Icons.cloud_download_outlined,
            title: 'Export Data',
            subtitle: 'Download your portfolio data',
            onTap: () {
              // TODO: Implement data export
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {
              _showClearCacheDialog(context);
            },
          ),
          const Divider(height: 32),

          // About Section
          _buildSectionHeader(context, 'About'),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'About WealthScope',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () {
              // TODO: Open terms of service
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Navigate to help center
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.rate_review_outlined,
            title: 'Rate WealthScope',
            onTap: () {
              // TODO: Open app store rating
            },
          ),
          const Divider(height: 32),

          // Danger Zone
          _buildSectionHeader(context, 'Account Actions'),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            titleColor: theme.colorScheme.error,
            onTap: () {
              _showSignOutDialog(context, ref);
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.delete_forever,
            title: 'Delete Account',
            titleColor: theme.colorScheme.error,
            onTap: () {
              _showDeleteAccountDialog(context);
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: titleColor ?? theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                )
              : null),
      onTap: onTap,
    );
  }

  Widget _buildNotificationToggles(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationPrefsAsync = ref.watch(notificationPreferencesNotifierProvider);

    return notificationPrefsAsync.when(
      data: (prefs) => Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              Icons.trending_up,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Price Alerts'),
            subtitle: const Text(
              'Get notified when asset prices hit your targets',
              style: TextStyle(fontSize: 12),
            ),
            value: prefs.priceAlerts,
            onChanged: (value) {
              ref
                  .read(notificationPreferencesNotifierProvider.notifier)
                  .togglePriceAlerts(value);
            },
          ),
          SwitchListTile(
            secondary: Icon(
              Icons.today_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Daily Briefing'),
            subtitle: const Text(
              'Receive daily portfolio summaries and market updates',
              style: TextStyle(fontSize: 12),
            ),
            value: prefs.dailyBriefing,
            onChanged: (value) {
              ref
                  .read(notificationPreferencesNotifierProvider.notifier)
                  .toggleDailyBriefing(value);
            },
          ),
          SwitchListTile(
            secondary: Icon(
              Icons.account_balance_wallet_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Portfolio Alerts'),
            subtitle: const Text(
              'Important updates about your portfolio performance',
              style: TextStyle(fontSize: 12),
            ),
            value: prefs.portfolioAlerts,
            onChanged: (value) {
              ref
                  .read(notificationPreferencesNotifierProvider.notifier)
                  .togglePortfolioAlerts(value);
            },
          ),
          SwitchListTile(
            secondary: Icon(
              Icons.psychology_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text('AI Insights'),
            subtitle: const Text(
              'Personalized financial insights powered by AI',
              style: TextStyle(fontSize: 12),
            ),
            value: prefs.aiInsights,
            onChanged: (value) {
              ref
                  .read(notificationPreferencesNotifierProvider.notifier)
                  .toggleAiInsights(value);
            },
          ),
        ],
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error loading notification preferences',
          style: TextStyle(color: theme.colorScheme.error),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WealthScope',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.account_balance_wallet, size: 48),
      children: [
        const SizedBox(height: 16),
        const Text(
          'WealthScope helps you track and manage your financial portfolio with AI-powered insights.',
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(logoutProvider.future);
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

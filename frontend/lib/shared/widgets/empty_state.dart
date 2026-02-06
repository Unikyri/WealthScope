import 'package:flutter/material.dart';

/// Empty State Type
/// Defines different types of empty states with appropriate icons and messages
enum EmptyStateType {
  portfolio,
  assets,
  notifications,
  searchResults,
  news,
  generic,
}

/// Empty State Widget
/// A polished, reusable widget for displaying empty states across the app.
/// Provides consistent styling with relevant icons, messages, and action buttons.
class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? customIcon;

  const EmptyState({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.customIcon,
  });

  /// Empty Portfolio - No assets yet
  const EmptyState.portfolio({
    super.key,
    required VoidCallback onAddAsset,
  })  : type = EmptyStateType.portfolio,
        title = null,
        message = null,
        actionLabel = null,
        onAction = onAddAsset,
        customIcon = null;

  /// Empty Assets List
  const EmptyState.assets({
    super.key,
    required VoidCallback onAddAsset,
  })  : type = EmptyStateType.assets,
        title = null,
        message = null,
        actionLabel = null,
        onAction = onAddAsset,
        customIcon = null;

  /// Empty Notifications - All caught up
  const EmptyState.notifications({
    super.key,
  })  : type = EmptyStateType.notifications,
        title = null,
        message = null,
        actionLabel = null,
        onAction = null,
        customIcon = null;

  /// No Search Results
  const EmptyState.searchResults({
    super.key,
    String? searchTerm,
  })  : type = EmptyStateType.searchResults,
        title = null,
        message = searchTerm != null ? 'No results found for "$searchTerm"' : null,
        actionLabel = null,
        onAction = null,
        customIcon = null;

  /// Empty News List
  const EmptyState.news({
    super.key,
  })  : type = EmptyStateType.news,
        title = null,
        message = null,
        actionLabel = null,
        onAction = null,
        customIcon = null;

  /// Generic Empty State
  const EmptyState.generic({
    super.key,
    required String title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  })  : type = EmptyStateType.generic,
        title = title,
        message = message,
        actionLabel = actionLabel,
        onAction = onAction,
        customIcon = icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getConfiguration(theme);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon/Illustration
            Icon(
              config.icon,
              size: 100,
              color: config.iconColor,
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              config.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message/Description
            Text(
              config.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (config.showAction && onAction != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onAction,
                icon: Icon(config.actionIcon),
                label: Text(config.actionLabel),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get configuration for the empty state type
  _EmptyStateConfig _getConfiguration(ThemeData theme) {
    switch (type) {
      case EmptyStateType.portfolio:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.account_balance_wallet_outlined,
          iconColor: theme.colorScheme.primary.withOpacity(0.3),
          title: title ?? 'Start Building Your Portfolio',
          message: message ??
              'Track all your investments in one place.\nAdd your first asset to get started.',
          showAction: true,
          actionIcon: Icons.add,
          actionLabel: actionLabel ?? 'Add First Asset',
        );

      case EmptyStateType.assets:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.inventory_2_outlined,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.2),
          title: title ?? 'No Assets Yet',
          message: message ??
              'Start by adding your first investment to see your portfolio here.',
          showAction: true,
          actionIcon: Icons.add,
          actionLabel: actionLabel ?? 'Add Asset',
        );

      case EmptyStateType.notifications:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.notifications_none_outlined,
          iconColor: theme.colorScheme.primary.withOpacity(0.3),
          title: title ?? 'All Caught Up!',
          message: message ??
              'You have no new notifications.\nWe\'ll notify you when something important happens.',
          showAction: false,
          actionIcon: Icons.check,
          actionLabel: '',
        );

      case EmptyStateType.searchResults:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.search_off,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.3),
          title: title ?? 'No Results Found',
          message: message ?? 'Try adjusting your search or filters to find what you\'re looking for.',
          showAction: false,
          actionIcon: Icons.clear,
          actionLabel: '',
        );

      case EmptyStateType.news:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.article_outlined,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.3),
          title: title ?? 'No News Available',
          message: message ?? 'Try adjusting your filters or check back later for updates.',
          showAction: false,
          actionIcon: Icons.refresh,
          actionLabel: '',
        );

      case EmptyStateType.generic:
        return _EmptyStateConfig(
          icon: customIcon ?? Icons.inbox_outlined,
          iconColor: theme.colorScheme.onSurface.withOpacity(0.3),
          title: title ?? 'Nothing Here',
          message: message ?? 'There\'s nothing to display at the moment.',
          showAction: actionLabel != null && onAction != null,
          actionIcon: Icons.add,
          actionLabel: actionLabel ?? '',
        );
    }
  }
}

/// Empty State Configuration
/// Internal class to hold configuration for different empty state types
class _EmptyStateConfig {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final bool showAction;
  final IconData actionIcon;
  final String actionLabel;

  const _EmptyStateConfig({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.showAction,
    required this.actionIcon,
    required this.actionLabel,
  });
}

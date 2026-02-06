import 'package:flutter/material.dart';

/// Error State Type
/// Defines different types of error states with appropriate icons and messages
enum ErrorStateType {
  network,
  server,
  notFound,
  unauthorized,
  generic,
}

/// Error State Widget
/// A polished, reusable widget for displaying error states across the app.
/// Provides consistent styling with relevant icons, messages, and retry actions.
class ErrorState extends StatelessWidget {
  final ErrorStateType type;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final IconData? customIcon;

  const ErrorState({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actionLabel,
    this.onRetry,
    this.customIcon,
  });

  /// Network Error - Check connection
  const ErrorState.network({
    super.key,
    VoidCallback? onRetry,
  })  : type = ErrorStateType.network,
        title = null,
        message = null,
        actionLabel = null,
        onRetry = onRetry,
        customIcon = null;

  /// Server Error - Try again later
  const ErrorState.server({
    super.key,
    String? errorDetails,
    VoidCallback? onRetry,
  })  : type = ErrorStateType.server,
        title = null,
        message = errorDetails,
        actionLabel = null,
        onRetry = onRetry,
        customIcon = null;

  /// Not Found Error
  const ErrorState.notFound({
    super.key,
    String? resourceName,
  })  : type = ErrorStateType.notFound,
        title = null,
        message = resourceName != null ? '$resourceName not found' : null,
        actionLabel = null,
        onRetry = null,
        customIcon = null;

  /// Unauthorized Error
  const ErrorState.unauthorized({
    super.key,
    VoidCallback? onRetry,
  })  : type = ErrorStateType.unauthorized,
        title = null,
        message = null,
        actionLabel = null,
        onRetry = onRetry,
        customIcon = null;

  /// Generic Error
  const ErrorState.generic({
    super.key,
    required String message,
    String? title,
    VoidCallback? onRetry,
    IconData? icon,
  })  : type = ErrorStateType.generic,
        title = title,
        message = message,
        actionLabel = null,
        onRetry = onRetry,
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
            // Error Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: config.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                size: 64,
                color: config.iconColor,
              ),
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              config.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Error Message
            Text(
              config.message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),

            // Retry Button
            if (config.showRetry && onRetry != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
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

            // Secondary Action (if available)
            if (config.secondaryAction != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: config.secondaryAction,
                child: const Text('Go Back'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get configuration for the error state type
  _ErrorStateConfig _getConfiguration(ThemeData theme) {
    switch (type) {
      case ErrorStateType.network:
        return _ErrorStateConfig(
          icon: customIcon ?? Icons.wifi_off_rounded,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
          title: title ?? 'No Internet Connection',
          message: message ??
              'Please check your connection and try again.\nMake sure you\'re connected to the internet.',
          showRetry: true,
          actionIcon: Icons.refresh,
          actionLabel: actionLabel ?? 'Retry',
          secondaryAction: null,
        );

      case ErrorStateType.server:
        return _ErrorStateConfig(
          icon: customIcon ?? Icons.cloud_off_rounded,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
          title: title ?? 'Server Error',
          message: message ??
              'Something went wrong on our end.\nPlease try again later.',
          showRetry: true,
          actionIcon: Icons.refresh,
          actionLabel: actionLabel ?? 'Try Again',
          secondaryAction: null,
        );

      case ErrorStateType.notFound:
        return _ErrorStateConfig(
          icon: customIcon ?? Icons.search_off,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
          title: title ?? 'Not Found',
          message: message ?? 'The item you\'re looking for doesn\'t exist or has been removed.',
          showRetry: false,
          actionIcon: Icons.arrow_back,
          actionLabel: '',
          secondaryAction: null,
        );

      case ErrorStateType.unauthorized:
        return _ErrorStateConfig(
          icon: customIcon ?? Icons.lock_outline,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
          title: title ?? 'Access Denied',
          message: message ??
              'You don\'t have permission to view this content.\nPlease sign in to continue.',
          showRetry: true,
          actionIcon: Icons.login,
          actionLabel: actionLabel ?? 'Sign In',
          secondaryAction: null,
        );

      case ErrorStateType.generic:
        return _ErrorStateConfig(
          icon: customIcon ?? Icons.error_outline,
          iconColor: theme.colorScheme.error,
          iconBackgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
          title: title ?? 'Something Went Wrong',
          message: message ?? 'An unexpected error occurred.\nPlease try again.',
          showRetry: onRetry != null,
          actionIcon: Icons.refresh,
          actionLabel: actionLabel ?? 'Retry',
          secondaryAction: null,
        );
    }
  }
}

/// Error State Configuration
/// Internal class to hold configuration for different error state types
class _ErrorStateConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String message;
  final bool showRetry;
  final IconData actionIcon;
  final String actionLabel;
  final VoidCallback? secondaryAction;

  const _ErrorStateConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.message,
    required this.showRetry,
    required this.actionIcon,
    required this.actionLabel,
    this.secondaryAction,
  });
}

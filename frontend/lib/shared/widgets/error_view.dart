import 'package:flutter/material.dart';
import 'package:wealthscope_app/shared/widgets/error_state.dart';

/// Custom Error Widget
/// Displays error messages in a consistent way across the app
/// Now uses the unified ErrorState widget for consistency
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    required this.message,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorState.generic(
      message: message,
      onRetry: onRetry,
    );
  }
}

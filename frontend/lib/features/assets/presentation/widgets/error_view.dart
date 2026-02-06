import 'package:flutter/material.dart';
import 'package:wealthscope_app/shared/widgets/error_state.dart';

/// Error View Widget
/// Displays an error message with a retry button
/// Now uses the unified ErrorState widget for consistency
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorState.generic(
      message: message,
      onRetry: onRetry,
    );
  }
}

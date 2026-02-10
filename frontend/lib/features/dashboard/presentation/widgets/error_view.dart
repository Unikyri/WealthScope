import 'package:flutter/material.dart';
import 'package:wealthscope_app/shared/widgets/error_state.dart';

/// Error View Widget
/// Displays error message with retry button
/// Now uses the unified ErrorState widget for consistency
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorState.generic(
      message: message,
      onRetry: onRetry,
    );
  }
}

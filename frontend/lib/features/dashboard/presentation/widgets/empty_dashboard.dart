import 'package:flutter/material.dart';
import 'package:wealthscope_app/shared/widgets/empty_state.dart';

/// Empty Dashboard State Widget
/// Displayed when user has no assets
/// Now uses the unified EmptyState widget for consistency
class EmptyDashboard extends StatelessWidget {
  final VoidCallback onAddAsset;

  const EmptyDashboard({
    super.key,
    required this.onAddAsset,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState.portfolio(
      onAddAsset: onAddAsset,
    );
  }
}

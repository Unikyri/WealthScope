import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/shared/widgets/empty_state.dart';

/// Empty Assets View
/// Displayed when the user has no assets in their portfolio
/// Now uses the unified EmptyState widget for consistency
class EmptyAssetsView extends StatelessWidget {
  const EmptyAssetsView({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState.assets(
      onAddAsset: () => context.push('/assets/select-type'),
    );
  }
}

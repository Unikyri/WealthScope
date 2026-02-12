import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_type_card.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/upgrade_prompt_dialog.dart';

/// Asset Type Selection Screen
/// Step 1 of the Add Asset flow. Users select the type of asset they want to add.
class SelectAssetTypeScreen extends ConsumerWidget {
  const SelectAssetTypeScreen({super.key});

  Future<void> _onAssetTypeSelected(
    BuildContext context,
    WidgetRef ref,
    AssetType type,
  ) async {
    final gate = ref.read(featureGateProvider);

    // Check asset count limit only (all asset types available for free)
    final assets = await ref.read(allAssetsProvider.future);
    final result = gate.canAddAsset(assets.length);
    if (!result.allowed) {
      if (!context.mounted) return;
      showGatePrompt(context, result);
      return;
    }

    if (!context.mounted) return;

    // Navigate to specific form based on asset type
    if (type == AssetType.stock || type == AssetType.etf) {
      context.push('/assets/add-stock?type=${type.toApiString()}');
    } else {
      context.push('/assets/add?type=${type.toApiString()}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.midnightBlue,
        elevation: 0,
        title: const Text(
          'Add Asset',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Step 1 of 2',
                  style: TextStyle(
                    color: AppTheme.electricBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'What type of asset\ndo you want to add?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select the category that best matches your investment.',
                style: TextStyle(
                  color: AppTheme.textGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Asset type list
              Expanded(
                child: ListView.separated(
                  itemCount: AssetType.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final assetType = AssetType.values[index];
                    return SizedBox(
                      height: 88,
                      child: AssetTypeSelectorCard(
                        type: assetType,
                        isPremiumType: false,
                        isLocked: false,
                        onTap: () =>
                            _onAssetTypeSelected(context, ref, assetType),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

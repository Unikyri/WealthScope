import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// Premium Badge Widget - Shows premium status and opens subscription screen
class PremiumBadge extends ConsumerWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return _buildPremiumBadge(context);
        }
        return _buildUpgradeBadge(context);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPremiumBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.electricBlue,
              AppTheme.electricBlue.withOpacity(0.8),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricBlue.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          PhosphorIconsFill.crownSimple,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildUpgradeBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.electricBlue.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Icon(
          PhosphorIconsRegular.crown,
          color: AppTheme.electricBlue,
          size: 20,
        ),
      ),
    );
  }
}

/// Premium Feature Lock - Shows when feature requires premium
class PremiumFeatureLock extends ConsumerWidget {
  final String featureName;
  final String description;

  const PremiumFeatureLock({
    super.key,
    required this.featureName,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.electricBlue.withOpacity(0.2),
            AppTheme.electricBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.electricBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIconsFill.lock,
            size: 48,
            color: AppTheme.electricBlue,
          ),
          const SizedBox(height: 16),
          Text(
            featureName,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/subscription'),
            icon: Icon(PhosphorIconsRegular.crownSimple),
            label: const Text('Obtener Premium'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.electricBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

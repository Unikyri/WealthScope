import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// Premium Badge Widget - Shows plan name (Scout / Sentinel) in the app bar.
///
/// Discreet chip that indicates the current plan. Tapping navigates to the
/// subscription screen.
class PremiumBadge extends ConsumerWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) {
        if (isPremium) {
          return _buildSentinelBadge(context);
        }
        return _buildScoutBadge(context);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Sentinel (premium) badge: electricBlue gradient, crown icon, white text.
  Widget _buildSentinelBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.electricBlue,
              AppTheme.electricBlue.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricBlue.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsFill.crownSimple,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 5),
            Text(
              'Sentinel',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Free plan badge: prominent upgrade CTA with crown icon.
  Widget _buildScoutBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.electricBlue.withValues(alpha: 0.3),
              AppTheme.electricBlue.withValues(alpha: 0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.electricBlue.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricBlue.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsRegular.crownSimple,
              color: AppTheme.electricBlue,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Get Premium',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.electricBlue,
              ),
            ),
          ],
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
            AppTheme.electricBlue.withValues(alpha: 0.2),
            AppTheme.electricBlue.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.electricBlue.withValues(alpha: 0.3),
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
            label: const Text('Upgrade to Sentinel'),
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

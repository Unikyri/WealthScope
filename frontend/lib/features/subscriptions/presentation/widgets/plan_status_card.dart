import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

/// Non-intrusive card at the top of Settings showing the user's current plan.
///
/// - **Scout** (free): Subtle card with shield icon, "Free plan" subtitle.
/// - **Sentinel** (premium): Elegant card with crown icon, gradient accent.
class PlanStatusCard extends ConsumerWidget {
  const PlanStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);

    return isPremiumAsync.when(
      data: (isPremium) => _buildCard(context, ref, isPremium),
      loading: () => _buildShimmer(),
      error: (_, __) => _buildCard(context, ref, false),
    );
  }

  Widget _buildCard(BuildContext context, WidgetRef ref, bool isPremium) {
    final planName = isPremium ? 'Sentinel' : 'Scout';
    final planSubtitle =
        isPremium ? 'Premium \u2022 Unlimited access' : 'Free plan \u2022 15 assets max';
    final ctaText = isPremium ? 'Manage' : 'See Plans';

    return GestureDetector(
      onTap: () {
        if (isPremium) {
          // Open Customer Center for subscription management
          ref.read(revenueCatServiceProvider).presentCustomerCenter();
        } else {
          context.push('/subscription');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPremium
                ? AppTheme.electricBlue.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Plan icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isPremium
                    ? LinearGradient(
                        colors: [
                          AppTheme.electricBlue.withValues(alpha: 0.25),
                          AppTheme.electricBlue.withValues(alpha: 0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isPremium ? null : Colors.white.withValues(alpha: 0.06),
              ),
              child: Icon(
                isPremium
                    ? PhosphorIconsFill.crownSimple
                    : PhosphorIconsRegular.shieldCheck,
                color: isPremium ? AppTheme.electricBlue : AppTheme.textGrey,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Plan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WealthScope $planName',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    planSubtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),

            // CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isPremium
                    ? AppTheme.electricBlue.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctaText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPremium ? AppTheme.electricBlue : AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: isPremium ? AppTheme.electricBlue : AppTheme.textGrey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

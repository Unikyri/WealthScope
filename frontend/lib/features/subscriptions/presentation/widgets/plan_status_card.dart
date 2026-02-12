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
    final planName = isPremium ? 'Premium' : 'Plan Gratuito';
    final planSubtitle =
        isPremium ? 'Acceso ilimitado' : '15 activos máx. \u2022 Actualización al cerrar';
    final ctaText = isPremium ? 'Administrar' : 'Obtener Premium';

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
          color: isPremium
              ? AppTheme.cardGrey
              : AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPremium
                ? AppTheme.electricBlue.withValues(alpha: 0.25)
                : AppTheme.electricBlue.withValues(alpha: 0.4),
            width: isPremium ? 1 : 1.5,
          ),
          boxShadow: isPremium
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.electricBlue.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Plan icon
            Container(
              width: 48,
              height: 48,
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
                    : LinearGradient(
                        colors: [
                          AppTheme.electricBlue.withValues(alpha: 0.2),
                          AppTheme.electricBlue.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: Icon(
                isPremium
                    ? PhosphorIconsFill.crownSimple
                    : PhosphorIconsRegular.crownSimple,
                color: AppTheme.electricBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Plan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
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

            // CTA - prominent button for free users
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isPremium
                    ? null
                    : LinearGradient(
                        colors: [
                          AppTheme.electricBlue,
                          AppTheme.electricBlue.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: isPremium
                    ? AppTheme.electricBlue.withValues(alpha: 0.12)
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isPremium
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.electricBlue.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctaText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isPremium ? AppTheme.electricBlue : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: isPremium ? AppTheme.electricBlue : Colors.white,
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

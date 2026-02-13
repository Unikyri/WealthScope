import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/subscriptions/domain/services/feature_gate_service.dart';

/// Reusable upgrade-prompt dialog shown when a Scout user hits a plan limit.
///
/// Dark-themed, non-aggressive, with a clear CTA to `/subscription`.
class UpgradePromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const UpgradePromptDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.cardGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with subtle gradient circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.electricBlue.withValues(alpha: 0.20),
                    AppTheme.electricBlue.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: AppTheme.electricBlue, size: 32),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Message
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // CTA: Upgrade to Sentinel
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/subscription');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.electricBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Upgrade to Sentinel',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dismiss
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Maybe Later',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience helper to show the upgrade prompt dialog.
Future<void> showUpgradePrompt(
  BuildContext context, {
  required String title,
  required String message,
  required IconData icon,
}) {
  return showDialog(
    context: context,
    builder: (_) => UpgradePromptDialog(
      title: title,
      message: message,
      icon: icon,
    ),
  );
}

// ---------------------------------------------------------------------------
// Bottom sheet variant
// ---------------------------------------------------------------------------

/// Show upgrade prompt as a modal bottom sheet (less intrusive alternative).
Future<void> showUpgradeBottomSheet(
  BuildContext context, {
  required String title,
  required String message,
  required IconData icon,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _UpgradeBottomSheetContent(
      title: title,
      message: message,
      icon: icon,
    ),
  );
}

class _UpgradeBottomSheetContent extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _UpgradeBottomSheetContent({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.electricBlue.withValues(alpha: 0.20),
                  AppTheme.electricBlue.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, color: AppTheme.electricBlue, size: 32),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Message
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textGrey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/subscription');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Upgrade to Sentinel',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Dismiss
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe Later',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GateResult convenience helpers
// ---------------------------------------------------------------------------

/// Show the upgrade prompt dialog using a [GateResult].
///
/// Does nothing if the result is [GateResult.allowed].
void showGatePrompt(BuildContext context, GateResult result) {
  if (result.allowed) return;
  showUpgradePrompt(
    context,
    title: result.deniedTitle!,
    message: result.deniedMessage!,
    icon: result.deniedIcon ?? Icons.lock_outline,
  );
}

/// Show the upgrade bottom sheet using a [GateResult].
///
/// Does nothing if the result is [GateResult.allowed].
void showGateBottomSheet(BuildContext context, GateResult result) {
  if (result.allowed) return;
  showUpgradeBottomSheet(
    context,
    title: result.deniedTitle!,
    message: result.deniedMessage!,
    icon: result.deniedIcon ?? Icons.lock_outline,
  );
}

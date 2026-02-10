import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiTriggerButton extends StatelessWidget {
  final VoidCallback onTap;

  const AiTriggerButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 6,
      shadowColor: AppTheme.electricBlue.withOpacity(0.5),
      borderRadius: BorderRadius.circular(28),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                AppTheme.electricBlue,
                AppTheme.electricBlue.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.electricBlue.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              CustomIcons.ai,
              color: Colors.white,
              size: 24,
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .shimmer(
                    duration: 2.seconds, color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}

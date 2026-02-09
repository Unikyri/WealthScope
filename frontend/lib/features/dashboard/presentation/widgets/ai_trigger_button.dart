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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A222D), // Slightly lighter than bg
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.electricBlue.withOpacity(0.3),
            width: 1,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A222D), Color(0xFF161B22)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.electricBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                CustomIcons.ai,
                color: AppTheme.electricBlue,
                size: 20,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.3)),
            
            const SizedBox(width: 16),
            
            // Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What if I sell my BTC?',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              CustomIcons.arrowRight,
              color: AppTheme.textGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

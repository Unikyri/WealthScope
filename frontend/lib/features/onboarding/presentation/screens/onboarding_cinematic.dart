import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';

class OnboardingCinematic extends StatefulWidget {
  const OnboardingCinematic({super.key});

  @override
  State<OnboardingCinematic> createState() => _OnboardingCinematicState();
}

class _OnboardingCinematicState extends State<OnboardingCinematic> {
  final List<String> _bootSequence = [
    "INITIALIZING QUANTUM CORE...",
    "LOADING NEURAL NODES...",
    "ESTABLISHING SECURE CONNECTION...",
    "DECRYPTING ASSET DATA...",
    "SYSTEM OPTIMIZED.",
    "WELCOME, USER.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Core Animation
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.neonGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonGreen.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                CustomIcons.aiFilled,
                size: 48,
                color: AppTheme.neonGreen,
              ),
            )
            .animate()
            .scale(duration: 1.seconds, curve: Curves.easeInOut)
            .then()
            .shimmer(duration: 2.seconds, color: Colors.white),

            const SizedBox(height: 48),

            // Terminal Text Sequence
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _bootSequence.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    child: Text(
                      "> ${_bootSequence[index]}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.neonGreen,
                        fontFamily: 'SpaceMono',
                        letterSpacing: 1.5,
                      ),
                    ).animate().fadeIn(delay: (500 * index).ms).slideX(begin: -0.2, end: 0),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),

            // Enter Button
            OutlinedButton(
              onPressed: () => context.go('/dashboard'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.neonGreen),
                foregroundColor: AppTheme.neonGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                "ENTER SYSTEM",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: AppTheme.neonGreen,
                ),
              ),
            ).animate().fadeIn(delay: 3.5.seconds).scale(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

/// Main AI Advisor Hub Screen
/// Provides access to AI-powered features: Morning Briefing, Chat, and What-If.
class AIAdvisorScreen extends StatelessWidget {
  const AIAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.midnightBlue,
        elevation: 0,
        title: const Text(
          'AI Advisor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Hero visual section
            const _AdvisorHero(),

            const SizedBox(height: 32),

            // Morning Briefing Card
            _PremiumFeatureCard(
              icon: Icons.wb_sunny_rounded,
              gradientColors: const [Color(0xFFFFD700), Color(0xFFFFA000)],
              title: 'Morning Briefing',
              description:
                  'Your personalized daily financial digest with AI-powered portfolio insights.',
              onTap: () => context.push('/ai-briefing'),
            ),
            const SizedBox(height: 14),

            // AI Chat Card
            _PremiumFeatureCard(
              icon: Icons.auto_awesome,
              gradientColors: const [
                AppTheme.electricBlue,
                AppTheme.accentBlue,
              ],
              title: 'AI Chat',
              description:
                  'Ask anything about your portfolio. Get instant, personalized investment advice.',
              onTap: () => context.push('/ai-chat'),
            ),
            const SizedBox(height: 14),

            // What-If Simulator Card
            _PremiumFeatureCard(
              icon: Icons.science_rounded,
              gradientColors: const [
                AppTheme.purpleAccent,
                AppTheme.accentPurple,
              ],
              title: 'What-If Simulator',
              description:
                  'Simulate market scenarios, test buy/sell decisions, and see projected outcomes.',
              onTap: () => context.push('/what-if'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Hero visual section
// -----------------------------------------------------------------------------
class _AdvisorHero extends StatelessWidget {
  const _AdvisorHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.6,
          colors: [
            AppTheme.electricBlue.withValues(alpha: 0.10),
            AppTheme.midnightBlue,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          // Sparkle icon with glow
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.electricBlue.withValues(alpha: 0.20),
                  AppTheme.accentPurple.withValues(alpha: 0.12),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.electricBlue.withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppTheme.electricBlue,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your AI Financial Assistant',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Get personalized insights and explore scenarios',
            style: TextStyle(
              color: AppTheme.textGrey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Premium feature card with gradient icon
// -----------------------------------------------------------------------------
class _PremiumFeatureCard extends StatelessWidget {
  const _PremiumFeatureCard({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = gradientColors.first;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: primaryColor.withValues(alpha: 0.08),
          highlightColor: primaryColor.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Gradient icon container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradientColors[0].withValues(alpha: 0.15),
                        gradientColors[1].withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),

                // Title + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Navigation arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Main AI Advisor Hub Screen
/// Provides access to AI-powered features: Chat and What-If Simulator
class AIAdvisorScreen extends StatelessWidget {
  const AIAdvisorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Advisor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Your AI Financial Assistant',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get personalized insights and explore scenarios',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Morning Briefing Card (NEW!)
            _FeatureCard(
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.amber,
              title: 'Morning Briefing',
              description: 'Get your personalized daily financial briefing with AI-powered insights and portfolio updates.',
              onTap: () => context.push('/ai-briefing'),
            ),
            const SizedBox(height: 16),

            // AI Chat Card
            _FeatureCard(
              icon: Icons.chat_bubble_outline,
              iconColor: colorScheme.primary,
              title: 'AI Chat',
              description: 'Ask questions about your portfolio, get investment advice, and receive personalized recommendations.',
              onTap: () => context.push('/ai-chat'),
            ),
            const SizedBox(height: 16),

            // What-If Simulator Card
            _FeatureCard(
              icon: Icons.science_outlined,
              iconColor: Colors.purple,
              title: 'What-If Simulator',
              description: 'Simulate different scenarios: market changes, buying/selling assets, and see projected outcomes.',
              onTap: () => context.push('/what-if'),
            ),
            const SizedBox(height: 16),

            // Coming Soon Cards
            _FeatureCard(
              icon: Icons.trending_up,
              iconColor: Colors.orange,
              title: 'Market Insights',
              description: 'Real-time market analysis and trends tailored to your portfolio.',
              badge: 'Coming Soon',
              onTap: null,
            ),
            const SizedBox(height: 16),

            _FeatureCard(
              icon: Icons.schedule,
              iconColor: Colors.green,
              title: 'Auto-Rebalancing',
              description: 'Automated portfolio rebalancing based on your risk profile and goals.',
              badge: 'Coming Soon',
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Feature card widget for AI tools
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String? badge;
  final VoidCallback? onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isEnabled = onTap != null;

    return Card(
      elevation: isEnabled ? 2 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? iconColor.withOpacity(0.1)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isEnabled ? iconColor : colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isEnabled
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              if (isEnabled) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

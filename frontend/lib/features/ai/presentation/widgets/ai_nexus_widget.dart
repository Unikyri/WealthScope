import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:wealthscope_app/shared/widgets/tech_card.dart';

/// AI Nexus Widget (Neural Core)
/// The central interaction point for the AI Agent.
/// Titanium Edition: Metallic, rotating, premium.
class AiNexusWidget extends ConsumerStatefulWidget {
  const AiNexusWidget({super.key});

  @override
  ConsumerState<AiNexusWidget> createState() => _AiNexusWidgetState();
}

class _AiNexusWidgetState extends ConsumerState<AiNexusWidget> with TickerProviderStateMixin {
  bool _isExpanded = false;
  
  // TODO: Connect this to actual AI state provider
  AiState _currentState = AiState.idle;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Slow, premium rotation
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100, // Above bottom nav
      right: 16,
      child: GestureDetector(
        onTap: _toggleExpand,
        child: AnimatedContainer(
          duration: 300.ms,
          curve: Curves.easeOutBack,
          width: _isExpanded ? 300 : 70, // Slightly larger touch target
          height: _isExpanded ? 400 : 70,
          child: _isExpanded 
              ? _buildExpandedView() 
              : _buildNeuralCore(),
        ),
      ),
    );
  }

  Widget _buildNeuralCore() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Ring - Platinum - Rotates slowly
        RotationTransition(
          turns: _rotationController,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.titaniumSilver.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                 Align(
                   alignment: Alignment.topCenter,
                   child: Container(width: 1, height: 10, color: AppTheme.titaniumSilver),
                 ),
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: Container(width: 1, height: 10, color: AppTheme.titaniumSilver),
                 ),
                 Align(
                   alignment: Alignment.centerLeft,
                   child: Container(width: 10, height: 1, color: AppTheme.titaniumSilver),
                 ),
                 Align(
                   alignment: Alignment.centerRight,
                   child: Container(width: 10, height: 1, color: AppTheme.titaniumSilver),
                 ),
              ],
            ),
          ),
        ),
        
        // Inner Core - Gold - Pulses
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.obsidianBlack, // Black hole center
            border: Border.all(color: AppTheme.mutedGold, width: 2),
            // No shadow, just sharp metal
          ),
          child: Icon(
            CustomIcons.aiFilled,
            color: AppTheme.mutedGold,
            size: 22,
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
         .scaleXY(end: 1.05, duration: 2000.ms, curve: Curves.easeInOut), // Subtle organic pulse
      ],
    );
  }

  Widget _buildExpandedView() {
    return TechCard(
      padding: EdgeInsets.zero,
      borderColor: AppTheme.mutedGold,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.mutedGold.withOpacity(0.3))),
              color: AppTheme.carbonSurface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CustomIcons.ai, color: AppTheme.mutedGold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'SYSTEM.AI',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.mutedGold,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(CustomIcons.close, size: 18),
                  color: AppTheme.titaniumSilver,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _toggleExpand,
                ),
              ],
            ),
          ),
          
          // Chat Area
          Expanded(
            child: Container(
              color: AppTheme.obsidianBlack,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CustomIcons.ai,
                      size: 48,
                      color: AppTheme.mutedGold.withOpacity(0.2),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds, color: AppTheme.mutedGold),
                    const SizedBox(height: 16),
                    Text(
                      'QUANTUM ONLINE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.mutedGold.withOpacity(0.5),
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analyzing Portfolio...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.titaniumSilver.withOpacity(0.2))),
              color: AppTheme.carbonSurface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianBlack,
                      border: Border.all(color: AppTheme.titaniumSilver.withOpacity(0.3)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Execute command...', 
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'SpaceMono',
                          color: AppTheme.neutralColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppTheme.mutedGold),
                  ),
                  child: const Icon(CustomIcons.microphone, color: AppTheme.mutedGold, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.9, 0.9));
  }
  
  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

enum AiState { idle, listening, processing, speaking }

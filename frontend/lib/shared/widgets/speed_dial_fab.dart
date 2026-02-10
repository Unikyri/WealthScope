import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({super.key});

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  // Define actions
  final List<_SpeedDialOption> _options = [
    _SpeedDialOption(
      icon: Icons.add,
      label: 'Add Asset',
      color: AppTheme.electricBlue,
      heroTag: 'speed_dial_add_asset',
      onTap: (BuildContext context) {
        context.push('/assets/select-type');
      },
    ),
    _SpeedDialOption(
      icon: Icons.upload_file,
      label: 'Import',
      color: AppTheme.emeraldAccent,
      heroTag: 'speed_dial_import',
      onTap: (BuildContext context) {
        context.push('/document-upload');
      },
    ),
    _SpeedDialOption(
      icon: Icons.psychology,
      label: 'AI Advisor',
      color: const Color(0xFF9C27B0),
      heroTag: 'speed_dial_ai_advisor',
      onTap: (BuildContext context) {
        context.push('/ai-chat');
      },
    ),
    _SpeedDialOption(
      icon: Icons.science,
      label: 'What-If',
      color: const Color(0xFFFF9800),
      heroTag: 'speed_dial_what_if',
      onTap: (BuildContext context) {
        context.push('/what-if');
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total height needed
    // 4 options * 64px spacing + 56px main FAB + 152px base offset
    const totalHeight = 400.0;
    const totalWidth = 200.0; // Account for labels

    final screenSize = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Backdrop difuminado cuando está abierto - cubre toda la pantalla
        if (_isOpen)
          Positioned(
            left: -screenSize.width,
            right: -totalWidth,
            top: -screenSize.height,
            bottom: -totalHeight,
            child: GestureDetector(
              onTap: _toggle,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
              ),
            ),
          ),
        SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Options stacked vertically
              ..._options.reversed.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final progress = _controller.value;
                    // Main FAB is at bottom: 0 (relative to SizedBox)
                    // FAB size: 56px
                    // Gap between FAB and first button: 16px
                    // Base offset: 56 (FAB height) + 16 (gap) = 72
                    final fabSize = 56.0;
                    final gap = 16.0;
                    final baseOffset = fabSize + gap;
                    // Each button needs space: 64px between buttons
                    final buttonSpacing = 64.0;

                    return Positioned(
                      right: 0,
                      bottom: baseOffset + (index * buttonSpacing) * progress,
                      child: Transform.scale(
                        scale: progress,
                        child: Opacity(
                          opacity: progress,
                          child: _SpeedDialButton(
                            icon: option.icon,
                            label: option.label,
                            color: option.color,
                            heroTag: option.heroTag,
                            onTap: () {
                              _toggle();
                              option.onTap?.call(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
              // Main FAB
              Positioned(
                right: 0,
                bottom: 0,
                child: Material(
                  elevation: _isOpen ? 8 : 6,
                  shadowColor: AppTheme.electricBlue.withOpacity(0.5),
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isOpen
                            ? [
                                Colors.grey[800]!,
                                Colors.grey[700]!,
                              ]
                            : [
                                AppTheme.electricBlue,
                                AppTheme.electricBlue.withOpacity(0.8),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isOpen
                              ? Colors.black.withOpacity(0.3)
                              : AppTheme.electricBlue.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: _toggle,
                      customBorder: const CircleBorder(),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return RotationTransition(
                              turns: Tween<double>(begin: 0.0, end: 0.125)
                                  .animate(animation),
                              child: child,
                            );
                          },
                          child: Icon(
                            _isOpen ? Icons.close : Icons.add,
                            key: ValueKey<bool>(_isOpen),
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpeedDialOption {
  final IconData icon;
  final String label;
  final Color color;
  final String heroTag;
  final void Function(BuildContext)? onTap;

  const _SpeedDialOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.heroTag,
    this.onTap,
  });
}

class _SpeedDialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String heroTag;
  final VoidCallback onTap;

  const _SpeedDialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Label container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.cardGrey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Mini FAB
        Material(
          elevation: 6,
          shadowColor: color.withOpacity(0.5),
          shape: const CircleBorder(),
          color: Colors.transparent,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

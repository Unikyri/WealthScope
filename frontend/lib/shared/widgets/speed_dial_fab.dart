import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      color: const Color(0xFF1976D2),
      heroTag: 'speed_dial_add_asset',
      onTap: (BuildContext context) {
        // Navigate to add asset
      },
    ),
    _SpeedDialOption(
      icon: Icons.upload_file,
      label: 'Import',
      color: const Color(0xFF00897B),
      heroTag: 'speed_dial_import',
      onTap: (BuildContext context) {
        context.push('/document-upload');
      },
    ),
    _SpeedDialOption(
      icon: Icons.psychology,
      label: 'AI Advisor',
      color: const Color(0xFF7B1FA2),
      heroTag: 'speed_dial_ai_advisor',
      onTap: (BuildContext context) {
        context.push('/ai-chat');
      },
    ),
    _SpeedDialOption(
      icon: Icons.science,
      label: 'What-If',
      color: const Color(0xFFF57C00),
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
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.black54,
            ),
          ),
        // Options stacked vertically
        ..._options.reversed.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = _controller.value;
              // Spacing: 56 (mini FAB) + 12 (gap) = 68px per item
              final baseOffset = 76.0;

              return Positioned(
                right: 8,
                bottom: baseOffset + (index * 68.0) * progress,
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
        FloatingActionButton(
          heroTag: 'speed_dial_main',
          onPressed: _toggle,
          backgroundColor: _isOpen ? Colors.grey[800] : null,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
            },
            child: Icon(
              _isOpen ? Icons.close : Icons.add,
              key: ValueKey<bool>(_isOpen),
            ),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: heroTag,
          mini: true,
          backgroundColor: color,
          onPressed: onTap,
          elevation: 4,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}

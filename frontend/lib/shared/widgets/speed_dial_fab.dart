import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

/// Center-docked Speed Dial FAB.
///
/// Designed to be used as `floatingActionButton` with
/// `FloatingActionButtonLocation.centerDocked`. The main button is a 56x56
/// circle; when tapped it opens an Overlay with a blurred backdrop and
/// 4 option buttons expanding upward.
class SpeedDialFab extends StatefulWidget {
  const SpeedDialFab({super.key});

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  // ---------------------------------------------------------------------------
  // FAB actions (unchanged from original)
  // ---------------------------------------------------------------------------
  final List<_SpeedDialOption> _options = [
    _SpeedDialOption(
      icon: Icons.add,
      label: 'Add Asset',
      color: AppTheme.electricBlue,
      onTap: (BuildContext context) => context.push('/assets/select-type'),
    ),
    _SpeedDialOption(
      icon: Icons.upload_file,
      label: 'Import',
      color: AppTheme.emeraldAccent,
      onTap: (BuildContext context) => context.push('/document-upload'),
    ),
    _SpeedDialOption(
      icon: Icons.psychology,
      label: 'AI Advisor',
      color: const Color(0xFF9C27B0),
      onTap: (BuildContext context) => context.push('/ai-chat'),
    ),
    _SpeedDialOption(
      icon: Icons.science,
      label: 'What-If',
      color: const Color(0xFFFF9800),
      onTap: (BuildContext context) => context.push('/what-if'),
    ),
  ];

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------
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
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Toggle open / close
  // ---------------------------------------------------------------------------
  void _toggle() {
    if (_isOpen) {
      _controller.reverse().then((_) {
        _removeOverlay();
      });
      setState(() => _isOpen = false);
    } else {
      setState(() => _isOpen = true);
      _showOverlay();
      _controller.forward();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fabPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _controller,
        builder: (ctx, __) {
          final progress = _controller.value;
          const buttonSpacing = 60.0;
          // Options start 16px above the top of the FAB
          final baseY = fabPosition.dy - 16;

          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Full-screen backdrop with blur
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggle,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 8 * progress,
                        sigmaY: 8 * progress,
                      ),
                      child: Container(
                        color: Colors.black
                            .withValues(alpha: 0.75 * progress),
                      ),
                    ),
                  ),
                ),

                // Options expanding upward from FAB
                ..._options.reversed.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;

                  return Positioned(
                    // Animate from baseY to final position
                    top: baseY - ((index + 1) * buttonSpacing * progress),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Transform.scale(
                        scale: progress,
                        child: Opacity(
                          opacity: progress,
                          child: _SpeedDialButton(
                            icon: option.icon,
                            label: option.label,
                            color: option.color,
                            onTap: () {
                              _toggle();
                              option.onTap?.call(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // ---------------------------------------------------------------------------
  // Build: just the 56x56 main FAB button
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: _isOpen
                ? [Colors.grey[800]!, Colors.grey[700]!]
                : [
                    AppTheme.electricBlue,
                    AppTheme.electricBlue.withValues(alpha: 0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _isOpen
                  ? Colors.black.withValues(alpha: 0.3)
                  : AppTheme.electricBlue.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns:
                    Tween<double>(begin: 0.0, end: 0.125).animate(animation),
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
    );
  }
}

// -----------------------------------------------------------------------------
// Data class for speed dial options
// -----------------------------------------------------------------------------
class _SpeedDialOption {
  final IconData icon;
  final String label;
  final Color color;
  final void Function(BuildContext)? onTap;

  const _SpeedDialOption({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

// -----------------------------------------------------------------------------
// Individual speed dial button (label + circle icon)
// -----------------------------------------------------------------------------
class _SpeedDialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SpeedDialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.cardGrey,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
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

        // Circle icon button
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

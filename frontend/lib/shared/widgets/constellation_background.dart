import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

class ConstellationBackground extends StatefulWidget {
  final Widget? child;
  final int particleCount;
  final double connectionDistance;
  final bool interactive;

  const ConstellationBackground({
    super.key,
    this.child,
    this.particleCount = 60,
    this.connectionDistance = 120.0,
    this.interactive = true,
  });

  @override
  State<ConstellationBackground> createState() => _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<ConstellationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  Offset? _touchPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    
    final random = Random();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 0.5,
            (random.nextDouble() - 0.5) * 0.5,
          ),
          size: random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  void _updateParticles(Size size) {
    for (var particle in _particles) {
      particle.position += particle.velocity;

      // Bounce off walls
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: widget.interactive
          ? (details) => setState(() => _touchPosition = details.localPosition)
          : null,
      onPanEnd: widget.interactive
          ? (_) => setState(() => _touchPosition = null)
          : null,
      child: Stack(
        children: [
          // Background Color
          Container(color: AppTheme.obsidianBlack),
          
          // Constellation Painter
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                  _initParticles(size);
                  _updateParticles(size);
                  
                  return CustomPaint(
                    size: size,
                    painter: _ConstellationPainter(
                      particles: _particles,
                      connectionDistance: widget.connectionDistance,
                      touchPosition: _touchPosition,
                      lineColor: Theme.of(context).extension<TechTheme>()?.lineColor ?? Colors.white12,
                      nodeColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              );
            },
          ),
          
          // Child Content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  final double size;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
  });
}

class _ConstellationPainter extends CustomPainter {
  final List<Particle> particles;
  final double connectionDistance;
  final Offset? touchPosition;
  final Color lineColor;
  final Color nodeColor;

  _ConstellationPainter({
    required this.particles,
    required this.connectionDistance,
    required this.touchPosition,
    required this.lineColor,
    required this.nodeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintNode = Paint()
      ..color = nodeColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;

    // Draw Connections
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      
      // Connection to other particles
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final distance = (p1.position - p2.position).distance;

        if (distance < connectionDistance) {
          final opacity = 1.0 - (distance / connectionDistance);
          paintLine.color = lineColor.withOpacity(opacity * 0.5);
          canvas.drawLine(p1.position, p2.position, paintLine);
        }
      }

      // Connection to Touch
      if (touchPosition != null) {
        final distance = (p1.position - touchPosition!).distance;
        if (distance < connectionDistance * 1.5) {
          final opacity = 1.0 - (distance / (connectionDistance * 1.5));
          paintLine.color = nodeColor.withOpacity(opacity * 0.8);
          canvas.drawLine(p1.position, touchPosition!, paintLine);
        }
      }

      // Draw Node
      canvas.drawCircle(p1.position, p1.size, paintNode);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainter oldDelegate) => true;
}

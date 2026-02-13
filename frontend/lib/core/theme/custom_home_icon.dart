import 'package:flutter/material.dart';

/// Custom Home Icon matching the provided SVG design
/// Features a center chip with connecting lines (tech/circuit board style)
class CustomHomeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomHomeIcon({
    super.key,
    this.size = 24,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HomeIconPainter(color: color),
    );
  }
}

class _HomeIconPainter extends CustomPainter {
  final Color color;

  _HomeIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 12 // Proporcionalmente a 2px en 24px
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Horizontal line - left
    canvas.drawLine(
      Offset(size.width * 0.083, center.dy), // 2/24
      Offset(size.width * 0.208, center.dy), // 5/24
      paint,
    );

    // Horizontal line - right
    canvas.drawLine(
      Offset(size.width * 0.792, center.dy), // 19/24
      Offset(size.width * 0.917, center.dy), // 22/24
      paint,
    );

    // Vertical line - top
    canvas.drawLine(
      Offset(center.dx, size.height * 0.083), // 2/24
      Offset(center.dx, size.height * 0.208), // 5/24
      paint,
    );

    // Vertical line - bottom
    canvas.drawLine(
      Offset(center.dx, size.height * 0.792), // 19/24
      Offset(center.dx, size.height * 0.917), // 22/24
      paint,
    );

    // Rounded rectangle (chip) - from x=5, y=5, width=14, height=14, rx=4
    final rectLeft = size.width * 0.208; // 5/24
    final rectTop = size.height * 0.208; // 5/24
    final rectWidth = size.width * 0.583; // 14/24
    final rectHeight = size.height * 0.583; // 14/24
    final borderRadius = size.width * 0.167; // 4/24

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight),
        Radius.circular(borderRadius),
      ),
      paint,
    );

    // Center circle - radius = 3
    final circleRadius = size.width * 0.125; // 3/24
    canvas.drawCircle(center, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CowrieShellWidget extends StatelessWidget {
  final int state; // 1 = Open (mouth up), 0 = Closed (back dome up)
  final bool isRolling;
  final double size;

  const CowrieShellWidget({
    super.key,
    required this.state,
    this.isRolling = false,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 0.7,
      height: size,
      child: CustomPaint(
        painter: _CowrieShellPainter(
          isOpen: state == 1,
          isRolling: isRolling,
        ),
      ),
    );
  }
}

class _CowrieShellPainter extends CustomPainter {
  final bool isOpen;
  final bool isRolling;

  _CowrieShellPainter({required this.isOpen, required this.isRolling});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.9,
      height: size.height * 0.95,
    );

    // Shell shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawOval(rect.shift(const Offset(0, 3)), shadowPaint);

    if (isOpen) {
      _paintOpenFace(canvas, rect, center);
    } else {
      _paintClosedFace(canvas, rect, center);
    }
  }

  void _paintOpenFace(Canvas canvas, Rect rect, Offset center) {
    // Ivory porcelain body
    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.2),
        radius: 0.8,
        colors: [
          Color(0xFFFFFDF8),
          Color(0xFFF5EDD8),
          Color(0xFFDEC9A5),
          Color(0xFFB89A74),
        ],
      ).createShader(rect);

    canvas.drawOval(rect, bodyPaint);

    // Border line
    final borderPaint = Paint()
      ..color = const Color(0xFFB89A74)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(rect, borderPaint);

    // Central longitudinal slit
    final slitRect = Rect.fromCenter(
      center: center,
      width: rect.width * 0.16,
      height: rect.height * 0.72,
    );

    final slitPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF6B4219),
          Color(0xFF241002),
          Color(0xFF6B4219),
        ],
      ).createShader(slitRect);
    canvas.drawOval(slitRect, slitPaint);

    // Teeth / Ridges on sides of slit
    final teethPaint = Paint()
      ..color = const Color(0xFF9E7345)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    const teethCount = 7;
    final topY = slitRect.top + 4;
    final bottomY = slitRect.bottom - 4;
    final stepY = (bottomY - topY) / (teethCount - 1);

    for (int i = 0; i < teethCount; i++) {
      final y = topY + i * stepY;
      // Left tooth
      canvas.drawLine(
        Offset(slitRect.left - rect.width * 0.2, y),
        Offset(slitRect.left + 1, y),
        teethPaint,
      );
      // Right tooth
      canvas.drawLine(
        Offset(slitRect.right - 1, y),
        Offset(slitRect.right + rect.width * 0.2, y),
        teethPaint,
      );
    }

    // Glossy reflection
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(rect.left + rect.width * 0.35, rect.top + rect.height * 0.3);
    canvas.rotate(-math.pi / 12);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: rect.width * 0.18, height: rect.height * 0.32),
      glossPaint,
    );
    canvas.restore();
  }

  void _paintClosedFace(Canvas canvas, Rect rect, Offset center) {
    // Caramel dome body
    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.8,
        colors: [
          Color(0xFFFFF8ED),
          Color(0xFFEDD9B4),
          Color(0xFFC69F68),
          Color(0xFF805426),
        ],
      ).createShader(rect);

    canvas.drawOval(rect, bodyPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF805426)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(rect, borderPaint);

    // Natural spotted markings
    final spotPaint = Paint()..color = const Color(0xFF936735).withValues(alpha: 0.35);
    canvas.drawCircle(Offset(center.dx - 4, center.dy - 8), 3.0, spotPaint);
    canvas.drawCircle(Offset(center.dx + 5, center.dy - 4), 2.5, spotPaint);
    canvas.drawCircle(Offset(center.dx - 2, center.dy + 6), 3.5, spotPaint);
    canvas.drawCircle(Offset(center.dx + 6, center.dy + 10), 2.2, spotPaint);

    // Gloss
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 5, center.dy - 10),
        width: rect.width * 0.25,
        height: rect.height * 0.38,
      ),
      glossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CowrieShellPainter oldDelegate) {
    return oldDelegate.isOpen != isOpen || oldDelegate.isRolling != isRolling;
  }
}

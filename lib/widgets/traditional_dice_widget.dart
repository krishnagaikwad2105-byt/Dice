import 'package:flutter/material.dart';
import '../models/dice_type.dart';

class TraditionalDiceWidget extends StatelessWidget {
  final DiceType type;
  final int state; // 1 = Face/Open, 0 = Back/Closed
  final bool isRolling;
  final double size;

  const TraditionalDiceWidget({
    super.key,
    required this.type,
    required this.state,
    this.isRolling = false,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    double width = size * 0.75;
    double height = size;

    if (type == DiceType.sticks) {
      width = size * 0.42;
      height = size * 1.25;
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _TraditionalDicePainter(
          type: type,
          isOpen: state == 1,
          isRolling: isRolling,
        ),
      ),
    );
  }
}

class _TraditionalDicePainter extends CustomPainter {
  final DiceType type;
  final bool isOpen;
  final bool isRolling;

  _TraditionalDicePainter({
    required this.type,
    required this.isOpen,
    required this.isRolling,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    switch (type) {
      case DiceType.whiteStone:
        _paintWhiteStone(canvas, size, center);
        break;
      case DiceType.blackStone:
        _paintBlackStone(canvas, size, center);
        break;
      case DiceType.sticks:
        _paintStick(canvas, size, center);
        break;
      case DiceType.tamarindSeeds:
        _paintTamarindSeed(canvas, size, center);
        break;
      case DiceType.cowrieShells:
        _paintCowrie(canvas, size, center);
        break;
    }
  }

  // 1. WHITE STONE (पांढरे खडे)
  void _paintWhiteStone(Canvas canvas, Size size, Offset center) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.9,
      height: size.height * 0.88,
    );

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawOval(rect.shift(const Offset(0, 3)), shadowPaint);

    if (isOpen) {
      // Marked / Flat face: Smooth polished ivory marble
      final marblePaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.1, -0.2),
          radius: 0.85,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF7F5EE),
            Color(0xFFE4DFD0),
            Color(0xFFCCC5B2),
          ],
        ).createShader(rect);
      canvas.drawOval(rect, marblePaint);

      // Gold etched sacred circle in center
      final markPaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, 5.0, markPaint);

      final dotPaint = Paint()..color = const Color(0xFFE63946);
      canvas.drawCircle(center, 2.5, dotPaint);
    } else {
      // Back dome: Natural rounded river stone
      final domePaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.3),
          radius: 0.75,
          colors: [
            Color(0xFFF0ECE1),
            Color(0xFFD8D2C2),
            Color(0xFFB5ADA0),
            Color(0xFF8F8677),
          ],
        ).createShader(rect);
      canvas.drawOval(rect, domePaint);

      // Subtle natural grey stone veins
      final veinPaint = Paint()
        ..color = const Color(0xFF9E9585).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(rect.left + 5, rect.top + 8),
        Offset(rect.right - 6, rect.bottom - 10),
        veinPaint,
      );
    }
  }

  // 2. BLACK STONE (काळे खडे)
  void _paintBlackStone(Canvas canvas, Size size, Offset center) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.9,
      height: size.height * 0.88,
    );

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawOval(rect.shift(const Offset(0, 3)), shadowPaint);

    if (isOpen) {
      // Marked / Polished Face: Deep obsidian/basalt with white sacred mark
      final stonePaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.15, -0.2),
          radius: 0.8,
          colors: [
            Color(0xFF3A3A3C),
            Color(0xFF242426),
            Color(0xFF141416),
            Color(0xFF08080A),
          ],
        ).createShader(rect);
      canvas.drawOval(rect, stonePaint);

      // White chalk/silver traditional etched mark
      final markPaint = Paint()
        ..color = const Color(0xFFF0F0F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, 5.0, markPaint);

      final dotPaint = Paint()..color = const Color(0xFFF7D070);
      canvas.drawCircle(center, 2.2, dotPaint);
    } else {
      // Back dome: Matte volcanic river pebble
      final domePaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.3),
          radius: 0.8,
          colors: [
            Color(0xFF2C2C2E),
            Color(0xFF1C1C1E),
            Color(0xFF111113),
            Color(0xFF050506),
          ],
        ).createShader(rect);
      canvas.drawOval(rect, domePaint);

      // Soft stone sheen
      final sheenPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - 4, center.dy - 6),
          width: rect.width * 0.35,
          height: rect.height * 0.35,
        ),
        sheenPaint,
      );
    }
  }

  // 3. STICKS (काठ्या / Split Bamboo / Daayam Sticks)
  void _paintStick(Canvas canvas, Size size, Offset center) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.85,
        height: size.height * 0.95,
      ),
      const Radius.circular(5),
    );

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRRect(rect.shift(const Offset(0, 3)), shadowPaint);

    if (isOpen) {
      // Marked Face: Polished golden bamboo with traditional brass/black markings
      final woodPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFD4A373),
            Color(0xFFFAEDCD),
            Color(0xFFE9D8A6),
            Color(0xFFBC6C25),
          ],
        ).createShader(rect.outerRect);
      canvas.drawRRect(rect, woodPaint);

      // Border line
      final borderPaint = Paint()
        ..color = const Color(0xFF8B5A2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawRRect(rect, borderPaint);

      // 3 Brass / Black Inlaid Circles
      final pipPaint = Paint()
        ..color = const Color(0xFF2B1810)
        ..style = PaintingStyle.fill;
      final pipBorder = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      final yOffsets = [-size.height * 0.28, 0.0, size.height * 0.28];
      for (final y in yOffsets) {
        final p = Offset(center.dx, center.dy + y);
        canvas.drawCircle(p, 3.5, pipPaint);
        canvas.drawCircle(p, 3.5, pipBorder);
      }
    } else {
      // Plain / Bark Back: Dark teak wood grain
      final woodPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF582F0E),
            Color(0xFF7F4F24),
            Color(0xFF582F0E),
            Color(0xFF331800),
          ],
        ).createShader(rect.outerRect);
      canvas.drawRRect(rect, woodPaint);

      // Wood grain lines
      final grainPaint = Paint()
        ..color = const Color(0xFF281404).withValues(alpha: 0.4)
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(center.dx - 2, rect.top + 4),
        Offset(center.dx - 2, rect.bottom - 4),
        grainPaint,
      );
      canvas.drawLine(
        Offset(center.dx + 3, rect.top + 4),
        Offset(center.dx + 3, rect.bottom - 4),
        grainPaint,
      );
    }
  }

  // 4. TAMARIND SEEDS (चिंचोके / Chinchoke)
  void _paintTamarindSeed(Canvas canvas, Size size, Offset center) {
    // Tamarind seed is a rounded, slightly asymmetric polygon/oval
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.88,
      height: size.height * 0.86,
    );

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(0, 3)), const Radius.circular(10)),
      shadowPaint,
    );

    final seedRRect = RRect.fromRectAndRadius(rect, const Radius.circular(10));

    if (isOpen) {
      // Split face / Flat rubbed inner side: Creamy ivory kernel
      final kernelPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.1, -0.2),
          radius: 0.85,
          colors: [
            Color(0xFFFFFEEA),
            Color(0xFFF4ECC8),
            Color(0xFFDFCE9E),
            Color(0xFFB89B66),
          ],
        ).createShader(rect);
      canvas.drawRRect(seedRRect, kernelPaint);

      // Dark brown outer seed coat rim surrounding the flat split face
      final rimPaint = Paint()
        ..color = const Color(0xFF3A1805)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2;
      canvas.drawRRect(seedRRect, rimPaint);

      // Seed center kernel line
      final kernelLine = Paint()
        ..color = const Color(0xFFA2834E).withValues(alpha: 0.45)
        ..strokeWidth = 1.2;
      canvas.drawLine(
        Offset(center.dx - 5, center.dy),
        Offset(center.dx + 5, center.dy),
        kernelLine,
      );
    } else {
      // Outer hull: Deep glossy chocolate brown / black seed coat
      final seedPaint = Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.25, -0.3),
          radius: 0.8,
          colors: [
            Color(0xFF4A1F08),
            Color(0xFF2E1204),
            Color(0xFF1B0A02),
            Color(0xFF0C0401),
          ],
        ).createShader(rect);
      canvas.drawRRect(seedRRect, seedPaint);

      // Glossy seed coat highlight
      final glossPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx - 4, center.dy - 6),
          width: rect.width * 0.32,
          height: rect.height * 0.28,
        ),
        glossPaint,
      );
    }
  }

  // 5. COWRIE SHELL (कवडी)
  void _paintCowrie(Canvas canvas, Size size, Offset center) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.9,
      height: size.height * 0.95,
    );

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawOval(rect.shift(const Offset(0, 3)), shadowPaint);

    if (isOpen) {
      // Open face
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

      final borderPaint = Paint()
        ..color = const Color(0xFFB89A74)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawOval(rect, borderPaint);

      final slitRect = Rect.fromCenter(
        center: center,
        width: rect.width * 0.16,
        height: rect.height * 0.72,
      );
      final slitPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6B4219), Color(0xFF241002), Color(0xFF6B4219)],
        ).createShader(slitRect);
      canvas.drawOval(slitRect, slitPaint);

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
        canvas.drawLine(Offset(slitRect.left - rect.width * 0.2, y), Offset(slitRect.left + 1, y), teethPaint);
        canvas.drawLine(Offset(slitRect.right - 1, y), Offset(slitRect.right + rect.width * 0.2, y), teethPaint);
      }
    } else {
      // Closed face
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

      final spotPaint = Paint()..color = const Color(0xFF936735).withValues(alpha: 0.35);
      canvas.drawCircle(Offset(center.dx - 4, center.dy - 8), 3.0, spotPaint);
      canvas.drawCircle(Offset(center.dx + 5, center.dy - 4), 2.5, spotPaint);
      canvas.drawCircle(Offset(center.dx - 2, center.dy + 6), 3.5, spotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TraditionalDicePainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.isOpen != isOpen || oldDelegate.isRolling != isRolling;
  }
}

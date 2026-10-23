import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/pawn.dart';
import '../models/dice_type.dart';

/// Renders authentic physical tokens (White Stone, Black Stone, Sticks, Tamarind Seeds, Cowrie Shells)
/// directly on the board squares.
class PawnTokenWidget extends StatefulWidget {
  final Player player;
  final Pawn pawn;
  final bool isSelectable;
  final VoidCallback? onTap;
  final double size;

  const PawnTokenWidget({
    super.key,
    required this.player,
    required this.pawn,
    this.isSelectable = false,
    this.onTap,
    this.size = 26.0,
  });

  @override
  State<PawnTokenWidget> createState() => _PawnTokenWidgetState();
}

class _PawnTokenWidgetState extends State<PawnTokenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    if (widget.isSelectable) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant PawnTokenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelectable && !_animController.isAnimating) {
      _animController.repeat(reverse: true);
    } else if (!widget.isSelectable && _animController.isAnimating) {
      _animController.stop();
      _animController.reset();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return GestureDetector(
      onTap: widget.isSelectable ? widget.onTap : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final scale = widget.isSelectable ? _pulseAnimation.value : 1.0;

          return Transform.scale(
            scale: scale,
            child: SizedBox(
              width: s,
              height: s,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Selectable Glowing Halo Aura
                  if (widget.isSelectable)
                    Container(
                      width: s + 8,
                      height: s + 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF7D070).withValues(alpha: 0.85),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: widget.player.color.withValues(alpha: 0.7),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),

                  // The Physical Token Custom Painter
                  CustomPaint(
                    size: Size(s, s),
                    painter: _PawnTokenPainter(
                      tokenType: widget.player.tokenType,
                      playerColor: widget.player.color,
                      playerColorLight: widget.player.colorLight,
                      playerColorDark: widget.player.colorDark,
                      isSelectable: widget.isSelectable,
                    ),
                  ),

                  // Pawn ID badge (1..4)
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: widget.player.colorDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isSelectable
                              ? const Color(0xFFF7D070)
                              : Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        "${widget.pawn.id + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PawnTokenPainter extends CustomPainter {
  final DiceType tokenType;
  final Color playerColor;
  final Color playerColorLight;
  final Color playerColorDark;
  final bool isSelectable;

  _PawnTokenPainter({
    required this.tokenType,
    required this.playerColor,
    required this.playerColorLight,
    required this.playerColorDark,
    required this.isSelectable,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawCircle(center.translate(0, 2), radius * 0.9, shadowPaint);

    switch (tokenType) {
      case DiceType.whiteStone:
        _drawWhiteStone(canvas, center, radius);
        break;
      case DiceType.blackStone:
        _drawBlackStone(canvas, center, radius);
        break;
      case DiceType.sticks:
        _drawStick(canvas, center, radius);
        break;
      case DiceType.tamarindSeeds:
        _drawTamarindSeed(canvas, center, radius);
        break;
      case DiceType.cowrieShells:
        _drawCowrie(canvas, center, radius);
        break;
    }

    // Outer Player Team Ring
    final teamRingPaint = Paint()
      ..color = isSelectable ? const Color(0xFFF7D070) : playerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelectable ? 2.2 : 1.4;
    canvas.drawCircle(center, radius - 1.0, teamRingPaint);
  }

  // 1. WHITE STONE (पांढरे खडे)
  void _drawWhiteStone(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius - 1.5);
    final stonePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFF8F6F0),
          Color(0xFFE8E2D2),
          Color(0xFFC7BDA9),
        ],
      ).createShader(rect);
    canvas.drawOval(rect, stonePaint);

    // Sacred Gold Ring
    final goldRingPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(center, radius * 0.42, goldRingPaint);

    // Red Vermilion Center Dot
    final redDotPaint = Paint()..color = const Color(0xFFE63946);
    canvas.drawCircle(center, radius * 0.22, redDotPaint);
  }

  // 2. BLACK STONE (काळे खडे)
  void _drawBlackStone(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius - 1.5);
    final stonePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.85,
        colors: [
          Color(0xFF38383B),
          Color(0xFF222225),
          Color(0xFF141416),
          Color(0xFF060608),
        ],
      ).createShader(rect);
    canvas.drawOval(rect, stonePaint);

    // Silver Sacred Ring
    final silverRingPaint = Paint()
      ..color = const Color(0xFFE5E5EA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(center, radius * 0.42, silverRingPaint);

    // Gold Sandalwood Center Dot
    final goldDotPaint = Paint()..color = const Color(0xFFF7D070);
    canvas.drawCircle(center, radius * 0.22, goldDotPaint);
  }

  // 3. STICKS (काठ्या / Bamboo Token)
  void _drawStick(Canvas canvas, Offset center, double radius) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 1.5,
        height: radius * 1.85,
      ),
      const Radius.circular(4),
    );

    final woodPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFD4A373),
          Color(0xFFFAEDCD),
          Color(0xFFE9D8A6),
          Color(0xFFBC6C25),
        ],
      ).createShader(rect.outerRect);
    canvas.drawRRect(rect, woodPaint);

    final woodBorder = Paint()
      ..color = const Color(0xFF8B5A2B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rect, woodBorder);

    // 2 Inlaid Brass Dots
    final brassDot = Paint()..color = const Color(0xFF2B1810);
    final brassRim = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final dotOffsets = [-radius * 0.45, radius * 0.45];
    for (final dy in dotOffsets) {
      final p = Offset(center.dx, center.dy + dy);
      canvas.drawCircle(p, radius * 0.18, brassDot);
      canvas.drawCircle(p, radius * 0.18, brassRim);
    }
  }

  // 4. TAMARIND SEED (चिंचोके)
  void _drawTamarindSeed(Canvas canvas, Offset center, double radius) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: radius * 1.65,
        height: radius * 1.65,
      ),
      const Radius.circular(6),
    );

    // Ivory Split Kernel Face
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
      ).createShader(rect.outerRect);
    canvas.drawRRect(rect, kernelPaint);

    // Dark Mahogany Seed Coat Rim
    final seedRimPaint = Paint()
      ..color = const Color(0xFF3A1805)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawRRect(rect, seedRimPaint);

    // Split Line
    final splitLine = Paint()
      ..color = const Color(0xFFA2834E).withValues(alpha: 0.6)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx - radius * 0.35, center.dy),
      Offset(center.dx + radius * 0.35, center.dy),
      splitLine,
    );
  }

  // 5. COWRIE SHELL (कवडी)
  void _drawCowrie(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCenter(
      center: center,
      width: radius * 1.5,
      height: radius * 1.85,
    );

    final shellPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.2),
        radius: 0.85,
        colors: [
          Color(0xFFFFFDF8),
          Color(0xFFF5EDD8),
          Color(0xFFDEC9A5),
          Color(0xFFB89A74),
        ],
      ).createShader(rect);
    canvas.drawOval(rect, shellPaint);

    // Slit
    final slitRect = Rect.fromCenter(
      center: center,
      width: rect.width * 0.22,
      height: rect.height * 0.72,
    );
    final slitPaint = Paint()..color = const Color(0xFF3E200B);
    canvas.drawOval(slitRect, slitPaint);
  }

  @override
  bool shouldRepaint(covariant _PawnTokenPainter oldDelegate) {
    return oldDelegate.tokenType != tokenType ||
        oldDelegate.playerColor != playerColor ||
        oldDelegate.isSelectable != isSelectable;
  }
}

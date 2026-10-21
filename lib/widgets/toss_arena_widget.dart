import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import 'cowrie_shell_widget.dart';

class TossArenaWidget extends StatelessWidget {
  final GameController controller;

  const TossArenaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final player = controller.currentPlayer;
    final canRoll = !player.isAI &&
        !controller.isRolling &&
        !controller.isMovingPawn &&
        !controller.waitingForPawnChoice &&
        controller.winner == null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xCC1C1009),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x44D4AF37)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brass / Velvet Bowl
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFF1B3D2F), Color(0xFF0D1E17), Color(0xFF3D2812)],
                radius: 0.9,
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF916828), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                return CowrieShellWidget(
                  state: controller.shells[i],
                  isRolling: controller.isRolling,
                  size: 54,
                );
              }),
            ),
          ),

          const SizedBox(height: 12),

          // Outcome Banner
          if (controller.currentRoll != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _getRollText(controller.currentRoll!),
                style: const TextStyle(
                  color: Color(0xFFF7D070),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Roll Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: canRoll ? () => controller.rollCowries() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                disabledBackgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: canRoll ? const Color(0xFFFFF5CC) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                elevation: canRoll ? 4 : 0,
              ),
              child: Text(
                _getButtonText(player),
                style: TextStyle(
                  color: canRoll ? const Color(0xFF1A0E05) : Colors.grey.shade400,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRollText(int roll) {
    if (roll == 8) return "Rolled: 8 (चंपाळ / Champool!) 🌟 BONUS ROLL";
    if (roll == 4) return "Rolled: 4 🌟 BONUS ROLL";
    return "Rolled: $roll";
  }

  String _getButtonText(player) {
    if (controller.winner != null) return "Game Over";
    if (player.isAI) return "🤖 AI is Playing...";
    if (controller.isRolling) return "Rolling Kavadis...";
    if (controller.waitingForPawnChoice) return "Tap a Glowing Pawn (${controller.currentRoll})";
    return "🎲 Roll Kavadis (कवड्या टाका)";
  }
}

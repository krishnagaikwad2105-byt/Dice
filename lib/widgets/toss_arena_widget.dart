import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/dice_type.dart';
import 'traditional_dice_widget.dart';

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

    final isStick = controller.diceType == DiceType.sticks;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          // Dice Type Selector Pills
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: DiceType.values.map((type) {
                final isSelected = controller.diceType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(
                      "${type.icon} ${type.shortName}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.white70,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFF7D070),
                    backgroundColor: const Color(0xFF2B1408),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFF7D070) : const Color(0x44D4AF37),
                    ),
                    visualDensity: VisualDensity.compact,
                    onSelected: (selected) {
                      if (selected) {
                        controller.setDiceType(type);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Casting Dish / Arena
          Container(
            height: isStick ? 96 : 82,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                colors: [Color(0xFF1B3D2F), Color(0xFF0D1E17), Color(0xFF3D2812)],
                radius: 0.9,
              ),
              borderRadius: BorderRadius.circular(isStick ? 20 : 40),
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
                return TraditionalDiceWidget(
                  type: controller.diceType,
                  state: controller.shells[i],
                  isRolling: controller.isRolling,
                  size: isStick ? 56 : 52,
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // Outcome Banner
          if (controller.currentRoll != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _getRollText(controller.currentRoll!),
                style: const TextStyle(
                  color: Color(0xFFF7D070),
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Roll Button
          SizedBox(
            width: double.infinity,
            height: 44,
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
                  fontSize: 14.5,
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
    if (controller.isRolling) return "Tossing ${controller.diceType.shortName}...";
    if (controller.waitingForPawnChoice) return "Tap a Glowing Pawn (${controller.currentRoll})";
    return "🎲 ${controller.diceType.rollActionText}";
  }
}

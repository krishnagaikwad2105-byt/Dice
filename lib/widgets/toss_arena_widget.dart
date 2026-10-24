import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/dice_type.dart';
import '../models/player.dart';
import '../i18n/localization_service.dart';
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

    final theme = controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;
    final isStick = controller.diceType == DiceType.sticks;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: theme.isDark ? 0.92 : 0.98),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.6 : 0.06),
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
                      "${type.icon} ${type.getLocalizedName(lang)}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? (theme.isDark ? Colors.black : Colors.white)
                            : theme.textColor.withValues(alpha: 0.7),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.accentGold,
                    backgroundColor: theme.isDark ? const Color(0xFF2B1408) : Colors.white,
                    side: BorderSide(
                      color: isSelected ? theme.accentGold : theme.cardBorder,
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
              gradient: RadialGradient(
                colors: theme.tossDishBg,
                radius: 0.9,
              ),
              borderRadius: BorderRadius.circular(isStick ? 20 : 40),
              border: Border.all(color: theme.tossDishBorder, width: theme.isDark ? 3 : 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: theme.isDark ? 0.8 : 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                _getRollText(controller.currentRoll!, loc),
                style: TextStyle(
                  color: theme.accentGold,
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
                backgroundColor: theme.primaryButtonBg,
                disabledBackgroundColor: theme.isDark ? Colors.grey.shade800 : const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: canRoll ? theme.accentGold : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                elevation: canRoll ? 4 : 0,
              ),
              child: Text(
                _getButtonText(player, loc, lang),
                style: TextStyle(
                  color: canRoll ? theme.primaryButtonTextColor : (theme.isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8)),
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

  String _getRollText(int roll, LocalizationService loc) {
    if (roll == 8) return loc.t('champalBonus');
    if (roll == 4) return loc.t('challasBonus');
    return "${loc.t('rolled')}: $roll";
  }

  String _getButtonText(Player player, LocalizationService loc, AppLanguage lang) {
    if (controller.winner != null) return loc.t('gameOver');
    if (player.isAI) return "🤖 ${player.getDisplayName(lang)} ${loc.t('botThinking')}";
    if (controller.isRolling) return loc.t('tossingAction');
    if (controller.waitingForPawnChoice) return "👆 ${loc.t('tapPawnPrompt')} (${controller.currentRoll})";
    return "🎲 ${controller.diceType.getLocalizedRollAction(lang)}";
  }
}

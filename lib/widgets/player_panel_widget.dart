import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/player.dart';

class PlayerPanelWidget extends StatelessWidget {
  final GameController controller;

  const PlayerPanelWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: controller.players.asMap().entries.map((entry) {
        final idx = entry.key;
        final player = entry.value;
        final isCurrent = idx == controller.currentPlayerIdx;

        return _buildPlayerCard(player, isCurrent);
      }).toList(),
    );
  }

  Widget _buildPlayerCard(Player player, bool isCurrent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrent
            ? controller.theme.cardCurrentPlayerBg
            : controller.theme.surfaceBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCurrent ? player.color : Colors.white10,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: player.color.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: player.color,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    player.avatar,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "${player.isAI ? '🤖 Bot' : '👤 You'} • ${player.side}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: player.hasPani
                      ? const Color(0x332EC4B6)
                      : const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: player.hasPani
                        ? const Color(0xFF2EC4B6)
                        : Colors.white24,
                  ),
                ),
                child: Text(
                  player.hasPani ? "🌊 PANI" : "🔒 NO PANI",
                  style: TextStyle(
                    color: player.hasPani
                        ? const Color(0xFF5CF0E2)
                        : Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatPill("⚔️", "${player.kills}", "Kills"),
              _buildStatPill("🏠", "${player.baseCount}", "Base"),
              _buildStatPill("🚶", "${player.fieldCount}", "Field"),
              _buildStatPill("🏆", "${player.homeCount}/4", "Home", isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String icon, String val, String label, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0x33D4AF37) : Colors.black26,
        borderRadius: BorderRadius.circular(6),
        border: isHighlight ? Border.all(color: const Color(0x66D4AF37)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            val,
            style: const TextStyle(
              color: Color(0xFFF7D070),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/player.dart';
import '../i18n/localization_service.dart';

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

        return _buildPlayerCard(context, player, isCurrent);
      }).toList(),
    );
  }

  Widget _buildPlayerCard(BuildContext context, Player player, bool isCurrent) {
    final theme = controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;

    final cardBg = isCurrent
        ? theme.cardCurrentPlayerBg
        : theme.surfaceBg;

    final borderColor = isCurrent ? player.color : theme.cardBorder;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCurrent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? player.color.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isCurrent ? 8 : 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: player.color,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: player.color.withValues(alpha: 0.35),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    player.avatar,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.getDisplayName(lang),
                      style: TextStyle(
                        color: theme.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${player.isAI ? '🤖 ${loc.t("bot")}' : '👤 ${loc.t("you")}'} • ${player.getLocalizedSide(lang)}",
                      style: TextStyle(
                        color: theme.textSecondaryColor,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: player.hasPani
                      ? (theme.isDark ? const Color(0x332EC4B6) : const Color(0xFFDCFCE7))
                      : (theme.isDark ? const Color(0x22FFFFFF) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: player.hasPani
                        ? (theme.isDark ? const Color(0xFF2EC4B6) : const Color(0xFF22C55E))
                        : theme.cardBorder,
                  ),
                ),
                child: Text(
                  player.hasPani ? "🌊 ${loc.t('paniUnlocked')}" : "🔒 ${loc.t('noPani')}",
                  style: TextStyle(
                    color: player.hasPani
                        ? (theme.isDark ? const Color(0xFF5CF0E2) : const Color(0xFF15803D))
                        : theme.textSecondaryColor,
                    fontSize: 9.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildStatPill("⚔️", "${player.kills}", loc.t('kills'))),
              const SizedBox(width: 4),
              Expanded(child: _buildStatPill("🏠", "${player.baseCount}", loc.t('base'))),
              const SizedBox(width: 4),
              Expanded(child: _buildStatPill("🚶", "${player.fieldCount}", loc.t('field'))),
              const SizedBox(width: 4),
              Expanded(child: _buildStatPill("🏆", "${player.homeCount}/4", loc.t('home'), isHighlight: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String icon, String val, String label, {bool isHighlight = false}) {
    final theme = controller.theme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3.5),
      decoration: BoxDecoration(
        color: isHighlight
            ? (theme.isDark ? const Color(0x33D4AF37) : const Color(0xFFFEF3C7))
            : (theme.isDark ? Colors.black26 : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isHighlight
              ? (theme.isDark ? const Color(0x66D4AF37) : const Color(0xFFF59E0B))
              : theme.cardBorder,
          width: 0.8,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 10)),
            const SizedBox(width: 2.5),
            Text(
              val,
              style: TextStyle(
                color: isHighlight
                    ? (theme.isDark ? const Color(0xFFF7D070) : const Color(0xFFB45309))
                    : theme.textColor,
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2.5),
            Text(
              label,
              style: TextStyle(
                color: theme.textSecondaryColor,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

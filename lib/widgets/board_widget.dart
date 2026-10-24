import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/board_paths.dart';
import '../models/player.dart';
import '../models/pawn.dart';
import '../models/dice_type.dart';
import '../i18n/localization_service.dart';
import 'traditional_dice_widget.dart';
import 'pawn_token_widget.dart';

class BoardWidget extends StatelessWidget {
  final GameController controller;

  const BoardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizing for board
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final availableH = maxH.isFinite ? maxH : 720.0;
        final targetW = (maxW * 0.98).clamp(300.0, 480.0);
        // Reserve height for header (~42px) and toss footer (~130px)
        final gridTargetSize = ((availableH - 200.0).clamp(240.0, targetW - 24.0)).clamp(240.0, 420.0);

        final theme = controller.theme;

        return Container(
          width: targetW,
          decoration: BoxDecoration(
            color: theme.boardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.boardBorder, width: theme.isDark ? 3.0 : 1.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: theme.boardGradient,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: theme.isDark ? 0.6 : 0.08),
                blurRadius: theme.isDark ? 20 : 12,
                offset: const Offset(0, 6),
              ),
              if (theme.isDark)
                BoxShadow(
                  color: theme.boardGlow.withValues(alpha: 0.25),
                  blurRadius: 18,
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. ON-BOARD DICE / TOKEN TYPE SELECTOR
              _buildOnBoardDiceSelector(context),

              const SizedBox(height: 6),

              // 2. 5x5 TRADITIONAL BOARD GRID
              SizedBox(
                width: gridTargetSize,
                height: gridTargetSize,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 25,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 3.5,
                    mainAxisSpacing: 3.5,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ 5;
                    final col = index % 5;
                    final coord = BoardCoord(row, col);

                    return _buildCell(context, coord, gridTargetSize / 5);
                  },
                ),
              ),

              const SizedBox(height: 8),

              // 3. ON-BOARD TOSS ARENA
              _buildOnBoardTossArena(context),
            ],
          ),
        );
      },
    );
  }

  // 1. On-Board Selector for the Traditional Types (+ Cowrie)
  Widget _buildOnBoardDiceSelector(BuildContext context) {
    final theme = controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.isDark ? const Color(0x99120702) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "⚔️ ${loc.t('piecesAndCasting').toUpperCase()}: ",
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                controller.diceType.getLocalizedName(lang),
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: DiceType.values.map((type) {
                final isSelected = controller.diceType == type;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    label: Text(
                      "${type.icon} ${type.getLocalizedName(lang)}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? (theme.isDark ? Colors.black : Colors.white)
                            : theme.textColor.withValues(alpha: 0.75),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.accentGold,
                    backgroundColor: theme.isDark ? const Color(0xFF261206) : Colors.white,
                    side: BorderSide(
                      color: isSelected ? theme.accentGold : theme.cardBorder,
                    ),
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
        ],
      ),
    );
  }

  // 2. Cell Builder with authentic sanctuary marks and token rendering
  Widget _buildCell(BuildContext context, BoardCoord coord, double cellSize) {
    final r = coord.row;
    final c = coord.col;

    final isCenter = (r == 2 && c == 2);
    final isSouthHome = (r == 4 && c == 2);
    final isWestHome = (r == 2 && c == 0);
    final isNorthHome = (r == 0 && c == 2);
    final isEastHome = (r == 2 && c == 4);
    final isSafe = isCenter || isSouthHome || isWestHome || isNorthHome || isEastHome;
    final isPani = (r >= 1 && r <= 3 && c >= 1 && c <= 3 && !isCenter);

    // Collect pawns located on this cell
    final pawnsOnCell = <_PawnInfo>[];

    for (int pIdx = 0; pIdx < controller.players.length; pIdx++) {
      final player = controller.players[pIdx];
      for (int i = 0; i < player.pawns.length; i++) {
        final pawn = player.pawns[i];
        BoardCoord pawnCoord;
        if (pawn.isHome) {
          pawnCoord = const BoardCoord(2, 2);
        } else {
          // Use player.pathIndex to correctly reflect North, West, East or South path
          pawnCoord = BoardPaths.playerPaths[player.pathIndex][pawn.stepIndex];
        }

        if (pawnCoord == coord) {
          final isSelectable = controller.waitingForPawnChoice &&
              pIdx == controller.currentPlayerIdx &&
              controller.validPawnIndices.contains(i) &&
              !player.isAI;

          pawnsOnCell.add(_PawnInfo(
            player: player,
            pawn: pawn,
            pawnIndex: i,
            isSelectable: isSelectable,
          ));
        }
      }
    }

    final theme = controller.theme;
    final loc = LocalizationService.instance;

    BoxDecoration decoration;

    if (isCenter) {
      decoration = BoxDecoration(
        color: theme.cellCenterBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.cellCenterBorder, width: 2),
        gradient: RadialGradient(
          colors: theme.cellCenterGradient,
          radius: 0.85,
        ),
      );
    } else if (isSafe) {
      Color safeBorder = theme.accentGold;
      if (isSouthHome) safeBorder = const Color(0xFFE63946);
      if (isWestHome) safeBorder = const Color(0xFF2A9D8F);
      if (isNorthHome) safeBorder = const Color(0xFFE76F51);
      if (isEastHome) safeBorder = const Color(0xFF3A86FF);

      decoration = BoxDecoration(
        color: theme.cellDefaultBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: safeBorder.withValues(alpha: 0.85), width: 1.8),
        gradient: RadialGradient(
          colors: [safeBorder.withValues(alpha: theme.isDark ? 0.32 : 0.15), theme.cellDefaultBg],
          radius: 0.85,
        ),
      );
    } else if (isPani) {
      decoration = BoxDecoration(
        color: theme.cellPaniBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.cellPaniBorder, width: 1.2),
      );
    } else {
      decoration = BoxDecoration(
        color: theme.cellDefaultBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.cellDefaultBorder, width: 1),
      );
    }

    return Container(
      decoration: decoration,
      child: Stack(
        children: [
          // Background Sanctuary Markings
          if (isCenter)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("⚜️", style: TextStyle(fontSize: 10)),
                  Text(
                    loc.t('swargaHome'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.isDark ? const Color(0xFFF7D070) : const Color(0xFFB45309),
                      fontSize: 8.0,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                  ),
                  if (pawnsOnCell.isNotEmpty)
                    Text(
                      "(${pawnsOnCell.length}🏆)",
                      style: TextStyle(
                        color: theme.isDark ? const Color(0xFFF7D070) : const Color(0xFFB45309),
                        fontSize: 7,
                      ),
                    ),
                ],
              ),
            )
          else if (isSouthHome)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("⚪", style: TextStyle(fontSize: 12, height: 1.0)),
                  Text(
                    loc.t('whiteStone'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.isDark ? const Color(0xCCFFFFFF) : const Color(0xFF475569),
                      fontSize: 7.0,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          else if (isWestHome)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("⚫", style: TextStyle(fontSize: 12, height: 1.0)),
                  Text(
                    loc.t('blackStone'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF2A9D8F),
                      fontSize: 7.0,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          else if (isNorthHome)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🪵", style: TextStyle(fontSize: 12, height: 1.0)),
                  Text(
                    loc.t('sticks'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE76F51),
                      fontSize: 7.0,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          else if (isEastHome)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("🌰", style: TextStyle(fontSize: 12, height: 1.0)),
                  Text(
                    loc.t('tamarindSeeds'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3A86FF),
                      fontSize: 7.0,
                      fontWeight: FontWeight.bold,
                      height: 1.05,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          else if (isPani)
            Center(
              child: Text(
                loc.t('paniStream'),
                style: TextStyle(
                  color: theme.cellPaniTextColor.withValues(alpha: theme.isDark ? 0.6 : 0.8),
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Criss-cross sanctuary lines on safe squares
          if (isSafe && !isCenter)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SanctuaryCrossPainter(
                    color: theme.isDark ? const Color(0x33F7D070) : const Color(0x33000000),
                  ),
                ),
              ),
            ),

          // Render authentic White Stones, Black Stones, Sticks, Tamarind Seeds on this cell!
          if (pawnsOnCell.isNotEmpty)
            Center(
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                alignment: WrapAlignment.center,
                children: pawnsOnCell.map((info) {
                  final tokenSize = pawnsOnCell.length > 2
                      ? (cellSize * 0.42).clamp(18.0, 24.0)
                      : (cellSize * 0.52).clamp(22.0, 30.0);

                  return PawnTokenWidget(
                    player: info.player,
                    pawn: info.pawn,
                    isSelectable: info.isSelectable,
                    size: tokenSize,
                    onTap: info.isSelectable
                        ? () => controller.movePawn(info.pawnIndex)
                        : null,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // 3. On-Board Toss Arena Display
  Widget _buildOnBoardTossArena(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: theme.isDark ? 0.92 : 0.98),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Casting Dish with the 4 Active Cast Pieces
          Container(
            height: isStick ? 84 : 70,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: theme.tossDishBg,
                radius: 0.95,
              ),
              borderRadius: BorderRadius.circular(isStick ? 16 : 36),
              border: Border.all(color: theme.tossDishBorder, width: theme.isDark ? 2.5 : 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: theme.isDark ? 0.6 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                  size: isStick ? 50 : 44,
                );
              }),
            ),
          ),

          const SizedBox(height: 6),

          // Outcome Banner
          if (controller.currentRoll != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                _getRollText(controller.currentRoll!, loc),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // On-Board Roll Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: canRoll ? () => controller.rollCowries() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryButtonBg,
                disabledBackgroundColor: theme.isDark ? Colors.grey.shade800 : const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: canRoll ? theme.accentGold : Colors.transparent,
                    width: 1.2,
                  ),
                ),
                elevation: canRoll ? (theme.isDark ? 4 : 2) : 0,
              ),
              child: Text(
                _getButtonText(player, loc, lang),
                style: TextStyle(
                  color: canRoll ? theme.primaryButtonTextColor : (theme.isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8)),
                  fontSize: 13.5,
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
    if (controller.waitingForPawnChoice) {
      return "👆 ${loc.t('tapPawnPrompt')} (${controller.currentRoll})";
    }
    return "🎲 ${controller.diceType.getLocalizedRollAction(lang)}";
  }
}

class _SanctuaryCrossPainter extends CustomPainter {
  final Color color;

  const _SanctuaryCrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset.zero, Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _SanctuaryCrossPainter oldDelegate) =>
      color != oldDelegate.color;
}

class _PawnInfo {
  final Player player;
  final Pawn pawn;
  final int pawnIndex;
  final bool isSelectable;

  _PawnInfo({
    required this.player,
    required this.pawn,
    required this.pawnIndex,
    required this.isSelectable,
  });
}

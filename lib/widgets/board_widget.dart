import 'package:flutter/material.dart';
import '../logic/game_controller.dart';
import '../models/board_paths.dart';
import '../models/player.dart';
import '../models/pawn.dart';

class BoardWidget extends StatelessWidget {
  final GameController controller;

  const BoardWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final boardSize = (availableSize * 0.96).clamp(280.0, 520.0);

        return Container(
          width: boardSize,
          height: boardSize,
          decoration: BoxDecoration(
            color: const Color(0xFF201107),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF916828), width: 3.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 25,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                blurRadius: 20,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0),
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

              return _buildCell(context, coord);
            },
          ),
        );
      },
    );
  }

  Widget _buildCell(BuildContext context, BoardCoord coord) {
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
          pawnCoord = BoardPaths.playerPaths[pIdx][pawn.stepIndex];
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

    BoxDecoration decoration;

    if (isCenter) {
      decoration = BoxDecoration(
        color: const Color(0xFF381A0B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        gradient: const RadialGradient(
          colors: [Color(0x66D4AF37), Color(0xEE1E0F06)],
          radius: 0.8,
        ),
      );
    } else if (isSafe) {
      Color safeBorder = const Color(0xFFD4AF37);
      if (isSouthHome) safeBorder = const Color(0xFFE63946);
      if (isWestHome) safeBorder = const Color(0xFF2A9D8F);
      if (isNorthHome) safeBorder = const Color(0xFFE76F51);
      if (isEastHome) safeBorder = const Color(0xFF3A86FF);

      decoration = BoxDecoration(
        color: const Color(0xFF25140B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: safeBorder.withValues(alpha: 0.6), width: 1.5),
        gradient: RadialGradient(
          colors: [safeBorder.withValues(alpha: 0.25), const Color(0xFF201007)],
          radius: 0.85,
        ),
      );
    } else if (isPani) {
      decoration = BoxDecoration(
        color: const Color(0x8814525A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0x662EC4B6), width: 1),
      );
    } else {
      decoration = BoxDecoration(
        color: const Color(0xFF2E1C12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF5A381F), width: 1),
      );
    }

    return Container(
      decoration: decoration,
      child: Stack(
        children: [
          // Background Markings
          if (isCenter)
            const Center(
              child: Text(
                "स्वर्ग\nHOME",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF7D070),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            )
          else if (isSafe)
            const Center(
              child: Text(
                "✕",
                style: TextStyle(
                  color: Color(0x66F7D070),
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
            )
          else if (isPani)
            const Center(
              child: Text(
                "≈ पाणी ≈",
                style: TextStyle(
                  color: Color(0x445CF0E2),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Render clustered pawns on cell
          if (pawnsOnCell.isNotEmpty)
            Center(
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                alignment: WrapAlignment.center,
                children: pawnsOnCell.map((info) {
                  return _buildPawnWidget(info);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPawnWidget(_PawnInfo info) {
    final size = info.isSelectable ? 26.0 : 22.0;

    return GestureDetector(
      onTap: info.isSelectable
          ? () => controller.movePawn(info.pawnIndex)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              info.player.colorLight,
              info.player.color,
              info.player.colorDark,
            ],
          ),
          border: Border.all(
            color: info.isSelectable ? const Color(0xFFF7D070) : Colors.white,
            width: info.isSelectable ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: info.isSelectable
                  ? const Color(0xFFF7D070).withValues(alpha: 0.8)
                  : Colors.black.withValues(alpha: 0.5),
              blurRadius: info.isSelectable ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            info.player.avatar,
            style: TextStyle(fontSize: size * 0.45),
          ),
        ),
      ),
    );
  }
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

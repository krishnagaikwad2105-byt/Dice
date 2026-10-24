import 'package:flutter/material.dart';
import 'player.dart';
import 'pawn.dart';
import 'dice_type.dart';

class BoardCoord {
  final int row;
  final int col;

  const BoardCoord(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardCoord &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => '($row, $col)';
}

class BoardPaths {
  // Safe sanctuary squares (Ghar / Safe Zones)
  static const List<BoardCoord> safeSquares = [
    BoardCoord(4, 2), // South Home
    BoardCoord(2, 0), // West Home
    BoardCoord(0, 2), // North Home
    BoardCoord(2, 4), // East Home
    BoardCoord(2, 2), // Center Swarga (Home)
  ];

  static bool isSafe(BoardCoord coord) {
    return safeSquares.contains(coord);
  }

  // 25-step paths for each of the 4 kingdoms:
  // Steps 0..15 = Outer Perimeter (Counter-Clockwise)
  // Steps 16..23 = Inner Track / "Pani" (Clockwise)
  // Step 24 = Center Swarga
  static const List<List<BoardCoord>> playerPaths = [
    // Kingdom 0: South (Red - Starts [4, 2])
    [
      BoardCoord(4, 2), BoardCoord(4, 3), BoardCoord(4, 4), BoardCoord(3, 4),
      BoardCoord(2, 4), BoardCoord(1, 4), BoardCoord(0, 4), BoardCoord(0, 3),
      BoardCoord(0, 2), BoardCoord(0, 1), BoardCoord(0, 0), BoardCoord(1, 0),
      BoardCoord(2, 0), BoardCoord(3, 0), BoardCoord(4, 0), BoardCoord(4, 1),
      // Inner Pani stream
      BoardCoord(3, 1), BoardCoord(2, 1), BoardCoord(1, 1), BoardCoord(1, 2),
      BoardCoord(1, 3), BoardCoord(2, 3), BoardCoord(3, 3), BoardCoord(3, 2),
      // Center Home
      BoardCoord(2, 2),
    ],

    // Kingdom 1: West (Green - Starts [2, 0])
    [
      BoardCoord(2, 0), BoardCoord(3, 0), BoardCoord(4, 0), BoardCoord(4, 1),
      BoardCoord(4, 2), BoardCoord(4, 3), BoardCoord(4, 4), BoardCoord(3, 4),
      BoardCoord(2, 4), BoardCoord(1, 4), BoardCoord(0, 4), BoardCoord(0, 3),
      BoardCoord(0, 2), BoardCoord(0, 1), BoardCoord(0, 0), BoardCoord(1, 0),
      // Inner Pani stream
      BoardCoord(1, 1), BoardCoord(1, 2), BoardCoord(1, 3), BoardCoord(2, 3),
      BoardCoord(3, 3), BoardCoord(3, 2), BoardCoord(3, 1), BoardCoord(2, 1),
      // Center Home
      BoardCoord(2, 2),
    ],

    // Kingdom 2: North (Orange/Yellow - Starts [0, 2])
    [
      BoardCoord(0, 2), BoardCoord(0, 1), BoardCoord(0, 0), BoardCoord(1, 0),
      BoardCoord(2, 0), BoardCoord(3, 0), BoardCoord(4, 0), BoardCoord(4, 1),
      BoardCoord(4, 2), BoardCoord(4, 3), BoardCoord(4, 4), BoardCoord(3, 4),
      BoardCoord(2, 4), BoardCoord(1, 4), BoardCoord(0, 4), BoardCoord(0, 3),
      // Inner Pani stream
      BoardCoord(1, 3), BoardCoord(2, 3), BoardCoord(3, 3), BoardCoord(3, 2),
      BoardCoord(3, 1), BoardCoord(2, 1), BoardCoord(1, 1), BoardCoord(1, 2),
      // Center Home
      BoardCoord(2, 2),
    ],

    // Kingdom 3: East (Blue - Starts [2, 4])
    [
      BoardCoord(2, 4), BoardCoord(1, 4), BoardCoord(0, 4), BoardCoord(0, 3),
      BoardCoord(0, 2), BoardCoord(0, 1), BoardCoord(0, 0), BoardCoord(1, 0),
      BoardCoord(2, 0), BoardCoord(3, 0), BoardCoord(4, 0), BoardCoord(4, 1),
      BoardCoord(4, 2), BoardCoord(4, 3), BoardCoord(4, 4), BoardCoord(3, 4),
      // Inner Pani stream
      BoardCoord(3, 3), BoardCoord(3, 2), BoardCoord(3, 1), BoardCoord(2, 1),
      BoardCoord(1, 1), BoardCoord(1, 2), BoardCoord(1, 3), BoardCoord(2, 3),
      // Center Home
      BoardCoord(2, 2),
    ],
  ];

  static List<Player> createDefaultPlayers() {
    return [
      Player(
        id: 0,
        pathIndex: 0,
        name: "White Stones (South)",
        hindiName: "सफेद कंकड़ (दक्षिण)",
        marathiName: "पांढरे खडे (दक्षिण)",
        color: const Color(0xFFE63946),
        colorLight: const Color(0xFFFF6B6B),
        colorDark: const Color(0xFF9D0208),
        avatar: "⚪",
        side: "South",
        tokenType: DiceType.whiteStone,
        isAI: false,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
      Player(
        id: 1,
        pathIndex: 1,
        name: "Black Stones (West)",
        hindiName: "काले कंकड़ (पश्चिम)",
        marathiName: "काळे खडे (पश्चिम)",
        color: const Color(0xFF2A9D8F),
        colorLight: const Color(0xFF48CAE4),
        colorDark: const Color(0xFF1B4332),
        avatar: "⚫",
        side: "West",
        tokenType: DiceType.blackStone,
        isAI: true,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
      Player(
        id: 2,
        pathIndex: 2,
        name: "Sticks (North)",
        hindiName: "तीलियाँ (उत्तर)",
        marathiName: "काठ्या (उत्तर)",
        color: const Color(0xFFE76F51),
        colorLight: const Color(0xFFF4A261),
        colorDark: const Color(0xFFBC4749),
        avatar: "🪵",
        side: "North",
        tokenType: DiceType.sticks,
        isAI: true,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
      Player(
        id: 3,
        pathIndex: 3,
        name: "Tamarind Seeds (East)",
        hindiName: "चिंचोके (पूर्व)",
        marathiName: "चिंचोके (पूर्व)",
        color: const Color(0xFF3A86FF),
        colorLight: const Color(0xFF00B4D8),
        colorDark: const Color(0xFF03045E),
        avatar: "🌰",
        side: "East",
        tokenType: DiceType.tamarindSeeds,
        isAI: true,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
    ];
  }

  static List<Player> createGamePlayers(int playerCount, {bool vsAI = true}) {
    final all = createDefaultPlayers();
    if (playerCount == 2) {
      // 2 Players: South vs North (Symmetric opponent across the board)
      final south = all[0];
      final north = all[2];
      return [
        Player(
          id: 0,
          pathIndex: 0,
          name: south.name,
          hindiName: south.hindiName,
          marathiName: south.marathiName,
          color: south.color,
          colorLight: south.colorLight,
          colorDark: south.colorDark,
          avatar: south.avatar,
          side: south.side,
          tokenType: south.tokenType,
          isAI: false,
          pawns: List.generate(4, (i) => Pawn(id: i)),
        ),
        Player(
          id: 1,
          pathIndex: 2, // North path (row 0, col 2)
          name: north.name,
          hindiName: north.hindiName,
          marathiName: north.marathiName,
          color: north.color,
          colorLight: north.colorLight,
          colorDark: north.colorDark,
          avatar: north.avatar,
          side: north.side,
          tokenType: north.tokenType,
          isAI: vsAI,
          pawns: List.generate(4, (i) => Pawn(id: i)),
        ),
      ];
    } else if (playerCount == 3) {
      // 3 Players: South, West, North
      return [
        all[0],
        Player(
          id: 1,
          pathIndex: 1,
          name: all[1].name,
          hindiName: all[1].hindiName,
          marathiName: all[1].marathiName,
          color: all[1].color,
          colorLight: all[1].colorLight,
          colorDark: all[1].colorDark,
          avatar: all[1].avatar,
          side: all[1].side,
          tokenType: all[1].tokenType,
          isAI: vsAI,
          pawns: List.generate(4, (i) => Pawn(id: i)),
        ),
        Player(
          id: 2,
          pathIndex: 2,
          name: all[2].name,
          hindiName: all[2].hindiName,
          marathiName: all[2].marathiName,
          color: all[2].color,
          colorLight: all[2].colorLight,
          colorDark: all[2].colorDark,
          avatar: all[2].avatar,
          side: all[2].side,
          tokenType: all[2].tokenType,
          isAI: vsAI,
          pawns: List.generate(4, (i) => Pawn(id: i)),
        ),
      ];
    } else {
      // 4 Players: South, West, North, East
      return List.generate(4, (i) {
        final p = all[i];
        return Player(
          id: i,
          pathIndex: i,
          name: p.name,
          hindiName: p.hindiName,
          marathiName: p.marathiName,
          color: p.color,
          colorLight: p.colorLight,
          colorDark: p.colorDark,
          avatar: p.avatar,
          side: p.side,
          tokenType: p.tokenType,
          isAI: i == 0 ? false : vsAI,
          pawns: List.generate(4, (j) => Pawn(id: j)),
        );
      });
    }
  }
}

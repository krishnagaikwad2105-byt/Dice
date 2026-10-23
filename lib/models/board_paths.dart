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

  // 25-step paths for each of the 4 players:
  // Steps 0..15 = Outer Perimeter (Counter-Clockwise)
  // Steps 16..23 = Inner Track / "Pani" (Clockwise)
  // Step 24 = Center Swarga
  static const List<List<BoardCoord>> playerPaths = [
    // Player 0: South (Red - Starts [4, 2])
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

    // Player 1: West (Green - Starts [2, 0])
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

    // Player 2: North (Yellow - Starts [0, 2])
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

    // Player 3: East (Blue - Starts [2, 4])
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

  static List<Player> createDefaultPlayers({bool singlePlayer = true}) {
    return [
      Player(
        id: 0,
        name: "White Stones (पांढरे खडे)",
        marathiName: "पांढरे खडे",
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
        name: "Black Stones (काळे खडे)",
        marathiName: "काळे खडे",
        color: const Color(0xFF2A9D8F),
        colorLight: const Color(0xFF48CAE4),
        colorDark: const Color(0xFF1B4332),
        avatar: "⚫",
        side: "West",
        tokenType: DiceType.blackStone,
        isAI: singlePlayer,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
      Player(
        id: 2,
        name: "Sticks (काठ्या)",
        marathiName: "काठ्या",
        color: const Color(0xFFE76F51),
        colorLight: const Color(0xFFF4A261),
        colorDark: const Color(0xFFBC4749),
        avatar: "🪵",
        side: "North",
        tokenType: DiceType.sticks,
        isAI: singlePlayer,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
      Player(
        id: 3,
        name: "Tamarind Seeds (चिंचोके)",
        marathiName: "चिंचोके",
        color: const Color(0xFF3A86FF),
        colorLight: const Color(0xFF00B4D8),
        colorDark: const Color(0xFF03045E),
        avatar: "🌰",
        side: "East",
        tokenType: DiceType.tamarindSeeds,
        isAI: singlePlayer,
        pawns: List.generate(4, (i) => Pawn(id: i)),
      ),
    ];
  }
}

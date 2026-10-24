import 'package:flutter_test/flutter_test.dart';
import 'package:champal_pani/models/board_paths.dart';

void main() {
  group('BoardPaths Unit Tests', () {
    test('BoardCoord equality and hashCode', () {
      const c1 = BoardCoord(2, 2);
      const c2 = BoardCoord(2, 2);
      const c3 = BoardCoord(4, 2);

      expect(c1, equals(c2));
      expect(c1.hashCode, equals(c2.hashCode));
      expect(c1, isNot(equals(c3)));
      expect(c1.toString(), equals('(2, 2)'));
    });

    test('Safe squares contain the 5 sacred sanctuaries', () {
      expect(BoardPaths.safeSquares.length, equals(5));

      // 4 starting sanctuaries
      expect(BoardPaths.isSafe(const BoardCoord(4, 2)), isTrue); // South
      expect(BoardPaths.isSafe(const BoardCoord(2, 0)), isTrue); // West
      expect(BoardPaths.isSafe(const BoardCoord(0, 2)), isTrue); // North
      expect(BoardPaths.isSafe(const BoardCoord(2, 4)), isTrue); // East

      // Center Swarga
      expect(BoardPaths.isSafe(const BoardCoord(2, 2)), isTrue);

      // Unsafe squares
      expect(BoardPaths.isSafe(const BoardCoord(0, 0)), isFalse);
      expect(BoardPaths.isSafe(const BoardCoord(1, 1)), isFalse);
      expect(BoardPaths.isSafe(const BoardCoord(3, 3)), isFalse);
      expect(BoardPaths.isSafe(const BoardCoord(4, 4)), isFalse);
    });

    test('All 4 kingdoms have exactly 25-step paths terminating in Swarga', () {
      expect(BoardPaths.playerPaths.length, equals(4));

      for (int i = 0; i < 4; i++) {
        final path = BoardPaths.playerPaths[i];
        expect(path.length, equals(25), reason: 'Kingdom $i should have 25 steps');

        // Center Swarga is always step 24
        expect(path[24], equals(const BoardCoord(2, 2)),
            reason: 'Kingdom $i step 24 must be Center Swarga (2, 2)');

        // Outer ring steps 0..15 should all be perimeter squares
        for (int step = 0; step < 16; step++) {
          final coord = path[step];
          final isPerimeter = (coord.row == 0 || coord.row == 4 || coord.col == 0 || coord.col == 4);
          expect(isPerimeter, isTrue,
              reason: 'Kingdom $i step $step ($coord) should be on perimeter');
        }

        // Inner Pani steps 16..23 should all be within inner 3x3 ring
        for (int step = 16; step < 24; step++) {
          final coord = path[step];
          final isInnerRing = (coord.row >= 1 && coord.row <= 3 && coord.col >= 1 && coord.col <= 3);
          expect(isInnerRing, isTrue,
              reason: 'Kingdom $i step $step ($coord) should be in inner ring');
          expect(coord, isNot(equals(const BoardCoord(2, 2))),
              reason: 'Inner ring steps 16..23 should not be Swarga');
        }
      }
    });

    test('Kingdom starting positions are correct', () {
      expect(BoardPaths.playerPaths[0][0], equals(const BoardCoord(4, 2))); // South
      expect(BoardPaths.playerPaths[1][0], equals(const BoardCoord(2, 0))); // West
      expect(BoardPaths.playerPaths[2][0], equals(const BoardCoord(0, 2))); // North
      expect(BoardPaths.playerPaths[3][0], equals(const BoardCoord(2, 4))); // East
    });

    test('2-player game correctly sets up South vs North (Bug 1 regression check)', () {
      final players = BoardPaths.createGamePlayers(2, vsAI: true);

      expect(players.length, equals(2));
      // Player 0 is South (pathIndex 0)
      expect(players[0].side, equals('South'));
      expect(players[0].pathIndex, equals(0));
      expect(players[0].isAI, isFalse);

      // Player 1 is North (pathIndex 2)
      expect(players[1].side, equals('North'));
      expect(players[1].pathIndex, equals(2));
      expect(players[1].isAI, isTrue);

      // Verify pawns start at starting sanctuaries
      final p0Start = BoardPaths.playerPaths[players[0].pathIndex][0];
      final p1Start = BoardPaths.playerPaths[players[1].pathIndex][0];
      expect(p0Start, equals(const BoardCoord(4, 2)));
      expect(p1Start, equals(const BoardCoord(0, 2)));
    });

    test('3-player and 4-player game creations', () {
      final players3 = BoardPaths.createGamePlayers(3, vsAI: true);
      expect(players3.length, equals(3));
      expect(players3[0].pathIndex, equals(0)); // South
      expect(players3[1].pathIndex, equals(1)); // West
      expect(players3[2].pathIndex, equals(2)); // North

      final players4 = BoardPaths.createGamePlayers(4, vsAI: false);
      expect(players4.length, equals(4));
      expect(players4.every((p) => !p.isAI), isTrue);
      expect(players4[3].pathIndex, equals(3)); // East
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:champal_pani/logic/game_controller.dart';
import 'package:champal_pani/models/board_paths.dart';
import 'package:champal_pani/models/dice_type.dart';
import 'package:champal_pani/theme/game_theme.dart';
import 'package:champal_pani/i18n/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameController Business Logic & Rules Unit Tests', () {
    late GameController controller;

    setUp(() {
      controller = GameController(initialPlayers: 4, vsAI: false);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial game state defaults', () {
      expect(controller.numPlayers, equals(4));
      expect(controller.isVsAI, isFalse);
      expect(controller.currentPlayerIdx, equals(0));
      expect(controller.winner, isNull);
      expect(controller.currentRoll, isNull);
      expect(controller.isRolling, isFalse);
      expect(controller.isMovingPawn, isFalse);
      expect(controller.waitingForPawnChoice, isFalse);
      expect(controller.players.length, equals(4));
      expect(controller.theme.id, equals(GameThemeId.cleanMinimal)); // Default clean minimal
    });

    test('Pawn calculation: outer ring without Pani loops within 0..15', () {
      final player = controller.players[0];
      expect(player.hasPani, isFalse);

      // Current step 0, roll 4 -> step 4
      expect(controller.calculateTargetStep(player, 0, 4), equals(4));

      // Current step 12, roll 4 -> step (12+4) % 16 = 0 (loops back to base!)
      expect(controller.calculateTargetStep(player, 12, 4), equals(0));

      // Current step 14, roll 4 -> step (14+4) % 16 = 2
      expect(controller.calculateTargetStep(player, 14, 4), equals(2));

      // Current step 15, roll 8 -> step (15+8) % 16 = 7
      expect(controller.calculateTargetStep(player, 15, 8), equals(7));
    });

    test('Pawn calculation: outer ring with Pani advances into inner track (16..23)', () {
      final player = controller.players[0];
      player.hasPani = true;

      // Current step 12, roll 4 -> 16 (enters inner track!)
      expect(controller.calculateTargetStep(player, 12, 4), equals(16));

      // Current step 14, roll 4 -> 18
      expect(controller.calculateTargetStep(player, 14, 4), equals(18));

      // Current step 15, roll 8 -> 23
      expect(controller.calculateTargetStep(player, 15, 8), equals(23));
    });

    test('Pawn calculation: inner track requires exact roll to enter Swarga (24)', () {
      final player = controller.players[0];
      player.hasPani = true;

      // At step 20:
      // Roll 4 lands exactly on Swarga (20 + 4 = 24)
      expect(controller.calculateTargetStep(player, 20, 4), equals(24));
      // Roll 3 advances to 23
      expect(controller.calculateTargetStep(player, 20, 3), equals(23));
      // Roll 8 overshoots (20 + 8 = 28 > 24) -> returns null!
      expect(controller.calculateTargetStep(player, 20, 8), isNull);

      // At step 23:
      // Roll 1 lands in Swarga
      expect(controller.calculateTargetStep(player, 23, 1), equals(24));
      // Roll 2 overshoots -> returns null
      expect(controller.calculateTargetStep(player, 23, 2), isNull);
      // Roll 4 overshoots -> returns null
      expect(controller.calculateTargetStep(player, 23, 4), isNull);
      // Roll 8 overshoots -> returns null
      expect(controller.calculateTargetStep(player, 23, 8), isNull);
    });

    test('Pawn already home cannot move', () {
      final player = controller.players[0];
      player.hasPani = true;
      player.pawns[0].isHome = true;
      player.pawns[0].stepIndex = 24;

      expect(controller.calculateTargetStep(player, 24, 1), isNull);
      expect(controller.calculateTargetStep(player, 24, 4), isNull);
    });

    test('getValidPawnsForRoll filters out overshooting pawns and home pawns', () {
      final player = controller.players[0];
      player.hasPani = true;

      player.pawns[0].stepIndex = 23; // Only roll 1 works
      player.pawns[1].isHome = true;   // Already home
      player.pawns[2].stepIndex = 0;   // In outer ring
      player.pawns[3].stepIndex = 0;   // In outer ring

      // Roll 4: pawns 2 and 3 can move (0+4=4). Pawn 0 overshoots (23+4=27). Pawn 1 is home.
      final validFor4 = controller.getValidPawnsForRoll(0, 4);
      expect(validFor4, equals([2, 3]));

      // Roll 1: pawns 0, 2, 3 can all move!
      final validFor1 = controller.getValidPawnsForRoll(0, 1);
      expect(validFor1, equals([0, 2, 3]));
    });

    test('Capturing enemy pawn on unsafe square resets enemy to base and unlocks Pani', () async {
      // Place Player 1's pawn at coordinate BoardCoord(4, 3) (step 1 for Player 0)
      // For Player 0, step 1 is BoardCoord(4, 3), which is NOT safe.
      final player0 = controller.players[0];
      final player1 = controller.players[1];

      // Find Player 1's stepIndex for BoardCoord(4, 3)
      final p1Path = BoardPaths.playerPaths[player1.pathIndex];
      final p1Step = p1Path.indexWhere((coord) => coord == const BoardCoord(4, 3));
      expect(p1Step, isNot(-1));

      player1.pawns[0].stepIndex = p1Step;
      expect(player0.hasPani, isFalse);
      expect(player0.kills, equals(0));

      // Simulate Player 0 rolling 1
      controller.currentRoll = 1;
      controller.waitingForPawnChoice = true;
      controller.validPawnIndices = [0];

      await controller.movePawn(0);

      // Player 0 moved to step 1 (BoardCoord(4, 3))
      expect(player0.pawns[0].stepIndex, equals(1));
      // Player 1's pawn should have been captured and returned to stepIndex 0
      expect(player1.pawns[0].stepIndex, equals(0));
      // Player 0 earned a kill and unlocked PANI!
      expect(player0.kills, equals(1));
      expect(player0.hasPani, isTrue);
    });

    test('Safe sanctuary squares prevent pawn captures', () async {
      final player0 = controller.players[0];
      final player1 = controller.players[1];

      // West Home is BoardCoord(2, 0). For Player 0, this is step 12.
      // BoardCoord(2, 0) IS a safe square!
      expect(BoardPaths.isSafe(const BoardCoord(2, 0)), isTrue);

      player0.pawns[0].stepIndex = 11; // 1 step away from step 12
      player1.pawns[0].stepIndex = 0;  // Player 1's start is BoardCoord(2, 0)

      controller.currentRoll = 1;
      controller.waitingForPawnChoice = true;
      controller.validPawnIndices = [0];

      await controller.movePawn(0);

      // Player 0 pawn is at step 12 (BoardCoord(2, 0))
      expect(player0.pawns[0].stepIndex, equals(12));
      // Player 1 pawn on the safe square is NOT captured!
      expect(player1.pawns[0].stepIndex, equals(0));
      expect(player0.kills, equals(0));
      expect(player0.hasPani, isFalse);
    });

    test('Multiple enemy pawns on the same unsafe cell are all captured (Bug 2 regression check)', () async {
      final player0 = controller.players[0];
      final player1 = controller.players[1];

      // Set TWO pawns of Player 1 on BoardCoord(4, 3)
      final p1Path = BoardPaths.playerPaths[player1.pathIndex];
      final p1Step = p1Path.indexWhere((coord) => coord == const BoardCoord(4, 3));

      player1.pawns[0].stepIndex = p1Step;
      player1.pawns[1].stepIndex = p1Step;

      controller.currentRoll = 1;
      controller.waitingForPawnChoice = true;
      controller.validPawnIndices = [0];

      await controller.movePawn(0);

      // Both pawns of Player 1 must be sent back to base!
      expect(player1.pawns[0].stepIndex, equals(0));
      expect(player1.pawns[1].stepIndex, equals(0));
      expect(player0.kills, equals(2));
      expect(player0.hasPani, isTrue);
    });

    test('Winning condition: player is winner when all 4 pawns reach Swarga', () async {
      final player0 = controller.players[0];
      player0.hasPani = true;

      // Set 3 pawns already home
      player0.pawns[0].isHome = true;
      player0.pawns[0].stepIndex = 24;
      player0.pawns[1].isHome = true;
      player0.pawns[1].stepIndex = 24;
      player0.pawns[2].isHome = true;
      player0.pawns[2].stepIndex = 24;

      // 4th pawn is at step 23
      player0.pawns[3].stepIndex = 23;

      controller.currentRoll = 1;
      controller.waitingForPawnChoice = true;
      controller.validPawnIndices = [3];

      await controller.movePawn(3);

      expect(player0.pawns[3].isHome, isTrue);
      expect(player0.isWinner, isTrue);
      expect(controller.winner, equals(player0));
    });

    test('Theme and DiceType switches update state correctly', () {
      controller.setThemeId(GameThemeId.royalRajwada);
      expect(controller.theme.id, equals(GameThemeId.royalRajwada));

      controller.setDiceType(DiceType.cowrieShells);
      expect(controller.diceType, equals(DiceType.cowrieShells));
    });

    test('Structured log localization produces correct output in English, Hindi, and Marathi', () {
      const entry = GameLogEntry(
        key: 'logNewGame',
        params: {'count': '4'},
      );

      expect(entry.getLocalized(AppLanguage.english), equals('🎉 New game started with 4 players!'));
      expect(entry.getLocalized(AppLanguage.hindi), equals('🎉 4 खिलाड़ियों के साथ नया खेल शुरू हुआ!'));
      expect(entry.getLocalized(AppLanguage.marathi), equals('🎉 4 खेळाडूंसह नवीन खेळ सुरू झाला!'));
    });
  });
}

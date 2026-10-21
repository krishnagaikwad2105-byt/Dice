import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/board_paths.dart';
import '../models/player.dart';

class GameController extends ChangeNotifier {
  int numPlayers = 4;
  List<Player> players = [];
  int currentPlayerIdx = 0;

  int? currentRoll;
  List<int> shells = [1, 0, 1, 0]; // 0=closed (flat), 1=open (mouth up)
  bool isRolling = false;
  bool isMovingPawn = false;
  bool waitingForPawnChoice = false;
  List<int> validPawnIndices = [];
  Player? winner;
  List<String> logs = [];

  final Random _random = Random();

  GameController() {
    startNewGame();
  }

  Player get currentPlayer => players[currentPlayerIdx];

  void startNewGame({int playerCount = 4, bool vsAI = true}) {
    numPlayers = playerCount;
    final defaultPlayers = BoardPaths.createDefaultPlayers(singlePlayer: vsAI);
    players = defaultPlayers.sublist(0, numPlayers);

    currentPlayerIdx = 0;
    currentRoll = null;
    shells = [1, 0, 1, 0];
    isRolling = false;
    isMovingPawn = false;
    waitingForPawnChoice = false;
    validPawnIndices = [];
    winner = null;
    logs = ["🎉 New Game began with $numPlayers players!"];

    notifyListeners();
    _checkAITurn();
  }

  /// Roll the 4 Cowrie Shells
  Future<void> rollCowries() async {
    if (isRolling || isMovingPawn || waitingForPawnChoice || winner != null) {
      return;
    }

    isRolling = true;
    notifyListeners();

    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    // Shell toss simulation
    await Future.delayed(const Duration(milliseconds: 700));

    // 4 Cowrie shells: each has 50% probability
    shells = List.generate(4, (_) => _random.nextBool() ? 1 : 0);
    final openCount = shells.fold<int>(0, (sum, s) => sum + s);

    // 0 open = 8 (Champool / Aath), 1=1, 2=2, 3=3, 4=4
    final rollValue = openCount == 0 ? 8 : openCount;
    currentRoll = rollValue;
    isRolling = false;

    final isBonus = (rollValue == 4 || rollValue == 8);
    final rollDesc = rollValue == 8 ? "8 (चंपाळ / Champool!)" : "$rollValue";
    addLog("${currentPlayer.avatar} ${currentPlayer.name} rolled $rollDesc${isBonus ? ' 🌟 Bonus Roll!' : ''}");

    if (isBonus) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }

    validPawnIndices = getValidPawnsForRoll(currentPlayerIdx, rollValue);

    if (validPawnIndices.isEmpty) {
      addLog("❌ No valid moves for ${currentPlayer.name} with roll $rollValue.");
      currentRoll = null;
      notifyListeners();
      _nextTurn(advancePlayer: !isBonus);
      return;
    }

    waitingForPawnChoice = true;
    notifyListeners();

    if (currentPlayer.isAI) {
      Future.delayed(const Duration(milliseconds: 700), () {
        _makeAIDecision();
      });
    }
  }

  List<int> getValidPawnsForRoll(int playerIdx, int roll) {
    final player = players[playerIdx];
    final valid = <int>[];

    for (int i = 0; i < player.pawns.length; i++) {
      final pawn = player.pawns[i];
      if (pawn.isHome) continue;

      final targetStep = calculateTargetStep(player, pawn.stepIndex, roll);
      if (targetStep != null) {
        valid.add(i);
      }
    }
    return valid;
  }

  int? calculateTargetStep(Player player, int currentStep, int roll) {
    if (currentStep >= 24) return null;

    if (currentStep >= 16) {
      final target = currentStep + roll;
      if (target == 24) return 24; // Lands in Swarga (Center Home)
      if (target < 24) return target;
      return null; // Overshoots
    }

    // Outer ring (0..15)
    if (player.hasPani) {
      // Unlocked inner track
      final target = currentStep + roll;
      if (target > 24) return null;
      return target;
    } else {
      // Must stay in outer ring
      return (currentStep + roll) % 16;
    }
  }

  /// Move selected pawn
  Future<void> movePawn(int pawnIndex) async {
    if (!waitingForPawnChoice || isMovingPawn) return;
    if (!validPawnIndices.contains(pawnIndex)) return;

    waitingForPawnChoice = false;
    isMovingPawn = true;
    notifyListeners();

    final player = currentPlayer;
    final pawn = player.pawns[pawnIndex];
    final roll = currentRoll!;
    final targetStep = calculateTargetStep(player, pawn.stepIndex, roll)!;

    // Smooth step-by-step hopping
    int cur = pawn.stepIndex;
    for (int i = 1; i <= roll; i++) {
      if (player.hasPani) {
        cur++;
      } else {
        cur = (cur < 16) ? (cur + 1) % 16 : cur + 1;
      }
      pawn.stepIndex = cur;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 160));
    }

    pawn.stepIndex = targetStep;
    final finalCoord = BoardPaths.playerPaths[currentPlayerIdx][targetStep];

    bool reachedHome = false;
    if (targetStep == 24) {
      pawn.isHome = true;
      reachedHome = true;
      addLog("🏆 ${player.avatar} ${player.name}'s pawn reached Center Home (Swarga)!");
    }

    bool captured = false;
    if (!BoardPaths.isSafe(finalCoord) && !pawn.isHome) {
      captured = _checkCapture(finalCoord, currentPlayerIdx);
    }

    // Check game winning condition
    if (player.isWinner) {
      winner = player;
      isMovingPawn = false;
      currentRoll = null;
      addLog("👑🎊 ${player.name} HAS WON THE GAME! 🎊👑");
      notifyListeners();
      return;
    }

    final rolledBonus = (roll == 4 || roll == 8);
    final getsBonusTurn = rolledBonus || captured || reachedHome;

    isMovingPawn = false;
    currentRoll = null;
    notifyListeners();

    if (getsBonusTurn) {
      addLog("✨ ${player.name} earns an Extra Roll!");
      _checkAITurn();
    } else {
      _nextTurn(advancePlayer: true);
    }
  }

  bool _checkCapture(BoardCoord coord, int activePlayerIdx) {
    bool capturedAny = false;
    final activePlayer = players[activePlayerIdx];

    for (int pIdx = 0; pIdx < players.length; pIdx++) {
      if (pIdx == activePlayerIdx) continue;
      final otherPlayer = players[pIdx];

      for (final enemyPawn in otherPlayer.pawns) {
        if (enemyPawn.isHome) continue;
        final enemyCoord = BoardPaths.playerPaths[pIdx][enemyPawn.stepIndex];

        if (enemyCoord == coord) {
          enemyPawn.stepIndex = 0; // Return to starting sanctuary
          capturedAny = true;
          activePlayer.kills++;

          try {
            HapticFeedback.heavyImpact();
          } catch (_) {}

          addLog("⚔️ ${activePlayer.name} captured ${otherPlayer.name}'s pawn! Sent back to base!");

          if (!activePlayer.hasPani) {
            activePlayer.hasPani = true;
            addLog("🌊 ${activePlayer.avatar} ${activePlayer.name} unlocked PANI (पाण्यात जाणे)! Eligible for inner track!");
          }
          break;
        }
      }
    }
    return capturedAny;
  }

  void _nextTurn({bool advancePlayer = true}) {
    if (advancePlayer) {
      currentPlayerIdx = (currentPlayerIdx + 1) % numPlayers;
    }
    currentRoll = null;
    validPawnIndices = [];
    waitingForPawnChoice = false;
    isRolling = false;
    isMovingPawn = false;
    notifyListeners();

    _checkAITurn();
  }

  void _checkAITurn() {
    if (winner != null) return;
    if (currentPlayer.isAI && !isRolling && !isMovingPawn && !waitingForPawnChoice) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (winner == null && currentPlayer.isAI) {
          rollCowries();
        }
      });
    }
  }

  void _makeAIDecision() {
    if (!waitingForPawnChoice || validPawnIndices.isEmpty) return;

    final player = currentPlayer;
    int bestPawnIdx = validPawnIndices.first;
    double highestScore = -999999;

    for (final pIdx in validPawnIndices) {
      final pawn = player.pawns[pIdx];
      final targetStep = calculateTargetStep(player, pawn.stepIndex, currentRoll!)!;
      final targetCoord = BoardPaths.playerPaths[currentPlayerIdx][targetStep];

      double score = 0;

      // 1. Reaching Swarga
      if (targetStep == 24) score += 2000;

      // 2. Capturing enemy pawn
      if (!BoardPaths.isSafe(targetCoord) && targetStep < 24) {
        if (_wouldCapture(targetCoord, currentPlayerIdx)) {
          score += player.hasPani ? 800 : 1500;
        }
      }

      // 3. Advancing into inner Pani
      if (player.hasPani && pawn.stepIndex < 16 && targetStep >= 16) {
        score += 350;
      }

      // 4. Safe square
      if (BoardPaths.isSafe(targetCoord)) score += 180;

      // 5. Progress
      score += (targetStep - pawn.stepIndex) * 15;
      score += _random.nextDouble() * 20;

      if (score > highestScore) {
        highestScore = score;
        bestPawnIdx = pIdx;
      }
    }

    movePawn(bestPawnIdx);
  }

  bool _wouldCapture(BoardCoord coord, int playerIdx) {
    for (int i = 0; i < players.length; i++) {
      if (i == playerIdx) continue;
      for (final p in players[i].pawns) {
        if (p.isHome) continue;
        final enemyCoord = BoardPaths.playerPaths[i][p.stepIndex];
        if (enemyCoord == coord) return true;
      }
    }
    return false;
  }

  void addLog(String message) {
    logs.insert(0, message);
    if (logs.length > 30) logs.removeLast();
    notifyListeners();
  }
}

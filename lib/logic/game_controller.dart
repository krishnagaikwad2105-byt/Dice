import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/board_paths.dart';
import '../models/player.dart';
import '../models/dice_type.dart';
import '../theme/game_theme.dart';
import '../i18n/localization_service.dart';
import '../i18n/app_strings.dart';

class GameLogEntry {
  final String key;
  final Map<String, String> params;
  final String rawText;

  const GameLogEntry({
    required this.key,
    this.params = const {},
    this.rawText = '',
  });

  String getLocalized(AppLanguage lang) {
    if (key.isNotEmpty) {
      return AppStrings.get(lang, key, params);
    }
    return rawText;
  }
}

class GameController extends ChangeNotifier {
  int numPlayers = 4;
  bool isVsAI = true;
  List<Player> players = [];
  int currentPlayerIdx = 0;
  DiceType diceType = DiceType.whiteStone;
  GameTheme theme = GameTheme.cleanMinimal; // Default is Clean Minimal

  int? currentRoll;
  List<int> shells = [1, 0, 1, 0]; // 0=closed (flat), 1=open (mouth/marked up)
  bool isRolling = false;
  bool isMovingPawn = false;
  bool waitingForPawnChoice = false;
  List<int> validPawnIndices = [];
  Player? winner;
  List<GameLogEntry> logs = [];

  final Random _random = Random();
  bool _disposed = false;
  int _gameSessionId = 0;

  GameController({int initialPlayers = 4, bool vsAI = true}) {
    startNewGame(playerCount: initialPlayers, vsAI: vsAI);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void setDiceType(DiceType type) {
    diceType = type;
    notifyListeners();
  }

  void setTheme(GameTheme newTheme) {
    theme = newTheme;
    notifyListeners();
  }

  void setThemeId(GameThemeId id) {
    theme = GameTheme.getById(id);
    notifyListeners();
  }

  Player get currentPlayer => players[currentPlayerIdx];

  void startNewGame({int playerCount = 4, bool vsAI = true}) {
    _gameSessionId++;
    numPlayers = playerCount;
    isVsAI = vsAI;

    // Use BoardPaths.createGamePlayers to ensure proper symmetric paths
    players = BoardPaths.createGamePlayers(numPlayers, vsAI: isVsAI);

    currentPlayerIdx = 0;
    currentRoll = null;
    shells = [1, 0, 1, 0];
    isRolling = false;
    isMovingPawn = false;
    waitingForPawnChoice = false;
    validPawnIndices = [];
    winner = null;

    logs = [
      GameLogEntry(
        key: 'logNewGame',
        params: {'count': '$numPlayers'},
      ),
    ];

    notifyListeners();
    _checkAITurn();
  }

  /// Roll the 4 Cowrie Shells / Traditional Dice
  Future<void> rollCowries() async {
    if (_disposed || isRolling || isMovingPawn || waitingForPawnChoice || winner != null) {
      return;
    }

    final currentSession = _gameSessionId;
    isRolling = true;
    notifyListeners();

    try {
      HapticFeedback.lightImpact();
    } catch (_) {}

    // Shell toss simulation delay
    await Future.delayed(const Duration(milliseconds: 650));
    if (_disposed || currentSession != _gameSessionId || winner != null) return;

    // 4 Cowrie shells: each has 50% probability
    shells = List.generate(4, (_) => _random.nextBool() ? 1 : 0);
    final openCount = shells.fold<int>(0, (sum, s) => sum + s);

    // 0 open = 8 (Champool / Aath), 1=1, 2=2, 3=3, 4=4
    final rollValue = openCount == 0 ? 8 : openCount;
    currentRoll = rollValue;
    isRolling = false;

    final isBonus = (rollValue == 4 || rollValue == 8);
    final rollDesc = rollValue == 8 ? "8 (चंपाळ / Champal!)" : "$rollValue";

    addStructuredLog('logRolled', {
      'player': "${currentPlayer.avatar} ${currentPlayer.name}",
      'roll': rollDesc,
      'bonus': isBonus ? ' 🌟' : '',
    });

    if (isBonus) {
      try {
        HapticFeedback.mediumImpact();
      } catch (_) {}
    }

    validPawnIndices = getValidPawnsForRoll(currentPlayerIdx, rollValue);

    if (validPawnIndices.isEmpty) {
      addStructuredLog('logNoMoves', {
        'player': currentPlayer.name,
        'roll': '$rollValue',
      });
      currentRoll = null;
      notifyListeners();
      _nextTurn(advancePlayer: !isBonus);
      return;
    }

    waitingForPawnChoice = true;
    notifyListeners();

    if (currentPlayer.isAI) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!_disposed && currentSession == _gameSessionId && winner == null) {
          _makeAIDecision();
        }
      });
    }
  }

  List<int> getValidPawnsForRoll(int playerIdx, int roll) {
    if (playerIdx < 0 || playerIdx >= players.length) return [];
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
    if (_disposed || !waitingForPawnChoice || isMovingPawn) return;
    if (!validPawnIndices.contains(pawnIndex)) return;

    final currentSession = _gameSessionId;
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
      await Future.delayed(const Duration(milliseconds: 140));
      if (_disposed || currentSession != _gameSessionId) return;
    }

    pawn.stepIndex = targetStep;
    final finalCoord = BoardPaths.playerPaths[player.pathIndex][targetStep];

    bool reachedHome = false;
    if (targetStep == 24) {
      pawn.isHome = true;
      reachedHome = true;
      addStructuredLog('logReachedSwarga', {
        'player': "${player.avatar} ${player.name}",
      });
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
      addStructuredLog('logWonGame', {
        'player': player.name,
      });
      notifyListeners();
      return;
    }

    final rolledBonus = (roll == 4 || roll == 8);
    final getsBonusTurn = rolledBonus || captured || reachedHome;

    isMovingPawn = false;
    currentRoll = null;
    notifyListeners();

    if (getsBonusTurn) {
      addStructuredLog('logEarnedExtraRoll', {
        'player': player.name,
      });
      _checkAITurn();
    } else {
      _nextTurn(advancePlayer: true);
    }
  }

  bool _checkCapture(BoardCoord coord, int activePlayerIdx) {
    if (BoardPaths.isSafe(coord)) return false;
    bool capturedAny = false;
    final activePlayer = players[activePlayerIdx];

    for (int pIdx = 0; pIdx < players.length; pIdx++) {
      if (pIdx == activePlayerIdx) continue;
      final otherPlayer = players[pIdx];

      // Fix: check all pawns on this unsafe square
      for (final enemyPawn in otherPlayer.pawns) {
        if (enemyPawn.isHome) continue;
        final enemyCoord = BoardPaths.playerPaths[otherPlayer.pathIndex][enemyPawn.stepIndex];

        if (enemyCoord == coord) {
          enemyPawn.stepIndex = 0; // Return to starting sanctuary
          capturedAny = true;
          activePlayer.kills++;

          try {
            HapticFeedback.heavyImpact();
          } catch (_) {}

          addStructuredLog('logCaptured', {
            'killer': activePlayer.name,
            'victim': otherPlayer.name,
          });

          if (!activePlayer.hasPani) {
            activePlayer.hasPani = true;
            addStructuredLog('logUnlockedPani', {
              'player': "${activePlayer.avatar} ${activePlayer.name}",
            });
          }
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
    if (_disposed || winner != null) return;
    final currentSession = _gameSessionId;

    if (currentPlayer.isAI && !isRolling && !isMovingPawn && !waitingForPawnChoice) {
      Future.delayed(const Duration(milliseconds: 750), () {
        if (!_disposed && currentSession == _gameSessionId && winner == null && currentPlayer.isAI) {
          rollCowries();
        }
      });
    }
  }

  void _makeAIDecision() {
    if (_disposed || !waitingForPawnChoice || validPawnIndices.isEmpty) return;

    final player = currentPlayer;
    int bestPawnIdx = validPawnIndices.first;
    double highestScore = -999999;

    for (final pIdx in validPawnIndices) {
      final pawn = player.pawns[pIdx];
      final targetStep = calculateTargetStep(player, pawn.stepIndex, currentRoll!)!;
      final targetCoord = BoardPaths.playerPaths[player.pathIndex][targetStep];

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
    if (BoardPaths.isSafe(coord)) return false;

    for (int i = 0; i < players.length; i++) {
      if (i == playerIdx) continue;
      final player = players[i];
      for (final p in player.pawns) {
        if (p.isHome) continue;
        final enemyCoord = BoardPaths.playerPaths[player.pathIndex][p.stepIndex];
        if (enemyCoord == coord) return true;
      }
    }
    return false;
  }

  void addStructuredLog(String key, Map<String, String> params) {
    logs.insert(0, GameLogEntry(key: key, params: params));
    if (logs.length > 40) logs.removeLast();
    notifyListeners();
  }

  void addLog(String message) {
    logs.insert(0, GameLogEntry(key: '', rawText: message));
    if (logs.length > 40) logs.removeLast();
    notifyListeners();
  }
}

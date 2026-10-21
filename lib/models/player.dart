import 'package:flutter/material.dart';
import 'pawn.dart';

/// Represents a player in Champal Pani
class Player {
  final int id;
  final String name;
  final String marathiName;
  final Color color;
  final Color colorLight;
  final Color colorDark;
  final String avatar;
  final String side;
  final bool isAI;

  bool hasPani; // Unlocked after capturing at least one enemy pawn
  int kills;
  final List<Pawn> pawns;

  Player({
    required this.id,
    required this.name,
    required this.marathiName,
    required this.color,
    required this.colorLight,
    required this.colorDark,
    required this.avatar,
    required this.side,
    this.isAI = false,
    this.hasPani = false,
    this.kills = 0,
    required this.pawns,
  });

  bool get isWinner => pawns.every((p) => p.isHome);

  int get homeCount => pawns.where((p) => p.isHome).length;
  int get baseCount => pawns.where((p) => !p.isHome && p.stepIndex == 0).length;
  int get fieldCount => pawns.where((p) => !p.isHome && p.stepIndex > 0).length;

  void reset() {
    hasPani = false;
    kills = 0;
    for (var p in pawns) {
      p.reset();
    }
  }
}

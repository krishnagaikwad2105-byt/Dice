import 'package:flutter/material.dart';
import '../i18n/localization_service.dart';
import 'pawn.dart';
import 'dice_type.dart';

/// Represents a player in Champal Pani
class Player {
  final int id;
  final int pathIndex; // 0=South, 1=West, 2=North, 3=East
  final String name;
  final String hindiName;
  final String marathiName;
  final Color color;
  final Color colorLight;
  final Color colorDark;
  final String avatar;
  final String side;
  final bool isAI;
  final DiceType tokenType;

  bool hasPani; // Unlocked after capturing at least one enemy pawn
  int kills;
  final List<Pawn> pawns;

  Player({
    required this.id,
    required this.pathIndex,
    required this.name,
    this.hindiName = '',
    required this.marathiName,
    required this.color,
    required this.colorLight,
    required this.colorDark,
    required this.avatar,
    required this.side,
    this.isAI = false,
    this.tokenType = DiceType.whiteStone,
    this.hasPani = false,
    this.kills = 0,
    required this.pawns,
  });

  String getDisplayName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return hindiName.isNotEmpty ? hindiName : name;
      case AppLanguage.marathi:
        return marathiName.isNotEmpty ? marathiName : name;
      case AppLanguage.english:
        return name;
    }
  }

  String getLocalizedSide(AppLanguage lang) {
    switch (side.toLowerCase()) {
      case 'south':
        return lang == AppLanguage.english ? 'South' : 'दक्षिण';
      case 'west':
        return lang == AppLanguage.english ? 'West' : 'पश्चिम';
      case 'north':
        return lang == AppLanguage.english ? 'North' : 'उत्तर';
      case 'east':
        return lang == AppLanguage.english ? 'East' : 'पूर्व';
      default:
        return side;
    }
  }

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

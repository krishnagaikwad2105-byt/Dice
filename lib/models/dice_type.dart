import '../i18n/localization_service.dart';

/// Types of traditional casting dice used in Maharashtrian board games
enum DiceType {
  whiteStone,
  blackStone,
  sticks,
  tamarindSeeds,
  cowrieShells,
}

extension DiceTypeExtension on DiceType {
  String get displayName {
    switch (this) {
      case DiceType.whiteStone:
        return "White Stones (पांढरे खडे)";
      case DiceType.blackStone:
        return "Black Stones (काळे खडे)";
      case DiceType.sticks:
        return "Sticks (काठ्या)";
      case DiceType.tamarindSeeds:
        return "Tamarind Seeds (चिंचोके)";
      case DiceType.cowrieShells:
        return "Cowrie Shells (कवड्या)";
    }
  }

  String get shortName {
    switch (this) {
      case DiceType.whiteStone:
        return "White Stones";
      case DiceType.blackStone:
        return "Black Stones";
      case DiceType.sticks:
        return "Sticks";
      case DiceType.tamarindSeeds:
        return "Tamarind Seeds";
      case DiceType.cowrieShells:
        return "Cowries";
    }
  }

  String getLocalizedName(AppLanguage lang) {
    switch (this) {
      case DiceType.whiteStone:
        switch (lang) {
          case AppLanguage.hindi:
            return "सफेद कंकड़";
          case AppLanguage.marathi:
            return "पांढरे खडे";
          case AppLanguage.english:
            return "White Stones";
        }
      case DiceType.blackStone:
        switch (lang) {
          case AppLanguage.hindi:
            return "काले कंकड़";
          case AppLanguage.marathi:
            return "काळे खडे";
          case AppLanguage.english:
            return "Black Stones";
        }
      case DiceType.sticks:
        switch (lang) {
          case AppLanguage.hindi:
            return "तीलियाँ";
          case AppLanguage.marathi:
            return "काठ्या";
          case AppLanguage.english:
            return "Sticks";
        }
      case DiceType.tamarindSeeds:
        switch (lang) {
          case AppLanguage.hindi:
            return "चिंचोके";
          case AppLanguage.marathi:
            return "चिंचोके";
          case AppLanguage.english:
            return "Tamarind Seeds";
        }
      case DiceType.cowrieShells:
        switch (lang) {
          case AppLanguage.hindi:
            return "कौड़ियां";
          case AppLanguage.marathi:
            return "कवड्या";
          case AppLanguage.english:
            return "Cowrie Shells";
        }
    }
  }

  String get icon {
    switch (this) {
      case DiceType.whiteStone:
        return "⚪";
      case DiceType.blackStone:
        return "⚫";
      case DiceType.sticks:
        return "🪵";
      case DiceType.tamarindSeeds:
        return "🌰";
      case DiceType.cowrieShells:
        return "🐚";
    }
  }

  String getLocalizedRollAction(AppLanguage lang) {
    final name = getLocalizedName(lang);
    switch (lang) {
      case AppLanguage.hindi:
        return "$name फेंकें";
      case AppLanguage.marathi:
        return "$name टाका";
      case AppLanguage.english:
        return "Toss $name";
    }
  }

  String get rollActionText {
    return getLocalizedRollAction(AppLanguage.english);
  }
}

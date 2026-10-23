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

  String get rollActionText {
    switch (this) {
      case DiceType.whiteStone:
        return "Toss White Stones (खडे टाका)";
      case DiceType.blackStone:
        return "Toss Black Stones (खडे टाका)";
      case DiceType.sticks:
        return "Toss Sticks (काठ्या टाका)";
      case DiceType.tamarindSeeds:
        return "Toss Seeds (चिंचोके टाका)";
      case DiceType.cowrieShells:
        return "Roll Kavadis (कवड्या टाका)";
    }
  }
}

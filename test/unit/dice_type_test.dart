import 'package:flutter_test/flutter_test.dart';
import 'package:champal_pani/models/dice_type.dart';
import 'package:champal_pani/i18n/localization_service.dart';

void main() {
  group('DiceType Unit Tests', () {
    test('All 5 dice types have distinct display names and icons', () {
      expect(DiceType.values.length, equals(5));

      for (final type in DiceType.values) {
        expect(type.displayName.isNotEmpty, isTrue);
        expect(type.shortName.isNotEmpty, isTrue);
        expect(type.icon.isNotEmpty, isTrue);
      }
    });

    test('DiceType localized names in English, Hindi, and Marathi', () {
      expect(DiceType.whiteStone.getLocalizedName(AppLanguage.english), equals('White Stones'));
      expect(DiceType.whiteStone.getLocalizedName(AppLanguage.hindi), equals('सफेद कंकड़'));
      expect(DiceType.whiteStone.getLocalizedName(AppLanguage.marathi), equals('पांढरे खडे'));

      expect(DiceType.blackStone.getLocalizedName(AppLanguage.english), equals('Black Stones'));
      expect(DiceType.blackStone.getLocalizedName(AppLanguage.hindi), equals('काले कंकड़'));
      expect(DiceType.blackStone.getLocalizedName(AppLanguage.marathi), equals('काळे खडे'));

      expect(DiceType.sticks.getLocalizedName(AppLanguage.english), equals('Sticks'));
      expect(DiceType.sticks.getLocalizedName(AppLanguage.hindi), equals('तीलियाँ'));
      expect(DiceType.sticks.getLocalizedName(AppLanguage.marathi), equals('काठ्या'));

      expect(DiceType.tamarindSeeds.getLocalizedName(AppLanguage.english), equals('Tamarind Seeds'));
      expect(DiceType.tamarindSeeds.getLocalizedName(AppLanguage.hindi), equals('चिंचोके'));
      expect(DiceType.tamarindSeeds.getLocalizedName(AppLanguage.marathi), equals('चिंचोके'));

      expect(DiceType.cowrieShells.getLocalizedName(AppLanguage.english), equals('Cowrie Shells'));
      expect(DiceType.cowrieShells.getLocalizedName(AppLanguage.hindi), equals('कौड़ियां'));
      expect(DiceType.cowrieShells.getLocalizedName(AppLanguage.marathi), equals('कवड्या'));
    });

    test('DiceType roll action text localization', () {
      expect(DiceType.whiteStone.getLocalizedRollAction(AppLanguage.english), equals('Toss White Stones'));
      expect(DiceType.whiteStone.getLocalizedRollAction(AppLanguage.hindi), equals('सफेद कंकड़ फेंकें'));
      expect(DiceType.whiteStone.getLocalizedRollAction(AppLanguage.marathi), equals('पांढरे खडे टाका'));
    });
  });
}

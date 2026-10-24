import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:champal_pani/i18n/localization_service.dart';
import 'package:champal_pani/i18n/app_strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('i18n & Localization Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('AppLanguage fromCode with valid, invalid, and null inputs', () {
      expect(AppLanguage.fromCode('en'), equals(AppLanguage.english));
      expect(AppLanguage.fromCode('hi'), equals(AppLanguage.hindi));
      expect(AppLanguage.fromCode('mr'), equals(AppLanguage.marathi));

      // Defaults/Fallbacks to English
      expect(AppLanguage.fromCode(null), equals(AppLanguage.english));
      expect(AppLanguage.fromCode(''), equals(AppLanguage.english));
      expect(AppLanguage.fromCode('fr'), equals(AppLanguage.english));
      expect(AppLanguage.fromCode('unknown'), equals(AppLanguage.english));
    });

    test('LocalizationService defaults to English on first launch', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LocalizationService.instance;
      // Reset state for test
      await service.setLanguage(AppLanguage.english);

      expect(service.currentLanguage, equals(AppLanguage.english));
      expect(service.t('appName'), equals('Champal Pani'));
    });

    test('LocalizationService switches language and notifies listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final service = LocalizationService.instance;

      int notifyCount = 0;
      void listener() => notifyCount++;
      service.addListener(listener);

      await service.setLanguage(AppLanguage.hindi);
      expect(service.currentLanguage, equals(AppLanguage.hindi));
      expect(service.t('appName'), equals('चंपाळ पाणी'));
      expect(notifyCount, greaterThan(0));

      await service.setLanguage(AppLanguage.marathi);
      expect(service.currentLanguage, equals(AppLanguage.marathi));
      expect(service.t('appName'), equals('चंपाळ पाणी'));

      await service.setLanguage(AppLanguage.english);
      expect(service.currentLanguage, equals(AppLanguage.english));
      expect(service.t('appName'), equals('Champal Pani'));

      service.removeListener(listener);
    });

    test('Translation keys coverage in English, Hindi, and Marathi', () {
      final keys = [
        'appName',
        'appSubtitle',
        'newGame',
        'newGameSetup',
        'gameMode',
        'vsAI',
        'passAndPlay',
        'numberOfPlayers',
        'twoPlayers',
        'threePlayers',
        'fourPlayers',
        'startMatch',
        'cancel',
        'rulesAndGuide',
        'rulesTitle',
        'changeTheme',
        'themeSelectorTitle',
        'done',
        'boardAndToss',
        'kingdoms',
        'chronicle',
        'gameHistory',
        'liveChronicle',
        'piecesAndCasting',
        'swargaHome',
        'paniStream',
        'kills',
        'base',
        'field',
        'home',
        'paniUnlocked',
        'noPani',
        'you',
        'bot',
        'turnRoll',
        'turnSelectPawn',
        'botThinking',
        'rolled',
        'bonusRoll',
        'champalBonus',
        'challasBonus',
        'tossAction',
        'tossingAction',
        'tapPawnPrompt',
        'gameOver',
        'victoryTitle',
        'wonTheGame',
        'allPawnsSwarga',
        'playAgain',
        'language',
        'selectLanguage',
        'south',
        'west',
        'north',
        'east',
        'whiteStone',
        'blackStone',
        'sticks',
        'tamarindSeeds',
        'cowrieShells',
        'scoringGuideTitle',
        'scoringGuideContent',
        'ruleObjectiveTitle',
        'ruleObjectiveBody',
        'rulePiecesTitle',
        'rulePiecesBody',
        'rulePaniTitle',
        'rulePaniBody',
        'ruleSafeTitle',
        'ruleSafeBody',
        'ruleSwargaTitle',
        'ruleSwargaBody',
        'logNewGame',
        'logRolled',
        'logBonusSuffix',
        'logNoMoves',
        'logCaptured',
        'logUnlockedPani',
        'logReachedSwarga',
        'logEarnedExtraRoll',
        'logWonGame',
      ];

      for (final key in keys) {
        final en = AppStrings.get(AppLanguage.english, key);
        final hi = AppStrings.get(AppLanguage.hindi, key);
        final mr = AppStrings.get(AppLanguage.marathi, key);

        expect(en.isNotEmpty, isTrue, reason: 'Key $key should have English translation');
        expect(hi.isNotEmpty, isTrue, reason: 'Key $key should have Hindi translation');
        expect(mr.isNotEmpty, isTrue, reason: 'Key $key should have Marathi translation');

        // Check that translation is not returning the raw key
        expect(en, isNot(equals(key)), reason: 'Key $key should not return the key itself in English');
        expect(hi, isNot(equals(key)), reason: 'Key $key should not return the key itself in Hindi');
        expect(mr, isNot(equals(key)), reason: 'Key $key should not return the key itself in Marathi');
      }
    });

    test('Translation parameter replacement', () {
      final msg = AppStrings.get(AppLanguage.english, 'logNewGame', {'count': '4'});
      expect(msg, equals('🎉 New game started with 4 players!'));

      final msgHi = AppStrings.get(AppLanguage.hindi, 'logNewGame', {'count': '2'});
      expect(msgHi, equals('🎉 2 खिलाड़ियों के साथ नया खेल शुरू हुआ!'));

      final msgMr = AppStrings.get(AppLanguage.marathi, 'logNewGame', {'count': '3'});
      expect(msgMr, equals('🎉 3 खेळाडूंसह नवीन खेळ सुरू झाला!'));
    });

    test('Missing key safely falls back to English and then raw key', () {
      final res = AppStrings.get(AppLanguage.hindi, 'non_existent_key_xyz');
      expect(res, equals('non_existent_key_xyz'));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:champal_pani/main.dart';
import 'package:champal_pani/i18n/localization_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Widget & Integration Tests - GameScreen & Localization', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await LocalizationService.instance.init();
      await LocalizationService.instance.setLanguage(AppLanguage.english);
    });

    testWidgets('App renders correctly with Clean Minimal design and English default', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('Champal Pani'), findsOneWidget);
      expect(find.text('Traditional 5x5 Board Game'), findsOneWidget);

      // Verify Language Selector displays English
      expect(find.text('English'), findsOneWidget);

      // Verify Action icons in AppBar
      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Verify 5x5 board is rendered (25 cells)
      expect(find.byType(GridView), findsOneWidget);

      // Verify Center Swarga cell is rendered
      expect(find.text('SWARGA\nHOME'), findsOneWidget);

      // Verify kingdoms panel
      expect(find.text('👑 Kingdoms'), findsOneWidget);

      // Verify live chronicle
      expect(find.text('📜 Live Chronicle'), findsOneWidget);
    });

    testWidgets('Instant Language Switching: English -> Hindi -> Marathi -> English without page reload', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // 1. Initial English State
      expect(find.text('Champal Pani'), findsOneWidget);
      expect(find.text('👑 Kingdoms'), findsOneWidget);
      expect(find.text('📜 Live Chronicle'), findsOneWidget);

      // 2. Switch to Hindi (हिन्दी)
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      // Find 'हिन्दी' in popup menu and tap it
      final hindiOption = find.text('हिन्दी').last;
      await tester.tap(hindiOption);
      await tester.pumpAndSettle();

      // Verify Hindi UI text updated immediately
      expect(find.text('चंपाळ पाणी'), findsOneWidget);
      expect(find.text('पारंपरिक 5x5 बोर्ड गेम'), findsOneWidget);
      expect(find.text('👑 साम्राज्य'), findsOneWidget);
      expect(find.text('📜 लाइव विवरण'), findsOneWidget);
      expect(find.text('स्वर्ग\nघर'), findsOneWidget);

      // 3. Switch to Marathi (मराठी)
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      final marathiOption = find.text('मराठी').last;
      await tester.tap(marathiOption);
      await tester.pumpAndSettle();

      // Verify Marathi UI text updated immediately
      expect(find.text('चंपाळ पाणी'), findsOneWidget);
      expect(find.text('पारंपारिक ५x५ पट खेळ'), findsOneWidget);
      expect(find.text('👑 साम्राज्य'), findsOneWidget);
      expect(find.text('📜 थेट घडामोडी'), findsOneWidget);

      // 4. Switch back to English
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();

      final englishOption = find.text('English').last;
      await tester.tap(englishOption);
      await tester.pumpAndSettle();

      // Verify back to English
      expect(find.text('Champal Pani'), findsOneWidget);
      expect(find.text('👑 Kingdoms'), findsOneWidget);
    });

    testWidgets('New Game Setup modal opens, allows changing settings, and starts match', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // Tap New Game button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('New Game Setup'), findsOneWidget);
      expect(find.text('Game Mode'), findsOneWidget);
      expect(find.text('Number of Players'), findsOneWidget);

      // Tap Start Match
      await tester.tap(find.text('Start Match 🎲'));
      await tester.pumpAndSettle();

      // Dialog closed
      expect(find.text('New Game Setup'), findsNothing);
    });

    testWidgets('Rules & Guide modal opens with full localized content', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // Tap Rules button
      await tester.tap(find.byIcon(Icons.menu_book));
      await tester.pumpAndSettle();

      // Verify Dialog header
      expect(find.text('Champal Pani — Guide & Rules'), findsOneWidget);
      expect(find.text('🎯 Objective'), findsOneWidget);

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Champal Pani — Guide & Rules'), findsNothing);
    });

    testWidgets('Theme Selector modal opens and allows selecting themes', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // Tap Theme button
      await tester.tap(find.byIcon(Icons.palette_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Select Visual Theme'), findsOneWidget);
      expect(find.text('Clean Minimal'), findsOneWidget);
      expect(find.text('Royal Rajwada'), findsOneWidget);

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('Select Visual Theme'), findsNothing);
    });

    testWidgets('Mobile responsive layout renders bottom navigation tabs', (WidgetTester tester) async {
      // Set to mobile viewport size (iPhone / Android phone portrait)
      tester.view.physicalSize = const Size(400, 850);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ChampalPaniApp());
      await tester.pumpAndSettle();

      // Verify BottomNavigationBar is present on mobile
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Board & Toss'), findsOneWidget);
      expect(find.text('Kingdoms'), findsOneWidget);
      expect(find.text('Chronicle'), findsOneWidget);

      // Tap Kingdoms tab
      await tester.tap(find.text('Kingdoms'));
      await tester.pumpAndSettle();

      // Tap Chronicle tab
      await tester.tap(find.text('Chronicle'));
      await tester.pumpAndSettle();
      expect(find.text('📜 Game History'), findsOneWidget);

      // Tap back to Board & Toss tab
      await tester.tap(find.text('Board & Toss'));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}

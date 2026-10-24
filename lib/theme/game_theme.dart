import 'package:flutter/material.dart';
import '../i18n/localization_service.dart';

enum GameThemeId {
  cleanMinimal,
  royalRajwada,
  traditionalCloth,
  teakWood,
  mysticMidnight,
}

class GameTheme {
  final GameThemeId id;
  final String name;
  final String hindiName;
  final String marathiName;
  final String description;
  final String icon;
  final bool isDark;

  // App & Scaffold
  final Color scaffoldBg;
  final Color appBarBg;
  final Color appBarTextColor;
  final Color surfaceBg;
  final Color cardBorder;
  final Color cardCurrentPlayerBg;
  final Color textColor;
  final Color textSecondaryColor;
  final Color dividerColor;

  // Board Frame
  final Color boardBg;
  final Color boardBorder;
  final List<Color> boardGradient;
  final Color boardGlow;

  // Cells
  final Color cellDefaultBg;
  final Color cellDefaultBorder;
  final Color cellPaniBg;
  final Color cellPaniBorder;
  final Color cellPaniTextColor;

  // Swarga Center & Safe
  final Color cellCenterBg;
  final Color cellCenterBorder;
  final List<Color> cellCenterGradient;

  // Toss Arena
  final List<Color> tossDishBg;
  final Color tossDishBorder;
  final Color primaryButtonBg;
  final Color primaryButtonTextColor;
  final Color accentGold;

  const GameTheme({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.marathiName,
    required this.description,
    required this.icon,
    this.isDark = true,
    required this.scaffoldBg,
    required this.appBarBg,
    required this.appBarTextColor,
    required this.surfaceBg,
    required this.cardBorder,
    required this.cardCurrentPlayerBg,
    this.textColor = Colors.white,
    this.textSecondaryColor = Colors.white70,
    this.dividerColor = const Color(0x33FFFFFF),
    required this.boardBg,
    required this.boardBorder,
    required this.boardGradient,
    required this.boardGlow,
    required this.cellDefaultBg,
    required this.cellDefaultBorder,
    required this.cellPaniBg,
    required this.cellPaniBorder,
    required this.cellPaniTextColor,
    required this.cellCenterBg,
    required this.cellCenterBorder,
    required this.cellCenterGradient,
    required this.tossDishBg,
    required this.tossDishBorder,
    required this.primaryButtonBg,
    required this.primaryButtonTextColor,
    required this.accentGold,
  });

  String getLocalizedName(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return hindiName;
      case AppLanguage.marathi:
        return marathiName;
      case AppLanguage.english:
        return name;
    }
  }

  // 0. Clean Minimal (Modern, uncluttered, white/grey with muted indigo) - DEFAULT THEME
  static const cleanMinimal = GameTheme(
    id: GameThemeId.cleanMinimal,
    name: "Clean Minimal",
    hindiName: "स्वच्छ मिनिमल",
    marathiName: "स्वच्छ मिनिमल",
    description: "Modern uncluttered layout, light background, dark charcoal text & muted indigo accent",
    icon: "✨",
    isDark: false,
    scaffoldBg: Color(0xFFF8FAFC),
    appBarBg: Color(0xFFFFFFFF),
    appBarTextColor: Color(0xFF0F172A),
    surfaceBg: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2E8F0),
    cardCurrentPlayerBg: Color(0xFFEEF2FF),
    textColor: Color(0xFF0F172A),
    textSecondaryColor: Color(0xFF64748B),
    dividerColor: Color(0xFFE2E8F0),
    boardBg: Color(0xFFFFFFFF),
    boardBorder: Color(0xFFCBD5E1),
    boardGradient: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    boardGlow: Color(0x224F46E5),
    cellDefaultBg: Color(0xFFF1F5F9),
    cellDefaultBorder: Color(0xFFE2E8F0),
    cellPaniBg: Color(0xFFE0F2FE),
    cellPaniBorder: Color(0xFF38BDF8),
    cellPaniTextColor: Color(0xFF0284C7),
    cellCenterBg: Color(0xFFFEF3C7),
    cellCenterBorder: Color(0xFFF59E0B),
    cellCenterGradient: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
    tossDishBg: [Color(0xFFF8FAFC), Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
    tossDishBorder: Color(0xFFCBD5E1),
    primaryButtonBg: Color(0xFF4F46E5),
    primaryButtonTextColor: Colors.white,
    accentGold: Color(0xFF4F46E5),
  );

  // 1. Royal Rajwada (शाही राजवाडा) - Regal Crimson Velvet & Antique Gold
  static const royalRajwada = GameTheme(
    id: GameThemeId.royalRajwada,
    name: "Royal Rajwada",
    hindiName: "शाही राजवाड़ा",
    marathiName: "शाही राजवाडा",
    description: "Palace velvet, imperial crimson, rich gold foil & royal turquoise water",
    icon: "👑",
    isDark: true,
    scaffoldBg: Color(0xFF140408),
    appBarBg: Color(0xFF26060F),
    appBarTextColor: Color(0xFFF7D070),
    surfaceBg: Color(0xFF21060D),
    cardBorder: Color(0x66E5A93C),
    cardCurrentPlayerBg: Color(0xEE420C1A),
    textColor: Colors.white,
    textSecondaryColor: Colors.white70,
    dividerColor: Color(0x33D4AF37),
    boardBg: Color(0xFF280712),
    boardBorder: Color(0xFFD4AF37),
    boardGradient: [Color(0xFF380A17), Color(0xFF1E040C)],
    boardGlow: Color(0xFFD4AF37),
    cellDefaultBg: Color(0xFF3D0E1C),
    cellDefaultBorder: Color(0xFF6B1D33),
    cellPaniBg: Color(0xFF0B4654),
    cellPaniBorder: Color(0xFF22C1B2),
    cellPaniTextColor: Color(0xFF5CF0E2),
    cellCenterBg: Color(0xFF4A0E22),
    cellCenterBorder: Color(0xFFFFD700),
    cellCenterGradient: [Color(0x88FFD700), Color(0xEE300714)],
    tossDishBg: [Color(0xFF1A4D3B), Color(0xFF0B2E22), Color(0xFF420D1D)],
    tossDishBorder: Color(0xFFE5A93C),
    primaryButtonBg: Color(0xFFE5A93C),
    primaryButtonTextColor: Color(0xFF1A050A),
    accentGold: Color(0xFFF7D070),
  );

  // 2. Traditional Cloth (कापडी पट) - Terracotta & Khadi Silk
  static const traditionalCloth = GameTheme(
    id: GameThemeId.traditionalCloth,
    name: "Traditional Cloth",
    hindiName: "कपड़े का पट",
    marathiName: "कापडी पट",
    description: "Historic Indian handwoven fabric board, terracotta earth & sacred indigo",
    icon: "📜",
    isDark: true,
    scaffoldBg: Color(0xFF141210),
    appBarBg: Color(0xFF261D16),
    appBarTextColor: Color(0xFFFFE0A3),
    surfaceBg: Color(0xFF241B13),
    cardBorder: Color(0x66D48B47),
    cardCurrentPlayerBg: Color(0xEE472F1F),
    textColor: Colors.white,
    textSecondaryColor: Colors.white70,
    dividerColor: Color(0x33B87333),
    boardBg: Color(0xFF2E2218),
    boardBorder: Color(0xFFB87333),
    boardGradient: [Color(0xFF38291C), Color(0xFF22170E)],
    boardGlow: Color(0xFFE07A5F),
    cellDefaultBg: Color(0xFF402E20),
    cellDefaultBorder: Color(0xFF6E5038),
    cellPaniBg: Color(0xFF14364D),
    cellPaniBorder: Color(0xFF3E8DB5),
    cellPaniTextColor: Color(0xFF81C3E6),
    cellCenterBg: Color(0xFF4D2417),
    cellCenterBorder: Color(0xFFE07A5F),
    cellCenterGradient: [Color(0x77E07A5F), Color(0xEE2B140B)],
    tossDishBg: [Color(0xFF2E4035), Color(0xFF18261E), Color(0xFF3D2718)],
    tossDishBorder: Color(0xFFB87333),
    primaryButtonBg: Color(0xFFE07A5F),
    primaryButtonTextColor: Colors.white,
    accentGold: Color(0xFFFFB703),
  );

  // 3. Golden Teak & Brass (सागवानी लाकूड)
  static const teakWood = GameTheme(
    id: GameThemeId.teakWood,
    name: "Golden Teak & Brass",
    hindiName: "सागवान की लकड़ी",
    marathiName: "सागवानी लाकूड",
    description: "Polished golden teakwood board with beaten brass inlay corners & emerald river",
    icon: "🪵",
    isDark: true,
    scaffoldBg: Color(0xFF120B06),
    appBarBg: Color(0xFF21140A),
    appBarTextColor: Color(0xFFF7D070),
    surfaceBg: Color(0xFF1E1107),
    cardBorder: Color(0x44D4AF37),
    cardCurrentPlayerBg: Color(0xDD3D1F10),
    textColor: Colors.white,
    textSecondaryColor: Colors.white70,
    dividerColor: Color(0x33D4AF37),
    boardBg: Color(0xFF241308),
    boardBorder: Color(0xFFC59B27),
    boardGradient: [Color(0xFF331C0C), Color(0xFF190C04)],
    boardGlow: Color(0xFFC59B27),
    cellDefaultBg: Color(0xFF381F0E),
    cellDefaultBorder: Color(0xFF6B4021),
    cellPaniBg: Color(0xFF0F3B2C),
    cellPaniBorder: Color(0xFF2BB673),
    cellPaniTextColor: Color(0xFF55E6A5),
    cellCenterBg: Color(0xFF42210C),
    cellCenterBorder: Color(0xFFE5B833),
    cellCenterGradient: [Color(0x77E5B833), Color(0xEE1E0E05)],
    tossDishBg: [Color(0xFF143D2A), Color(0xFF0B2116), Color(0xFF38200F)],
    tossDishBorder: Color(0xFFC59B27),
    primaryButtonBg: Color(0xFFD4AF37),
    primaryButtonTextColor: Color(0xFF140B04),
    accentGold: Color(0xFFF7D070),
  );

  // 4. Mystic Midnight (मध्यरात्र)
  static const mysticMidnight = GameTheme(
    id: GameThemeId.mysticMidnight,
    name: "Mystic Midnight",
    hindiName: "मध्यरात्रि",
    marathiName: "मध्यरात्र",
    description: "Cosmic obsidian basalt board with glowing cyan waterways & celestial gold",
    icon: "🌌",
    isDark: true,
    scaffoldBg: Color(0xFF08090E),
    appBarBg: Color(0xFF10131C),
    appBarTextColor: Color(0xFFF9D423),
    surfaceBg: Color(0xFF12141F),
    cardBorder: Color(0x55F9D423),
    cardCurrentPlayerBg: Color(0xDD1F2338),
    textColor: Colors.white,
    textSecondaryColor: Colors.white70,
    dividerColor: Color(0x33F9D423),
    boardBg: Color(0xFF111422),
    boardBorder: Color(0xFFF9D423),
    boardGradient: [Color(0xFF181C2E), Color(0xFF0D0F18)],
    boardGlow: Color(0xFF00F5D4),
    cellDefaultBg: Color(0xFF1B2033),
    cellDefaultBorder: Color(0xFF363E5E),
    cellPaniBg: Color(0xFF052B38),
    cellPaniBorder: Color(0xFF00F5D4),
    cellPaniTextColor: Color(0xFF00F5D4),
    cellCenterBg: Color(0xFF261D3B),
    cellCenterBorder: Color(0xFFF9D423),
    cellCenterGradient: [Color(0x88F9D423), Color(0xEE0E101E)],
    tossDishBg: [Color(0xFF0A2B2E), Color(0xFF051719), Color(0xFF1D1533)],
    tossDishBorder: Color(0xFFF9D423),
    primaryButtonBg: Color(0xFFF9D423),
    primaryButtonTextColor: Color(0xFF08090E),
    accentGold: Color(0xFFF9D423),
  );

  static const List<GameTheme> allThemes = [
    cleanMinimal,
    royalRajwada,
    traditionalCloth,
    teakWood,
    mysticMidnight,
  ];

  static GameTheme getById(GameThemeId id) {
    switch (id) {
      case GameThemeId.cleanMinimal:
        return cleanMinimal;
      case GameThemeId.royalRajwada:
        return royalRajwada;
      case GameThemeId.traditionalCloth:
        return traditionalCloth;
      case GameThemeId.teakWood:
        return teakWood;
      case GameThemeId.mysticMidnight:
        return mysticMidnight;
    }
  }
}

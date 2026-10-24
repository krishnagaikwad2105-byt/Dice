import 'package:flutter/material.dart';
import 'logic/game_controller.dart';
import 'widgets/board_widget.dart';
import 'widgets/player_panel_widget.dart';
import 'widgets/rules_dialog.dart';
import 'theme/game_theme.dart';
import 'i18n/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizationService.instance.init();
  runApp(const ChampalPaniApp());
}

class ChampalPaniApp extends StatelessWidget {
  const ChampalPaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalizationService.instance,
      builder: (context, _) {
        final loc = LocalizationService.instance;

        return MaterialApp(
          title: '${loc.t('appName')} - ${loc.t('appSubtitle')}',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4F46E5),
              brightness: Brightness.light,
              primary: const Color(0xFF4F46E5),
              surface: Colors.white,
            ),
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0.5,
              scrolledUnderElevation: 1.0,
              iconTheme: IconThemeData(color: Color(0xFF0F172A)),
              titleTextStyle: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF140408),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE5A93C),
              secondary: Color(0xFFE63946),
              surface: Color(0xFF21060D),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF26060F),
              elevation: 2,
              iconTheme: IconThemeData(color: Color(0xFFF7D070)),
              titleTextStyle: TextStyle(
                color: Color(0xFFF7D070),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          themeMode: ThemeMode.light,
          home: const GameScreen(),
        );
      },
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  int _selectedMobileTab = 0; // 0 = Board, 1 = Kingdoms, 2 = Chronicle

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _controller.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    if (_controller.winner != null && mounted) {
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
    final theme = _controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;
    final winner = _controller.winner!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surfaceBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.accentGold, width: 2),
          ),
          title: Center(
            child: Text(
              "👑 ${loc.t('victoryTitle')} 👑",
              style: TextStyle(
                color: theme.accentGold,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                winner.avatar,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 8),
              Text(
                "${winner.getDisplayName(lang)} ${loc.t('wonTheGame')}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                winner.getLocalizedSide(lang),
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.isDark ? const Color(0x33000000) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.cardBorder),
                ),
                child: Text(
                  "⚔️ ${winner.kills} ${loc.t('kills')} • ${loc.t('allPawnsSwarga')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textSecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryButtonBg,
                  foregroundColor: theme.primaryButtonTextColor,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controller.startNewGame(
                    playerCount: _controller.numPlayers,
                    vsAI: _controller.isVsAI,
                  );
                },
                child: Text(
                  "${loc.t('playAgain')} ⚔️",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNewGameDialog() {
    int selectedPlayers = _controller.numPlayers;
    bool vsAI = _controller.isVsAI;
    final theme = _controller.theme;
    final loc = LocalizationService.instance;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.surfaceBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.cardBorder),
              ),
              title: Row(
                children: [
                  const Text("⚔️ "),
                  Text(
                    loc.t('newGameSetup'),
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.t('gameMode'),
                    style: TextStyle(color: theme.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.isDark ? const Color(0x33FFFFFF) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<bool>(
                        value: vsAI,
                        isExpanded: true,
                        dropdownColor: theme.surfaceBg,
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "${loc.t('vsAI')} 🤖",
                              style: TextStyle(color: theme.textColor, fontSize: 13),
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "${loc.t('passAndPlay')} 👥",
                              style: TextStyle(color: theme.textColor, fontSize: 13),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setDialogState(() => vsAI = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loc.t('numberOfPlayers'),
                    style: TextStyle(color: theme.textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.isDark ? const Color(0x33FFFFFF) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedPlayers,
                        isExpanded: true,
                        dropdownColor: theme.surfaceBg,
                        items: [
                          DropdownMenuItem(
                            value: 2,
                            child: Text(
                              loc.t('twoPlayers'),
                              style: TextStyle(color: theme.textColor, fontSize: 13),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text(
                              loc.t('threePlayers'),
                              style: TextStyle(color: theme.textColor, fontSize: 13),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text(
                              loc.t('fourPlayers'),
                              style: TextStyle(color: theme.textColor, fontSize: 13),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setDialogState(() => selectedPlayers = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    loc.t('cancel'),
                    style: TextStyle(color: theme.textSecondaryColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryButtonBg,
                    foregroundColor: theme.primaryButtonTextColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _controller.startNewGame(
                      playerCount: selectedPlayers,
                      vsAI: vsAI,
                    );
                  },
                  child: Text(
                    "${loc.t('startMatch')} 🎲",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showThemeSelectorDialog() {
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final activeTheme = _controller.theme;

            return AlertDialog(
              backgroundColor: activeTheme.surfaceBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: activeTheme.cardBorder, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text("🎨 "),
                  Text(
                    loc.t('themeSelectorTitle'),
                    style: TextStyle(
                      color: activeTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 380,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: GameTheme.allThemes.map((th) {
                      final isSelected = th.id == activeTheme.id;

                      final itemBg = isSelected
                          ? th.cardCurrentPlayerBg
                          : (activeTheme.isDark ? th.boardBg.withValues(alpha: 0.5) : const Color(0xFFF8FAFC));

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? activeTheme.accentGold : activeTheme.cardBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Material(
                          color: itemBg,
                          borderRadius: BorderRadius.circular(11),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: th.boardGradient),
                                border: Border.all(color: th.boardBorder, width: 1.5),
                              ),
                              child: Center(
                                child: Text(th.icon, style: const TextStyle(fontSize: 18)),
                              ),
                            ),
                          title: Text(
                            th.getLocalizedName(lang),
                            style: TextStyle(
                              color: isSelected ? activeTheme.accentGold : activeTheme.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                th.description,
                                style: TextStyle(color: activeTheme.textSecondaryColor, fontSize: 10.5),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  _colorDot(th.boardBg),
                                  _colorDot(th.boardBorder),
                                  _colorDot(th.cellPaniBorder),
                                  _colorDot(th.accentGold),
                                ],
                              ),
                            ],
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: activeTheme.accentGold)
                              : null,
                          onTap: () {
                            _controller.setTheme(th);
                            setDialogState(() {});
                          },
                        ),
                      ),
                    );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeTheme.primaryButtonBg,
                    foregroundColor: activeTheme.primaryButtonTextColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    loc.t('done'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 0.8),
      ),
    );
  }

  Widget _buildLanguageSelector(GameTheme theme) {
    final loc = LocalizationService.instance;
    final currentLang = loc.currentLanguage;

    return PopupMenuButton<AppLanguage>(
      tooltip: loc.t('selectLanguage'),
      initialValue: currentLang,
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.cardBorder),
      ),
      color: theme.surfaceBg,
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.isDark ? const Color(0x22FFFFFF) : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 16),
            const SizedBox(width: 4),
            Text(
              currentLang.nativeName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.textColor,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 16, color: theme.textSecondaryColor),
          ],
        ),
      ),
      onSelected: (AppLanguage lang) {
        loc.setLanguage(lang);
      },
      itemBuilder: (context) {
        return AppLanguage.values.map((lang) {
          final isSelected = lang == currentLang;
          return PopupMenuItem<AppLanguage>(
            value: lang,
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check, size: 16, color: theme.accentGold)
                else
                  const SizedBox(width: 16),
                const SizedBox(width: 8),
                Text(
                  lang.nativeName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.accentGold : theme.textColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "(${lang.englishName})",
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_controller, LocalizationService.instance]),
      builder: (context, _) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 900;
        final theme = _controller.theme;
        final loc = LocalizationService.instance;

        return Scaffold(
          backgroundColor: theme.scaffoldBg,
          appBar: AppBar(
            backgroundColor: theme.appBarBg,
            iconTheme: IconThemeData(color: theme.textColor),
            elevation: theme.isDark ? 3 : 0.8,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(theme.icon),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    loc.t('appName'),
                    style: TextStyle(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      loc.t('appSubtitle'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: theme.textSecondaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              // Language Selector (English, Hindi, Marathi)
              _buildLanguageSelector(theme),
              const SizedBox(width: 4),

              // Theme Selector
              IconButton(
                icon: const Icon(Icons.palette_outlined),
                tooltip: loc.t('changeTheme'),
                onPressed: _showThemeSelectorDialog,
              ),

              // Rules
              IconButton(
                icon: const Icon(Icons.menu_book),
                tooltip: loc.t('rulesAndGuide'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => RulesDialog(theme: theme),
                  );
                },
              ),

              // New Game
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: loc.t('newGame'),
                onPressed: _showNewGameDialog,
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: SafeArea(
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
          bottomNavigationBar: isDesktop
              ? null
              : BottomNavigationBar(
                  backgroundColor: theme.surfaceBg,
                  selectedItemColor: theme.accentGold,
                  unselectedItemColor: theme.textSecondaryColor.withValues(alpha: 0.6),
                  currentIndex: _selectedMobileTab,
                  onTap: (idx) => setState(() => _selectedMobileTab = idx),
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.grid_view),
                      label: loc.t('boardAndToss'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.shield),
                      label: loc.t('kingdoms'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.history_edu),
                      label: loc.t('chronicle'),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // Desktop / Tablet 3-Column Layout
  Widget _buildDesktopLayout() {
    final theme = _controller.theme;
    final loc = LocalizationService.instance;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Player Cards & Kingdoms
          SizedBox(
            width: 250,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "👑 ${loc.t('kingdoms')}",
                    style: TextStyle(
                      color: theme.accentGold,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PlayerPanelWidget(controller: _controller),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Center: The Complete Board (Grid, Tokens & On-Board Toss)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTurnBanner(),
                  const SizedBox(height: 10),
                  BoardWidget(controller: _controller),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right: Traditional Scoring Guide & Live Log
          SizedBox(
            width: 270,
            child: Column(
              children: [
                _buildTraditionalPiecesGuide(),
                const SizedBox(height: 10),
                Text(
                  "📜 ${loc.t('liveChronicle')}",
                  style: TextStyle(
                    color: theme.accentGold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: _buildLogView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Single Column / Tabbed Layout
  Widget _buildMobileLayout() {
    final theme = _controller.theme;
    final loc = LocalizationService.instance;

    switch (_selectedMobileTab) {
      case 1:
        // Kingdoms Tab
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "👑 ${loc.t('kingdoms')}",
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              PlayerPanelWidget(controller: _controller),
            ],
          ),
        );
      case 2:
        // Chronicle Tab
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildTraditionalPiecesGuide(),
              const SizedBox(height: 10),
              Text(
                "📜 ${loc.t('gameHistory')}",
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildLogView()),
            ],
          ),
        );
      default:
        // Board & Toss Tab
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTurnBanner(),
              const SizedBox(height: 8),
              BoardWidget(controller: _controller),
            ],
          ),
        );
    }
  }

  Widget _buildTraditionalPiecesGuide() {
    final theme = _controller.theme;
    final loc = LocalizationService.instance;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: theme.isDark ? 0.95 : 1.0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(theme.icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  loc.t('scoringGuideTitle'),
                  style: TextStyle(
                    color: theme.accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            loc.t('scoringGuideContent'),
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.8),
              fontSize: 11,
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnBanner() {
    final player = _controller.currentPlayer;
    final theme = _controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: theme.isDark ? 0.95 : 1.0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: player.color.withValues(alpha: 0.7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.4 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: player.color,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(player.avatar, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.getDisplayName(lang),
                  style: TextStyle(
                    color: theme.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  player.isAI
                      ? "🤖 ${loc.t('botThinking')}"
                      : (_controller.waitingForPawnChoice
                          ? "👉 ${loc.t('turnSelectPawn')}"
                          : "🎲 ${loc.t('turnRoll')}"),
                  style: TextStyle(color: theme.accentGold, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogView() {
    final theme = _controller.theme;
    final loc = LocalizationService.instance;
    final lang = loc.currentLanguage;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: theme.isDark ? 0.92 : 1.0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.cardBorder),
      ),
      child: ListView.builder(
        itemCount: _controller.logs.length,
        itemBuilder: (context, i) {
          final logEntry = _controller.logs[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              logEntry.getLocalized(lang),
              style: TextStyle(
                color: theme.textColor.withValues(alpha: 0.8),
                fontSize: 11.5,
              ),
            ),
          );
        },
      ),
    );
  }
}

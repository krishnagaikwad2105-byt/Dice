import 'package:flutter/material.dart';
import 'logic/game_controller.dart';
import 'widgets/board_widget.dart';
import 'widgets/player_panel_widget.dart';
import 'widgets/rules_dialog.dart';
import 'theme/game_theme.dart';

void main() {
  runApp(const ChampalPaniApp());
}

class ChampalPaniApp extends StatelessWidget {
  const ChampalPaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'चंपाळ पाणी - Champal Pani',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF140408),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE5A93C),
          secondary: Color(0xFFE63946),
          surface: Color(0xFF21060D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF26060F),
          elevation: 4,
          iconTheme: IconThemeData(color: Color(0xFFF7D070)),
          titleTextStyle: TextStyle(
            color: Color(0xFFF7D070),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const GameScreen(),
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final winner = _controller.winner!;
        return AlertDialog(
          backgroundColor: const Color(0xFF2B1408),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
          ),
          title: const Center(
            child: Text(
              "👑 विजयरथ! VICTORY! 👑",
              style: TextStyle(color: Color(0xFFF7D070), fontWeight: FontWeight.bold),
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
                "${winner.name} Won!",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${winner.side} Kingdom",
                style: const TextStyle(color: Color(0xFFF7D070), fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                "⚔️ ${winner.kills} Captures • All 4 Pawns in Swarga",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controller.startNewGame(
                    playerCount: _controller.numPlayers,
                    vsAI: true,
                  );
                },
                child: const Text("Play Again ⚔️", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNewGameDialog() {
    int selectedPlayers = _controller.numPlayers;
    bool vsAI = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF241208),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFD4AF37)),
              ),
              title: const Text(
                "⚔️ New Game Setup",
                style: TextStyle(color: Color(0xFFF7D070)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Game Mode:", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  DropdownButton<bool>(
                    value: vsAI,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2E170A),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("You vs AI Bots 🤖")),
                      DropdownMenuItem(value: false, child: Text("Pass & Play (Multiplayer) 👥")),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => vsAI = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text("Number of Players:", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  DropdownButton<int>(
                    value: selectedPlayers,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2E170A),
                    items: const [
                      DropdownMenuItem(value: 2, child: Text("2 Players (South vs North)")),
                      DropdownMenuItem(value: 3, child: Text("3 Players")),
                      DropdownMenuItem(value: 4, child: Text("4 Players (Full Board)")),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedPlayers = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE63946),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _controller.startNewGame(
                      playerCount: selectedPlayers,
                      vsAI: vsAI,
                    );
                  },
                  child: const Text("Start Match 🎲"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showThemeSelectorDialog() {
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
                side: BorderSide(color: activeTheme.accentGold, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text("🎨 "),
                  Text(
                    "थीम निवडा / Game Theme",
                    style: TextStyle(
                      color: activeTheme.accentGold,
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

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? th.cardCurrentPlayerBg
                              : th.boardBg.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? th.accentGold : th.cardBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
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
                            "${th.name} (${th.marathiName})",
                            style: TextStyle(
                              color: isSelected ? th.accentGold : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                th.description,
                                style: const TextStyle(color: Colors.white70, fontSize: 10.5),
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
                              ? Icon(Icons.check_circle, color: th.accentGold)
                              : null,
                          onTap: () {
                            _controller.setTheme(th);
                            setDialogState(() {});
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeTheme.accentGold,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Done / पूर्ण", style: TextStyle(fontWeight: FontWeight.bold)),
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
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 900;
        final theme = _controller.theme;

        return Scaffold(
          backgroundColor: theme.scaffoldBg,
          appBar: AppBar(
            backgroundColor: theme.appBarBg,
            iconTheme: IconThemeData(color: theme.accentGold),
            title: Row(
              children: [
                Text(theme.icon),
                const SizedBox(width: 6),
                const Text("चंपाळ पाणी "),
                Text(
                  "CHAMPAL PANI",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.palette_outlined),
                tooltip: "Change Theme (थीम बदला)",
                onPressed: _showThemeSelectorDialog,
              ),
              IconButton(
                icon: const Icon(Icons.menu_book),
                tooltip: "Rules & History",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const RulesDialog(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: "New Game",
                onPressed: _showNewGameDialog,
              ),
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
                  unselectedItemColor: Colors.white38,
                  currentIndex: _selectedMobileTab,
                  onTap: (idx) => setState(() => _selectedMobileTab = idx),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view),
                      label: "Board & Toss",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shield),
                      label: "Kingdoms",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history_edu),
                      label: "Chronicle",
                    ),
                  ],
                ),
        );
      },
    );
  }

  // Desktop / Tablet 3-Column Layout
  Widget _buildDesktopLayout() {
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
                  const Text(
                    "👑 Kingdoms & Pawns",
                    style: TextStyle(
                      color: Color(0xFFF7D070),
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
                const Text(
                  "📜 Live Chronicle",
                  style: TextStyle(
                    color: Color(0xFFF7D070),
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
    switch (_selectedMobileTab) {
      case 1:
        // Kingdoms Tab
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                "👑 Kingdoms & Status",
                style: TextStyle(
                  color: Color(0xFFF7D070),
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
              const Text(
                "📜 Game History",
                style: TextStyle(
                  color: Color(0xFFF7D070),
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

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: 0.95),
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
              Text(
                "पारंपारिक फासे व सोंगट्या",
                style: TextStyle(
                  color: theme.accentGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "• ⚪ पांढरे खडे: Ivory river stones\n"
            "• ⚫ काळे खडे: Obsidian basalt stones\n"
            "• 🪵 काठ्या: Carved daayam sticks\n"
            "• 🌰 चिंचोके: Split tamarind seeds\n"
            "• 🌟 ८ = चंपाळ (Champal) Bonus Roll!\n"
            "• 🌟 ४ = चल्लास (Challas) Bonus Roll!",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnBanner() {
    final player = _controller.currentPlayer;
    final theme = _controller.theme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: player.color.withValues(alpha: 0.7), width: 1.5),
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
                  player.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  player.isAI
                      ? "🤖 Thinking..."
                      : (_controller.waitingForPawnChoice
                          ? "👉 Select a glowing pawn"
                          : "🎲 Your turn to roll"),
                  style: TextStyle(color: theme.accentGold, fontSize: 11),
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

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.surfaceBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.cardBorder),
      ),
      child: ListView.builder(
        itemCount: _controller.logs.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              _controller.logs[i],
              style: const TextStyle(color: Colors.white70, fontSize: 11.5),
            ),
          );
        },
      ),
    );
  }
}

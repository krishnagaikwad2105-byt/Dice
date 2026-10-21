import 'package:flutter/material.dart';
import 'logic/game_controller.dart';
import 'widgets/board_widget.dart';
import 'widgets/toss_arena_widget.dart';
import 'widgets/player_panel_widget.dart';
import 'widgets/rules_dialog.dart';

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
        scaffoldBackgroundColor: const Color(0xFF120904),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37),
          secondary: Color(0xFFE63946),
          surface: Color(0xFF1E1008),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF221108),
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 900;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Text("⚜️ "),
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
                  backgroundColor: const Color(0xFF1B0E06),
                  selectedItemColor: const Color(0xFFF7D070),
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
          // Left: Player Cards
          SizedBox(
            width: 260,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "👑 Kingdoms",
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
          const SizedBox(width: 16),

          // Center: Board & Turn Banner
          Expanded(
            child: Column(
              children: [
                _buildTurnBanner(),
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: BoardWidget(controller: _controller),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Toss Arena & Live Log
          SizedBox(
            width: 280,
            child: Column(
              children: [
                TossArenaWidget(controller: _controller),
                const SizedBox(height: 12),
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
              const SizedBox(height: 10),
              TossArenaWidget(controller: _controller),
            ],
          ),
        );
    }
  }

  Widget _buildTurnBanner() {
    final player = _controller.currentPlayer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xDD241409),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: player.color.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: player.color,
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
                  style: const TextStyle(color: Color(0xFFF7D070), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogView() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0x99180E07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
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

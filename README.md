# 🎲 चंपाळ पाणी (Champal Pani) — Flutter Edition

An authentic, cross-platform **Flutter** implementation of **Champal Pani** (also known as *Champool*, *Challas Aath*, or *Pat Sogayya* in Maharashtra), the ancient Indian cross-and-circle board game from the *Pachisi / Chowka Bhara* family.

---

## 📁 Project Architecture

```
Dice/ (Flutter Project Root)
├── pubspec.yaml                     # Flutter dependencies and asset registrations
├── README.md                        # Documentation and run instructions
├── assets/                          # Heritage teakwood texture and media
│   └── board_bg.jpg
└── lib/
    ├── main.dart                    # App entry point, responsive layouts, victory & setup dialogs
    ├── models/
    │   ├── pawn.dart                # Pawn model (stepIndex 0..24, isHome)
    │   ├── player.dart              # Player model (avatar, color, kills, hasPani)
    │   └── board_paths.dart         # 25-step paths for 4 kingdoms & safe squares
    ├── logic/
    │   └── game_controller.dart     # ChangeNotifier state manager (rolls, captures, Pani rules, AI bot)
    └── widgets/
        ├── board_widget.dart        # 5x5 Sacred Board Grid with interactive pulsating pawns
        ├── cowrie_shell_widget.dart # CustomPainter 3D Cowrie Shell (open teeth vs. closed dome)
        ├── toss_arena_widget.dart   # Brass toss dish, roll action button & outcomes
        ├── player_panel_widget.dart # Player kingdom cards, kills & live Pani status
        └── rules_dialog.dart        # Bilingual English & Marathi rules modal
```

---

## 🌟 Key Features

- **Heritage Aesthetics:** Warm teakwood theme, gold brass inlays, water-rippled "पाणी" cells, and center Swarga mandala.
- **Custom-Painted Cowrie Shells (कवड्या):** Drawn with Flutter's `CustomPainter` for crisp rendering at any screen density.
- **Authentic Maharashtrian Rules:**
  - 5x5 board with safe cross-marked starting sanctuaries (घरे).
  - Counter-clockwise outer perimeter traversal.
  - **The "PANI" Sacred Rule:** Entering the inner water stream ("पाण्यात जाणे") towards Swarga is locked until you capture ("kill") at least one opponent pawn!
  - Exact roll required to enter the central winning square (**स्वर्ग / Swarga**).
- **Game Modes:**
  - **Single Player vs Smart AI Bots:** Intelligent heuristic AI with tactical danger avoidance, hunting priority, and path optimization.
  - **Pass & Play Local Multiplayer:** 2, 3, or 4 players on the same device.
- **Adaptive Responsive Design:**
  - Phone UI: Bottom navigation (`Board & Toss`, `Kingdoms`, `Chronicle`).
  - Tablet/Desktop UI: Adaptive 3-column layout.
- **Haptic Feedback:** Native vibration feedback when tossing shells and capturing enemy pieces.

---

## 🚀 How to Run

From this project directory (`c:\Users\Baap\Desktop\Dice`):

```bash
flutter pub get
flutter run
```

### Supported Platforms:
- 📱 **Android** (`flutter run -d android`)
- 🍏 **iOS** (`flutter run -d ios`)
- 💻 **Windows Desktop** (`flutter run -d windows`)
- 🌐 **Web** (`flutter run -d chrome`)

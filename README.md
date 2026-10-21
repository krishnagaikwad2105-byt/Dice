# चंपाळ पाणी (Champal Pani) — Traditional Maharashtrian Board Game

An authentic, modern web edition of **Champal Pani** (also known as *Champool*, *Challas Aath*, or *Pat Sogayya* in Maharashtra), the ancient Indian cross-and-circle strategy game from the *Pachisi / Chowka Bhara* family.

---

## 🌟 Game Highlights

- **Heritage Indian Design:** Teakwood board finish, brass inlays, authentic Kolam & Mandala motifs, and warm candlelight ambiance.
- **3D Cowrie Shells (कवड्या):** Realistic SVG-modeled shells with 3D physics toss animations and natural organic landing scatter.
- **Zero-Dependency Procedural Audio:** Authentic wooden pawn taps, shell rattling clatters, capture impacts, water ripple chimes, and victory fanfare synthesized via Web Audio API.
- **Authentic Maharashtrian Rules:**
  - 5x5 board with safe cross-marked starting sanctuaries (घरे).
  - Counter-clockwise outer perimeter traversal.
  - **The "PANI" Sacred Rule:** Entering the inner water stream ("पाण्यात जाणे") towards Swarga is strictly locked until you capture ("kill") at least one opponent pawn!
  - Exact roll required to enter the central winning square (**स्वर्ग / Swarga**).
- **Game Modes:**
  - **Single Player vs Smart AI Bots:** Intelligent heuristic AI with tactical danger avoidance, hunting priority, and path optimization.
  - **Pass & Play Local Multiplayer:** 2, 3, or 4 players on the same device.
- **Interactive UI:** Glowing beacons for movable pawns, destination preview rings on hover, real-time live game chronicle, and bilingual rules reference (English & Marathi).

---

## 🐚 Cowrie Shell Toss Scoring (कवडी डाव)

| Shells Landing Mouth-Up (Open) | Movement Value | Bonus Roll? |
| :--- | :--- | :--- |
| **1 Open** | 1 Step | No |
| **2 Open** | 2 Steps | No |
| **3 Open** | 3 Steps | No |
| **4 Open** | 4 Steps | 🌟 **Extra Roll!** |
| **0 Open (All 4 Mouths Down)** | **8 Steps (Champool / चंपाळ!)** | 🌟 **Extra Roll!** |

> **Extra Turns:** A player earns an extra roll whenever they roll a **4**, roll an **8**, **capture an opponent piece**, or guide a pawn into **Swarga (Center Home)**!

---

## 🚀 Running the Game Locally

### Option 1: Live Server (Already running)
Open your browser and navigate to:
```
http://localhost:8080
```

### Option 2: Direct File Open
You can directly double-click and open [`index.html`](file:///c:/Users/Baap/Desktop/Dice/index.html) in Chrome, Edge, Firefox, or Safari without installing anything!

### Option 3: Terminal Command
```bash
node server.js
```
or
```bash
npx serve .
```

---

## 📁 Project Structure

- [`index.html`](file:///c:/Users/Baap/Desktop/Dice/index.html): Semantic HTML5 board layout, toss dish, player cards, and modals.
- [`style.css`](file:///c:/Users/Baap/Desktop/Dice/style.css): Custom heritage design system, 3D animations, and responsive layout.
- [`game.js`](file:///c:/Users/Baap/Desktop/Dice/game.js): Core game engine, 25-step player paths, Pani verification, capture logic, and smart AI bot.
- [`app.js`](file:///c:/Users/Baap/Desktop/Dice/app.js): DOM controller, 3D shell animations, pawn movement coordination, and event handling.
- [`audio.js`](file:///c:/Users/Baap/Desktop/Dice/audio.js): Procedural Web Audio synthesizer (zero external dependencies).
- [`server.js`](file:///c:/Users/Baap/Desktop/Dice/server.js): Built-in zero-dependency local static HTTP server.
- [`assets/board_bg.jpg`](file:///c:/Users/Baap/Desktop/Dice/assets/board_bg.jpg): High-resolution Indian teakwood game table background.

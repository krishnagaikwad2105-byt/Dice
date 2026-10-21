/**
 * Champal Pani (चंपाळ पाणी / चंपूल) - Core Game Engine
 * 5x5 Maharashtrian Traditional Board Game
 */

// 5x5 Board Coordinate Paths for 4 Players
// 0: South (Red), 1: West (Green), 2: North (Yellow), 3: East (Blue)
const PLAYER_CONFIG = [
  {
    id: 0,
    name: "Surya (Red)",
    marathiName: "सूर्य (लाल)",
    color: "#e63946",
    colorLight: "#ff6b6b",
    colorDark: "#9d0208",
    avatar: "👑",
    startCoord: [4, 2],
    side: "South"
  },
  {
    id: 1,
    name: "Vana (Green)",
    marathiName: "वन (हिरवा)",
    color: "#2a9d8f",
    colorLight: "#48cae4",
    colorDark: "#1b4332",
    avatar: "🌿",
    startCoord: [2, 0],
    side: "West"
  },
  {
    id: 2,
    name: "Suvarna (Gold)",
    marathiName: "सुवर्ण (पिवळा)",
    color: "#e76f51",
    colorLight: "#f4a261",
    colorDark: "#bc4749",
    avatar: "☀️",
    startCoord: [0, 2],
    side: "North"
  },
  {
    id: 3,
    name: "Mayur (Blue)",
    marathiName: "मयूर (निळा)",
    color: "#3a86ff",
    colorLight: "#00b4d8",
    colorDark: "#03045e",
    avatar: "🦚",
    startCoord: [2, 4],
    side: "East"
  }
];

// Safe Squares (Ghar / Safe Zones)
const SAFE_SQUARES = [
  [4, 2], // South Home
  [2, 0], // West Home
  [0, 2], // North Home
  [2, 4], // East Home
  [2, 2]  // Center Home (Swarga)
];

// Complete 25-step paths for each player:
// Steps 0..15 = Outer Ring (Anti-Clockwise)
// Steps 16..23 = Inner Ring / Pani (Clockwise)
// Step 24 = Center Home [2,2]
const PLAYER_PATHS = [
  // Player 0: South (Start [4,2])
  [
    [4, 2], [4, 3], [4, 4], [3, 4], [2, 4], [1, 4], [0, 4], [0, 3],
    [0, 2], [0, 1], [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [4, 1],
    // Inner track (Pani)
    [3, 1], [2, 1], [1, 1], [1, 2], [1, 3], [2, 3], [3, 3], [3, 2],
    // Center Home
    [2, 2]
  ],

  // Player 1: West (Start [2,0])
  [
    [2, 0], [3, 0], [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [3, 4],
    [2, 4], [1, 4], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0], [1, 0],
    // Inner track (Pani)
    [1, 1], [1, 2], [1, 3], [2, 3], [3, 3], [3, 2], [3, 1], [2, 1],
    // Center Home
    [2, 2]
  ],

  // Player 2: North (Start [0,2])
  [
    [0, 2], [0, 1], [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [4, 1],
    [4, 2], [4, 3], [4, 4], [3, 4], [2, 4], [1, 4], [0, 4], [0, 3],
    // Inner track (Pani)
    [1, 3], [2, 3], [3, 3], [3, 2], [3, 1], [2, 1], [1, 1], [1, 2],
    // Center Home
    [2, 2]
  ],

  // Player 3: East (Start [2,4])
  [
    [2, 4], [1, 4], [0, 4], [0, 3], [0, 2], [0, 1], [0, 0], [1, 0],
    [2, 0], [3, 0], [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [3, 4],
    // Inner track (Pani)
    [3, 3], [3, 2], [3, 1], [2, 1], [1, 1], [1, 2], [1, 3], [2, 3],
    // Center Home
    [2, 2]
  ]
];

class ChampalPaniGame {
  constructor() {
    this.numPlayers = 4;
    this.players = [];
    this.currentPlayerIdx = 0;
    this.currentRoll = null; // number: 1, 2, 3, 4, 8
    this.shells = [0, 0, 0, 0]; // 0=closed (flat), 1=open (mouth up)
    this.isRolling = false;
    this.isMovingPawn = false;
    this.waitingForPawnChoice = false;
    this.validPawnIndices = [];
    this.winner = null;
    this.history = [];
    this.gameStarted = false;
  }

  // Initialize new game session
  startNewGame(config = {}) {
    this.numPlayers = config.numPlayers || 4;
    this.players = [];

    for (let i = 0; i < this.numPlayers; i++) {
      const isAI = config.aiConfig ? config.aiConfig[i] : (i > 0);
      this.players.push({
        id: i,
        name: config.playerNames?.[i] || PLAYER_CONFIG[i].name,
        marathiName: PLAYER_CONFIG[i].marathiName,
        color: PLAYER_CONFIG[i].color,
        colorLight: PLAYER_CONFIG[i].colorLight,
        colorDark: PLAYER_CONFIG[i].colorDark,
        avatar: PLAYER_CONFIG[i].avatar,
        side: PLAYER_CONFIG[i].side,
        isAI: isAI,
        hasPani: false, // Unlocked once at least 1 kill is scored
        kills: 0,
        // Each player has 4 pawns. stepIndex: 0 = start safe square, 24 = home
        pawns: [
          { id: 0, stepIndex: 0, isHome: false },
          { id: 1, stepIndex: 0, isHome: false },
          { id: 2, stepIndex: 0, isHome: false },
          { id: 3, stepIndex: 0, isHome: false }
        ]
      });
    }

    this.currentPlayerIdx = 0;
    this.currentRoll = null;
    this.shells = [1, 0, 1, 0];
    this.isRolling = false;
    this.isMovingPawn = false;
    this.waitingForPawnChoice = false;
    this.validPawnIndices = [];
    this.winner = null;
    this.history = [];
    this.gameStarted = true;

    this.addLog(`🎉 New Game began with ${this.numPlayers} players! Good luck.`);
    this.checkAITurn();
  }

  // Roll the 4 Cowrie Shells
  rollCowries() {
    if (this.isRolling || this.isMovingPawn || this.waitingForPawnChoice || this.winner) {
      return null;
    }

    this.isRolling = true;
    if (window.soundEngine) window.soundEngine.playRattle();

    // 4 Cowrie shells: each has 50% probability of landing open/closed
    const shells = [
      Math.random() < 0.5 ? 1 : 0,
      Math.random() < 0.5 ? 1 : 0,
      Math.random() < 0.5 ? 1 : 0,
      Math.random() < 0.5 ? 1 : 0
    ];
    this.shells = shells;

    // Value calculation:
    // 1 open = 1
    // 2 open = 2
    // 3 open = 3
    // 4 open = 4 (Bonus roll!)
    // 0 open = 8 (Champool! Bonus roll!)
    const openCount = shells.reduce((sum, s) => sum + s, 0);
    let rollValue = openCount;
    if (openCount === 0) {
      rollValue = 8;
    }

    this.currentRoll = rollValue;
    return {
      shells,
      value: rollValue,
      isOpenCount: openCount,
      isBonusRoll: (rollValue === 4 || rollValue === 8)
    };
  }

  // Finalize roll outcome after shell toss animation completes
  finishRollAnimation() {
    this.isRolling = false;
    if (window.soundEngine) window.soundEngine.playRollLand(this.currentRoll);

    const player = this.players[this.currentPlayerIdx];
    const isBonus = (this.currentRoll === 4 || this.currentRoll === 8);
    const rollDesc = this.currentRoll === 8 ? "8 (चंपाळ / Champool!)" : this.currentRoll;
    this.addLog(`${player.avatar} <strong>${player.name}</strong> rolled <strong>${rollDesc}</strong>${isBonus ? ' 🌟 <em>Bonus Roll!</em>' : ''}`);

    if (isBonus && window.soundEngine) {
      window.soundEngine.playBonus();
    }

    // Determine valid moves for the current roll
    this.validPawnIndices = this.getValidPawnsForRoll(this.currentPlayerIdx, this.currentRoll);

    if (this.validPawnIndices.length === 0) {
      this.addLog(`❌ No valid moves for ${player.name} with roll ${this.currentRoll}.`);
      this.currentRoll = null;
      this.nextTurn(!isBonus);
      return;
    }

    // If only 1 valid pawn exists, we can still let player or AI select it
    this.waitingForPawnChoice = true;

    // If active player is AI, schedule AI decision
    if (player.isAI) {
      setTimeout(() => {
        this.makeAIDecision();
      }, 700);
    }
  }

  // Get list of pawn indices that can legally move with the given roll
  getValidPawnsForRoll(playerIdx, roll) {
    const player = this.players[playerIdx];
    const valid = [];

    for (let pIdx = 0; pIdx < player.pawns.length; pIdx++) {
      const pawn = player.pawns[pIdx];
      if (pawn.isHome) continue; // Already in Swarga (Center Home)

      const targetStep = this.calculateTargetStep(player, pawn.stepIndex, roll);
      if (targetStep !== null) {
        valid.push(pIdx);
      }
    }
    return valid;
  }

  // Calculate the destination step index along player's path
  calculateTargetStep(player, currentStep, roll) {
    // If already in center
    if (currentStep >= 24) return null;

    // Check inner track / center boundaries
    if (currentStep >= 16) {
      // In inner track (steps 16..23)
      const target = currentStep + roll;
      if (target === 24) return 24; // Lands in center home!
      if (target < 24) return target; // Advances in inner track
      return null; // Overshoots home, cannot move!
    }

    // Currently in outer ring (steps 0..15)
    if (player.hasPani) {
      // Has killed an opponent! Can enter inner track (Pani)
      const rawTarget = currentStep + roll;
      if (rawTarget > 24) return null; // Overshoot check
      return rawTarget;
    } else {
      // Has NOT unlocked Pani yet!
      // Must stay in outer ring (wrap around 0..15)
      const targetInOuter = (currentStep + roll) % 16;
      return targetInOuter;
    }
  }

  // Get intermediate step path for step-by-step hopping animation
  getHopPath(playerIdx, startStep, endStep, roll) {
    const player = this.players[playerIdx];
    const hops = [];
    let cur = startStep;

    for (let i = 1; i <= roll; i++) {
      if (player.hasPani) {
        cur++;
        hops.push(cur);
      } else {
        if (cur < 16) {
          cur = (cur + 1) % 16;
          hops.push(cur);
        } else {
          cur++;
          hops.push(cur);
        }
      }
    }
    return hops;
  }

  // Move a chosen pawn
  async movePawn(pawnIdx, onStepCallback) {
    if (!this.waitingForPawnChoice || this.isMovingPawn) return false;
    if (!this.validPawnIndices.includes(pawnIdx)) return false;

    this.waitingForPawnChoice = false;
    this.isMovingPawn = true;

    const player = this.players[this.currentPlayerIdx];
    const pawn = player.pawns[pawnIdx];
    const startStep = pawn.stepIndex;
    const roll = this.currentRoll;
    const targetStep = this.calculateTargetStep(player, startStep, roll);

    const hopSteps = this.getHopPath(this.currentPlayerIdx, startStep, targetStep, roll);

    // Step-by-step hopping animation
    for (const step of hopSteps) {
      pawn.stepIndex = step;
      if (window.soundEngine) window.soundEngine.playPawnStep();
      if (onStepCallback) onStepCallback(pawnIdx, step);
      await new Promise(r => setTimeout(r, 160));
    }

    pawn.stepIndex = targetStep;
    const finalCoord = PLAYER_PATHS[this.currentPlayerIdx][targetStep];

    // Check if reached Central Home
    let reachedHome = false;
    if (targetStep === 24) {
      pawn.isHome = true;
      reachedHome = true;
      if (window.soundEngine) window.soundEngine.playPawnHome();
      this.addLog(`🏆 ${player.avatar} <strong>${player.name}</strong>'s pawn reached <strong>Center Home!</strong>`);
    }

    // Check capture on final destination
    let captured = false;
    if (!this.isSafeSquare(finalCoord) && !pawn.isHome) {
      captured = this.checkCapture(finalCoord, this.currentPlayerIdx);
    }

    // Check game winning condition: all 4 pawns home
    const allHome = player.pawns.every(p => p.isHome);
    if (allHome) {
      this.winner = player;
      this.isMovingPawn = false;
      this.currentRoll = null;
      if (window.soundEngine) window.soundEngine.playVictory();
      this.addLog(`👑🎊 <strong>${player.name} HAS WON THE GAME!</strong> 🎊👑`);
      return { winner: player };
    }

    // Extra Turn logic:
    // Bonus turn granted if:
    // 1. Rolled 4 or 8
    // 2. Captured an enemy pawn
    // 3. Reached home
    const rolledBonus = (roll === 4 || roll === 8);
    const getsBonusTurn = rolledBonus || captured || reachedHome;

    this.isMovingPawn = false;
    this.currentRoll = null;

    if (getsBonusTurn) {
      this.addLog(`✨ <strong>${player.name}</strong> earns an <strong>Extra Roll!</strong>`);
      this.checkAITurn();
    } else {
      this.nextTurn(true);
    }

    return { captured, reachedHome, getsBonusTurn };
  }

  // Check if a coordinate is a safe sanctuary square
  isSafeSquare(coord) {
    return SAFE_SQUARES.some(s => s[0] === coord[0] && s[1] === coord[1]);
  }

  // Check and process opponent capture at coordinate
  checkCapture(coord, activePlayerIdx) {
    let capturedAny = false;
    const activePlayer = this.players[activePlayerIdx];

    for (let pIdx = 0; pIdx < this.players.length; pIdx++) {
      if (pIdx === activePlayerIdx) continue;
      const otherPlayer = this.players[pIdx];

      for (const enemyPawn of otherPlayer.pawns) {
        if (enemyPawn.isHome) continue;
        const enemyCoord = PLAYER_PATHS[pIdx][enemyPawn.stepIndex];
        
        if (enemyCoord[0] === coord[0] && enemyCoord[1] === coord[1]) {
          // Captured! Send back to starting safe square (step 0)
          enemyPawn.stepIndex = 0;
          capturedAny = true;
          activePlayer.kills++;

          if (window.soundEngine) window.soundEngine.playCapture();
          this.addLog(`⚔️ <strong>${activePlayer.name}</strong> captured <strong>${otherPlayer.name}</strong>'s pawn! Sent back to home base!`);

          // Unlock PANI if this is their first kill
          if (!activePlayer.hasPani) {
            activePlayer.hasPani = true;
            if (window.soundEngine) window.soundEngine.playPaniUnlock();
            this.addLog(`🌊 <strong>${activePlayer.avatar} ${activePlayer.name}</strong> unlocked <strong>PANI (पाण्यात जाणे)!</strong> Now eligible to enter the inner track!`);
          }
          break;
        }
      }
    }
    return capturedAny;
  }

  // Advance to next player's turn
  nextTurn(advancePlayer = true) {
    if (advancePlayer) {
      this.currentPlayerIdx = (this.currentPlayerIdx + 1) % this.numPlayers;
    }
    this.currentRoll = null;
    this.validPawnIndices = [];
    this.waitingForPawnChoice = false;
    this.isRolling = false;
    this.isMovingPawn = false;

    this.checkAITurn();
  }

  // AI Turn Handler
  checkAITurn() {
    if (this.winner) return;
    const player = this.players[this.currentPlayerIdx];
    if (player.isAI && !this.isRolling && !this.isMovingPawn && !this.waitingForPawnChoice) {
      setTimeout(() => {
        if (!this.winner && this.players[this.currentPlayerIdx].isAI) {
          const rollResult = this.rollCowries();
          if (rollResult && window.onAIRollTriggered) {
            window.onAIRollTriggered(rollResult);
          }
        }
      }, 900);
    }
  }

  // Smart Heuristic AI Decision Maker
  makeAIDecision() {
    if (!this.waitingForPawnChoice || this.validPawnIndices.length === 0) return;
    const player = this.players[this.currentPlayerIdx];

    let bestPawnIdx = this.validPawnIndices[0];
    let highestScore = -Infinity;

    for (const pIdx of this.validPawnIndices) {
      const pawn = player.pawns[pIdx];
      const targetStep = this.calculateTargetStep(player, pawn.stepIndex, this.currentRoll);
      const targetCoord = PLAYER_PATHS[this.currentPlayerIdx][targetStep];
      const currentCoord = PLAYER_PATHS[this.currentPlayerIdx][pawn.stepIndex];

      let score = 0;

      // 1. Winning the pawn into Swarga (Center Home)
      if (targetStep === 24) {
        score += 2000;
      }

      // 2. Capturing an opponent pawn
      if (!this.isSafeSquare(targetCoord) && targetStep < 24) {
        const canCapture = this.wouldCapture(targetCoord, this.currentPlayerIdx);
        if (canCapture) {
          score += 800;
          // Huge priority if AI doesn't have Pani yet!
          if (!player.hasPani) {
            score += 1500;
          }
        }
      }

      // 3. Advancing into Pani (inner ring)
      if (player.hasPani && pawn.stepIndex < 16 && targetStep >= 16) {
        score += 350;
      }

      // 4. Moving out of danger (if current square is unsafe and enemy is lurking behind)
      if (!this.isSafeSquare(currentCoord)) {
        if (this.isPawnInDanger(currentCoord, this.currentPlayerIdx)) {
          score += 250;
        }
      }

      // 5. Landing on a Safe Square
      if (this.isSafeSquare(targetCoord)) {
        score += 180;
      }

      // 6. Avoid landing in immediate danger
      if (!this.isSafeSquare(targetCoord)) {
        if (this.wouldBeInDanger(targetCoord, this.currentPlayerIdx)) {
          score -= 220;
        }
      }

      // 7. General forward progress
      score += (targetStep - pawn.stepIndex) * 15;

      // Random tie breaker
      score += Math.random() * 20;

      if (score > highestScore) {
        highestScore = score;
        bestPawnIdx = pIdx;
      }
    }

    if (window.onAIMoveSelected) {
      window.onAIMoveSelected(bestPawnIdx);
    }
  }

  // Check if landing at coord would capture an opponent
  wouldCapture(coord, playerIdx) {
    for (let i = 0; i < this.players.length; i++) {
      if (i === playerIdx) continue;
      for (const p of this.players[i].pawns) {
        if (p.isHome) continue;
        const enemyCoord = PLAYER_PATHS[i][p.stepIndex];
        if (enemyCoord[0] === coord[0] && enemyCoord[1] === coord[1]) {
          return true;
        }
      }
    }
    return false;
  }

  // Check if pawn at coord can be captured by nearby enemies
  isPawnInDanger(coord, playerIdx) {
    for (let i = 0; i < this.players.length; i++) {
      if (i === playerIdx) continue;
      const other = this.players[i];
      for (const p of other.pawns) {
        if (p.isHome) continue;
        // Check if enemy is within 1,2,3,4,8 steps behind
        for (const r of [1, 2, 3, 4, 8]) {
          const enemyTarget = this.calculateTargetStep(other, p.stepIndex, r);
          if (enemyTarget !== null) {
            const enemyCoord = PLAYER_PATHS[i][enemyTarget];
            if (enemyCoord[0] === coord[0] && enemyCoord[1] === coord[1]) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  // Check if moving to targetCoord exposes the pawn to danger
  wouldBeInDanger(targetCoord, playerIdx) {
    return this.isPawnInDanger(targetCoord, playerIdx);
  }

  addLog(msg) {
    this.history.unshift(msg);
    if (this.history.length > 40) this.history.pop();
    if (window.onGameLogUpdated) {
      window.onGameLogUpdated(msg);
    }
  }
}

window.ChampalPaniGame = ChampalPaniGame;

/**
 * Champal Pani - Application & UI Controller
 * Renders the 5x5 board, 3D Cowrie Shells, animations, and handles player interactions
 */

document.addEventListener("DOMContentLoaded", () => {
  const game = new ChampalPaniGame();
  window.currentGame = game;

  // DOM Elements
  const boardEl = document.getElementById("gameBoard");
  const shellContainerEl = document.getElementById("shellContainer");
  const rollBtn = document.getElementById("rollBtn");
  const rollStatusEl = document.getElementById("rollStatus");
  const currentTurnBannerEl = document.getElementById("currentTurnBanner");
  const playerPanelsContainer = document.getElementById("playerPanels");
  const logFeedEl = document.getElementById("logFeed");
  const soundToggleBtn = document.getElementById("soundToggleBtn");
  const rulesModal = document.getElementById("rulesModal");
  const newGameModal = document.getElementById("newGameModal");
  const victoryModal = document.getElementById("victoryModal");

  // State
  let hoveredPawnTarget = null;

  // Initialize UI & Event Listeners
  init();

  function init() {
    setupModals();
    setupSoundToggle();
    setupKeyboardControls();
    setupMobileTabs();
    setupTouchAudioUnlock();

    // Start default game: 1 Human vs 3 AI bots
    game.startNewGame({
      numPlayers: 4,
      aiConfig: [false, true, true, true] // Player 0 is Human, others AI
    });

    renderBoardGrid();
    renderPlayerPanels();
    renderShells([1, 0, 1, 0], false);
    updateTurnDisplay();
    updateBoardPawns();
  }

  // Mobile Tab Switcher for phones and tablets
  function setupMobileTabs() {
    const tabBtns = document.querySelectorAll(".mobile-tab-btn");
    const arenaEl = document.querySelector(".arena-center");
    const leftEl = document.querySelector(".sidebar-left");
    const rightEl = document.querySelector(".sidebar-right");

    tabBtns.forEach(btn => {
      btn.addEventListener("click", () => {
        tabBtns.forEach(b => b.classList.remove("active"));
        btn.classList.add("active");
        const target = btn.dataset.target;

        if (target === "arena-center") {
          arenaEl.classList.remove("mobile-hidden");
          leftEl.classList.remove("mobile-active");
          rightEl.classList.remove("mobile-active");
        } else if (target === "sidebar-left") {
          arenaEl.classList.add("mobile-hidden");
          leftEl.classList.add("mobile-active");
          rightEl.classList.remove("mobile-active");
        } else if (target === "sidebar-right") {
          arenaEl.classList.add("mobile-hidden");
          leftEl.classList.remove("mobile-active");
          rightEl.classList.add("mobile-active");
        }
      });
    });
  }

  // Mobile Web Audio unlock on initial gesture
  function setupTouchAudioUnlock() {
    const unlock = () => {
      if (window.soundEngine) window.soundEngine.ensureContext();
      window.removeEventListener("touchstart", unlock);
      window.removeEventListener("pointerdown", unlock);
    };
    window.addEventListener("touchstart", unlock, { passive: true });
    window.addEventListener("pointerdown", unlock, { passive: true });
  }

  // Mobile Haptic Vibration Feedback
  function triggerHaptic(pattern) {
    if (typeof navigator !== "undefined" && navigator.vibrate) {
      try {
        navigator.vibrate(pattern);
      } catch (e) {}
    }
  }

  // Keyboard shortcut: Spacebar to roll kavadis
  function setupKeyboardControls() {
    window.addEventListener("keydown", (e) => {
      if (e.code === "Space" && !e.target.matches("input, textarea, button")) {
        e.preventDefault();
        handleUserRoll();
      }
    });
  }

  // Render the 5x5 grid cells
  function renderBoardGrid() {
    boardEl.innerHTML = "";

    for (let r = 0; r < 5; r++) {
      for (let c = 0; c < 5; c++) {
        const cell = document.createElement("div");
        cell.className = "board-cell";
        cell.dataset.row = r;
        cell.dataset.col = c;
        cell.id = `cell-${r}-${c}`;

        // Classify cell type
        const isCenter = (r === 2 && c === 2);
        const isSouthHome = (r === 4 && c === 2);
        const isWestHome = (r === 2 && c === 0);
        const isNorthHome = (r === 0 && c === 2);
        const isEastHome = (r === 2 && c === 4);
        const isSafe = isCenter || isSouthHome || isWestHome || isNorthHome || isEastHome;

        // Check if part of the inner "Pani" track (rows 1..3, cols 1..3, except center)
        const isPaniStream = (r >= 1 && r <= 3 && c >= 1 && c <= 3 && !isCenter);

        if (isCenter) {
          cell.classList.add("cell-center-home");
          cell.innerHTML = `
            <div class="center-mandala">
              <div class="swarga-title">स्वर्ग<br><span>HOME</span></div>
            </div>
            <div class="pawn-container"></div>
          `;
        } else if (isSafe) {
          cell.classList.add("cell-safe");
          let homeClass = "";
          let label = "SAFE";
          if (isSouthHome) { homeClass = "home-south"; label = "START"; }
          if (isWestHome) { homeClass = "home-west"; label = "START"; }
          if (isNorthHome) { homeClass = "home-north"; label = "START"; }
          if (isEastHome) { homeClass = "home-east"; label = "START"; }
          
          cell.classList.add(homeClass);
          cell.innerHTML = `
            <div class="safe-mark-wrapper">
              <div class="safe-cross">✕</div>
              <span class="safe-sub">${label}</span>
            </div>
            <div class="pawn-container"></div>
          `;
        } else if (isPaniStream) {
          cell.classList.add("cell-pani");
          cell.innerHTML = `
            <div class="pani-watermark">≈ पाणी ≈</div>
            <div class="pawn-container"></div>
          `;
        } else {
          cell.classList.add("cell-outer");
          cell.innerHTML = `
            <div class="pawn-container"></div>
          `;
        }

        boardEl.appendChild(cell);
      }
    }
  }

  // Update pawn pieces placed onto board cells
  function updateBoardPawns() {
    // Clear all pawn containers
    document.querySelectorAll(".pawn-container").forEach(el => el.innerHTML = "");

    // Clear previous cell highlight states
    document.querySelectorAll(".board-cell").forEach(el => {
      el.classList.remove("target-preview", "source-active");
    });

    const activePlayer = game.players[game.currentPlayerIdx];

    // Group pawns by cell coordinate [r, c]
    const cellsWithPawns = {};

    game.players.forEach((player, pIdx) => {
      player.pawns.forEach((pawn, pawnIdx) => {
        let coord;
        if (pawn.isHome) {
          coord = [2, 2]; // In Center
        } else {
          coord = PLAYER_PATHS[pIdx][pawn.stepIndex];
        }

        const key = `${coord[0]}-${coord[1]}`;
        if (!cellsWithPawns[key]) cellsWithPawns[key] = [];

        cellsWithPawns[key].push({
          player,
          pawn,
          pIdx,
          pawnIdx,
          isSelectable: (
            game.waitingForPawnChoice &&
            pIdx === game.currentPlayerIdx &&
            game.validPawnIndices.includes(pawnIdx) &&
            !player.isAI
          )
        });
      });
    });

    // Render grouped pawns into corresponding cell containers
    Object.keys(cellsWithPawns).forEach(key => {
      const pawns = cellsWithPawns[key];
      const cell = document.getElementById(`cell-${key}`);
      if (!cell) return;
      const container = cell.querySelector(".pawn-container");
      if (!container) return;

      container.dataset.count = pawns.length;

      pawns.forEach(item => {
        const pieceEl = document.createElement("div");
        pieceEl.className = `pawn-piece player-${item.pIdx}`;
        pieceEl.style.setProperty("--p-color", item.player.color);
        pieceEl.style.setProperty("--p-light", item.player.colorLight);
        pieceEl.style.setProperty("--p-dark", item.player.colorDark);

        pieceEl.innerHTML = `
          <div class="pawn-body">
            <span class="pawn-avatar">${item.player.avatar}</span>
          </div>
          <div class="pawn-shadow"></div>
        `;

        if (item.isSelectable) {
          pieceEl.classList.add("selectable");
          pieceEl.title = `Click to move this pawn (${game.currentRoll} steps)`;

          // Hover preview of target destination
          pieceEl.addEventListener("mouseenter", () => {
            const targetStep = game.calculateTargetStep(item.player, item.pawn.stepIndex, game.currentRoll);
            if (targetStep !== null) {
              const targetCoord = PLAYER_PATHS[item.pIdx][targetStep];
              highlightTargetCell(targetCoord);
              cell.classList.add("source-active");
            }
          });

          pieceEl.addEventListener("mouseleave", () => {
            clearTargetHighlight();
            cell.classList.remove("source-active");
          });

          // Pawn click handler to trigger move
          pieceEl.addEventListener("click", (e) => {
            e.stopPropagation();
            clearTargetHighlight();
            executePawnMove(item.pawnIdx);
          });
        }

        container.appendChild(pieceEl);
      });
    });
  }

  // Highlight preview of destination cell
  function highlightTargetCell(coord) {
    clearTargetHighlight();
    const cell = document.getElementById(`cell-${coord[0]}-${coord[1]}`);
    if (cell) {
      cell.classList.add("target-preview");
      hoveredPawnTarget = cell;
    }
  }

  function clearTargetHighlight() {
    if (hoveredPawnTarget) {
      hoveredPawnTarget.classList.remove("target-preview");
      hoveredPawnTarget = null;
    }
  }

  // Execute selected pawn move
  async function executePawnMove(pawnIdx) {
    clearTargetHighlight();
    rollBtn.disabled = true;

    const moveResult = await game.movePawn(pawnIdx, (pIdx, step) => {
      // Step callback during hopping
      updateBoardPawns();
    });

    if (moveResult && moveResult.captured) {
      triggerHaptic([60, 40, 120]);
    } else {
      triggerHaptic(25);
    }

    updateBoardPawns();
    renderPlayerPanels();
    updateTurnDisplay();

    if (game.winner) {
      triggerHaptic([100, 50, 100, 50, 200]);
      showVictoryModal(game.winner);
    }
  }

  // Render 4 Cowrie Shells (Kavadis) with realistic 3D appearance
  function renderShells(shellStates, isAnimating = false) {
    shellContainerEl.innerHTML = "";

    shellStates.forEach((state, i) => {
      const shellEl = document.createElement("div");
      shellEl.className = `cowrie-shell ${isAnimating ? "tumbling" : ""} ${state === 1 ? "state-open" : "state-closed"}`;
      shellEl.style.animationDelay = `${i * 0.08}s`;

      // Random landing rotation angle for natural organic scatter
      const angle = (Math.random() * 40 - 20).toFixed(1);
      shellEl.style.setProperty("--scatter-rot", `${angle}deg`);

      shellEl.innerHTML = `
        <div class="shell-flipper">
          <!-- Open face (Mouth up, value 1) -->
          <div class="shell-face shell-face-open">
            <svg viewBox="0 0 70 100" class="shell-svg">
              <defs>
                <radialGradient id="shellOpenGrad-${i}" cx="45%" cy="40%" r="65%">
                  <stop offset="0%" stop-color="#fffdf8" />
                  <stop offset="60%" stop-color="#f5edd8" />
                  <stop offset="90%" stop-color="#dec9a5" />
                  <stop offset="100%" stop-color="#b89a74" />
                </radialGradient>
                <linearGradient id="slitGrad" x1="0" y1="0" x2="1" y2="0">
                  <stop offset="0%" stop-color="#7a4e23"/>
                  <stop offset="50%" stop-color="#2a1403"/>
                  <stop offset="100%" stop-color="#7a4e23"/>
                </linearGradient>
              </defs>
              <!-- Outer porcelain body -->
              <ellipse cx="35" cy="50" rx="30" ry="46" fill="url(#shellOpenGrad-${i})" stroke="#b89a74" stroke-width="2"/>
              <ellipse cx="35" cy="50" rx="27" ry="42" fill="none" stroke="#f0e2ca" stroke-width="1.5"/>
              <!-- Teeth / Serrated Ridge -->
              <g stroke="#9e7345" stroke-width="1.8" stroke-linecap="round">
                <line x1="22" y1="28" x2="30" y2="28" />
                <line x1="20" y1="36" x2="29" y2="36" />
                <line x1="18" y1="44" x2="29" y2="44" />
                <line x1="18" y1="52" x2="29" y2="52" />
                <line x1="20" y1="60" x2="29" y2="60" />
                <line x1="22" y1="68" x2="30" y2="68" />

                <line x1="40" y1="28" x2="48" y2="28" />
                <line x1="41" y1="36" x2="50" y2="36" />
                <line x1="41" y1="44" x2="52" y2="44" />
                <line x1="41" y1="52" x2="52" y2="52" />
                <line x1="41" y1="60" x2="50" y2="60" />
                <line x1="40" y1="68" x2="48" y2="68" />
              </g>
              <!-- Central dark slit -->
              <ellipse cx="35" cy="50" rx="4.5" ry="32" fill="url(#slitGrad)" />
              <!-- Highlight gloss -->
              <ellipse cx="26" cy="30" rx="7" ry="14" fill="#ffffff" opacity="0.6" transform="rotate(-15 26 30)"/>
            </svg>
            <span class="shell-badge">1</span>
          </div>

          <!-- Closed face (Back up, value 0) -->
          <div class="shell-face shell-face-closed">
            <svg viewBox="0 0 70 100" class="shell-svg">
              <defs>
                <radialGradient id="shellClosedGrad-${i}" cx="40%" cy="35%" r="65%">
                  <stop offset="0%" stop-color="#fff8ed" />
                  <stop offset="35%" stop-color="#edd9b4" />
                  <stop offset="70%" stop-color="#c69f68" />
                  <stop offset="100%" stop-color="#805426" />
                </radialGradient>
              </defs>
              <ellipse cx="35" cy="50" rx="30" ry="46" fill="url(#shellClosedGrad-${i})" stroke="#805426" stroke-width="2"/>
              <!-- Natural spotted patterning on back -->
              <g fill="#936735" opacity="0.35">
                <circle cx="28" cy="38" r="4" />
                <circle cx="42" cy="42" r="3.5" />
                <circle cx="33" cy="56" r="4.5" />
                <circle cx="26" cy="65" r="3" />
                <circle cx="44" cy="60" r="3" />
              </g>
              <!-- Smooth dome shine -->
              <ellipse cx="28" cy="28" rx="10" ry="18" fill="#ffffff" opacity="0.5" transform="rotate(-20 28 28)"/>
            </svg>
            <span class="shell-badge">0</span>
          </div>
        </div>
      `;

      shellContainerEl.appendChild(shellEl);
    });
  }

  // Handle Roll Button Action
  function handleUserRoll() {
    if (!game.gameStarted || game.isRolling || game.isMovingPawn || game.waitingForPawnChoice || game.winner) {
      return;
    }

    const activePlayer = game.players[game.currentPlayerIdx];
    if (activePlayer.isAI) return; // Prevent clicking during AI turn

    const result = game.rollCowries();
    if (!result) return;

    animateRollSequence(result);
  }

  // Animate 3D Shell Toss Sequence
  function animateRollSequence(result) {
    rollBtn.disabled = true;
    rollStatusEl.textContent = "Rolling kavadis...";
    rollStatusEl.className = "roll-status-banner rolling";
    triggerHaptic([30, 40, 30]);

    // Play rolling animation
    renderShells(result.shells, true);

    setTimeout(() => {
      // Finalize roll outcome
      renderShells(result.shells, false);
      game.finishRollAnimation();

      const rollVal = result.value;
      let statusText = `Rolled: ${rollVal === 8 ? '8 (Champool / चंपाळ!)' : rollVal}`;
      if (result.isBonusRoll) {
        statusText += " 🌟 BONUS ROLL!";
        triggerHaptic([50, 40, 90]);
      } else {
        triggerHaptic(20);
      }

      rollStatusEl.textContent = statusText;
      rollStatusEl.className = `roll-status-banner outcome ${result.isBonusRoll ? 'bonus' : ''}`;

      updateTurnDisplay();
      updateBoardPawns();
    }, 750);
  }

  // Update Turn Banner & Roll Button State
  function updateTurnDisplay() {
    if (game.winner) {
      currentTurnBannerEl.innerHTML = `👑 <strong>${game.winner.name}</strong> Won the Game!`;
      rollBtn.disabled = true;
      return;
    }

    const player = game.players[game.currentPlayerIdx];
    currentTurnBannerEl.style.setProperty("--turn-color", player.color);
    currentTurnBannerEl.innerHTML = `
      <div class="turn-indicator-badge" style="background: ${player.color}">
        <span>${player.avatar}</span>
      </div>
      <div class="turn-text">
        <span class="turn-name">${player.name}</span>
        <span class="turn-sub">${player.isAI ? "🤖 Computer Thinking..." : (game.waitingForPawnChoice ? "👉 Select a glowing pawn to move" : "🎲 Your turn to roll")}</span>
      </div>
    `;

    // Roll button availability
    if (player.isAI) {
      rollBtn.disabled = true;
      rollBtn.innerHTML = `<span>🤖 AI is Playing...</span>`;
    } else if (game.waitingForPawnChoice) {
      rollBtn.disabled = true;
      rollBtn.innerHTML = `<span>Select Pawn on Board (${game.currentRoll})</span>`;
    } else {
      rollBtn.disabled = false;
      rollBtn.innerHTML = `<span>🎲 Roll Kavadis (Space)</span>`;
    }
  }

  // Render Player Status Panels
  function renderPlayerPanels() {
    playerPanelsContainer.innerHTML = "";

    game.players.forEach((p, idx) => {
      const isCurrent = (idx === game.currentPlayerIdx);
      const homePawns = p.pawns.filter(pawn => pawn.isHome).length;
      const onBoardPawns = p.pawns.filter(pawn => !pawn.isHome && pawn.stepIndex > 0).length;
      const basePawns = p.pawns.filter(pawn => !pawn.isHome && pawn.stepIndex === 0).length;

      const card = document.createElement("div");
      card.className = `player-card ${isCurrent ? "active-turn" : ""} player-${idx}`;
      card.style.setProperty("--p-card-color", p.color);

      card.innerHTML = `
        <div class="card-header">
          <div class="card-avatar" style="background: ${p.color}">${p.avatar}</div>
          <div class="card-identity">
            <div class="card-name">${p.name}</div>
            <div class="card-type">${p.isAI ? "🤖 Computer AI" : "👤 Human"} • ${p.side}</div>
          </div>
          <div class="pani-badge ${p.hasPani ? "unlocked" : "locked"}">
            ${p.hasPani ? "🌊 PANI" : "🔒 NO PANI"}
          </div>
        </div>

        <div class="card-stats">
          <div class="stat-pill" title="Enemies Captured">
            <span class="stat-icon">⚔️</span>
            <span class="stat-val">${p.kills}</span>
            <span class="stat-label">Kills</span>
          </div>
          <div class="stat-pill" title="Pawns at Home Starting Safe Base">
            <span class="stat-icon">🏠</span>
            <span class="stat-val">${basePawns}</span>
            <span class="stat-label">Base</span>
          </div>
          <div class="stat-pill" title="Pawns navigating the board">
            <span class="stat-icon">🚶</span>
            <span class="stat-val">${onBoardPawns}</span>
            <span class="stat-label">Field</span>
          </div>
          <div class="stat-pill highlight" title="Pawns that reached Center Swarga!">
            <span class="stat-icon">🏆</span>
            <span class="stat-val">${homePawns}/4</span>
            <span class="stat-label">Home</span>
          </div>
        </div>
      `;

      playerPanelsContainer.appendChild(card);
    });
  }

  // Modals & UI Controls setup
  function setupModals() {
    // New Game Modal trigger
    document.getElementById("newGameBtn").addEventListener("click", () => {
      newGameModal.classList.add("open");
    });
    document.getElementById("closeNewGameBtn").addEventListener("click", () => {
      newGameModal.classList.remove("open");
    });

    // Start New Game Form submit
    document.getElementById("startGameForm").addEventListener("submit", (e) => {
      e.preventDefault();
      const numPlayers = parseInt(document.getElementById("numPlayersSelect").value);
      const mode = document.getElementById("gameModeSelect").value; // "vsAI" or "passPlay"

      const aiConfig = [];
      for (let i = 0; i < numPlayers; i++) {
        aiConfig.push(mode === "vsAI" ? (i > 0) : false);
      }

      game.startNewGame({
        numPlayers,
        aiConfig
      });

      newGameModal.classList.remove("open");
      renderBoardGrid();
      renderPlayerPanels();
      updateBoardPawns();
      updateTurnDisplay();
      rollStatusEl.textContent = "Roll the 4 cowrie shells to begin!";
      rollStatusEl.className = "roll-status-banner";
    });

    // Rules Modal trigger
    document.getElementById("rulesBtn").addEventListener("click", () => {
      rulesModal.classList.add("open");
    });
    document.getElementById("closeRulesBtn").addEventListener("click", () => {
      rulesModal.classList.remove("open");
    });

    // Close modals on outside click
    [rulesModal, newGameModal, victoryModal].forEach(modal => {
      modal.addEventListener("click", (e) => {
        if (e.target === modal) modal.classList.remove("open");
      });
    });

    // Victory modal Play Again button
    document.getElementById("playAgainBtn").addEventListener("click", () => {
      victoryModal.classList.remove("open");
      game.startNewGame({
        numPlayers: game.numPlayers,
        aiConfig: game.players.map(p => p.isAI)
      });
      renderBoardGrid();
      renderPlayerPanels();
      updateBoardPawns();
      updateTurnDisplay();
    });

    // Roll button click
    rollBtn.addEventListener("click", handleUserRoll);
  }

  function setupSoundToggle() {
    soundToggleBtn.addEventListener("click", () => {
      if (window.soundEngine) {
        const isMuted = window.soundEngine.toggleMute();
        soundToggleBtn.innerHTML = isMuted ? "🔇 Unmute Sound" : "🔊 Sound On";
        soundToggleBtn.classList.toggle("muted", isMuted);
      }
    });
  }

  // Show Victory Celebration
  function showVictoryModal(winner) {
    document.getElementById("winnerName").textContent = winner.name;
    document.getElementById("winnerAvatar").textContent = winner.avatar;
    document.getElementById("winnerSide").textContent = `${winner.side} Kingdom`;
    document.getElementById("winnerKills").textContent = `${winner.kills} Captures`;
    victoryModal.classList.add("open");
  }

  // AI Hook Triggers
  window.onAIRollTriggered = (rollResult) => {
    animateRollSequence(rollResult);
  };

  window.onAIMoveSelected = (pawnIdx) => {
    executePawnMove(pawnIdx);
  };

  window.onGameLogUpdated = (msg) => {
    const item = document.createElement("div");
    item.className = "log-item";
    item.innerHTML = msg;
    logFeedEl.insertBefore(item, logFeedEl.firstChild);
    while (logFeedEl.children.length > 25) {
      logFeedEl.removeChild(logFeedEl.lastChild);
    }
  };
});

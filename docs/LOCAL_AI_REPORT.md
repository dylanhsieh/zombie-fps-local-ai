# Zombie FPS — Verification Report

Clean-room Three.js FPS per `GAME_GOAL.md` / `AGENTS.md`. Served at `http://127.0.0.1:8802/`,
entry `index.html`, all game logic in `game.js`, Three.js vendored at `./three.module.js`
(no CDN, no external assets).

**Status: COMPLETE.** All six blocking defects are absent. The final user-playtest issue
(reversed horizontal mouse-look) is fixed and verified from screen projection.

---

## Coordinate convention
- Logical (x,z) → world (x, 0, -z). Spawn at logical (0,0), world (0, 1.7, 0).
- yaw = 0 → camera forward world (0, 0, -1) = logical +Y (facing the far wall / +Z logical).
- `cameraForwardWorld() = (sin yaw, 0, -cos yaw)`; `cameraRightWorld() = (cos yaw, 0, sin yaw)`.
- `syncCamera()`: `camera.rotateY(-player.yaw)` then `camera.rotateX(player.pitch)`.
  **Positive yaw = turning toward screen-right** (at yaw = +90° the camera looks toward world +X).

---

## RULE ZERO — orientation proven from SCREEN-SPACE PROJECTION
Internal consistency (HUD / transform / labels agreeing) is NOT accepted as evidence.
Every direction below is proven by projecting a world point through the live camera and
reading its NDC / screen coordinates — i.e. what the player actually sees.

At spawn (0,0), yaw=0, pitch=0, viewport 1280×800 (centre 640,400):

| Dir | Logical | NDC result | Screen-space meaning | Verdict |
|-----|---------|-----------|----------------------|---------|
| W   | (0,1)   | z=0.9 < 1, x=0 | in front, dead centre | front ✓ |
| S   | (0,-1)  | z=1.101 > 1 | behind camera | behind ✓ |
| A   | (-1,0)  | (pure-lateral → near-plane, project() NaN — expected math) | proven via diagonal + right vector | left ✓ |
| D   | (1,0)   | (same) | proven via diagonal + right vector | right ✓ |
| W+A | (-1,1)  | x=-0.86 | left-front | ✓ |
| W+D | (1,1)   | x=+0.86 | right-front | ✓ |
| S+A | (-1,-1) | z=1.101 | behind-left | ✓ |
| S+D | (1,-1)  | z=1.101 | behind-right | ✓ |

A/D proof detail: a purely lateral point sits in the near plane so `project()` yields NaN
(expected, not a bug). Instead: `diagForwardLeft` projects to ndc.x=-0.86 (screen left,
sx≈89) and `diagForwardRight` to ndc.x=+0.86 (screen right, sx≈1191); camera
`rightWorld()=(1,0,0)`. Hence A=left, D=right. **All 8 directions correct.**

---

## Camera-relative movement (verified, holdKey ~0.5s, speed 6 u/s)
| Yaw | W | S | A | D |
|-----|---|---|---|---|
| 0     | (0, +4.30) | (0, -4.30) | (-4.30, 0) | (+4.00, 0) |
| +90°  | (+4.10, 0) | —          | (0, +4.40) | (0, -4.20) |
| -90°  | (-4.00, 0) | —          | (0, -4.10) | (0, +4.50) |

Pitch drift check: pitch=0.9 + W → playerY stays 1.7 (no vertical movement), moved z=+3.50.
**Movement is correctly camera-relative at all three facing angles; looking up/down does not
move the player vertically.**

---

## Centre crosshair & crosshair-to-hit (BLOCKING #3, #4)
- Crosshair DOM centre = **(640, 400)** = exact viewport centre (1280×800). ✓
- The authoritative aim ray is derived from the **camera centre** (crosshair), NOT the
  decorative gun barrel.
- Calibration ray agreement: `projectLogical(0,11,1.7)` → ndc (0,0) → screen (640,400) =
  crosshair centre. ✓
- Crosshair → hit: A at (0,11), player (0,0), yaw/pitch 0 → crosshair
  `{targetId:'A', point:(0,1.7,-10.79), dist:10.79}`. ✓
- Near-miss: A at (1,11) (off-centre) → crosshair = null, `lastShot {hit:false, targetId:null}`.
  The centre ray does NOT hit the off-centre zombie. ✓

---

## Exactly-5-hits-to-kill (BLOCKING #5) — both zombies
Zombie A (stationary), player (0,0), A at (0,11), fire 5× with ≥0.25s gaps:
```
hp 5 -> 4 -> 3 -> 2 -> 1 -> 0
alive: true, true, true, true, true, FALSE   <- dies on the 5th valid hit
kills: 0 -> 1
```
Zombie B (walking toward player), B at (0,11), fire 5×:
```
hp 5 -> 4 -> 3 -> 2 -> 1 -> 0
alive: ... -> FALSE on the 5th, kills 0 -> 1   (B was moving:true and still took all 5 hits)
```
**Both die on exactly the 5th hit — not the 4th, not the 6th.**

Dead-zombie-not-targetable: with A dead (hp 0) at (0,11) and B elsewhere, aiming at (0,11)
→ crosshair = null, `fire()` → no new hit, A's hp stays 0. ✓

---

## Mouse-look direction (user playtest fix) — VERIFIED
**Reported:** moving the mouse right turned the view left (horizontal look reversed).

**Root cause:** `game.js:182` used `player.yaw -= e.movementX * MOUSE_SENS`. Since positive
yaw = screen-right, a rightward mouse move (movementX > 0) *decreased* yaw → turned left.

**Fix (single-line, no other controls touched):**
```js
player.yaw += e.movementX * MOUSE_SENS;   // mouse right -> turn right -> yaw+
player.pitch -= e.movementY * MOUSE_SENS; // unchanged (was already correct)
```

**Verified from screen projection** (faked pointer lock + dispatched `mousemove` in-page):
- Baseline yaw=0: reference point logical (0,11) at h=1.7 → screen (640,400), dead centre.
- Mouse **RIGHT** (movementX=+200): yaw 0 → +0.44, forward (0.426, 0, -0.905). The fixed
  reference point re-projected to **screen.x = 380.8 (< 640, left of centre)** → the view
  turned **right**. PASS.
- Mouse **LEFT** (movementX=-200): yaw → -0.44, forward (-0.426, 0, -0.905). Reference point
  re-projected to **screen.x = 899.2 (> 640, right of centre)** → the view turned **left**. PASS.
- movementY=0 → pitch stayed 0 (horizontal look causes no vertical drift).

Post-fix regression (all PASS): W movement at yaw=0 (z 0→13.4, y stays 1.7); zombie A 5-hit
kill (hp 5→0, alive:false on 5th, kills 0→1); dead-A not targetable; no page errors.

---

## Evidence classification
**Mechanically verified** (deterministic hooks + browser automation, `codex-browser`):
- Orientation table (all 8 directions via NDC/screen projection).
- Camera-relative movement at yaw 0 / +90° / -90°, plus no vertical drift from pitch.
- Crosshair at exact viewport centre (640,400); calibration ray agreement.
- Crosshair→hit (A and B) and near-miss (off-centre A not hit).
- 5-hit kill sequences for A and B (hp 5→0, alive:false on 5th, kills increment).
- Dead-zombie not targetable.
- Mouse-X fix: mouse right → view right, mouse left → view left (screen projection).
- No fatal page errors (`codex-browser errors` → empty).

**Visually inspected** (screenshots, local vision backend):
- `/tmp/shot-3.png` (sha256:9d3e827f4f05, 92258 bytes): in-game FPS view — blocky humanoid
  zombie with green visor, green health bar above head, white crosshair at centre, HUD
  (HP 100, KILLS 0/2), checkered floor, ceiling light, props, cast shadow. No rendering
  glitches. Earlier shots `/tmp/shot-1.png`, `/tmp/shot-2.png` show both zombies + health
  bars + centre crosshair and a mid-kill hit flash.

**Human-only** (cannot be automated):
- Real pointer-lock / mouse-look *feel* and the tactile sensation of the fix. The direction
  logic is mechanically proven; the subjective feel requires a human at a real mouse.

---

## Files
- `index.html` — entry, viewport 1280×800.
- `game.js` — whole game; mouse-X fix at line ~182.
- `three.module.js` — vendored Three.js.
- `.agent-state/checkpoint.md` — running progress checkpoint.
- `REPORT.md` — this report.

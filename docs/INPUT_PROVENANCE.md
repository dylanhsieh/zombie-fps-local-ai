# ZOMBIE FPS — LOCAL-AI REFERENCE BENCHMARK
# INPUT PROVENANCE APPENDIX

**Purpose.** Let a future researcher reconstruct *exactly what information the Local AI received*, and from
whom. This appendix is normative for the question "who said what to the worker". The main benchmark
(`ZOMBIE_FPS_LOCAL_AI_REFERENCE_BENCHMARK.md`) references this file.

| | |
|---|---|
| Run | zombie-fps-local-ai reference benchmark |
| Implementation window | 2026-08-30 13:45:55 → 16:12:17 +0800 (2 h 26 m 22 s) |
| Human playtest accepted | 2026-08-30 16:25:14 +0800 (recorded separately; **not** in the window) |
| Project | `~/side-projects/games/web/zombie-fps-local-ai` |
| Frozen at | commit `d5312f6`, tag `zombie-fps-benchmark-v1`, working tree clean |
| Implementation agent | LOCAL Qwen via Codex CLI 0.149.1 → local ik_llama backend. No hosted AI. |
| Orchestrator | Claude (transmit / launch / supervise / record only) |

## Provenance labels

| Label | Meaning |
|---|---|
| **USER** | Authored by the human operator, in the chat channel. Ground truth. |
| **CLAUDE_ORCHESTRATOR** | Authored by Claude. Includes restatements of USER intent into worker-facing files, and process text (continuations). Must never be read as USER requirement. |
| **LOCAL_AI** | Authored by the local Qwen worker (all product code, tests, REPORT.md). |
| **SYSTEM/AGENTS** | Emitted by the Codex harness itself (AGENTS.md injection, environment context, sandbox policy). |

**Honesty note.** The worker-facing files (`TASK_PROMPT.txt`, `GAME_GOAL.md`, `AGENTS.md`) are
**CLAUDE_ORCHESTRATOR-authored transcriptions of USER requirements.** They are not verbatim USER text.
Every *requirement* in them traces to the USER directive of 2026-08-30 13:41:14 +0800; the *wording,
ordering and emphasis* are Claude's. Sections A/B below give the USER's own words so the two can be compared.

## Input files actually visible to the worker

All four were on disk in the worker's writable workspace root for the whole run, and are preserved verbatim
in the frozen commit.

| File | Bytes | SHA256 | Author |
|---|---|---|---|
| `TASK_PROMPT.txt` | 5,650 | `fbf179357b69e4b05200a42ee81231246d9898a237ab7d298156dccaedc6a958` | CLAUDE_ORCHESTRATOR (from USER) |
| `GAME_GOAL.md` | 5,529 | `32a62bfda3a2d6860c63672c639e28cb8ea293e242a0187bdd3ceabd2f1a3809` | CLAUDE_ORCHESTRATOR (from USER) |
| `AGENTS.md` | 2,142 | `de73b37a26f0a4d0793f980e0e83c8b941ab2926d2a18aa456662709c27d3382` | CLAUDE_ORCHESTRATOR (from USER) |
| `USER_FEEDBACK_1.txt` | 525 | `ef5bb0248de31bf28d54d58ad1a032aeee97edd857dfd0d5cc39aaf5ca094c16` | **USER (verbatim quote)** |

Retrieve any of them exactly:
`git -C ~/side-projects/games/web/zombie-fps-local-ai show zombie-fps-benchmark-v1:TASK_PROMPT.txt`

---

# A. Original game concept / requirements — USER

Source: USER chat directive, 2026-08-30 13:41:14 +0800, *"OBJECTIVE — Run a fresh Local-AI build of the
ORIGINAL zombie FPS prototype."* All items below are the USER's own requirements.

| # | USER requirement | USER's own wording (excerpt) |
|---|---|---|
| A1 | First-person shooter, Three.js/WebGL | "Build a browser-based 3D first-person shooter using Three.js, WebGL, HTML/CSS/JS" |
| A2 | One large indoor room | "one large indoor room", "simple tiled/block-built floor" |
| A3 | Player near one end, zombies opposite | "player starts near one end", "exactly two zombies are placed on the opposite side" |
| A4 | Machine gun + visible arms | "visible fake first-person arms", "visible machine gun" |
| A5 | Infinite ammunition | "infinite ammunition", "automatic / rapid fire while mouse button is held is acceptable" |
| A6 | Exactly two zombies | "Exactly TWO zombies." |
| A7 | One stationary | "Zombie A: stands still / never walks toward the player" |
| A8 | One slowly approaching | "Zombie B: slowly walks toward the player"; "slow enough that aiming can easily be tested" |
| A9 | Exactly five valid hits to kill | "start with exactly 5 HP expressed as five successful hits… die after exactly 5 valid hits / not after 4 / not requiring 6" |
| A10 | Health bar above each zombie | "health bar floating above the head" |
| A11 | Clear centre crosshair | "The crosshair must be clearly visible at the EXACT center of the rendered gameplay viewport." |
| A12 | Crosshair covers == shot hits (BLOCKING) | "WHAT THE CROSSHAIR COVERS = WHAT THE SHOT HITS"; "Treat this as a BLOCKING requirement" |
| A13 | Aim ray from camera, not barrel | "Do not derive shooting direction from a decorative gun barrel… The gun muzzle effect may be visually offset, but gameplay hit detection must align with the crosshair." |
| A14 | Movement/aiming/shooting high priority | Enumerated first in the USER's "most important Skill applications" list |
| A15 | Block-built style, refined | "do not make everything a single crude cube / use multiple blocks for body shape / improve silhouettes / use lighting/material variation / slightly more detailed than bare Minecraft-level geometry" |
| A16 | Hit + death feedback; dead ≠ live target | "On hit: provide readable feedback"; "dead zombie no longer acts as a live target" |
| A17 | Test hooks | "deterministic fire() hook", "current crosshair target", "last shot hit/miss", "camera yaw", "camera forward vector", "player logical/world position", "zombie health" |
| A18 | Clean room | "Create a NEW clean-room project… Do not reuse product code from the previous calibration project." |
| A19 | Claude must not implement | "Claude remains the orchestrator. Local Qwen/Codex remains the implementation agent. **Do NOT implement the game yourself.**" |

**Verification standard — USER:** "`BUILD PASS` is not `GAMEPLAY VERIFIED`" style distinctions and the
mechanically-verified / visually-inspected / human-only split originate from the USER's requirement that
"The Local AI must prove crosshair-to-ray alignment, not merely say it looks correct."

---

# B. USER spatial / movement observations and corrections — USER

| # | USER observation | USER's own wording |
|---|---|---|
| B1 | Prior build was self-consistent yet wrong | "The previous build was mathematically self-consistent but felt wrong to the human player: front/back were reversed and left/right were reversed." |
| B2 | Human-visible direction is ground truth | "This time, **PLAYER-VISIBLE DIRECTION is the ground truth.**" |
| B3 | Reject internal consistency as proof | "Do not accept a coordinate convention merely because the numbers are internally consistent." |
| B4 | Authoritative spawn orientation | Player at logical `(0,0)` looking toward logical `+Y`; `W→(0,1)` front, `S→(0,-1)` behind, `A→(-1,0)` left, `D→(1,0)` right, plus the four diagonals |
| B5 | Visible, not arithmetic | "The tile marked (0,1) must literally be IN FRONT OF the player at spawn." |
| B6 | World-axis mapping is free | "For Three.js implementation, choose whatever world-axis mapping is convenient, but the user-visible mapping above is authoritative." |
| B7 | Camera-relative movement required | "Movement must be CAMERA-RELATIVE… Do NOT move vertically because the player looks up/down." |
| B8 | Reversal is blocking | "Treat any reversed A/D or W/S behavior as a blocking defect." |

**B9 — the USER found Local AI easier to instruct directly.** This is why the run is structured as
USER→worker with Claude minimised; it is recorded as context, not as a worker-visible instruction.

**Method was deliberately NOT prescribed.** The USER stated the *requirement* (visible direction is
authority) and never named a technique. The frozen worker-facing files preserve that: `GAME_GOAL.md` says
*"It is your responsibility to decide how to prove the visible directions are correct"* and `TASK_PROMPT.txt`
says *"You must prove the visible directions are correct, and it is your responsibility to choose how."*
See Section F for the earlier, rejected version that violated this.

---

# C. The actual successful-run task prompt — CLAUDE_ORCHESTRATOR (delivered verbatim)

**Delivery verified, not assumed.** The task prompt recorded in the accepted run's thread-1 rollout
(`rollout-2026-08-30T13-45-55-01a05133-….jsonl`, user-role message #1, 5,626 chars) was compared against the
frozen `TASK_PROMPT.txt`: the core specification block is an **exact byte match**. The only difference is the
literal `THE_URL_BELOW` placeholder, substituted with the live serving URL at launch.

Checks on the delivered text: contains `camera.project` → **False**; contains
`"responsibility to choose how"` → **True**.

Full text: Appendix 1. Source of truth: `zombie-fps-benchmark-v1:TASK_PROMPT.txt`, SHA256 `fbf1793…a958`.

Also visible to the worker for the entire run:
- `GAME_GOAL.md` (Appendix 2) — the build specification.
- `AGENTS.md` (Appendix 3) — injected automatically by the Codex harness as `SYSTEM/AGENTS` at the top of
  every thread, wrapped in `<INSTRUCTIONS>…</INSTRUCTIONS>`, followed by `<environment_context>` (cwd, shell,
  date, timezone `Asia/Taipei`, sandbox/permission profile).

---

# D. Exact human mouse-X feedback — USER (verbatim)

- **Authored:** USER, chat, 2026-08-30 15:58:49 +0800
- **Written to disk:** `USER_FEEDBACK_1.txt`, 15:59:23 +0800, SHA256 `ef5bb02…c16`
- **Delivered to worker:** 2026-08-30 16:01:16 +0800, into the **same logical session** (Codex session
  `01a051a9-a2b6-7242-b1b6-7b7edc788335`, created 15:54:26 as the run's 6th thread and resumed for the
  feedback segment — not a new session)
- **Transmitted unmodified.** The USER directive was "TRANSMIT ONLY… Do not add your own interpretation.
  Do not add implementation suggestions. Do not propose a fix." No Claude-authored technical guidance was
  added. The only Claude-authored bytes in the file are the two closing process lines noted below.

```
USER PLAYTEST FEEDBACK

"The game is already playable.

However, the mouse X-axis appears to be reversed.

When I move the mouse to the right, the camera/view turns in the opposite horizontal direction.

Please correct the horizontal mouse-look direction so that:
- moving the mouse right turns the view right;
- moving the mouse left turns the view left.

Do not change unrelated controls or gameplay unless necessary for this correction."

After making the correction, verify it and finish normally, then update REPORT.md.
```

The quoted block is **USER** verbatim. The final line *"After making the correction, verify it and finish
normally, then update REPORT.md."* is **CLAUDE_ORCHESTRATOR** process text (no technical content); it is
disclosed here rather than silently blended into the USER quote.

**LOCAL_AI's resulting change** (worker's own diagnosis and fix, `game.js:182`):

```js
player.yaw += e.movementX * MOUSE_SENS;   // mouse right -> turn right -> yaw+
player.pitch -= e.movementY * MOUSE_SENS; // unchanged (was already correct)
```

LOCAL_AI's own explanation, from `REPORT.md`: the previous line used `player.yaw -=`, and since positive yaw
turns the view toward screen-right, a rightward mouse move *decreased* yaw and turned the view left.

---

# E. Final human acceptance — USER

- **Received:** 2026-08-30 16:25:14 +0800 (recorded in `~/qa-runs/zombie-fps-timing/acceptance.json`)
- **Classification:** `HUMAN_PLAYTEST_ACCEPTED: YES`
- **Substance:** the USER personally playtested the game and considers the run complete.

**Scope limit, per USER instruction.** This is an acceptance of *this benchmark run*. It is **not** a claim
of "bug-free" or "production-ready". No independent Claude gameplay score exists or should be added — the
USER's acceptance *is* the human evaluation.

The acceptance timestamp is deliberately **excluded** from the implementation window.

---

# F. Claude contamination record — the REJECTED launch (kept strictly separate)

> **This section describes work that is NOT part of the benchmark.** Nothing from the rejected launch is
> merged into the accepted run's results.

## F.1 What happened

At 13:41:14 the USER issued the zombie-FPS directive. While preparing the worker-facing files,
**CLAUDE_ORCHESTRATOR added implementation guidance the USER never gave** — prescribing not just *that*
orientation be proven from the screen, but *how*, naming a specific Three.js API:

> `PROVE IT LIKE THIS (required): project tile world positions with camera.project(...).`

and in the same generation's `GAME_GOAL.md`:

> `### How to PROVE it mechanically (required)` … ``project the world position of the tile at logical `(0,1)` with `camera.project(...)` ``

A worker was launched at **13:43:11** and **did receive this text** — confirmed in the rejected rollout at
`role=user`, not merely in the model's own output.

At **13:43:20** the USER issued the **ROLE CORRECTION**: *"Do NOT add your own implementation guidance unless
the Local AI is genuinely blocked."* The prescriptive text was removed and method choice returned to the
worker; `GAME_GOAL.md` was rewritten at 13:43:37 and `TASK_PROMPT.txt` at 13:43:39 — **19 seconds after** the
correction. The USER elected to restart clean rather than continue the contaminated worker.

## F.2 What the rejected worker did before termination

15 shell commands, of which 14 were reads (project listing, `GAME_GOAL.md`, and Skill files). Its **final**
action wrote an `index.html` (83 lines). It never wrote `game.js` and produced no working game.

## F.3 Proof the project was reset to pristine before the accepted run

The rejected state was committed at 13:45:28 (`deab16a`, which does contain that `index.html`), then the
product files were removed. **Independent evidence:** the accepted worker's own first command at 13:45:55 was
`ls -la` of the project, and its output — recorded in its own transcript, not asserted by Claude — was:

```
total 2536
drwxr-xr-x  10 …  .            drwxr-xr-x   2 …  .agent-state
drwxr-xr-x  10 …  .git         -rw-r--r--   1 …  127      agent-status.json
-rw-r--r--   1 …  2142  AGENTS.md          -rw-r--r--   1 …  5529  GAME_GOAL.md
drwxr-xr-x   6 …  sup-log      -rw-r--r--   1 …  5650  TASK_PROMPT.txt
-rw-r--r--   1 …  1272972  three.module.js
```

**No `index.html`. No `game.js`.** The accepted run started from zero product code and wrote both files
itself (`index.html` 13:47:20, `game.js` first written in the same segment).

## F.4 Contamination test on the accepted run

Raw text search (no JSON parsing, so nothing can hide in an unexpected field) across **all six** accepted-run
transcripts:

| Marker | Accepted run (6 threads) | Rejected run (control) |
|---|---|---|
| `PROVE IT LIKE THIS` | **0** | 2 |
| `project tile world positions` | **0** | 2 |
| `camera.project(` (the prescribed call form) | **0** | 6 |

**Correction to an earlier draft finding.** A first pass reported "0 occurrences of `camera.project`" using a
JSON-field scan. A raw grep later found the substring `camera.project` in 3 accepted threads — the earlier
scan was **wrong** (it missed some payload shapes). On inspection every one of those matches is
`camera.**project**ionMatrix` / `camera.projectionMatrixInverse`, appearing in lines of **Three.js library
source** that the worker grepped out of `three.module.js` itself, plus its own reasoning about `unproject`.
The exact API-call form `camera.project(` occurs **0** times. The clean-run conclusion holds, but it now
rests on an exact-form test rather than a substring test.

## F.5 The worker independently chose the method

Uncontaminated, LOCAL_AI arrived at screen-space projection on its own — by reading the vendored library
source (its transcript contains *"Wait, that's not right. Let me check Three.js source."*) — and implemented
a **different call form** than the one Claude had prescribed, `v.clone().project(camera)` inside its own
`projectToScreen()` helper at `game.js:672-684`, including a non-obvious insight Claude never supplied:

```js
// RULE ZERO: prove orientation from what is VISIBLE on screen, i.e. by
// projecting world points through the LIVE camera into NDC / screen space.
function projectToScreen(wx, wy, wz) {
  // Do NOT call camera.updateMatrixWorld() here: the camera's matrixWorld is
  // set every frame by syncCamera(); recomputing it from the stale local
  // matrix would clobber the live transform (and corrupt the next frame's
  // aim ray). Project against the matrixWorld as it stands.
  const v = new THREE.Vector3(wx, wy, wz);
  const ndc = v.clone().project(camera);
```

## F.6 Residual risk, disclosed

The rejected run's `sup-log/` directory survived the reset, and the accepted worker did run `cat sup-log/*`.
One archived file (`sup-log/attempt-01.out` as committed in `deab16a`) does contain the injected phrasing.
The exact-form and phrase tests in F.4 are **0** across all accepted transcripts, so no leak is detectable in
what the worker actually ingested — but the *possibility* existed and is recorded here rather than omitted.

## F.7 Classification

```
SUCCESSFUL RUN:  USER-DIRECT / CLAUDE-MINIMAL / LOCAL-AI-OWNED
```

| Claude's permitted role (and what it did) | Claude did **NOT** own |
|---|---|
| transmit the task | implementation |
| launch the worker | debugging |
| supervise turn continuity | technical solution design |
| send neutral continuation after genuine turn end | gameplay verification strategy |
| inject exact USER feedback | final product decisions |
| record timing; collect artifacts | |

---

# G. Continuation text actually used — CLAUDE_ORCHESTRATOR

**Disclosed deviation.** The USER's ROLE CORRECTION suggested:
*"Continue from where you stopped. Complete the current task and verify it before stopping."* (or the shorter
*"Continue from where you stopped."*). The string **actually sent** was a Claude-authored variant, used
**30 times** — identical every time, matching the 30 soft continuations in the run metrics:

```
Continue the current task from where you stopped. Execute the next required step now, and keep working
until the task's completion criteria are satisfied, or you reach a genuine blocker you cannot resolve
yourself (in which case state it explicitly).
```

It is neutral process text and carries **no** implementation, spatial, or verification guidance, so it does
not affect the clean-room claim — but it is not the USER's wording and is labelled CLAUDE_ORCHESTRATOR here
rather than presented as the USER's.

**Compact-resume seeds (5).** On context pressure the supervisor started a fresh thread seeded with the
original `TASK_PROMPT.txt` content (6,084 chars) plus the worker's own
`.agent-state/checkpoint.md`. The re-seed introduced **no new instructions** — it is the same task text the
worker already had, so continuity across threads did not smuggle in new guidance.

**Thread accounting correction.** Six distinct Codex sessions were used, not seven. The feedback segment
**resumed** session `…15-54-26` (created 15:54:26 during the first segment; last written 16:12:17) rather
than creating a new one. Earlier drafts added the feedback segment's "1 thread" to the first segment's 6 and
reported 7; the measured value is **6**.

---

# Appendix 1 — `TASK_PROMPT.txt` (verbatim)

> CLAUDE_ORCHESTRATOR-authored, from USER requirements. SHA256 `fbf179357b69e4b05200a42ee81231246d9898a237ab7d298156dccaedc6a958`.
> `THE_URL_BELOW` was substituted with the live serving URL at delivery.

```text
Before substantive implementation, inspect the installed Skills relevant to this task, read their SKILL.md content, and apply their methods where materially useful.

Priority for this run:
  1. threejs-qa-release       — deterministic test hooks (__THREE_GAME_TEST_HOOKS__ / __AGENT_STATE__ convention),
                                automated playtest. Read references/playtest-bot.md. This is how you PROVE things.
  2. threejs-debug-profiler   — first-person camera/input debugging, transforms, pointer behaviour.
                                Read references/debug-profile-checklists.md and references/checklists/scene-debugging.md.
  3. threejs-gameplay-systems — FPS controls, camera-relative movement, raycast/hit detection, update order,
                                game feel. Read references/gameplay-workflows.md.
  4. threejs-game-ui-designer — centre crosshair and floating health-bar UI.
  5. threejs-aaa-graphics-builder — readable block-built visuals, lighting/material variation.
  6. game-engine / game-developer — general 3D web game techniques (references/3d-web-games.md).
Use threejs-game-director only if it materially helps. Do not force irrelevant Skills.

Then read GAME_GOAL.md and AGENTS.md in this folder and build what GAME_GOAL.md specifies.

This folder is served at THE_URL_BELOW — put your entry HTML at index.html and open that URL to test.
Three.js is vendored locally at ./three.module.js (no CDN needed, no external assets).

=== THE SINGLE MOST IMPORTANT THING ===
A PREVIOUS BUILD WAS MATHEMATICALLY SELF-CONSISTENT AND STILL WRONG. Its player transform, its HUD, and its
ground-tile labels all agreed with each other perfectly — and on screen, front/back were reversed and
left/right were reversed. The human player experienced it as backwards.

So: INTERNAL CONSISTENCY IS NOT EVIDENCE OF CORRECTNESS. Three internal sources agreeing proves nothing about
what the player sees. You must prove orientation from SCREEN-SPACE PROJECTION.

At spawn the player is at logical (0,0) looking toward logical +Y:
   W -> (0,1) must be VISIBLY IN FRONT      S -> (0,-1) behind
   A -> (-1,0) must be VISIBLY ON THE LEFT  D -> (1,0) visibly on the RIGHT
   W+A (-1,1)   W+D (1,1)   S+A (-1,-1)   S+D (1,-1)

You must prove the visible directions are correct, and it is your responsibility to choose how. Whatever
method you pick, it must reflect what actually appears on screen rather than internal numbers agreeing with
each other. If the directions come out swapped, the build is reversed no matter what your HUD says.

=== CAMERA-RELATIVE MOVEMENT (this is a real FPS) ===
After the player turns with the mouse: W = camera facing projected onto the ground; S = opposite;
A = strafe screen-LEFT; D = strafe screen-RIGHT. Looking up/down must not move the player vertically.
Verify at initial facing, after ~90 deg right, and after ~90 deg left. Reversed A/D or W/S is BLOCKING.

=== CROSSHAIR-TO-HIT (BLOCKING) ===
Crosshair at the EXACT viewport centre. What the crosshair covers must be what the shot hits. Derive the
authoritative aim ray from the camera centre, NOT from a decorative gun barrel (the muzzle may be visually
offset; hit detection must follow the crosshair). Build an aiming calibration target and prove the ray and the
crosshair agree. Also prove a near-miss: aim just beside a zombie -> no hit registered.

=== THE GAME ===
One large indoor room, block-built floor, player near one end, exactly TWO zombies on the far side, both
visible soon after spawn. First person: mouse look + pointer lock, camera-relative WASD, centre crosshair,
block-built fake arms + machine gun, infinite ammo, rapid fire while held.
Zombie A stands still. Zombie B walks slowly toward the player. Both: block-built humanoid silhouette, health
bar above the head, exactly 5 HP — each valid hit removes 1, dies on the 5th (not 4th, not 6th), readable hit
feedback, obvious death feedback, dead zombie stops being a live target.
Visuals: multiple blocks per body, decent silhouettes, lighting/material variation — better than bare cubes.

=== TEST HOOKS ===
Expose window.__AGENT_STATE__ with: player logical+world position, camera yaw, camera forward vector,
crosshair target, last shot hit/miss + target id, both zombies' health/positions, ready. Plus a deterministic
fire() and a way to set yaw/position for testing. Keep hooks working even when debug visuals are hidden.

=== SUGGESTED ORDER ===
room + first-person camera -> correct initial facing -> verify initial WASD by screen projection ->
camera-relative movement -> verify after rotation -> centre crosshair -> centre-view ray -> calibration target
and prove crosshair/ray agreement -> hands + gun -> two zombies -> health bars -> 5-hit death ->
Zombie B slow approach -> visual polish -> full runtime verification.

=== VERIFICATION STANDARD ===
BUILD PASS is not GAMEPLAY VERIFIED. PAGE LOADS is not FPS VERIFIED. RAYCAST EXISTS is not CROSSHAIR ALIGNMENT
VERIFIED. Use codex-browser (`codex-browser help`) to open the page, read state, eval expressions, send keys,
and screenshot. Separate mechanically verified / visually inspected / human-only (real pointer-lock feel).

=== STOP CONDITION ===
When the game genuinely works — correct human-visible movement, camera-relative movement, centre crosshair,
crosshair-to-hit alignment, machine gun, infinite ammo, two zombies (one stationary, one approaching), health
bars, exactly five hits to kill, runtime verified, no fatal page errors — write REPORT.md with your evidence
(including the screen-projection proof and the 5-hit sequences) and stop. Do not stop after scaffolding.
```

**Note on the phrase "SCREEN-SPACE PROJECTION"** (paragraph 2 above): the *requirement* is the USER's
("PLAYER-VISIBLE DIRECTION is the ground truth"); the *phrase* is CLAUDE_ORCHESTRATOR's restatement. It names
a class of evidence, not a technique, and the very next paragraph returns method choice to the worker. This
is the surviving trace of the correction described in Section F — the prescriptive `camera.project(...)`
instruction was removed; the "prove it from the screen" requirement was kept because it is the USER's.

---

# Appendix 2 — `GAME_GOAL.md` (verbatim)

> CLAUDE_ORCHESTRATOR-authored, from USER requirements. SHA256 `32a62bfda3a2d6860c63672c639e28cb8ea293e242a0187bdd3ceabd2f1a3809`.
> Retrieve with `git -C ~/side-projects/games/web/zombie-fps-local-ai show zombie-fps-benchmark-v1:GAME_GOAL.md`

Structure: title → **RULE ZERO — PLAYER-VISIBLE DIRECTION IS THE AUTHORITY** (with the authoritative spawn
diagram and the 8-direction table from USER item B4) → camera-relative movement → room → player →
**CROSSHAIR — BLOCKING REQUIREMENT** → zombies (exactly two, 5 HP, health bars) → visual style → test hooks →
verification standard → deliverable.

The passage that governs the contamination question (lines 47-49), verbatim:

```
Do NOT accept "all internal sources agree with each other" as proof of orientation. That test passed last time
and the result was still reversed on screen. It is your responsibility to decide how to prove the visible
directions are correct.
```

Blocking crosshair requirement, verbatim (lines 80-89):

```
The crosshair must sit at the **exact centre of the rendered viewport**, and the player must be able to trust:
> **what the crosshair covers == what the shot hits**
The authoritative aim ray must originate from the camera / centre of view, or otherwise be mathematically
guaranteed to correspond to the centre crosshair. A decorative gun barrel may be visually offset, but
**hit detection must follow the crosshair, not the barrel.**
```

---

# Appendix 3 — `AGENTS.md` (verbatim)

> CLAUDE_ORCHESTRATOR-authored; injected by the Codex harness as **SYSTEM/AGENTS** at the head of every
> thread. SHA256 `de73b37a26f0a4d0793f980e0e83c8b941ab2926d2a18aa456662709c27d3382`.

```markdown
# Agent working agreement — zombie FPS prototype (clean room)

## Scope
Build the FPS specified in `GAME_GOAL.md`, in THIS folder. When it genuinely works, write `REPORT.md` and stop.

## RULE ZERO — player-visible direction is the authority
A previous build was internally self-consistent and still shipped reversed front/back and left/right.
**Never accept a coordinate convention because the numbers agree with each other.** Prove orientation from
screen-space projection (what the player sees). See `GAME_GOAL.md`.

## Clean room
Fresh implementation here only. Do NOT open, read, or copy code from any other project on this machine —
including the previous `fps-grid-calibration` project. Generic Three.js/JS knowledge, general coordinate
reasoning, and the installed Skills are fine; copying product code is not.

## Local-only
No hosted AI, no web search for solutions, no copying implementations from GitHub/StackOverflow.
Three.js is vendored locally as `./three.module.js` — use it; no external 3D assets.

## Method
- Read the relevant installed Skills' `SKILL.md` before substantive implementation.
- Iterate: design → implement → run in the browser → observe → test → fix your own code → retest.
- Drive the browser with `codex-browser` (run `codex-browser help`). Expose `window.__AGENT_STATE__` so state
  is readable via `codex-browser state`.
- Keep bulk output in files, not in the conversation.
- Maintain `./.agent-state/checkpoint.md` as you go so work survives a context reset.

## Blocking defects — do not report complete with any of these
1. W/S or A/D reversed relative to what the player sees on screen.
2. Movement not camera-relative after the player turns.
3. Crosshair not at the exact viewport centre.
4. Crosshair-to-hit misalignment (crosshair on a zombie with clear line of sight, shot misses).
5. A zombie dying on the 4th or surviving the 5th valid hit.
6. Fatal page errors.

## Evidence standard
"It looks right" is not evidence. Prove with deterministic hooks and browser automation, and state clearly
which findings are mechanically verified vs visually inspected vs human-only.
```

---

# Appendix 4 — Skill exposure vs actual use

Per the USER's instruction that mentions must not be counted as application, this table credits a Skill only
where a **shell command in the accepted-run transcripts actually opened the file**.

| Skill | Files actually opened in accepted run | State |
|---|---|---|
| `threejs-qa-release` | `SKILL.md`, `references/playtest-bot.md` | **APPLIED** |
| `threejs-debug-profiler` | `SKILL.md`, `references/debug-profile-checklists.md`, `references/checklists/scene-debugging.md` | **APPLIED** |
| `threejs-gameplay-systems` | `SKILL.md`, `references/gameplay-workflows.md` | **APPLIED** |
| `threejs-game-ui-designer` | `SKILL.md`, `references/ui-patterns.md` | **APPLIED** |
| `threejs-aaa-graphics-builder` | `SKILL.md` | **APPLIED** |
| `game-engine` | `references/3d-web-games.md` only (**not** its `SKILL.md`) | **APPLIED (reference only)** |
| `game-developer` | none | **MENTIONED ONLY** — named in `TASK_PROMPT.txt`, never read |
| `threejs-game-director` | none | **MENTIONED ONLY** — named in `TASK_PROMPT.txt`, never read |

**Why raw mention counts are not used.** Each of the eight names appears ~100 times across the transcripts,
purely because `TASK_PROMPT.txt` (which lists all eight) is re-seeded into every thread. Mention frequency
therefore carries no information about use; only the 13 file-opening commands do.

---

*Companion documents:* `ZOMBIE_FPS_LOCAL_AI_REFERENCE_BENCHMARK.md` (main record) and
`ZOMBIE_FPS_LOCAL_AI_REFERENCE_BENCHMARK.json` (machine-readable).

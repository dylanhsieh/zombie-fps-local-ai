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

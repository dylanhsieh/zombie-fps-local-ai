# Codex Skills given to the Local AI

The local model was pointed at an 8-skill pack before it wrote any code. This page is the complete,
honest accounting of that pack: what each skill is, where it came from, and **whether the model
actually opened it** during this run.

## Licensing — why the skill text is not vendored here

All 8 skills are **third-party MIT** content from three upstream repositories. Rather than
redistribute ~635 KB of someone else's files, this repo pins the exact upstream commits and ships
[`fetch-skills.sh`](fetch-skills.sh), which reconstructs the identical pack. Each skill's recorded
content SHA256 is in [`skills_manifest.json`](skills_manifest.json) so you can verify you got the same bytes.

| Upstream | Commit | Skills | License |
|---|---|---|---|
| [github/awesome-copilot](https://github.com/github/awesome-copilot) | `f11a4e44` | `game-engine` | MIT |
| [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) | `882ef55e` | `game-developer` | MIT |
| [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) | `7221c1f4` | the six `threejs-*` skills | MIT |

Credit for the skills belongs to those authors. Nothing in this directory is my work except the
evidence columns and this description.

## What was actually used

A skill is credited **only** where a shell command in the run transcripts genuinely opened the file.
13 such commands exist across the run.

| Skill | Files the model opened | Status | Evidence in the product |
|---|---|---|---|
| `threejs-qa-release` | `SKILL.md`, `references/playtest-bot.md` | **APPLIED** | `__THREE_GAME_TEST_HOOKS__` + `__AGENT_STATE__` exposed; deterministic hooks drove every proof in the report |
| `threejs-debug-profiler` | `SKILL.md`, `references/debug-profile-checklists.md`, `references/checklists/scene-debugging.md` | **APPLIED** | camera/transform + input debugging; used when diagnosing the reversed mouse-X axis |
| `threejs-gameplay-systems` | `SKILL.md`, `references/gameplay-workflows.md` | **APPLIED** | camera-relative movement, `Raycaster` ×3, update ordering |
| `threejs-game-ui-designer` | `SKILL.md`, `references/ui-patterns.md` | **APPLIED** | centre crosshair (×5), HUD, floating health bars |
| `threejs-aaa-graphics-builder` | `SKILL.md` | **APPLIED** | `MeshStandardMaterial` ×16, lighting/material variation on the block-built bodies |
| `game-engine` | `references/3d-web-games.md` | **APPLIED (reference only)** | world-space transform reasoning — note its `SKILL.md` was never opened, only this one reference |
| `game-developer` | — none — | MENTIONED ONLY | named in `TASK_PROMPT.txt`, never read |
| `threejs-game-director` | — none — | MENTIONED ONLY | named in `TASK_PROMPT.txt`, never read |

> **Mention counts are not evidence, and this repo does not use them.** Each of the eight names appears
> ~100× across the transcripts purely because `TASK_PROMPT.txt` lists all eight and is re-seeded into
> every thread. `game-developer` (never read) scores almost the same mention count as `threejs-qa-release`
> (read twice). Only file-opening commands distinguish them.

**Net: 6 of 8 skills were read, 2 were never opened** — and the two ignored were the two the task
prompt itself deprioritised. `game-engine` is a partial case: the model read one reference file but
never its `SKILL.md`.

## The pack, skill by skill

### `threejs-qa-release`

> Verify and release Three.js browser games. Combines playtest QA, automated bot playtests, mobile/responsive checks, production builds, preview verification, static-hosting base paths, debug gating, bundle review, screenshots, visual test harness decisions, packaged canvas-pixel inspection with measu…

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-qa-release` · MIT
- **Files in pack:** 12 · content SHA256 `8f2116a79436939f…`
- **This run:** APPLIED — `__THREE_GAME_TEST_HOOKS__` + `__AGENT_STATE__` exposed; deterministic hooks drove every proof in the report

### `threejs-debug-profiler`

> Debug and profile Three.js browser games. Combines scene debugging, render/runtime/loading/animation/resize/mobile input fixes, performance profiling, draw calls, triangles, textures, memory, shader/post-processing cost, bundle size, and mobile DPR/input issues.

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-debug-profiler` · MIT
- **Files in pack:** 7 · content SHA256 `ff2a086a21191a2d…`
- **This run:** APPLIED — camera/transform + input debugging; used when diagnosing the reversed mouse-X axis

### `threejs-gameplay-systems`

> Build and iterate playable Three.js game systems. Combines starter scaffold creation, architecture, game design, level design, gameplay implementation, combat/encounter design, and game-feel tuning (hitstop, screenshake, easing, impact feedback). Use for first playable slices, new Vite/TypeScript/Th…

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-gameplay-systems` · MIT
- **Files in pack:** 39 · content SHA256 `58fd0b44cecacde1…`
- **This run:** APPLIED — camera-relative movement, `Raycaster` ×3, update ordering

### `threejs-game-ui-designer`

> Design premium Three.js game UI. Use for HUDs, menus, overlays, pause/win/lose screens, settings, icon controls, touch UI, typography, responsive layout, safe areas, text fit, and UI/world cohesion.

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-game-ui-designer` · MIT
- **Files in pack:** 8 · content SHA256 `fa5ee12eaf7fdc82…`
- **This run:** APPLIED — centre crosshair (×5), HUD, floating health bars

### `threejs-aaa-graphics-builder`

> Upgrade Three.js games from basic/prototype visuals to premium AAA-inspired browser graphics. Combines art-direction critique, procedural model building, technical art, mandatory external asset sourcing decisions, threejs-3d-generator assets, threejs-image-generator concept/texture workflows, scene …

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-aaa-graphics-builder` · MIT
- **Files in pack:** 18 · content SHA256 `f764d8ad1bc929e1…`
- **This run:** APPLIED — `MeshStandardMaterial` ×16, lighting/material variation on the block-built bodies

### `game-engine`

> 'Expert skill for building web-based game engines and games using HTML5, Canvas, WebGL, and JavaScript. Use when asked to create games, build game engines, implement game physics, handle collision detection, set up game loops, manage sprites, add game controls, or work with 2D/3D rendering. Covers t…

- **Upstream:** [github/awesome-copilot](https://github.com/github/awesome-copilot) @ `f11a4e44` · path `skills/game-engine` · MIT
- **Files in pack:** 15 · content SHA256 `72d38d5568aa8cc6…`
- **This run:** APPLIED (reference only) — world-space transform reasoning — note its `SKILL.md` was never opened, only this one reference

### `game-developer`

> Use when building game systems, implementing Unity/Unreal Engine features, or optimizing game performance. Invoke to implement ECS architecture, configure physics systems and colliders, set up multiplayer networking with lag compensation, optimize frame rates to 60+ FPS targets, develop shaders, or …

- **Upstream:** [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) @ `882ef55e` · path `skills/game-developer` · MIT
- **Files in pack:** 6 · content SHA256 `0138b2d8042f0c56…`
- **This run:** MENTIONED ONLY — named in `TASK_PROMPT.txt`, never read

### `threejs-game-director`

> Primary entrypoint for complete Three.js browser game creation and premium iteration. Use by default for build-a-game, upgrade, polish, premium, AAA, high-fidelity, showcase, from-scratch, endless runner, arcade, action, or release-ready requests. Orchestrates sibling skills for gameplay, AAA graphi…

- **Upstream:** [majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) @ `7221c1f4` · path `skills/threejs-game-director` · MIT
- **Files in pack:** 6 · content SHA256 `7890f63d936c9490…`
- **This run:** MENTIONED ONLY — named in `TASK_PROMPT.txt`, never read

## Excluded on purpose

Three sibling skills were **deliberately not installed**, because this experiment had to be verifiably
local-only: `threejs-3d-generator`, `threejs-image-generator`, `threejs-audio-generator`. Each calls an
external generation API (TRIPO / Gemini / ElevenLabs). Excluding them is what makes "no hosted AI"
checkable rather than merely asserted.

The graphics and director skills were safe to keep: their credential probe only reads environment
variables, and with the keys unset they report MISSING and fall back to procedural generation.

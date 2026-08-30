# Zombie FPS — built end-to-end by a local LLM

**▶ [Play it in the browser](https://dylanhsieh.github.io/zombie-fps-local-ai/)** — no install, no build step.

A first-person shooter in Three.js. Every line of `game.js` was written, tested, debugged and verified by a
**locally-hosted Qwen model** running through Codex CLI against a llama.cpp/ik_llama server on a home GPU.
No hosted AI wrote any product code. The whole thing took **2 h 26 m** across 37 turns.

This repo is the complete record — the game, the exact prompts, the skills the model was given, the raw
supervisor logs, and a benchmark that is candid about what could not be measured.

```
Controls   WASD move · mouse look · hold LEFT MOUSE to fire · click to lock pointer
Goal       Two zombies. Five hits each. One stands still, one walks at you.
```

## What actually happened

| | |
|---|---|
| Model | Qwen3.8, **26.9 B params** (26,895,998,464, measured from tensors), mixed IQ4_KT/IQ4_KS quant, 13.7 GiB |
| Hardware | **RTX 5080 (16 GB)** · Ryzen 7 7700 · 64 GB DDR5 · one consumer desktop |
| Server | ik_llama `llama-server`, 49,152 ctx, 1 slot, q4_0 KV + Hadamard, flash-attn on |
| Harness | Codex CLI 0.149.1, 47,616-token client context, reasoning effort `xhigh` |
| Duration | 2 h 26 m 22 s — 37 turns, 35 automatic continuations |
| Context handling | 11 internal compactions, 6 threads, **0 context exhaustions** |
| Inference | 766 requests, 763 generations, **0 failures — `200` was the only status code in the entire log** |
| Throughput | prefill 538 tok/s median · decode 44.7 tok/s median (n = 763) |
| Human input | One sentence of playtest feedback, at 2 h 13 m |
| Result | Accepted by the human after playing it |

The model's native context is **262,144** tokens; this run used 47,616 of it, and the largest prompt reached
41,800 — so nothing ever came near the ceiling. Both the client and backend datasets are reconciled against
the same closed window and published as `VERIFIED` in [`docs/BENCHMARK.md`](docs/BENCHMARK.md).

The orchestrating model (Claude) was deliberately fenced off: it transmitted the task, launched and
supervised the worker, sent neutral "continue" prompts, and recorded timings. It did not write, debug, test
or verify the game. That constraint is the experiment.

## The interesting part

A previous attempt at this game had been **mathematically self-consistent and still wrong** — every internal
number agreed with every other internal number, and on screen left and right were reversed. So the prompt
demanded the model prove direction *from what the player sees*, while pointedly refusing to say how:

> You must prove the visible directions are correct, and it is your responsibility to choose how.

That restraint had to be enforced against the orchestrator, not just written down. An earlier launch was
accidentally handed a prescribed technique — *"PROVE IT LIKE THIS (required): project tile world positions
with `camera.project(...)`"* — the human caught it, and that entire run was thrown away and the project reset.
[The contamination record](docs/INPUT_PROVENANCE.md) documents this in full, including the test showing the
discarded instruction never reached the run that counted (0 occurrences across all six threads, against 6 in
the discarded one).

Left to itself, the model read the vendored Three.js source, worked out the projection semantics, and wrote
its own helper — including a subtlety nobody told it about:

```js
function projectToScreen(wx, wy, wz) {
  // Do NOT call camera.updateMatrixWorld() here: the camera's matrixWorld is
  // set every frame by syncCamera(); recomputing it from the stale local
  // matrix would clobber the live transform (and corrupt the next frame's
  // aim ray). Project against the matrixWorld as it stands.
```

It then used that helper to prove all eight movement directions, crosshair-to-hit alignment, and a
deliberate near-miss negative control. When a pure-lateral point projected to `NaN`, it correctly identified
that as expected near-plane math rather than a bug, and proved left/right via the diagonals instead.

The one thing it got wrong was one it could not have detected: **the mouse X-axis was inverted**. No
automated check catches that — the code was self-consistent, and only a human with a hand on a mouse feels
it. The human reported it in one sentence; the model found the sign error at `game.js:182`, fixed it in a
single line, verified the fix by screen projection, re-ran its regressions, and stopped.

## Repo map

| Path | What's in it |
|---|---|
| `index.html`, `game.js`, `three.module.js` | the game — vendored Three.js, no CDN, no external assets |
| [`prompts/`](prompts) | the exact files the model was given, verbatim, with authorship labels |
| [`skills/`](skills) | the 8-skill Codex pack: what each is, and **which ones it actually opened** |
| [`docs/LOCAL_AI_REPORT.md`](docs/LOCAL_AI_REPORT.md) | the model's own verification report, in its own words |
| [`docs/BENCHMARK.md`](docs/BENCHMARK.md) | full reference benchmark — timings, tokens, hardware, telemetry gaps |
| [`docs/INPUT_PROVENANCE.md`](docs/INPUT_PROVENANCE.md) | who instructed what, and the discarded-run record |
| [`run-logs/`](run-logs) | raw supervisor output for all 37 attempts |

## Skills: 8 given, 6 read, 2 ignored

The model was pointed at eight Three.js/gamedev skills before writing code. It opened six and ignored two —
and the two it ignored were the two the prompt itself deprioritised. [`skills/README.md`](skills/README.md)
credits a skill **only** where a shell command genuinely opened the file, because mention counts are
worthless here: every skill name appears ~100× in the transcripts purely from prompt echo, so a skill that
was never read scores about the same as one read twice.

The skills are third-party MIT content and are **not** vendored here; the exact upstream commits are pinned
and [`skills/fetch-skills.sh`](skills/fetch-skills.sh) reconstructs the identical pack.

## What this does and does not show

It **does** show that a 27B model on consumer hardware can carry a graphical, spatially-reasoned build
through 2.5 hours and six context resets without losing the thread, and can hold itself to an evidence
standard stricter than "it looks right".

It **does not** show that any single ingredient caused that. This is one run with no control arm — nothing
here attributes the outcome to the skills, or the reasoning effort, or the context size, or the orchestration
style. It is a baseline to compare future runs against, not a proof of causation.

Some things were simply not measured, and the benchmark says so rather than guessing: GPU utilisation and
VRAM over the run were never sampled, and the slot-occupancy monitor was pointed at the wrong port for most
of the run, making all 1,714 of its samples useless. Those are recorded as unavailable. Reporting "0% busy"
from connection-refused rows would have been a fabricated measurement.

Two details worth singling out, because both cut against the tidy version of this story:

- **The filename lied about the model, and the record was corrected.** The GGUF is named
  `…IQ4_KT-attn_qkv-IQ4_KS…`, and that name was initially taken at face value. Reading the per-tensor types
  out of the GGUF header instead showed there is **no fused `attn_qkv` tensor at all** (Q, K and V are
  separate) and that `attn_v` is IQ5_KS — *higher* precision than the name implies. The filename is a label,
  not evidence.
- **Three requests produced no generation, and nobody knows why.** 746 POSTs from the client, 743 counted by
  the client's own router, 763 generations. The discrepancy is documented down to the four unmatched
  timestamps — and then explicitly *not* explained, because no field in either log establishes the cause. It
  would have been easy to call it "explained"; it is only narrowed.

Known limitation the model flagged itself: real pointer-lock *feel* cannot be automated. That is exactly
where the one genuine defect hid.

## Credits

Game code: written by a local Qwen model, directed by [@dylanhsieh](https://github.com/dylanhsieh).
Orchestration and this write-up: Claude, in a deliberately restricted role.
[Three.js](https://threejs.org) is MIT, © its authors. The Codex skills are MIT and belong to
[github/awesome-copilot](https://github.com/github/awesome-copilot),
[Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills), and
[majidmanzarpour/threejs-game-skills](https://github.com/majidmanzarpour/threejs-game-skills) — see
[`skills/README.md`](skills/README.md).

Local paths, LAN addresses and the backend hostname have been redacted from the published logs and reports.

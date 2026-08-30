# Zombie FPS — Local-AI Reference Benchmark

```
ZOMBIE_FPS_REFERENCE_BENCHMARK: VERIFIED
LOCAL_AI_PRODUCT:               COMPLETE
LOCAL_AI_RC:                    0
HUMAN_PLAYTEST_ACCEPTED:        YES   (2026-08-30 16:25:14 +0800)
```

Client and Backend data are reconciled against the same closed window **13:45:55 → 16:12:17 +0800**, and every
remaining unknown is explicitly labelled. Backend published its closed-window dataset on LAI-15 with the
verdict `ZOMBIE_FPS_BACKEND_BENCHMARK_DATA: VERIFIED`.

> **The re-scope confirmed rather than corrected the counts.** Backend's first snapshot ran to 16:16:59; on
> re-scoping, the excluded 4 m 42 s contained **0 POSTs and 0 generations** — GET probes only. Every
> run-specific inference figure is numerically identical to the open-window snapshot. Re-scoping was still
> required: without it, "identical" would have been an assumption rather than a measurement. What did change
> is that 2 client GETs and 67 localhost GET probes are now correctly excluded from the origin table.

Ownership: **Backend** owns hardware/inference facts · **Client** owns Codex/orchestration/Skills/session/task
facts. Values are labelled `MEASURED`, `DERIVED`, `VERIFIED`, `NOT_AVAILABLE`, `NOT_VERIFIED`, or
`AWAITING_RESCOPE`. Two telemetry axes are permanently `NOT_AVAILABLE` for this window and are documented
rather than estimated — see **§9.3**.

**Companion document:** `ZOMBIE_FPS_LOCAL_AI_REFERENCE_BENCHMARK_INPUT_PROVENANCE.md` — the complete
USER → LOCAL AI instruction chain, verbatim inputs, and the rejected-launch contamination record.

> **Corrections applied to earlier drafts of this file**, each explained in place rather than silently edited:
> physical threads **7 → 6** (§4); the contamination claim restated on an exact-form test after the original
> substring test proved unsound (§2); and the "mentioned 22×" skill figures dropped as prompt-echo artefacts
> (§6).

---

## 1. RUN IDENTITY

| Field | Value | Source |
|---|---|---|
| Benchmark name | Zombie FPS — Local-AI Reference Benchmark | — |
| Date | 2026-08-30 (+0800) | MEASURED |
| Project path | `~/side-projects/games/web/zombie-fps-local-ai` | MEASURED |
| Playable URL | `http://127.0.0.1:8802/` (HTTP 200 at capture) | MEASURED |
| Git (frozen) | commit **`d5312f6`**, tag **`zombie-fps-benchmark-v1`**, working tree **clean** | MEASURED |
| Session (segment 1, thread 1) | `01a05133-f728-7d12-a99c-c0497b0dedc1` | MEASURED |
| Session (final thread, resumed for feedback) | `01a051a9-a2b6-7242-b1b6-7b7edc788335` (created 15:54:26) | MEASURED |
| **LOCAL_AI_START_TIME** | **2026-08-30 13:45:55 +0800** | MEASURED |
| **Final completion (implementation terminal)** | **2026-08-30 16:12:17 +0800** | MEASURED |
| **TOTAL WALL-CLOCK** | **8,783 s = 2 h 26 m 22 s** | DERIVED (end − start) |
| **HUMAN_PLAYTEST_ACCEPTED** | **2026-08-30 16:25:14 +0800** — recorded **separately**, deliberately **excluded** from the window | MEASURED |

**Human feedback was injected inside this same logical run.** Segments are listed for detail only; total
benchmark wall time is measured from the original start to final completion, and the feedback segment is
**not** treated as a separate benchmark.

| Segment | Window | Duration | Terminal |
|---|---|---|---|
| 1 — initial build | 13:45:55 → 16:00:28 | 8,073 s | `rc=143` — **operator SIGTERM**, see below |
| — feedback delivered | 16:01:16 | — | verbatim user message into the same session |
| 2 — post-feedback | 16:01:16 → 16:12:17 | 662 s | `rc=0`, supervisor `COMPLETE`, predicate pass |

> **The `rc=143` is an OPERATOR INTERVENTION, not a failure or a completion.** To inject the user's feedback,
> Claude sent `SIGTERM` to the *supervisor loop only* (not the worker's process group), because the supervisor
> would otherwise keep injecting its own neutral continuation and the user's message would never be delivered.
> The live worker turn ran to its natural end and feedback went in at 16:01:16. Recorded explicitly so this is
> never later misread as a crash.

---

## 2. TASK / PROMPT PROVENANCE

Files visible to the worker in the project root (SHA-256 first 16):

| File | SHA-256 | Size | Role |
|---|---|---|---|
| `TASK_PROMPT.txt` | `fbf179357b69e4b0` | 5,650 B | the delivered task |
| `GAME_GOAL.md` | `32a62bfda3a2d686` | 5,529 B | the specification |
| `AGENTS.md` | `de73b37a26f0a4d0` | 2,142 B | standing rules, clean-room + blocking defects |
| `USER_FEEDBACK_1.txt` | `ef5bb0248de31bf2` | 525 B | verbatim human feedback |

- **Instructions from the user:** the entire game specification — RULE ZERO (player-visible direction is the
  authority), the spawn orientation table, camera-relative movement, the crosshair-to-hit blocking requirement,
  the two-zombie/5-hit rules, visual style, verification standard, implementation order.
- **Clean-room rule:** fresh implementation in a new project; explicitly forbidden from reading or copying the
  previous `fps-grid-calibration` product code. Three.js vendored locally; no external assets.
- **Claude-added technical guidance: REMOVED before the successful run.** An earlier launch (13:43:11) was
  delivered a Claude-prescribed verification method — *"PROVE IT LIKE THIS (required): project tile world
  positions with `camera.project(...)`"* — confirmed present at `role=user` in that run's transcript, i.e. it
  really did reach that worker. The operator's ROLE CORRECTION arrived at 13:43:20; the prompt files were
  rewritten 17–19 s later and the project reset. Contamination test across **all six** accepted-run threads
  (raw text search, no JSON parsing):

  | Marker | Accepted run | Rejected run (control) |
  |---|---|---|
  | `PROVE IT LIKE THIS` | **0** | 2 |
  | `project tile world positions` | **0** | 2 |
  | `camera.project(` (prescribed call form) | **0** | 6 |

  > **Correction to an earlier draft of this document.** It previously asserted "`camera.project` occurrences
  > = 0" from a JSON-field scan. A later raw grep found the *substring* `camera.project` in 3 accepted
  > threads; every instance is `camera.**project**ionMatrix` inside **Three.js library source** the worker
  > grepped out of `three.module.js` itself. The exact call form is 0. The conclusion stands, but it now rests
  > on an exact-form test rather than a substring test, and the earlier wording was too strong.

  The Local AI then chose its own method independently, writing `v.clone().project(camera)` in its own
  `projectToScreen()` helper (`game.js:672-684`) — a **different call form** than the one Claude had
  prescribed — after reading the vendored Three.js source to work out the semantics.
- **Full provenance appendix:** `ZOMBIE_FPS_LOCAL_AI_REFERENCE_BENCHMARK_INPUT_PROVENANCE.md` — the complete
  USER → LOCAL AI instruction chain (sections A–E), the rejected-launch record kept strictly separate, the
  verbatim input files, and per-item `USER` / `CLAUDE_ORCHESTRATOR` / `LOCAL_AI` / `SYSTEM_AGENTS` labels.
- **Delivery verified, not assumed:** the task prompt in the accepted run's thread-1 transcript is an **exact
  byte match** to the frozen `TASK_PROMPT.txt` core block (only the `THE_URL_BELOW` placeholder differs).
- **Disclosed:** the worker-facing files are Claude *transcriptions* of user requirements, not verbatim user
  text; and the continuation string actually sent 30× was Claude-authored, not the operator's suggested
  wording. Both are itemised in the provenance appendix (§C, §G) rather than smoothed over.
- **Orchestrator discipline:** Claude's role was transmit / launch / supervise continuity / record timing.
  **Claude is not credited with implementation, debugging, testing, or verification** — those are owned by
  local Qwen/Codex.

---

## 3. CLIENT / CODEX ENVIRONMENT (re-measured)

| Field | Value | Source |
|---|---|---|
| Codex version | **codex-cli 0.149.1** | MEASURED |
| Codex binary | `~/qa-research/codex-experiment/node_modules/.bin/codex` | MEASURED |
| CODEX_HOME | `~/qa-baseline/external-knowledge/codex-home-robot-tps` | MEASURED |
| Working directory | `~/side-projects/games/web/zombie-fps-local-ai` | worker banner |
| Effective context | **47,616** | per-run override, banner-confirmed |
| Reasoning effort | **xhigh** | per-run override, banner-confirmed |
| Sandbox | `workspace-write [workdir, /tmp, $TMPDIR]` | banner |
| Workspace network | enabled | banner |
| Approval policy | `never` (required for unattended; interactive would be `on-request`) | banner |
| Route | `:18095` → `:18090` → `http://<BACKEND_LAN_IP>:8092` | MEASURED |
| Backend contract seen by client | `n_ctx = 49152`, `total_slots = 1` | MEASURED (client-side read) |

**Persistent config (`config.toml`) vs per-run overrides — kept separate:**

| Setting | Persistent | Per-run override used |
|---|---|---|
| `model_context_window` | 32768 | **47616** |
| `model_reasoning_effort` | `high` | **xhigh** |
| `sandbox_mode` | `workspace-write` | (same, explicit) |
| `approval_policy` | `never` | (inherited) |
| `model_max_output_tokens` | 12288 — **INEFFECTIVE**, unknown key in 0.149.1, silently ignored | — |
| model / provider / base_url | Qwen3.8-27B IQ4_KT / `qwen-local` / `http://127.0.0.1:18095/v1`, `wire_api="responses"` | — |

`config.toml` was **not modified**; 47616 exists only as a per-run `-c` override.

---

## 4. LOCAL-AI / SUPERVISOR LIFECYCLE

| Metric | Segment 1 | Segment 2 | **Total** |
|---|---:|---:|---:|
| Attempts / turns | 23 | 14 | **37** |
| Automatic continuations | 22 | 13 | **35** |
| — soft resumes | 17 | 13 | 30 |
| — compact-resumes | 5 | 0 | 5 |
| Codex-internal compactions | 10 | 1 | **11** |
| Physical threads (distinct Codex sessions) | 6 | *(reused thread 6)* | **6** |
| Context-exhaustion events | 0 | 0 | **0** |
| `RUNAWAY_CAPPED` (attempt timeout) | 1 (a8) | 0 | 1 |
| Final exit code | 143 (operator) | **0** | — |
| Final supervisor state | interrupted | **COMPLETE** (predicate pass) | COMPLETE |

> **Thread-count reconciliation (corrected).** An earlier draft reported **7** physical threads by adding the
> feedback segment's "1 thread" to the first segment's 6. The measured value is **6**: the feedback segment
> *resumed* the existing session `01a051a9…` (created 15:54:26 during segment 1, last written 16:12:17) rather
> than creating a new one. Exactly six rollout files exist for the window. Published value: **6**.

- **MODEL_STOP_DECISION / `STALLED`:** 35 of 37 attempts exited cleanly and were classified `STALLED`
  (early-yield with forward intent) → automatically continued. Classification happens **on process exit only**,
  never on a wall clock.
- **Operator interventions:** 2 — (1) the aborted pre-corrected launch at 13:43:11 (stopped, project reset);
  (2) the SIGTERM at 16:00:28 to inject feedback.
- **Human-feedback injections:** 1 (16:01:16).
- **Infrastructure failures:** 0. **Worker failures:** 0. **Process restarts:** 0 unplanned.
- **No long silent productive turn was classified as a stall.** Liveness was judged from process state,
  inference activity, and file mtime — not from silence.

### Timeline
```
13:43:11  (aborted launch — carried Claude-injected guidance; stopped, project reset)
13:45:55  LOCAL_AI_START — supervised worker, 47616 / xhigh / workspace-write
13:47     index.html written
~14:20    attempt 6, thread 2, game.js 26.9 KB — browser test hooks in use
15:40-43  attempt 23: browser verification (setZombiePosition, setYaw, fire, screenshots)
16:00:28  OPERATOR SIGTERM to supervisor loop only (worker turn left running)
16:01:16  worker turn ended naturally -> USER FEEDBACK delivered verbatim (mouse X reversed)
16:02     game.js updated (27,318 -> 27,362 B)
16:12:17  supervisor COMPLETE (rc=0), REPORT.md written
```

---

## 5. TOKEN / CONTEXT METRICS

| Metric | Value | Source |
|---|---|---|
| Client context window | 47,616 | MEASURED |
| Attempts with a token reading | 35 / 37 | MEASURED |
| `tokens used` range across attempts | 38,728 … **174,400** (cumulative per attempt) | MEASURED |
| Codex-internal compactions | 11 | MEASURED |
| Context-pressure → fresh-thread compact-resumes | 5 | MEASURED |
| Hard context exhaustion | **0** | MEASURED |
| Context overflow / hard-500 | **0** | MEASURED |
| Requests through the client route (run window) | **743** | MEASURED |
| 5xx through the route | **0** | MEASURED |
| Truncation events | NOT_AVAILABLE (not exposed by the client) | — |
| Tokens per request | NOT_AVAILABLE client-side | AWAITING_BACKEND |
| Context remaining at checkpoints | NOT_AVAILABLE (not exposed) | — |

---

## 6. SKILLS

**INSTALLED (8, all enabled):** `game-engine`, `game-developer`, `threejs-gameplay-systems`,
`threejs-game-ui-designer`, `threejs-aaa-graphics-builder`, `threejs-debug-profiler`, `threejs-qa-release`,
`threejs-game-director`.

| Skill | DISCOVERED | LOADED — exact files read | APPLIED — fingerprint |
|---|---|---|---|
| `threejs-qa-release` | ✅ | ✅ `SKILL.md` ×3, `references/playtest-bot.md` ×3 | ✅ `__THREE_GAME_TEST_HOOKS__` + `__AGENT_STATE__` exposed; hooks driven in testing |
| `threejs-debug-profiler` | ✅ | ✅ `SKILL.md`, `references/debug-profile-checklists.md`, `references/checklists/scene-debugging.md` | ✅ camera/transform + input debugging (mouse-X root cause) |
| `threejs-aaa-graphics-builder` | ✅ | ✅ `SKILL.md` ×2 | ✅ `MeshStandardMaterial` ×16, lighting present |
| `game-engine` | ✅ | ⚠️ `references/3d-web-games.md` ×2 — its **`SKILL.md` was never opened** | ✅ world-space transform reasoning (reference-only) |
| `threejs-gameplay-systems` | ✅ | ✅ `SKILL.md`, `references/gameplay-workflows.md` | ✅ camera-relative movement, `Raycaster` ×3 |
| `threejs-game-ui-designer` | ✅ | ✅ `SKILL.md`, `references/ui-patterns.md` | ✅ centre crosshair (×5), HUD, health bars |
| `game-developer` | ✅ named in `TASK_PROMPT.txt` | ❌ never read | **MENTIONED ONLY** |
| `threejs-game-director` | ✅ named in `TASK_PROMPT.txt` | ❌ never read | **MENTIONED ONLY** |

**No skill is credited merely for being installed.** The two never-loaded skills were the two the task
deprioritised; the worker read the top-6 and skipped them.

> **Method — and why mention counts are not used as evidence.** A skill is credited only where a shell command
> in the accepted-run transcripts **actually opened the file**; 13 such commands exist. Each of the eight skill
> names also appears **~100×** across the transcripts, but that is an artefact: `TASK_PROMPT.txt` lists all
> eight and is re-seeded into every thread, so `game-developer` (never read) scores almost the same mention
> count as `threejs-qa-release` (read twice). An earlier draft cited "mentioned 22×" for the two unread
> skills; that figure measured prompt echo, not use, and has been dropped. Mention frequency carries no
> information here — only file-opening commands do.

**Test hooks exposed:** `window.__AGENT_STATE__`, `window.__THREE_GAME_TEST_HOOKS__`.
**Hook methods exercised during testing:** `fire`, `getCamera`, `holdKey`, `projectLogical`, `projectToScreen`,
`releaseAllKeys`, `respawn`, `setCalibrationTarget`, `setPitch`, `setPlayerPosition`, `setYaw`,
`setZombiePosition`.
**Browser automation:** `codex-browser` (open / eval / state / key / hold / screenshot / errors).

---

## 7. PRODUCT OUTPUT

| File | Size | Lines | SHA-256 (16) |
|---|---:|---:|---|
| `index.html` | 3,199 B | 66 | `9ab137652e6ebeec` |
| `game.js` | 27,362 B | 725 | `0c865352eb33772e` |
| `REPORT.md` | 7,190 B | 146 | `43f28da70944040a` |
| `three.module.js` | 1,272,972 B | — | vendored Three.js (r160) |
| `.agent-state/checkpoint.md` | — | — | worker-maintained continuity checkpoint |

Screenshots produced by the worker: `/tmp/shot-calib4.png`, `shot-case6.png`, `shot-spawn.png`,
`shot-topdown.png`, `shot-verify-diag.png`, `shot-verify-spawn.png` (+ `shot-1/2/3.png` cited in its report).
**Runtime console errors: 0** (`codex-browser errors` → empty, per the worker).

### The Local AI's own claimed verified behaviours
Reproduced from the worker's `REPORT.md`. **No independent Claude gameplay judgement is added** (not requested).

*Mechanically verified (its deterministic hooks + browser automation):*
- Orientation: all 8 directions proven by **screen-space projection** — W `(0,1)` NDC z=0.9 dead centre;
  S behind (z>1); W+A ndc.x=−0.86 (screen-left), W+D ndc.x=+0.86 (screen-right). A/D pure-lateral points sit in
  the near plane so `project()` yields NaN — it stated this as expected math and proved A/D via the diagonals
  plus the camera right-vector.
- Camera-relative movement at yaw 0 / +90° / −90°; pitch 0.9 + W keeps playerY at 1.7 (no vertical drift).
- Crosshair DOM centre **(640,400)** = exact viewport centre (1280×800); aim ray from camera centre, not the
  gun barrel; calibration ray → ndc (0,0) → screen (640,400).
- Crosshair→hit on A; **near-miss negative control** (off-centre A → crosshair null, `hit:false`).
- **Exactly 5 hits**: A and B each hp 5→4→3→2→1→0, `alive:false` on the 5th, kills 0→1. Dead zombie not
  re-targetable.
- Mouse-X fix verified by projection: mouse right → reference point re-projects to x=380.8 (view turned right);
  mouse left → x=899.2 (view turned left); pitch unchanged.
- Post-fix regression: W movement, A 5-hit kill, dead-A not targetable, no page errors.

*Visually inspected (screenshots + local vision):* blocky humanoid zombie with green visor, green health bar
above head, white centre crosshair, HUD (HP 100, KILLS 0/2), checkered floor, ceiling light, cast shadow.

*Human-only (it explicitly could not automate):* real pointer-lock / mouse-look **feel**.

---

## 8. HUMAN PLAYTEST FEEDBACK

- **Delivered:** 2026-08-30 **16:01:16**, verbatim, as the next user message in the same session
  (`codex exec resume --last`), after the active turn ended naturally.
- **Overall user assessment:** result satisfactory / promising — the build was already playable before final
  completion.
- **Exact feedback text (verbatim, not re-written into a Claude diagnosis):**

> "The game is already playable.
>
> However, the mouse X-axis appears to be reversed.
>
> When I move the mouse to the right, the camera/view turns in the opposite horizontal direction.
>
> Please correct the horizontal mouse-look direction so that:
> - moving the mouse right turns the view right;
> - moving the mouse left turns the view left.
>
> Do not change unrelated controls or gameplay unless necessary for this correction."

- **Did the Local AI modify the product afterward?** Yes — `game.js` 27,318 → 27,362 B at 16:02.
- **The Local AI's own diagnosis and result** (its words, its finding): `game.js:182` used
  `player.yaw -= e.movementX * MOUSE_SENS`; since positive yaw turns the view screen-right, a rightward mouse
  move *decreased* yaw and turned the view left. Fix: `player.yaw += e.movementX * MOUSE_SENS`, single line,
  pitch untouched. It then verified the fix by screen projection and re-ran regressions. Nothing unrelated was
  changed, as the user requested.

---

## 9. BACKEND DATA (Jira **LAI-15**)

Backend-owned. `VERIFIED` values below are quoted from Backend's published response of 16:20:08. Nothing here
is inferred by the Client.

### 9.1 Contract / runtime — VERIFIED

| Field | Value | Status |
|---|---|---|
| Host | `<BACKEND_HOST>` | VERIFIED |
| Active profile | `qwen-chunter-48k-1slot` | VERIFIED |
| Backend capacity `n_ctx` | **49,152** | VERIFIED (runtime-confirmed) |
| `total_slots` | 1 (`parallel=1`, so per-slot == capacity) | VERIFIED |
| Port / endpoints | 8092; LAN `http://<BACKEND_LAN_IP>:8092/v1`, tailnet `http://<BACKEND_TAILNET_IP>:8092/v1` | VERIFIED |
| Served model | `Qwen3.8-27B.i1-IQ4_KT-attn_qkv-IQ4_KS.gguf` | VERIFIED |
| Model SHA256 | `A8588CE80E23C1FD36C893A697BC953A05E3563CB3CC41F1C56F21EF47907236` | VERIFIED |
| Runtime | ik_llama `llama-server.exe`, pid 24468, started 08:47:43 | VERIFIED |
| Runtime SHA256 | `9CA87C9964AC2193AA4682B8433F13B2F793DC26AF89A673FD930510F465E41F` | VERIFIED |
| KV cache | `q4_0` / `q4_0` with Hadamard (`-khad -vhad`), flash-attn on | VERIFIED |
| Sampling | temp 0.6, top_p 0.95, top_k 20, reasoning off | VERIFIED |
| Backend output cap | **NONE** (`n_predict = -1`) — any output cap is request-side, Client-owned | VERIFIED |
| GPU driver | 610.88; compute capability 12.0 | VERIFIED |

Backend explicitly restates the ownership split: *backend capacity ≥ 49152; CLIENT owns its effective context
window at or below that capacity. The 47616 / 1536-headroom split is CLIENT convention, not Backend-owned.*

### 9.1b Hardware — all re-measured live by Backend (CIM / nvidia-smi), VERIFIED

| Component | Value |
|---|---|
| OS | Windows 11 Pro, version 25H2, build 26200.9278 |
| CPU | AMD Ryzen 7 7700 8-Core, 8 physical / 16 logical, max 3801 MHz |
| RAM | 67,821,981,696 B (63.16 GiB) — 2 × 32 GB Team Group UD5-6000, ch A + B, configured 5600 MT/s |
| GPU | **NVIDIA GeForce RTX 5080**, 16,303 MiB dedicated VRAM |
| GPU driver / vBIOS | 610.88 / 98.03.6c.00.28 · compute capability 12.0 · PCIe Gen 4 ×16 |
| Motherboard | ASUSTeK TUF GAMING B650M-E WIFI |
| GGUF storage | WD_BLACK SN850X 2000GB NVMe SSD |

### 9.1c Model identity — verified from the GGUF, not assumed

| Field | Value |
|---|---|
| Family / architecture | Qwen3.8 (GGUF architecture `qwen35`) |
| **Parameter count** | **26,895,998,464** (sum of tensor elements — measured, not inferred from the name) |
| File | `Qwen3.8-27B.i1-IQ4_KT-attn_qkv-IQ4_KS.gguf`, 14,763,620,928 B (13.749 GiB) |
| SHA256 | `A8588CE8…07236` — recomputed at generation time, matched; mtime unchanged since 2026-08-18 |
| Native/training context | **262,144** (GGUF metadata) — the run used 47,616 of it |
| Shape | 64 blocks · embd 5120 · ffn 17408 · attention heads Q/KV **24 / 4** |
| Tokenizer / chat template | `gpt2` / `qwen-chunter-sysmerge.jinja` via `--chat-template-file` |
| Reasoning | `--reasoning off`; `/props reasoning_format=none` |

> **Quantization — Backend corrected its own earlier answer.** The first snapshot described this as "IQ4_KT,
> attn_qkv at IQ4_KS", which was **read off the filename**. Backend then read the per-tensor types out of the
> GGUF header. Measured across 851 tensors:
>
> `F32 449 · IQ4_KT 256 · IQ4_KS 122 · IQ5_KS 16 · IQ6_K 4 · Q8_0 3 · IQ5_K 1`
>
> | Tensor group | Type |
> |---|---|
> | `ffn_down` / `ffn_gate` / `ffn_up` | IQ4_KT ×64 each |
> | `attn_output` | IQ4_KT ×16 |
> | `attn_q` | IQ4_KS ×64 (+F32 ×16 norms) |
> | `attn_k` | IQ4_KS ×16 (+F32 ×16 norms) |
> | `attn_v` | **IQ5_KS** ×16 |
> | `token_embd` | Q8_0 |
> | output head | IQ5_K |
>
> **The filename is a label, not evidence**, and it differs from the file in two ways: there is **no fused
> `attn_qkv` tensor** (Q, K and V are separate), and `attn_v` is IQ5_KS — *higher* precision than the name
> implies. `general.file_type = 145`, `quantization_version = 2`.

### 9.1d Runtime — complete effective argv, read live from `Win32_Process.CommandLine`

```
llama-server.exe -m <GGUF>
  -c 49152 --parallel 1 -ngl 999 -fa on -ctk q4_0 -ctv q4_0 -khad -vhad
  --jinja --chat-template-file <...>/qwen-chunter-sysmerge.jinja
  --reasoning off --temp 0.6 --top-p 0.95 --top-k 20 --host 0.0.0.0 --port 8092
```

Runtime-confirmed via `GET /props`: `n_ctx 49152` · `total_slots 1` · model_path matches ·
**`n_predict -1`, `max_tokens -1`** · temp 0.6 · top_p 0.95 · top_k 20 · min_p 0.05 · repeat_penalty 1.0 ·
repeat_last_n 64 · seed −1 · stream true · `reasoning_format none` · `chat_format Content-only` ·
`build_info null`. Exactly **1** `llama-server.exe` on the host, pid 24468, started 08:47:43 (before the
window) and still live at the end — **no restart, reload, profile switch or crash inside the window**.

The backend imposes **no output cap**. Any cap during the run was request-side and Client-owned.

### 9.2 Explicitly NOT verified / NOT available — Backend's own labels, preserved

| Field | Label | Backend's stated reason |
|---|---|---|
| CUDA toolkit version | NOT_VERIFIED | driver + compute capability confirmed; the toolkit the binary was built against is not exposed by the running process or `/props` |
| ik_llama build version/commit | NOT_VERIFIED | `/props` returns `build_info = null`, the executable carries no FileVersion/ProductVersion resource, and the binary emits no version string over HTTP. `8337e4cd386` per handover notes is **not independently verified**. The executable SHA256 `9CA87C99…E41F` is the hard, checkable identity. |
| Model publisher / source | NOT_VERIFIED | no `general.organization`, `general.repo_url` or `general.basename` in the file. Handover notes attribute it to "cHunter" — **hearsay, not file evidence**. |
| imatrix | NOT_VERIFIED | the `i1` infix conventionally denotes an imatrix quant, but **no imatrix key exists** in the metadata |
| TTFT | NOT_AVAILABLE | not measurable server-side; client-observed TTFT includes network transit and queueing. Server **prompt-eval duration** is the nearest honest proxy — it is *not* TTFT and is not presented as one. |
| Truncation flag | NOT_AVAILABLE | ik_llama emits no `truncated` field; ceiling states are DERIVED from prompt+gen vs `n_ctx−1`. None was invented. |
| mmap / mlock effective state | NOT_AVAILABLE | neither `--mlock` nor `--no-mmap` appears in argv (verified), so both sit at runtime defaults; the *effective* state is not reported by `/props` and is not asserted |
| Actual layer placement | NOT_VERIFIED | `-ngl 999` requests all 64 blocks on CUDA, but the placement banner predates the window and was not re-parsed, so realised placement is not asserted |
| GPU contention | NOT_AVAILABLE | would require the GPU time series, which was not recorded (§9.3) |
| POSTs producing no generation | count VERIFIED (3), **cause NOT_VERIFIED** | see §10.2 — all returned 200 with no runtime error, so the cause is not recoverable from the log and is not asserted |

### 9.3 DISCLOSED TELEMETRY GAP — preserved verbatim, do not back-fill

Two axes are **NOT_AVAILABLE** for the window. Backend did not interpolate them, and neither does this report.

1. **`gpu_utilization_window` / `vram_window` = NOT_AVAILABLE.** No sampler recorded GPU metrics during the
   run; `platform-samples.csv` last wrote 2026-08-29 23:28:57.
2. **`slot_occupancy_window` = NOT_AVAILABLE.** `ctx_watch.py` polled port **8082** while the backend served
   on **8092**, so all **1,714** in-window samples are connection-refused error rows. Cadence and freshness
   looked healthy and `guard.py` therefore reported CLEAR — **guard checks staleness, not validity.**

> **Connection-refused rows are NOT slot-idle measurements.** Reporting "0 % busy" from them would have been a
> fabricated measurement. **`guard` CLEAR during that period is not valid evidence of an idle backend** — it
> was an instrument artefact. Backend confirms the guard flipped CLEAR → CLIENT ACTIVE the moment it was fed
> valid data.

Instrumentation was fixed at **2026-08-30 16:10:59** (ctx_watch now resolves the *active* backend port instead
of hardcoding 8082). **Telemetry after that timestamp is valid; before it is not.** Disclosed, not back-filled.

A single point-in-time GPU reading was taken at collection — VRAM 15,773 MiB used, util 1 %, 48.9 W, 51 °C,
backend working set 22.74 GB — labelled **`VERIFIED_POINT_IN_TIME_ONLY`**. It must **not** be read as a window
statistic and is not used as one anywhere in this report.

Backend also confirms: historical 32K/48K/64K figures are held in a separate
`comparison_historical_NOT_this_run` section and are never merged into this run's numbers; the 64K prefill
collapse is recorded as MEASURED behaviour with **no established mechanism** (the earlier VRAM-spill
explanation was retracted). Backend state was unchanged by the collection: no profile switch, no restart, no
parameter change.

---

## 10. PERFORMANCE

| Metric | Value | Classification |
|---|---|---|
| Total wall-clock | 8,783 s (2 h 26 m 22 s) | MEASURED (client) |
| Worker attempts / continuations | 37 / 35 | MEASURED (client) |
| Requests through route | 743, 0 × 5xx | MEASURED (client) |
| Prefill / decode / latency / token totals | see 10.1 — **AWAITING_RESCOPE** | Backend |
| TTFT | NOT_AVAILABLE (not measurable server-side) | Backend |
| Backend busy time / slot occupancy | **NOT_AVAILABLE** — instrument was polling the wrong port (§9.3) | Backend |
| GPU utilisation / VRAM over window | **NOT_AVAILABLE** — no sampler running (§9.3) | Backend |

### 10.1 Inference statistics — FINAL, closed window 13:45:55 -> 16:12:17

| Counter | Value |
|---|---:|
| Total POST requests | **766** (`/v1/responses` 746 · `/v1/chat/completions` 20) |
| GET requests (probes) | 33 |
| Completed generations | **763** |
| Failed requests · HTTP 5xx · HTTP 4xx | **0 · 0 · 0** |
| Status histogram, all methods | **`200 x 799`** — the only status code in the entire log |
| Context-overflow errors · ceiling cuts | **0 · 0** |
| Derived ceiling states | `CLEAN x 763` |
| Crashes / restarts | **0** |
| Cumulative prompt / generated / total tokens | 1,240,516 · 175,096 · **1,415,612** |
| Largest prompt · largest generation | 41,800 tok · 9,161 tok |

| metric | n | min | median | mean | p95 | max |
|---|---:|---:|---:|---:|---:|---:|
| prompt tokens | 763 | 5 | 279 | 1,625.8 | 4,028 | 41,800 |
| generated tokens | 763 | 13 | 120 | 229.5 | 605 | 9,161 |
| prefill tok/s | 763 | 6.23 | **538.47** | 744.49 | 1,929.75 | 2,177.34 |
| decode tok/s | 763 | 39.62 | **44.71** | 45.17 | 50.92 | 55.71 |
| request wall time (ms) | 763 | 569.27 | 3,948.44 | 7,367.39 | 20,589.61 | 213,401.70 |
| prompt-eval duration (ms) | 763 | 89.08 | 920.63 | 2,145.58 | 5,486.40 | 67,211.05 |

Largest prompt (41,800) sits well under the 49,152 capacity — **no request approached the ceiling**, which is
consistent with the Client's deliberately conservative 47,616 window and 1,536-token headroom.

**Boundary handling.** Both bounds are inclusive at whole-second granularity. The log stamp truncates to the
second, so the end bound covers `16:12:17.000-.999`; the run's final generation completed at **16:12:17.502**
and **is** included. A stricter comparison would have silently dropped the last request of the run.

### 10.2 Counter reconciliation — resolved, and still not forced to agree

Three counters, three different things being counted. All are reported; none was adjusted to match another.

| Counter | Value | What it measures |
|---|---:|---|
| **Client route requests** | 743 | what the Client's own chain forwarded |
| **Backend POSTs from the client Mac** | 746 | what the server accepted and logged from that origin |
| **Backend generations** | 763 | requests that reached a generation phase (all origins) |

Closed-window origin split: **client Mac — 746 POSTs + 2 GETs** (benchmark inference traffic);
**backend-local `127.0.0.1` — 20 POSTs + 31 GETs** (router, contract tool and watcher probes, which never
traverse the Client route and are excluded from the comparison). **No other origin appears at all.**

Backend also found **3 POSTs that produced no generation** (count VERIFIED, **cause NOT_VERIFIED**): pairing
each POST to a preceding unconsumed timing block leaves 4 unmatched POSTs — 13:45:58, 14:41:32, 15:29:20,
15:29:46, all from the client Mac — and 1 unconsumed timing block at the window edge, net 3. All returned 200
with no runtime error, so the cause is not recoverable from the log.

> **Observation, explicitly not a conclusion** (Backend's framing, preserved): the +3 surplus over the
> Client's count and the 3 POSTs that produced no generation are the same magnitude, and every unmatched POST
> originates from the client Mac. That is *consistent with* the Client not counting requests that never
> generated — but no field in either log establishes the correspondence, so it is **not asserted**. The
> tempting move here is to declare the discrepancy "explained"; it is merely narrowed.

No averages are computed by the Client. Every Backend statistic carries its sample count (`n = 763`
throughout), so nothing is averaged from insufficient data.

### 10.3 Service events inside the window — Backend, VERIFIED

Backend restart · model reload · profile switch · crash · route failure · firewall event · unexpected second
inference worker · other infrastructure fault: **NONE** across the board. Exactly one `llama-server.exe` ran
throughout. All 799 logged requests returned 2xx.

The single fault in the window was a **telemetry instrumentation failure, not an inference failure** (§9.3).
Inference itself was unaffected: 0 failures, 0 non-2xx, 0 crashes.


## 11. EXECUTIVE SUMMARY

| Group | Field | Value |
|---|---|---|
| **HARDWARE** | CPU / RAM | AMD Ryzen 7 7700 (8C/16T, 3801 MHz) · 63.16 GiB DDR5 @ 5600 MT/s |
| | GPU / VRAM | **NVIDIA GeForce RTX 5080 · 16,303 MiB** · driver 610.88 · CC 12.0 · PCIe 4.0 ×16 |
| | OS | Windows 11 Pro 25H2, build 26200.9278 |
| **MODEL** | family / params | Qwen3.8 (`qwen35`) · **26,895,998,464 params** (measured from tensors) |
| | GGUF / size | `Qwen3.8-27B.i1-IQ4_KT-attn_qkv-IQ4_KS.gguf` · 13.749 GiB · sha `A8588CE8…` |
| | quantization | **mixed, measured per-tensor** — IQ4_KT 256 · IQ4_KS 122 · IQ5_KS 16 · Q8_0 embd · IQ5_K head (the filename is a label, not evidence — see §9.1c) |
| | native context | **262,144** (only 47,616 used) |
| **BACKEND** | context capacity / slots | 49,152 · 1 slot (runtime-confirmed) |
| | KV / flags | q4_0 / q4_0 + Hadamard (`-khad -vhad`), flash-attn on, `-ngl 999` |
| | profile / output cap | `qwen-chunter-48k-1slot` · **no backend output cap** (`n_predict = -1`) |
| | throughput | prefill **538 tok/s** median · decode **44.7 tok/s** median (n=763) |
| | reliability | 766 POSTs · 763 generations · **0 failures, 0 non-2xx, 0 crashes** |
| **CLIENT** | Codex version | codex-cli 0.149.1 |
| | effective context | **47,616** |
| | reasoning effort | **xhigh** |
| | Skills | 8 installed · 6 loaded · 6 applied · 2 unused |
| | sandbox | workspace-write + network, approval never |
| **RUN** | start / end | 13:45:55 → 16:12:17 |
| | duration | **2 h 26 m 22 s** |
| | attempts | 37 |
| | continuations | 35 (30 soft + 5 compact) |
| | compactions | 11 internal · 5 fresh-thread · **0 exhaustions** |
| **PRODUCT** | files / LOC | `index.html` 66 L + `game.js` 725 L (+ vendored Three.js) |
| | playable | `http://127.0.0.1:8802/` — HTTP 200 |
| | Local AI final status | **COMPLETE** (self-declared, predicate `REPORT.md` passed) |
| **HUMAN FEEDBACK** | initial playability | user: already playable before completion |
| | feedback count | **1** |
| | mouse-X issue | reported reversed → fixed by Local AI (one line) → self-verified by projection |
| | final status | user assessment: satisfactory / preserved as reference benchmark |

---

## 12. WHY THIS RUN MATTERS

Experimental facts only — no causal claims the experiment did not establish:

- The **user considers this run satisfactory** and asked for it to be preserved as a reference benchmark.
- **Implementation, debugging, testing and verification were owned by local Qwen/Codex.** The worker chose its
  own verification method, diagnosed the mouse-X reversal itself, and produced its own report.
- **Claude was intentionally restricted** to transmitting the instruction, launching/supervising the worker,
  continuing it only after genuine turn termination, and recording timing and results.
- **Human feedback was supplied during the run** and acted on inside the same logical session.
- This combination makes the run usable as a **future comparison baseline** for the same stack.

What this run does **not** establish: it is a single run with no control arm, so it cannot attribute the
outcome to any particular factor — not the skills, not `xhigh`, not the 47,616 context, not the orchestration
style. It is a baseline to compare against, not evidence of causation.

---

## 13. RUN CLOSURE & PRODUCT FREEZE

### 13.1 Human acceptance

```
HUMAN_PLAYTEST_ACCEPTED: YES        2026-08-30 16:25:14 +0800
```

The operator personally playtested the build and considers the run complete. Recorded in
`~/qa-runs/zombie-fps-timing/acceptance.json`.

**Scope of this claim, stated precisely:** this is acceptance of *this benchmark run*. It is **not** a claim
of "bug-free" or "production-ready". **No independent Claude gameplay score exists or has been added** — the
operator's acceptance *is* the human evaluation. The acceptance timestamp is recorded separately and is
**excluded** from the 13:45:55 → 16:12:17 implementation window.

The one previously-open human item — **real pointer-lock / mouse-look feel**, which the Local AI itself flagged
as un-automatable — is now covered by that human playtest.

### 13.2 Orchestration closure — verified, not assumed

| Check | Result |
|---|---|
| Codex workers running | **0** |
| Supervisors running | **0** |
| Resume / wait / monitor helpers | **0** |
| **Orphan Local-AI processes** | **none** (checked by process-group / env token, not `pgrep -f`, which has previously missed Codex children) |
| Dev HTTP server | **still running** — `python3 -m http.server 8802`, pid 90087, HTTP 200 |

> The dev server is a **static file server**, explicitly **not** a Local AI worker and not counted as one. It
> is left running so the frozen build stays playable at `http://127.0.0.1:8802/`.

Nothing was modified during closure: game source, Skills, model, Backend profile, Client config, Supervisor
code and prompt files are all untouched. No unrelated local AI session was killed.

### 13.3 Product freeze

```
commit d5312f6   tag zombie-fps-benchmark-v1   working tree clean
```

The freeze commit **records** the accepted state; it does not alter product contents. Authorship is stated in
the commit message: the Local Qwen worker authored the implementation, debugging, browser testing,
verification and `REPORT.md`; Claude orchestrated only. Retrieve any input or product file exactly with
`git -C ~/side-projects/games/web/zombie-fps-local-ai show zombie-fps-benchmark-v1:<file>`.

### 13.4 Path to `VERIFIED` — closed

| # | Item | State |
|---|---|---|
| 1 | Backend re-scopes inference statistics to 13:45:55 → 16:12:17 | ✅ delivered 17:0x — **confirmed** the counts (excluded interval held 0 POSTs / 0 generations) |
| 2 | Backend supplies OS / CPU / RAM / GPU / VRAM / GGUF path+size / argv / ngl | ✅ delivered, all re-measured live (§9.1b–d) |
| 3 | Origin-count reconciliation stated exactly | ✅ §10.2 — resolved to 746 vs 743 vs 763, with the residual narrowed but **not** asserted |
| 4 | Header flipped to `ZOMBIE_FPS_REFERENCE_BENCHMARK: VERIFIED` | ✅ |

Per the operator's rule — **unknown instrumentation is acceptable, fabricated instrumentation is not** — the
GPU and slot-occupancy gaps in §9.3 are explicitly documented and do not block `VERIFIED`. Nothing was
back-filled, interpolated, or averaged into existence to close this benchmark.

**Unknowns that remain unknown, on purpose:** CUDA toolkit version · ik_llama build commit · model publisher ·
imatrix presence · TTFT · truncation flag · mmap/mlock effective state · realised layer placement · GPU
utilisation, VRAM and slot occupancy over the window · the cause (not the count) of the 3 non-generating POSTs.

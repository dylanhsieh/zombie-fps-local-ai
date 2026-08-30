# What the Local AI was actually told

Everything the model received, verbatim. Nothing here is reconstructed after the fact — these are the
files that sat in its workspace for the whole run, preserved byte-for-byte.

| File | SHA256 | Author |
|---|---|---|
| [`TASK_PROMPT.txt`](TASK_PROMPT.txt) | `fbf179357b69e4b0…` | orchestrator, transcribing the operator's requirements |
| [`GAME_GOAL.md`](GAME_GOAL.md) | `32a62bfda3a2d686…` | orchestrator, transcribing the operator's requirements |
| [`AGENTS.md`](AGENTS.md) | `de73b37a26f0a4d0…` | orchestrator — auto-injected by Codex at the head of every thread |
| [`USER_FEEDBACK_1.txt`](USER_FEEDBACK_1.txt) | `ef5bb0248de31bf2…` | **the human operator, verbatim** |

## Who said what

The experiment's whole point was to keep the orchestrating model out of the engineering, so the chain of
authorship matters more than usual:

- **The human operator** wrote the game requirements and, later, the one piece of playtest feedback.
- **The orchestrator** (Claude) transcribed those requirements into the three worker-facing files, launched
  and supervised the worker, sent neutral continuations, and recorded timings. It did **not** write, debug,
  test or verify the game.
- **The local model** (Qwen, via Codex CLI) owns every line of `game.js` and `index.html`, all testing and
  verification, and [`docs/LOCAL_AI_REPORT.md`](../docs/LOCAL_AI_REPORT.md).

So `TASK_PROMPT.txt` / `GAME_GOAL.md` / `AGENTS.md` are *transcriptions* of the operator's intent, not the
operator's literal words. `USER_FEEDBACK_1.txt` is the only file containing verbatim human wording.
[`docs/INPUT_PROVENANCE.md`](../docs/INPUT_PROVENANCE.md) labels every requirement individually.

## The one instruction that was deliberately withheld

The prompt insists the model prove on-screen direction is correct — because a previous build had been
mathematically self-consistent and still shipped reversed left/right. But it pointedly refuses to say *how*:

> You must prove the visible directions are correct, and it is your responsibility to choose how.

That restraint was not there from the start. An earlier launch was handed a prescribed technique
(*"PROVE IT LIKE THIS (required): project tile world positions with `camera.project(...)`"*). The operator
caught it, that run was discarded, the project was reset, and the prompt was rewritten to hand the choice
back to the model. The full record — including proof the discarded instruction never reached the run that
counted — is in [`docs/INPUT_PROVENANCE.md` §F](../docs/INPUT_PROVENANCE.md).

Left to itself, the model read the vendored Three.js source and built its own `projectToScreen()` helper.

## Continuation prompt

When a turn ended before the task was done, the supervisor sent this — 30 times, identical, carrying no
technical content:

```
Continue the current task from where you stopped. Execute the next required step now, and keep working
until the task's completion criteria are satisfied, or you reach a genuine blocker you cannot resolve
yourself (in which case state it explicitly).
```

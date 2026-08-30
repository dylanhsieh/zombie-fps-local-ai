# Raw supervisor logs

Every attempt the local model made, unedited except that absolute home paths were rewritten to `~`.

| Directory | Attempts | Window |
|---|---|---|
| [`segment-1/`](segment-1) | 23 | 13:45:55 → 16:00:28 — initial build |
| [`segment-2-feedback/`](segment-2-feedback) | 14 | 16:01:16 → 16:12:17 — after the human mouse-X report |

`supervisor.jsonl` carries one JSON event per attempt boundary; `context_ledger.jsonl` tracks token pressure;
`attempt-NN.out` is the model's raw output for that turn. `*-checkpoint.out` files are the checkpoint the
supervisor requested before starting a fresh thread.

## Reading these honestly

**35 of 37 attempts are marked `STALLED`, and that is not a failure mode.** Classification happens only when
the process actually exits — never on a wall-clock guess. `STALLED` means the model ended its turn while
still having forward intent, so the supervisor continued it. A long, silent, productive turn was never
treated as a stall.

`attempt-08` is the one genuine `RUNAWAY_CAPPED` (hit the per-attempt time limit).

**Segment 1 ends with `rc=143`, which is a SIGTERM, not a crash.** The supervisor loop was deliberately
stopped so the human's feedback could be delivered — otherwise it would have kept injecting its own neutral
continuation and the human message would never have landed. The worker's live turn was left to finish
naturally; feedback went in at 16:01:16. The run's real terminal is `rc=0` at 16:12:17.

[`worker-checkpoint.md`](worker-checkpoint.md) is the model's own running notes, which it maintained so its
work would survive a context reset. It crossed six context boundaries during the run without ever losing the task.

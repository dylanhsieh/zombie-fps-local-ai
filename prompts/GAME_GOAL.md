# GAME GOAL — Browser 3D zombie FPS prototype

Browser-based first-person shooter using Three.js / WebGL / HTML-CSS-JS. Block-built visuals, no external
3D assets. Built clean-room in this folder.

---

## ⚠ RULE ZERO — PLAYER-VISIBLE DIRECTION IS THE AUTHORITY

A previous build was **mathematically self-consistent and still wrong**: every internal number agreed with
every other internal number, yet on screen front/back were reversed and left/right were reversed.

**Internal consistency is NOT evidence of correctness.** If the coordinate arithmetic is self-consistent but
the tile labelled `(0,1)` is not literally *in front of* the player on screen, the build is WRONG.

You must prove direction from **what appears on screen**, not from vector signs agreeing with each other.

### Authoritative spawn orientation
Player spawns at logical `(0,0)` **looking toward logical +Y**.

```
                    W / +Y
                      ↑
                      |
             A / -X  ← ● →  D / +X
                      |
                      ↓
                    S / -Y
```
Before the player turns the camera:

| Key | Logical result | Must appear on screen as |
|---|---|---|
| W | `(0, 1)` | tile moves toward / is **in front** |
| S | `(0,-1)` | **behind** |
| A | `(-1,0)` | player's **LEFT** |
| D | `(1, 0)` | player's **RIGHT** |
| W+A | `(-1, 1)` | forward-left |
| W+D | `(1, 1)` | forward-right |
| S+A | `(-1,-1)` | back-left |
| S+D | `(1,-1)` | back-right |

**The tile marked `(0,1)` must literally be IN FRONT of the player at spawn. `(-1,0)` on the LEFT.
`(1,0)` on the RIGHT.** Pick whatever Three.js world-axis mapping is convenient — the *visible* mapping above
is what counts.

Do NOT accept "all internal sources agree with each other" as proof of orientation. That test passed last time
and the result was still reversed on screen. It is your responsibility to decide how to prove the visible
directions are correct.

---

## Camera-relative movement (this is a real FPS, unlike the previous calibration test)

After the player turns with the mouse:
- **W** = the direction the camera faces, projected onto the ground plane
- **S** = opposite
- **A** = strafe to the player's **screen-left**
- **D** = strafe to the player's **screen-right**

Looking up/down must **not** move the player vertically — use yaw / horizontal forward projection.

Required checks: facing initial +Y → W goes visually forward. Turn ~90° right → W now moves toward the new
facing. Turn ~90° left → same. **A always strafes screen-left, D always screen-right.**
**Reversed A/D or W/S is a BLOCKING defect.**

---

## Room
One large indoor room. Simple tiled/block-built floor. Player starts near one end; both zombies on the far
side, visible shortly after spawn. A coordinate/debug floor may be retained during development — if used, it
must match the visible orientation above.

## Player
First-person. Mouse look + pointer lock where appropriate. Camera-relative WASD. Visible **centre crosshair**.
Visible block-built fake first-person arms and a machine gun. **Infinite ammo.** Rapid/automatic fire while the
button is held is fine.

## ⚠ CROSSHAIR — BLOCKING REQUIREMENT
The crosshair must sit at the **exact centre of the rendered viewport**, and the player must be able to trust:

> **what the crosshair covers == what the shot hits**

The authoritative aim ray must originate from the camera / centre of view, or otherwise be mathematically
guaranteed to correspond to the centre crosshair. A decorative gun barrel may be visually offset, but
**hit detection must follow the crosshair, not the barrel.**

If the crosshair visually covers a zombie with clear line of sight, the shot **must** register on it.
Do not report complete if this is wrong.

## Zombies — exactly two
- **Zombie A** — stationary, never approaches.
- **Zombie B** — walks slowly toward the player (slow enough to aim at comfortably).

Both: block-built humanoid silhouette, clearly distinct from the environment, **health bar floating above the
head**, exactly **5 HP = 5 successful hits**. Each valid hit removes exactly 1. Dies on the **5th** hit — not
the 4th, not the 6th. Readable hit feedback; obvious death feedback; a dead zombie is no longer a live target.

## Visual style
Block/cuboid construction is fine, but not one crude cube per thing — multiple blocks per body, decent
silhouettes, lighting and material variation. Somewhat more refined than bare Minecraft-level geometry.

## Test hooks (keep available even when debug visuals are hidden)
Expose deterministic hooks, e.g. `window.__AGENT_STATE__` returning: player logical + world position, camera
yaw, camera forward vector, crosshair target, last shot hit/miss + target id, both zombies' health and
positions, `ready`. Plus a deterministic `fire()` and a way to set yaw/position for testing.

## Verification standard
`BUILD PASS` ≠ `GAMEPLAY VERIFIED`. `PAGE LOADS` ≠ `FPS VERIFIED`. `RAYCAST EXISTS` ≠ `CROSSHAIR ALIGNMENT
VERIFIED`. Distinguish honestly between **mechanically verified**, **visually inspected**, and **human-only**
(e.g. real pointer-lock feel). Prove things with hooks/automation where practical.

## Deliverable
`REPORT.md` with: what was implemented, movement evidence (initial + after rotation, including the
screen-projection proof), crosshair-alignment evidence, per-zombie 5-hit evidence, health-bar verification,
runtime verification, controls, what still needs human playtest, and known defects.

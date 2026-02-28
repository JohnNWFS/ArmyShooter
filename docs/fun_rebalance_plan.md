# ArmyShooter "Fun" Rebalance Plan

## Why the current loop feels flat

Based on the current spawn/block logic, the game has difficulty spikes but very little *decision pressure*.

1. **Enemy lane pressure is mostly random.**
   - Enemy lanes are chosen randomly from `[0, 2]`, with no memory of recent spawns or player state.
   - This causes accidental empty windows and accidental impossible stacks rather than designed pacing.
2. **Bosses are frequently solo checks.**
   - Boss patterns return `enemy_count: 1`, and regular block spawning is disabled while a boss exists.
   - Result: the expected "boss + supporting horde" fantasy is missing.
3. **Blocks/powerups are detached from combat context.**
   - Number blocks spawn in center lane with fixed probabilities (80% negative / 20% +1), not tied to current threat.
   - Powerups are pure RNG (15%) without relation to danger, army size, or wave type.
4. **Wave identity exists in names but not in tactical variation.**
   - Patterns switch swarm/non-swarm and sizes, but there is no explicit tactical role system (harass, pin, punish greedy center play, protect boss, etc.).
5. **Strategy signaling is weak.**
   - Players are not forced into meaningful tradeoffs like "clear flank now vs farm center growth" through intentional synchronized spawns.

## Design goals

1. Create **predictable-but-varied pressure arcs** each wave.
2. Make **mid-wave decisions matter** (shoot horde vs convert block vs survive escort).
3. Ensure **boss encounters are combined-arms fights**, not isolated DPS checks.
4. Keep randomness for replayability, but inside **director constraints**.

## Proposed system changes

## 1) Add an Encounter Director (lightweight AI scheduler)

Create a wave director that runs every step and spends a per-wave **threat budget**.

### Data model
- Add a struct (or script-returned struct) per wave:
  - `threat_budget_total`
  - `threat_budget_per_second`
  - `lane_pressure_target[3]`
  - `allowed_units` (swarm, regular, mini, boss, escort)
  - `block_policy` and `powerup_policy`

### Spawn rules
- Each spawn request has a `threat_cost` and `role`.
- Director chooses lane by score:
  - lane danger near game-over line,
  - recent spawn cooldown per lane,
  - whether center lane already has a high-value block,
  - whether boss needs escort.
- Replace purely random lane pick with weighted selection and cooldown memory.

**Outcome:** consistent pressure ramps without removing randomness.

## 2) Replace single boss waves with boss phases + escorts

Boss wave template should have timed phases:

- **Phase A (entry):** boss + light swarm escort from opposite flank.
- **Phase B (pressure):** periodic mini-swarm pulses while boss alive.
- **Phase C (burn window):** reduced escorts + guaranteed positive block window.

Implementation idea:
- Add `boss_phase`, `boss_phase_timer`, `boss_support_timer` to `oLevelManager`.
- Keep block spawning active during boss, but under boss-specific policy (fewer, more meaningful).

**Outcome:** player has rotating priorities, not just holding fire on one target.

## 3) Convert block spawning into a tactical economy

Instead of fixed independent RNG:

- Spawn **block sets** tied to encounter state every N seconds:
  - Example set: center `+2` plus side `-3` corruption threat.
- Use **rubber-band logic**:
  - low army size => higher chance of recoverable positive blocks,
  - high army size => more corruption/negative denial blocks.
- Make "farm vs survive" explicit:
  - when side pressure is high, spawn an attractive center conversion target.

**Outcome:** player must choose between immediate safety and longer-term growth.

## 4) Introduce role-based enemy behaviors

Keep existing enemy types but assign one tactical role at spawn:

- `RUSH` (fast swarm)
- `PIN` (slow high-HP frontliner)
- `FLANK` (lane that currently has least defenders)
- `ESCORT` (stays near boss lane, short leash)

Minimal implementation:
- Add `role` var in `oEnemy`.
- In `oEnemy.Step`, vary speed / lateral drift / target lane drift by role.

**Outcome:** waves feel authored and strategically legible.

## 5) Add fairness/telegraphing constraints

Director constraints:
- Never schedule impossible overlaps (e.g., boss + max escort + double corruption at once).
- Enforce minimum reaction windows after high-threat bursts.
- Telegraph high-threat events (brief warning marker in lane) before spawn.

**Outcome:** harder but fairer difficulty that feels intentional.

## 6) Instrumentation for tuning (already partly present)

Existing spawn/death CSV logging is a great base. Extend logs with:
- `threat_budget_remaining`
- `director_decision_reason`
- `player_army_band` (low/mid/high)
- `time_since_last_positive_block`

Then evaluate using quick heuristics:
- average time-to-first-loss,
- army size variance per wave,
- boss wave failure causes.

## Concrete implementation plan (phased)

## Phase 1 - Foundation (low risk)
1. Add new director state fields to `oLevelManager` create/init.
2. Add `scripts/get_spawn_intent.gml` that returns `{unit_type, lane, reason, threat_cost}`.
3. Replace random lane select in `oGame.Step` with `get_spawn_intent()`.
4. Add per-lane cooldown array and recent-spawn memory.

## Phase 2 - Boss support and tactical blocks
1. Add boss phase timers and escort pulse spawning.
2. Remove blanket "no blocks during boss" rule; switch to boss block policy.
3. Implement block-set spawns driven by army-size band and pressure score.

## Phase 3 - Role behaviors and telegraphs
1. Add `role` assignment on enemy spawn.
2. Expand `oEnemy.Step` movement by role.
3. Add lane telegraph visual object for high-threat pulses.

## Phase 4 - Tuning pass
1. Add extra logging fields.
2. Run 20+ seeded simulations (or manual sessions) and collect failure distribution.
3. Tune budgets/cooldowns until target challenge curve is reached.

## Suggested first PR slice

Keep first slice small and measurable:
- Add director lane cooldown + weighted lane selection.
- Add boss escort pulse every X seconds during boss waves.
- Keep all art assets/sprites unchanged.

This should immediately address:
- empty/random lane pressure,
- solo boss feeling,
- lack of strategic choice density.

# S06-1 live clock providers and bounded frame kernel

## Scope

This slice adds a bounded C kernel for the source-backed clock update that precedes the scene action scan. It borrows the existing `WorldInitState`, its `WorldInitClock`, the ten timer records, and `ActionCoreWorld.event_flags`; it adds no duplicate mutable clock store. `world_init` remains the lifecycle owner. The kernel does not implement the full frame loop, native presentation, audio playback, the post-clock controller handlers, or complete gameplay.

The original is pinned to `GAME.EXE` SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. The recovery report is `work/analysis/slices/S06-1-provider-recovery-20261013.md` with its companion JSON. This implementation's exact file and byte-window hashes are in `work/analysis/slices/S06-1-clock-kernel-oracle-20261013.json`.

The earlier provider-recovery report was written before implementation and records timer completion as untested. That historical limitation is superseded for the listed bounded scenarios by this implementation's nine-case original oracle; all remaining omissions are listed below.

## Caller contract

The frame owner samples `GetTickCount` once at original entry `0x43a7ca`, applies the original outer state/event gates, then chooses the normal or off-mode entry point. Early-return event branches must bypass this kernel and preserve their own saved-pause-mark writes. The normal call belongs after the original mode-`0x0e` gate and before the post-clock controller call at `0x43b13d`, then before the sequential action scan. On success, `world_clock_update_normal` returns continuation VA `0x43b13d`; the owner still performs the Boot/session-owned controller callbacks before scanning actions. The off-mode call returns its exact caller-owned cleanup boundary at `0x43ab41`; it must be followed by the original pump/cleanup/mode-reset sequence and must not dispatch actions.

Call `world_clock_condition_read` against the same mutable `WorldInitState` at each leaf evaluation. Opcode 4 reads signed `clock.run_elapsed_ticks` (`0x585d37`), opcode 5 reads signed `clock.scene_elapsed_ticks` (`0x585d41`), and opcode 6 reads the current `clock.total_minutes` (`0x585d4b`). This is live per-condition state: an earlier action may mutate the civil clock in the same action scan. Opcode 3 remains explicitly unsupported: the indexed read from `0x581a71` has no proven logical extent or producer, and no opcode-3 rows were observed in the pinned corpus.

`WorldClockSession` contains only the globals not represented by `WorldInitState`: the outside-window flag at `0x5bb20a`, configured signed window bounds at `0x5b0284/0x5b0286`, and caption enable at `0x5bb202`. The root adapter must bind/refresh these values from the existing engine state rather than treat them as new authoritative copies.

## Implemented original-order behavior

The normal function uses unsigned `baseline < sample`; otherwise delta is zero and baseline stays unchanged. It then updates run elapsed/display, each active timer record in slot order, scene elapsed/display, and at most one civil-clock minute when unsigned `sample >= deadline`. A due minute sets `deadline = sample + sign_extend(interval)` and increments minute once; it does not catch up missed periods. Minute/hour/day normalization and totals use the original signed 16-bit stores. It tests the first-day event only on the non-rollover branch, writes its event flag before recomputing the outside-window flag, and preserves source order on errors.

Active timer statuses are 1, 5, and 6. Each adds the frame delta modulo 2^32 and refreshes display fields. Status 5/6 completion requires signed positive target, completion zero, and signed elapsed at least target. Completion commits its marker, applies valid non-sentinel short-ID/value pairs in order to the borrowed event-flag array, clears all ten IDs to `-1`, then handles sound and caption boundaries. `NO SOUND` skips both sound calls. Otherwise the kernel emits `LOAD_SOUND_DESCRIPTOR` with the exact 49 bytes at record `+0x28` and the descriptor's unsigned channel at descriptor `+0x21`, then emits `PLAY_SOUND_CHANNEL` with that channel. The other identified descriptor fields remain present without loss in the byte payload: `+0x23` (forwarded by the original to the channel-control helper), `+0x25` (mode test), `+0x29` (raw control), and `+0x2d/+0x2f` (signed scalar shorts). The record channel at `+0x49` is descriptor byte `+0x21`. The original ignores both sound calls' return values, so the kernel also continues on the typed `RETURNED_FAILURE_IGNORED` result. Caption lookup is conditional on `0x5bb202`; a hit or record fallback is passed to the presentation sink with the original `<n><e>` suffix. Status 5 then receives the exact zero/`NO SOUND`/ten-sentinel reset byte pattern from `0x433bd2`; status 6 changes its status back to 1.

The off-mode path always stores its sample to `0x585d61`. Only when the restore guard is zero and unsigned saved mark `0x585d5d < sample` does it subtract the pause delta from run/scene elapsed and active timer elapsed fields, clamping each result to zero when the wrapped DWORD is signed-negative. It does not update display words or run completion logic.

Mutations occur directly in borrowed state. There is no rollback on a bounds or unavailable-host result; `WorldClockResult` identifies the trigger and committed prefix. Bounds checks on event IDs and strings are safe-port guards where the original can access arbitrary memory or overrun its local 104-byte caption buffer. The kernel returns a typed result at those boundaries rather than pretending the original operation was atomic.

## Files and verification

- `src/world_clock.[ch]`: kernel, typed sinks/results, and live condition reads.
- `scripts/build_world_clock.sh`: reproducible local C11 build.
- `tests/test_world_clock.py`: 13 behavioral tests for state mutation, ordering, conditions, host behavior, and guarded failures.
- `tests/world_clock_original_oracle.py`: isolated Unicorn 2.1.4 original execution with named deterministic hooks and exact-SHA guard.

Build and test:

```sh
outputs/blackmoor-decomp/scripts/build_world_clock.sh
python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_world_clock.py' -v
work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/world_clock_original_oracle.py
```

The current oracle passes nine fixtures and 64 component assertions. It executes original `0x43a7ca` clock/timer code through the normal post-clock boundary at `0x43b13d`, and through off-mode arithmetic plus the original cleanup path to `0x43ab78`. It covers status 5 and 6 due paths, status-5 non-due behavior, sound/`NO SOUND`, enabled and disabled captions, resolver and fallback captions, dependency-flag pairs and `-1` sentinels, status-5 reset, a due civil-clock update, pause subtraction and restore guard. The generated, explicitly unverified pseudocode for `0x4fb77a` reads the 49-byte descriptor, including channel `+0x21`, forwarded field `+0x23`, mode `+0x25`, control `+0x29`, and scalars `+0x2d/+0x2f`; `0x4fb2e3` takes the channel word and calls `0x4f6059`. These pseudocode files are evidence references, not reconstructed source claims. The oracle pins the `0x4fb2e3..0x4fb397` machine-code window. A dedicated missing-host run stops at descriptor-handler entry `0x4fb77a`; native execution with the host sink absent returns at the same committed timer/event-flag prefix.

The oracle hooks only deterministic `GetTickCount`, named frame/input-polling helpers, the sound descriptor/channel host boundaries, caption lookup/presentation, and documented continuation boundaries. At the descriptor boundary it captures and compares all 49 original bytes plus the descriptor channel; at the subsequent play boundary it compares the separately passed uint16 channel. The status-6 fixture uses distinct values for channel, `+0x23`, mode, control, and both scalar shorts, so the byte-for-byte payload comparison detects a lossy sound-event mapping. It does not stub the timer handler, dependency writes, caption assembly, clock arithmetic, or reset helper. Input hashes pin the executable, original code/data windows, current source, test runner, and built library.

## Unverified branches and integration limits

- Opcode 3's `0x581a71` table remains unsupported until a logical extent and live producer are proven.
- Status-5/6 caption source text longer than 97 bytes is rejected by a typed bounds result. The original copies into `local_c4[104]` and can overrun; this port does not reproduce stack corruption.
- Original event IDs that are negative other than sentinel `-1`, or outside the borrowed event-flag span, return a bounds result. The original has no equivalent bounds check.
- The sound descriptor loader and channel play are typed host boundaries. The oracle verifies their call inputs, not the internals of `0x4fb77a`, `0x4fc62d`, `0x4fb2e3`, or `0x4f6059`; native sound-state/resource semantics and audible playback are not reconstructed here.
- The oracle does not run `0x4d3c31/0x4d3d48` post-clock controller work, the full outer event loop, or the actual action scan. `0x43b13d` is the explicit normal continuation for Boot/session integration.
- New-game and scene-clear reset/rebase paths remain owned by the existing `world_init` implementation; this kernel does not add a competing lifecycle implementation.
- No native game/playability, full-function decompilation, or whole-file x86 match claim follows from this bounded slice.

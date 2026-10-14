# RT-3: run S5900 past ACT row 7 (action 0x62, then 0x28/0x51 as far as evidence allows)

Branch: `claude/rt-3-s5900-bindings`, from root's current `claude/hungry-matsumoto-8ab8eb` commit. Owner: a `slice-implementer`. Not for you: the pointer transform (RT-2, Codex, in flight) and the opaque action decoders (A-37/A-97/A-A1, another Codex thread).

## Where the live game stops

`blackmoor_app --inspect-live-session --live-click-row 34` plays S0 (audio now works), clicks the S0 hotspot at row 34, replaces the scene with S5900 and stops there: `scene_session_blocked stage=3 provider=action-family-62 action=7 type=0x62 detail=1 effects_before_block=7`. Rows 0-6 (0x64, 3x 0x82, 3x 0x1d) already run. `--dump-scene-actions 5900` lists the remaining rows: 7 `0x62` "Event Flags with Cursor and HS" (30-byte body, one entry), 8 `0x28` special effect (37 B, 1 dependency), 9 `0x9f` sound (dependency), 10 `0x0a` scene change (dependency), 11 `0x51` text to frame text box, 12 `0x9f`, 13 `0x0a`, 14 `0x9f`.

The session only binds `0x9f` today (`create_native_scene_session`, `native_action_sound_handler` in `src/blackmoor_app.mm`). Reviewed kernels exist but are not bound: `action_family_62` (+ `action_family_62_interaction`), `action_family_28` (+ `action_family28_surface`), `action_family_51`. Read their proposals first:
- `work/analysis/slices/A-62-dispatcher-registration-proposal.md`, `A-62-interaction-integration-proposal-luna6.md`, `A-62-interaction-trace-luna6-20261013.md`
- `A-51.dispatcher-registration.md`, `A-51.handoff.json`
- the A-28 receipts (`A-28.3-receipt.json`, `A-28.3.2-sequence-receipt-20261013.json`) and `tasks/A-28*.md`

## Outcome

Take the live S5900 pass as far as the recovered evidence honestly allows, one row at a time, in ACT order:

1. **Row 7, 0x62.** Bind the handler through `SceneSessionActionBinding`. The open problem is the source of the signed `selector`, the start flag, request flag and response words (`ActionFamily62Result`), and the type-0x62 pre-gate request clear the dispatcher proposal says the executor lacks when a dependency gate is false. Recover the real producers from the original bytes (follow `work/tools/rea/.../SKILL.md`) rather than guessing; if a producer cannot be proven, name it and stop at that row with an exact blocker, do not default the selector to zero. Decide whether S5900 row 7 can complete without pointer input (it is a cursor/hotspot action; RT-2 will supply the pointer path). You may add the pre-gate hook to `scene_executor.[ch]`/`scene_session.[ch]` if the evidence requires it.
2. **Rows 8-14.** Continue only as far as you can bind with proven providers: 0x28 with its reviewed frame capture/composition adapters (the app already prepares A-28 handoff frames in `prepare_a28_handoff_frames`; note the live path does not set `transition_source_frame`), 0x51 with the caption/frame text box, the scene-change rows (handled natively by the executor), and the remaining 0x9f sounds. Every unproven step stays an explicit named blocker.

Pointer-driven acceptance is RT-2's: if row 7 needs a click to proceed, build the handler so that the pointer/candidate inputs arrive through a narrow interface, drive it in a test with a synthetic accepted event, and record that the live path waits on RT-2.

## Ownership

You may edit: new `src/session_bindings_*.[ch]` modules you add (preferred home for the adapters, so the app only registers them), `src/scene_executor.[ch]`, `src/scene_session.[ch]` for the pre-gate hook if needed, `scripts/build_native_app.sh` (module list only), `src/blackmoor_app.mm` only for registering your bindings and a minimal host-context struct (no refactors; another thread's RT-1 wiring just landed above you, read it first), `tests/test_scene_session.py`, `tests/test_native_app.py`, new tests and `work/analysis/slices/RT-3.*` evidence. Do not edit the other reviewed kernels (`action_family_*`, `action_sound`, `live_audio`, `macos_*`); propose changes instead.

## Acceptance

- Failing tests first (executor/session level with synthetic worlds for the hook and handler; native-app level for the live S5900 stop moving past row 7, or for the new exact blocker string).
- Every provider you bind is cited to original disassembly addresses; every one you cannot prove is listed.
- Existing tests still pass (`python3 -m unittest discover -s tests`, expect two filesystem skips) and the build is clean under `-Wall -Wextra -Wpedantic -Werror`.
- Re-run `--inspect-live-session --live-click-row 34` and report the new stop row/provider, with the log lines.
- Handoff `work/analysis/slices/RT-3.handoff.json` with commit, baseline, files, commands, results, hashes and an explicit unverified list. Never modify GAME.EXE or the install. Commit only owned files; end commit messages with `Co-Authored-By: Claude Sonnet <noreply@anthropic.com>`.

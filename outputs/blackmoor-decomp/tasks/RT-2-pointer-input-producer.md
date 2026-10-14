# RT-2: original pointer input producer for the live scene session

Branch: `codex/rt-2-pointer-input`, from root's current `claude/hungry-matsumoto-8ab8eb` commit. Worker: Codex `gpt-6.1-sol` at `xhigh`. Integrator (root thread) wires the result into `src/blackmoor_app.mm`; you do not edit the app.

## Why

The live session now feeds the executor a provisional pointer: window coordinates minus the scene viewport origin (10,10), always-permissive cursor-context, no modal guard, activation on any primary-button release. `scene_session.h` says outright that the original viewport/scroll/hot-point transform, cursor-mode guards and WM_LBUTTONUP acceptance are unrecovered. That is a guess, and it decides whether the player can click S0's difficulty choice and every later hotspot.

## Outcome

Recover, from the original bytes, the path that produces `SceneExecutorFrameInput` (`pointer_x/y`, `pointer_valid`, `cursor_context_allowed`, `modal_event_active`, `hotspot_activation_event`): the window-message map handlers for WM_MOUSEMOVE and WM_LBUTTONDOWN/UP, any coordinate transform (viewport, scroll, cursor hot point), the cursor-mode/context and modal-event conditions, the latch (`input_latch`/`input_consume` are existing reviewed pieces; read them), and the point at which the per-tick hit test (`0x43a7ca -> 0x4d3073 -> 0x4f0059`) reads them. Deliver a pure native C module `src/session_input.[ch]` with a small API: feed platform events (move/down/up with logical window coordinates), call once per tick to get a `SceneExecutorFrameInput` pointer/activation subset, and clear edges only after the correct consumer. Everything unproven stays an explicit named limit rather than a guess.

Read first: `AGENTS.md`, `PROJECT-SPEC.md`, `s0-interaction-recovery.md`, `s0-action-runtime-trace.md`, `src/scene_executor.h` (the frame-input contract), `src/input_latch.h`, `src/input_consume.h`, `src/scene_session.h`, and the pointer code in `src/blackmoor_app.mm` (`pointer()`, `prepare_native_session_tick`). Original-code recovery follows `work/tools/rea/node_modules/rea-agents/skills/reverse-engineer-anything/SKILL.md`. Use disassembly of the pinned GAME.EXE as authority; Ghidra pseudocode is a hint.

## Ownership

New files only: `src/session_input.[ch]`, `scripts/build_session_input.sh`, `tests/test_session_input.py`, an original-x86 oracle `tests/session_input_original_oracle.py` (Unicorn, `work/tools/oracle-python/bin/python`), and evidence under `work/analysis/slices/RT-2.*`. Do not edit the app, the session, the executor, or the central build script. If the executor's frame-input contract is wrong, propose the change in the handoff.

## Acceptance

- Tests written first. Cases: viewport offset, coordinates outside the viewport, move-without-button, down-without-up, up-without-down, release outside a hotspot, cursor-mode/modal guards, edge clearing across ticks, repeated release in one tick.
- Original oracle: run the unmodified message handlers / latch under Unicorn with enumerated OS/host hooks only, and compare state and ordered effects with the native module on the same event sequences. Hooks may stand in for OS and host boundaries, never for a decision the original makes.
- A mutation check that the oracle detects (wrong offset, release accepted without down, edge never cleared), and an ASan/UBSan run on bounded malformed sequences.
- Build is clean under `-Wall -Wextra -Wpedantic -Werror`, matching the other module scripts.
- Handoff `work/analysis/slices/RT-2.handoff.json`: commit, baseline, files, build/test commands, source/native/original hashes, hook list, and an explicit unverified list. Update nothing in the status documents.

The Mac is unlocked, but this slice needs no GUI check. Never modify GAME.EXE or the game install. Commit only your owned files; end the commit message with `Co-Authored-By: Codex <noreply@openai.com>`.

# RT-7: raw action 0x35 (MOVIE controller) runtime in the live session

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer, one independent `slice-reviewer` afterwards. Owner of the AVF kernels is the finished S03 pair; the opaque-action decoding thread owns parser registrations, not this slice.

## Where the live game stops

`blackmoor_app --inspect-live-session --live-click-row 34 --live-ticks 3000` (offline audio, no window) goes S0 -> S5900 -> S5907 -> S5901..S5906 -> S4700, then stops: `scene_session_blocked provider=action-kernel` at S4700 row 3, raw/runtime type 0x35 (typed body since A-35.1; `src/action_family_35.[ch]` decodes and constructs it). The next rows after 3 are the 0x97 rows 11-13 (A-97.x, not yours; if the run reaches them, report the stop and finish).

## What 0x35 is

The runtime object is the MOVIE controller: `FUN_004bf9bb` (state machine on the per-row state at `&DAT_005bb632 + row*0x8d`: 0 init, 1 playing, 2 finishing via `FUN_004c0774`; the per-tick helpers are `FUN_004c0205` (AVF branch) and `FUN_004c04e3` (Bink branch, selected by typed word at body +0x21 == 1). The init path creates `SEC_AVF_MOVIE` or `SEC_BINK_MOVIE` surfaces and, for AVF, a "Secondary Movie Reader Thread" (`FUN_004497a0(FUN_004c0c7d, ...)`). Dispatch is `0x427a50`, call site `0x428079`; the loader already normalised nothing (raw 0x35 == runtime 0x35). Full prior evidence: `work/analysis/slices/A-35.1-discovery.md`, `A-35.1.runtime.pseudo.txt`, `A-35.1.handoff.json` (follow-up children A-35.2..A-35.5), `A-35.1.followup-code-windows.json`.

The reviewed AVF decoder and playback kernel already exist, unmerged, on branch `codex/blackmoor-s03-2-avf-playback` (contains S03-1's decoder repair): `src/avf_decoder.[ch]`, `src/avf_player.[ch]`, `scripts/build_avf_player.sh`, tests and oracle. `work/analysis/slices/S03-2.integration-proposal.md` is the integration contract: the MOVIE mode is exactly this controller (record +0x27 double, +0x29 direction, +0x2b / +0x2d first and last frame, controller update `0x4bf9bb`, render-list callback `0x4c0d3f`, completion `0x4c0774`).

## Outcome

Take the live run past S4700 row 3 as far as recovered evidence honestly allows, in this order:

1. **Base.** Merge `codex/blackmoor-s03-2-avf-playback` into your branch (it is a clean fast-forward-able line plus decoder repair). Build and rerun its tests; list any caveat from `S03-2.handoff.json` that still applies. Check the whole corpus first: for all 113 raw-0x35 rows, how many select the AVF branch and how many the Bink branch (word at +0x21), which AVF file each names, whether those files exist in the installed game, and which branch S4700 row 3 takes.
2. **Recover the controller lifecycle** (A-35.2 scope, plus the pieces of A-35.4 that S4700 needs): states 0/1/2 of `0x4bf9bb`, `0x4c0205`, `0x4c0774` (and `0x4c04e3` only if S4700 or the opening path needs the Bink branch), every global read/written, every callee that touches the session (event flags, scene trigger, caption/frame effects, clock, input skip). Original-x86 oracle for the state transitions, hooks only for OS/allocation/thread boundaries, every hook enumerated, as the S03-2 and A-37.2 oracles do.
3. **Implement** `src/action_family_35_runtime.[ch]` (portable lifecycle kernel with a typed host interface that drives `avf_player`) and `src/session_bindings_a35.[ch]` (per-scene row records that live as long as the scene, shared world state, mapping to the executor disposition), following `session_bindings_a51.[ch]` / `session_bindings_a62.[ch]`. The renderer/frame effects stay host callbacks; a visit that needs a missing callback reports UNSUPPORTED before any effect. The reader-thread handshake: the S03-2 kernel is sequential; keep the sequential model and write the deviation down, do not invent real threads.
4. **Register** in `src/blackmoor_app.mm` (`create_native_scene_session` bindings array, minimal host-context only), `scripts/build_native_app.sh` module list, and add the typed-handler registration needed by `decomp-progress/playable.py` (it derives live coverage from the bindings array; run `python3 outputs/blackmoor-decomp/decomp-progress/generate.py` and confirm 0x35 moves to handled).
5. **Drive the live run** and report the new stop row/provider with the log lines. If frames reach a surface, add the smallest honest headless evidence (a frame hash of an AVF frame presented for S4700 row 3, no pixel dumps committed). Every unproven step is an explicit named blocker; never skip a row silently, never default an unknown input to zero.

## Ownership

You may edit: new `src/action_family_35_runtime.[ch]`, `src/session_bindings_a35.[ch]`, `scripts/build_action_family_35_runtime.sh`, new tests/oracle files for them, the merged S03 files only to fix a defect you can prove against the original (say so loudly), and minimally: `src/blackmoor_app.mm`, `src/scene_session.[ch]`, `src/scene_executor.[ch]` (only for what the evidence requires), `scripts/build_native_app.sh` (module list), `tests/test_scene_session.py`, `tests/test_native_app.py`. Do not edit the other action-family kernels, `scene_resource.c` registrations, the status docs or `decomp-progress/`. Unique evidence in `work/analysis/slices/RT-7.*`. Never modify `work/original` or the GOG install or GAME.EXE. No GUI, no computer use, no audio device (offline audio only; the Mac is unlocked but a root pass does the window checks later).

## Acceptance

- Failing tests first (kernel/oracle and session/native-app level), baseline recorded.
- Every provider/field is cited to original addresses; every one not proven is listed.
- `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` under `work/tools/oracle-python/bin/python` passes (the suite is 961 tests with 5 skips today), build clean under `-Wall -Wextra -Wpedantic -Werror`.
- Handoff `work/analysis/slices/RT-7.handoff.json` with commit, baseline, files, commands, results, hashes, an explicit unverified list and the new live stop. Commit only owned files on your branch, no push, message ending `Co-Authored-By: Codex <noreply@openai.com>` and no model identifiers.

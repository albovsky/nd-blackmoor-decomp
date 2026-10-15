# Reconstruction coordination

Claude Code is root (2026-10-13). Implementers: Claude Sonnet (high) `slice-implementer` subagents and Codex `gpt-6.1-sol` (xhigh; the installed `codex` CLI rejects that model, run it through `npx @openai/codex@0.162.1`). Independent review: `slice-reviewer`. Findings are fixed before collection.

Goal of the current run: a playable native ARM64 build. The Mac is unlocked, so GUI and hardware-audio checks are allowed (none have been done yet).

| Work | State |
|---|---|
| RT-1 live audio channel provider | Reviewed, fixed, merged (PR 6) |
| RT-2 / RT-2.1 pointer producer module (Codex) | Reviewed, fixed, merged; wired into the live session by RT-6 |
| RT-3 0x62 / 0x51 session bindings | Reviewed, fixed, on PR 8 |
| RT-4 dependency opcodes 11-15/17/20/21 | Reviewed, fixed, on PR 8 |
| RT-5 scene exit handler + queued 0x28 effect | Reviewed, fixed, on PR 8 |
| RT-6 wire the pointer module, single hotspot candidate | Reviewed (no P1), merged (PR 10) |
| RT-7 raw 0x35 MOVIE controller init (Codex) | Reviewed (no P1), oracle gap fixed, merged (PR 15) |
| RT-8 raw 0x97 (runtime 0x9f) text/sound rows (Codex) | Reviewed (no P1), six coverage gaps fixed, merged (PR 18) |
| RT-9 Bink playback for 0x35: frames, events, embedded audio, completion (Codex) | Reviewed (no P1), findings fixed, merged (PR 20) |
| RT-10 edge/arrow cascade 0x4f0059; RT-11 sound persistence across scene changes (Codex) | In flight on `codex/rt-10-edge-cascade`, `codex/rt-11-sound-persistence`; not reviewed or merged |
| A-35.1 / A-38.1 / A-3F.1 / A-97.1 / A-A1.1 opaque decoders | Reviewed, merged; 0x35 and 0x97 runtimes now bound (RT-7/8/9), the rest unimplemented |
| A-3E.1 / A-6E.1 / A-79.1 / A-67.1 / A-6F.1 / A-43.1 / A-45.1 / A-44.1 / A-36.1 / A-94.1 / A-D1.1 / A-2E.1 / A-0C.1 / A-4E.1 / A-17.1 / A-68.1 / A-83.1 / A-4B.1 / A-69.1 / A-65.1 / A-16.1 opaque decoders (Codex) | Reviewed, merged (typed 19,551 / opaque 61) |
| Track M (M02/M03 whole-file match) | Other threads; 398 exact bytes at last report |
| Whole game / whole-file rebuild | Incomplete |

Live headless run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`): S0 narration plays, the click enters S5900, the game's own transitions carry it through S5907, S5901-S5906 and S4700 (the 0x35 Bink cinematic decodes and presents all 504 frames with its soundtrack on the mixer, the 0x97 rows run), then S4710, S4701, S4711, S4800-S4802, S4712 and S4803-S4808 (23 scenes). It stops at S4808 row 6, raw 0x83 (typed since A-83.1, no runtime handler yet, `provider=action-kernel`). Headless only.

GUI and hardware audio remain unverified: no window or speaker check has been done. This session had no computer-use tools and the shell cannot screen-capture, so the window click-through and listening pass still needs Glib (or a session with computer use). The windowed app does create the same scene session and tick loop (`blackmoor_app.mm` enables the scene runtime unless inspect-only) and reaches the menu; nothing past that was observed.

## Handoff: runtime path after RT-9 (2026-10-14 5:55 PM PDT)

Merged (PRs 13, 15, 18, 20, each with one independent review): PROG-1.1 progress map (Playable build panel, both audited M03 batches counted: 86 functions, 33,326 code bytes, 2.75% of code), RT-7 (0x35 MOVIE controller), RT-8 (raw 0x97), RT-9 (Bink playback). The suite is 1,269 tests (5 skipped); run it twice after a fresh merge, because the first run uses a stale cached scene-resource library and fails two `test_scene_resource` tests.
Unverified and carried forward: Bink audio/video sync is a free-run rule (audio starts at the first decode and is not advanced per frame; at 17 ms ticks the soundtrack ends 17 ms after the last frame with about 70 ms left; BinkWait parity and the SDK default volume are unproven); the 0x97 channel defaults (+0x2f..+0x8c, about 22 fields) are not carried by `ActionSoundCommand` and the sound manager at 0x4f5651..0x4f56d8 is not compared; 311 of 1,958 raw-0x97 rows end in a scene change that is covered only by unit tests and the oracle; real threads are modelled sequentially; all of this is headless (no window, no output device).
Next, in order:
1. S4808 row 6 raw 0x83 runtime (the A-83.1 decoder is merged: build on `src/action_family_83.[ch]`, do not re-decode); read the next stop from the live log and repeat the RT-7/8/9 pattern (Codex implements, one `slice-reviewer`, fix findings, merge, regenerate the map with `build_native_app.sh`, `record_playable_status.py`, `generate.py --preview-browser ~/Library/Caches/ms-playwright/chromium_headless_shell-1243/chrome-headless-shell-mac-arm64/chrome-headless-shell`).
2. Collect RT-10 (edge/arrow cascade) and RT-11 (sound persistence) from their branches: read `work/analysis/slices/RT-10.handoff.json` / `RT-11.handoff.json`, merge `origin/main` into the branch, run the suite twice, review, merge.
3. The real window click-through and listening pass (needs computer use or Glib): launch the built app, New Game, click through S0 narration and the opening, watch the S4700 cinematic and listen to its audio sync.
4. Menus, save/load and the second difficulty (I04/I05).
Merge hygiene: the other thread merges to `main` often, so a PR can turn conflicting right after a push; the generated progress files (`REPORT.md`, `index.html`, `progress.json`, `playable-status.json`) conflict every time: take either side, rebuild, rerun the recorder and the generator, and rerun `test_progress.py` (its assertions that mirror recorded evidence were made to read it instead of hard-coding it, but counts such as typed/opaque records and the registrations list still need a manual bump).

## Handoff: opaque scene actions (2026-10-14 12:50 PDT)

Merged: raw 0x35, 0x38 and 0x3f body boundaries and isolated decoders (A-35.1, A-38.1, A-3F.1; one independent review each, no P1 findings). Typed 18,951 / opaque 661. S4700 now loads and ticks in the live path and blocks at the 0x35 runtime (row 3, A-35.2), then the 0x97 rows 11-13.
Review follow-ups carried forward as unverified: A-3F.1 oracle does not run the 0x424aa8 tail-modulus loop or assert `body_length`; its text-lookup model is only valid for corpus-shaped keys (A-3F.2); 0x38 and 0x37 share runtime byte 0x36, so A-38.2 must discriminate by object contents.
Next: runtime handlers for 0x35 (A-35.2) and 0x97, then the next opaque families (0x6f, 0x45, 0x67, 0x44).

## Handoff: opaque scene actions, second batch (2026-10-14 13:05 PDT)

Merged: raw 0x3e, 0x6e and 0x79 body boundaries and isolated decoders (A-3E.1, A-6E.1, A-79.1; one independent review each, no P1 findings). Typed 19,259 / opaque 353. 0x3e is registered inline (a build-breaking helper call in Codex's proposal was caught by review) and rejects unterminated name and key fields like the decoder.
Review follow-ups carried as unverified for all six new decoders: the originals' oracles stop before 0x424aa8, so the dependency-tail modulus is checked by static reading and reviewer probes, not by the shipped oracle (the original logs and continues on a ragged tail, native rejects); the 0x3e/0x3f text-lookup model matches the original only for corpus-shaped keys; native dylib hashes are path-dependent.
Next: A-35.2 and A-97.x runtime handlers (S4700 rows 3 and 11-13), then oracle-coverage hardening for the tail path, then the remaining opaque families (0x45 32, 0x67 27, 0x44 27, 0x6f 25, 0x36 20; then a long tail).

## Handoff for the next session (runtime-path thread)

State: the live scripted run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`) goes S0 -> S5900 -> S5907 -> S5901..S5906 -> S4700, then S4700 row 3 (type 0x35, typed body, no runtime handler) blocks as `provider=action-kernel`. Pointer input goes through the recovered `session_input` module with one shared hotspot candidate.

Working rules (Glib, 2026-10-14): Pacific time only; hand implementation to Codex (`npx @openai/codex@0.162.1 exec -m gpt-6.1-sol -c model_reasoning_effort=xhigh`; the installed CLI rejects the model) and keep Sonnet `slice-implementer` for the rest; one `slice-reviewer` per slice; two threads (this one plus the Codex action-decoding thread); merge PRs yourself when ready (fix Codex review threads first); after every merged slice regenerate the progress map (`decomp-progress/generate.py`, PROG-1 adds a Playable build panel) and show it to Glib.

Next slices, in order:
1. Drive the run past S4700 once the 0x35 runtime lands (Codex thread, A-35.2); bind it into the session like `session_bindings_a62` (executor extern handler) and read the next stop from the live log.
2. Recover the 0x4f0059 edge/arrow cascade (`[0x5a4c1c]`, `[0x5bb2ca/cc/b6]`, `[0x5b0260/62]`, `[0x5b51f6]`, `[0x5b51c6]`, `[0x5b51ab]`) so `priority_clear` and hover near viewport edges are proven rather than assumed (RT-6 review P2).
3. Settle whether the original keeps sounds across continuation transitions (the blanket `live_audio_unload_all` in `perform_session_transition` is an unverified choice; S5907 row 6 behaves differently with it).
4. Interactive pass on the real window (needs Glib or computer use): click through S0, listen to the narration, check the hover cursor and a double click. Nothing interactive has been verified yet.
5. Menus, save/load and the second difficulty (I04/I05) once the opening scenes run.

## Handoff: opaque scene actions, third batch (2026-10-14 15:00 PDT)

Merged: raw 0x67, 0x6f and 0x43 body boundaries and isolated decoders (A-67.1, A-6F.1, A-43.1; one independent review each, no P1 findings). Typed 19,324 / opaque 288. 0x67 and 0x6f are one-byte fixed bodies; 0x43 is registered inline with both its keyed and inline-text branches and its own unit test.
In progress (Codex gpt-6.1-sol xhigh): A-45.1 (32), A-44.1 (27), A-36.1 (20), branches `codex/A-45.1`, `codex/A-44.1`, `codex/A-36.1`. These packets require the oracle itself to run the original dependency loader 0x424aa8.
Open review follow-ups for every merged decoder (A-35.1 through A-43.1): the shipped oracles stop before 0x424aa8, so the tail modulus and count are verified by reviewer probes, not by the committed oracle; the original takes a fatal path on a ragged tail and on unpaired 0x12/0x13 dependency opcodes (native parser accepts the latter); dylib hashes are path-dependent. A hardening packet (A-TAIL.1) should add a shared 0x424aa8 oracle stage and tail mutants to all of them.

## Handoff: opaque scene actions, fourth batch (2026-10-14 16:00 PDT)

Merged: raw 0x45, 0x44 and 0x36 body boundaries and isolated decoders (A-45.1, A-44.1, A-36.1) and the shared original-backed dependency-tail oracle A-TAIL.1 (one independent review each, no P1 findings). Typed 19,403 / opaque 209. A-TAIL.1 runs the original `0x424aa8` for the nine earlier decoders (45/45 mutants detected; the old oracles missed 44 of them), closing the oracle gap earlier reviews found.
In progress (Codex gpt-6.1-sol xhigh): A-94.1 (12), A-D1.1 (11), A-2E.1 (10). The 0x35 movie runtime belongs to RT-7 (runtime thread), not to this thread.
Open review follow-ups: A-TAIL.2 should add the dependency pre-scan exit at `0x424e98` and its fatal log formats (unpaired 0x12/0x13, the 0xb/0xb rule at 0x424dee, count mismatch at 0x424e5d): the native parser accepts tails the original rejects there, none occur in the corpus; the tail sweep covers lengths 0..48 plus a few large ones; 0x44 test gaps (inline count 0x8000 sign boundary, 32-character key, 48/64-byte tails); 0x36 oracle needs mode-word fixtures (0, 3, 0x0102, 0x8002, 0xfffe) and the mode-selector mutants; the 0x36 runtime byte is also written for raw 0x37 and 0x38, so lifecycle code must key on raw type, not the runtime byte; native count bounds (0x36 100/25, 0x45 and 0x44 negatives) are deliberate safety limits tighter than the original.
Next: the remaining opaque long tail (0x4e, 0x17, 0x68, 0x83, 0x4b, then the families with one to three records), A-TAIL.2, the 0x97 runtime coordination with the runtime thread.

## Handoff: opaque scene actions, fifth batch (2026-10-14 17:15 PDT)

Merged: raw 0x94, 0xd1 and 0x2e fixed-body boundaries and isolated decoders (A-94.1 = 50 bytes, A-D1.1 = 927, A-2E.1 = 15; one independent review each, no P1 findings). Typed 19,436 / opaque 176.
In progress (Codex gpt-6.1-sol xhigh): A-0C.1 (43), A-4E.1 (18), A-17.1 (10).
Open follow-ups: A-TAIL.2 should extend the shared tail oracle to the six later decoders (0x45, 0x44, 0x36, 0x94, 0xd1, 0x2e, then the next batch) and the dependency pre-scan exits; the three fixed-body oracles here cover tails 0..40 only (a 16-bit count truncation and modulus-only-for-small-tails mutants survive them; the shared oracle catches them); short-body rejection is a native safety rule with no original reference.

## Handoff: opaque scene actions, sixth batch (2026-10-14 18:00 PDT)

Merged: raw 0x0c (43 records), 0x4e (18, fixed 31 bytes) and 0x17 (10) body boundaries and isolated decoders (A-0C.1, A-4E.1, A-17.1; one independent review each, no P1 findings). Typed 19,507 / opaque 105.
In progress (Codex gpt-6.1-sol xhigh): A-68.1 (10), A-83.1 (9), A-4B.1 (9). Remaining after that: 0x69 (7), 0x65 (7) and a long tail of families with one to six records.
Review follow-ups: raw 0x16 (2 records, resources 1602 and 1616) uses the same loader arm and layout as 0x17 (0x16..0x19 share arm 0x40b98f) but has no oracle coverage: A-16.1 should register it with its own oracle run; native rejects 0x0c/0x17 counts above 1819 (original wraps its WORD size) as a deliberate safety rule; the new decoders' oracles sweep ragged tails only to 0..40 (A-TAIL.2 covers the dense sweep and the pre-scan).

Dependency pre-scan (A-TAIL.2, 2026-10-14 18:20 PDT): the tail-oracle extension (reviewed, no P1) covers 15 decoders against the original `0x424aa8` and models the content checks the loader runs after the modulus (0x424cb0..0x424e98). `scene_resource.c` now mirrors them in `dependency_prescan_ok`, so a scene whose dependency tail the original aborts on (empty group, one-leaf group, unbalanced 0x12/0x13, adjacent 0x0b pair with a zero word at +6) fails to open natively instead of loading. All 14,445 real tails in the game pass the original pre-scan and the native model. Not modelled: slot-reuse state at `0x424bd6` (loader lifecycle), the post-pre-scan tree construction and ordering of opens and closes. Review follow-ups: the ragged-tail sweep stops at 4,097 bytes (add 8,191/8,193, 65,535/65,537, 2^20+-1 sentinels), the stage's scene argument is vacuous (0), and the "fatal" wording means log, error dialog and aborted load, not process exit.

## Handoff: opaque scene actions, seventh batch (2026-10-14 19:00 PDT)

Merged: raw 0x68 (10 records, fixed 1 byte), 0x83 (9, fixed 74) and 0x4b (9, selector form) body boundaries and isolated decoders (A-68.1, A-83.1, A-4B.1; one independent review each, no P1 findings). Typed 19,535 / opaque 77. The shared tail oracle (`tests/tail_oracle_common.py`) now pins 21 decoders (the six from the last two batches added with their corpus digests, all pass against the original `0x424aa8` with 0 mismatches).
In progress (Codex gpt-6.1-sol xhigh): A-69.1 (7), A-65.1 (7), A-16.1 (raw 0x16, 2 records, same arm as 0x17).
Remaining after that: 0xf6 (6), 0xea (6), 0xf5 (4), 0x1b (4), 0x7d (4) and a tail of families with one to three records (about 40 of the 61 records left after the current batch), then runtime work through the runtime thread.
Open: raw 0x4b record 2804/0 needs a caller-resolved missing-key fallback string (A-4B.2); the three new fixed-body oracles sweep ragged tails to 0..40 only (the shared stage covers the dense sweep); ragged-tail sentinels above 4,097 bytes are still missing from the shared stage.

Live path after this registration (2026-10-14 19:30 PDT): with 0x83 typed, the scripted run now reaches 23 scenes (S0 to S5906, S4700 with its Bink movie, S4710, S4701, S4711, S4800-S4808) and stops at S4808 row 6, raw 0x83, `provider=action-kernel` (typed body, no runtime handler). The 0x83 runtime (loader arm 0x40e995, a 74-byte fixed body) is the next runtime slice for the runtime thread; the live-path tests and progress pins were updated for the new stop.

## Handoff: opaque scene actions, eighth batch (2026-10-14 20:30 PDT)

Merged: raw 0x69 (7 records) and 0x65 (7) one-byte bodies and raw 0x16 (2, sharing the 0x17 layout and loader arm 0x40b98f) boundaries and decoders (A-69.1, A-65.1, A-16.1; one independent review each, no P1 findings). Typed 19,551 / opaque 61. The shared tail oracle pins 23 decoders (0x69 and 0x65 added; 0x16 is a thin wrapper over the 0x17 module with no mutation sites of its own, so it stays out of the shared mutation harness and keeps its own oracle).
Paused: Codex hit its usage limit (retry after Oct 19, 2026 9:58 PM per its own message) while A-1B.1 (4), A-7D.1 (4) and A-33.1 (3) were starting; nothing was committed, the packets are READY. Codex PR reviews are also unavailable until then. Remaining after that: 0xf6 (6), 0xea (6), 0xf5 (4), 0x2d (3), 0xe0 (3), 0xd3 (3) and a tail of one- and two-record types (about 30 records).
Notes for the runtime thread: 0x65 is a save-state call in the original (do not register a no-op handler); registered-but-unhandled types fail at executor step time with `SCENE_EXECUTOR_ERR_UNSUPPORTED`, not at creation.

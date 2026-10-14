# S03-2: AVF playback timing and frame handoff

Owner: Claude, through the owner's existing relay. State: brief issued; claim pending. Parent S03 remains open. Boot owns shared runtime integration.

## Outcome

Reconstruct the AVF playback scheduler and reader/presenter protocol from GAME.EXE into portable C. Produce the frame request, ready/present/acknowledge and completion behavior the original actually uses, with bounded buffers and explicit host boundaries. Connect it to the S03-1 decoder in an isolated automated playback harness. This child delivers a usable playback kernel; live game integration belongs to Boot.

Read AGENTS.md, PROJECT-SPEC.md, WORK-SLICES.md, media-recovery.md, the S03-1 header, and private S03-1 recovery/integration evidence. Use the local REA skill, existing Ghidra exports and immutable machine bytes. Pin the original executable SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.

## Checkout and ownership

First commit and hand off the final S03-1 checkout, including its existing uncommitted changes. Record the final commit, source/library hashes, exact oracle counts, safety divergences and review state. Preserve that checkout for review.

Create a separate worktree/branch `codex/blackmoor-s03-2-avf-playback` from canonical main `0ddd1c9b3a73ddeb358d4535953c970a474ad931` or a later root-approved main. Bring the pinned S03-1 dependency into this branch without rewriting its history or modifying its files. Link canonical work/ for tools/evidence. Inspect existing claims before creating `S03-2-claim-avf_playback_claude-20261013.json` with the WORK-SLICES fields. Root reviews and collects both children separately.

Own only these new files under outputs/blackmoor-decomp/:

- src/avf_player.[ch]
- scripts/build_avf_player.sh
- tests/test_avf_player.py
- tests/avf_player_original_oracle.py
- tasks/S03-2-avf-playback.md

Own uniquely named private `work/analysis/slices/S03-2.*` evidence and your claim. Shared files, the decoder, Bink, sound and caption modules remain read-only. Propose dependency fixes to their owners. Send the proposed public header and state/host boundary map to root before implementing a materially new integration contract; continue source recovery while awaiting architecture feedback. Claude performs the assigned implementation himself.

## Starting anchors

| Address | Recovery question |
|---|---|
| 0x4cf687 | Reader worker loop, frame requests, single/double mode, decode completion and wait/signal order |
| 0x4ce602 | AVF movie frame consumption, timing, ready flags, presentation and completion |
| 0x4bf710 / 0x4dc2f8 | Start/restart and index/toggle initialization in their respective callers |
| 0x4161d1 | Frame-buffer setup and flags; relationship to decoder lifetime |
| 0x44c479 / 0x44c4ab | Worker/presenter handshake and ownership of synchronization state |
| 0x4163b4 / 0x4cdfd3 | Background/movie opening, mode selection and caller state boundaries |
| 0x41546f / 0x4156ea | Decoder dependency: retained frames, written slot and flags |

Follow actual callers and writes to object/global state, including the candidate locations `0x638225`, `0x5e2dbe`, `0x6383f1` and frame index +0x1c2. These are recovery leads, not certified field meanings. Distinguish background and movie/controller instances instead of merging similar layouts by assumption. Header +0x1c is 66 in the decoder inventory; establish its timing interpretation from its consumers before assigning units or fps.

## Work and acceptance

1. Recover a source-ordered state/command map with exact widths, signedness, clock origin, comparisons, wrap behavior, frame bounds, single/double selection, EOS and every reachable reset/stop/restart path. Identify each buffer's writer and reader, every flag producer/consumer, waits/signals and teardown sequence. List complete routine/code-window hashes and all original-oracle hooks. Separate source behavior from native lifetime safeguards.
2. Define an explicit player/session API with caller-owned decoder/file/buffers and a typed host boundary for sampled clock, decode request/completion, presentation and synchronization. Keep unsupported or unavailable effects observable. Preserve effects already committed before a failing callback. Specify outstanding work and borrowed-data lifetime across stop, replacement and destruction. Any native epoch protection must be labeled as a port safeguard, not an original field.
3. Build deterministic oracle fixtures that execute the actual original scheduler, worker/consumer logic and reachable helpers. Hooks may supply OS clocks/events/files/allocations; enumerate their assumptions and validate request/response arguments. Do not replace scheduler decisions with Python hooks. Compare ordered effects, state bytes, indices, slot/flags, time decisions and completion reasons after each step.
4. Implement the portable kernel and isolated decoder-backed harness. Cover just-before/at/after each timing boundary, slow consumer/worker, duplicate polls, empty/no-new-image records, last frame, restart, cancellation and stale completion. Cover pause/resume, repeat and seek only where source paths are established; report missing source branches explicitly. Preserve predecessor dependencies on nonsequential requests. Use checked arithmetic and exact source-width behavior for valid inputs.
5. Exercise all 32 installed AVF assets through the recovered applicable modes. Recount frames against the pinned final S03-1 inventory rather than copying a stale count. Record every decoded/requested/presented frame and explain legitimate retained or repeated frames. Include synthetic type-1/type-2/empty records where the real corpus omits them. Compare scheduler traces with original execution and verify presented pixels with the pinned decoder oracle evidence; distinguish these evidence classes.
6. Add malformed-state/argument tests and ASan/UBSan checks for index/count arithmetic, too-small buffers, invalid state, decoder failure, host failure and stop/restart while work is outstanding. Prove that deliberately broken timing and buffer/handshake rules are caught by the original comparison. If actual native threading is added, verify the synchronization model rather than treating sequential mocks as race coverage.
7. Freeze and commit owned files. Return exact build/unit/oracle commands, counts and zero unexplained valid-input mismatches; original, source, input, oracle and native-library hashes; hooks and unverified branches. Request independent review, fix material findings and rerun affected checks. Root collects only the reviewed snapshot.

Write `S03-2.handoff.json`, `S03-2.validation.json`, concise recovery evidence and a read-only integration proposal specifying Boot's load/tick/present/stop/destruction calls. This child is accepted only when timing, ownership and completion have original-backed comparisons plus real decoder-backed corpus playback. A timer demo or predecoded slideshow does not satisfy those checks.

The Mac remains locked: use original-x86 oracles and automated offscreen checks. GUI/hardware checks wait for explicit unlock. Live ACT movie integration, all-game playthroughs, complete x86 matching and native packaging remain separate open work.

## Status (Claude, 2026-10-13)

The playback kernel is implemented and committed on `codex/blackmoor-s03-2-avf-playback`:
- `7b750e2`: reviewed snapshot
- `909daf0`: fixes for the review findings
- API amendments (root decision): the header and reports now state the recovered publication order (worker acquire, decode, release, R = 1; stop acquire, H = 2, kill, release, H = 0) and that sequential fixtures prove only the tested orderings, not real-thread synchronisation; stop is a caller-owned quiescence boundary; secondary slot ownership, generation scope, typed events with provider status and GetTickCount semantics are documented; pause/seek/repeat are reported as not located (unverified/unsupported). One new unit test covers secondary slot ownership with variable chunk sizes. No behaviour changed.

It depends on S03-1, merged unmodified at the repaired decoder commit (declared key size versus conversion footprint). The receipt is `work/analysis/slices/S03-2.handoff.json`.

**Original-trace comparison.** 369 cases (209 synthetic and 160 installed-file playbacks across the four controllers), 13,501 compared steps, 0 mismatches. The oracle runs the unmodified original start, worker, tick, render and stop routines.

**Decoder-backed playback.** 168 playbacks (32 installed files × 5 controller configurations, plus synthetic delta and full files). Presented pixels match the pinned decoder for every frame (0 mismatches), and every playback is in order.

**Mutation check.** All 10 planted timing and handshake bugs are detected.

**ASan/UBSan.** Clean over about 621k randomized operations.

**Still open:**
- Boot integration: threading, view gate, surfaces and controller completion.
- Bink variants.
- Root review of the final commit.

Parent S03 stays open.

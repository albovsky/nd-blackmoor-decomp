# Parallel reconstruction work

The earlier S0 diagnostic slice is complete; persistent live scene integration remains incomplete. The complete game remains unfinished. This catalogue covers every currently observed unimplemented raw action family, plus world/media/audio/caption/conditions/save/matching work and the later integration gates.

Permanent project: `/Users/albovsky/Projects/nd-blackmoor-decomp`.

## First work wave

The following packets can start independently. For four workers, start A-64, A-62, S01 and S02; then add A-28/A-51 and sound/caption work as slots become free. Workers follow the `AGENTS.md` roster. Workers may already be active: before starting a packet, check `work/analysis/slices/` for an existing claim. Registry `READY` status means a packet can start, not that it is unclaimed.

| Slice | Deliverable | Ownership |
|---|---|---|
| A-64 | [Action 0x64: body boundary and runtime](tasks/A-64-action-64.md) | Separate new module; shared integration reserved |
| A-62 | [Action 0x62: body boundary and runtime](tasks/A-62-action-62.md) | Separate new module; shared integration reserved |
| A-28 | [Action 0x28: body boundary and runtime](tasks/A-28-action-28.md) | Separate new module; shared integration reserved |
| A-51 | [Action 0x51: body boundary and runtime](tasks/A-51-action-51.md) | Separate new module; shared integration reserved |
| S01 | [Complete world initialization](tasks/S01-world-init.md) | Separate new module; shared integration reserved |
| S02 | [Timed Bink playback](tasks/S02-bink-player.md) | Separate new module; shared integration reserved |
| S04 | [Sound control and decoder fidelity](tasks/S04-sound-control.md) | Separate new module; shared integration reserved |
| S05 | [Caption layout and font rendering](tasks/S05-caption-layout.md) | Separate new module; shared integration reserved |

## Complete catalogue

`slice-registry.json` contains 86 registered packets, including bounded recovery/kernel children and six gated integration packets. Every one has a file boundary, inputs/outputs, evidence steps and acceptance conditions. The action packets use current corpus counts: 2,078 scenes, 19,612 actions, 19,551 typed body boundaries, 61 opaque records. Typed metadata is not implemented gameplay.

All remaining action-family packets are in `tasks/A-*.md`; each raw family has one owner. Large families must split into numbered body/runtime/branch child packets before coding; their parent remains incomplete until all discovered variants pass. Raw 0x37 (4,308), 0x97 (1,958), 0xa1 (565), 0x3f (493), 0x38 (425), 0x3e (202), 0x35 (113), 0x6e (68), 0x45 (32), 0x67 (27), 0x44 (27), 0x6f (25), 0x36 (20), 0x79 (38), 0x43 (13), 0x0c (43), 0x4e (18), 0x94 (12), 0xd1 (11), 0x2e (10), 0x17 (10), 0x68 (10), 0x83 (9), 0x4b (9), 0x69 (7), 0x65 (7) and 0x16 (2) now have registered parser body boundaries from A-37.2, A-97.1, A-A1.1, A-3F.1, A-38.1, A-3E.1, A-35.1, A-6E.1, A-79.1, A-67.1, A-6F.1, A-43.1, A-45.1, A-44.1, A-36.1, A-94.1, A-D1.1, A-2E.1, A-0C.1, A-4E.1, A-17.1, A-68.1, A-83.1, A-4B.1, A-69.1, A-65.1 and A-16.1 (reviewed Codex gpt-6.1-sol work); their handlers/runtime remain unimplemented and the executor reports them unsupported at dispatch. The largest remaining opaque recovery families are 0xf6 (6), 0xea (6), 0xf5 (4), 0x1b (4, A-1B.1 active), 0x7d (4, A-7D.1 active) and 0x33 (3, A-33.1 active). S4700 now loads in the live path and stops at the 0x35 runtime (row 3).

## Current integration assignment

The owner resumed work with Claude Code as root on 2026-10-13. Root (Claude Opus) plans, reviews and collects. Implementers are Claude Sonnet (high) subagents, defined in `.claude/agents/slice-implementer.md`, and Codex `gpt-6.1-sol` (xhigh). Independent review uses `.claude/agents/slice-reviewer.md`.

First assignment: finish S03.
1. Apply root's S03-1 decoder repair (`CLAUDE-S03-1-REVIEW-FIX.md`).
2. Propagate it into S03-2, applying root's API amendments (`CLAUDE-S03-2-API-DECISION.md`).
3. Run an independent review.
4. Collect onto main.

A-37.3 and S04-2.2 stay paused; S04-2.2 is the live-audio blocker at S0 row 31 and is the likely next slice. See `COORDINATION-STATUS.md`.

## Track M: whole-file x86 match

Owner ruling of 2026-10-14 (see `AGENTS.md` and `M0-binary-census-report.md`): functions may be produced as tool-assisted assembly with independent review. Two packets start now and need no shared-file edits:

| Slice | Deliverable | Ownership |
|---|---|---|
| M02 | [Whole-file skeleton and image composer](tasks/M02-whole-file-skeleton-and-composer.md) | New `image/` sources, composer script, tests, private M02.* evidence |
| M03 | [Hinted assembly generator and first reviewed batch](tasks/M03-hinted-assembly-generator-and-first-batch.md) | New generator/audit scripts, `asm/` batch sources, tests, private M03.* evidence |

## Runtime path (RT) slices, 2026-10-14

| Slice | Deliverable | State |
|---|---|---|
| RT-1 | [Live audio channel provider](tasks/RT-1-live-audio-channels.md) | Collected |
| RT-2 | [Pointer input producer](tasks/RT-2-pointer-input-producer.md) | Collected; wiring is RT-6 |
| RT-3 | [S5900 0x62/0x51 bindings](tasks/RT-3-s5900-a62-a51-binding.md) | Collected |
| RT-4 | [Dependency leaves](tasks/RT-4-dependency-leaf-integration.md) | Collected |
| RT-5 | [Scene exit handler and 0x28 effect](tasks/RT-5-scene-exit-handler-and-a28-effect.md) | Collected |
| RT-6 | [Pointer integration](tasks/RT-6-pointer-integration.md) | Collected |
| RT-7 | [0x35 MOVIE controller](tasks/RT-7-0x35-movie-runtime.md) | Collected (PR 15) |
| RT-8 | [Raw 0x97 runtime](tasks/RT-8-a97-runtime.md) | Collected (PR 18) |
| RT-9 | [Bink playback for 0x35](tasks/RT-9-bink-movie-playback.md) | Collected (PR 20) |
| RT-10 | [Edge/arrow cascade 0x4f0059](tasks/RT-10-edge-cascade.md) | In flight (branch `codex/rt-10-edge-cascade`) |
| RT-11 | [Sound persistence across scenes](tasks/RT-11-sound-persistence.md) | In flight (branch `codex/rt-11-sound-persistence`) |

Opaque action decoders (A-35.1, A-38.1, A-3F.1, A-3E.1, A-6E.1, A-79.1, A-97.1, A-A1.1 merged) are driven by the opaque-action thread, Codex implementers and one independent reviewer per packet.

## Ownership and coordination

Workers create only their packet's new module/test/build/evidence files. The integrator alone edits shared scene parsing, scheduling, conditions, existing audio/platform/app files and central build scripts. Workers supply registration proposals and public headers; the integrator incorporates them sequentially. A local Git baseline supports separate branches/worktrees. Every worktree must also have access to the private `work/` evidence/tools (link the canonical project's `work/` directory when needed); generated builds stay local to each checkout. Workers write unique slice evidence/receipt filenames in the shared evidence directory. Use separate branches/worktrees if simultaneous work could touch the same file. Claim a packet with a JSON receipt at `work/analysis/slices/<ID>-claim-<owner>-<date>.json` containing `slice`, `owner`, `status`, `branch`, `baseline`, `worktree` and `created_utc_date`; do not have every worker rewrite the central registry.

A handoff receipt includes commit/change location, build/test commands, original/native hashes, branch and corpus coverage, enumerated oracle hooks, unresolved cases, and an independent review result. No worker marks the complete game finished. A ready packet means its recovery/kernel work can start; it does not mean all original behavior is already known.

## Integration order

I01 makes the S0 scene live after world, media, sound and caption contracts finish. I02 adds opening execution after A-64/A-62/A-28/A-51. I03 integrates remaining family/dependency work, AVF playback (S03) and condition extras (S06) in reviewed scene-sized batches. I04 adds full menus/session restart/save restoration. I05 verifies both campaigns and hardware input/audio. I06 finishes whole-executable matching and final native packaging. S08 proceeds independently from the start; byte matching cannot be postponed away from the owner's completion requirements.

Read `PROJECT-SPEC.md`, `PROJECT-HANDOFF.md`, then the chosen packet. The old conversation is not required to pick up a packet.

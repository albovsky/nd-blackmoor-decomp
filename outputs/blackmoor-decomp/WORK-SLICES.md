# Parallel reconstruction work

The current S0 integration slice is complete. The complete game remains unfinished. This catalogue covers every currently observed unimplemented raw action family, plus world/media/audio/caption/conditions/save/matching work and the later integration gates.

Permanent project: `/Users/albovsky/Projects/blackmoor-reconstruction`.

## First work wave

The following packets can start independently. For four workers, start A-64, A-62, S01 and S02; then add A-28/A-51 and sound/caption work as slots become free. Use GPT-6 Luna Max. Workers are already active: before starting a packet, check `work/analysis/slices/` for an existing claim. Registry `READY` status means a packet can start, not that it is unclaimed.

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

`slice-registry.json` contains 75 packets: 69 independent recovery/kernel packets and 6 gated integration packets. Every one has a file boundary, inputs/outputs, evidence steps and acceptance conditions. The action packets use current corpus counts: 2,078 scenes, 19,612 actions, 9,111 typed body boundaries, 10,501 opaque records. Typed metadata is not implemented gameplay.

All remaining action-family packets are in `tasks/A-*.md`; each raw family has one owner. Large families must split into numbered body/runtime/branch child packets before coding; their parent remains incomplete until all discovered variants pass. The largest opaque families are 0x37 (4,308 records), 0x97 (1,958), 0x62 (1,802), 0xa1 (565), 0x3f (493) and 0x38 (425). S5900's immediate blockers are 0x64,0x62,0x28,0x51.

## Current integration assignment

Boot (/root/boot_world_contract_luna6) is the sole shared writer for [I01-1 persistent scene session](tasks/I01-1-persistent-scene-session.md), following A-28 adapter review repairs. Claude owns the independent [S03-1 AVF decoder](tasks/S03-1-avf-decoder.md). Sound-control and condition-provider workers use separate module/evidence ownership. Root coordinates independent review and sequential collection. Parent integration gates remain open until their complete requirements pass.

## Ownership and coordination

Workers create only their packet's new module/test/build/evidence files. The integrator alone edits shared scene parsing, scheduling, conditions, existing audio/platform/app files and central build scripts. Workers supply registration proposals and public headers; the integrator incorporates them sequentially. A local Git baseline supports separate branches/worktrees. Every worktree must also have access to the private `work/` evidence/tools (link the canonical project's `work/` directory when needed); generated builds stay local to each checkout. Workers write unique slice evidence/receipt filenames in the shared evidence directory. Use separate branches/worktrees if simultaneous work could touch the same file. Claim a packet with a JSON receipt at `work/analysis/slices/<ID>-claim-<owner>-<date>.json` containing `slice`, `owner`, `status`, `branch`, `baseline`, `worktree` and `created_utc_date`; do not have every worker rewrite the central registry.

A handoff receipt includes commit/change location, build/test commands, original/native hashes, branch and corpus coverage, enumerated oracle hooks, unresolved cases, and an independent review result. No worker marks the complete game finished. A ready packet means its recovery/kernel work can start; it does not mean all original behavior is already known.

## Integration order

I01 makes the S0 scene live after world, media, sound and caption contracts finish. I02 adds opening execution after A-64/A-62/A-28/A-51. I03 integrates remaining family/dependency work, AVF playback (S03) and condition extras (S06) in reviewed scene-sized batches. I04 adds full menus/session restart/save restoration. I05 verifies both campaigns and hardware input/audio. I06 finishes whole-executable matching and final native packaging. S08 proceeds independently from the start; byte matching cannot be postponed away from the owner's completion requirements.

Read `PROJECT-SPEC.md`, `PROJECT-HANDOFF.md`, then the chosen packet. The old conversation is not required to pick up a packet.

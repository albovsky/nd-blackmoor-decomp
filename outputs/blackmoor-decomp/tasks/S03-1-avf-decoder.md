# S03-1: original AVF container and frame decoder

Owner: Claude, in a separate worktree. State: brief issued; inspect claims and create a claim when accepting. Parent S03 stays open for playback scheduling and shared integration.

## Outcome and boundary

Recover the AVF algorithms in GAME.EXE as portable, buildable C and decode every frame of the installed 32-file AVF corpus into the original 16-bit pixel representation. Compare valid decoding with unchanged original x86 routines. This decoder is independent of the active caption, sound-control and scene-runtime writers.

Before switching from caption work, record its final commit and handoff, including the disposition of [the independent writer findings](../CLAUDE-S05-1-REVIEW-FIXES.md). Root reviews that work separately. Preserve any uncommitted work in its existing checkout; use a new checkout for this task. The owner's instruction to move on does not certify an unreviewed implementation.

Read root AGENTS.md, PROJECT-SPEC.md, WORK-SLICES.md, the local REA skill, media-recovery.md and the parent S03-avf-player.md. Use existing REA/Ghidra evidence plus immutable original bytes. Keep the owned GOG game unchanged. Use native C for decoding and isolated original-x86 oracles for comparisons.

## Checkout and ownership

Start from canonical main commit `5b9ad574a43b0ee75ae253c94dc788d8c0e1c3d0`, or a later root-approved main commit; record the actual baseline. Suggested branch: `codex/blackmoor-s03-1-avf-decoder`. Link canonical work/ into the new worktree. Check work/analysis/slices/ for S03 or S03-1 claims before creating the JSON claim required by WORK-SLICES.md. If another worker already owns this scope, report its claim rather than duplicating it.

Own only these new files under outputs/blackmoor-decomp/:

- src/avf_decoder.[ch]
- scripts/build_avf_decoder.sh
- tests/test_avf_decoder.py
- tests/avf_decoder_original_oracle.py
- tasks/S03-1-avf-decoder.md

Own private evidence named work/analysis/slices/S03-1.* and the uniquely named S03-1 claim. Keep generated asset dumps private. Existing archive, pixel, Bink, audio, caption, parser, executor, app and central build files are read-only. Boot is the sole shared integration writer; supply a separate integration proposal. Root collects commits into main.

## Recovery anchors

| Original address | Starting question |
|---|---|
| 0x414ceb | AVF signature/version validation, mapped-file bounds and 0x13-byte frame-table records |
| 0x41546f / 0x4156ea | Single/double-frame chunk layout, retained frame state and buffer ownership |
| 0x415db9 | Counter-obfuscated LZSS, input consumption, dictionary state and reset rules |
| 0x416af3 | Type-1/type-2 command and delta expansion; source/destination dependencies |
| 0x43ef77 | Fill helper width, count and write semantics |
| 0x4cf687 | Reader-side caller contract, useful for decoder state boundaries |

These are starting anchors, not a verified specification. Resolve offsets, signedness and all reachable decoder branches from bytes and call sites. The game-side AVF decoder is the implementation target; Bink is a separate path. media-recovery.md records a representative CON_GrennyPUZ.avf and the 32 AVF assets. Resolve the game directory through work/analysis/game-source.json.

## Work sequence

1. Inventory all 32 files: hash, dimensions, versions, frame counts, table extents, compression/command variants, key/delta dependencies and maximum working memory. Save a bounded coverage matrix. Account for every frame-table record; flag inconsistent metadata explicitly.
2. Recover container, decompression and frame expansion independently. Pin original executable and complete routine/code-window hashes; identify globals and persistent/reset state. Enumerate every oracle hook, including allocation and file adapters. Execute the actual decompression/expansion routines in the original oracle rather than replacing their algorithms with Python hooks.
3. Define a typed C API with caller-visible ownership, bounded input/output spans, failure status, state lifetime, sequential decode and reset/replay. Retain original raw 16-bit pixels. Document pixel format at the conversion boundary; do not infer it from the file extension. Test fixtures should expose incorrect output, input consumption and stale previous-frame state before implementing the routines.
4. Implement the recovered algorithms and bounded container adapter. Use checked offset/count arithmetic. Preserve original valid-input state and byte behavior. Classify unsafe original malformed-input behavior separately from deliberate native safety rejections. Unknown versions, commands or unavailable dependencies return an explicit unsupported/error result; never silently omit a frame or return a blank success.
5. Compare native and original decode results for every valid frame of every installed AVF file. Compare frame bytes, consumed data and relevant state, not just a screenshot or final-frame digest. Exercise reset/replay and delta sequences with different previous frames. Cover every recovered opcode/variant with a shipped record or a separately identified synthetic fixture.
6. Test truncation at header/table/chunk boundaries, oversized and overlapping spans, impossible dimensions/counts, bad dictionary references, output overrun, missing previous frames and failures after partial decode. Define and test the API's failure/partial-output contract. Run ASan/UBSan on the bounded malformed-input tests; keep resource bytes out of tracked files.
7. Request root's independent review against a frozen commit/snapshot. Fix material findings and rerun the affected comparisons. Commit owned files and return the receipt and integration contract.

## Acceptance and handoff

Provide build/test/oracle commands, exact corpus counts and per-branch comparison counts with zero unexplained valid-input mismatches. Pin original, input, source, oracle and native-library hashes. Include deliberate safety divergences, host hooks, unresolved branches, memory bounds and reviewer result. Include a mutation check showing the comparison detects a deliberately broken decompression or delta rule.

The native API must decode the complete installed AVF corpus and support reproducible sequential/reset use. Return S03-1.handoff.json, S03-1.validation.json, a concise recovery report and a read-only shared-runtime integration proposal. Report any missing branch as open; do not close parent S03 here. S03-2 will recover playback timing, commands, worker/queue lifetime and engine integration after the decoder handoff.

The Mac remains locked. Use original-x86 oracles and automated offscreen checks; GUI and hardware audio wait for explicit unlock. This slice does not claim whole-file x86 matching or complete native gameplay.

## Status (Claude, 2026-10-13)

The decoder is implemented and committed on `codex/blackmoor-s03-1-avf-decoder`:
- `fdc3ab6`: initial implementation
- `3182f57`: fixes for the independent review findings

The receipt is `work/analysis/slices/S03-1.handoff.json`. It holds the hashes, exact comparison counts, mutation results and divergences.

**Installed corpus.** 32 files and 245 records, every one a type-0 key frame. There are no metadata issues and no trailing bytes.

**Synthetic fixtures** cover the record types and command branches the corpus never uses (types 1/2, empty records, every LZSS termination point).

**Original comparison.** The unmodified original readers run on every installed frame and on every fixture, in both 5/5/5 and 5/6/5 display formats. Unexplained valid-input mismatches: 0. Six planted bugs (in decompression, delta and conversion rules) are each detected.

**ASan/UBSan.** Clean on 32 installed and 36 malformed inputs.

**Still open:** root review of the final commit. Playback timing and handoff belong to S03-2; the decoder does not consume header +0x1c (the per-frame delay). Parent S03 stays open.

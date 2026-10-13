# AVF media path Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Recover original AVF container/frame decompression and playback command behavior, using actual installed AVF files. Keep Bink ownership separate.

**Architecture:** Work in a new isolated module, retain original state/commands in a portable C kernel, and expose host boundaries through typed contracts. The integrator connects it to the app after independent review.

**Tech Stack:** REA/Ghidra, original PE32 bytes, C11/C++17, Clang ARM64, isolated Unicorn oracles where applicable.

**Spec:** `../PROJECT-SPEC.md`

## Global Constraints

Read `../PROJECT-SPEC.md` and root `AGENTS.md`. Use GPT-6 Luna Max. Keep original executable/assets unchanged. Use original bytes to substantiate behavior; retain unsupported branches explicitly. No GUI while the Mac remains locked. Do not edit integrator-owned files.

## Review Focus

- Truncated/count-overflow resource inputs must fail before out-of-bounds reads or mutations.
- False dependency gates and subtype-2 reset must preserve original lifecycle behavior.
- Stale completion callbacks or failed host calls must not silently commit a transition.
- Raw-type normalization must preserve the distinction between typed body and dependency tail.
- Host boundary hooks must be enumerated; passing oracle fixtures must not imply full-game equivalence.

## Task: S03

**Status:** READY: S03-1 decoder brief issued to Claude; worker claim pending. Parent remains open for S03-2 playback and integration.

**Current child:** [S03-1 AVF decoder](S03-1-avf-decoder.md) defines the active file ownership and acceptance contract. Read it before starting implementation. The parent file list below is reserved for later playback work.

**Files:** Own new `src/avf_player.[ch]` (or `.mm` only for native rendering), `tests/test_avf_player.py`, `tests/avf_player_original_oracle.py`, `scripts/build_avf_player.sh`, and `work/analysis/slices/S03.*`. Prefix paths with `outputs/blackmoor-decomp/` except evidence. Existing shared files are read-only; deliver integration proposals separately.

**Interfaces:** Consume Existing archive/HIFF/pixel kernels. Produce a public header for the bounded module plus a contract mapping each state/command field to its original address/offset. Public interface changes are reviewed by the integrator before shared-file integration.

**Starting evidence:** outputs/blackmoor-decomp/media-recovery.md; work/analysis/full-game-snapshot.json.

- [ ] Trace source-byte anchors, all observed branches and state lifetime; save a bounded recovery report and hash the code windows.
- [ ] Define the public header and original/native fixtures for the acceptance conditions below; enumerate host hooks and excluded behavior.
- [ ] Run the fixtures before implementation and record the missing behavior/failure.
- [ ] Implement the isolated module and explicit bounds/unsupported/error paths. Do not mutate neighboring modules.
- [ ] Run `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_avf_player.py'`; run the pinned original oracle separately when applicable. Scoped JIT/offline audio checks may need sandbox approval; no UI.
- [ ] Obtain an independent review, fix concrete findings and rerun affected checks.
- [ ] Hand off source/header/tests/build command, code/native hashes, comparison counts, unresolved behavior and the shared integration patch proposal. Update only this packet's status or a separate completion receipt.

**Acceptance:** Bounded original-decode comparisons and malformed-input checks pass for every discovered AVF compression/frame branch; provide a native decode/playback module.

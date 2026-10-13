# Caption layout and font rendering Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Recover font metrics, markup <h>/<n>/<o>/<e>, line wrapping, timed presentation and original caption window geometry. Preserve original byte encoding and missing-text fallback.

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

## Task: S05

**Status:** READY: original recovery + isolated renderer

**Files:** Own new `src/caption_layout.[ch]` (or `.mm` only for native rendering), `tests/test_caption_layout.py`, `tests/caption_layout_original_oracle.py`, `scripts/build_caption_layout.sh`, and `work/analysis/slices/S05.*`. Prefix paths with `outputs/blackmoor-decomp/` except evidence. Existing shared files are read-only; deliver integration proposals separately.

**Interfaces:** Consume autotext.h and BOOT/font/resource access. Produce a public header for the bounded module plus a contract mapping each state/command field to its original address/offset. Public interface changes are reviewed by the integrator before shared-file integration.

**Starting evidence:** outputs/blackmoor-decomp/autotext-recovery.md; outputs/blackmoor-decomp/action-sound-recovery.md.

- [ ] Trace source-byte anchors, all observed branches and state lifetime; save a bounded recovery report and hash the code windows.
- [ ] Define the public header and original/native fixtures for the acceptance conditions below; enumerate host hooks and excluded behavior.
- [ ] Run the fixtures before implementation and record the missing behavior/failure.
- [ ] Implement the isolated module and explicit bounds/unsupported/error paths. Do not mutate neighboring modules.
- [ ] Run `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_caption_layout.py'`; run the pinned original oracle separately when applicable. Scoped JIT/offline audio checks may need sandbox approval; no UI.
- [ ] Obtain an independent review, fix concrete findings and rerun affected checks.
- [ ] Hand off source/header/tests/build command, code/native hashes, comparison counts, unresolved behavior and the shared integration patch proposal. Update only this packet's status or a separate completion receipt.

**Acceptance:** Actual S0 NSHT01 caption and representative markup/font fixtures produce original-derived layout commands/pixels; embedded NUL, absent font and malformed markup branches fail explicitly.

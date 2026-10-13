# Action 0x47 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Recover and implement raw action family 0x47: runtime (body boundary already typed).

**Architecture:** Reconstruct the loader and normalized runtime semantics in a new portable module with typed backend commands. The integrator alone adds shared parser/dispatcher registrations.

**Tech Stack:** REA/Ghidra, C11 ARM64, original PE32 x86 oracle, Python tests.

**Spec:** `../PROJECT-SPEC.md`

## Global Constraints

Read `../PROJECT-SPEC.md` and root `AGENTS.md`. Use GPT-6 Luna Max. Keep original executable/assets unchanged. Use original bytes to substantiate behavior; retain unsupported branches explicitly. No GUI while the Mac remains locked. Do not edit integrator-owned files.

## Review Focus

- Truncated/count-overflow resource inputs must fail before out-of-bounds reads or mutations.
- False dependency gates and subtype-2 reset must preserve original lifecycle behavior.
- Stale completion callbacks or failed host calls must not silently commit a transition.
- Raw-type normalization must preserve the distinction between typed body and dependency tail.
- Host boundary hooks must be enumerated; passing oracle fixtures must not imply full-game equivalence.

## Task: A-47

**Status:** READY for independent recovery and isolated source. Priority: remaining corpus family.

**Corpus:** 139 actual records; 139 typed body boundaries and 0 opaque records. These counts do not prove runtime support. Use `action-census-current.json`; the older priority report is historical and may list already-typed families as opaque.

**Files:** Own new `src/action_family_47.[ch]`, `tests/test_action_family_47.py`, `tests/action_family_47_original_oracle.py`, `scripts/build_action_family_47.sh`, and `work/analysis/slices/A-47.*`. Shared `scene_resource`, `scene_executor`, `scene_conditions`, `action_sound`, app/platform and central build files are read-only.

**Interfaces:** Consume immutable `SceneActionInfo` raw bytes and the current source-resource corpus. Produce `ActionFamily47Decoded`, `ActionFamily47Input/Backend/Result` and a public bounded decode/step header with original-derived fields; record the exact signatures in the handoff before integration. Do not guess dependencies or state names. Any runtime-type alias must be proven from the loader.

- [ ] Locate the original raw-type loader using `function-index.json`, `action-body-recovery.md` and the saved original snapshot; trace normalized dispatch in `0x427a50`. Hash original code ranges.
- [ ] Map all observed body variants and dependency cursor boundaries. Check every 139 corpus record, not only 16-byte tail alignment; validate cursor/constructor fixtures against original code.
- [ ] Map lifecycle, subtype completion/reset, ordering, relevant global state and backend side effects. Define a typed header and branch inventory. For a complex family, create numbered child packets for distinct branches before implementing them; this parent stays incomplete until they all pass.
- [ ] Add original/native fixtures for each observed branch plus false gates, reset, malformed lengths/counts, host failure and any delayed transition. Record the failing baseline.
- [ ] Implement only the owned module. Emit typed commands for unreplaced platform boundaries; unresolved branches return explicit unsupported and keep this packet incomplete.
- [ ] Build with the owned script; run `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_action_family_47.py'` and the isolated original oracle. Report comparison/hook counts and hashes.
- [ ] Obtain independent review and fix findings. Hand off a parser-body-size/normalization registration proposal and dispatcher callback proposal as separate files; do not edit shared code concurrently.

**Acceptance:** Every observed variant has a proven body boundary and dependency split; the reconstructed native kernel matches original state/command fixtures across all observed branches; invalid input fails before mutation. Corpus counts reconcile and all unresolved paths are listed. The integrator's end-to-end check is a separate gate.

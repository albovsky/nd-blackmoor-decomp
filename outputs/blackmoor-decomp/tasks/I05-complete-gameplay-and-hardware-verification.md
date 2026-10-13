# Complete gameplay and hardware verification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Run both difficulty campaigns to endgame with save/reload and representative branch coverage, under real macOS window/input/audio after explicit unlock. Compare original-derived state transitions; record UI/audio/codec limits. Do not treat a title screen as playable completion.

**Architecture:** Integrate completed, reviewed module contracts into shared engine/application files in one checkout. Keep original semantics distinct from native host adaptation.

**Tech Stack:** C11/C++17/Objective-C++, native ARM64 macOS, original x86 matching fixtures.

**Spec:** `../PROJECT-SPEC.md`

## Global Constraints

Read `../PROJECT-SPEC.md` and root `AGENTS.md`. Use GPT-6 Luna Max. Keep original executable/assets unchanged. Use original bytes to substantiate behavior; retain unsupported branches explicitly. No GUI while the Mac remains locked. Do not edit integrator-owned files.

## Review Focus

- Truncated/count-overflow resource inputs must fail before out-of-bounds reads or mutations.
- False dependency gates and subtype-2 reset must preserve original lifecycle behavior.
- Stale completion callbacks or failed host calls must not silently commit a transition.
- Raw-type normalization must preserve the distinction between typed body and dependency tail.
- Host boundary hooks must be enumerated; passing oracle fixtures must not imply full-game equivalence.

## Task: I05

**Status:** BLOCKED by I03, I04. This is a gated integration packet, not authorization to guess the missing interfaces.

**Files:** Integrator owns `src/blackmoor_app.mm`, `src/scene_executor.[ch]`, `src/scene_resource.[ch]`, `src/scene_conditions.[ch]`, `src/macos_platform.[h,mm]`, `src/macos_audio.[h,mm]`, central build scripts and combined integration tests. For packaging/matching use the existing verifier and matching-source files.

**Interfaces:** Consume the completed predecessor headers and their evidence/branch coverage. Recheck their actual signatures before producing a concrete integration patch; all packet dependency IDs must reconcile with the registry.

- [ ] Verify all prerequisite completion receipts and independently review contracts/evidence.
- [ ] Split this integration gate into per-scene/per-boundary testable child tasks with exact affected files and signatures from those receipts.
- [ ] Add failing end-to-end fixtures for the goal and all exposed state/input/error boundaries.
- [ ] Integrate one child task at a time, run its tests and obtain independent review.
- [ ] Run the complete native suite and relevant original oracles; refresh the corpus/evidence and signed package when changed.
- [ ] Demonstrate the goal's actual user behavior and retain explicit unsupported coverage. Close the gate only after every child task passes.

**Acceptance:** The goal is demonstrated in the actual integrated app/whole-file verifier as applicable, with all prerequisites and child tests passing. A diagnostic subset cannot close this gate.

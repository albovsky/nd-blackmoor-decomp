# Claude next task: S05-2 caption and framed-box lifecycle

Continue as Claude, as the owner requested. Your S05-1 text writer is committed as `db638f3f1ca2347f7e286969fd0ba24f0b0e82e0`. Its handoff explicitly leaves S05-2 open; this task completes the surrounding lifecycle before the queued S03 AVF work.

## Immediate prerequisite

Fix the three independent S05-1 findings in [CLAUDE-S05-1-REVIEW-FIXES.md](CLAUDE-S05-1-REVIEW-FIXES.md) and obtain narrow re-review first. Use that corrected writer commit as this child's baseline; `db638f3` alone is not yet accepted.

## Objective

Replace the remaining caption/framed-box lifecycle stubs with original-derived state and typed presentation/input commands. This is needed to connect A-51 and sound captions to the real persistent scene runtime. Do not rewrite the completed text writer.

## Checkout and ownership

Create a separate worktree from `db638f3f1ca2347f7e286969fd0ba24f0b0e82e0`; check claims and write an S05-2 JSON claim. Read AGENTS.md, PROJECT-SPEC.md, your S05.handoff.json/S05.recovery.md, A-51.handoff.json, and tasks/S05-2-framed-text-box-lifecycle.md. Root collects and verifies; Boot exclusively owns shared integration files.

Own only new src/caption_lifecycle.[ch], scripts/build_caption_lifecycle.sh, tests/test_caption_lifecycle.py, tests/caption_lifecycle_original_oracle.py, the S05-2 child packet, and private work/analysis/slices/S05-2.* evidence. Prefix source/test/script/packet paths with outputs/blackmoor-decomp. Treat caption_layout.[ch], action_family_51, app/executor/parser/audio/platform files as read-only. Deliver their wiring proposal separately. Do not merge main.

## Required recovery and implementation

1. Recover frame-box object 0x61f864 open 0x4de24f, close 0x4de2d8, per-frame poll 0x4de4f9/0x4ee6c7 and scrolling 0x4de440. Preserve +0x991 mode and source-order writes to 0x5b15d6, 0x5d17f5, 0x5a161f and the writer's shared flags. Trace the actual input/control that makes 0x4ee6c7 return zero; do not invent an any-click dismissal.
2. Recover caption presentation 0x4e1157 -> 0x4c5377, source/destination rectangles and scroll offsets, main-loop flags 0x5d1889/0x5d18d3, two-frame clear 0x42ae0a/counter 0x5b160a, sibling 0x42ad90 and timed dismiss 0x4ea361 (armed at 0x4e93b1/0x4eb5b3). Expose precise state and bounded blit/input/timer commands for the native integrator.
3. Inventory remaining 0x448d11 callers, especially sound-caption 0x41c7f4, their measure/mode behavior, text ownership and fallback markup. Use the existing layout/font/pixel module and real installed BOOT/font/text data.
4. Keep A-51 and CaptionGlobals on one authoritative shared-state contract. Preserve the actual owners of clear/dismiss/completion. A-51 wait-mode 0 has no handler completion path for 58 shipped records; never manufacture a timeout or set done merely because the box closed.
5. Preserve observable state writes in source order, including partial host effects/failures. Missing host behavior must be explicit unsupported/error; do not report a successful presentation without pixels or a source-backed command.

## Acceptance

- Compare original/native open, close, poll, scrolling, clear-counter and timed-dismiss state/call order using unchanged original x86 code. Cover modal/denied input, repeated open/close, stale events, timer wrap, host failures and bounds.
- Exercise S0 NSHT01 and S5900 action 11 CURL00="<n>" using actual assets. Demonstrate frame opening with zero glyphs, continued wait-mode-0 behavior, and dismissal through its recovered owner.
- Provide offscreen composition fixtures for caption/frame surfaces using recovered geometry; keep DirectDraw/window adaptation and unverified UI branches explicit.
- Pin executable/code-window/native/source/test hashes, enumerate oracle hooks and intentional safety divergences, obtain independent review, fix findings, and commit owned files.
- Return commit hash, S05-2 handoff/validation receipts, public signatures and the shared-runtime wiring proposal. Close parent S05 only when both children meet their acceptance conditions.

The Mac remains locked: no GUI or hardware audio. Use original-x86 oracles and offscreen tests. Original GOG files remain immutable. S03 AVF follows this lifecycle child; do not start an overlapping S03 claim now.

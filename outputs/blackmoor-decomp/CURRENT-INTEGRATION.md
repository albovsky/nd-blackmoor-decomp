# Current integration evidence

Code snapshot: branch `claude/hungry-matsumoto-8ab8eb` at `e495947` (PR 8). Full suite: 899 tests, 894 pass, 5 skips, run with `work/tools/oracle-python/bin/python` after building the per-module libraries (`scripts/build_*.sh`; three matching builders need a GAME.EXE path argument). Original GAME.EXE hash unchanged. No GUI or listening check was done.

Collected and independently reviewed (findings fixed): live audio provider (`live_audio`, with mono-to-stereo duplication, deterministic offline completion, host-play-failure tolerance); 0x62 and 0x51 session bindings with the per-type pre-gate hook and accept-candidate model; dependency opcodes 11, 12, 13, 14, 15, 17, 20, 21 inside the executor tree reduction (whole-tree original oracle, 3,182 cases); scene exit handler (states 4/1/2) with the queued 0x28 effect and the caption/latch clears; 0x9f completion requests the scene change; original pointer producer module (not yet wired).

Live scripted run: S0 -> S5900 -> S5907 -> S5901 -> S5902 -> S5903 -> S5904 -> S5905 -> S5906, then S4700 (loads, ticks, `scene_transition_applied`); the session blocks at `action-kernel row 3 type=0x35` because the 0x35 runtime handler (A-35.2) is not implemented. A-35.1, A-38.1 and A-3F.1 register body boundaries only.

Known gaps (see each slice's `RT-*.handoff.json` in `work/analysis/slices/` for the full lists): provisional pointer feed in the app until RT-6; whether the original keeps sounds across continuation transitions; opcode-20 CRT seed parity; 0x28 nested state-3 tick and bit-exact x87 curve; effect types 1 and 3; frame text box close order versus original; ClearSceneData's ~74 subsystem resets; control_word / looping; original attenuation curve.

Whole-file x86 matching is tracked by other threads (Track M) and is unchanged by this work.

RT-6 (pointer producer in the live session): independently reviewed, no P1. Open: `priority_clear=1` is not proven near viewport edges. The original 0x4f0059 runs a scroll-arrow cascade (0x4f18fa..0x4f1db8, gated by `[0x5a4c1c]` which scene entry sets to 1 at 0x438d0c) that can return before the generic scan when the pointer is within about 0x2d px of an edge; `[0x5bb2ca]/[0x5bb2cc]/[0x5bb2b6]` defaults, `[0x5a4c1c]`, `[0x5b0260/0262]` and the UI flags `[0x5b51f6]`, `[0x5b51c6]`, `[0x5b51ab]` are unrecovered. Hover-driven gestures near edges (including the S5900 row 7 corner gesture) are therefore unverified. Item-use feedback calls 0x4eb107/0x4eb184 are not modelled.

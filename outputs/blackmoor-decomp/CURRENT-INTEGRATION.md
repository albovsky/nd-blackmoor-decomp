# Current integration evidence

Code snapshot: branch `claude/hungry-matsumoto-8ab8eb` at `e495947` (PR 8). Full suite: 736 tests, 731 pass, 5 skips, run with `work/tools/oracle-python/bin/python` after building the per-module libraries (`scripts/build_*.sh`; three matching builders need a GAME.EXE path argument). Original GAME.EXE hash unchanged. No GUI or listening check was done.

Collected and independently reviewed (findings fixed): live audio provider (`live_audio`, with mono-to-stereo duplication, deterministic offline completion, host-play-failure tolerance); 0x62 and 0x51 session bindings with the per-type pre-gate hook and accept-candidate model; dependency opcodes 11, 12, 13, 14, 15, 17, 20, 21 inside the executor tree reduction (whole-tree original oracle, 3,182 cases); scene exit handler (states 4/1/2) with the queued 0x28 effect and the caption/latch clears; 0x9f completion requests the scene change; original pointer producer module (not yet wired).

Live scripted run: S0 -> S5900 -> S5907 -> S5901 -> S5902 -> S5903 -> S5904 -> S5905 -> S5906, then `scene_transition_error ... S4700 ... type=0x35` (opaque, owned by the A-35.1 thread).

Known gaps (see each slice's `RT-*.handoff.json` in `work/analysis/slices/` for the full lists): provisional pointer feed in the app until RT-6; whether the original keeps sounds across continuation transitions; opcode-20 CRT seed parity; 0x28 nested state-3 tick and bit-exact x87 curve; effect types 1 and 3; frame text box close order versus original; ClearSceneData's ~74 subsystem resets; control_word / looping; original attenuation curve.

Whole-file x86 matching is tracked by other threads (Track M) and is unchanged by this work.

# NATIVE-01: turning-puzzle audio in the native app

Authorization: the human request in this Codex chat on 2026-10-24 authorizes build and real-data GUI/audio checks, one playability slice per PR, latest main integration, tests, independent diff review and merge. Publication owner: this chat only. Worker prepares code and evidence; it must not publish. Original game files and GAME.EXE are read-only. Ledger/evidence, tests/fl40_*, tasks/flNN-handoff.md are reserved to two other agents and excluded.

Baseline: origin/main b4cbef996687275edeb758ae7a8af751e4e7ff9e; merged into codex/native-playability before implementation. The native app compiles all current bindings, reaches S2010 through 24 scenes and S2008 with the real S2010 row-5 hotspot. Title menu captured; CUA coordinate input fails noWindowsAvailable despite owner-confirmed unlocked desktop. Baseline audio and movies verified offline only.

Problem: native_ad1_sound_prepare/stop/play/busy in blackmoor_app.mm return success with no sound. The 0xd1 Turning Puzzle relies on these calls to pace tile turns and win completion. Connect this family to live_audio through a bounded descriptor adapter; preserve kernel decisions and other families' behavior.

Ownership: worker owns new puzzle_sound.[ch], build_puzzle_sound.sh and test_puzzle_sound.py (and new drivers); integrator owns app/build integration, a new app-glue test, this packet and PLAYABILITY-LOG.md. Independent reviewer is read-only against the frozen slice commit. No ledger, evidence-generator or status-document edits.

Acceptance:
1. Descriptor conversion has tests for valid values, independent gains/categories, channels, bounds/unsupported inputs, no-resource, errors and stop/play/busy semantics. Prove the baseline regression before the app change.
2. The real app D1 callbacks load/decode original CDSound assets, start output or offline playback, report true busy state, stop/unload on cleanup, propagate failures. Missing resources must not accidentally play a previous clip or fail as an unloaded play.
3. Run a real D1 corpus scene through the binding and native audio callbacks offline; show nonzero PCM and completion gating. Test native callback integration and re-run the existing D1 unit/corpus/oracle checks.
4. Build normal and test-hook ARM64 bundles. Run meaningful combined startup/movie/scene checks and the full canonical suite before merge (report unrelated failures by name).
5. Record original GAME.EXE and native hashes, exact commands, review result and unverified branches. Keep full resource payloads and screenshots local in work/. The whole game remains incomplete; do not alter coverage claims.

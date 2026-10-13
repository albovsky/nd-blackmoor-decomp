# Blackmoor reconstruction

Owner objective: reconstruct the original game as buildable source, prove a whole-file x86 matching rebuild, and deliver a playable native ARM64 macOS game. A static preview, diagnostic run or passing helper tests does not satisfy that objective.

Use GPT-6 Luna at Max for workers (`gpt-6-luna`, `max`); never dispatch GPT-5.6 Luna. Parallel agents are authorized for independent slices. The integrator owns shared parser/dispatcher/app files. Each worker reads its packet under `outputs/blackmoor-decomp/tasks/` and obeys the ownership map in `WORK-SLICES.md`.

Read `outputs/blackmoor-decomp/PROJECT-SPEC.md` before implementing. Read `outputs/blackmoor-decomp/status.json` for current coverage. For original-code recovery, read the local REA skill at `work/tools/rea/node_modules/rea-agents/skills/reverse-engineer-anything/SKILL.md`; use REA/Ghidra evidence plus immutable original bytes, and distinguish pseudocode from reconstructed source.

The legally owned game is recorded in `work/analysis/game-source.json`; leave it unchanged. Do not use ScummVM, Wine or a VM as the game implementation. Isolated original-x86 oracle tests are allowed. Native platform/codec adapters are allowed; Game Porting Toolkit may be used if needed, but it is not a substitute for source reconstruction. The owner has no VC6 installer: do not ask again.

All current verification is automated. The Mac was locked; do not run computer-use or visual checks until the owner explicitly says it is unlocked. Offline audio checks use no output device.

Put scratch/evidence in `work/`; user-facing source, reports, builds and plans in `outputs/blackmoor-decomp/`. Do not publish proprietary executable/resource bytes or generated resource dumps. Keep large tool results on disk and print only bounded summaries.

Slice completion requires the packet's exact acceptance checks, pinned executable/code/native hashes, an independent review, and an explicit list of unverified branches. The integrator reruns meaningful combined checks before updating completion status. Do not mark the complete game done until both native gameplay and whole-file x86 matching pass.

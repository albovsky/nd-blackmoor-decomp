# Blackmoor reconstruction

Owner objective: reconstruct the original game as buildable source, prove a whole-file x86 matching rebuild, and deliver a playable native ARM64 macOS game. A static preview, diagnostic run or passing helper tests does not satisfy that objective.

Claude Code is root. The root session (Claude Opus) plans, writes packets, assigns slices, runs or arranges independent review, collects reviewed commits onto `main` and keeps the status documents honest. Implementation is delegated:

- Claude Sonnet at high effort, through the `slice-implementer` subagent in `.claude/agents/`, in its own git worktree.
- Codex as an additional worker, always `gpt-6.1-sol` at `xhigh` (`codex exec -m gpt-6.1-sol -c model_reasoning_effort=xhigh`). Never dispatch a Luna model.
- Independent review uses the `slice-reviewer` subagent against a frozen commit; root accepts or rejects its findings before collection. A reviewer never reviews its own implementation.

Parallel agents are authorized for independent slices. One designated integration owner edits shared parser/dispatcher/app files at a time, under root coordination; root may take that role itself. Each worker reads its packet under `outputs/blackmoor-decomp/tasks/` and obeys the ownership map in `WORK-SLICES.md`.

Read `outputs/blackmoor-decomp/PROJECT-SPEC.md` before implementing. Read `outputs/blackmoor-decomp/status.json` for current coverage. For original-code recovery, read the local REA skill at `work/tools/rea/node_modules/rea-agents/skills/reverse-engineer-anything/SKILL.md`; use REA/Ghidra evidence plus immutable original bytes, and distinguish pseudocode from reconstructed source.

The legally owned game is recorded in `work/analysis/game-source.json`; leave it unchanged. Do not use ScummVM, Wine or a VM as the game implementation. Isolated original-x86 oracle tests are allowed. Native platform/codec adapters are allowed; Game Porting Toolkit may be used if needed, but it is not a substitute for source reconstruction. The owner has no VC6 installer: do not ask again.

All current verification is automated. The Mac was locked; do not run computer-use or visual checks until the owner explicitly says it is unlocked. Offline audio checks use no output device.

Put scratch/evidence in `work/`; user-facing source, reports, builds and plans in `outputs/blackmoor-decomp/`. Do not publish proprietary executable/resource bytes or generated resource dumps. Keep large tool results on disk and print only bounded summaries.

Track M production method (owner ruling, 2026-10-14; evidence in `outputs/blackmoor-decomp/M0-binary-census-report.md`). Original x86 functions may be reconstructed as tool-assisted assembly: the project-owned generator (packet M03) emits Intel-syntax GNU assembly for one function from the owner's local original, an implementer annotates it (function and label names, frame and field symbols, the Track N source it corresponds to, unverified branches), and an independent reviewer confirms that the annotated source reassembles byte-exactly with the pinned `i686-w64-mingw32-as` 2.43.1 before the function counts. Such functions carry the class `tool_assisted_reconstructed_assembly`, reported separately from `explicit_reconstructed_assembly_source`; neither class claims original C++ or compiler provenance. Permitted encodings are mnemonics plus the `{load}`/`{store}` and `{disp8}`/`{disp32}` prefixes, the `.d8`/`.d32` branch suffixes, and `.insn` only for the four residual encoding classes listed in the M0 report. Machine-byte arrays, `incbin`, patching the original, and committing original code, data or resource bytes remain forbidden; the image composer (packet M02) may reference not-yet-reconstructed ranges from the local original at build time and must report them as referenced, never as matched. CRT, MFC and Vorbis code is reconstructed the same way and tracked as its own class.

Slice completion requires the packet's exact acceptance checks, pinned executable/code/native hashes, an independent review, and an explicit list of unverified branches. The integrator reruns meaningful combined checks before updating completion status. Do not mark the complete game done until both native gameplay and whole-file x86 matching pass.

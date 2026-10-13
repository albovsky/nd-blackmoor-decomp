# S04-2: Mode-1 audio and stream lifecycle

**Status:** OPEN. Parent S04 remains open.

**Goal:** Recover original type-0x9f playback-mode branches and how loaded HIS resources signal playing, completion, restart, and unload across scene ticks. Preserve the distinction between the scene action's mode and the DirectSound channel's raw control/flags.

**Starting evidence:** `outputs/blackmoor-decomp/action-sound-recovery.md`; `outputs/blackmoor-decomp/tasks/S04-1-sound-control.md`; private `work/analysis/slices/S04-1-original-oracle.json` records 85 mode-1 commands, including 84 control-1 and one control-0 command. Existing type-0x9f action behavior fast-advances its mode-1 phase-1 branch, but this is not proof of the actual HIS streaming lifecycle.

**Scope:** Trace original mode/load branches, DirectSound or HIS stream status, state transitions after completion, and unload/restart effects for corpus-backed mode-1 cases. Use pinned executable bytes and isolated original-x86 oracle execution. No real output device or GUI.

**Acceptance:** Hash each relevant source window; execute representative mode-1/control combinations and false/true completion gates against original x86; add native fixtures that compare state transitions and callback order; enumerate hooks and untested variants; deliver an integration proposal. Do not infer completion from elapsed time or treat raw control 0 as an infinite loop.

**Files:** New child module/tests/evidence only; parser, dispatcher, `action_sound`, and platform audio files remain integrator-owned.

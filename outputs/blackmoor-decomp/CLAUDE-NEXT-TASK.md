# Claude next task: S05 caption and framed-text rendering

Continue as Claude, as the owner explicitly requested. Root orchestrates; the integration worker exclusively owns shared parser/executor/app/build files.

A-51 commit 8e90977 is the foundation. Create a separate S05 worktree from that commit, check claims, and write an S05 JSON claim. Read AGENTS.md, PROJECT-SPEC.md, tasks/S05-caption-layout.md, A-51.handoff.json, A-51.parser-registration.md and A-51.dispatcher-registration.md.

Implement the actual caption and framed-text backends currently stubbed by A-51. Recover original font data/metrics, byte encoding, <h>/<n>/<o>/<e> markup, line wrapping, BOOT/window geometry, rendering state flags and framed-box lifecycle from immutable original code/assets. Implement original-derived layout and bounded native pixel rendering, with typed adapters for unreplaced platform boundaries. Do not substitute generic macOS text layout or invent completion behaviour.

Starting original anchors: caption/measure 0x448d11 on object 0x619a05 with handle *0x5d03b3; framed box open/close 0x4de24f / 0x4de2d8 on object 0x61f864. Trace the producers/consumers of 0x5b1602 and 0x5b1606. Preserve renderer flag writes already respected by the A-51 kernel. Validate the line-count branch (>2 selects framed rendering) using original metrics, not a guessed width.

Own only new src/caption_layout.[ch] (native .mm if necessary), tests/test_caption_layout.py, tests/caption_layout_original_oracle.py, scripts/build_caption_layout.sh, numbered S05 child packets if the two renderers need separate work, and S05 evidence. Put evidence in work/analysis/slices; source/tests/build under outputs/blackmoor-decomp. Shared engine and other workers' modules remain read-only. Deliver integration proposals separately; never merge into main yourself.

Acceptance: actual S0 NSHT01 and S5900 CURL00 captions plus representative shipped markup/font/framed-text cases produce source-backed layout commands/pixels. Compare original code against native for each recovered branch; test embedded NUL, missing font, malformed/truncated markup, bounds, renderer flag side effects and failures before mutation. Enumerate all oracle hooks and platform adaptations. Keep absent behaviour explicitly unsupported. Obtain independent review, fix findings and commit owned files with hashes, comparison counts and unresolved items.

Do not auto-complete A-51 wait-mode0: its handler has no completion path for 58 shipped records, including S5900 action11. Find the actual owner of dismissal/clearing rather than manufacturing a timer or click contract. No GUI/hardware audio while the Mac remains locked; use original-x86 fixtures and offscreen pixel tests.

Return the commit hash and S05 handoff receipt through the owner's existing Claude/Codex relay. S03 AVF remains queued after S05; the progress-map worker and other engine workers continue separately.

# Full original-engine reconstruction

The active objective is a fully reconstructed, compiled game that runs natively
on the owner's Apple Silicon Mac. The supplied original Windows executable is
the reference. ScummVM, Wine and a replacement interpreter are not the delivered
engine. Isolated emulation of original functions is permitted as a test oracle.

Two required tracks remain distinct: the original x86 byte-matching rebuild and
the native ARM64 engine with macOS platform adapters. A working resource utility,
static pseudocode, a menu preview or passing helper tests do not complete either
track. The goal remains active until the complete game is runnable and verified.

## Evidence required for completion

| Requirement | Required evidence | Current state |
| --- | --- | --- |
| Preserve supplied game | Original executable and asset hashes; no original modifications | Original executable hash retained |
| Recover original source | Buildable engine source, types, classes, globals, state transitions and algorithms with original-code provenance | Archive/container, startup/menu, selected condition/action handlers recovered; 10,501 actions remain opaque |
| Byte-matching x86 rebuild | Reproducible compiler/link command and whole-original-executable comparison | Only two selected ranges, 14 bytes matched |
| Native ARM64 game | Complete ARM64 app compiled from recovered engine source; no compatibility runtime | Incomplete startup/scene-preview app compiled |
| Native platform support | Verified window, display, input, audio, video, timing and file/save adapters | Window/input/timing/resource integration; first-frame Bink and HIS codec adapters; offline audio graph verified; game audio and saves absent |
| Authentic startup | Original boot records drive initialization, logo flow and main-menu behavior | Logo/menu kernel integrated; silent host; latest visual inspection pending |
| Complete gameplay | Every required scene/action subsystem implemented; original assets, interactions, puzzles, dialogue and endings work | Not implemented |
| Persistence | Save/load, continue and second-chance state behave consistently with original | Not implemented |
| Runnable on owner's Mac | Built app launches on the actual machine; observed gameplay and regression evidence | Not achieved |

## Ordered engine work

1. Recover and validate archive resource loading. Completed for the supplied
   archive and standalone CIF payloads; see the original-decoder validation.
2. Recover `CHiff` DATA/chunk indexing, duplicate-chunk iteration and boot record
   access. Completed for the current archive corpus and tested selection paths;
   BOOT/image modules and patched-resource precedence are compiled and checked.
3. Recover boot initialization and its exact record layouts; recover original
   image/video/audio transforms and surface operations. These are prerequisites
   for faithful startup and scene rendering. Pixel conversion and a native
   framebuffer/input adapter are verified. Startup/menu render plans and a
   first-frame Bink port adapter are integrated; full audio/video, cursor and
   scene surface composition remain.
4. Recover state dispatch and scene/action construction. Integrate original
   scene loading, conditions, transitions, dialogue and puzzle logic.
5. Replace platform API boundaries with macOS implementations while preserving
   recovered engine semantics. Build and observe the actual startup flow.
6. Complete every remaining action family and media path. Validate original
   state transitions, save/load and both difficulty modes through gameplay.
7. Finish whole-file x86 matching and final native gameplay/packaging audits.

Current goal turn classification: **progress**; current S0 integration slice is complete.
The latest combined suite ran 216 tests: 214 passed and two filesystem skips.
The headless app now uses selected recovered BOOT inputs, real AUTOTEXT captions,
real offline voice completion and original-derived hotspot activation to request
S5900, then loads its first frame. Peer review caught and fixed dependency-bearing
raw-0x15 classification; bounded original comparisons and regression tests pass.
The GUI is still a static preview. S5900 starts with opaque type0x64 and also
contains unrecovered types0x62,0x28,0x51. Live scene execution, timed media,
remaining action families, save/load and whole-file matching are still required.
See WORK-SLICES.md and tasks/ for file ownership, parallel entry points and gates.

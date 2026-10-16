# Blackmoor reconstruction handoff

Permanent project: `/Users/albovsky/Projects/nd-blackmoor-decomp`.

The completed slice is **S0 BOOT, captions, sound actions, hotspot input and delayed scene integration**. The signed native ARM64 app's automated fixture reads the original resources, initializes selected recovered state, consumes the actual NSHT01 caption and voice clip, selects a challenge hotspot, requests S5900 from the original ACT data and loads OPEN_A's first frame.

## Verified in this slice

- Full native suite: 216 tests ran, 214 passed and two filesystem-specific case-distinct filename fixtures were skipped.
- BOOT startup fields: scene0, two zero opaque coordinate words, initial 18:00 clock; 12 source phone records exposed through bounded getters. Native phone copy/sort matches all 492 bytes of the original 0x4e2e05 selected initializer path.
- AUTOTEXT: 1,257 CVTX records; original insert/lookup proves ASCII case folding, first duplicate match, real NSHT01 lookup and missing-caption fallback. Five native parser tests pass.
- Sound 0x9f: portable lifecycle/typed backend kernel; 16 tests pass. Original S0 phases `(1,0),(1,0),(2,0),(0,1)` and selected command boundaries match. Native fixture renders the real 494,792-frame voice clip silently to authoritative DataRendered completion, with original-derived selected attenuation −1035 mB. Original decode/hardware equivalence is not implied.
- Hotspots: original WM_LBUTTONUP release mapping, frame/dependency guards, 0x6a flag hotspots and raw0x15→runtime0x0d scene hotspot; 23 native tests pass and 13 original comparisons have zero mismatches. Peer review found and fixed dependency-bearing raw0x15 classification. Failed callback transitions remain uncommitted.
- Headless app: six integration tests pass, including missing voice failure. Real S0 → S5900 transition and first target background are verified from a clean signed archive. Signature and executable hashes are recorded in `native-package-validation.json` and `scene-runtime-integration-validation.json`.

## Existing reconstructed components

The project already includes compiled CIF archive decompression/dictionary handling, HIFF record access, pixel formats, BOOT/image loading and patch precedence, native window/input/framebuffer adapters, recovered startup menu selection, scene metadata and dependency parsing, supported nested condition reduction, core flag/value/difficulty effects, phone/control actions, HIS decoding, tested float-to-PCM conversion and a native offline/output audio adapter. The original asset analyses and Ghidra/REA evidence are retained under `work/`.

## Still unfinished

The GUI remains a static menu/scene preview. The new action/sound/caption/hotspot execution is a headless diagnostic, not the live game loop. Complete world initialization, caption rendering, timed Bink and AVF, remaining action/dependency families, complete sound controls, original codec equivalence, dialogue, inventory, puzzles, UI/settings, saves and full campaign verification remain.

S5900's first action is opaque raw0x64; that scene also contains opaque0x62,0x28,0x51. The current census covers 2,078 scenes and 19,612 actions: 9,111 have typed body boundaries and 10,501 remain opaque. Typed metadata does not imply runtime implementation.

Only **14 bytes in two isolated ranges** match the original x86 executable today. The whole executable has not been rebuilt or matched. Both full matching and playable native ARM64 behavior remain completion requirements.

## Picking up work

Read `PROJECT-SPEC.md`, root `AGENTS.md`, then `WORK-SLICES.md` and the chosen `tasks/` packet. `slice-registry.json` lists all75 packets and dependencies. Suggested first wave: A-64, A-62, S01 and S02; A-28/A-51 and sound/captions can proceed independently as more workers become available. Workers are Claude Sonnet (high) `slice-implementer` subagents or Codex `gpt-6.1-sol` (xhigh), coordinated by the Claude Code root (see root `AGENTS.md`). A local Git baseline is available for independent worker checkouts. Private `work/` evidence/tools are retained in the canonical project and excluded from Git; link them into each worker checkout as needed. No new agents were launched for the handoff; packets are ready for another agent/chat.

Workers own separate new modules, tests and evidence. One integrator owns shared parser, dispatcher, app/platform and central build changes. Each packet includes evidence, bounds/failure checks, review and acceptance gates. Complex families must split into numbered branch packets before implementation; no parent closes with silent unsupported paths.

## Reproduce checks

From the permanent project root:

```bash
outputs/blackmoor-decomp/scripts/build_native_app.sh
script/run_test_suite.sh   # canonical: rebuilds all ignored artifacts, then runs the full suite with the oracle interpreter (BLACKMOOR_REQUIRE_ORACLE=1; add -v, or --no-build to skip the rebuild)
# direct equivalent (after script/build_all_native_checks.sh):
BLACKMOOR_REQUIRE_ORACLE=1 work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'
work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/phone_init_original_oracle.py
work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/hotspot_original_oracle.py
```

Isolated Unicorn JIT and offline AVAudioEngine registration need scoped execution outside the restricted agent sandbox. They open no window or output audio device. `--inspect-scene-runtime` runs the new headless fixture; `script/build_and_run.sh` launches the still-incomplete GUI preview. Do not use its GUI launch until the owner explicitly unlocks the Mac.

Builds use the current macOS27/Xcode27 and external Homebrew FFmpeg dependencies. The app is not yet a self-contained release for other Macs. The original GOG app/files are untouched. Private evidence/tools and existing prototypes are preserved in the permanent project; no legacy prototype is used by the native reconstruction.

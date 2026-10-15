# RT-8: raw action 0x97 (runtime type 0x9f) in the live session

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer; one independent `slice-reviewer` afterwards. Branch `codex/rt-8-a97-runtime` is stacked on `codex/rt-7-movie-runtime` (PR 15); keep that history, root merges RT-7 first.

## Where the live game stops

After RT-7 the scripted run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`, offline audio, no window) goes S0 -> S5900 -> S5907 -> S5901..S5906 -> S4700, initializes the S4700 row-3 movie, then stops at `scene_session_blocked provider=action-kernel action=11 type=0x97`. Rows 12-13 are also 0x97. 0x97 has 1,958 corpus records, so this is the highest-leverage runtime family left.

## What 0x97 is

A-97.1 (`src/action_family_97.[ch]`, `work/analysis/slices/A-97.1-discovery.md`, `A-97.1.handoff.json`) recovered the loader: body is n fixed 33-byte names plus 13 neutral bytes, n signed int16 selectors (-1 = AUTOTEXT key, >=0 inline text of that length), then a dependency tail. The constructor `0x410f99` builds a 172+text byte object whose slot type is normalised to **runtime 0x9f** (`0x40fcf3`); the raw type stays 0x97 in native views. Runtime dispatch is `0x427a50` (the 0x9f arm), helpers named by A-97.1 as children: A-97.2 lifecycle/runtime (`0x427a50`, `0x432d1a`, `0x42ba3a`), A-97.3 dependencies (`0x424aa8`, `0x423f57`, `0x423d33`), A-97.4 rendering/host effects (`0x432d1a`, `0x448d11`, `0x4faf98`, `0x4fba69`, `0x4fc62d`, `0x4f6334`), A-97.5 subtype behaviour. The session already binds runtime `0x9f` for the S5900 sound-style rows (`native_action_sound_handler` in `src/blackmoor_app.mm`, `src/action_sound.[ch]`), which is a **different layout**: first determine, from the original, exactly how the 0x9f arm of `0x427a50` treats an object built from raw 0x97 versus raw 0x9f, and whether the existing binding must be keyed by raw type or split. Do not assume they share a body.

## Outcome

Take the live run past S4700 rows 11-13 as far as recovered evidence honestly allows:

1. **Corpus check.** For all 1,958 raw-0x97 rows: subtype distribution, text kind (inline vs AUTOTEXT), dependency counts, and what the three S4700 rows select. Then recover the 0x9f arm of `0x427a50` for 0x97-built objects (phases, completion, global reads/writes, session-visible effects: text/caption, sound, clock, event flags, scene change) and `0x432d1a`/`0x42ba3a` as needed. Original-x86 oracle for the lifecycle with enumerated hooks, as the RT-7 and A-37.2 oracles do.
2. **Implement** `src/action_family_97_runtime.[ch]` and `src/session_bindings_a97.[ch]` following `session_bindings_a35.[ch]`, `session_bindings_a51.[ch]`, `session_bindings_a62.[ch]`. Reuse the caption/frame text box, AUTOTEXT lookup and sound providers already in the app (`session_a51`, `autotext`, `action_sound`) through typed host callbacks; a visit that needs an unbound callback reports UNSUPPORTED before any effect.
3. **Register** in `src/blackmoor_app.mm` (bindings array, minimal), `scripts/build_native_app.sh`; confirm `decomp-progress/playable.py` derives 0x97 as handled (`python3 outputs/blackmoor-decomp/decomp-progress/generate.py`).
4. **Drive the live run**, report the new stop row/provider with log lines. Every unproven step is an explicit named blocker; never default an unknown input to zero or skip a row silently.

## Ownership

You may edit: new `src/action_family_97_runtime.[ch]`, `src/session_bindings_a97.[ch]`, `scripts/build_action_family_97_runtime.sh`, new tests/oracle files; minimally `src/blackmoor_app.mm`, `src/scene_session.[ch]`, `src/scene_executor.[ch]` (only what evidence requires), `scripts/build_native_app.sh`, `tests/test_scene_session.py`, `tests/test_native_app.py`. Do not edit other families' kernels, `scene_resource.c` registrations, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-8.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance

- Failing tests first, baseline recorded; every provider cited to original addresses; unproven items listed.
- `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes (1,074 tests, 5 skips today); build clean under `-Wall -Wextra -Wpedantic -Werror`.
- Handoff `work/analysis/slices/RT-8.handoff.json` (commit, baseline, files, commands, results, hashes, unverified list, new live stop). Commit only owned files on your branch, no push; message ends `Co-Authored-By: Codex <noreply@openai.com>`, no model identifiers.

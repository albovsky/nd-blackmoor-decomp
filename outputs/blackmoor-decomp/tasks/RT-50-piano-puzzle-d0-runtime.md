# RT-50: raw 0xd0 Piano Puzzle runtime

Owner thread: Claude Sonnet (cloud). Follows RT-49 (PR 113). Ranking from `scene-action-coverage.json` after PR 113 (0xf6 is RT-47's): eight families unblock two scenes each (0x1c, 0xd0, 0xd3, 0xe0, 0xe4, 0xeb, 0xf5 and 0xf6 at three). Size tie-break (callee closure of the dispatcher arm, common engine helpers excluded): 0xd0 is the smallest left, one object with seven methods (the handler `0x48d914` 1,439 bytes plus six short methods, about 2,400 bytes in all), then 0x1c, then the rest at 5,000+ bytes. Raw 0xd0 is the "Piano Puzzle": up to 15 keys, each plays a sound and shows a text, the last L keys played are compared with the solution.

The contract is `src/action_family_d0_runtime.h` (written first; kernel `src/action_family_d0_runtime.c`, binding, app glue, tests and oracle all follow it; the header comment lists the original addresses and the typed body layout). The shape is the 0xd1 family (`action_family_d1_runtime.[ch]`, `session_bindings_ad1.[ch]`, `tests/action_family_d1_*`) combined with the RT-49 test and oracle layout (`tests/action_family_77_runtime_*`). GAME.EXE SHA-256 afd337a2...5c45; private evidence is `work/original/GAME.EXE` (extracted from `/mnt/project-files/private-inputs/work-private.tar.gz`); disassembly helper `work/rt50/pe.py` (`python3 pe.py <hex va> <len>`).

## The original (verified in the disassembly)

The object `CPianoPuzzle` is the static singleton at 0x61d345 (0x5c bytes, thiscall ECX = 0x61d345). Methods, all plain functions callable under Unicorn:

| address | role | calling convention |
|---|---|---|
| `0x48d914` | handler, called by dispatcher arm `0x42a0ea` after gate `0x423f57` mode 0 | thiscall, `ret 4`, one word argument (row) |
| `0x48d1e8` | pointer hit test, called at `0x4f0acf` in the cascade `0x4f0059` (x = [event+0x5e], y = [event+0x5a]; pushes y then x) | thiscall, `ret 8`, args (x, y) as words |
| `0x48d3cb` | cursor / candidate writer (inner, called by 0x48d1e8) | thiscall, `ret 8` |
| `0x48d5f4` | click method, called at `0x43b273` on the accepted-release chain, no arguments | thiscall, plain `ret` |
| `0x48d89e` | solved check, called by the handler (state 1) and by the render callback | thiscall |
| `0x48ded7` | render callback of the dynamic generic Z entry (type 10), called by the engine | cdecl, no arguments |
| `0x48d0e5` | slot invalidate, called at `0x43d910` (entry +0x14 := 1 when active and slot != -1) | thiscall |
| `0x48d09c` + `0x48d067` | cleanup (releases surface and slot, then resets), called at `0x438b5d` and `0x43de52` and by the handler after phase 2 | thiscall |
| `0x48d12d` | loader (already decoded by `src/action_family_d0.[ch]`) | |

`0x48d119` (called at `0x438444`) only stores word `[0x594daf] := 0`; nothing reads that cell, so it is not modelled.

Object fields (offsets from 0x61d345): +0x1c slot word, +0x1e row word, +0x20 surface dword, +0x24 dirty byte, +0x25 check byte, +0x26 pressed byte, +0x27 hover word, +0x29 last word, +0x2b state dword (0..4), +0x2f has-surface dword, +0x33 active dword, +0x37 exit byte, +0x38 solved byte, +0x39 deadline dword, +0x3d order words (15, the last L keys).

Engine hooks used by the code (all outside this slice; replace them in the oracle and implement them in the native host, in the original order):

* `0x4e8d96` (ECX 0x571442) clear pending item; `0x4d39f9` alloc generic Z slot (returns word in AX, 0x18..0x3f); `0x4c2790` load image (thiscall ECX 0x5cf659, `ret 0x10`: "CIFTREE", name, 6, "Piano Puzzle Surface"); `0x4c2dfb` release (thiscall ret 4, zeroes the cell); `0x4d3992` release slot (cdecl, one word; entry flags +0x14 and +0x18 := 0); `0x4fb77a` / `0x4fba69` sound prepare / stop (ECX 0x5c3a67, ret 4, pointer to the 9+ byte record); `0x4fb2e3` play (ret 4, channel word); `0x4f6334` busy (ECX 0x5cf1eb, ret 4); `GetTickCount` ([0x52a23c]); `0x423259` text lookup (thiscall ECX 0x619a6b, `ret 4`, key string, returns pointer or NULL); `0x448d11` text show (thiscall ECX 0x619a05, `ret 0x10`, args [0x5d03b3], text buffer, -1, 0); `0x4c5377` blit (thiscall ECX 0x5cf659, `ret 0x14`, args: source surface, target [0x5cf665], source rect pointer, destination rect pointer, label); `0x42ba3a` generic completion (original code runs).
* The text buffer of the click method is a 216-byte stack buffer (`ebp-0xd8..ebp-1`) written with strlen+1 bytes and then the dword at `0x54e898` ("<e>\0") over the terminator; texts longer than 212 characters reach its saved ebp in the original (lengths 200..212 only overwrite dead locals and work). The native kernel refuses those (known divergence, `D0_ERR_BOUNDS`).
* Strings: label "PIANO PUZZLE OVERLAYS" at 0x54e89c, surface label "Piano Puzzle Surface" at 0x54e8b4, kind "CIFTREE" at 0x54e8cc, blit labels "Piano puzzle pSrcSurface" at 0x54e8e0 (pressed key) and "Piano Puzzle pSrcSurface" at 0x54e8fc (background restore), "NO SOUND\0" at 0x54e88c and 0x54e8d4. The empty-name test compares the first body byte with the byte at 0x63a8ac (0).
* Native-only refusals (the oracle must not run them against the original; test them natively): body validation (`d0_validate_body`: short body, name without NUL, N outside 0..15, L outside 1..15 because L == 0 makes the original store into the deadline, key sound/text key without NUL), phase 1/2 without phase 0 for the row, event flag index outside the host window in phase 2, hover outside 0..N-1 at a key press or render, text longer than 212 characters.

## Deliverables (one PR, all in `outputs/blackmoor-decomp`)

1. `src/action_family_d0_runtime.[ch]` (done), `src/session_bindings_ad0.[ch]` (copy the shape of `session_bindings_ad1.[ch]`: handler, begin_scene/clear, pointer_move, click, render), register in `scripts/build_native_app.sh`, `scripts/build_action_family_d0_runtime.sh`.
2. App glue in `src/blackmoor_app.mm`: next free binding slot (check main's declared count before the PR), mirror the 0xd1 and 0x77 glue (surface load, render of the blit into the back buffer, pointer, click through the accepted-release path, sound calls logged "NOT PLAYED", text through the app's text writer when available, otherwise logged). Not compiled in the cloud: syntax-check against stand-ins.
3. Tests: `tests/action_family_d0_runtime_test.c` + `tests/test_action_family_d0_runtime.py` (plain, sanitizers, source mutants); oracle `tests/action_family_d0_runtime_original_oracle.py` + native driver C (the real dispatcher `0x427a50` runs rows of raw 0xd0; the other methods run as original functions on the same process image). 0 mismatches; planted-mutant kill rate reported.
4. Handoff in `COORDINATION-STATUS.md` (same PR), regenerate `scene-action-coverage.json`, `function-evidence.json`, `function-ledger.json`.

# FL-21 batch a: handoff

Branch `worktree-agent-a9f2abdbee9057983` (worktree `.claude/worktrees/agent-a9f2abdbee9057983`), baseline `claude/fl21-large-ports-15bobb` at `12229e36`. Implementer: Claude Sonnet 5.5. Not yet independently reviewed.

## Ported (five of five, none dropped)

| Original | Native symbol | Direct test | Differential test | Oracle (window, bytes) |
|---|---|---|---|---|
| 0x4cb586 | `m4cb586_visit(self, int16 index, world, host)` | `test_m4cb586_visit` | `test_4cb586_visit` | `action_family_1c_runtime_original_oracle.py` 0x4cb586..0x4cb8d5, 847 |
| 0x42caa8 | `m42caa8_clip_rect(int16 index, clip, world, host)` | `test_m42caa8_clip_rect` | `test_42caa8_clip_rect` | `action_family_33_...` 0x42caa8..0x42cecd, 1061 |
| 0x462c39 | `m462c39_pointer_move(self, int16 x, int16 y, world, host)` returns 0/1 | `test_m462c39_pointer_move` | `test_462c39_pointer_move` | `action_family_d3_...` 0x462c39..0x4630a3, 1130 |
| 0x484f42 | `m484f42_pointer_move(self, x, y, rect, world, host)` returns 0/1 | `test_m484f42_pointer_move` | `test_484f42_pointer_move` | `action_family_ea_...` 0x484f42..0x4853b0, 1134 |
| 0x48d914 | `m48d914_step_scene(self, int16 index, world, host)` | `test_m48d914_step_scene` | `test_48d914_step_scene` | `action_family_d0_...` 0x48d914..0x48dec7, 1459 |

Files (all under `outputs/blackmoor-decomp/`): `src/original_methods_fl21a.c/.h`, `tests/fl21a_direct_test.c`, `tests/test_fl21a_direct.py`, `tests/fl21a_differential_shim.c`, `tests/test_fl21a_differential.py`, `tests/fl21a_sanitize_fuzz.c`, `tests/test_fl21a_sanitize.py`, `tests/fl21a_mutation_check.py`, `tasks/fl21a-acceptances.json`, this file. No shared file was edited. `Fl21aWorld` (in the header) is this batch's own world struct; host calls go through `Fl18Host`.

## Commands and results

- `python3 -m unittest tests.test_fl21a_direct tests.test_fl21a_differential` : 11 tests OK. Direct binary prints PASS for all five cases.
- `python3 -m unittest tests.test_fl21a_sanitize` : 2 tests OK. Direct cases and `fl21a_sanitize_fuzz.c` (3000 rounds over all five ports, exact-size malloc buffers, bounded indices) build with `-fsanitize=address,undefined -fno-sanitize-recover=all` and run clean. The test uses the default compiler and falls back to gcc when clang has no sanitizer runtime (the case on this container); it skips only when no runtime is found.
- `python3 tests/fl21a_mutation_check.py [out.json] [label substrings]` : 26 deliberate rule breaks, one at a time, source restored after each. Final result: all 26 are detected by the original-x86 differential suite; the hand-derived direct suite detects 25 (the exception, 4cb586 "state-1 stores after the 0x4c0c2c call", only shows when the callee reads the fields, which the differential probes do). Two initial escapes were fixed: the 48d914 nine-byte compare (differential fixtures now put a share of scenarios on v = 3 with the timer due, and put the single differing byte in the ninth position half the time) and the 42caa8 lower-edge `>=` (a direct case with an inverted clip was added).

Differential counts (300 scenarios each, every instruction of the original reached):

| Function | Instructions reached | Ordered host calls compared | Memory bytes compared | Globals compared | Fixture digest (sha256) |
|---|---|---|---|---|---|
| 0x4cb586 | 214/214 | 434 | 562800 | 300 | `6bca76af147b288c4a9cef12adf762408ce89bea315918ab140fff66fcf9824e` |
| 0x42caa8 | 240/240 | 106 | 211500 | 5400 | `04e876bacf7ccaa883bea930bfe9c7663d97f16741e3c78d402e82465a56a999` |
| 0x462c39 | 298/298 | 336 | 288300 | 600 | `518b715c78b5b96059ba9828bc3586cdcf5766b75a40abf1ca1bdd132f9917b8` |
| 0x484f42 | 301/301 | 284 | 2438700 | 0 | `bcfb9aff2ada3871ad104ca5c2c0554cc82dbfcc398976c7385ecc9e0a437212` |
| 0x48d914 | 338/338 | 380 | 467700 | 3000 | `0b3b86fe3529b56707dffd6a0cf21eacd859e08e85dd283143f868b55f978cee` |

For 0x48d914 the instruction set is the code before the switch table at 0x48deb3 (the table itself is data inside the window).

## Hashes

- GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified).
- Oracle code-window sha256 (equal to the ledger `window_sha256` in all five cases): 4cb586 `91e675c3a72629218d9b961ae84b177a59581568d0f19b4e52b8f4110288ab76`; 42caa8 `339940d243f4701dceb67cc550ba9f5966635ae23fca1ee2458a20bc4a14dd93`; 462c39 `f242443d2b87a491ff7710452b6ce103b86736cb167f4b658e55542a8d4040e1`; 484f42 `3ff2ddbbdc87a871d5cdce79ebaa3e75c65b35d79062294f7ba36c9f9252da5d`; 48d914 `c16eaa9635b6c5261282602575e07dc3c07f4970869c22bc78c89ab3d7dbd873`.
- Oracle files (sha256): 1c `4303e68708e68c7a453e9ee52e11a8db6ae04d94ae1cc8bc196e08ad4013956f`; 33 `967924b4522e0354626c11a84ad8d79155d2997d6e56af79d638e0873c5c36ba`; d3 `cc2c1c64459605779c02931802e80df11145e9eea7ee98c7e951ff01b40e5230`; ea `6666e2a23949c99ab4f35e0406bc4b15e4ba6799deb4511ecd0116e5f1af6f05`; d0 `c8943b1a24d58174ff98162a839744e219edb009bb3bbaffaf64ae965b39b356`.
- Source and tests (sha256 of the committed content): `src/original_methods_fl21a.c` `61b937e391aa98544fa0953746bed26855c586f0177d33ad890cf965be0aa74a`; `src/original_methods_fl21a.h` `b2d10d71ddd6d2595830d6335b4c6217c4b943af058173dbf2ce1c6b5a1f2d6f`; `tests/fl21a_differential_shim.c` `3733540e1a3e7fe4e674f7988c6257652b99675d390a5fba4eb070ada861cc7b`; `tests/test_fl21a_differential.py` `4d03d1e5d6e0ca9e763a7c1f0eb6fb5fe43908dccf6106bf411edf2f0ec17b5d`; `tests/fl21a_direct_test.c` `f6c0ce144c82893425a22d3f8676f46031e223f6ec10ea18b4ef365d44c042bb`; `tests/test_fl21a_direct.py` `ac4932bbd988f7ab37cb5a6486ed09eac0daceeb8bd54133d8243cf67c7c53e8`; `tests/fl21a_sanitize_fuzz.c` `9cd0c31d296755bd912723a16d1a3a5adeee09d4dee36d06ae7d5879be7ad4b0`; `tests/test_fl21a_sanitize.py` `25e6e4893a9a9f3bf3b3ce80eacc273c0023415eb78620364de1ff29a2e93db0`; `tests/fl21a_mutation_check.py` `b6cd54f4e6cb5fb65301a9259c2a21cbdaa5434219fa847bb81dd61de512fe1f`; `tasks/fl21a-acceptances.json` `288909213b41b464af30fe1a3d47e14b8a82936c0ddede72121a0fd508c5ca7a`.

## Hooks (the only stand-ins in the Unicorn runs)

Every callee is a stub that records its arguments and `this`, and writes scripted values through a pointer argument, as in FL-20. No decision of the original is replaced.
- 4cb586: 0x4cbba9 (thiscall, 1 arg), 0x4c0c2c, 0x4c0c18, 0x4c0c54 (thiscall on 0x637fcf), 0x4d39f9 (returns ax), 0x4cb944, 0x4cb9d1, 0x4caf8a, 0x42ba3a (cdecl, 1 arg).
- 42caa8: 0x42cecd (cdecl, 2 args).
- 462c39: 0x4619be and 0x4630a3 (thiscall, ret 4).
- 484f42: 0x484d87 (thiscall), 0x4854fb (thiscall, ret 4).
- 48d914: 0x4e8d96, 0x4d39f9, 0x4c2790 (thiscall, 4 args), 0x4fba69, 0x4fb77a, 0x4fb2e3, 0x4f6334, 0x48d89e, 0x48d09c, 0x42ba3a, and the IAT slot 0x52a23c (GetTickCount, an ordered event, native `host->tick`).

## Deliberate divergences and known limits

1. Word arguments whose upper half is a callee- or path-dependent leftover (0x42ba3a in 4cb586 and 48d914, 0x4fb2e3 in 48d914) are compared by their low 16 bits. In 42caa8 the dword for 0x42cecd is `(value_5b4e60 & 0xffff0000) | (uint16)index`: the upper half is a deterministic leftover of ecx and is reproduced and compared.
2. In 48d914 the `[self+0x20] != 0` skip of the 0x4c2790 call cannot be reached with a valid callee (the original clears the field first); it is implemented 1:1 and exercised only in the direct test, with a callee that writes the field.
3. No native rejection of the original's unsafe overruns was added: indices into the record, entry and cell tables are used as the original uses them. The sanitizer run therefore uses bounded inputs only; the callers must keep indices in range.
4. The tables are passed by pointer inside `Fl21aWorld`; the differential harness maps them to the original addresses and compares the whole areas. In 484f42 the record word +0x2b is written through the pointer returned by the resolve step, as in the original.
5. In the 48d914 fixtures the records area has no slack record: a slack record would overlap the globals at 0x5bb57b..0x5bb5a3 that the function writes. The sentinel values around the record table in the direct test cover the out-of-range side.
6. 0x48d914 jump table (five dwords at 0x48deb3) is data and is not part of the instruction coverage; the port uses the same unsigned compare with 4 and the same five arms.

## Unverified branches

None in the sense of unreached original instructions (all reached, see counts). Open points: the meaning of the receipt items A-1C.1 (dispatcher arm 0x427cc1 and the 105 bytes), A-33.1 (handler 0x42c221, siblings 0x42ca22 and 0x42d215, gate 0x423f57) and A-D0.1 (dispatcher arm 0x42a0ea, global object 0x61d345) stay with the callers; the acceptance snippets say so. The callees listed above are not ported by this batch.

## Integration

Root merges `tasks/fl21a-acceptances.json` into `port_acceptances` of `function-ledger-overrides.json` and regenerates the ledger. Add `src/original_methods_fl21a.c` to whatever build list names the FL-20 sources.

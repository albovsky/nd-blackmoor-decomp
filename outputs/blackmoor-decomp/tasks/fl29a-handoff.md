# FL-29 batch a (`fl29a`) handoff

Branch `fl29a` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a85c332806a229ea0`), based on `62c9934` (the FL-29 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl29a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 10 entries; none of the ten rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 30 test ids and accepts them).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (10 of 10, none dropped)

All in `src/original_methods_fl29a.c` / `.h` (symbols `m<va>_*`, world struct `Fl29aWorld`, host convention `Fl18Host` as in FL-18/26/27/28). Ports land in commit `f182039`; this handoff, the acceptances and the final notes are the commit after it. Addresses that the original passes or stores (surface, rectangle, descriptor, string, vtable, entry array) are 32-bit original addresses here too and go through `Fl18Host.resolve`; only `self` and the `Fl29aWorld` table pointers are host pointers.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4d39f9 | 89 | m4d39f9_find_free_entry | 28/28 | 4/4 | 87 | 89681306a0095c12c2beacbe890a83cffd84ded5f9234f50fc73c259b6b6b485 | 48d316b205db4a871706a7ceb32a0262cda3309557aa02e312f0690376e8fa0b |
| 0x4c4202 | 92 | m4c4202_check_vtable_call | 32/32 | 4/4 | 80 | f9bd56bd0e24cb07d75f20205a6e99095f97717893a4e86707fd036267ef9dff | 4759b7f595ea50378bb6643c9c222b560fece4f7b9c28c25fef32bd4a677007f |
| 0x4c948f | 93 | m4c948f_find_free_slot | 29/29 | 4/4 | 75 | 7d36fa75d32be21461f3b9f1dd2d3c6eb94c13ef447e1faff0da6acdc78a24de | 0b8219b7d88ac84ec24522564e2fd3a1b319f6e14431ec3a68c70fb75e894bc6 |
| 0x4d3992 | 103 | m4d3992_clear_entry | 28/28 | 4/4 | 72 | 48dcac3391c566a2035c5625b06060d8e28ad7bee2600279154d006d6cf99467 | b2d0e64f368b9b18845ea3662148cc164a98741a3e04938719adbc0efa5c00f9 |
| 0x4c92c5 | 123 | m4c92c5_count_down | 30/30 | 6/6 | 280 | 4c132a0ed51165bbfca6ee2bb19eeff226d6a55cbc6b208b6bf445ae5209062d | 367561d23a3a01a88e45d0ea6887498ac8f95e1d4d48d34f78c7b05b70aaacca |
| 0x4c9340 | 232 | m4c9340_scan_surface | 75/75 | 8/8 | 360 | 9b34821cf0f7e133e9353093a1d6e5d44b09d144666ecd477f8ac89b5ae3e512 | 4a4721e5c84c8300e2effe161ea07978119bedc7e39853988e7a15fe171c7b97 |
| 0x4c46d1 | 277 | m4c46d1_fill_surface | 88/88 | 8/8 | 240 | 3f766aaf15beb7cd2eccf0f0cedcdca89c56cf64d1092ed0f666a466455fcc3f | ac45a124fd35580944a274838fa7ab3d1656e9aac16540b2f624814a95d60f17 |
| 0x4cb9d1 | 303 | m4cb9d1_relocate_entries | 79/79 | 6/6 | 80 | 5a8208b9d9a5f2652d5b2832b7d5d54fbafc9a3094969f1775738c3c56efb635 | 64cd145431893efa99e7edc6f888b35762c57286d5d9f795e6419be5727449fa |
| 0x4895cc | 342 | m4895cc_init_buffer | 114/114 | 4/4 | 140 | b9eca5a83aca3be2b95d9be34dbfd641bff0c64a879c4f5f24d3e5ed174e4797 | 717d0de9f08e537cf3833bc5664716f6df3452ed642f638453e4e7567a990410 |
| 0x4c3efb | 364 | m4c3efb_lock_surface | 120/120 | 12/14 (2 allowlisted) | 96 | 599f1b53e40aacfb96abbbd33b9bcfdd5ca6c9ffc9fa043a15f14f923a92deb8 | 955a8b7cc6f876d0a2d990524f3e5424b92a382dc3f41d8ec02f8552725d5312 |

Notes per function (the header `original_methods_fl29a.h` gives the byte-level contract of each):

- **0x4d39f9** `find_free_entry` (returns ax): first dword at `+4` of the stride-0x4a records `0x5d15a5 + i*0x4a`, `i = 0x18 .. 0x3f` (a word), equal to 0; otherwise the report and ax = 0xffff. Fixtures also make the entries 0x17 and 0x40 and the dwords at `+0` free, so a wrong bound or offset is visible.
- **0x4c4202** `check_vtable_call` (`ret 0xc`, the third stack dword is unused): the vtable entry at `[ [obj] + 0x80 ]` is called with ecx = the vtable pointer and the stack arguments (obj, arg); a non-zero result goes through 0x4c88c7, 0x42639d, 0x4c97b4.
- **0x4c948f** `find_free_slot`: the first zero dword of the 0x18 slots at `self + 0xc72`; the final report calls 0x4c97b4 with ecx = `self` (not 0x5cf659).
- **0x4d3992** `clear_entry`: the range check is `index < 0` or `index >= 0x58` on the sign-extended word; the three reporting calls do not stop the function, so the two dword clears happen for an out-of-range index as well (the tests use -3 .. 0x5b, inside the fixture table).
- **0x4c92c5** `count_down`: 16-bit decrement of `[0x5afbda + idx*2]` when `[0x5d032f + idx*4] != 0`; when the signed word is then 0, `0x4c2dfb(this 0x5cf659, 0x5d032f + idx*4)` is called with the ORIGINAL address (a number, not a host pointer); then a negative word is set to 0 in every case.
- **0x4c9340** `scan_surface` (returns ax): row/column scan with the pitch, bytes-per-pixel word `0x639895`, odd widths (the last word read ends one byte past the row), negative pitch and the unsigned 16-bit compare with the word at `self + 0x38d0`.
- **0x4c46d1** `fill_surface`: byte masks, `shl dl,1` byte shifts when the selector byte is not 5, 32-bit `shl eax, cl` (count modulo 32 as the CPU does), low word to `w*h` pixels; the pixel base and the sizes are re-read each pass like the original.
- **0x4cb9d1** `relocate_entries`: the callee 0x4c0c69 returns the object stored at `[self+0x15c]`; the entry address `[ [self+0x12] + 9 ] + counter*0x18` is stored to `[self+0x126]` and each of the four fields is updated through `[self+0x126]`, `[self+0x15c]` re-read at every access, in the original order.
- **0x4895cc** `init_buffer`: see divergences (allocation failure). Success path: clear 0xaba bytes (`rep stosd` 0x2ae dwords + `stosw`), the string copy as dwords then bytes (`repne scasb` length including the NUL), the two words stored after the copy and in that order (a string of 0x24 or more characters has them clobber it, tested), the 16-byte copy to `+0xac`, the two `+= 0x45`, the trace call when the word `0x63a4cd` is non-zero.
- **0x4c3efb** `lock_surface`: fast path for the stored surface (rectangle or none), otherwise the retry loop around the vtable entry `[ [surface] + 0x64 ]` (`ecx` is the leftover 1 and is not an argument).

## Dropped

None. Spill rows (0x4f61e7, 0x44b26a) were not touched.

## Files

`src/original_methods_fl29a.h`, `src/original_methods_fl29a.c`; `tests/fl29a_direct_test.c`, `tests/test_fl29a_direct.py`; `tests/fl29a_fixtures.py`, `tests/fl29a_differential_shim.c`, `tests/test_fl29a_differential.py`; `tests/fl29a_original_oracle.py`; `tests/fl29a_mutation_check.py`; `tasks/fl29a-acceptances.json`; this file. `fl29a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner subclass `Original27` with the edge hook, the stub constructor, the call-log normaliser, the conditional-jump finder), so the oracle needs that file present (it is on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl29a_direct tests.test_fl29a_differential` -> 22 tests, OK (12 direct: 10 functions, the run-all check and the sweep; 10 differential).
- Oracle: `python3 tests/fl29a_original_oracle.py` (10 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl29a_direct_test.c src/original_methods_fl29a.c -lm` -> 11 PASS (10 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices, sizes and pitches inside the fixture buffers.
- Mutation: `python3 tests/fl29a_mutation_check.py [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of fixture memory at the call. Callee shapes taken from the call sites: 0x52139c stdcall(3); 0x4c97b4 thiscall(0); 0x50ca3e cdecl(3 in 0x4d3992, 4 in 0x4895cc and 0x4c3efb); 0x4c88c7 thiscall(1); 0x42639d thiscall(2); 0x4264e8 thiscall(1); 0x4c2dfb thiscall(1) (probe: both tables); 0x4c0c69 thiscall(0) (probe: `self` 0x120..0x170); 0x51dc43 cdecl(1); 0x48945b thiscall(2) (probes: `self` first 0x30 bytes and the buffer first 0x48 bytes); 0x44a2b7 cdecl(1); 0x4c4dc3 thiscall(0); the vtable entries (stub page address `0x7e000900`) of 0x4c4202 (ecx logged, 2 stack arguments, pops 8) and of 0x4c3efb (5 stack arguments, pops 20; probe: the first 16 bytes of the descriptor). Globals and tables are patched into the image per scenario (`0x5d15a5` records, `0x5afbda` words, `0x5d032f` dwords, `0x639895`, `0x5bb57b`, `0x5c39e3`, `0x63a4cd`); the oracle checks the number of bytes the function popped on every run (0, 12, 0, 0, 4, 8, 16, 0, 12, 16). One memory model boundary: in the single allocation-failure scenario of 0x4895cc a zeroed page is mapped at address 0 (see below).

## Deliberate divergences and native rejections (not original behaviour)

- **0x4895cc, allocation returns 0**: after the reporting block the original runs `rep stosd` with `edi = 0` (it writes through the null pointer; Windows would fault). The oracle runs it on a mapped zero page only so that the reporting instructions (0x4895f5..0x48962e) are executed; the native port returns 1 right after the four reporting calls (0x51dc43, 0x50ca3e, 0x42639d, 0x4c97b4) and does nothing else. The differential test compares exactly those four calls and the dword `[p0]` (= 0) for that scenario, and the native status 1; the rest of the original's run on the zero page is not compared.
- Nothing else is bounds checked, as in the original: the indices of 0x4d3992 and 0x4c92c5 (a reported index still clears its record), the string length of 0x4895cc (a string over 0xaba bytes overruns the buffer), the pixel counts of 0x4c46d1, the rows and widths of 0x4c9340 and the entry counts of 0x4cb9d1 are caller-validated and the fixtures keep them inside their buffers.
- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half); byte arguments of 0x4c46d1 from the low byte. 0x4d39f9, 0x4c948f and 0x4c9340 return `ax`; the upper half of `eax` is not compared.

## Allowlisted untaken jump directions (0x4c3efb)

The differential and the oracle require both directions of every conditional jump of every function; two directions of 0x4c3efb are impossible by the function's own instructions and are allowlisted in `fl29a_fixtures.UNTAKEN_ALLOWED` with the reason (an allowlist entry that is taken fails as stale):

- `0x4c3f1f jne 0x4c3f49` fall-through: the test `cmp [ebp+0xc], 0` is repeated after `0x4c3f19 je` for the same value, so any value that reaches the second test is non-zero and the `jne` is always taken. The instructions at 0x4c3f21..0x4c3f47 are reached through the `je` at 0x4c3f19 and executed.
- `0x4c3fe7 je 0x4c405f` taken: `mov ecx, 1; test ecx, ecx; je` guards the retry loop; the guard is always true. The target 0x4c405f is reached through 0x4c3fd2 and 0x4c400d and executed. Under the owner ruling on always-true guards no instruction is unreachable here (all 120 are executed), but root should confirm that crediting the row with these two allowlisted edges is acceptable; if not, drop 0x4c3efb from the acceptances.

## Unverified

- Callee calling conventions are read from the call sites only: the vtable entries are assumed stdcall (0x4c4202: 2 arguments, 0x4c3efb: 5 arguments, as COM-style methods), but the original restores `esp` with `mov esp, ebp`, so the bytes cannot prove the callee's cleanup count; the stubs pop exactly the assumed count and the oracle checks only the function's own `ret N`.
- Not exercised: a callee that changes `self`, an object or a global that the function reads again afterwards (for example 0x48945b changing the buffer or `self+0x20` before 0x4895cc copies the string, 0x4c0c69 changing the entry array, the vtable entry changing the descriptor). The ports re-read like the original (0x4cb9d1 and 0x4c46d1 read every pointer and size again each pass), but the stubs never change them.
- Import/callee names are hints from the call shapes only; the meaning of the tables and fields is a description of what the code does, not recovered source names.
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl29a_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 238: caught by the direct test 214, by the differential test only 16, survivors 8
```

All eight survivors were read and are equivalent on every reachable input:

- 0x4c92c5, line `wr16(words, ..., rd16(...) - 1)` with `rd32`: the dword is truncated by the `(uint16_t)` cast, the low 16 bits of `X - 1` are the same. `rds16(...) == 0` read as `rd16` (unsigned zero test is the same). `< 0` -> `<= 0` writes 0 over 0.
- 0x4c9340: `uint16_t v = rd16(...)` read as `rd32`: truncated by the assignment.
- 0x4cb9d1: the counter `[self+0x132]` read with `rd16` instead of `rd32` (twice): the counter starts at 0 and the loop bound is a signed word (at most 0x7fff), so the high half is always 0.
- 0x4895cc: the two `wr16(..., rd16(q + 0x21 / 0x23))` read as `rd32`: truncated by the 16-bit store.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled. The retry-loop arms of 0x4c3efb (the `continue` after 0x8876021c, the three error-report calls) and the rejection block of 0x4895cc are covered by the direct test and by the differential test but have no automatic mutant.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; the world pointers (`table_5d15a5`, `words_5afbda`, `dwords_5d032f`) must point to host memory that mirrors those global tables, with slack for a negative index (`words_5afbda` and `dwords_5d032f` are indexed by a signed word). The stack-argument addresses of 0x4c4202, 0x4c9340, 0x4c46d1, 0x4895cc and 0x4c3efb are original addresses that `resolve` must map to writable memory (the surface descriptor, pixel buffer and the three output dwords are written).
- The host must treat the return value of `m4895cc_init_buffer` as follows: 0 = done, 1 = the allocation failed and the reports were made (the original would crash; the host should stop the scene or exit with the report).
- The ports are standalone; no shared parser, dispatcher or app file was edited. 0x4c97b4 is the common reporting call (the same callee as in FL-28); a host that binds the other callees to ported `m<va>_*` symbols says so itself.

## Source and test hashes (sha256, at the commit of the ports)

| file | sha256 |
|---|---|
| src/original_methods_fl29a.c | 794df0e9d78ca4d065a0b83752a4760f15a587d35ed3dd0eafdf3dd05b3fb22d |
| src/original_methods_fl29a.h | 920b815bc5f0eda28ebcda7acbfbad0d564529b14a1989acf578594da147930e |
| tests/fl29a_original_oracle.py | a931e75351bd6889de9a19cb1a17250a41faee22a4054aa9aef9a263a40b1044 |
| tests/fl29a_fixtures.py | d4e843897f44373fb655db146d426eb99b869307621aeaab71f6fb0704e6f370 |
| tests/fl29a_direct_test.c | a7b4d4e900fb2ea77be12beb51268f6c1da7d5aa18372cf8e36d2cc6c3a3d536 |
| tests/fl29a_differential_shim.c | fd3bb28929ead71e3aac8b1fe130f1279c5e1e46de115c445ad44ad2212d847c |
| tests/test_fl29a_differential.py | 2fd0a7c3fd84e07c70d502f21f8a2aeed3966f024689489ddd39fc0472b174be |
| tests/test_fl29a_direct.py | c8518d6af2708deca82e4b250d12e47871797cb50a13a4057d7e01c583d30b3e |
| tests/fl29a_mutation_check.py | 8c9da1b1e3dae61b5c7b72b66d4550e6c072e368a9ca365f475ce776c54e2996 |

Native library: the differential builds `tests/fl29a_differential_shim.c` + `src/original_methods_fl29a.c` into a throwaway shared object per run (no committed binary).

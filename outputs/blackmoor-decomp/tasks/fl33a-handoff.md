# FL-33 batch a (`fl33a`) handoff

Branch `worktree-agent-a444b29fc6acb99c4` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a444b29fc6acb99c4`), based on `a7839503` (the FL-33 packet commit, fast-forwarded in because the worktree was created at `f13a5a72`). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited and no `--write` recorder was run. `tasks/fl33a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 8 entries; the packet lists no receipt blocker for any of the eight rows, so there is no `blockers_reviewed`; the ledger's `test_area` check was NOT run here, root does it with the merge). The slice claim file was skipped as instructed.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (8 of 8, none dropped)

All in `src/original_methods_fl33a.c` / `.h` (symbols `m<va>_*`, world struct `Fl33aWorld`, host convention `Fl18Host` as in FL-18 to FL-31). One implementation commit for all eight (they share the world struct, the fixtures, the shim and the test files, as in fl31a/fl31c), then the commit that adds the hand mutants, the final fixtures and this handoff (see the end for the hashes). Per-function results (original-only oracle, N/N instructions, both directions of every conditional jump):

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4dae88 | 45 | m4dae88_set_cursor | 18/18 | 0/0 | 8 | 33aa37d386076913b64d80f2d6dd1d601a03a7f4fca0d3bd2f86f1a15475dca4 | a1a81a3bca7cc831639a049e870e925f36dda56f04a50e3cb7e1a6334c573b86 |
| 0x473117 | 52 | m473117_mark_entry | 18/18 | 4/4 | 48 | d5105ba5c92664e4ca68b4647c84be6c8a19f85f451d8427d69aad165b3eceb0 | d59d037c39dc1ed995fa971baaa6fcc1d54bc55336d39b1ac7a246021f5832b9 |
| 0x4234dd | 144 | m4234dd_push_pair | 43/43 | 4/4 | 36 | 53b1cf838aacea7a2ad593f5552a478cc17e93509d0c657ff24308ed576a2196 | 898fa0ca170e36d30d3b16e22a6d96c6ea745ae2e83543c3fa5cd4467e94cd97 |
| 0x4c7623 | 333 | m4c7623_draw_frame | 115/115 | 2/2 | 32 | 92d895ebd930106c1151df9006a8eefd990c8f8c6d73980dd5350c0c27a13cb4 | 66033d073d90ecf2ce92fdffa33eae3c9e2c461165de31c20e691c8c4897b11f |
| 0x4bf3b8 | 370 | m4bf3b8_set_text | 130/130 | 2/2 | 132 | f0f1487eaa8ad1a22f9f376f63625daed8ecfb4f48964859f90ddb4ab05a232f | fc8deb03127d18e7a434d1ff19f77c5ecdbc957078bf6415e28407720e0f9a9e |
| 0x4db993 | 384 | m4db993_move_cursor | 95/95 | 10/10 | 270 | df312ccb01fa8184ccac57483226621d9df5d2bada196c29a5c95cf199c143a0 | 139830af414afb3c475a212431a0a47d478ec5334ec6c7d1c1a5b4de3a01e39a |
| 0x47d24e | 388 | m47d24e_report_fields | 100/100 | 10/10 | 202 | d443b1514b2a77f1ebb79ebf1d59e33b597e9d26125e7bcb6c9afdc0fe239e12 | c6808a43c3312cd263c7433312490289a00449f94bed7c28fee620ffeb60b6cb |
| 0x4c7070 | 393 | m4c7070_rotate_image | 121/121 | 6/6 | 45 | 0613c9ea949f75b095202a43bb4a1315b07ee069a2607685f8b654bbda5a94f5 | e552c5024eccec8c520207f55e12e611a1909c7a3171c0357bbe85f6b6620cc9 |

Rows 0x4bf3b8 (370 bytes: the whole window is code; the dword jump table behind it at 0x4bf52a is outside the window and is executed by the original's own `jmp [eax*4+0x4bf52a]`; all six targets and the default ran) and 0x4c7070 are the larger rows.

No jump direction is allowlisted: `fl33a_fixtures.UNTAKEN_ALLOWED` is empty and every conditional jump of every function is taken both ways. None of the eight has an unreachable block behind an always-true guard (checked in the disassembly: the only unconditional-looking branches are `jmp 0x47d3ce` after `jne` in 0x47d24e and the loop back-jumps; every `j<cc>` is fed by a value the fixtures drive both ways).

Notes per function (the header `original_methods_fl33a.h` gives the byte-level contract of each):

- **0x4dae88** (`ret 8`): stores x, y at `[self+0x18]`, `[self+0x1c]`, then `call [0x52a488]` = USER32 `SetCursorPos` (stdcall, x pushed last); eax of the import is the function's eax and is returned (compared by the oracle). The stub probe proves the two stores precede the import call.
- **0x473117**: the same record store as 0x47b3bc (FL-31a) with gate dword `[self+0x7a]` (unaligned, dword compare; fixtures use values with a zero low word) and signed word `[self+0x14]` (`-1` skips; `-2`, `-3` are indices).
- **0x4234dd** (`ret 8`): n = `[self+4]`; `cmp n,0x80; jl` is SIGNED (fixtures n = -1, 0x80000000); for n >= 0x80 the report chain (0x50ca3e strcpy-shaped, 0x52139c stdcall(3), 0x44a2b7 when word 0x63a4cd is non-zero, 0x4c97b4) runs and, as in the code, execution goes on to the stores. Stores at `self + n*12 + 0xc/0x10` use 32-bit wrap (n = 0x80000000 -> offset 0, n = 0x15555556 -> 8, n = 0x2aaaaaab -> 4), `[self+4]` is read again for the second address and for the increment (n = -1: the second store hits `[self+4]` itself, then +1 of the new value).
- **0x4c7623** (`ret 0xc`): a 0x80 byte local descriptor is handed to 0x4c4067 (the callee stores dwords at +0x10 and +0x24 through the pointer; the oracle scripts those stores); then four 0x4c808f line draws with seven arguments each, rectangle fields re-read for every push (`{r0,r4,r8,r4}`, `{r0,rc,r8,rc}`, `{r0,r4,r0,rc}`, `{r8,r4,r8,rc}`), then 0x4c4202 and, on `a == [self+0xc]`, 0x4c952f. The word argument comes from `mov cx, word [ebp+0x10]; push ecx`: the upper half is leftover, the port passes the zero-extended word and the comparison masks to 16 bits (`WORD_ARGS`).
- **0x4bf3b8** (`ret 4`): `v = [self+0x2c0] + 6` (32-bit), `ja` unsigned; jump table order (read from the original, outside the window): v=0 -> `_BinkGetError@0` (import slot 0x52a514) + 0x50ca3e(self+0xc0, 0x552564, e); v=1 -> 0x50ca3e(self+0xc0, 0x552540, arg); v=2..5 -> strings at 0x552508, 0x5524e4, 0x552494, 0x5524bc; default 0x552594. The string copy is `repne scasb` (length with NUL), `rep movsd`, `rep movsb`. The strings are original data: the fixtures patch random strings of all lengths mod 4 into the image at those addresses (the closest two are 0x24 bytes apart, so the areas are 0x24 long), the port reads them through `Fl18Host.resolve`; no original string is in the source. Returns `self + 0xc0` (host pointer).
- **0x4db993** (`ret 8`): `0x4dae88(this 0x5830a6, a, b)`; `0x4daeb5(this 0x5830a6, &local pair)`. Same convention as FL-31c `m4db870_load_cursor`: the game's callee returns its own argument, `Fl18Host.call` returns 32 bits, so a result equal to the low 32 bits of the local's address means the local pair, any other result is an original address resolved through the host (both are fixtured). Four signed bound compares, three selector arms, then the globals are stored in the original order with the OLD rectangle values copied into the object first and the table reads using `0x5b44f4` and `0x5b44f0` read back from the globals.
- **0x47d24e** (plain `ret`, no ecx): every argument of the five-argument `0x4c5377` calls is a 32-bit original value (`p + (x << 4) + const` wraps in 32 bits); `byte [p+0x35b]` is read with `movsx` but only tested for zero; the loop bound `[0x61e618]` is a signed compare re-read each pass; `base = [0x61e624] * [0x61e618]`; entries are 12 bytes, dword compare `== 1` (fixtures use 0x100, 0x10001, 0x80000001 ... as non-1 values).
- **0x4c7070** (`ret 8`): allocator 0x51dc43(size), image copy as dwords then bytes (sizes 3, 4, 5, 0x10..0x13, 0x80, 0x81, 0x100 and 0x10005), a nested loop that writes the image back rotated (outer loop signed word w1, inner count signed word w2 down to 0, row stride signed word w3, column step signed word 0x639895), the four descriptor words (w2, w1, low 16 bits of w2 * step, w1) and 0x51dc6c(buffer). Allocator failure: 0x42639d(this 0x583979, 0x5552e8, arg2) and 0x4c97b4(this), nothing else.

## Dropped

None. No row had an always-true guard or a dead block.

## Files

`src/original_methods_fl33a.h`, `src/original_methods_fl33a.c`; `tests/fl33a_direct_test.c`, `tests/test_fl33a_direct.py`; `tests/fl33a_fixtures.py`, `tests/fl33a_differential_shim.c`, `tests/test_fl33a_differential.py`; `tests/fl33a_original_oracle.py`; `tests/fl33a_mutation_check.py`, `tests/fl33a_hand_mutants.py`; `tasks/fl33a-acceptances.json`; this file. `fl33a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner subclass with the edge hook, the stub constructor, the call-log normaliser, the conditional-jump finder) and adds the `ret_arg` runner of FL-31c.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to the first of clang/cc/gcc)

- Slice tests: `python3 -m unittest tests.test_fl33a_direct tests.test_fl33a_differential` -> 18 tests, OK (10 direct: 8 functions, the run-all check and the sweep; 8 differential).
- Oracle: `python3 tests/fl33a_original_oracle.py` (8 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0, one trace file written).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl33a_direct_test.c src/original_methods_fl33a.c -lm` -> 9 PASS (8 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices, counts, sizes and pointers inside the fixture buffers (the unsafe inputs are the documented non-rejections below, covered by hand-derived cases, not by the sweep).
- Mutation: `python3 tests/fl33a_mutation_check.py [--only <va key>]`, `python3 tests/fl33a_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes of fixture memory and of the globals at the call. Callee shapes taken from the call sites: 0x4dae88 USER-import slot 0x52a488 stdcall(2); 0x50ca3e cdecl(2) (0x4234dd) and cdecl(3) (0x4bf3b8) (esp restored by `add esp`); 0x52139c stdcall(3) (inferred: linear disassembly shows a `ret 0xc` at 0x5213d1, the end of the routine that starts at 0x52139c); 0x44a2b7 cdecl(1); 0x4c97b4 thiscall(0); 0x4c4067 thiscall(5) (scripted stores of two dwords through its third argument, the function's local); 0x4c808f thiscall(7); 0x4c4202 thiscall(3); 0x4c952f thiscall(1); import slot 0x52a514 (`_BinkGetError@0`) stdcall(0); 0x4dae88 thiscall(2) and 0x4daeb5 thiscall(1) (0x4db993; the second stores the pair through its argument and returns that argument, or returns a scripted original address); 0x4c5377 thiscall(5); 0x51dc43 cdecl(1) (scripted block address or 0); 0x51dc6c cdecl(1); 0x42639d thiscall(2). Globals, tables and the five game strings are patched into the image per scenario (`0x5d15a5`, `0x5d1599`, `0x5b3790` tables, the world's globals, the strings at 0x552494 ...). The oracle checks the number of bytes the function popped on every run (8, 0, 8, 12, 4, 8, 0, 8 for the rows in table order) and, for 0x4bf3b8, that eax = this + 0xc0. `rep` string moves and the dword jump table of 0x4bf3b8 run as original instructions. No x87.

## Deliberate divergences (not original behaviour)

- 0x4c7623: the 0x80-byte descriptor local is zero filled here; the original leaves stack garbage there except the two dwords that 0x4c4067 stores (the only ones read). Not observable when the callee stores them.
- 0x4db993 / pointer results: a callee result is 32 bits (convention above).
- 0x47d24e: in the game the table dword of record 1 at 0x5d15e3 and the global 0x5d15e3 are the same memory (`0x5d1599 + 0x4a`); `Fl33aWorld` has them as two fields (`table_5d1599` and `value_5d15e3`), so the host must keep them coherent. The fixtures set the table dword equal to the global.
- Nothing is bounds checked, as in the original: 0x4234dd with n >= 0x80 (or a negative n beyond the object) stores outside any fixed bound after the report chain, 0x4c7070 reads `buf + j*w3 + i*step` and writes `w1*w2` words without any check, 0x473117 indexes the record table by a signed word. Callers validate. No native rejection was needed: none of the eight has an input on which the original faults inside its own instructions that the fixtures could reach (a fault would need an unmapped address, i.e. a caller error).
- Word arguments are taken from the low 16 bits of the stack dword (0x4c7623).

## Unverified

- Callee calling conventions are read from the call sites only; whether the callee pops its arguments (`ret n`) is unprovable for 0x4c5377, 0x4c4067, 0x4c808f, 0x4c4202, 0x4c952f, 0x4daeb5, 0x42639d, 0x4c97b4 from these bytes (every function here ends in `mov esp, ebp`, so the leak would be hidden). 0x51dc43 / 0x51dc6c are the CRT allocator and free by shape only; 0x50ca3e is strcpy / sprintf by shape only (a different, string-copying use at 0x4234dd with two arguments and a formatting use with three at 0x4bf3b8).
- 0x4234dd for n >= 0x80: whether 0x4c97b4 and 0x52139c ever return is unknown (the code keeps going, so does the port).
- Not exercised: a callee that changes `self` or a global that the function reads again afterwards (for example 0x4c5377 changing `[0x61e618]` mid-loop, 0x4daeb5 changing `self`, a callee changing the rectangle behind the 0x4c7623 argument): the ports re-read like the original, but the stubs never change them. 0x4c7623's ecx at the `mov cx, word [ebp+0x10]; push ecx` sites carries whatever 0x4c4067 left in the upper half; the port passes the zero-extended word and the stubs here leave ecx as it was.
- The meaning of the fields is a description of what the code does, not recovered source names. No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl33a_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 168: caught by the direct test 151, by the differential test only 14, survivors 3
```

The first run had four survivors. One was a fixture gap and is closed: `size = rd32(d, 0x23)` read as `rd16` survived in 0x4c7070 because every image size was below 0x10000; the profile `('big', 2, 2, 4, 2, 0x10005)` (image and block regions of 0x10800 bytes) is now in the fixtures and in the oracle, and the mutant is caught by the differential test. The remaining survivors are EQUIVALENT mutants: (1) `uint8_t desc[0x80]` -> `[0x81]` in 0x4c7623 (the size of the local buffer is not observable, only the dwords at +0x10 and +0x24 are used); (2) `rds16(d, 0x2d)` -> `rd16` in the 0x4c7070 product (the low 16 bits of a product depend only on the low 16 bits of the operands, so sign extension does not change the stored word); (3) `uint16_t word = rd16(buf, ...)` -> `rd32` in the same function (the value is truncated to `uint16_t` again).

Hand-written mutants (`python3 tests/fl33a_hand_mutants.py`, all caught, 32 of 32; each by the direct test, the build or the differential test as printed): swapped SetCursorPos arguments, import before the stores, dropped return value (0x4dae88); zero-extended index and a word gate instead of the dword gate (0x473117); unsigned instead of signed `>= 0x80`, un-wrapped 64-bit offset, the two stores in the wrong order, the debug word read as a byte (0x4234dd); the word argument not masked, swapped rectangle fields, the wrong descriptor dword (0x4c7623); signed `v > 5`, the NUL not copied, swapped sprintf arguments, the BinkGetError result dropped (0x4bf3b8); the old rectangle values copied after the update, unsigned low and high bound compares, the local pair never recognised, the zero store to 0x5b44f4 dropped, the `-1` selector arm lost (0x4db993); the flag cleared before the call, an unsigned loop bound, the gate read as a word, a dword read for the byte test, `!= 0` for `== 1` (0x47d24e); ascending instead of descending rows, the free before the descriptor words, `this` wrong in the failure path, the trailing bytes of the copy truncated, the product taken from the wrong word (0x4c7070).

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled (the hand mutants cover the shapes that matter here).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl33aWorld` carries the tables as host pointers (`table_5d15a5`, `table_5d1599`, `table_5b3790`, each pointing at the byte the original address names, with slack for a negative index) and the globals by their original address in the field name; the host copies them back to its own storage or points the world at it. The import slots 0x52a488 (SetCursorPos) and 0x52a514 (_BinkGetError@0) are called through `Fl18Host.call` with the slot address as the callee, as 0x52a530 is in FL-29c.
- `m4bf3b8_set_text` returns the host pointer `self + 0xc0`; the strings it copies come from `Fl18Host.resolve` on the original's data addresses, so the host's data image must serve 0x552494 ... 0x552594.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that closes this batch)

| file | sha256 |
|---|---|
| src/original_methods_fl33a.c | f18e3cd3939d09e6fb2afe32888ff20320a7811b606842227e1262ce0789762e |
| src/original_methods_fl33a.h | 14f277596b8a7c26d89ab0087cbcf175bb05648a646c0a79f0c329273b3ff252 |
| tests/fl33a_original_oracle.py | 9a4fef33cb1b3f685dbcc5b9a9d1764a8ef45fb031d09580d8b2637c8962690f |
| tests/fl33a_fixtures.py | 2915e6fd3764941f3fb1fc8d8be9b8986e021af9c6e1df7e6e144dfffc37f1ff |
| tests/fl33a_direct_test.c | 48b2524dc9173cb0ad23e71b5c0da3e4a947bee608e7a6d3d886428f4e553af5 |
| tests/fl33a_differential_shim.c | 9482477c57c8935f5844482052582bbbf276c51d81c7d213253a560164016fd1 |
| tests/test_fl33a_differential.py | 0b244d95fb8cf42a09aaf180a84b01a02b189363064091219967af0dc48b7d28 |
| tests/test_fl33a_direct.py | 60872d13386b66d5a993eeeb0a1d15e8c3302b8df740a2787fdc6f19f55f273a |
| tests/fl33a_mutation_check.py | f846af0299c67def89b7b0a9deb55613788d71f79e1f64d1cecdadd61e268ff0 |
| tests/fl33a_hand_mutants.py | 017e15faca0254b9780469d4fe5b6785f31c24424d00e48de3a572dc534c98bd |

Native library: the differential builds `tests/fl33a_differential_shim.c` + `src/original_methods_fl33a.c` into a throwaway shared object per run (no committed binary).

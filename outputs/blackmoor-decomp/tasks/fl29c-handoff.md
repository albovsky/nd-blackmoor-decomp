# FL-29 batch c (`fl29c`) handoff

Branch `fl29c` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a50d1eca4cb6558e4`), based on `62c9934` (the FL-29 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl29c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 10 entries). None of the 10 rows has a receipt blocker, so there is no `blockers_reviewed`.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (10 of 10) and one open decision

All in `src/original_methods_fl29c.c` / `.h` (symbols `m<va>_*`, world struct `Fl29cWorld`, host convention `Fl18Host` as in FL-18/26/27/28). The window hash is the SHA-256 of the original bytes `va .. va + span` (it equals the ledger's `window_sha256` where the ledger carries one).

| va | span (code) | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 |
|---|---|---|---|---|---|---|---|
| 0x4bf19a | 86 | m4bf19a_bink_goto | 30/30 | 6/6 | 63 | 85a764871a66936f076270928b007ced8b79ed346bf0f756299026def7f30300 | e1d4bfba556921a1e9049bde018e652cb61afacfd2645daca3542d28abe35246 |
| 0x434814 | 108 (101) | m434814_copy_name | 31/31 | 4/4 | 56 | 666f150e1c34b4754df06aaec1f903dcf7b911ba5465d0e05e318f377b2f26c8 | be9d2fcd44e2e5052ddf08c1923ce249deb4af32330c0785aa512c596db23672 |
| 0x4471ca | 176 | m4471ca_copy_record15 | 57/57 | 4/4 | 57 | 8626f16ac58373ddbfd3b0ffd231d6cb9ed6c9247df2920ffcfd458d29d7b09f | 8b0f82614a0e63fc5a928bd26bd1711cdc038eed361aaaa96fb9d11cb3dda307 |
| 0x45b4ae | 186 | m45b4ae_copy_record_b8e | 57/57 | 4/4 | 57 | a6d9b9ecc6776a7029cd4d58b39bac0474b0eec505b91e20b9a481a98f3edf82 | deb606e9ba087b3e85a16b377b66dae04cd1738b35d6f61032cd6343a635ffd6 |
| 0x461903 | 187 | m461903_copy_record_357 | 58/58 | 4/4 | 57 | cbc0619a25956d08c0e0db9a1a173e3e0939573052055b7df3c765b14c69e507 | a17fe1bef790c68f79f85e52e9244bf7761a113a697a548c15e8877a9c1ad439 |
| 0x4b5c5c | 187 | m4b5c5c_copy_record_39f | 58/58 | 4/4 | 57 | 8b059f7853a68f9153d8ba7d67a480cd685cd23e157e44095d734a8dacc5a7bb | 1d4bb7367575fb73a2071051d8402a72864d94749f1e1fb7f7ef013e2b57961c |
| 0x45bbd8 | 233 | m45bbd8_roll_rects | 69/69 | 10/10 | 96 | ceb7d38f9b21cf239e5a3421c16c42050272b36910584f0d298267fcca1d06a2 | 693b45f27e4f2d89d3e316c71cddaf5aef0b77f050d85313405545f901f26df1 |
| 0x4630a3 | 302 (286) | m4630a3_select_action | 58/58 | 6/6 | 144 | ae33d0ae407e35b6ec75217baaa1918e2b999e2286c9c10f30ed31f5898287b6 | e131792c907d98f7f3f7048ebc32995e8ea5fd2d6eb12504915866689e5028b5 |
| 0x43423d | 357 | m43423d_find_name_a | 116/116 | 14/14 | 256 | 28e71bb0c1589ea9f212e0d9eea42ae40721adf5f7d2a1d941909601dc3d8dfc | 11fb4c2fba56f1adfa591e51d080cbda140f510f1810e38c96315ab8635f213f |
| 0x4344bf | 369 | m4344bf_find_name_b | 114/114 | 16/16 | 266 | 608313983143dcb856002f7e842d729a8c5ff2d901d858176a0be7a99ea00fb9 | 170621f02b872e6595467b0abfd42155f691430808b69866851fdb2464ea40d9 |

Notes per function (the headers of `original_methods_fl29c.h` give the byte-level contract):

- **0x4bf19a** `bink_goto`: the thiscall 0x4bf38c first, then the null-handle word (-3 into `[self+0x2c0]`), the signed `frame < 1` / unsigned `frame > [handle+8]` rejections and the import `_BinkGoto@12` (IAT slot 0x52a530, stdcall(3): handle, frame, 0).
- **0x434814** `copy_name`: at most four non-zero bytes (a `movsx` byte test) from the string to the 5-byte global buffer 0x63a590 (reached through `world->buf_63a590`), terminator, returns the constant 0x63a590. The ledger span has 7 trailing `int3` bytes: 101 code bytes.
- **0x4471ca, 0x45b4ae, 0x461903, 0x4b5c5c** `copy_record*`: four instances of one body (allocate N bytes through the cdecl 0x51dc43, store the pointer in cell A, report on 0, copy forward from `[B]` to `[A]`, advance cell C then cell B by N, trace with the debug word). In the port they are four symbols that call one static helper `copy_record` (parameters: size, dword count, word tail, byte tail, three string addresses); each symbol cites its own address in its leading comment. The cells are host pointers to 4-byte cells that hold original addresses, resolved through `Fl18Host.resolve`.
- **0x45bbd8** `roll_rects`: four passes of two `0x50cd50` calls; the signed remainder by 2 and by 4 (`and 0x80000001/3; jns; dec; or; inc` idiom, kept as a word); 16 bytes copied in four dword steps from `rec + 0x36d + w4*32 + w2*16` to `self + 0x36 + arg*64 + i*16`; count of `w2 == 1`, 5 when zero; returns `ax`. **Open decision for root**: see the 0x45bbd8 paragraph under Unverified.
- **0x4630a3** `select_action`: the 0x277f case, the `[self+0x57]` word set when zero, the 4-entry jump table (0x2780..0x2783 -> 0x19, 0x17, 0x18, 0x1a; the table dwords at 0x4631c1 read from the original), the default arm leaves `[0x5b44f0]` as it is and reads it back for the `[0x5d1631]` sum.
- **0x43423d** `find_name_a` / **0x4344bf** `find_name_b`: table searches with the inlined strcmp (byte pairs, in the order the original reads them), 0x4347b8 (a length report) and 0x434814 (the lookup) host-stubbed. The constant string at 0x545ef0 whose length is added in 0x43423d (`repne scasb`) is 4 bytes long (measured from the original; only the number is in the port). The first loop of 0x4344bf clears 1000 dwords; the flag test `[self + 0x4fc4 + i*4] != 1` is only false for i >= 1000, where the flag dword aliases `[self+0x5f64]` (i = 1000) and the count `[self+0x5f68]` (i = 1001): the fixtures `alias_hit` (flag values 1, 0x10001, 0x100, 0) and `alias_miss` take that `je` and are what makes both directions of that jump reachable; the port reproduces it with the same memory accesses.

## Dropped (0)

None. The spill rows (0x4f61e7, 0x44b26a) were not touched.

## Files

`src/original_methods_fl29c.h`, `src/original_methods_fl29c.c`; `tests/fl29c_direct_test.c`, `tests/test_fl29c_direct.py`; `tests/fl29c_fixtures.py`, `tests/fl29c_differential_shim.c`, `tests/test_fl29c_differential.py`; `tests/fl29c_original_oracle.py`; `tests/fl29c_mutation_check.py`; `tasks/fl29c-acceptances.json`; this file.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang/cc/gcc)

- Slice tests: `python3 -m unittest tests.test_fl29c_direct tests.test_fl29c_differential` -> 22 tests, OK (12 direct: 10 functions, the run-all check and the sweep; 10 differential).
- Oracle: `python3 tests/fl29c_original_oracle.py` (10 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl29c_direct_test.c src/original_methods_fl29c.c -lm` -> 11 PASS (10 functions + the bounded sweep of 300 random scenarios), no report. The sweep drives every port on random in-bounds buffers and leaves the null page unmapped in a quarter of the runs, so the native rejections run under the sanitisers too; the direct tests of 0x43423d / 0x4344bf also pass an unresolvable string address.
- Mutation: `python3 tests/fl29c_mutation_check.py [--decimal] [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments (stdcall/thiscall cleanup as at the call sites), return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of the object. Callee shapes: 0x4bf38c thiscall(0) (plain `ret`); the import `_BinkGoto@12` at IAT slot 0x52a530 stdcall(3) (a fake entry address is written into the slot; `ret 0xc`); 0x51dc43 cdecl(1) (allocation); 0x50ca3e cdecl(4); 0x42639d thiscall(2) (`ret 8`); 0x4c97b4 thiscall(0); 0x44a2b7 cdecl(1); 0x50cd50 cdecl(0) (the CRT `rand`: scripted rolls); 0x4347b8 and 0x434814 thiscall(1) (`ret 4`; 0x4347b8 is the FL-16 port `m4347b8_read_be32` and 0x434814 is a function of this batch: both are host-stubbed here, with the string address of 0x434814 scripted per call). Not hooked: nothing else; the globals (the debug word 0x63a4cd, 0x5c39e3, 0x5bb57b, the 0x4630a3 globals, the 5-byte buffer 0x63a590, the record table 0x5bb5e5) are patched into the image per scenario; memory the original allocates (`0x51dc43` results) is a region of the fixture. The oracle checks the number of bytes the function popped on every run (ret 4/8/0xc). For the allocation-failure scenarios of the four copy functions the fixture maps a scratch page at address 0 (a memory-map choice of the harness, not a patch of the function) so that the original can run on to its end after the report; see the divergences.

Callee/batch relations: 0x434814 is called by 0x43423d and 0x4344bf (stubbed there); the integration step decides whether the host binds it to `m434814_copy_name` (the host contract: flush the world before and resync after each call).

## Deliberate divergences and native rejections (not original behaviour)

- Nothing is bounds checked, as in the original: the counts, indices and string lengths are caller-validated; the tests keep them inside their buffers.
- Allocation failure (0x4471ca, 0x45b4ae, 0x461903, 0x4b5c5c): after the report calls the original copies through the address 0 (and advances the cells). The oracle and the differential test run it against a mapped scratch page at address 0 (the port finds that page through `Fl18Host.resolve`). A production host whose `resolve(0)` returns NULL makes the port return at that point without copying and without advancing the cells: an explicit native rejection of an access violation, not original behaviour.
- 0x45bbd8: a source address that `resolve` cannot map skips that pass's 16-byte copy (the original would fault). 0x43423d / 0x4344bf: an unresolvable string address from 0x434814 returns 0 (the original would read an unmapped address). Neither is reached by a valid input.
- Pointer-valued stack arguments (`handle`, `name`, the cells) are host pointers; values stored in objects and cells are original addresses.
- Word arguments are taken from the low 16 bits of the stack dword (0x45bbd8, 0x4630a3: the fixtures put garbage in the upper half). 0x45bbd8 returns `ax` only (the upper half of `eax` is not compared).
- The `copy_record` helper writes the trailing word with a 16-bit store and the trailing byte with a byte store, like the original `movsw` / `movsb`; the dword copy runs forward dword by dword (the same overlap behaviour as `rep movsd`).

## Unverified

- Not exercised: a callee that changes `self`, a cell or a global that the function reads again afterwards. 0x43423d and 0x4344bf re-read the loop bound `[self+0x5f64]` / `[self+0x5f68]` on every pass (the port does too); no scenario changes it in between, so a port that cached the bound is not detected (the only write to the count, at i = 1001 of the `alias_hit` scenarios, ends the function).
- 0x45bbd8, the `rand` question: the real `0x50cd50` is `... shr eax, 0x10; and eax, 0x7fff; ret`, so its result is never negative, and the two `jns` fixups (`dec eax; or eax, 0xfffffffe; inc eax` at 0x45bc2a..0x45bc2e and `dec; or 0xfffffffc; inc` at 0x45bc54..0x45bc58, six instructions) run only when the stubbed callee returns a value with bit 31 set. The oracle does script such results (N/N includes them) because the packet allows scripted callee outcomes at the host boundary. If the owner ruling on "unreachable blocks behind always-true guards stay pending" is read to cover a callee result that the real callee can never produce, 0x45bbd8 should be withdrawn from the acceptance file; the other nine rows do not depend on this. The signed-remainder arithmetic is verified by the Unicorn differential for every value of the scripted set (0, 1, 2, 3, 0x7fff, 0x80000000 .. 0x80000004, 0xfffffffe, 0xffffffff, ...).
- The meaning of the tables, records and strings is a description of what the code does, not recovered source names; the import name `_BinkGoto@12` is the PE import name of slot 0x52a530.
- No independent review; no claim that the bink, hiff, 28, da, d1 or d3 families are complete.

## Mutation check

`python3 tests/fl29c_mutation_check.py --only <va key>` per function (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap), run on the committed source. The helper `copy_record` sits under the 0x4471ca marker, so its mutants are counted there.

```
== 4bf19a
mutants 9: caught by the direct test 9, by the differential test only 0, survivors 0
== 434814
mutants 3: caught by the direct test 3, by the differential test only 0, survivors 0
== 4471ca
mutants 24: caught by the direct test 23, by the differential test only 0, survivors 1
  survivor: line 124 (0x4471ca) width rd16( -> rd32(
== 45b4ae
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 461903
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 4b5c5c
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 45bbd8
mutants 19: caught by the direct test 17, by the differential test only 1, survivors 1
  survivor: line 168 (0x45bbd8) boundary < -> <=
== 4630a3
mutants 15: caught by the direct test 14, by the differential test only 0, survivors 1
  survivor: line 211 (0x4630a3) width rds16( -> rd16(
== 43423d
mutants 31: caught by the direct test 27, by the differential test only 4, survivors 0
== 4344bf
mutants 19: caught by the direct test 15, by the differential test only 4, survivors 0
```

With `--decimal` (every decimal literal of 2 or more raised by one: the multipliers 16, 32, 64, the counts):

```
== 4bf19a
mutants 10: caught by the direct test 10, by the differential test only 0, survivors 0
== 434814
mutants 4: caught by the direct test 4, by the differential test only 0, survivors 0
== 4471ca
mutants 33: caught by the direct test 32, by the differential test only 0, survivors 1
  survivor: line 124 (0x4471ca) width rd16( -> rd32(
== 45b4ae
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 461903
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 4b5c5c
mutants 5: caught by the direct test 5, by the differential test only 0, survivors 0
== 45bbd8
mutants 28: caught by the direct test 26, by the differential test only 1, survivors 1
  survivor: line 168 (0x45bbd8) boundary < -> <=
== 4630a3
mutants 22: caught by the direct test 21, by the differential test only 0, survivors 1
  survivor: line 211 (0x4630a3) width rds16( -> rd16(
== 43423d
mutants 44: caught by the direct test 34, by the differential test only 10, survivors 0
== 4344bf
mutants 25: caught by the direct test 21, by the differential test only 4, survivors 0
```

All survivors were read; they are equivalent on this host:

- 0x4471ca (helper, line `wr16(dst, 4*ndwords, rd16(src, ...))`): `rd16` read as `rd32`, truncated by the 16-bit store that follows.
- 0x45bbd8: `(int32_t)v < 0` as `<= 0` in `signed_rem` (v = 0 maps to 0 either way).
- 0x4630a3: `rds16(self, 0x57) == 0` as `rd16(...) == 0` (the same zero test).

The two native-rejection guards (`s == NULL` in 0x43423d and 0x4344bf) and the flag dword width of 0x4344bf (`!= 1` on a dword, tested with the flag value 0x10001) are caught by the direct and the differential test respectively. Known gap of the tool: mutants are single textual edits; a dropped statement, a reordering of effects, a loop bound cached in a local or two edits together are not modelled (the loop-bound re-read is listed under Unverified).

## Source and test hashes (sha256, at the last commit)

| file | sha256 |
|---|---|
| src/original_methods_fl29c.c | 6840871b8b92356cd397c524845ffd08d7f30764f41495efaba1b4967657161b |
| src/original_methods_fl29c.h | fca50da03b31ac4a8e90040d3a2da08d6e1dcf4cc383f85ea43b11929bf6d0ee |
| tests/fl29c_original_oracle.py | 6af650e2d6ee2def792d35408ddf14fb8f4c1c2bf97ceb9a27f5071675c93397 |
| tests/fl29c_fixtures.py | 45ab010d5418b51cf04657dd7cc7b0efceb132360951ed3cc8fbac5fb9c9d3f5 |
| tests/fl29c_direct_test.c | 6cbdb439c84346368c18ecd4b6e1d825f6d7b6af3f30df03251e67b3b84f350c |
| tests/fl29c_differential_shim.c | 3c89153c6c586f9a647278a36d3b38aa4169af12673e174cbf93c37adc444ade |
| tests/test_fl29c_differential.py | 51eac6bf5a64c1d0f9ba601b4e19813c701ca4778a50c6eeb533515ce26e127c |
| tests/test_fl29c_direct.py | 7328069cf392129dabd8efd611c5b7dab7148ebed3c4439cd7674b4f9c9930d9 |
| tests/fl29c_mutation_check.py | 736c594db856d6fd04e2243da223ff99f7d6727bcee8c6faf64ba198b8ddc84e |
| tasks/fl29c-acceptances.json | 13cd9a6fb8bf2b55dfa3103e70303ae460144fc2c76dfef4b1371e59d0d988ba |

Native library: the differential builds `tests/fl29c_differential_shim.c` + `src/original_methods_fl29c.c` into a throwaway shared object per run (no committed binary).

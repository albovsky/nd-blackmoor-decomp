# FL-31 batch c (`fl31c`) handoff

Branch `worktree-agent-a899d9c618f76e131` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a899d9c618f76e131`), based on `6b8fe413` (the FL-31 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl31c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 8 entries; none of the rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 24 test ids and accepts them).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (8 of 8, none dropped, spill row 0x4c7623 not touched)

All in `src/original_methods_fl31c.c` / `.h` (symbols `m<va>_*`, world struct `Fl31cWorld`, host convention `Fl18Host` as in FL-29/31b). The three near-identical rows share one static helper (`pick_variant`) with one exported symbol each, every symbol with a leading comment that cites its own address. Callees are host calls (stubs) everywhere; none of the listed functions is called natively by another.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4e2faa | 145 | m4e2faa_release_cells | 40/40 | 4/4 | 72 | 1b8f40f0c00c1689d16f8f0ba51d2ab1b2cc8d22d662384ee12b7d40e0cf360a | 65e93f6e03767a18a48f7e257f70ad80ddb8827db487107eeb097c5a855a06e5 |
| 0x4c2790 | 264 | m4c2790_new_record | 91/91 | 6/6 | 152 | 984f486a4fdf59b2217271b960f8807884aef6307273942c6d4961525ad9e13f | 7348763ea143298d0d536527aaa4800658c28dc84560003f3f6b534a268e23cf |
| 0x4eba54 | 263 | m4eba54_retarget_words | 62/62 | 8/8 | 168 | f85ec37f1c62ff8dcba9a1bf42ac3e0f48ce2b453d1b379085c66ea87beb2017 | d1a3a6b57e8553dbdcf5fc3cd91bf52352750187945ef72184c3fd3d6b43e609 |
| 0x4edb97 | 282 | m4edb97_release_members | 69/69 | 14/14 | 256 | 401b6848933eca7375a2421e56d9dda3d07dd335d2ac0cb0d1eada32e060eee7 | 0f9dd052b1bed5f56fff0501bbd7af2165f92d1d845367b6e593144eedfb542a |
| 0x4db870 | 291 | m4db870_load_cursor | 73/73 | 2/2 | 132 | 00c7ef3fa9bac1ed33a216a75cd70cc5d975665d010fc5f80f8ae175a702e5f3 | 3f6aa40fbd6dc3eb235e07eb563ccee747b9ca2a3712bb639f52113bc1a18adc |
| 0x47cd90 | 223 | m47cd90_pick_variant_a | 62/62 | 8/8 | 48 | 0b7c7cb02ba6b780e2d3e0b2b5f09d647c9ced83b25753cec676d6f2201c261f | bdf6e9cc6fe545851cc51e94bbcf082503cdd8ec153c66282400ae6fcd144c25 |
| 0x47ce6f | 223 | m47ce6f_pick_variant_b | 62/62 | 8/8 | 93 | 98d8bf6872e60da083570dda9e6e1d161b3a3bebcfabc9ae612d77dbee4ec0b1 | f53e38752eefe5817035cd9a0851bf5dd189663d9b8f792fdebf52e3cba7071c |
| 0x47cf4e | 223 | m47cf4e_pick_variant_c | 62/62 | 8/8 | 93 | bbc87d6829da651c50e8254646a19b8832885ef2b14db5ddf017f61d40223eb8 | 74fe1246fd0e96f87f1c7fa91fcc3131266024eb19d402950792fd4329662d9f |

No allowlisted untaken jump directions: every direction of every conditional jump is taken (`fl31c_fixtures.UNTAKEN_ALLOWED` is empty). Unreachable-block check (ruling on always-true guards): none of the eight has an `mov reg,1; test reg,reg; je` guard or a `jns` after a non-negative callee; every instruction is executed.

Per-function notes (the header `original_methods_fl31c.h` gives the byte-level contract):

- **0x4e2faa** loops a signed dword counter 0..0x19 calling `0x4e1d34` (thiscall, 0 args) with ecx = `self + 0x1ca2 + i*0x18f`; then `0x4e2dd3(self)`, `0x4c92c5(0x5cf659, word [self+0x140a])` and the same for `+0x140c` (the pushes are `push ecx` / `push eax` after `mov cx/ax, word`, so the upper half is stale: the callee is declared a word argument and compared by its low 16 bits), then `0x4c2dfb(0x5cf659, self+0x6ce)` if the dword is set.
- **0x4c2790** (`ret 0x10`, returns eax): `0x51dc43(0x59)`; null -> `0x42639d(0x583979, 0x553be8, b)`, `0x4c97b4(self)`, return 0. Otherwise 0x59 bytes zeroed, the string cut IN PLACE at index 0x18 when its length is >= 0x19 (`jb` unsigned), length measured again, copied with its NUL to `buf+8` (dwords then bytes), `[buf+4]=c`, word `[buf+0x21]=0x59`, word `[buf+0x33]=word 0x639893`, dword `[buf+0x55]=0`, `0x4181c6(0x5d2f31, a, b, buf)` (thiscall 3; the fixture callee stores the dword `[buf]` through its third argument, both zero and non-zero scripted), then `[buf]==0` -> `0x42639d(0x583979, 0x553c40, b)`, `0x4c97b4(self)`, return 0, else return buf.
- **0x4eba54**: the dword counter lives in `self+0xfc6` and is stored at every step like the original (the stubs probe it at each call); the first loop (`< 2`) calls `0x4e1d34(self + i*0x18f + 0xca8)` when dword `[self + i*0xf7 + 0x985]` is non-zero; the second runs while the counter < signed word `[self+0x28da]` and rewrites a table word equal to 8 (signed compare after `movsx`) with word `[self+0xb85]`. The row of the table is `movsx word [ebp-4]`, a local the function sets to 0 and never changes, so the row is 0 (kept as a named local in the port). Final `0x4eb9c8(self)`.
- **0x4edb97**: see the header; each of the four members is cleared AFTER its `0x4fba69` call (the stubs probe the four dwords at each call).
- **0x4db870**: the pair pointer returned by the callee `0x4daeb5` (an original address; the real callee returns its argument, a local) is read through `Fl18Host.resolve`; the fixtures script it to a separate area and to five spots inside `self` (+0x10, +0x14, +0x18, +0x1c, +0x28), so that an implementation that reads `y` after storing `x` is caught. The table entry address is `0x5b3790 + 8*[0x5b44f0] + 4*[0x5b44f4] (+2)` in 32-bit arithmetic with signed words; `[0x5b44f4]` is the value just stored (0). All globals are written in the original order and read back where the original does (`Fl31cWorld`).
- **0x47cd90 / 0x47ce6f / 0x47cf4e**: one method with different constants (selector +0x2b8/+0x2bc/+0x2c0, record offset 0x4c8/0x856/0xf72, count 5/10/10, strings; the stride is 0xb6 and the final callee is 0x47d02d in all three). The remainder keeps the sign of the rand result (`cdq; idiv`), so a negative scripted rand gives a negative selector and a record address computed in 32-bit wrap arithmetic; the fixtures use such values, and bases that wrap.

## Dropped

None.

## Deliberate divergences and native rejections

- None. The ports do not add bounds checks; strings, tables and objects are caller-validated as in the original. The retry loop of the three `pick_variant` methods has no bound in the original and none in the port: it ends only when the host's `0x516530` answers non-zero for the drawn record (scripted in every test; with real data this depends on the strings in the game's records and is not proven here).
- Word arguments: `0x4c92c5` receives the low word only (see above). The word fields compared as signed (`movsx`) are `rds16`; unsigned compare of a word is not used in this batch.

## Unverified

- Callee calling conventions are read from the call sites (ecx set or not, pushes, `add esp` after cdecl calls); callee cleanup of thiscall stack arguments cannot be proven from the caller (the stubs pop the assumed count and the oracle checks only the function's own `ret N`).
- Not exercised: a callee that changes `self`, an object or a global that the function reads again afterwards (for example `0x4e1d34` changing the flag dwords of `0x4eba54` or the counter, `0x4181c6` changing the string or `0x639893`, `0x47d02d` or `0x516530` changing `self+0xc`). The ports re-read like the original (counter, flags and word count in `0x4eba54`, `self+0xc` and the selector in the `pick_variant` loop, `[buf]` after `0x4181c6`).
- `0x4daeb5` returns an arbitrary scripted pointer in the fixtures, as does `0x4181c6` for `[buf]`; in the game they return/produce their documented results (the first returns its argument, the local pair). The local-pair case is not run as such (the pair read from the local would be uninitialised bytes with the stubs).
- Names are hints from what the code does, not recovered source names. No independent review; no claim that any family or pool is complete.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address: they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of fixture memory at the call. Shapes from the call sites: 0x4e1d34 thiscall(0); 0x4e2dd3 thiscall(0); 0x4c92c5 thiscall(1, word); 0x4c2dfb thiscall(1); 0x51dc43 cdecl(1); 0x42639d thiscall(2); 0x4c97b4 thiscall(0); 0x4181c6 thiscall(3) (stores a scripted dword through its third argument); 0x4eb9c8 thiscall(0); 0x4eead0 thiscall(0); 0x4fba69 thiscall(1); 0x4edae5 thiscall(0); 0x4dae88 thiscall(2); 0x4daeb5 thiscall(1) (scripted result); 0x516530 cdecl(2) (scripted result sequence); 0x50cd50 cdecl(0) (scripted result sequence); 0x47d02d thiscall(1). Globals and tables are patched into the image per scenario (`0x639893`, `0x583a29`, `0x5d0377`, `0x571ad3`, `0x5b44f0`, `0x5d162d`, `0x5b44f4`, `0x583106`, `0x58310e`, `0x583102`, `0x58310a`, the word tables at `0x59f27b` and `0x5b3790`); the oracle checks the number of bytes the function popped on every run (0, 16, 0, 0, 0, 0, 0, 0). No memory-model boundary is changed (no null page).

## Files

`src/original_methods_fl31c.h`, `src/original_methods_fl31c.c`; `tests/fl31c_direct_test.c`, `tests/test_fl31c_direct.py`; `tests/fl31c_fixtures.py`, `tests/fl31c_differential_shim.c`, `tests/test_fl31c_differential.py`; `tests/fl31c_original_oracle.py`; `tests/fl31c_mutation_check.py`; `tasks/fl31c-acceptances.json`; this file. `fl31c_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl31c_direct tests.test_fl31c_differential` -> 18 tests, OK (10 direct: 8 functions, the run-all check and the sweep; 8 differential).
- Oracle: `python3 tests/fl31c_original_oracle.py` (8 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl31c_direct_test.c src/original_methods_fl31c.c -lm` -> 9 PASS (8 functions + the bounded sweep of 300 random scenarios), no report.
- Mutation: `python3 tests/fl31c_mutation_check.py [--only <va key>]`.

## Mutation check

`python3 tests/fl31c_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 162: caught by the direct test 151, by the differential test only 2, survivors 9
```

All nine survivors are in 0x4eba54 and are equivalent on every reachable input: the dword counter `[self+0xfc6]` read with `rd16` instead of `rd32` (five places: it starts at 0 and the loop bounds are 2 and a signed word, so its high half is always 0); `0x320 -> 0x321` (it multiplies the row, which is the constant 0 of the word local `[ebp-4]`); `rds16 -> rd16` on the table word compared with 8 (equality with 8 is the same signed or unsigned); `rd16 -> rd32` on the replacement word `[self+0xb85]` (truncated by the 16-bit store).

Mutants applied by hand to copies (the direct test run on each; all CAUGHT except the last, which is equivalent): 0x4edb97 clearing a member dword BEFORE its 0x4fba69 call; 0x47cd90 family with an unsigned remainder (`%` on unsigned); 0x4db870 reading `y` after storing `x` (pair inside self); 0x4eba54 with an unsigned second-loop bound; 0x4e2faa with 25 cells instead of 26; 0x4c2790 without the second length measurement (equivalent: after the cut the length is exactly 0x19, otherwise len+1). Known gap of the tool: multi-line guards, `if (1)`, loop bounds written as expressions and double edits are not modelled.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; the world pointers `words_59f27b` and `table_5b3790` must point to host memory that mirrors those global word tables (the first writable, the second with slack on both sides of index 0 for a signed selector). Addresses that the original passes (strings, records, the pair returned by `0x4daeb5`, the buffer returned by `0x51dc43`) are 32-bit original addresses that `resolve` must map to readable (the string of `0x4c2790` also writable: it is cut in place) memory.
- `m4c2790_new_record` returns eax (0 or the record address as an original address).
- The ports are standalone; no shared parser, dispatcher or app file was edited. A host that binds the callees to ported `m<va>_*` symbols says so itself.

## Source and test hashes (sha256, at the commit named below)

| file | sha256 |
|---|---|
| src/original_methods_fl31c.c | a7ed488b8127d28467d9ac439afa783230ba67b01d93cd0c4f4ade853f609ed0 |
| src/original_methods_fl31c.h | dcef09ba6a065767261a47372480e9418ae1b0e830c571c81235bf0a0642d97c |
| tests/fl31c_original_oracle.py | d61165a8e646e7feda3cc358a7aafc0b803b421f44ccfefaba87ed3232b43fd7 |
| tests/fl31c_fixtures.py | 54b560d3eb40e10114f50b62cc2be9670b2d807632ebdf357460e45b02e62c0d |
| tests/fl31c_direct_test.c | 230d83922806e03d3f0fd6715f78a4c69de7f793aa2adfff2503e655bfed8baa |
| tests/fl31c_differential_shim.c | 1f34a62f94cd4e4a0df8e78d63801e37934a22e47f21ddacc30e223f7f967de5 |
| tests/test_fl31c_differential.py | ca8236847d0cfce757700e7c63163fb66635d31793480a8723e3ba31accadf22 |
| tests/test_fl31c_direct.py | 7084e73f2f614b4d7ed98cac0ec335d3feeed7d3fbecfb722eb2c0f5264cf982 |
| tests/fl31c_mutation_check.py | 12c297699e74cd1bc4121e858d30ba1233b94b0ede3ffeea9b5c629029f58358 |

Native library: the differential builds `tests/fl31c_differential_shim.c` + `src/original_methods_fl31c.c` into a throwaway shared object per run (no committed binary).

Commit: the ports land in `b5d7612d` (source comments for the three pick_variant symbols, the acceptances and this file are the commit after it; the branch head is the final commit).

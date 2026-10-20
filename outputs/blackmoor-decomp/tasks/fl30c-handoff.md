# FL-30 batch c (`fl30c`) handoff

Branch `claude/fl-30c` (worktree `/home/user/wt-fl30c`), based on `da2ffc67` (the FL-30 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl30c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 6 entries; none of the rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 18 test ids and accepts them, each test area names its address).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (6 of 7)

All in `src/original_methods_fl30c.c` / `.h` (symbols `m<va>_*`, world struct `Fl30cWorld`, host convention `Fl18Host` as in FL-18/26/27/28/29). One commit per function (see below). Addresses that the original stores in objects (nodes, cells, records, constants) are 32-bit original addresses here too and go through `Fl18Host.resolve`; `self`, the `cell` argument of 0x423876, the `src`/`dst` pointers of 0x41b6e2 and the `Fl30cWorld` table pointers are host pointers.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4fcb5c | 406 | m4fcb5c_set_category_master | 97/97 | 10/10 | 528 | 1f5329377b87211f51a68e00510241c345350bf0ee303ed4c7163d337c7b6960 | 4feec6951a00a65465aeec5c128621ed090e4dd8030f71e0ef2aadf212257cc5 |
| 0x423876 | 442 | m423876_unwind_chain | 132/132 | 27/28 (1 allowlisted) + 1 cut-off run | 358 | 3f77be8cebb681aa7e4f8c46fb11b0916ab566498243e4dbf02361f16e896e63 | 68ca5942ca89ab5f3a641c4d6fa7bde6c54a50b9ae8ae518b9af4ced25969e3e |
| 0x434025 | 536 | m434025_scan_entries | 154/154 | 21/22 (1 allowlisted) | 492 | d51d02a3b9109663d826d1fe5c92bfb7b6652ed97085819e8aeb59567cb3c688 | 1c8b47dd0818cbee7e5cf51258be5e791f8dcf6f991b0dc31cec6646c63067e1 |
| 0x41b6e2 | 579 | m41b6e2_lz_decode | 186/186 | 14/14 | 360 | 45ca46428759bb57d9cb262da259918a45fb944f527a65dde8dceb1789ab442c | 8bbf62784b5ec05fb5d4fb11ea2b1170aa6f7777124604f1b9d03c0f7b87b079 |
| 0x43d7f0 | 675 | m43d7f0_init_scenes | 139/139 | 16/16 | 512 | 859e65001112682f7a208b979a9e1411364f5f2a7f02b838b4bfe4a691e9948b | 07b1d252f1508c06d118b6aa71b6cbbb012853271bc96afadd9a468135e36fe8 |
| 0x4763b3 | 1650 | m4763b3_mark_runs | 408/408 | 46/46 | 648 | b957d4279a7d9e0b3cdc793bbe82ea6e8e6c543d36877ddcfa95524158ef4dee | 435160cbfa29318b25157a320bab8b028604360d76dcc24e3ac8a61ec90439dc |

Commits (in order): `45846748` 0x4fcb5c, `dab1287c` 0x43d7f0, `e1cf8a94` 0x434025, `6cd1d420` 0x41b6e2, `ced550b7` 0x4763b3, `1d3c83de` 0x423876; the handoff, acceptances and the hand-mutant script are in the commit after them (hash in the report).

Notes per function (the header `original_methods_fl30c.h` gives the byte-level contract of each):

- **0x4fcb5c** `set_category_master` (`ret 4`, thiscall, stack dword `idx`): the float table at `self + 0xb764 + idx*4`: `!(v >= 0.0f)` (an x87 `fcomp` + `test ah,1`: less or unordered, so a NaN too) stores 0, otherwise the bits are rewritten; `!(v > 1.0f)` (`test ah,0x41`) keeps the bits, otherwise 0x3f800000. Then the 32 channels (stride 0x5bb): signed word `+0x10c` == idx (sign-extended against the dword) and unsigned word `+0x132` == 1: `+0x140`, `+0x144` = `ftol(f * v * 2857.142822265625f - 2857.142857142857)`, `0x4f684a(this 0x5cf1eb, channel)`. The x87 sequence runs with the control word 0x27f (53-bit precision, the Windows default; set at the host boundary by the harness), so each step is one rounding to double and the port uses doubles (`-ffp-contract=off` in every build); `__ftol` (0x50ce04) is NOT stubbed: the oracle runs the original library code, the port reproduces it with `ftol_low32` (truncate; NaN or outside int64 gives the integer indefinite, low dword 0). Constants (0.0f at 0x52db78, 1.0f at 0x52cbf4, float 0x52e4e0, double 0x52e4d8) were read from the image. Fixtures include NaN (quiet and signalling), infinities, denormals, -0.0, out-of-int64 products and idx = -3 .. 0x20 (channel 0x20 lies behind the loop and is given matching words so a bound slip is visible).
- **0x43d7f0** `init_scenes` (plain `ret`): `[0x5d15a5] = 1`; 0x4d3ced on 0x61c387; two copy-and-clear dwords (`0x5bb1d2` -> `0x5b15d6`, `0x5bb1da` -> `0x5b1606`); six byte flags (non-zero byte) set their dword to 1; then the other 46 thiscalls (no arguments) in the order of the table `kInitCalls` (the addresses come from the disassembly; the differential compares callee and ecx of all 47 in order, with a probe of all 19 globals at each call).
- **0x434025** `scan_entries` (thiscall, plain `ret`): see the header for the control flow. The endless-loop guard `mov eax,1; test eax,eax; je 0x434233` (0x4340dc..0x4340e3) is always true: its taken direction is allowlisted; the target 0x434233 is reached through 0x43416e and 0x43422c, and every one of the 154 instructions runs. The count-above-0x3e6 report needs 1000 stores: scenario 'big' runs 500 entries with two stores each (the stub answers 40, 0, 40 per entry), which is the reason for the larger call and result tables in the shim.
- **0x41b6e2** `lz_decode` (`ret 0x10`; the fourth stack dword is overwritten by the function's own counter, so it is not an input): ring buffer at 0x56f354 (world pointer `ring_56f354`; bytes 0..0xfed set to 0x20, the last 18 keep their content, both compared). Fixtures build real LZ streams (flag byte, literals, match tokens, source bytes = token + index) and cut the length at each of the four exit tests.
- **0x4763b3** `mark_runs` (`ret 8`): see the header. The first marking block tests the HORIZONTAL length (`[8d4] - [8d2] == 2`) before the vertical 3 and 4 tests, exactly as the original; the port keeps that and a hand mutant (below) checks it. 0x50ca3e is called with four dwords (trace) and with three (text of the score); the stub logs four, and the fixtures' `TRIM` hook drops the fourth dword of the three-dword calls (it is the caller's local `self`, not an argument).
- **0x423876** `unwind_chain` (`ret 8`, recursive): the recursion is executed as original code in the oracle (the function cannot stub its own entry) and as a native recursive call; the callees 0x423aae, 0x423a30 (with a 4-byte deref of the local `cur`), 0x4234dd, 0x4235fd, 0x50ca3e (two or three dwords, `TRIM`), 0x51dc6c, 0x52139c (stdcall 3), 0x44a2b7, 0x4c97b4 are recording stubs. The cell argument is replaced by `[t+4]` after 0x4235fd, and the final `flag` free uses the replaced cell.

## Dropped (1 of 7)

- **0x4c334f** (867 bytes): unreachable block behind an always-true guard, so it stays pending per the packet ruling. The local `[ebp-0x6c]` is written only once, `mov dword [ebp-0x6c], 0` at 0x4c3360, and read only at 0x4c3693 (`cmp dword [ebp-0x6c], 0; je 0x4c369d`); the `je` is therefore always taken and `xor eax, eax` (0x4c3699) and `jmp 0x4c36aa` (0x4c369b) can never run (checked: those are the only two references to that local in the function; no `lea` of it). It is also a BMP writer with CRT file calls (0x50d0a9, 0x50e493, 0x50cee4), which would have been expensive.

## Deliberate divergences and native rejections (not original behaviour)

- **0x423876**: a node whose type is neither 1 nor 2 (and not type 1 with `[+0x44] != 0`) makes the original loop forever (`jne 0x4239c8` at 0x423930, back to 0x4238c1, with `done` never changing). The oracle shows this mechanically (`hang_run_423876`: the original on a type 3 node does not return within 20000 instructions, the run is cut off and its instructions and jump pairs are added to the coverage of the function); the port returns at once. The port also returns when an address it must dereference does not resolve (node, `t`, the cell `[t+4]`, the object `c`): in the original that is a wild access.
- **0x4763b3**: native rejection: when the record address at `[0x5bb5e5 + word[self+0x22]*0x8d]` does not resolve, the port returns before any effect (the original would read through it in the second scan and fault).
- Nothing else is bounds checked, as in the original: the scans of 0x4763b3 (a start outside the grid runs until a word wraps), the destination of 0x41b6e2 (up to 18 bytes per two source bytes), the source length (the original tests `si == srclen` by equality; an unreachable length reads on), the entry counts of 0x434025 (index 0x3e8 and above overwrite the table at self+0x3084, with report calls, as the original does), the table index `idx` of 0x4fcb5c.
- Word arguments: 0x4763b3 and 0x423876 use their stack dwords in full (they `imul`/`cmp` the dword); only the stores to words use the low 16 bits.
- 0x41b6e2 has no defined result (`eax` is left over); the others are `void`.

## Allowlisted untaken jump directions

The differential and the oracle require both directions of every conditional jump of every function; allowlist in `fl30c_fixtures.UNTAKEN_ALLOWED` (an entry that is taken fails as stale):

- 0x434025: `0x4340e3 je 0x434233` taken: the guard after `mov eax, 1; test eax, eax` is always true (see above). Under the owner ruling on always-true guards no instruction is unreachable here (all 154 are executed), but root should confirm that crediting the row with this one allowlisted edge is acceptable; if not, drop 0x434025 from the acceptances.
- 0x423876: `0x42393d je 0x4239c8` taken: reached only after `[node+0x44] != 0` was just established for the same type 1 node, so the jump is never taken. Same remark for root. (The two jumps into the endless loop, `0x4238d9 jne 0x42392a` and `0x423930 jne 0x4239c8` taken, are covered by the cut-off run, not allowlisted.)

## Files

`src/original_methods_fl30c.h`, `src/original_methods_fl30c.c`; `tests/fl30c_direct_test.c`, `tests/test_fl30c_direct.py`; `tests/fl30c_fixtures.py`, `tests/fl30c_differential_shim.c`, `tests/test_fl30c_differential.py`; `tests/fl30c_original_oracle.py`; `tests/fl30c_mutation_check.py`, `tests/fl30c_hand_mutants.py`; `tasks/fl30c-acceptances.json`; this file. `fl30c_fixtures.py` is self-contained (it carries its own copy of the harness of the FL-29 fixtures, with the `TRIM` and `EXTRA_RUNS` additions).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl30c_direct tests.test_fl30c_differential` -> 14 tests, OK (8 direct: 6 functions, the run-all check and the sweep; 6 differential).
- Oracle: `python3 tests/fl30c_original_oracle.py` (6 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl30c_direct_test.c src/original_methods_fl30c.c -lm` -> 7 PASS (6 functions + the bounded sweep of 300 random scenarios), no report (clang's sanitiser runtime is not installed in this container, gcc was used).
- Mutation: `python3 tests/fl30c_mutation_check.py [--only <va key>]` and `python3 tests/fl30c_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of fixture memory at the call. Shapes taken from the call sites: 0x4f684a thiscall(1); 0x4d3ced and the 46 other initialisers of 0x43d7f0 thiscall(0) (probe: all globals of the world); 0x4347b8 thiscall(1), 0x434773 thiscall(1), 0x42639d thiscall(2), 0x4c97b4 thiscall(0); 0x50ca3e cdecl (stub of 4 dwords, `TRIM` to the real arity); 0x44a2b7 cdecl(1); 0x423aae thiscall(1), 0x423a30 thiscall(1) (deref 4 bytes of the local), 0x4234dd thiscall(2), 0x4235fd thiscall(0), 0x51dc6c cdecl(1), 0x52139c stdcall(3). Not hooked: `__ftol` 0x50ce04 (original code runs), and the function's own recursion. Host/OS boundaries modelled outside the function: the x87 control word 0x27f (0x4fcb5c only). Globals and tables are patched into the image per scenario (`0x63a4cd`, the records at `0x5bb5e5`, the ring at `0x56f354`, the 19 globals of 0x43d7f0).

## Unverified

- Callee calling conventions are read from the call sites only: the callers restore `esp` after the cdecl calls (`add esp, N`) and after none of the thiscall or stdcall calls, so those callees pop their own arguments (cleanup 4 * arguments) and the stubs do the same; the cleanup of a callee that is never entered cannot be proven from the bytes. The oracle checks only the number of bytes the function under test popped itself (`SPECS.cleanup`: 4, 8, 0, 0, 16, 8).
- Not exercised: a callee that changes `self`, a node, a cell or a global that the function reads again afterwards (for example 0x4d3ced changing `0x5bb1d2` before 0x43d7f0 tests it; 0x4347b8 changing the table that 0x434025 scans; 0x423a30 changing the node chain). The ports re-read like the original, but the stubs never change the data.
- The names of the functions and of the fields are descriptions of what the code does, not recovered source names. 0x4763b3's first-block quirk (horizontal length tested for the case 2) is reproduced as it is, not interpreted.
- 0x4fcb5c: signalling-NaN payload propagation of the x87 is not modelled beyond what the clamp needs (a NaN never reaches a copied value: the first compare sends it to 0).
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl30c_mutation_check.py --only <key>` per function (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line `if (...) return;` guard deleted, `rd16`/`rd32`/`rds16` width swap):

| function | mutants | caught by the direct test | by the differential only | survivors |
|---|---|---|---|---|
| 0x4fcb5c | 21 | 17 | 3 | 1 |
| 0x43d7f0 | 103 | 19 | 84 | 0 |
| 0x434025 | 47 | 37 | 6 | 4 |
| 0x41b6e2 | 24 | 22 | 2 | 0 |
| 0x4763b3 | 164 | 109 | 31 | 24 |
| 0x423876 | 56 | 42 | 7 | 7 |

All 36 survivors were read and are equivalent on every input the original can take (or are the native rejections):

- 0x4fcb5c: `> 1.0f` -> `>= 1.0f`: at exactly 1.0 both write the same bits (0x3f800000).
- 0x434025: the four `rd32` -> `rd16` swaps on the counts `[+0x5f64]` / `[+0x5f68]` (one in the inner scan bound, three in the store index and the report test): the counts stay below 0x10000 for any object that fits memory (the loop would read 65536 entries), so the high half is always 0 in a valid run.
- 0x4763b3: all 24 are signed-versus-unsigned or word-versus-dword swaps on grid positions (`rds16` -> `rd16`, `rd16` -> `rd32`): the positions, the scan words and the run lengths are non-negative and below 0x8000 for any cell inside the grid, which the caller guarantees (a start outside the grid is the uncontrolled case above).
- 0x423876: five `guard deleted` mutants remove the NATIVE REJECTION returns (`node == NULL`, `cp == NULL`, `tp == NULL`, `node == NULL || cell == NULL`); the fixtures never feed an unresolvable address (the original would fault), and the direct test covers the endless-loop rejection separately (the `else { return; }` of the endless-loop case is not a one-line guard and the tool does not mutate it; it was not mutated by hand either, the direct test case with the type 0 node checks the return). Two `rd32` -> `rd16` swaps on the node type / the next link (type 1 or 2 are the only legal types, so the high half is 0; a type with a non-zero high half is the endless-loop case).

Mutants applied by hand with `tests/fl30c_hand_mutants.py` (single multi-line edits that the tool cannot model; all CAUGHT by the differential test): 0x423876 recursion with flag 0, 0x4234dd arguments swapped, cell not replaced by `[t+4]`; 0x4763b3 vertical length tested for the case 2 in the first block; 0x41b6e2 key not advanced in the literal branch; 0x43d7f0 flag store moved after the first call; 0x434025 `sel` reset for every entry; 0x4fcb5c second clamp writing 0x3f800001.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl30cWorld` carries `word_63a4cd` (debug flag), the 19 scalars of 0x43d7f0 (mirrors of the original globals; flush before and resync after each `Fl18Host.call`), and two table pointers (`ring_56f354`: 0x1000 bytes that mirror 0x56f354; `records_5bb5e5`: the records of stride 0x8d with slack for a negative index).
- `m423876_unwind_chain` and `m4763b3_mark_runs` resolve original addresses through `Fl18Host.resolve`; the host must answer for every node, record, `t` structure and `c` object the game can hold, or the ports return silently (marked NATIVE REJECTION). The `cell` argument of 0x423876 is a host pointer to a dword cell (the original passes its address).
- `m4fcb5c_set_category_master` needs a build with `-ffp-contract=off` and IEEE doubles (no x87 extended precision, no fast-math) to be bit-identical to the original's 53-bit x87 sequence.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that adds this file)

| file | sha256 |
|---|---|
| src/original_methods_fl30c.c | a60441e0d3aa473cbdb780857c1dd6b423e5a143e20ab575a578f3bf23cb2d9c |
| src/original_methods_fl30c.h | 281be7a605380da6e9deb42c2c76dba06aa82ec4376ead0ebec541d764bd5b9b |
| tests/fl30c_original_oracle.py | fbe461e57387aac219b5354144db90d64eb10993394378d445140a979f1db7fc |
| tests/fl30c_fixtures.py | 50b9af6800e5ee654f3ddf6e64f06c7eeef0701c46c3691439c4eb56e60bc9fa |
| tests/fl30c_direct_test.c | 25d3eef64c97427c4342c72176bc92e7b74b394be5b946d1c882b2cc1aaee6ec |
| tests/fl30c_differential_shim.c | 27f0837933fcd6cd9eb90f68c5a13022e8e686757d279716b79ca39ae4599314 |
| tests/test_fl30c_differential.py | f558aa7408fc7eb7a7816dbd9ec28f6314d12b1c27663638940fd256a26297ab |
| tests/test_fl30c_direct.py | 8fcd6a6c5151cd1e951823547258e2aa0d1f4cb0ba4df79e9ab17037ba99b4a2 |
| tests/fl30c_mutation_check.py | fb869c9844bbd1924984cb74e4a3a6d1ae30c1989b41d0832aeab26a1d35cbd1 |
| tests/fl30c_hand_mutants.py | 239d2805d9dacbfd8ff146f47ed93979a4a5eff47f2251d78deff8d18aef4fb3 |
| tasks/fl30c-acceptances.json | 88dc17f959fc803558fa3258a7003743fd57f046c28f1e5bdb5c78bb1883ea5c |

Native library: the differential builds `tests/fl30c_differential_shim.c` + `src/original_methods_fl30c.c` into a throwaway shared object per run (no committed binary).

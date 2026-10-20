# FL-31 batch a (`fl31a`) handoff

Branch `worktree-agent-a46e53b8bbdee7a88` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a46e53b8bbdee7a88`), based on `6b8fe413` (the FL-31 packet commit, fast-forwarded in because the worktree had been created one commit earlier at `a14f287b`). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl31a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries; none of the nine rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 27 test ids and resolves each).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (9 of 9, none dropped)

All in `src/original_methods_fl31a.c` / `.h` (symbols `m<va>_*`, world struct `Fl31aWorld`, host convention `Fl18Host` as in FL-18/26/27/28/29). Commits: `e43eee18` (0x47b200, 0x47b3bc, 0x47d640), `b1f2895f` (0x47b709, 0x47ba79, 0x47badf), `b7cef56a` (0x47b321, 0x47c049, 0x47b23b), then the commit that closes two mutation survivors and adds this handoff (see the end). Commits are per group of three functions, not per function: the three share all of their test files, so each commit has to carry the shared files anyway.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x47b200 | 31 | m47b200_construct | 12/12 | 0/0 | 8 | 891dd6105fc232bcf535c921db5e600a50055f1a17f6eea7a7bc665c2681b286 | afff28070eb76b395ab88292f4f2964cb884aa1171a1aa0a8cd8ea9364e7027d |
| 0x47b3bc | 52 | m47b3bc_mark_entry | 18/18 | 4/4 | 48 | 9c55a340dd3220b4705acaf62feff4daaca8db2bd587b3b928fc621b401a9071 | 2c8d56328e575f15aac4243482ee8f3e66e3e96ef0c061f2e9216ec1e3b98d9b |
| 0x47d640 | 55 | m47d640_mark_entry | 20/20 | 4/4 | 48 | 2f35576ff28e2190a2a543bbfbe9379ea7cd7e5b85f34fd59366a75df9546c93 | f75314f967435c4dd7d572ed3b8ae278c98b79cd41d37eb19fb0133c8d2bad32 |
| 0x47b709 | 94 | m47b709_set_selector | 20/20 | 0/0 | 48 | 7181e089a11b2384a32a094da3107223c3fcee58364e508088f8a59dbc6e6072 | 8dfe643b75b117c5993452baa0a327c9fcde6f6f39a73768e2266de0a82789a0 |
| 0x47ba79 | 102 | m47ba79_expire_links | 29/29 | 4/4 | 60 | f4d6cd3f5812da51eb70587d862f8471ca45355173bde4db903e284d65f15083 | e277cc203bbbc5b9f1a3415eb30322da07a658f7a49acb508c2b6b7e5a904f84 |
| 0x47badf | 119 | m47badf_check_range | 34/34 | 8/8 | 162 | 662c9e03802dcfa3230e13b55341332eb2f9f4369aa1783c0fdd2b162a8b8f40 | 15901b7c1a05ea7ad2dbba5434982980285d16328255d862802c16dc105c5658 |
| 0x47b321 | 155 | m47b321_release | 50/50 | 8/8 | 52 | abb9cbf7c8bb2918d5c39402b4187eb1cf1fabe9cca8d48e56daf95b998a6f95 | 0a5837e737b02db32eabbcc5e5f879eccb2bca1f7355ce1615867df99c6cba7d |
| 0x47c049 | 167 | m47c049_pick_slot | 51/51 | 8/8 | 156 | 8fccd1a013deaf3b8ac628999275e18c29a85d09634b748e3cf340eecabc0912 | cf6749a581237e69ea1b98dc83be764fd27a73d3899e60f6a5b6aaf418cf487f |
| 0x47b23b | 230 | m47b23b_reset_fields | 47/47 | 0/0 | 8 | 3d7bea206056471d4e1d590ff187cbe33e0d07a6c9f779473edba7af033cb864 | a4f9e3a25088b9091adec3ef3cbc76d49c083705d3653f6c233c15304af09ea8 |

No jump direction is allowlisted: `fl31a_fixtures.UNTAKEN_ALLOWED` is empty and every conditional jump of every function is taken both ways (the 0/0 rows have no conditional jump). None of the nine has an unreachable block behind an always-true guard (checked from the disassembly: 0x47c049 has the divide, whose faulting inputs are separate scenarios; see below).

Notes per function (the header `original_methods_fl31a.h` gives the byte-level contract of each):

- **0x47b200** constructor (returns `this`, the port returns `self`): `[self] = 0x52d568`, then `0x47b23b(this self)`. The callee is host-stubbed (it is also in this batch, as `m47b23b_reset_fields`; the host decides which one it binds). The fixture probes the first 16 bytes of the object at the call to prove the store comes first.
- **0x47b3bc / 0x47d640** the same record store with different gates: dword `[self+0x24]` (dword compare; fixtures use values with a zero low word) / byte `[self+0x57]` (the bytes around it are non-zero in the gate-0 case); the index is the signed word `[self+4]` / the unaligned signed word `[self+0x23]`, `-1` skips, `-2` and `-3` are indices; the table is `0x5d15a5 + i*0x4a` with slack below index 0.
- **0x47b709** (`ret 4`): the word argument is sign-extended into `[0x5c39e5]`; `[0x5b44f0]`/`[0x5b44f4]` are written and read back for `[0x5d1631]` (= 0x5b161c); the garbage upper half of the stack dword is never read. All seven globals are compared after the run.
- **0x47ba79**: `GetTickCount` (import `0x52a23c`) goes through `Fl18Host.tick`; the compare with `[self+0x38]` is unsigned (`jbe`; fixtures include 0x80000000 against 0x7fffffff and the reverse). The two object pointers carry non-zero low bytes so that a store one byte off shows; the second pointer is read after the first store. One pass of the cycle points both at the same object.
- **0x47badf**: all four compares are signed; the fields are re-read at each use; `[ [self+0xc] + 0x341 ]` is an unaligned dword behind an original address. 81 (a,b,c,d) order combinations including the signed extremes.
- **0x47b321**: `0x4c2dfb` gets `self + 8` as a host pointer to the field (the original passes the address of the field; compared as `region + 8`); `0x51dc6c` is called with the pointer value and the field is cleared afterwards (probes at each call prove the order); `0x4d3992` takes the zero-extended word (the original pushes `eax` whose upper half is left over from `this`; the callee reads a word, and the differential compares the low 16 bits through `WORD_ARGS`).
- **0x47c049**: see the divergence below. The first scan and the draw loop re-read `[self+0x2a4]` and `[self+0x18]` at every use; slot compares are dword compares (slots hold 0x10000, 0x100, ...); a count above 16 bits (0x10005) is covered; the slot behind the last counted one is free but not looked at; a negative count skips the scan; the rand results include negative values and 0x80000000 (signed `idiv`, remainder takes the sign of the dividend).
- **0x47b23b**: straight line, stores in the original order (words at +6, +4, then eighteen dwords); every other byte of a 0x400-byte random object is compared unchanged.

## Dropped

None. The spill row 0x4c7623 was not touched.

## Files

`src/original_methods_fl31a.h`, `src/original_methods_fl31a.c`; `tests/fl31a_direct_test.c`, `tests/test_fl31a_direct.py`; `tests/fl31a_fixtures.py`, `tests/fl31a_differential_shim.c`, `tests/test_fl31a_differential.py`; `tests/fl31a_original_oracle.py`; `tests/fl31a_mutation_check.py`, `tests/fl31a_hand_mutants.py`; `tasks/fl31a-acceptances.json`; this file. `fl31a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner subclass `Original27` with the edge hook, the stub constructor, the call-log normaliser, the conditional-jump finder), so the oracle needs that file present (it is on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl31a_direct tests.test_fl31a_differential` -> 20 tests, OK (11 direct: 9 functions, the run-all check and the sweep; 9 differential).
- Oracle: `python3 tests/fl31a_original_oracle.py` (9 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl31a_direct_test.c src/original_methods_fl31a.c -lm` -> 10 PASS (9 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices, counts and pointers inside the fixture buffers (the unsafe inputs are the documented rejections below, covered by hand-derived cases, not by the sweep).
- Mutation: `python3 tests/fl31a_mutation_check.py [--only <va key>]`, `python3 tests/fl31a_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes of fixture memory at the call. Callee shapes taken from the call sites: 0x47b23b thiscall(0) (probe: `self` 0..0x10 / 0..0x30); 0x4c2dfb thiscall(1) (probe `self` 0..0x30); 0x51dc6c cdecl(1) (probe `self` 0x10..0x20); 0x4d3992 cdecl(1) (probe `self` 0..0x30); 0x50cd50 cdecl(0), scripted results (probe: the first 0x40 bytes of the slot array); the import slot `0x52a23c` (GetTickCount) entered through the patched IAT entry, scripted result. Globals and tables are patched into the image per scenario (`0x5d15a5` records, the seven globals of 0x47b709). The oracle checks the number of bytes the function popped on every run (4 for 0x47b709, 0 for the others). No `rep` string move, no x87, no indirect jump in this batch. One CPU boundary: the two fault scenarios of 0x47c049 (below) are run to the faulting instruction and the run must stop exactly at `0x47c0a9`.

## Deliberate divergences and native rejections (not original behaviour)

- **0x47c049, n == 0 and (n == -1, rand result INT32_MIN)**: the original executes `idiv dword [self+0x2a4]` and takes a CPU divide error (#DE) at 0x47c0a9. The native port returns `INT32_MIN` right after the one rand call (it can never be a legitimate remainder, whose magnitude is below |n| <= 2^31). The oracle runs both inputs and asserts that the original stops at exactly 0x47c0a9 and has changed nothing; the differential compares the call prefix, the unchanged memory and the status `INT32_MIN`. The acceptance keeps class `native_oracle_verified`; its note says so.
- **0x47c049, the draw loop** is unbounded as in the original (a degenerate rand that never names a free slot never returns). The host's rand is the CRT rand; no bound is invented.
- Nothing else is bounds checked, as in the original: record indices of 0x47b3bc / 0x47d640 (a word index outside the table writes outside it), the slot indices of 0x47c049 when rand is negative and a slot is free (the original reads before the array), the pointers of 0x47ba79 and 0x47badf (a pointer the host cannot resolve faults natively as the original would fault) are caller-validated; the fixtures keep them inside their buffers.
- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half). 0x47b200 returns `self` (eax = this, checked on the original side by the oracle and on the native side by the shim), 0x47c049 returns the full eax.

## Unverified

- Callee calling conventions are read from the call sites only (esp is restored by `add esp,4` after 0x51dc6c and 0x4d3992, which proves cdecl for them; 0x4c2dfb and 0x47b23b receive ecx and no stack argument beyond the one pushed for 0x4c2dfb, its callee-pop count is not provable from these bytes). `0x51dc6c` is the CRT free by shape only; `0x50cd50` is assumed to be the CRT rand because the result is used as a dividend; both are hints, not recovered names.
- Not exercised: a callee that changes `self` or a global that the function reads again afterwards (for example 0x4c2dfb changing `self+0x14`, or a rand callee changing the slot array); the ports re-read like the original (0x47c049 reads the count and the slot pointer again for every access), but the stubs never change them.
- Swapping the order of the two clearing stores of 0x47ba79 cannot be observed on a valid input: they hit disjoint dwords, and the only alias that would show the order (`[self+0x1c]+4 == self+0x20`) makes the original fault at address 0 afterwards. The port keeps the original order.
- The meaning of the fields is a description of what the code does, not recovered source names. No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl31a_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 118: caught by the direct test 110, by the differential test only 8, survivors 0
```

The first run had two survivors, and both were fixture gaps, now closed: (1) 0x47ba79 `wr32(self, 0x1c, 0)` -> `0x1d` survived because the fixture pointer was 0x20010000 (low byte 0, so a store one byte off was invisible); the object pointers now have non-zero low bytes (0x...11, 0x...23); (2) 0x47c049 `n = rd32(self, 0x2a4)` read as `rd16` in the draw loop survived because every count was below 0x10000; a count of 0x10005 with a free slot is now in both the direct test and the fixtures (6 % 0x10005 = 6, 6 % 5 = 1).

Hand-written mutants (`python3 tests/fl31a_hand_mutants.py`, all CAUGHT by the direct test; 13 of 13): signed instead of unsigned tick compare (0x47ba79); unsigned instead of signed first compare (0x47badf); the field cleared before the free call (0x47b321); `self` instead of `self + 8` (0x47b321); a sign-extended instead of zero-extended word argument (0x47b321); a zero-extended instead of sign-extended selector (0x47b709); the slot not marked and an unsigned modulus (0x47c049); `return NULL` and the store after the call (0x47b200); the word at +6 not reset (0x47b23b); a dword read for the byte gate (0x47d640); a 16-bit unsigned index (0x47b3bc).

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled (the hand mutants cover the shapes that matter here).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve` / `tick`; `Fl31aWorld.table_5d15a5` must point to host memory that mirrors the record table at 0x5d15a5 with slack for a negative index (the word index is signed); the seven globals of `m47b709_set_selector` are read and written through the world (the host copies them back to its own storage or points the world at it).
- `m47c049_pick_slot` returns the slot index; `INT32_MIN` means the original would have faulted (count 0, or INT_MIN with count -1): the host must not use the result. A host that binds `0x47b23b` to `m47b23b_reset_fields` and calls it from `m47b200_construct` / `m47b321_release` through `Fl18Host.call` keeps the original call structure.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that closes this batch)

The hashes below are of the files in the final commit named in the report.

| file | sha256 |
|---|---|
| src/original_methods_fl31a.c | b9bdfef57b4d7f149b675637f5b32bf9508ed601d306b8b8c69b61cb8ccfee9b |
| src/original_methods_fl31a.h | a11a24dc57211de615c429f4e305302a09aec39b327982cfd92188d925c8d2cd |
| tests/fl31a_original_oracle.py | c7f87de8d332e0b0ff0dfbf8ff36f200a8a5e1df30400e1c701acbf6f7e2ef15 |
| tests/fl31a_fixtures.py | f561255e26c515c25edd05f17696b16d030c1908414cc7c7ed83575e2c768b00 |
| tests/fl31a_direct_test.c | 31d228fbbdc86154e9daa0247005fd226934222bdf68bea452e92a28090706f6 |
| tests/fl31a_differential_shim.c | de6361982acb3e80e487af8ae205dfb9bbbb9f0dcca9452a47a13e580ce1602d |
| tests/test_fl31a_differential.py | 274aa47644c0e4a8989190bcf3acb99174ffd2d3948db5ad3ff82e421c55355e |
| tests/test_fl31a_direct.py | eaedb10c2373f5d025f8f4f38a647b71b2d2d4c6a0d3cf85ccf6b463a729e1b6 |
| tests/fl31a_mutation_check.py | 84d339f0e2f60215eca658e585a61d08825a2096a58b5dc35f5fb01f7dc0cde1 |
| tests/fl31a_hand_mutants.py | 4a0c86cf710fa27cc75a1827d73067c63ee7f3b066f224ee3fb576035ca88db0 |

Native library: the differential builds `tests/fl31a_differential_shim.c` + `src/original_methods_fl31a.c` into a throwaway shared object per run (no committed binary).

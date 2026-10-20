# FL-30 batch d (`fl30d`) handoff

Branch `claude/fl-30d` (worktree `/home/user/wt-fl30d`), based on `da2ffc67` (the FL-30 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl30d-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 5 entries; none of the rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 15 test ids and accepts them).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (5 of the 6 batch rows)

All in `src/original_methods_fl30d.c` / `.h` (symbols `m<va>_*`, world struct `Fl30dWorld`, host convention `Fl18Host` as in FL-18/26..29). Commits: `91cebba2` (0x4e2e05), `4b198f25` (0x4c2a8d), `eeb45fca` (0x48d3cb), `ffe7afb1` (0x4f684a), `b86409d6` (0x414692); the handoff and acceptances are in the commit after them. Addresses that the original passes or stores (record, cell, stream, string, vtable) are 32-bit original addresses here too and go through `Fl18Host.resolve`; only `self` and the `Fl30dWorld` pointers are host pointers.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4e2e05 | 421 | m4e2e05_copy_state | 117/117 | 4/4 | 112 | e4abf93033e4ca8ec59b65125eaf4c7bd0c5a47b884ef33ecf014cc9c6e9db9f | 403e9dd3794e6b312cddbc0aabc5064fc7e5ad46ba84e3180fc34098e605ec25 |
| 0x4c2a8d | 429 | m4c2a8d_make_record | 136/136 | 6/6 | 148 | cf49ff442b6e4acc577058c2aa5c5eb3ff83ca1e95d6a569cbfd458c593002eb | 9e30a70ee2613a1ea7fb608e88a98b56478e5c3e71814992f28c9609cc451f75 |
| 0x48d3cb | 553 | m48d3cb_select_entry | 124/124 | 22/22 | 258 | d051801cfbc366e5ad6dcb9bad6cb9ae4d835da62ebefdbf903ade6722f79887 | 24c7997adcd6e49ebf1cc544724aacb8770595cf8b5831aa00942d01edd94b2b |
| 0x4f684a | 564 | m4f684a_prepare_entry | 137/137 | 16/16 | 264 | 7cf8d33a447a859d579d7742307f8ae7507838e02924a53c1bc8248af35c0b3a | ec0a5c5d12137f671987aea9599e247b21fbc05d82f194c3af9ded151225a56e |
| 0x414692 | 693 | m414692_read_block | 224/224 | 8/8 | 185 | d51d118111a5865f931b1f1cb0f388233486c1367ea3657dec04b5d904421159 | a14081d6c878930bce560a0ee3bc9e67b11c07f016e3d583ca133dde909f8966 |

No allowlisted untaken jump direction in any of the five: every instruction and both directions of every conditional jump are executed. The headers in `original_methods_fl30d.h` give the byte-level contract of each function; in short:

- **0x4e2e05** `copy_state` (thiscall, plain `ret`): zeroes the dwords 0x5a1e54/0x5a1e58, copies `signed word [self+0x1471] * 0x29` bytes from `self+0x457b` to 0x5a1e62 (dwords then bytes), stores the word at 0x5a1e5c, calls `0x4e3ade(this self)`; then per first-byte compare of the strings at `self+0x139d` / `self+0x13e3` against the globals bytes 0x63a9e4 / 0x63a9e8 sets the flag words 0x5a1e5e / 0x5a1e60 and copies the NUL-terminated strings, words and the dword (sign-extended) to 0x5a2664, 0x5a2685, 0x5a26a6.., 0x5a434c, 0x5a4371.. in the original order (a first string of over 0x21 bytes is overwritten by the second, tested). The destination globals are a host mirror `Fl30dWorld.block_5a1e54` of 0x2540 bytes.
- **0x4c2a8d** `make_record` (thiscall, `ret 0x10`, returns the record address): two allocations through 0x51dc43, the 0x59 byte clear, `size = w * bpp * h` as 32-bit signed products, name copy cut at 0x18 characters in the caller's buffer (a visible side effect, compared), all field stores. Both allocation failures report (0x42639d, 0x4c97b4) and return 0 as in the original; no crash path.
- **0x48d3cb** `select_entry` (thiscall, `ret 8`): selection 0x2766 / 0x2765 / other (the compare is on the sign-extended low word of the stack dword, so 0x12765 is 0x2765 and 0xd89a is not 0x2766); for 0x2765 the two boxes of four signed dword tests (`jl`/`jg`) on `p + k*16 + 0x203..0x20f` against `p + 0x2f5..0x301` and `p + 0x307..0x313` select `[0x5b44f0]`; `k` is a signed word (negative k tested), `p` comes from the table at 0x5bb5e5 (stride 0x8d, signed index word `[self+0x1e]`).
- **0x4f684a** `prepare_entry` (thiscall, `ret 4`, returns eax 0 or 1): see divergences for the x87 part.
- **0x414692** `read_block` (thiscall, `ret 0xc`): three allocations; see divergences for the failure paths.

## Dropped

- **0x41137f (751 bytes): unreachable block behind an always-true guard, stays pending.** At 0x4113e3: `movsx eax, word ptr [edx+0x12b]` (a sign-extended 16-bit value, at most 0x7fff) then `cmp eax, 0x9c40` / `jl 0x411429`. 0x9c40 = 40000 is above every sign-extended word, so the `jl` is always taken and the report block 0x4113f4..0x411428 (`push` of the word, `call 0x50ca3e`, `call 0x52139c`, `call 0x4c97b4`) can never run. Under the packet's ruling the row is not credited; no code was written for it.
- **0x4c36b2 (1451 bytes, the spill row): not attempted.** The condition for it (all six rows finished) was not met because 0x41137f is dropped; it stays in the pool.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of fixture memory at the call. Callee shapes taken from the call sites: 0x4e3ade thiscall(0) (probes: the first 0x600 bytes of the mirror and 0x50 bytes at 0x5a2664); 0x51dc43 cdecl(1) (probes: the record/cell/self bytes named in the fixtures); 0x42639d thiscall(2); 0x4c97b4 thiscall(0); 0x50ca3e cdecl(4) in 0x4c2a8d/0x414692 and cdecl(5) in 0x4f684a; 0x44a2b7 cdecl(1); 0x4f709c thiscall(0) (probe: `self` 0x3c0..0x3d0); the vtable entry at `[vt + 0x3c]` of 0x4f684a (stub page address `0x7e000900`, ecx = obj logged, 2 stack arguments, pops 8; probes: the two clamped dwords and `self`). Globals and tables are patched into the image per scenario (the mirror at 0x5a1e54, `0x63a9e4`, `0x63a9e8`, the table at 0x5bb5e5, `0x639895`, `0x639893`, `0x5b44f0`, `0x5b44f4`, `0x5d0377`, `0x5d162d`, `0x5d1631`, `0x5d1639`, `0x5c39e5`, `0x5bb57b`, `0x5c39e3`, `0x63a4cd`); the oracle checks the number of bytes the function popped on every run (0, 16, 8, 4, 12). Two oracle-only notes:

- **0x50ce04 (the CRT float-to-integer conversion) is NOT stubbed in the oracle of 0x4f684a**: the original bytes (save control word, set truncation, `fistp`, restore) run in Unicorn with the x87 control word 0x27f (the Windows process default, as in FL-28), so the clamp results come from the original conversion. The native port computes the same value in C (`clamp_ftol`: `v = (double)value; use = (v <= -2857.142857142857) ? constant : v; (int32_t)use`) and does not call the host for it; the differential compares the stored dwords of both sides, over the values -2^31, -3000, -2858, -2857, -1, 0, 5 and 0x7fffffff in both fields.
- **Stop at the reporting call (0x414692 only, `Original30` in `tests/fl30d_fixtures.py`)**: in the 105 scenarios (21 profiles, 5 passes) where an allocation fails, the original goes on through a null pointer and the port rejects, so the original is made to return (EIP = the stop address) as soon as the stub for 0x4c97b4 has returned its first call. Every instruction up to there is the original's, nothing the original decides is replaced, and the stack-pop check is skipped for those runs. The instructions after the failure reports (the copy code) are executed by the success scenarios, so no zero page is mapped.

## Deliberate divergences and native rejections (not original behaviour)

- **0x414692, an allocation returns 0 (three reachable branches where the symbol DELIBERATELY DIVERGES)**: after the report block (0x50ca3e, 0x42639d, 0x4c97b4) the original stores through address 0 (`mov [ecx], dx` with ecx = 0 after the first failure, `rep movsd` with edi = 0 after the second and third). The port returns 1 right after the report calls of that allocation and does nothing else. The differential requires that the effects before the report (the cell `[p0]`, `self+0x1c`/`+0x20`, `[B]`, `[B+2]`, `[B+0x1e]`, the cells `[p1]`/`[p2]`, and the ordered call log up to and including 0x4c97b4) equal the original's state at that point, byte for byte, and that the port returns 1.
- **0x414692, negative count words** (`signed word [B]` or `[B+0x1c]` < 0): in the original `count * 0x16` / `* 0x12` is passed to the allocator as a huge unsigned size; the port returns 1 before that allocation call (the effects before it are the original's). Direct test only (the original cannot be run on it: it would copy about 4 GB).
- **0x4e2e05, count out of range**: the port returns 1 and changes nothing (not even the two zeroed dwords) when `signed word [self+0x1471]` is negative or `count * 0x29` exceeds the mirror (`0x2540 - 0xe` = 0x2532 bytes, so counts above 232). The original would copy to or past the end of its globals. Direct test only; counts 0 to 0x33 are compared with the original (0x33 * 0x29 runs past 0x5a2664, which the original also does).
- Caller-validated, unbounded as in the original: the `strlen` and the string copy (`copy_z`) of 0x4e2e05 and of 0x4c2a8d read until a NUL and write that many bytes (the fixtures keep every string NUL-terminated inside its field and inside the destination); a missing NUL overruns exactly as the original does.
- Nothing else is bounds checked, as in the original: the lengths of the strings of 0x4e2e05 (they must end inside their fields in the fixtures), the pixel and stream sizes of 0x4c2a8d, 0x414692 and the `k`/index of 0x48d3cb are caller-validated and the fixtures keep them inside their buffers.
- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half). 0x4c2a8d and 0x4f684a return the full `eax` and the oracle compares it.

## Unverified

- Callee calling conventions are read from the call sites only: the vtable entry of 0x4f684a is assumed to be a stdcall method taking (obj, value) with ecx = obj (the original restores `esp` with `mov esp, ebp`, so the bytes cannot prove the callee's cleanup count); the stubs pop exactly 8 bytes and the oracle checks only the function's own `ret N`.
- Not exercised: a callee that changes `self`, an object or a global that the function reads again afterwards (for example 0x4e3ade changing the strings in `self` that 0x4e2e05 copies afterwards, 0x4f709c changing `[q+0x28f]` or the vtable). The ports re-read like the original (0x4f684a re-reads `[q+0x28f]`, `[q+0x13c]`; 0x414692 re-reads the stream cell before each copy), but the stubs never change them.
- 0x50ce04 is run only in the oracle; the native C conversion equals it on the tested values (the full sweep is by the differential over the fixture values listed above), not for every 32-bit input.
- Import/callee names are hints from the call shapes only; the meaning of the tables and fields is a description of what the code does, not recovered source names.
- No independent review; no claim that any family or pool is complete.

## Files

`src/original_methods_fl30d.h`, `src/original_methods_fl30d.c`; `tests/fl30d_direct_test.c`, `tests/test_fl30d_direct.py`; `tests/fl30d_fixtures.py`, `tests/fl30d_differential_shim.c`, `tests/test_fl30d_differential.py`; `tests/fl30d_original_oracle.py`; `tests/fl30d_mutation_check.py`; `tasks/fl30d-acceptances.json`; this file. `fl30d_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner `Original27`, the stub constructor, the call-log normaliser, the conditional-jump finder); `tests/test_fl_differential.py` supplies the `DiffBase` build helper.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl30d_direct tests.test_fl30d_differential` -> 12 tests, OK (7 direct: 5 functions, the run-all check and the sweep; 5 differential).
- Oracle: `python3 tests/fl30d_original_oracle.py` (5 lines as in the table, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl30d_direct_test.c src/original_methods_fl30d.c -lm` -> 6 PASS (5 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps counts, sizes and indices inside the fixture buffers; the malformed inputs (negative and over-large counts, failed allocations) are in the function tests.
- Mutation: `python3 tests/fl30d_mutation_check.py [--only <va key>]`.

## Review fixes (coordinator review, no P1)

Section comments now sit directly above each port function (`/* 0x<va> m<va>_<name> */`); 0x48d3cb no longer resolves `p` for the 0x2766 and default selections (only the table entry is read, as in the original); 0x4e2e05 has deterministic xor 0x01 / 0x80 / 0xff first-byte profiles (a hand-applied `(a & 0x7f) != (b & 0x7f)` mutant on both compares is now caught by the differential); acceptance reviewer/note lengths trimmed. Oracle counts unchanged except the 0x4e2e05 digest (new fixtures): 117/117, 4/4, 112 scenarios, digest in `tests/fl30d_original_oracle.py` output. Full mutation script: 237 mutants, 212 caught by the direct test, 7 by the differential only, 18 survivors (the same 18 equivalent ones listed below).

## Mutation check

Single textual edits per function (hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap), run with `--only` per function:

| va | mutants | caught by direct | by differential only | survivors |
|---|---|---|---|---|
| 0x4e2e05 | 46 | 38 | 0 | 8 |
| 0x4c2a8d | 33 | 28 | 2 | 3 |
| 0x48d3cb | 48 | 46 | 2 | 0 |
| 0x4f684a | 56 | 49 | 3 | 4 |
| 0x414692 | 54 | 51 | 0 | 3 |

All 18 survivors were read and are equivalent on every reachable input:

- 0x4e2e05: `rds16` read as `rd16` for the count (an unsigned count of 0x8000 or more is over the mirror and rejected exactly like a negative one); the six `rd16` -> `rd32` swaps feed a 16-bit store (truncated); `0x5a1e62` -> `0x5a1e63` and `>` -> `>=` in the bound change the outcome only for `n == 0x2532`, which is not a multiple of 0x29 (the bound is checked at counts 232 and 233).
- 0x4c2a8d: the zero stores at `+0x35`, `+0x39` and the 16 byte clear at `+0x45` moved by one byte write zeros over bytes that the 0x59 byte clear already zeroed.
- 0x4f684a: the constant's last bit +1 (one ulp) moves no integer across it; three `rd32` -> `rd16` swaps are on `return rd32(self, 0x3be)` right after a store of 0.
- 0x414692: two `rd16` -> `rd32` feed a 16-bit store; the 0x16 byte copy read as 0x17 writes one byte at `B+0x1c` that the following word store overwrites.

Known gap of the tool: mutants are single textual edits; multi-line guards, a dropped `&&` operand, loop-bound expressions and double edits are not modelled. Hand-applied mutants were not run in this batch.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl30dWorld.block_5a1e54` must point to host memory that mirrors the original globals 0x5a1e54..0x5a4394 (0x2540 bytes, `FL30D_BLOCK_5A1E54_SIZE`), `table_5bb5e5` to the table of records of stride 0x8d at 0x5bb5e5 with slack for a negative index (the dword at +0 of each record is read). The scalar globals of `Fl30dWorld` are read and, for 0x48d3cb, written in place (the function takes a non-const world).
- Return values: `m4e2e05_copy_state` and `m414692_read_block` return 0 (done) or 1 (native rejection: the original would overrun or store through address 0; for 0x414692 the quit has already been posted by 0x4c97b4 after an allocation failure, and the host must not use the cells or the object afterwards). `m4c2a8d_make_record` and `m4f684a_prepare_entry` return the full `eax` (the record address or 0; 0 or 1).
- 0x4f684a makes no host call for the float-to-integer conversion (the port does it in C); a host that binds 0x50ce04 elsewhere is unaffected.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the last code commit)

| file | sha256 |
|---|---|
| src/original_methods_fl30d.c | 75401f8faa14b677afd517cf0bfc09f5ecb956a22fde0ddf51d03d9d7c7f868e |
| src/original_methods_fl30d.h | 6d67eb545587f7496075667b5362ce664fe95e2dc5577acd402c5f4543f404f7 |
| tests/fl30d_fixtures.py | 5e1d91233b10828879a62b02b1ffa3d55d453bd2502b4d5d9ad7db515283f073 |
| tests/fl30d_original_oracle.py | 3c272eb108e6ec60d8f74df82dc5072e52474012c920cd9799283a5ff59c8fbf |
| tests/fl30d_direct_test.c | 907080fda3cecc1bc91e3ebda6af348df57888dc907290fbcac4073480b1cda6 |
| tests/fl30d_differential_shim.c | 4fa5a67b8ac0c78c79cbe062d768d2dc3f3d476e396c1907548efd8b5d35d90f |
| tests/test_fl30d_differential.py | b6460f348668999a0b5631c28c7c375f581ad532d715e08d47d6c8f5c2971ca9 |
| tests/test_fl30d_direct.py | f431937d4cda81a45a2df0d31b40762dd84b9e3a6ceac2d98ef9779c81a809be |
| tests/fl30d_mutation_check.py | 08c2ec0b36c32d1a678b220ec5be98ee5c40532547b98d0956d3723efaaafa69 |

Hashes are those of the review-fix commit. Native library: the differential builds `tests/fl30d_differential_shim.c` + `src/original_methods_fl30d.c` into a throwaway shared object per run (no committed binary).

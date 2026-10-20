# FL-30 batch b (`fl30b`) handoff

Branch `claude/fl-30b` (worktree `/home/user/wt-fl30b`), based on `da2ffc67` (the FL-30 packet commit). Implementer: Claude Sonnet. A Sonnet `slice-reviewer` diff review was done (findings addressed below); the acceptance entries say so in their `reviewer` field. Root decides on collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl30b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 7 entries; none of the rows has a receipt blocker in the packet, so there is no `blockers_reviewed`; `function_ledger.test_area` was run on all 21 test ids and accepts them).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (7 of 7, none dropped)

All in `src/original_methods_fl30b.c` / `.h` (symbols `m<va>_*`, world struct `Fl30bWorld`, host convention `Fl18Host`). Each function is its own commit (see the branch log). The oracle counts are "executed instructions / instructions of the code part" and "taken jump directions / all directions".

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x44b26a | 350 | m44b26a_apply_delta | 111/111 | 15/16 (1 allowlisted) | 560 | 78b08728d8e70a8325baeb2dfa529addd3504bcab570437f44d1b56e824b1797 | d800a30bfee6a006119b98eff1f0a704f17bac09bae6f3e8c348cb00c760e7cc |
| 0x488e9c | 447 | m488e9c_init_record | 143/143 | 6/6 | 610 | 04f123c1db8648ba495a114d264875b08310a8c5dba60df95e6d57e92f3e92f9 | f2ca65102b72b407f020982400f4a39a1b891ad199d0947ec840b7ce76dbc0e1 |
| 0x4c5b3a | 529 | m4c5b3a_copy_keyed | 166/166 | 16/16 | 432 | 2ce80eced44a45e914b9e9fe555ded858aafa3fb9c5409777026088f51524d14 | d7cb8e7864115f36b6b300d69c93dd9b85a9f7741eb7bcc20e69787a6b63737c |
| 0x42e844 | 579 | m42e844_step_record | 124/124 | 14/14 | 168 | 3bd804f9cb5c3b288592cd46be75d86c79f1077fc90cd8b81d98881aa0b7bc03 | 80447f83a1367e5dcfff7373597b837fa4aace201a01a1b607ef394eb5de2f09 |
| 0x411f24 | 660 | m411f24_replace_record | 191/191 | 4/4 | 84 | 8ff4d43ad8f3a65d62d2f94287f02024bb8aa6b7c7da1b3fc6f5949239222268 | fb55837c218fe7fb72c2f3eaa899d8061c0f2cdd32c5550b6868551bf76e8635 |
| 0x4cbba9 | 969 | m4cbba9_load_file | 292/292 | 30/30 | 116 | 6b23139d2d963665a936d6188bd3df1cecedcb1c5db05f3785e79771a9454d9d | 43560a4a3b0918e72ad68874b74f2341659055c4e94a18a376ba2df825f43a56 |
| 0x4d214b | 1472 (code 1002) | m4d214b_lookup_word | 235/235 | 2/2 | 512 | a1f04ee4bd06f48becc3e1db569fe5362a7343b6b9a521f6b5cad7e9c1ada5f1 | 6bfc7bc63fe734934eb94b7559c5217613f2aaa39c09dab91554588dff6cbbd5 |

Notes per function (the header `original_methods_fl30b.h` gives the byte-level contract of each):

- **0x44b26a** `apply_delta` (`ret 4`, one word stack argument; ecx unused): record item pointer from `[0x5bb5e5 + (int16)idx*0x8d]`; kind byte > 0x27 only reports (when the signed debug word 0x63a4cd is non-zero); kinds <= 0x1d update a word table (replace on flag != 0 or on the 0x270f sentinel, else 16-bit add); kinds 0x1e..0x27 update a float table by x87 (`fcomp` against 9999.0f: equal or unordered replaces; else `fild`, `fadd` at 53-bit precision, `fstp` as float). The oracle runs with x87 control word 0x27f. `0x42ba3a(idx)` is called on every path (the report path jumps to it as well).
- **0x488e9c** `init_record`: sibling of FL-29a 0x4895cc: `0x51dc43(0xaba)`, three rep-copies (0xac, n*16, m*0x26 bytes), the three pointer cells advanced after each copy.
- **0x4c5b3a** `copy_keyed`: colour-key word copy (read from `from`, written to `to` when it differs from the word at `self+0x38d0`), with the size-equality report when the debug word is set; loop bounds as in FL-29a 0x4c9340.
- **0x42e844** `step_record`: three states in the dword `[r+0x4d]`; state 0 sets the global 0x5bb1ca and goes on as state 1.
- **0x411f24** `replace_record`: calls 0x413187, 0x42ba3a; allocation, text built from the constant string at 0x5415c8 and the converted number (0x5193ca writes into an 8 byte local), record copied to a second allocation; both allocation-failure branches.
- **0x4cbba9** `load_file`: file open and read through scripted callees; 0x4cc70f (host stub) stores the allocation addresses to the header field, the entry table and each entry's data field.
- **0x4d214b** `lookup_word`: a `jmp [idx*4+table]` switch through an index table; the port's `switch` holds the 53 mapped byte values and field offsets (0x59 + 2k, k = 0..52). The mapping was read from the original's index and jump tables and the arm instructions at test-writing time; the acceptance and evidence window is the full 1,472 bytes (0x4d214b..0x4d270b, tables included; the instruction count 235/235 is over the 1,002 code bytes); the oracle runs all 256 byte values through the original arms and the differential compares each with the port.

## Review round (coordinator findings, all addressed)

- Evidence attribution: a `/* 0x<va> <symbol> */` comment sits directly above each port function and above each `test_m<va>_*` function; the old `/* ---- 0x.. ---- */` section comments (which sat in front of the static helpers `rep_copy`, `c_strlen`, `read4cbba9`) carry no address any more. Checked with `scripts/extract_function_evidence.py --repo <worktree> --write --output <scratch>` (scratch output, `function-evidence.json` untouched): each of the seven addresses now has its port symbol as native_source and no helper. `tests/fl30b_mutation_check.py` splits functions on the new comments.
- Acceptance window of 0x4d214b is `["0x4d214b","0x4d270b"]`; reviewer string and notes shortened to the limits (80 / 240 characters).
- 0x42e844: profiles with the count word 0xffff, 0xfffe and 0x8000 (negative as signed words; the old list never had a negative count, `range(-1, -1)` was empty): an unsigned `i < count` is caught (hand-applied, CAUGHT).
- 0x411f24: the scripted 0x48945b rewrites the dword `[r+0]` on odd passes, so a cached `p` instead of the re-read before `0x51dc6c` is caught (hand-applied, CAUGHT).
- 0x4c5b3a: shape `bppneg` with `word_639895 = 0xfffe` (-2): an unsigned 16-bit read of the bytes-per-pixel word is caught (hand-applied, CAUGHT).

## Dropped

None.

## Deliberate divergences and native rejections (not original behaviour)

- **0x488e9c, allocation returns 0**: after the report (`0x50ca3e`, `0x42639d`, `0x4c97b4`) the original runs `rep movsd` through the null pointer. The oracle maps a zeroed page at address 0 only so that the report instructions execute; the port returns 1 right after the three report calls. The differential compares those calls and requires that every byte of every area is unchanged except `[p0]`. **Also rejected (return 1, the effects before the offending copy stay):** a negative `n` or `m` (the original's `shr ecx, 2` of a negative byte count copies about 4 GB) and a copy that would end behind the 0xaba bytes of the buffer. Neither can be run by the oracle; the direct test checks them.
- **0x4c5b3a, null descriptor on the copy path** (`from` or `to` is 0 and the debug word is clear): the original reads address 0x2f and faults; the port returns 1 and does nothing. With the debug word set the original reports and never touches them, and so does the port.
- **0x411f24, both allocation failures** (first: right after the report; second: after the report, the record pointer is left 0 and the first buffer is not freed): the original goes on through the null pointer. The oracle maps a zero page. The differential compares the calls up to the end of the report (6 and 10 calls) and the bytes written by then (`buf` and the record pointer dword in the second case; `tests/test_fl30b_differential.py` accepts a list of `(offset, length)` ranges in `sc.partial[1]` for this). **Also rejected:** a number text without a NUL inside the 8 byte local (the original overwrites the local that follows). The constant string at 0x5415c8 (12 characters in the original's data) is read through `Fl18Host.resolve`; the test supplies the bytes from the local original at run time (not committed).
- 0x44b26a: the port computes the float sum as a double and rounds it to float (53-bit x87 precision); NaN payload handling of other x87 precisions is not modelled.
- Nothing else is bounds checked, as in the original: the entry count `n` of 0x4cbba9 (header field, caller-validated), the count word at `[P+0x28]` of 0x42e844 and the indices of its dword table, the word and float table indices of 0x44b26a (a kind byte selects at most the first 0x28 entries).
- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half), the byte argument of 0x4d214b from the low byte. 0x4d214b returns the full `eax` (0 or 1).

## Allowlisted untaken jump directions

- `0x44b28f jl 0x44b29d` taken: `xor eax, eax; mov al, [edx]; test eax, eax; jl` - `eax` is a zero-extended byte, SF is clear, the `jl` is never taken. Its target 0x44b29d is reached through the `jle` at 0x44b29b when the byte is above 0x27 and is executed (all 111 instructions run). Under the packet ruling (only some directions impossible, every instruction runs) the row is credited; root should confirm. Entered in `fl30b_fixtures.UNTAKEN_ALLOWED` with this reason; the oracle and the differential fail if an allowlisted edge is taken.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax`, and log ecx, the stack arguments and probes of fixture memory at the call. Callee shapes from the call sites: 0x44b26a: 0x50ca3e cdecl(3), 0x52139c stdcall(3), 0x42ba3a cdecl(1). 0x488e9c: 0x51dc43 cdecl(1), 0x50ca3e cdecl(4), 0x42639d thiscall(2), 0x4c97b4 thiscall(0), 0x44a2b7 cdecl(1). 0x4c5b3a: 0x50ca3e cdecl(11), 0x52139c stdcall(3), 0x4c97b4. 0x42e844: 0x42ba3a. 0x411f24: 0x413187 thiscall(4), 0x42ba3a, 0x51dc43 (two scripted results), 0x50ca3e cdecl(4), 0x42639d, 0x4c97b4, 0x48945b thiscall(2), 0x5193ca cdecl(3) (writes the number text into the local through its second argument: a scripted write), 0x51dc6c cdecl(1). 0x4cbba9: 0x4cbb00 thiscall(0), 0x50ca3e cdecl (3 or 4 arguments in this function: the stub logs the first three; the fourth, always `self+0x1e`, is checked by the direct test only; `fl30b_fixtures.LOG_ARGS`), 0x50cd72 cdecl(5), 0x50d0a9 cdecl(2), 0x4cc70f thiscall(2) (scripted writes: the allocation addresses), 0x50cf61 cdecl(4) (scripted results; scripted writes of the entry count and of each entry's word), 0x4264e8 thiscall(1), 0x44a2b7, 0x50cee4 cdecl(1), 0x4c97b4. 0x4d214b: none. Globals and tables are patched into the image per scenario (0x5bb5e5 records, 0x58c91d/0x58c959 tables, 0x585801 dwords, 0x63a4cd, 0x5bb57b, 0x5c39e3, 0x5bb1ca, 0x5bb50b, 0x5bb1fa, 0x639895). Memory model boundaries: a zeroed page at address 0 in the null-allocation scenarios of 0x488e9c and 0x411f24; the x87 control word 0x27f for 0x44b26a. The oracle checks the number of bytes each function popped (4, 12, 20, 0, 4, 4, 0).

One fixture note: the dword 0x5bb57b lies inside the table of records (slot -1, +0x23) of 0x411f24's fixture; the global is set from that memory so that both sides see the same bytes.

## Unverified

- Callee calling conventions are read from the call sites only (callee pops are assumed to match the stub shapes); 0x4cc70f, 0x5193ca, 0x50cf61 and the like are named by shape, not by recovered names.
- Not exercised: a callee that changes `self`, a record or a global the function re-reads, other than the scripted writes named above (0x4cc70f and 0x50cf61 of 0x4cbba9, 0x5193ca of 0x411f24). Aliasing between the pointer cells of 0x488e9c (`p0`, `p1`, `p2` pointing at the same dword) is not tested.
- The fourth argument of the 4-argument 0x50ca3e calls of 0x4cbba9 is not compared by the differential (see Hooks).
- The 0x4d214b mapping was derived from the tables with a throwaway script; the committed port is a plain `switch`. No claim of recovered source names.
- Descriptive names are hints from the code, not recovered source names.
- No claim that any family or pool is complete.

## Mutation check

`python3 tests/fl30b_mutation_check.py --only <va key>` (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

| function | mutants | caught by the direct test | by the differential only | survivors |
|---|---|---|---|---|
| 0x44b26a | 21 | 18 | 0 | 3 |
| 0x488e9c | 61 | 47 | 5 | 9 |
| 0x4c5b3a | 33 | 21 | 10 | 2 |
| 0x42e844 | 39 | 31 | 3 | 5 |
| 0x411f24 | 54 | 49 | 2 | 3 |
| 0x4cbba9 | 121 | 108 | 9 | 4 |
| 0x4d214b | 55 | 12 | 42 | 1 |

Every survivor was read: all are equivalent on every reachable input. Width swaps whose result is truncated by a 16-bit store or a `(int16_t)` cast (0x44b26a lines of the word table update, 0x488e9c counts, 0x42e844 copies and count, 0x411f24 copies, 0x4d214b `rd16` of the word); `rds16(x) == 2` read as `rd16` (0x488e9c, the compare value is positive); boundary or literal changes of the native-rejection thresholds of 0x488e9c that no 16-byte or 38-byte multiple can reach (`0xac + n*16 > 0xaba` has no equality case; the thresholds 0xaba -> 0xabb, `>` -> `>=` and 0xac -> 0xad do not change which n or m is accepted); 0x411f24: the NUL of the constant string copied into a buffer that was just cleared (`strlen` of the string from +1 loses only the NUL, which the buffer already holds); 0x4c5b3a: the size of the local text buffer 0x124 -> 0x125 and the `rd16` of the pixel word that is stored through a 16-bit store; 0x4cbba9: the loop counter `[self+0x12e]` (a dword that never exceeds the entry count) read with 16 bits, four lines.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled. Hand-applied mutants were not run beyond the above in this batch.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl30b_direct tests.test_fl30b_differential` -> 16 tests, OK (9 direct: 7 functions, the run-all check and the sweep; 7 differential).
- Oracle: `python3 tests/fl30b_original_oracle.py` (7 lines as in the table, exit 0).
- Sanitisers: `gcc -std=c11 -Wall -Wextra -Wpedantic -Werror -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl30b_direct_test.c src/original_methods_fl30b.c -lm` -> 8 PASS (7 functions + the bounded sweep of 300 scenarios), no report.
- Mutation: `python3 tests/fl30b_mutation_check.py [--only <va key>]`.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; the world pointers (`records_5bb5e5` with two records of slack below for a negative index, `words_58c959`/`floats_58c91d` over one table, `dwords_585801` with slack on both sides) must point to host memory that mirrors those global tables. Every address the original passes or stores is a 32-bit original address resolved through `resolve`; the string at 0x5415c8 must be served by the host (0x411f24).
- Return values: `m488e9c_init_record`, `m4c5b3a_copy_keyed` and `m411f24_replace_record` return 0 = done, 1 = native rejection (the original would have crashed or run away); the host must not use the buffers afterwards (for 0x488e9c/0x411f24 the quit has already been posted by 0x4c97b4 on the allocation-failure paths). `m4d214b_lookup_word` returns the original's `eax` (0 or 1).
- The 0x4cc70f callee of 0x4cbba9 allocates and stores the address to its first argument (the host must do the same for the header field, the entry table and each entry's data field).
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the last commit)

| file | sha256 |
|---|---|
| src/original_methods_fl30b.c | 0c1e32e4b24ae66e0a80f2d528bdbb550effe24d047c1ca04f33391676415152 |
| src/original_methods_fl30b.h | c8df6facdfbd90a18700aad3f039a71b1d8cae016fd0c22c52f3720e89f713e9 |
| tests/fl30b_original_oracle.py | 6983ad9296d12a6d52083f00ed3e9e7824ff9ac3aceaec89eb29dbb807385e0a |
| tests/fl30b_fixtures.py | 91c3609a04198b51839e925e6a9185a7d61969b095497cb519709bac006ccc72 |
| tests/fl30b_direct_test.c | eb397d47d9e14c5089653f26076f57eb932405dc3078bb34e53383775ed24504 |
| tests/fl30b_differential_shim.c | 72a7a401a35a1072a44e55fccc4878abba2e4ae5907115eda5d90f083178fd89 |
| tests/test_fl30b_differential.py | d32f4282d86bcc19cf664ab867cf87321569278a4713ef9039a08e08c20a939f |
| tests/test_fl30b_direct.py | 7b5208ede36ca3c90f60006079af725614f4b40a625cdfe606b54bdb0a32c15a |
| tests/fl30b_mutation_check.py | 841d9a4254d8ed9361d3efd67895c239de74a30a2de8019289279072ea70b4aa |

Native library: the differential builds `tests/fl30b_differential_shim.c` + `src/original_methods_fl30b.c` into a throwaway shared object per run (no committed binary).

# FL-25 batch d (fl25d) handoff

Branch `worktree-agent-a3c797cfd93608f87`, based on `9cb9b577` (FL-25 packet). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (3 of 3)

All in `src/original_methods_fl25d.c` / `.h` (thiscall with `self` = ecx as a byte buffer with raw offsets, world globals in `Fl25dWorld`, callees through the `Fl18Host` convention, GetTickCount through `host->tick`). The batch-a conventions apply.

| va | span | symbol | what |
|---|---|---|---|
| 0x4712bd | 1125 | m4712bd_click_27a6_27ad | plain ret; gates, three arms over the word lists at +0xd4a / +0xdc2, nine-byte announcement through 0x4fb2e3 (constants 0x54c480 / 0x54c48c), GetTickCount, record state 2 |
| 0x4b2250 | 1735 | m4b2250_hit_test | ret 8; clearing of two words, the cell grid (rows 0x1e4, cells 0x2c) with the Z path and four overlapping blocks that advance A and B, calls 0x4afec1 and 0x4b2917, two record rectangles |
| 0x46bca9 | 1909 | m46bca9_hit_test | ret 0xc; rectangle stored into the object, mode A (0x46b954, two cell scans, announcement globals) / mode B (two scans with their own bounds, then a rectangle), calls 0x46c41e |

Record table at 0x5bb5e5: stride 0x8d, object address at +0, state dword at +0x4d. Hit-test x/y are sign-extended words compared as signed dwords.

## Dropped, with reason

None. Every instruction of the three windows is reached by an original-bytes scenario. One conditional-jump direction is unreachable and allowlisted (below).

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH`.

- Direct and Unicorn differential, slice tests only: `python3 -m unittest tests.test_fl25d_direct tests.test_fl25d_differential` -> 8 tests OK (5 direct: three functions, the bounded sweep, the run-all check; 3 differential).
- Original-bytes-only oracle: `python3 tests/fl25d_original_oracle.py`; also under the recorder `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl25d_original_oracle.py` (same lines, exit 0).
- Sanitisers: `tests/fl25d_direct_test.c` + the port built with gcc `-std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined`: all 4 cases PASS, no report.
- Mutation: `python3 tests/fl25d_mutation_check.py [--only <va hex>]` (see below).

Oracle results (instructions reached / in the code window, conditional-jump directions taken / total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x4712bd | 267/267 | 55/56 | 600 | 8233f5635cad6d551fb0aae12de3847ef442cbdaa451cbd8ba5223a8445daa39 |
| 0x4b2250 | 476/476 | 86/86 | 910 | c4c0a1a4ad65edede73454872c7ed01da14ad334754f2b949e3ec7d11bd4ad18 |
| 0x46bca9 | 494/494 | 92/92 | 568 | a6a0330bb1be52b39ea2819ead0b05f7a6dc9b519219abb677e93bb4175de707 |

The one untaken direction is 0x4714dd `jne 0x4715ee` in 0x4712bd (allowlisted in `fl25d_fixtures.UNTAKEN_ALLOWED`): at 0x4714d3 the byte [R+0x23] is read again after the `je 0x4714d3` at 0x471424 that tested the same byte, with no store of any kind in between, so the jump cannot be taken. (The related `jne 0x4714a8` at 0x471479 is reachable only through a word store that overwrites the tested byte: the profile `arm2 alias`, slot 0x36 with the count word -60.) All three windows are pure code (no data inside). The direction of a jump is read from the original run itself (every (instruction, next instruction) pair seen by the Unicorn code hook).

`tasks/fl25d-acceptances.json` has 3 entries (class `native_oracle_verified`, window = start to start+span).

## Hooks (Unicorn differential and oracle)

Only OS and host boundaries are stubbed; no decision of the function under test is replaced. Each stub records its arguments and the memory it sees at call time and returns a scripted value.

- 0x4fb2e3 (1 dword argument), 0x4afec1 (1 word argument, answer scripted: 1 / 0 / 2 / 0x100 / 0xffffffff), 0x4b2917 (1 argument), 0x46b954 (no argument), 0x46c41e (4 dword arguments): recording stubs by entry address (the callees; recovered separately). The words pushed from 16-bit registers (0x4afec1 and the code argument of 0x4b2917, whose upper half is whatever the register held) are compared by their low 16 bits on both sides.
- GetTickCount: IAT slot 0x52a23c (0x4712bd only).

## Divergences and unverified branches

- Callees are stubbed in the oracle and a host callback in the native tests; the native code does not model any effect of a callee on `self`, the record table or an object (host contract in the header: flush the world before and resync after each call).
- The world is a snapshot of scalars (`Fl25dWorld`); the original reads globals at the instant of use. All scenarios keep the globals constant between a callee call and the read, which matches because the callees are stubbed.
- 0x4712bd: the word 0x4fb2e3 argument is the zero-extended word [R+0x87] (the original pushes ecx after `repe cmpsb`, whose count is at most 9, so the upper half is zero); the native code passes the same. The 16-bit wrap of `sub ax, 1` on the count word -32768 would read the word list 64 KiB above the object; fixtures keep the counts small (the original would read there too, nothing was rejected).
- 0x4b2250: reads the object at negative offsets when R.w21 <= 0 (`(w21 - 1) * 0x1e4 + 0x6b`), i.e. memory before the object; the fixtures give the object 0x400 bytes of slack below `this` and cover w21 = -1 and 0; w21 below -1 is not covered. The 4afec1 answer is compared as a dword (`cmp eax, 1`).
- 0x46bca9: the four scans are one static helper (`scan_cells`) called with the original's constants; the original has four copies of the loop. The announcement globals are written and read back through the world as in the original (0x5d1631 = 0x24 * 32 + 0 * 16 + 0x5b160c = 0x5b1a8c).
- Unsafe original behaviour: none rejected. Out-of-range indices (counts above the fixture sizes, a k loop reaching into the fields at +0x4a50) read memory the original would also read; the native code does the same on the host buffers and the tests never go there.
- No independent review; no claim that the batch or FL-25 is complete.

## Hashes

Code windows (sha256 of the original bytes, va to va+span):

| va | span | sha256 |
|---|---|---|
| 0x4712bd | 1125 | 09bf39ecb2c78135648244ac83acea373a9deafd2e28de4fcc99c1a87f1973b7 |
| 0x4b2250 | 1735 | 26f1244dce9db10223e966d308bf6ad442563eb9a316bb54e9c8cc93862c0f54 |
| 0x46bca9 | 1909 | 7b27b8f015f95940e0924bd1903220042204691a460f9556448008f0259b1c09 |

Files at the last commit: `src/original_methods_fl25d.c` 752a122eca407a552973866164328ae9bef31ce24e808ed9e46683537a280272, `src/original_methods_fl25d.h` 4e93795440790248d546f415a88453d00a576e27db35e0db3ae5c566c157d2e1, `tests/fl25d_fixtures.py` 91f3bf35af1698c2ed86c0ee9ccd03145df77cc8fb68b9cbf62f519892909c09 (at code commit b02ee0c2; the handoff commit changes none of them).

## Mutation

Mutants are single textual edits of the port (a literal +1, `==`/`!=` swapped, one boundary moved, a one-line `if (...) return;` deleted, a width or signedness swap), each built and run against the direct test, then against the differential of the owning function. Results by function (run per function with `--only`):

- 0x4712bd: 143 mutants, 119 caught by the direct test, 5 by the differential only, 19 survivors, all equivalent: `rds16(` -> `rd16(` where the value is only compared with 0x28 for equality (2 sites), `rd16(` -> `rd32(` where the value is then stored through `wr16` or cast to 16 bits (11 sites, the store narrows it), `<` -> `<=` where the equal case assigns the value it already has (the clamps of the count word to 0, to R.w21 and to d, 4 sites), and `<` -> `<=` on the shift loop bound (the extra pass copies one word that the final store of the slot word at [+0xd48 + 2d] overwrites), plus `rds16(` -> `rd16(` on a count that the clamp has just made non-negative.
- 0x4b2250: 116 mutants, 94 caught by the direct test, 19 by the differential only, 3 survivors, all equivalent: `rds16(` -> `rd16(` in the two `word [cell+0x1a] != 0` tests (a zero test) and `rd16(` -> `rd32(` under the `(int16_t)` cast of the code.
- 0x46bca9: 81 mutants, 73 caught by the direct test, 6 by the differential only, 2 survivors, both equivalent: `rds16(` -> `rd16(` on the entry words [e+8] and [e+0xa] compared for equality with the row and column counters (both below 0x8000). A first run had 4 survivors: the loop bound `k < R.w4f` -> `<=` and the signedness of that count; they exposed that no fixture put a matching entry just past the count or used a negative count, and both were added (fixtures and direct test) and killed.

The unsampled full set was run per function (`--only`); no `--limit` sampling.

Known gap of the tool: mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width); multi-line guard deletion, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Last commit

Code commits on the branch, in order: c86fda3d (0x4712bd), 33c3e6f3 (0x4b2250), 5a4807a3 (0x46bca9), b02ee0c2 (0x46bca9 fixture gap); the handoff commit follows them (its hash is the branch head). Branch `worktree-agent-a3c797cfd93608f87`, base `9cb9b577`.

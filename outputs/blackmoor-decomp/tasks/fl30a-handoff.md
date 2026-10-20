# FL-30 batch a (`fl30a`) handoff

Branch `claude/fl-30a` (worktree `/home/user/wt-fl30a`), based on `da2ffc67` (the FL-30 packet commit). Implementer: Claude Sonnet. A Sonnet slice-reviewer diff review was done (no P1); its findings are fixed in the commit after the handoff (see Review round). Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl30a-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 6 entries; none of the rows has a receipt blocker, so no `blockers_reviewed`). `function_ledger.test_area` was NOT run on the test ids in this container.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (6 of 7)

All in `src/original_methods_fl30a.c` / `.h` (symbols `m<va>_*`, world struct `Fl30aWorld`, host convention `Fl18Host` as in FL-18/26/27/28/29). One commit per function (see Commits). Addresses that the original passes or stores (records, objects, vtables, layout tables, strings, surfaces) are 32-bit original addresses here too and go through `Fl18Host.resolve`; only `self` and the `Fl30aWorld` table pointers are host pointers.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4f61e7 | 333 | m4f61e7_start_record | 78/78 | 10/10 | 192 | 65ccd72e2219d267a62d1d9cd2188d017ff518e6408587b9e43edc28ac446179 | 91986ddd54f06b46da13ec5d43a81dbc2bda2cfc3f6816e543766d2635d664fc |
| 0x484762 | 467 | m484762_intersect_rects | 163/163 | 28/28 | 1850 | ed6d502c0827f7e9dd46bff0270dd0200f8fee044c316907d02388df73ac5dee | 18857f1882b6325bbd9f20668785eb0a93c1edd406423aeb122c200b7f5a6fb5 |
| 0x484ac0 | 495 | m484ac0_latch_hit | 121/121 | 18/18 | 312 | 1bac0abc366d9c13b3aa13172bf2ba2e7bf5a2e8260220eb53f5384cbac09d9b | d4cadc5e8a635142bbb45e5c8cf6b3d41e61b5bb3668796faec47b365653a004 |
| 0x44b3c8 | 633 | m44b3c8_sum_kinds | 181/181 | 21/22 (1 allowlisted) | 1216 | af2bf68f9c73c51e853fb311dc6ba476bb20bc429b18c77bbdb7bb7405c86a5d | bbb8faa8936805077289b618d4b353bc146088a9561d75b6a3dd45994f388152 |
| 0x47ef0f | 654 | m47ef0f_latch_hit_counter | 163/163 | 22/22 | 416 | c0f3ec42ac8bd34bc3c5e48ae0d6fd2cbbb012e679a7863a4af26a309f38db3d | 0c6c8d351a99931dc42e062ce0e8d723958f482c0cd44a7c0082360fdcbf7e6b |
| 0x4d270b | 1301 | m4d270b_draw_text | 350/350 | 34/34 | 1500 | d6b8b64e152570c23c49d411c6c761c2cbb06a2a93756ff42bb902d7f1ba654b | 56eb3e1c05f2a110bc4915aaad0efbba56f38d9c2881de536a2d158312235d73 |

Notes per function (the header `original_methods_fl30a.h` gives the byte-level contract of each):

- **0x4f61e7** `start_record` (thiscall, `ret 4`, returns eax): sets `[self+0x3c2]=0x3e8`, `[self+0x3ca]=0`, rec = `[self+0x3ce] + index*0x5bb` (32-bit), calls 0x4f709c, checks `[rec+0x162]` / `[rec+0x28f]`, sets `[rec+0x287]=1`, calls the vtable entry `[ [ [rec+0x28f] ] + 0x48 ]` (ecx = the vtable, one stack argument = the object; assumed stdcall) and stores its result to `[self+0x3ca]`; a zero result reports through 0x50ca3e / 0x44a2b7 only when the word 0x63a4cd is non-zero and returns 1, a non-zero result sets `[self+0x3c2]=0x40b` and returns 0.
- **0x484762** `intersect_rects` (thiscall, `ret 8`, leaf, no host calls): intersection of the dword rectangles at `+2` of two stride-0x85 records; result 0 when empty or when any of the four computed coordinates is -1 (the initial value), else 1. The two word loads at `r + 0x24 + byte[r+0x22]*0x18 + 0x14` into locals that nothing reads are made natively too (so a sanitiser sees the reach); the mutation survivors on them are equivalent.
- **0x484ac0** `latch_hit` (thiscall, plain `ret`): seven guards (the record from the table 0x5bb5e5, its state at +0x4d, flags in `self`), then either the stored hit word `[self+0xa9e]` (flag `[self+0xa92]` set) or the answer ax of 0x4846c2 (-1 ends the function); stores the two word differences at `+0xbc5` / `+0xbc7` and calls 0x485f12 and 0x484935. The second path re-reads `[self+0xa9e]` after storing it, as the original does.
- **0x44b3c8** `sum_kinds` (thiscall with ecx unused, `ret 4`): x87 code at the control word 0x27f (53-bit). Accumulates up to ten (kind byte, value word) triples of a record into the float cells at 0x58c91d; see the header for the arms. Single-precision stores (`fstp dword`) and double-precision intermediates are reproduced exactly (`(float)(((double)(float)v / 100.0) * (double)(float)t)`); the constants 100.0 (0x52cbec) and 9999.0 (0x52cbe8) are literals in the port. A float cell equal to 9999.0 or NaN (unordered) is treated alike (`fcomp` / `test ah, 0x40`).
- **0x47ef0f** `latch_hit_counter` (thiscall, plain `ret`): the same latch as 0x484ac0 with other offsets and a counter-decrement block (`[self + k + 0x7a0]` with k from the table at `+0x7d7`) on the second path only.
- **0x4d270b** `draw_text` (cdecl, plain `ret`, returns the constant 0x63a8f0): ten stack arguments; walks the string, asks 0x4d214b for a glyph (writes a word through a local pointer) or classifies the character through 0x50d651 / 0x50d67f / 0x50d6a7 / 0x50d6cf, builds the glyph rectangle in a local, calls 0x4c5b3a with the pen globals 0x63a8f0..0x63a8fc as they are at the call, computes the baseline offset with `__ftol` of 0.9 times the height once, and optionally fills a run of words. The globals are fields of `Fl30aWorld` that the port writes.

## Dropped

- **0x4c36b2 (1451 bytes)**: not started. Reason: batch budget. After six ports (about 105 tool calls) the remaining budget could not cover a 1,451-byte function with a switch on the record state, two heap allocations, two row-copy loops (`rep movsd` / `rep movsb`), a stack-built bitmap-header struct passed to six CRT / library callees (0x50cd72, 0x50d0a9, 0x50e493 twice, 0x50cee4, 0x51dc6c twice) and local-pointer probes at each call; the packet says to skip the largest rows rather than spend the run on them. The disassembly shows no unreachable block behind an always-true guard (every `je` / `jne` has both outcomes available from callee results), so the row stays a pool candidate. Disassembly saved at `/tmp/claude-0/4c36b2.txt` during the run only; re-run the helper to regenerate.

No row was dropped for an unreachable block. 0x44b3c8 has one jump direction that is never taken but every instruction runs (credited, flagged below).

## Allowlisted untaken jump directions

- 0x44b3c8, `0x44b492 jl 0x44b5a3`, taken direction: `xor eax, eax; mov al, byte ptr [..]; test eax, eax; jl` tests a zero-extended byte, so it is never negative and the `jl` is never taken. The target 0x44b5a3 is reached through the `jg` at 0x44b4ab and executed, so all 181 instructions run. The allowlist entry lives in `fl30a_fixtures.UNTAKEN_ALLOWED` with this reason (an entry that is taken fails as stale). Root should confirm that crediting 0x44b3c8 with one allowlisted edge is acceptable under the ruling; if not, drop its acceptance entry.

Other guards that look redundant were checked and are reachable: 0x484762 (the -1 test is reached by every combination), 0x4d270b (the `cmp ecx, 0x80; jge` byte tests fail for bytes 0x80 and above, the two `jl`-free paths of the report test both run).

## Deliberate divergences and native rejections (not original behaviour)

- **0x4d270b, flag != 0 and no drawn glyph (native rejection)**: `ofs` ([ebp-4]) is only assigned when a glyph was drawn and `x1` ([ebp-0xc]) only when a character was reached; with the flag set and no drawn glyph the original computes the destination address from stack garbage and writes through it (the oracle's stack is filled with 0x71 bytes, so the original faults on an unmapped address). The port skips the fill then; everything else (globals, calls) is as in the original. The differential does not run this case (no legal fixture); `test_m4d270b_draw_text` covers it, and the generator forces a glyph into every string whose flag is set.
- **0x4d270b, `__ftol`**: the call to the library routine 0x50ce04 is not a stub: the oracle runs the original bytes (fnstcw / fldcw / fistp); the port performs the truncation natively with `ftol_low_dword` (as in FL-28b). The two NaN / out-of-range guards of that helper are unreachable from this call site (the operand is `(float)int32 * 0.9`), hence two equivalent mutation survivors.
- Nothing else is bounds checked, as in the original: record numbers, glyph indices, string lengths and pixel runs are caller-validated and the fixtures keep them inside their regions.
- Word arguments are taken from the low 16 bits of the stack dword (the fixtures put garbage in the upper half); the byte argument of 0x4d214b is compared by its low byte (its upper 24 bits are left-over register bits in the original: `fl30a_fixtures.BYTE_ARGS`).

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` (per-call result lists), log ecx, the stack arguments and, where named, probes of fixture memory / world globals at the call. Callee shapes from the call sites: 0x4f709c thiscall(0); the vtable entry (stub page address `0x7e000900`) of 0x4f61e7 thiscall-like ecx = vtable, 1 stack argument, pops 4; 0x50ca3e cdecl (3 or 4 arguments); 0x44a2b7 cdecl(1); 0x52139c stdcall(3); 0x4c97b4 thiscall(0); 0x4846c2, 0x485f12, 0x47e9d3, 0x480abe thiscall(0); 0x4853b0, 0x484935, 0x47fa11, 0x47ed96 thiscall(1, word argument); 0x42ba3a cdecl(1, word argument); 0x4d214b cdecl(3) with a scripted write of a word through its third argument (a local); 0x50d651 / 0x50d67f / 0x50d6a7 / 0x50d6cf cdecl(1); 0x4c5b3a thiscall(5) with the 16 bytes behind its third argument (a local rectangle) and the four pen globals logged. Globals and tables are patched into the image per scenario (`0x5bb5e5` records of stride 0x8d, the float / word table at `0x58c91d`, the words `0x63a4cd`, `0x639895` and the four dwords `0x63a8f0..fc`). The x87 control word is set to 0x27f (the Windows default) for 0x44b3c8; 0x4d270b runs the original `__ftol` under the same control word. The oracle checks the number of bytes each function popped (4, 8, 0, 4, 0, 0).

## Files

`src/original_methods_fl30a.h`, `src/original_methods_fl30a.c`; `tests/fl30a_direct_test.c`, `tests/test_fl30a_direct.py`; `tests/fl30a_fixtures.py`, `tests/fl30a_differential_shim.c`, `tests/test_fl30a_differential.py`; `tests/fl30a_original_oracle.py`; `tests/fl30a_mutation_check.py`; `tasks/fl30a-acceptances.json`; this file. `fl30a_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (Unicorn runner with the edge hook and the x87 control word, the stub constructor, the call-log normaliser, the conditional-jump finder) and `tests/test_fl_differential.py` (`DiffBase`), so those files must be present (they are on main).

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl30a_direct tests.test_fl30a_differential` -> 14 tests, OK (8 direct: 6 functions, the run-all check and the sweep; 6 differential).
- Oracle: `python3 tests/fl30a_original_oracle.py` (6 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same 6 lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl30a_direct_test.c src/original_methods_fl30a.c -lm` -> 7 PASS (6 functions + the bounded sweep of 300 random scenarios), no report. The sweep keeps indices, record numbers, glyph extents and pixel runs inside the fixture buffers.
- Mutation: `python3 tests/fl30a_mutation_check.py [--only <va key>]`.

## Mutation check

Per function (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
0x4f61e7  mutants 43: direct 40, differential only 0, survivors 3
0x484762  mutants 49: direct 28, differential only 12, survivors 9
0x484ac0  mutants 73: direct 61, differential only 3, survivors 9
0x44b3c8  mutants 34: direct 30, differential only 2, survivors 2
0x47ef0f  mutants 73: direct 62, differential only 3, survivors 8
0x4d270b  mutants 66: direct 47, differential only 5, survivors 14
```

(the 0x4f61e7 and 0x484762 lines are from the runs made while the fixtures were being tuned; they were re-run after the last fixture change for 0x484762 and 0x4f61e7 only.) All survivors were read and are equivalent on every reachable input:

- Width swaps where the loaded value is immediately truncated: `(int16_t)rd16` -> `rd32` (the cast keeps the low 16 bits) and `rd32` -> `rd16` inside `(uint16_t)(a - b)` (low 16 bits of a difference depend only on the low 16 bits of the operands): 0x484ac0, 0x47ef0f, 0x44b3c8 (the word loads of `value` and `t`), 0x4d270b (twelve loads of signed words).
- 0x4f61e7: the read-back of `[self+0x3be]` after storing 0 to it (`rd32` -> `rd16`, three places): reads back 0 either way.
- 0x484762: the dead word loads (offsets 0x22, 0x18, 0x24, 0x14 and their widths): the values are never used.
- 0x4d270b: the two NaN / out-of-range guards of the `__ftol` helper (unreachable for this call site) and the boundaries on them.

Hand-applied mutants (all CAUGHT, restored afterwards): 0x44b3c8 quotient/product computed in `float` instead of double-then-float (caught by the differential only: the oracle detects the 53-bit precision rule); an added `+ 1e-9` term in the float-cell product (caught by the differential); the NaN-as-equal rule removed (`&& f == f`, caught by the direct and the differential tests).

Review round (reviewer findings 1 to 5): these mutants are now covered, each by the direct test (and the fixtures of the differential where noted) and checked by hand-applied edits, all CAUGHT:

- 0x4d270b: `0.9f` -> `0.9` (extents heights 10, 20, 30, 40 in the fixtures; direct cases with heights 10 and 30); unsigned-cast flips of `x`, `y`, `sel` (in `glyph_rect`), the pitch word at dest_b+0x2f, the layout advance words 0x4f (differential only) and 0x51, the extents height at idx*4+2 (negative x, y, sel, pitch, advance and extent words, negative glyph indices, all valid for the original: the layout and extents addresses point into the middle of their regions and the pixel base is in the middle of a 0x6000-byte region); the 32-bit arithmetic (`ofs*pitch`, `x0*bpp`, `fc - f4 + 1`, pen updates, run length) is done in `uint32_t` so it wraps like the original. The unsigned flips of the layout words 0x53 / 0x55 / 0x57 are equivalent (the sum is truncated to 16 bits into `idx` either way) and are not claimed.
- 0x44b3c8: crafted (value, table entry) pairs where `(v / 100) * t` and `(v * t) / 100` give different floats (25647 with 17375 gives 4456166.5f; five more pairs found by search; table words and float cells, the profiles `craftw` / `craftf`), and the kind byte of the record read again after the report callee (profile `kindchg`: a scripted write by the first 0x50ca3e call changes `rec[0]`, the accumulation then goes to the new cell; direct case likewise). The port re-reads `res(rec)[0]` at each use as the original does at 0x44b434, 0x44b60a and 0x44b61b (and the report argument at 0x44b40c). Mutants `mul-then-div` (both arms) and `kind not re-read` are caught by the direct test.
- The 0x4d270b native rejection (flag set, no drawn glyph: the original uses stack garbage) is unchanged and covered by the direct test.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand, loop-bound expressions and double edits are not modelled.

## Unverified

- Callee calling conventions are read from the call sites only; the vtable entry of 0x4f61e7 is assumed stdcall (the original restores `esp` with `mov esp, ebp`, so its cleanup count is not proven by the bytes); the stub pops exactly 4 bytes and the oracle checks only the function's own `ret N`.
- Not exercised (except the kind byte of 0x44b3c8, see below): a callee that changes `self`, a record, an object or a global that the function reads again afterwards (for example 0x4853b0 / 0x47fa11 changing `self+0xa9e` or the difference operands, 0x4c5b3a changing the pen globals). The ports re-read like the original; the stubs never change them.
- 0x4d270b: the character-class routines (0x50d651 / 0x50d67f / 0x50d6a7 / 0x50d6cf) are stubbed with scripted answers, independent of the character, so the three lookup arms are exercised for every combination of answers and byte values but the real library semantics (isalpha / isupper / islower / isdigit) are a name hint only. 0x4c5b3a, 0x4d214b and the callee names are hints from the call shapes.
- 0x44b3c8: the oracle ran under Unicorn's x87 emulation (53-bit precision from the control word 0x27f); a host x87 or a different emulator is not compared.
- No independent review; no claim that any family or pool is complete.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; `Fl30aWorld.table_5bb5e5` must point to host memory that mirrors the record table at 0x5bb5e5 (stride 0x8d; slack for a negative record number), `tab_58c91d` to the 0xa0 bytes at 0x58c91d. The world globals of 0x4d270b (`dword_63a8f0..fc`) are written by the port: the host must keep them as the storage of the original globals, because 0x4c5b3a reads them through the address 0x63a8f0.
- `m4d270b_draw_text` returns the constant 0x63a8f0 (the address of the pen x), as the original does; a caller that reads the pen position through it must read the world field. The documented native rejection (flag set, no drawn glyph) leaves the pixels untouched.
- `m4f61e7_start_record` returns eax (0 or 1); `m484762_intersect_rects` returns 0 or 1.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the last code commit)

| file | sha256 |
|---|---|
| src/original_methods_fl30a.c | f9a696c5d912c87f20c976745289334bc57f9b31eb9b00e622961920744273ae |
| src/original_methods_fl30a.h | 23db69193ac75519d4213a43e8e8c2b9117a7ae1b45b68b8ead718ecca61d321 |
| tests/fl30a_original_oracle.py | b6558cc0cec9954128077ba9a591055a2cb46af0790164d5ea51c0da25105223 |
| tests/fl30a_fixtures.py | 436ca1d0712aaa2532efa8a93598692a7e68c2cdc61c604393be00fd3b9fc549 |
| tests/fl30a_direct_test.c | 696c96d59806f994eebc56186d2cc920da27c60fd13a8344968cc7142257dbc9 |
| tests/fl30a_differential_shim.c | 21f25178b295f4c6886e38786792988d7cd91d0728ac7f381ede1c5fe1086aea |
| tests/test_fl30a_differential.py | 08088a7967be94a07372b8e7085457fa0a0247c4918bd4247cbfb7cce8261fc8 |
| tests/test_fl30a_direct.py | 3288084e5e2c8aad6c056907e0efac6d15d86e4c2d51e409528a356c07414545 |
| tests/fl30a_mutation_check.py | 975a6e819b3106238bcd4b870a8f95a9f507e524953a57ba197c5ce5f48c48d6 |

Native library: the differential builds `tests/fl30a_differential_shim.c` + `src/original_methods_fl30a.c` into a throwaway shared object per run (no committed binary).

## Commits

One per function on `claude/fl-30a`: 0x4f61e7 `61f6a4b8`, 0x484762 `60c12a8b`, 0x484ac0 `a29a65dd`, 0x44b3c8 `431a8b85`, 0x47ef0f `9f83b39a`, 0x4d270b `46048eb0`; the handoff commit follows them.

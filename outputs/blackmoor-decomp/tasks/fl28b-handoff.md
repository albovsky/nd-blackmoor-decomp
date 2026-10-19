# FL-28 batch b (`fl28b`) handoff

Branch `fl28b` (worktree `/home/user/wt/fl28b`), based on `4a1d00d` (the FL-28 packet commit). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl28b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 12 entries). None of the 12 rows has a receipt blocker in the packet (blockers were listed only for batch a and c rows), so there is no `blockers_reviewed`.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (12 of 13)

All in `src/original_methods_fl28b.c` / `.h` (symbols `m<va>_*`, world struct `Fl28bWorld`, host convention `Fl18Host` as in FL-18/26/27). Commits: `6aa1640` (0x41e043, 0x42e493, 0x41de29, 0x41e250, 0x4edfaf, 0x41e0b4), `b86c499` (0x4205c1, 0x4209e8, 0x4f6ef4), `22739b6` (0x41c544, 0x41fa11), `07b5502` (0x422a0a) and the last commit of the branch (fixture fix for the 0x422a0a loop bound, handoff, acceptances). The first six and the next three were committed as one commit per group because they share the same five files and the shared fixture machinery; each group's tests were green at its commit.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x41e043 | 113 | m41e043_find_free_slot | 35/35 | 6/6 | 102 | 698e3d27db9910b0cc90eed4dcde883668c3a758e46fcfe8406f0b0cc407199f | c97e79b69d60e63e262f9dc96e8b52d0e4ee70db736f61e9b4fd0c90ceae472e |
| 0x42e493 | 205 | m42e493_take_pending | 38/38 | 4/4 | 98 | 92c2378bee58115d45299f77fad2f280843cf012b3bf51277ae366137041ec26 | ad863a5b6157f199732eb975d2f9f9e99ebf6e539ae56df7868eedb397dd1b69 |
| 0x41de29 | 220 | m41de29_clear_slots | 60/60 | 6/6 | 18 | 860ad25ea359230dc491f2844a17bc3ad450a8eb607bb3499235e050febbbdea | f563de65c8929cb81c04e5315fc10bba8bfbbde2df69c0d2ed6ffa0a2f8dadaf |
| 0x41e250 | 235 | m41e250_release_slot | 65/65 | 8/8 | 330 | 857f5bf345bffbd224b8d5b0985b95148cd0c8392b1d9784595aa70d201138e8 | 28fe16f9d2ba495cd2a03299064b8f4e39557efc4a6dde6f7cef06f939f880b2 |
| 0x4edfaf | 293 | m4edfaf_centre_rect | 95/95 | 2/2 | 360 | 14f489fe4ea3678aba0b43785807a152cbd3821686f2cc453e69921cd6604597 | dab73ecd68c6b5e5e98c4955a484e410f564728f4a882e9e41c8b6ad667c6ed5 |
| 0x41e0b4 | 304 | m41e0b4_add_slot | 85/85 | 12/12 | 462 | 3cfb9038c129c057d02d37ea4ac0b296486bed07adf655a4230b994571e6807a | 8b8cd13d302c2c426cac07f36c2fd364da72428c4b2acb83b6e9963ba39a1b55 |
| 0x4205c1 | 374 | m4205c1_run_entries | 101/101 | 14/14 | 408 | 3446f16f5cb545c52a060f455bf208cae3d736ef3a7bcd93ceaa51b49de73c8a | f9f9d1981494a2a4f8a4b7dc665a723f3a642728e0f601b8df2ce9fd1b7c1044 |
| 0x4209e8 | 438 | m4209e8_run_small_entries | 119/119 | 12/12 | 396 | 0446df668a7590f9969b88a47ebdd88378ebc4c7d49fc3f123e4a2848d1a0841 | bec0cbec20f6d2a627290a5503cf8250ce3edb6aa0e6bb1901b2de836a0df7a7 |
| 0x4f6ef4 | 424 | m4f6ef4_advance_record | 116/116 | 18/18 | 1002 | 8eb6f84822670ac8578c51e95cd0c3f600aed722b8885f8e584d6f248f570478 | c68cffc7ff7cab44a5e0d8cd127ab4c68bdb9252eabd15c6983dcc5062bd4e74 |
| 0x41c544 | 556 | m41c544_init_record | 155/155 | 4/4 | 120 | 79335b4c1b93f28c1784b1c448835a60e1745da8ed1fee46125ae11d77327e43 | 8fc0e546a1d150c81da998a294be229b9b654916c674a1ae2f6b1460ee840632 |
| 0x41fa11 | 759 | m41fa11_add_entry | 188/188 | 10/10 | 210 | 7274eb8c74e10d3219ded5897fc227f0dd7e12c08518b0efa46360617aad3448 | f809abda9a9f9d10ce6ac69ad5244e04b5811b6e8a8c1167ca43a3d83deceba9 |
| 0x422a0a | 1088 | m422a0a_draw_marked | 303/303 | 24/24 | 360 | 7b8a22b1ab07f21c1c6dad99a2f825de8174971c28435da76ed20c35e8395b8a | 8caef4a93275cc66dabe8957776504955d37b54d49f1f0a56a8cb135b4ba3c41 |

| file | sha256 |
|---|---|
| src/original_methods_fl28b.c | de9bd4a8c12286ac072ca213d6fe8e6b048f5b869e636ca8dbc8ca1a166f01eb |
| src/original_methods_fl28b.h | bb84b7cf0caeea2da357abca4b8aea23002fe77fd72c1d58fee1c1677fa9ee06 |
| tests/fl28b_original_oracle.py | 916b2e2b78ec0d4f60db1fa9ffc1ec6a6f9c7d51c00e1403c688720e33ad0848 |
| tests/fl28b_fixtures.py | a1f771e0bcbab77f3ab6125171f56b83b49317bf0ea6c2a1c520f5260ab4b9a9 |
| tests/fl28b_direct_test.c | 8f38fd60d42b78976f32028b2e6bd587bae5628b1b947db0c9875b3c3c4bb848 |
| tests/fl28b_differential_shim.c | 851d8ff35abcf094e3d1452520f19db6b438cf6870568c3a4685dadc4b0b3a1d |
| tests/test_fl28b_differential.py | 6df692f4e663fd9e1fc5a7fddf4f8c2cc33b1aaa3bcb00a6e03eeabe94392f82 |
| tests/test_fl28b_direct.py | deb76112c0a10ca8f70ec139ec03edea0d422593c9b5ada29c1c026b206e9c8d |
| tests/fl28b_mutation_check.py | 4882bc29df41fb8756b7665d8e872c15746d52d6e3ea9001a0adec0d2c74cd3d |

Notes per function (the headers of `original_methods_fl28b.h` give the byte-level contract):

- **0x41e043** `find_free_slot` (thiscall, returns ax): first free slot of the 0x4b-entry table at +0x1c (stride 0x16), signed word count/capacity compares.
- **0x42e493** `take_pending` (no arguments): sentinel 0x270f report, or latch of nine globals and the two clears. The callee 0x52139c is stdcall(3) (its `ret 0xc`), so the original pops 12 bytes there.
- **0x41de29** `clear_slots`, **0x41e250** `release_slot`: the free/clear of the owned pointer through 0x51dc6c (cdecl) and four dword calls 0x4c2e5b per entry.
- **0x4edfaf** `centre_rect`: truncating halvings (`cdq; sub; sar`), 32-bit wrap; calls 0x4db993.
- **0x41e0b4** `add_slot`: two reports that continue (full, occupied), kind byte 0x39/0x3b/0x3e loop calling 0x417b04, else second report; the first argument of 0x417b04 is pushed from `ax` (only the low word is defined, compared by the low 16 bits in the tests).
- **0x4205c1** `run_entries`, **0x4209e8** `run_small_entries`: record loops (records table 0x5bb5e5, stride 0x8d) with the 0x420737 gate (`movsx eax, ax`), kind byte arms, the indirect calls `[self + b*4 + 0xf23]` (ecx = record) and `[self + c*4 + 0xf4b]` (ecx = c) of 0x4205c1, the dword table store of 0x4209e8.
- **0x4f6ef4** `advance_record` (returns eax): guard chain, `fild`/`fstp dword`/`fdiv dword` quotient through the real `__ftol` (the oracle runs the original `__ftol` bytes on the FPU with control word 0x27f; the port uses `float` operands, a `double` quotient and a truncating conversion that returns 0 for NaN/infinity/out of range), two signed clamps.
- **0x41c544** `init_record`: three constant strings of the original (`"dummy"` at 0x5431b0, the 65-byte "Missing conversation text ..." at 0x5431fc and at 0x543240) are embedded constants of the port.
- **0x41fa11** `add_entry`: dedupe against stored 0x190-byte blocks (0x50d550 is a cdecl compare; zero = equal), 400-byte copy to the block that 0x51ea75 returns, then the field and string stores in the original order (a string of 0x21 or more characters clobbers the words stored before it, tested).
- **0x422a0a** `draw_marked`: nested word loops where the first matching `j` ends the inner loop after its arm (the original jumps from 0x422e20 to the outer `i++`; a first version of the port used `continue` and the Unicorn differential test caught it), jump table 0x422e3a (0, 1, 3 -> 0x422af6; 2 -> 0x422ceb; above 3 -> end of the inner loop), locals passed as host pointers (their 16 bytes are compared at the call).

## Dropped (1)

- **0x422e4a** (358 bytes): not a function that returns. It is a worker-thread loop: `mov ecx, 1; test ecx, ecx; je 0x422f92` (an always-true guard, so that `je` can never be taken), a `jmp 0x422e56` back edge and no `ret` anywhere in the span; the only exits are the never-returning report 0x51ec84 and the endless loop with the Sleep import 0x52a2b0. A bounded oracle would need a synthetic stop at the import (which is not an OS-boundary stand-in but a replacement of the function's termination), and the port would need an invented step/stop contract, so the row stays pending (owner ruling on always-true guards; packet rule "drop it with the disassembly reason"). Callees seen: 0x44c479, 0x41dfd2, 0x41e1e4, 0x41e043, 0x41e0b4 (the last two are ported here), 0x44c4ab, 0x51ec84.

## Files

`src/original_methods_fl28b.h`, `src/original_methods_fl28b.c`; `tests/fl28b_direct_test.c`, `tests/test_fl28b_direct.py`; `tests/fl28b_fixtures.py`, `tests/fl28b_differential_shim.c`, `tests/test_fl28b_differential.py`; `tests/fl28b_original_oracle.py`; `tests/fl28b_mutation_check.py`; `tasks/fl28b-acceptances.json`; this file. The two Python test files build their test methods from `fl28b_fixtures.KEYS` (no per-function edit).

## Commands (from `outputs/blackmoor-decomp`, after `export PATH=/tmp/claude-0/shim:$PATH`)

- Slice tests: `python3 -m unittest tests.test_fl28b_direct tests.test_fl28b_differential` -> 26 tests, OK (14 direct: 12 functions, the run-all check and the sweep; 12 differential).
- Oracle: `python3 tests/fl28b_original_oracle.py` (12 lines as in the table, exit 0); also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace` (same lines, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl28b_direct_test.c src/original_methods_fl28b.c -lm` -> 13 PASS (12 functions + the bounded sweep of 300 random scenarios over the first six and the record-driven functions), no report. The sweep keeps counts and indices inside the fixture buffers (see the divergences).
- Mutation: `python3 tests/fl28b_mutation_check.py [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments (stdcall/thiscall cleanup as at the call sites), return a scripted `eax`, and log ecx, the stack arguments and, where named, probes of the object. Callee shapes: 0x52139c stdcall(3); 0x4c97b4 thiscall(0); 0x51dc6c cdecl(1); 0x4c2e5b thiscall(1); 0x4db993 thiscall(2); 0x417b04 thiscall(3); 0x420737 thiscall(3); 0x41fa11/0x41fd08/0x42028e thiscall(1) (0x41fa11 is also a port of this batch, host-stubbed where 0x4205c1 calls it); 0x4e9e84 thiscall(2); 0x4ea06c thiscall(1); 0x50ca3e cdecl(3 or 4); 0x44a2b7 cdecl(1); 0x4264e8 thiscall(1); 0x4f709c thiscall(0); 0x4f6334, 0x4f81fa thiscall(1); 0x423259 thiscall(1); 0x51ea75 thiscall(1); 0x50d550 cdecl(3); 0x51eac4 thiscall(1); 0x4c5377 thiscall(5); 0x4c609b, 0x4c5770 thiscall(6); the indirect-call targets of 0x4205c1 (stub page addresses `0x7e000a00 + 0x10*i` and `0x7e000b00 + 0x10*i` stored in the object's tables). Not hooked: `__ftol` (0x50ce04) runs as original bytes in 0x4f6ef4's oracle; the x87 control word is set to 0x27f (the Windows process default). Globals and tables are patched into the image per scenario (the world scalars; the records at 0x5bb5e5, the dword table at 0x585801, the tables of 0x422a0a at their original addresses); the oracle checks the number of bytes the function popped on every run. Callees with pointer arguments to locals (0x4c5377, 0x4c609b, 0x4c5770) have the 16 bytes behind the pointer logged at the call.

Which callees are batch functions: 0x41e043 and 0x41e0b4 are called by 0x422e4a (dropped); 0x41fa11 by 0x4205c1 (host-stubbed there). The integration step decides whether the host binds them to `m<va>_*`; the host contract (flush the world before and resync after each call) is in the header.

## Deliberate divergences and native rejections (not original behaviour)

- Nothing is bounds checked, as in the original: the slot index, the count, the capacity, the entry counts (0x793/0x79f/0xf21/0xf9b/0x618783) and the table indices (0x585801) are caller-validated. The tests keep them inside their buffers; the bounded sweep restricts counts (for example `[+0xf9b] < 0x20`) so that the sanitiser run is meaningful. There is no native rejection path in this batch.
- 0x4f6ef4: the `__ftol` truncation is `ftol_low_dword` (the 64-bit truncation, low dword, 0 for NaN, infinities and out-of-range values); the explicit guards are required for the saturating float-to-int conversion on ARM64 and are equivalent on x86 (the mutants that delete them survive on this host).
- 0x41c544: the three strings are embedded constants of the port.
- Word arguments are taken from the low 16 bits of the stack dword; arguments the original pushes from a 16-bit register (the first argument of 0x417b04, the second of 0x420737, the word of 0x4e9e84/0x4ea06c) carry stale upper bits in the original: the tests compare the low 16 bits.
- 0x41e043 returns `ax`; the upper half of `eax` is not compared.

## Unverified

- Not exercised: a callee that changes `self`, the record or a global that the function reads again afterwards (for example 0x4205c1/0x4209e8 re-read the record fields and the entry array after the 0x420737 call; the stubs never change them). The ports re-read like the original.
- x87 precision of 0x4f6ef4: the oracle runs with 0x27f and the port uses IEEE doubles; fixtures with all quotients of two single-precision floats give identical results, but the tests do not discriminate 53-bit from 64-bit extended precision for quotients extremely close to an integer.
- Import/callee names are hints from the call shapes only; the meaning of the tables (slot table, records, rectangles) is a description of what the code does, not recovered source names.
- No independent review; no claim that the 0x3f/0x3e pools or the action family are complete.

## Mutation check

`python3 tests/fl28b_mutation_check.py --only <key>` per function group (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap), run on the committed source of each group:

```
group 1 (0x41e043 0x42e493 0x41de29 0x41e250 0x4edfaf 0x41e0b4): mutants 104: caught by the direct test 93, by the differential test only 8, survivors 3
0x4205c1: mutants 37: caught by the direct test 37, by the differential test only 0, survivors 0
0x4209e8: mutants 29: caught by the direct test 29, by the differential test only 0, survivors 0
0x4f6ef4: mutants 50: caught by the direct test 42, by the differential test only 3, survivors 5
0x41c544: mutants 47: caught by the direct test 43, by the differential test only 0, survivors 4
0x41fa11: mutants 87: caught by the direct test 76, by the differential test only 6, survivors 5
0x422a0a: mutants 94: caught by the direct test 73, by the differential test only 19, survivors 2
```

All survivors were read; they are equivalent or unreachable on this host:

- 0x41e250 (3 in group 1, with 0x41e0b4's): `rd16(0x68e)` read as a dword then truncated to 16 bits (twice), and the `< 0` floor written as `<= 0` (writes 0 over 0).
- 0x4f6ef4: the NaN guard, the range guards and their boundaries of `ftol_low_dword` (NaN and infinity cannot arise from a positive count, and x86-64 maps them to the same indefinite integer), and `n > 0` as `n >= 0` (n = 0 gives 0 either way).
- 0x41c544: the `i + 4 <= n` boundary of the string copy (the last dword copied by bytes instead), and three `rd16` read as `rd32` that are truncated by the 16-bit store that follows.
- 0x41fa11: the same truncated width swaps (four) and the `rds16` of the trace argument, which is only evaluated when the count is at least 0x1e.
- 0x422a0a: the `rd16` of the word index read as a dword and then cast to `int16_t` (equivalent), and `k < 4` -> `k <= 4` in `copy16` (a memory-safety mutant: it reads 4 bytes past the 16-byte source and writes one dword past a 16-byte local, which this harness, built without sanitizers, does not see; the ASan/UBSan build would flag it, but it was not run on that mutant). A first run also left the outer loop bound `i < count` -> `i <= count` alive (no fixture byte equalled the count); the generator now includes bytes equal to the count and one more, and the direct test has a case, so that mutant is now caught.

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; addresses stored inside records (the sub-object addresses, the entry array pointers, the table pointer `[0x618795]`) are original addresses that `resolve` turns into memory; stack-argument pointers to the records of 0x41c544/0x41fa11 are host pointers; the world pointers (`records_5bb5e5`, `dwords_585801`, `table_617804`, `words_61879d`, `objs_5d34d1`, `rects_617ec2`, `rects_617f02`) must point to host memory that mirrors those global tables, including the records below the base for a negative index.
- The ports are standalone; no shared parser, dispatcher or app file was edited. Bind 0x41e043, 0x41e0b4 and 0x41fa11 to their `m<va>_*` symbols in the host when wiring the callers.

## Source and test hashes (sha256, at the last commit)

| file | sha256 |
|---|---|
| src/original_methods_fl28b.c | de9bd4a8c12286ac072ca213d6fe8e6b048f5b869e636ca8dbc8ca1a166f01eb |
| src/original_methods_fl28b.h | bb84b7cf0caeea2da357abca4b8aea23002fe77fd72c1d58fee1c1677fa9ee06 |
| tests/fl28b_original_oracle.py | 916b2e2b78ec0d4f60db1fa9ffc1ec6a6f9c7d51c00e1403c688720e33ad0848 |
| tests/fl28b_fixtures.py | a1f771e0bcbab77f3ab6125171f56b83b49317bf0ea6c2a1c520f5260ab4b9a9 |
| tests/fl28b_direct_test.c | 8f38fd60d42b78976f32028b2e6bd587bae5628b1b947db0c9875b3c3c4bb848 |
| tests/fl28b_differential_shim.c | 851d8ff35abcf094e3d1452520f19db6b438cf6870568c3a4685dadc4b0b3a1d |
| tests/test_fl28b_differential.py | 6df692f4e663fd9e1fc5a7fddf4f8c2cc33b1aaa3bcb00a6e03eeabe94392f82 |
| tests/test_fl28b_direct.py | deb76112c0a10ca8f70ec139ec03edea0d422593c9b5ada29c1c026b206e9c8d |
| tests/fl28b_mutation_check.py | 4882bc29df41fb8756b7665d8e872c15746d52d6e3ea9001a0adec0d2c74cd3d |

Native library: the differential builds `tests/fl28b_differential_shim.c` + `src/original_methods_fl28b.c` into a throwaway shared object per run (no committed binary).

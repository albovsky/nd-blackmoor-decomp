# FL-27 batch c (`fl27c`) handoff

Branch `worktree-agent-a7acaa5a285fda3ae` (worktree `agent-a7acaa5a285fda3ae`), based on `b19dff64` (the FL-27 packet branch `claude/fl27-family-35-ports-jak55w`). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field, and root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited; `tasks/fl27c-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 4 entries; none of the four has a receipt blocker in `function-evidence.json`, so no `blockers_reviewed`).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (4 of 4, one commit per function)

All in `src/original_methods_fl27c.c` / `.h` (symbols `m<va>_*`, world struct `Fl27cWorld`, host convention `Fl18Host` as in FL-18/26/27b, callees through `Fl18Host.call`).

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4497a0 | 728 | m4497a0_construct | 187/187 | 16/16 | 372 | 24f3e7fc7e9c5a474fcbcbff7d3f986394a1a5ffb1d2ad9349e13f837e0913b1 | 93bbc611d8ae76a24de81d370be047ef43729ad73acb209c2284cb1aebf94586 |
| 0x414ceb | 806 | m414ceb_open_map | 224/224 | 18/18 | 276 | 92c8453b37a45434f205894ea66d711db88c5178eb6f4935e963205e567389d2 | 4f9fd401655d0465b10cc6920ad34f26c436d48e97a6bd43113825bb70ba942f |
| 0x4c2e97 | 1208 | m4c2e97_read_pixel_format | 298/298 | 36/36 | 496 | 1372d022a02816600df8cbca1c3475ae97870b1a6b4dca3d07c3ab1581f25bce | 120f9a25bf014bf133fddaef12969fa286f922fff5382d4e6618516f11de780c |
| 0x44c4c1 | 1306 | m44c4c1_open_video | 329/329 | 16/16 | 216 | 1ce37316b51b9d2814e8b82ab08bd8d69474454c0879bfe63d57d4a1e16401c8 | 8dd6a87ff43cc31725db8afa3dfd0c7740e39e6b738b109f71072a9cd21911e7 |

Every function is one contiguous code range with no data inside its span; no conditional-jump direction is left untaken (`UNTAKEN_ALLOWED` is empty). What each port is (the headers of `original_methods_fl27c.h` give the full byte-level contract):

- **0x4497a0** (`ret 0x10`, thiscall): the thread-wrapper constructor. Stores the vtable 0x52cb5c and the four fields, copies the name string to `self+4` after those stores (a long string clobbers +0x3a..+0x45, as in the original), allocates 0x68 bytes (0x51dc43), constructs the object (0x524aff), then 0x51ed8c, the import 0x52a2ac and, with bit 2 of `flags` clear, 0x52a284, with the virtual call `[[o]+0x78]` and the 0x4264e8 / 0x4c97b4 report on each failure. Returns `this`.
- **0x414ceb** (`ret 4`, thiscall, `self` only forwarded): the chunk-streamer open. Three failure reports that continue (record in use, empty name), then the imports 0x52a2bc (7 args), 0x52a2c0 (6 args), 0x52a2c4 (5 args) through IAT slots, the 0x21-byte header copy, the 15-byte signature test plus the words at +0x10 (== 2) and +0x12 (== 0), the 0x13-byte-per-entry table copy and the geometry product.
- **0x4c2e97** (`ret 4`, thiscall, returns `ax`): the pixel-format reader. A virtual call (vtable slot 0x58) fills a zeroed 0x7c-byte descriptor; three shift loops give the counts / mask bytes / kinds; three byte globals are masked, shifted and combined into the word at +0x38d0; the 16-argument trace and the four flag traces.
- **0x44c4c1** (cdecl, one argument): the movie open: extension text, two sprintf calls, the AVF path (0x414ceb then geometry from the record words) or the BINK path (0x4bf315 / 0x4bee5f, geometry from the info record, the frame rate through x87 and `__ftol`), the common tail.

## Files

- `src/original_methods_fl27c.h`, `src/original_methods_fl27c.c`.
- `tests/fl27c_direct_test.c`, `tests/test_fl27c_direct.py`: hand-derived direct tests and a bounded sweep (run under ASan/UBSan too).
- `tests/fl27c_fixtures.py`, `tests/fl27c_differential_shim.c`, `tests/test_fl27c_differential.py`: Unicorn differential (original bytes against the native symbol on the same generated fixtures; ordered host calls with their arguments, the bytes behind pointer arguments and probed memory, and the globals are compared).
- `tests/fl27c_original_oracle.py`: coverage oracle (original bytes only, no native library); `tests/fl27c_mutation_check.py`; `tasks/fl27c-acceptances.json`.

## Commands (from `outputs/blackmoor-decomp`, after `export PATH=/tmp/claude-0/shim:$PATH`)

- Direct and differential, slice tests only: `python3 -m unittest tests.test_fl27c_direct tests.test_fl27c_differential` -> 10 tests, OK (4 + sweep + run-all direct, 4 differential).
- Oracle: `python3 tests/fl27c_original_oracle.py` (four lines as in the table, exit 0); also `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl27c_original_oracle.py` (same lines, exit 0, one trace file written).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl27c_direct_test.c src/original_methods_fl27c.c -lm` -> all 5 cases PASS (4 functions + the bounded sweep, 300 random scenarios per function), no report (clang here has no ASan runtime).
- Mutation: `python3 tests/fl27c_mutation_check.py [--only <va key>]`.

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run); they pop their arguments (stdcall / thiscall cleanup as in the original), return a scripted `eax`, and where a scenario needs it store scripted bytes or dwords (call number, argument or absolute address, offset). Imports are stubbed through their IAT slots.

- 0x4497a0: 0x51dc43, 0x524aff, 0x4264e8, 0x4c97b4, 0x51ed8c, 0x50ca3e, 0x44a2b7, the vtable entry (stub at 0x7e000a00, `[vtable+0x78]`), IAT 0x52a2ac, 0x52a284. OS boundary: the thread information block behind `fs` (a GDT entry, selector 0x18, base 0x7d000000, `[0]` = a random chain head); the oracle asserts that the chain at `fs:[0]` is restored on every return. Not hooked: the frame handler 0x527f1a (it never runs: no callee throws).
- 0x414ceb: 0x42639d, 0x4c97b4, 0x415011, 0x51dc43, IAT 0x52a2bc, 0x52a2c0, 0x52a2c4. The mapped file is a fixture region whose address the view stub returns.
- 0x4c2e97: the vtable entry (stub at 0x7e000900, `[vtable+0x58]`, thiscall with two stack arguments and `ret 8`; it stores the masks, the bit depth and the flags into the descriptor the function passes and logs its first 0x7c bytes), 0x4c88c7, 0x42639d, 0x50ca3e (16 arguments), 0x44a2b7.
- 0x44c4c1: 0x50cd72 (stores a scripted 0x80-byte string window into its first argument), 0x449d90, 0x414ceb, 0x4bf315, 0x4bf3b8, 0x44a2b7, 0x4264e8, 0x4c97b4, 0x50ca3e, 0x4bee5f. OS/CPU boundary: the x87 control word is set to 0x27f (the Windows process default) before the run. `__ftol` (0x50ce04) is NOT hooked: its original bytes run inside the oracle on the real FPU stack.
- Debug word 0x63a4cd is patched into the image per scenario; the two bytes behind it are random compared-out neighbours (a dword read of the word would show).

Which callees are batch functions (all host-stubbed, none bound to the ports): 0x414ceb is called by 0x44c4c1 (stubbed there although this batch ports it); 0x449d90 (batch a) is stubbed in 0x44c4c1. The integration step decides whether the host binds them to `m<va>_*`; the host contract (flush the world before and resync after each call) is in the header.

## Deliberate divergences and native rejections (not original behaviour)

- 0x4497a0: the exception frame in `fs:[0]` (pushed `0x527f1a`, trylevel stores) is not modelled; the frame is unlinked on every return in the original (checked by the oracle). A callee throwing would run the handler in the original; the port has no such path. Native rejection: returns NULL (the original would fault on address 0x24 / 0x28 / vtable 0) when `[self+0x36]` is zero at a re-read after a callee ran; tested in the direct test only (the oracle never lets a callee clear it).
- 0x414ceb: rejection (returns 1 after storing `[+0x21]`, before the copy) when `n = signed word [+0x15] * 0x13` is above 0x7fffffff and the allocation succeeded; the original copies about 4 GB there. The file signature `"AVF WayneSikes\0"` (15 bytes, from the data at 0x541978) is an embedded constant of the port; the extension texts `".AVF"` / `".BIK"` of 0x44c4c1 (0x54938c, 0x549394) likewise.
- 0x4c2e97: a mask of 0 returns 2 at its own loop (after the stores of the masks before it); the original never leaves the shift loop. Returned value: the port returns 1 / 0 for `ax`; the upper half of `eax` is stale in the original and is not compared.
- 0x44c4c1: `__ftol` is inlined as "truncate toward zero, keep the low dword of the 64-bit result, NaN and out-of-range give 0"; the explicit guards are required for a saturating float-to-int conversion (ARM64) and are equivalent to the x86 conversion on this host (so the mutants that delete them survive here, see below). The two local texts and the extension text are zero-filled in the port; the original leaves them to the callee (its stack garbage is 0x71 bytes in the harness): the contract is that the sprintf callee writes a terminated string into its first argument.
- Callees of 0x44c4c1 that change the record are only exercised where named: the oracle and the direct test script a callee clearing `[arg+0x186]` (0x4bee5f, the `je` at 0x44c7df) and a callee changing `[arg+0x176]` after the extension was chosen (0x449d90, profile `reread`). A real 0x414ceb writes fields +0x15..+0x1c that the AVF branch reads; the stub does not, so those fields are fixture bytes.
- A callee that changes `self` or a global the function re-reads is not exercised in the other functions (0x4497a0, 0x414ceb, 0x4c2e97): in 0x4497a0 the object address `[self+0x36]` is re-read at every use; the oracle compares those re-reads only against unchanged values.

## Unverified

- Import names are hints from the argument shapes: 0x52a2bc (7 stdcall args, `0x80000000`, `3`, `0x8000000`) behaves like CreateFileA, 0x52a2c0 (6 args) like CreateFileMappingA, 0x52a2c4 (5 args) like MapViewOfFile; 0x52a2ac (2 args) like WaitForSingleObject and 0x52a284 (1 arg) like ResumeThread. Only the call shapes and the order are verified; the OS behaviour is host business. 0x4c2e97's vtable slot 0x58 is a COM method called with `this` in ecx and as the first stack argument; only that is verified.
- x87 precision control: the oracle runs with 0x27f and the port uses IEEE doubles. The fixtures give identical results with the control word 0x37f (tried once by hand), so the tests do not discriminate the two precisions; the 53-bit assumption rests on the Windows default and on every quotient in the fixtures being insensitive to the extended precision. Exponent range differences (denormals, overflow) are not modelled.
- 0x44c4c1: the unbounded string copies (`strcpy` into `arg+0x4d`, 0x104-byte field) are caller-validated, as in the original; the fixtures use strings of at most 0x7f characters in 0x200-byte records.
- No independent review; no claim that FL-27 or the action 0x35 family is complete.

## Mutation check

`python3 tests/fl27c_mutation_check.py` (full run on the final source): 406 single-edit mutants (hex literal +1, `==`/`!=` swap, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap), 362 caught by the direct test, 13 more only by the Unicorn differential, 31 survivors. All 31 were read and are equivalent or unreachable:

- 0x4497a0 line 117, 0x4c2e97 line 283, 0x44c4c1 line 365 (three): local buffer sizes (+1).
- 0x414ceb line 240 (`rd16(arg, 0x10)` as a dword): the combined test `dword[+0x10] != 2 || word[+0x12] != 0` is the same condition as the two-word test. Line 254 (two mutants): the threshold of the native-only rejection; `n = word * 0x13` cannot be 0x7fffffff or 0x80000000.
- 0x4c2e97 lines 311, 312 (the word at +0x38d0 read as a dword, then its low / second byte taken), 326 (`[+0x38a8]` read as a word: it holds 0 or 1), 333 (the flags dword read as a word: only bits 2, 0x20, 0x40, 0x400 are tested).
- 0x44c4c1: lines 348 and 349 (four mutants: the NaN and range guards of `__ftol`, which the x86-64 conversion also maps to the indefinite value; not detectable on this host, see above; the two boundary mutants concern exactly +-2^63, unreachable for a non-negative rate); lines 356, 358 (two), 388, 391, 392 (two): fields that the function has just set to zero (`[+0x19e]`, `[+0x19a]`, word `[+0x18c]`) read through a different width or at +0x19b; lines 393, 394, 395, 422, 427, 428, 429: a wider read whose value is truncated to 16 bits by the store or the cast that follows.
- Two real gaps were closed during the work: the 0x4497a0 guards of the re-read (the direct test cleared `[self+0x36]` at every callee, ending the function at the first guard) and the 0x44c4c1 kind test (kinds whose low word is 1: 0x10001, 0x80000001, 0xffff0001 are added to the profile cycle and to the direct test).

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled (the same list as in the FL-26 / FL-27b handoffs).

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call` / `resolve`; a host binding must say which side translates addresses: stack-argument pointers to the records (`arg`, `self`) are host pointers, addresses stored inside the records (`[self+0x36]`, `[arg+0x2d]`, `[arg+0x21]`, the info record, the surface object, the name of 0x4497a0) are original addresses that `resolve` turns into memory. Local buffers (the text of 0x44c4c1, the descriptor of 0x4c2e97) are passed to callees as host pointers, so the host must write through them.
- Bind 0x414ceb and 0x449d90 to their `m<va>_*` symbols (or the real code) in the host when wiring 0x44c4c1.
- The new ports are standalone; no shared parser, dispatcher or app file was edited.

## Hashes

GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Window hashes: see the table. Source and test hashes (sha256, at the last port commit):

| file | sha256 |
|---|---|
| src/original_methods_fl27c.c | 718405eb1991418e20f74e19c978e411d28b2aef939bbca1d7ac6aee4c8c08fc |
| src/original_methods_fl27c.h | 5b4e64be11f204816cb2c9e63b21859b6626b0cbb6629e356a886b0cc3934a53 |
| tests/fl27c_original_oracle.py | b474c1e7780293fb3052dafc9d1fc27421056c8d537f791d4d2167fcb671a9f4 |
| tests/fl27c_fixtures.py | f284dff86aef2296c6759b86d0d088cb7f58111fe980adafff071cfe27b36d7f |
| tests/fl27c_direct_test.c | e5c609c9affa64b4ce9c7f35fc10385e528b3f1562c9c1b31af486b85759d8c8 |
| tests/fl27c_differential_shim.c | 3c170d0524e5e3f1fb78d32c16acbaa23a63f22e6eba2ff920cf0dc707e73012 |
| tests/test_fl27c_differential.py | 2b91041745ff8397200eed395f780023cea9bb6e8a024bfea866438ac2881139 |
| tests/test_fl27c_direct.py | 723f3ad9693411839d1ba7c97ae4f53c1cc02aa693fb5c02eea5cdebdcb63645 |
| tests/fl27c_mutation_check.py | f81aa97a989bda374a983676a7b37ea8b1a4390cd2b9d513613aaa767c34b341 |

Native library: the differential builds `tests/fl27c_differential_shim.c` + `src/original_methods_fl27c.c` into a throwaway shared object per run (no committed binary).

## Branch and commit

Branch `worktree-agent-a7acaa5a285fda3ae`; port commits `1a0dc98f` (0x4497a0), `a3003a6c` (0x414ceb), `0e6667ff` (0x4c2e97), `83dacc69` (0x44c4c1), `1b8d6b23` (test fix); the final commit adds this handoff and the acceptances (see git log).

## Root decisions after review

- A Sonnet `slice-reviewer` found no P1. Fixed: the zero-mask native rejection of `0x4c2e97` now returns 0 (the caller's failure path; any non-zero value would have continued as success), header and direct test updated; header notes for `0x414ceb` (rejection result must be treated as a failed open; the original leaves `eax = arg`) and the import name (`0x52a2ac` is `SetThreadPriority`, parameter renamed `priority`).
- Left as an unexercised branch, stated here: `0x4497a0` re-reads `[self+0x36]` after the callee `0x51ed8c` and after the import `0x52a2ac`; the fixtures only change it to zero, so a callee that swaps in a second object is not exercised (the port does re-read). The x87 precision (53-bit double versus the 64-bit extended mantissa under control word 0x37f) is not pinned by fixtures at the realistic rates (10 to 60 fps).

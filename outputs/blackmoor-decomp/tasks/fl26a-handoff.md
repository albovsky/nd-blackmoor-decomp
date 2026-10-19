# FL-26 batch a (fl26a) handoff

Branch `fl26a` (worktree `agent-a668b64aae2d7bc43`), based on `97fe35d8` (FL-26 packet, `claude/project-thread-cmhyad`). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (4 of 5)

All in `src/original_methods_fl26a.c` / `.h`: thiscall with `self` = ecx as a byte buffer with raw offsets, world globals in `Fl26aWorld`, callees through the `Fl18Host` convention (`call(callee, this, args[], n)`, args[0] = last pushed). `0x4d3073` has no `self`: its callees take a constant ecx (a singleton), passed as the original address.

| va | span | symbol | what |
|---|---|---|---|
| 0x4d3073 | 196 (180 code + 16-byte jump table at 0x4d3127) | m4d3073_session_tick | calls 0x4db38a, resets [0x5a4c18] = 0 and [0x5c39e5] = -1, calls 0x4e8d72, [0x5b44f8] = 0; `jmp [edx*4+0x4d3127]` on [0x583204] - 2 (unsigned compare with 3): four arms 0x4e77b8 / 0x4e89eb / 0x4ebd85 / 0x4e412d, default 0x4f0059, 0x4e075a and, when the byte [0x5a161f] is non-zero, 0x4de322 |
| 0x469057 | 407 | m469057_hit_test | ret 8; gate dword [+0x55c]; six rows of 16 bytes in `self` and a record-object rectangle, edges widened by -5/+5/-6/+10 in 32 bits; calls 0x4691ee(word i or 0x64) |
| 0x4b42d3 | 572 | m4b42d3_hit_test | ret 0xc; gate dword [+0x76e]; rectangle argument stored into the object; calls 0x4b3f98; three rows of the record object, then (word [+0x750] zero) a tail rectangle; calls 0x4b450f(word i or 0x64) |
| 0x4897cd | 509 | m4897cd_hit_test | ret 8; object list [+0x2c + 4i] (count dword [+0xcc], signed), record-state test, rows of 0x26 bytes from +0x6ec; announcement globals 0x5b44f0 / 0x5b44f4 / 0x5d162d / 0x5d1631 / 0x5d1639 and [0x5c39e5]; no callee |

Record table at 0x5bb5e5: stride 0x8d, object address at +0, state dword at +0x4d. Hit-test x/y are sign-extended words compared as signed dwords.

## Dropped, with reason

- **0x4e0978 (1203 bytes): dropped.** The instructions 0x4e0df7..0x4e0e04 (`push 0x63888b; call 0x427a40; add esp, 4; mov [ebp-0x50], eax`, four instructions) sit behind `mov ecx, 1; test ecx, ecx; je 0x4e0df7` at 0x4e0de5..0x4e0dec. ecx is the constant 1, so the `je` is never taken and those four instructions cannot run from any input: the packet's N/N instruction coverage cannot be met without patching the original (same situation as 0x4b5d17 in FL-25). The receipt blocker located at 0x4e0a22 (RT-22 unverified: "the locked-button message ... is not modelled") is therefore not reviewed here; the function returns to the pool unchanged. No claim files or partial code exist for it. Left for root: an agreed dead-code rule would let the remaining 1187 - 4 instructions be ported.

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH` (clang shim of this environment).

- Direct and Unicorn differential, slice tests only: `python3 -m unittest tests.test_fl26a_direct tests.test_fl26a_differential` -> 10 tests, OK (6 direct: four functions, `test_sweep_bounded`, and the run-all check; 4 differential).
- Original-bytes-only oracle: `python3 tests/fl26a_original_oracle.py`; also under the recorder `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl26a_original_oracle.py` (same summary lines, one trace file written).
- Sanitisers: `tests/fl26a_direct_test.c` + the port built with gcc `-std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined`: all 5 cases PASS, no report. (clang in this environment has no ASan runtime, so gcc was used.)
- Mutation: `python3 tests/fl26a_mutation_check.py` (full run, see the result line below), plus 16 hand mutants in a scratch driver (64-bit instead of 32-bit widening of the y low edge and of the tail x high edge in 0x469057, the record index read as a dword, the 0x4d3073 index compared signed, the `byte_5a161f` test changed, the first and the third reset moved across their calls, the 0x4897cd count gate as a word / compared unsigned / the announcement branch forced / `d1631` computed before `b44f4`, the 0x4b42d3 rectangle stores after the callee call / row stores after the callee / `[+0x750]` as a dword / the x edges swapped): every one is caught (one by the differential only before the direct test got a count of 0x10000 and 0x01000000; now by both). The hand mutants found that the first direct test had no count whose low word is zero.

Oracle results (instructions reached / in the code window, conditional-jump directions taken / total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x4d3073 | 44/44 | 4/4 | 144 | 500210c86ad4ccc38c8f75171ac8347122aaf9f6dbc19d6cc398493214e470a5 |
| 0x469057 | 111/111 | 20/20 | 306 | b0940b498327d39314d82a96c51cc41a1f619036b861f5d570d5917675ad889a |
| 0x4b42d3 | 129/129 | 22/22 | 192 | 34b505a56ef0ab4040a559646b7a7eba07063e33077a1d6125fc445444eae70d |
| 0x4897cd | 125/125 | 30/30 | 332 | c8d58ee794d63ea29316dfd89a7168e26ccd78b2bc8f2f68c64da65270deb3ae |

No untaken conditional-jump direction in any function (the allowlist `UNTAKEN_ALLOWED` is empty). The direction of a jump is read from the original run itself (every (instruction, next instruction) pair seen by the Unicorn code hook). The code window of 0x4d3073 for coverage is the 180 code bytes (`code=180` in the fixtures); the 16 bytes behind it are the jump table, not code. Every switch arm (index 0..3) and the out-of-range default (sel = 0, 1, 6, 7, 0x7fffffff, 0x80000002, 0x80000005, 0xffffffff) is reached with all four values of the flag byte.

`tasks/fl26a-acceptances.json` has 4 entries (class `native_oracle_verified`, window = start to start+span) with a `blockers_reviewed` entry each: RT-6:1f418027007cea4a for 0x4d3073 (located item 0x4d3081, the store `mov [0x5a4c18], 0` right after the call to 0x4db38a, read in the disassembly; the port stores it before the call to 0x4e8d72 and the call-time probes of [0x5a4c18], [0x5c39e5], [0x5b44f8] in the differential and the direct test prove the order), RT-6:1f418027007cea4a for 0x469057 and 0x4b42d3, RT-14:24b263357f7586e3 for 0x4897cd (the five announcement globals; applying them as a hover cursor in the app is outside the function and stays open).

## Hooks (Unicorn differential and oracle)

Only OS and host boundaries are stubbed; no decision of the function under test is replaced. Each stub records its arguments and the memory it sees at call time (or, for 0x4d3073, the three globals 0x5a4c18, 0x5c39e5, 0x5b44f8) and returns a scripted value (zero).

- 0x4d3073: 0x4db38a, 0x4e8d72, 0x4f0059, 0x4e075a, 0x4de322, 0x4e77b8, 0x4e89eb, 0x4ebd85, 0x4e412d (no stack argument, thiscall with the constant ecx).
- 0x469057: 0x4691ee (one word stack argument, `ret 4`).
- 0x4b42d3: 0x4b3f98 (no argument) and 0x4b450f (one word stack argument, `ret 4`).
- 0x4897cd: none.
- No import is called by any of the four.

## Divergences and unverified branches

- Callees are stubbed in the oracle and a host callback in the native tests; the native code does not model any effect of a callee on `self`, the record table, an object or a global that the function reads afterwards (0x4d3073 re-reads [0x583204] after 0x4db38a and 0x4e8d72 and [0x5a161f] after 0x4e075a; 0x4b42d3 re-reads the record object after 0x4b3f98). Host contract in the header: flush the world before and resync after each call.
- The world is a snapshot of scalars (`Fl26aWorld`); the original reads globals at the instant of use. All the scenarios keep the globals constant between the host call and the read, which matches because the callees are stubbed.
- The word arguments of 0x4691ee and 0x4b450f: the original pushes a 32-bit register of which only the low word is set from the row index; the upper 16 bits are stale register contents (0x469057: the sign extension of x; 0x4b42d3: the leftover of ecx). The native passes only the low word (`(uint16_t)i`) and the tests compare the low 16 bits. I read the first 400 bytes of 0x4691ee and the start of 0x4b450f: both read the argument only as `word ptr [ebp+8]` (`movsx`); the remaining bytes of 0x4691ee were not read. Unverified for those.
- 0x4897cd: the row address and the object addresses written into `self` ([+0x1c], [+0x20], [+0x24]) are the 32-bit original addresses (`address + 0x26 j + 0x6ec` with 32-bit wrap); `Fl18Host.resolve` is called unchecked on them, a NULL result (an object address outside the host's regions) crashes where the original would fault. The `world` is written (non-const) as in the original.
- 0x4d3073: `this` of the callees is the original address of a singleton, not a host pointer (the integration step must say which side translates). The returned `eax` of the callees is ignored by the original and by the port.
- 0x4d3073: the byte [0x5a161f] is read as a byte (`xor eax, eax; mov al, [..]`); the oracle fixtures vary the three bytes behind it, the native world holds only the byte, so a widening of that read in the native code is not distinguishable by the differential (the direct test cannot see it either); the hand mutant that changed the test of the value is caught.
- 0x469057, 0x4b42d3, 0x4897cd: out-of-range word indices (a record index outside -1..4 in the tests) read memory the original would also read; the native code does the same on the host buffers and the tests never go there. No unsafe original behaviour is rejected natively.
- Unreachable instructions: none in the four ported functions. 0x4e0978 has four (see above).
- Review fixes (FL-26 a+b review, no P1). (1) Fixture gap closed: the differential now has profiles with two overlapping hits where the first must win: 0x469057 `('overlap', 1, 4)` and `('overlap', 0, 5)` (rows), 0x4b42d3 `('overlap', 0, 2)` and `('overlap', 1, 2)` (rows), 0x4897cd `('orows', 0, 1)`, `('orows', 1, 3)` (two rows of one object; `self+0x24` shows the row where the loop stopped) and `('oobjs', 0, 2)`, `('oobjs', 1, 2)` (two objects; `[0x5c39e5]` and `self+0x1c` show which object won). Hand mutants that drop the early `return 1` of the first hit (`continue` in the row loops, `continue` and `break` in the row loop of 0x4897cd) are all detected. A mutant of the count gate that reads the dword at +0xcd (line 184) had survived by chance after the profile list changed; the fixtures now zero the byte at +0xd0 in half of the small-count scenarios, which kills it (the survivors are again the 2 equivalent ones). (2) Safety policy: the port is caller-validated, like the original, and says so in the header of `original_methods_fl26a.h`: the object count [+0xcc] of 0x4897cd must not exceed 40 (the list at [+0x2c + 4i] has 40 entries; a count whose signed value is not positive is an empty loop, tested), the row count word [+0xaa] needs that many rows, `Fl18Host.resolve` is called unchecked (NULL is dereferenced), the record table must cover the signed record words times 0x8d. Resolve width contract: `Fl18Host.resolve(a)` must return memory valid for the bytes read through it (16 bytes for the 0x4b42d3 rectangle, 0x8ae bytes for a 0x4b42d3 object, 0x41 bytes for a 0x469057 object, 0xab6 bytes plus the rows for a 0x4897cd object). (3) Integration blocker, as in FL-25: the 0x4897cd stores into `self` ([+0x1c], [+0x20], [+0x24]) are original addresses, and the calls of 0x4691ee / 0x4b450f / 0x4b3f98 pass `self` as a HOST pointer while the hit-test inputs (the rectangle address, the object addresses) are original addresses: the host adapter must say which side translates.
- No independent review; no claim that the batch or FL-26 is complete.

## Hashes

Code windows (sha256 of the original bytes, va to va+span):

| va | span | sha256 |
|---|---|---|
| 0x4d3073 | 196 | 502e71a8f5a8cc952c1ab1c60168b1f4b24a4e22ffcf74b305944c7ea5776005 |
| 0x4d3073 (code part) | 180 | bb3a12f58cb8b588771211f75e730ff6698b591c52798170118434f886162761 |
| 0x469057 | 407 | bea0db641fce72b4d6062f2d15f78a339050de2a53d0ed797e01503a360879d1 |
| 0x4b42d3 | 572 | 6bedbe07f7f003f5efd3b2bd11a5ffe14c8b9a3aa74c7a6508b186548ca042ba |
| 0x4897cd | 509 | 715a602f9a6f12d750b580d6d7e6d51b73adab4e076b9bd4b531a3d96628423f |
| 0x4e0978 (not ported) | 1203 | 2ed09c82a3396e4d80c13cacab66b0da09b52b2c9b93810c442c9c9f01fbbf3a |

(0x469057 and 0x4b42d3 equal the `window_sha256` the ledger already records.)

## Mutation

`python3 tests/fl26a_mutation_check.py` (full, unsampled run, final tests): 136 mutants, 131 caught by the direct test (build failures and timeouts included), 3 more caught only by the Unicorn differential, 2 survivors (re-run after the review fixes: same counts). Both survivors are equivalent:

- line 168 (0x4b42d3) `rds16(self, 0x750) != 0` -> `rd16(...) != 0`: a zero test of a word gives the same answer sign-extended or zero-extended.
- line 199 (0x4897cd) `rds16(row, 4) != 1` -> `rd16(row, 4) != 1`: `movsx` of a word equals 1 exactly when the zero-extended word equals 1.

Known gap of the tool: mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width); multi-line guard deletion, `if (1)`, a dropped `||` operand and double edits are not modelled. The 16 hand mutants above cover some of these (forced branch, reordered effects, wrapped widening).

## Last commit

see git log

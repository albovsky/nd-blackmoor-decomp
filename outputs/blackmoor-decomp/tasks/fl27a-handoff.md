# FL-27 batch a (fl27a) handoff

Branch `worktree-agent-ab2e582729cf9fbef` (worktree `agent-ab2e582729cf9fbef`), based on `b19dff64` (FL-27 packet, branch `claude/fl27-family-35-ports-jak55w`; the worktree was created on the older `main` and was reset onto that packet commit before any work). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so. Commit hash: see `git log` (the last commit of the branch).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (16 of 16)

All in `src/original_methods_fl27a.c` / `.h`: thiscall methods take `self` (ecx) as a byte buffer with raw offsets, world globals in `Fl27aWorld`, callees and imports through the `Fl18Host` convention (`call(callee, this, args[], n)`, args[0] = last pushed = first argument; an import is named by its IAT slot). Pointer arguments are original addresses read through `Fl18Host.resolve`. One commit per function (the harness went in with 0x4de1f5).

| va | span | symbol | what |
|---|---|---|---|
| 0x4de1f5 | 31 | m4de1f5_clear_flags | `[self+0x991] = 0` (dword, odd offset), byte `[0x5a161f] = 0` |
| 0x4de214 | 19 | m4de214_clear_flags_thunk | calls 0x4de1f5 (natively) |
| 0x4de2d8 | 74 | m4de2d8_reset_caption | `[self+0x991] = 1`; 0x4e053f(ecx 0x570508, 1); 0x4e1113(ecx 0x570508); `[0x5b15d6] = [0x5d17f5] = 0`; 0x4de214 (natively) |
| 0x449d90 | 55 | m449d90_file_exists | fopen-like 0x50d0a9(path, 0x548aac); zero -> 0, else fclose-like 0x50cee4(file), 1 |
| 0x44c479 | 50 | m44c479_wait_state | while `[state] == 1`: Sleep(1); then 2 -> return 2, else `[state] = 1`, return 1 (only `ax` is set by the original) |
| 0x4bee2c | 51 | m4bee2c_get_field | 0x4bf38c; null handle: `[self+0x2c0] = -3`, return -1; else return `[handle+0xc]` |
| 0x4bef85 | 67 | m4bef85_bink_wait | 0x4bf38c; null: error code, 0; else `_BinkWait` (0x52a52c): non-zero -> 0, zero -> 1 |
| 0x4bee5f | 84 | m4bee5f_bink_summary | 0x4bf38c; null: 124 bytes at self+8 cleared (`rep stosd`), error code, 0; else `_BinkGetSummary` (0x52a508: handle, self+8), returns self+8 |
| 0x4befc8 | 92 | m4befc8_bink_do_frame | 0x4bf38c; `[self+0xbc] = 0`; null: error code, return it; else `[self+0xbc] = _BinkDoFrame` (0x52a528), return it |
| 0x4c2dfb | 96 | m4c2dfb_free_pair | slot -> p; p == 0: nothing; bit 0 of `[p+0x55]` clear: 0x4c2e5b(self, p), set: `[p] = 0`; then re-reads the slot, 0x51dc6c(slot value), slot = 0 |
| 0x4bef11 | 116 | m4bef11_bink_goto | 0x4bf38c; null: error code, -3; else `[self+0x2c4] = mode`; mode == 1 (dword): `_BinkGoto`(handle, `[handle+8]`, 0), other: `_BinkGoto`(handle, 1, 0); return 0 |
| 0x4bf098 | 119 | m4bf098_bink_copy_to_buffer | 0x4bf38c; `[self+0xbc] = 0`; null: error code; else `_BinkCopyToBuffer` (0x52a524: handle + 5 arguments + `[self+4]`) stored in `[self+0xbc]` and returned |
| 0x4bf315 | 119 | m4bf315_bink_open | 0x4bf38c, 0x4bede7; empty name: error -5, 0; else `_BinkOpen` (0x52a518: name, flags): zero -> error -6, 0; else the handle |
| 0x4159db | 134 | m4159db_dispatch_piece | byte `[a+0x20] == 2`: 0x415db9(self; a, word); else 0x415011(self; a), 0x50ca3e(0x63888b, 0x541dd8, byte re-read, a+0x151), 0x52139c(0x63888b, 0, 0), `[0x63a58a] = 4`, 0x4c97b4(ecx 0x5cf659) |
| 0x4bf10f | 139 | m4bf10f_bink_next | 0x4bf38c; null: error code, 0; mode (dword `[self+0x2c4]`) != 1: cur == total -> 0 else `_BinkNextFrame`, 1; mode == 1: cur == 1 -> 0 else `_BinkGoto`(handle, cur-1, 0), 1 |
| 0x4c0c7d | 194 | m4c0c7d_movie_thread | thread loop (see below) |

Names of the Bink imports come from the import table (`binkw32.dll`: `_BinkWait@4` 0x52a52c, `_BinkGetSummary@8` 0x52a508, `_BinkDoFrame@4` 0x52a528, `_BinkCopyToBuffer@28` 0x52a524, `_BinkGoto@12` 0x52a530, `_BinkNextFrame@4` 0x52a520, `_BinkOpen@8` 0x52a518; `Sleep` 0x52a2b0). 0x51ec84 is MFC `AfxEndThread(nExitCode, bDelete)` (stdcall, `ret 8`; it ends in `_endthreadex`). Stack shapes of every callee were taken from the callers (`add esp` after the call = cdecl) and checked against the callee's `ret N`; the oracle also asserts that every function pops exactly its own `ret N`.

## Dropped

None. 0x4c0c7d is the one judgement call: its loop head `mov ecx, 1; test ecx, ecx; je 0x4c0d32` never takes the jump (compiler `while (1)`), so that one jump DIRECTION is unreachable. Unlike 0x4e0978 (FL-26) and 0x4b5d17 (FL-25) the instruction at the target (0x4c0d32, the AfxEndThread call) is also reached by the `jmp 0x4c0d32` at 0x4c0ca5, so every instruction runs (55/55). The direction is on the allowlist `UNTAKEN_ALLOWED['4c0c7d']` with its reason. If root's rule is "no dead branch direction at all", drop its acceptance entry; the port and tests stand either way.

## Receipt blockers

0x4de2d8 has two (A-51:29188def10ea4702, A-51:c6f8b288bc870891). Both concern callee/UI behaviour (the renderer callbacks 0x4de24f, 0x4e053f, 0x4e1113 and the frame text box/caption layout backends), not a branch of the 74 bytes of 0x4de2d8. The located text names `0x4de24f/0x4de2d8` as stubbed callbacks in A-51; the oracle runs all 18 instructions of 0x4de2d8 with the callees stubbed, and the acceptance `blockers_reviewed` says so (the callees' own writes stay open). If root reads the blockers as requiring the callees' behaviour, drop 0x4de2d8 from the credit; nothing else depends on it.

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH` (xcrun wrapper of this environment).

- Direct and Unicorn differential, slice tests only: `python3 -m unittest tests.test_fl27a_direct tests.test_fl27a_differential` -> 34 tests, OK (18 direct: 16 functions, `test_sweep_bounded` and the run-all check; 16 differential).
- Original-bytes-only oracle: `python3 tests/fl27a_original_oracle.py` (exit 0); also under the recorder `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl27a_original_oracle.py` (identical summary lines, one trace file written).
- Sanitisers: `tests/fl27a_direct_test.c` + the port built with gcc `-std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined`: all 17 cases (16 functions and the sweep) PASS, no report (the sweep runs 400 rounds of arbitrary object bytes through every port, with waiting loops bounded by `native_spin_limit`).
- Mutation: see the Mutation section.

Oracle results (instructions reached / in the code window, conditional-jump directions taken / total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x4de1f5 | 10/10 | 0/0 | 16 | 4b65b363cb043aa98920431ff1c7f7294607743d84ee6d1bc2c11a538591c795 |
| 0x4de214 | 9/9 | 0/0 | 16 | 03a46e60b7813e8f024163822ef3d6230e01bdf863bc6e239487182a8434eb80 |
| 0x4de2d8 | 18/18 | 0/0 | 32 | 9f6a2b21fb571af8d06ec37c5f2305a941fa27de5c017f2acb6c60d3a6dd4728 |
| 0x449d90 | 21/21 | 2/2 | 21 | e68ced369b242d816e2f71af33caa23bfc5b5207fb8c5b55c64d9bf6694fb0c2 |
| 0x44c479 | 18/18 | 4/4 | 78 | 93c087c1fda4d10a9577510e6d05bc5f7000e1415ff75818bdfa103f8f9d415b |
| 0x4bee2c | 17/17 | 2/2 | 27 | 1161ac766e43ddf7704e9be08988cbbde8ad89e7052f4035a62e6de367a7af90 |
| 0x4bef85 | 23/23 | 4/4 | 27 | aa0b35f2c8681e8c6cb33ed9af8ceac0792b795e0824abf6a8c2255d7157dae0 |
| 0x4bee5f | 30/30 | 2/2 | 16 | a8bd694a01225f2e85b1763982c82f6b0de2a437b73d6130da6027b15c42e113 |
| 0x4befc8 | 25/25 | 2/2 | 27 | fb9ffad834da66e723ddb1103d68aa2aec3f729bc5b926faf20b29a6e3978ec9 |
| 0x4bef11 | 37/37 | 4/4 | 36 | 94bf4930dbe9bf8bef09cdd7195d6776d607c834b7dc1a2a6007d92b7fe736a9 |
| 0x4bf098 | 38/38 | 2/2 | 27 | 7f0de1719e02ab54e52d26a27b063f7ef51eb5672e168c1417df7616d73a2a91 |
| 0x4bf10f | 46/46 | 8/8 | 60 | 1ca25c1a526120bbdf8261d1db29f4d39dc0d9340e029e87d9d5bb844e318bc5 |
| 0x4bf315 | 39/39 | 4/4 | 44 | 362f9a1def3fdcc9fc84a639a28716d5533e0554e7c37b8217922dc3fcadc581 |
| 0x4c2dfb | 35/35 | 4/4 | 45 | 5625251f624437c0f1375cf8e10bdf165e334f4d5cd5d40b79ec52b83d087c11 |
| 0x4159db | 42/42 | 2/2 | 42 | bf6a1f974cd1561a7fea160c72640955c87444285446bdd8ca6504eb76879385 |
| 0x4c0c7d | 55/55 | 11/12 | 396 | f84c6fe91867f6bab745821d2cc30beecc8cb143b0511c20ac4c93e2a7a5dee4 |

The one untaken direction (0x4c0c97 `je`, taken) is the allowlisted one of 0x4c0c7d; every other conditional jump of every function goes both ways.

## Hooks (Unicorn differential and oracle)

Only OS and host boundaries are stubbed; no decision of a function under test is replaced. Each stub records its arguments (and `ecx` for thiscall callees) and the memory it sees at call time (the object, the Bink handle area, the slot, the state area, the globals 0x5a161f / 0x5b15d6 / 0x5d17f5 / 0x63a58a), pops its callee-cleaned stack bytes and returns a scripted `eax`.

- Callees (by entry address): 0x4bf38c, 0x4bede7, 0x4e053f, 0x4e1113, 0x415db9, 0x415011, 0x4c97b4, 0x4c2e5b, 0x41546f, 0x4156ea, 0x50ca3e, 0x51dc6c, 0x50d0a9, 0x50cee4, 0x44c4ab, 0x52139c, 0x51ec84. Not stubbed (original bytes run): 0x4de1f5 (inside 0x4de214 and 0x4de2d8's chain) and 0x44c479 (inside 0x4c0c7d); they are called natively by the ports.
- Imports (by IAT slot): Sleep 0x52a2b0, `_BinkWait` 0x52a52c, `_BinkGetSummary` 0x52a508, `_BinkDoFrame` 0x52a528, `_BinkCopyToBuffer` 0x52a524, `_BinkGoto` 0x52a530, `_BinkNextFrame` 0x52a520, `_BinkOpen` 0x52a518.
- Two extra hook capabilities, both at the host boundary: (a) a stub may store a value at its n-th call (`pokes`): the other thread that a waiting loop waits for (the Sleep stub of 0x44c479 and 0x4c0c7d), and the effect of a callee on memory that the function reads again (0x4c2e5b replacing the slot, 0x415011 changing the byte at `[a+0x20]`); (b) the stub of 0x51ec84 (AfxEndThread) stops the run, because the call does not return in the original.
- GetTickCount is not used by any function of the batch.

## Divergences and unverified branches

- Callees are stubbed in the oracle and a host callback in the native tests; the native code does not model any effect of a callee on `self`, a Bink handle, or a global that the function reads afterwards, except the three that the fixtures script explicitly with pokes (0x44c479 and 0x4c0c7d: the state/flag/word/selector changed at a Sleep; 0x4c2dfb: the slot replaced by 0x4c2e5b; 0x4159db: the byte at `[a+0x20]` changed by 0x415011). In those the port re-reads exactly as the original does (checked on both sides).
- Callee 0x4bf38c is called first by every Bink wrapper; its own effects (it may touch `[self+0x2c0]` or other fields) are the host's. The bytes of 0x4bf38c, 0x4bede7, 0x4e053f, 0x4e1113, 0x415011, 0x415db9, 0x4c97b4, 0x4c2e5b, 0x41546f, 0x4156ea, 0x44c4ab were read only as far as their `ret N` (stack shape); their bodies are not verified here.
- Word argument of 0x415db9: the original pushes `edx` after `mov dx, word [ebp+0xc]`, so the upper 16 bits are stale register contents; the port and the tests compare the low 16 bits only. 0x415db9's own use of the argument was not read (it is in batch b; its `ret 8` was checked).
- 0x44c479 sets only `ax` (`mov ax, 1 / 2`); the upper half of eax is the upper half of the pointer argument. The port returns 1 or 2; the oracle comparison masks 0xffff. 0x4c0c7d uses it through `movsx edx, ax`.
- 0x4bee5f returns the HOST pointer `self + 8` (the original returns its own object's address plus 8); the callee 0x52a508 gets the host pointer `self + 8` as its second argument. As in FL-26, a host adapter must say which side translates.
- 0x4bf315 measures the name with `repne scasb` (full scan to the terminator); the port tests only the first byte, which is equivalent for any terminated string. A name without a terminator runs off the memory in the original (unsafe, caller-validated here; no native rejection added because the port never scans).
- Native rejections (documented apart from valid input; they change no valid input): 0x44c479 returns `FL27A_REJECTED` (-1) after `native_spin_limit` Sleep calls (0 = 1,000,000) with the state dword still 1; 0x4c0c7d returns `FL27A_REJECTED` after that many passes without the stop flag, or when 0x44c479 is rejected. The original spins without end. 0x4c0c7d returns 0 after the host's AfxEndThread call returns (it never does in the original).
- Caller-validated, like FL-26: every address given to `Fl18Host.resolve` must resolve (NULL is dereferenced) and cover the bytes read or written (0x4bee2c 0x10 bytes, 0x4bef11 12, 0x4bf10f 0x10, 0x4c2dfb slot 4 and object 0x59, 0x4159db 0x21, 0x44c479 4 writable, 0x4c0c7d flag 4 and the 0x637fd3 area up to +0x1d2). The wait functions read the state dword byte by byte (volatile) because it sits at an odd address (0x637fd3).
- `Fl27aWorld` is a snapshot of scalars (the four original globals touched and the native bound); the original reads/writes globals at the instant of use. All scenarios keep the globals constant between a host call and the next read except where pokes say otherwise.
- Unreachable instructions: none. One unreachable jump direction in 0x4c0c7d (see Dropped).
- Not covered by the oracle: a Bink callee that fails in some way other than its return value (all scripted answers are 32-bit values); behaviour of the host callees themselves.
- No independent review; no claim that the batch or FL-27 is complete.

## Hashes

GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Native library: built from source per run (no checked-in binary); source hashes below.

| file | sha256 |
|---|---|
| src/original_methods_fl27a.c | 85b1cf213b55075c28468724ba0dc74c99e06879cb106cd3fdd9b39a7cab8786 |
| src/original_methods_fl27a.h | 8bf059d85839d40d2ed4dff1d963749f657ce89645a999ecc81063e113a22cbe |
| tests/fl27a_differential_shim.c | 2b9044e34d5313891e03f0dedb5a274636f40e29faf64e8b0b415016e23547ad |
| tests/fl27a_direct_test.c | 744f9591e5024ac6509d812861c8ccf91ff1c206ac311d408c2876956a9b91fd |
| tests/fl27a_fixtures.py | 79718bfbee70aca1d012764d9acaf0df83927d7246206b1f9244025ce0473607 |
| tests/fl27a_original_oracle.py | ed9f0855673b07276f2d8b38016d3d54893b470b25d8218b6662dc392aeee8dd |
| tests/test_fl27a_differential.py | 5fdebb5886af560106bf36eb3b410f62e37638c305614fe1aa8fc5ac80f82b9a |
| tests/test_fl27a_direct.py | fc4f4231ba6558974084cabd0a74605f3e0b427c768607e178e5783243d089d1 |
| tests/fl27a_mutation_check.py | e14bd5062a5dbbe50a8b96beeca51fdacce9993f438852369b9c524670d5fcf5 |

Code windows (sha256 of the original bytes, va to va+span; 0x44c479 equals the `window_sha256` the ledger already records):

| va | span | sha256 |
|---|---|---|
| 0x4de214 | 19 | 27166be5e0d0b40eb52b45e77558158f6facb5ca3e36a28e01b88ee2cfd4ebf8 |
| 0x4de1f5 | 31 | e69f20b8be8fb10814de0511f6487559b2dc8b0539a648ad1ba41738d3894c0b |
| 0x44c479 | 50 | 54c215e74ea4051a44fbcde7dd6a5d1412ae20c4c8a2d0a2d814175ddbd3d377 |
| 0x4bee2c | 51 | 686c4c9ff3b6a40b1eeb3f2134afc9ca9657f6a4da3f7f4d63f95759f39972df |
| 0x449d90 | 55 | c3ca6145390d9b2e1bc85660c49dc80a1485edf7e6d20b9cdff486f90057c172 |
| 0x4bef85 | 67 | 69fa0a5113f4db405b458b2d2555b0f01ac768ce9f23535b1d843d2b47897902 |
| 0x4de2d8 | 74 | 67a06f4f718125de269a25794f8a757c4ae0e530c34ffc851d57ff9f0cf3c0fb |
| 0x4bee5f | 84 | 8c952b45a931280f127c297be77a8b90b5fca399a53e4119f3209d5a479aec7e |
| 0x4befc8 | 92 | 59a12f309ea0a419703659113e52ab7218197e292bba55a7ae5675dc04a8b197 |
| 0x4c2dfb | 96 | 6a4c3acbf343bec7db627754cc259522de4be43b34801b51b31bbeef9098c455 |
| 0x4bef11 | 116 | e9ce0dd56561605180e985e9637699c5ab7649490b7c968e103fdfd3570c35af |
| 0x4bf098 | 119 | db2f5edd3e354c69850cfe30777772fc75860402a1608fc2e81e879b495d2c9e |
| 0x4bf315 | 119 | 243b91165921af0771acdea9476fd6f1e5ce1afba97cbed26f60887ad32ad021 |
| 0x4159db | 134 | 22d4d494ed470c374fc42a2afa715951fc23e6df411033abb7c136ccf3c302f5 |
| 0x4bf10f | 139 | 8ff4f95ff0aa5b703b2f812bf1ed8bed592c7ff1d2b1b452ef73e2d8440182e5 |
| 0x4c0c7d | 194 | cff40d965b12bab1174db0a316a544be07cefd1bdebf645b9465f38334c53837 |

## Mutation

`python3 tests/fl27a_mutation_check.py` (full, unsampled run, final tests): 139 mutants (hex literals raised by one, `==`/`!=` swapped, relational operators moved across their boundary, one-line guards deleted, rd16/rd32 width slips), 134 caught by the direct test, 1 more caught only by the Unicorn differential, 4 survivors, all equivalent:

- line 187 (0x4befc8) and line 228 (0x4bf098), `return (int32_t)rd32(self, 0xbc)` -> `rd16` in the null-handle arm: the dword was cleared to 0 two lines above, so a word read gives the same 0.
- line 307 (0x4c2dfb), `(rd32(obj, 0x55) & 1u)` -> `rd16`: bit 0 lies in the low word.
- line 366 (0x4c0c7d), `(int16_t)rd16(obj, 0x1cc)` -> `rd32`: the `(int16_t)` cast truncates the dword back to the same word.

A first run had 6 survivors; two were real fixture gaps and were closed (a mode of 0x10001 for 0x4bef11 / 0x4bf10f, whose dword is not 1 but whose word is; the hand mutant below for 0x44c479 needed states 0x102 / 0x10002). 65 hand mutants (multi-line, reordering, forced branches, dropped calls, swapped arguments, dword/word/byte compares, a store after instead of before a call, a dropped re-read, wrong error codes) were run with `python3 tests/fl27a_hand_mutants.py`: every one is caught by the direct test (a few by a build failure, which the final list replaced by building variants), including the ones that need the call-time probes (cleared-before-call order of 0x4de2d8, 0x4befc8 and 0x4bf098, the byte and slot re-reads of 0x4159db and 0x4c2dfb, and the native rejection of 0x44c479). The differential test additionally caught one mechanical mutant that the direct test missed.

Known gap of the tool: mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width); multi-line guard deletion, `if (1)`, a dropped `||` operand and double edits are not modelled by the script, which is why the hand mutants exist.

## Files owned

`src/original_methods_fl27a.c`, `src/original_methods_fl27a.h`, `tests/fl27a_differential_shim.c`, `tests/fl27a_direct_test.c`, `tests/fl27a_fixtures.py`, `tests/fl27a_mutation_check.py`, `tests/fl27a_original_oracle.py`, `tests/test_fl27a_differential.py`, `tests/test_fl27a_direct.py`, `tasks/fl27a-acceptances.json`, `tasks/fl27a-handoff.md`. `function-ledger.json`, `function-ledger-overrides.json`, `function-evidence.json`, `function-execution.json` are untouched.

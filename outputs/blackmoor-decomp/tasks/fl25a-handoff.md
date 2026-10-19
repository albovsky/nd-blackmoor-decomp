# FL-25 batch a (fl25a) handoff

Branch `worktree-agent-a5d92aa935c2db08a`, based on `9cb9b577` (FL-25 packet). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (6 of 10)

All in `src/original_methods_fl25a.c` / `.h`: thiscall with `self` = ecx as a byte buffer with raw offsets, world globals in `Fl25aWorld`, callees through the `Fl18Host` convention (`call(callee, this, args[], n)`, args[0] = last pushed), GetTickCount through `host->tick`.

| va | span | symbol | what |
|---|---|---|---|
| 0x45e1ca | 778 | m45e1ca_hit_test | ret 8; arm A loop, arm B double loop, tail rectangle; calls 0x45e4d4 with 0x27ed / 0x27ec / 0x27ef |
| 0x464792 | 803 | m464792_hit_test | ret 0xc; rectangle argument stored, 0x46465d, three fixed rectangles, five rows, 0x464ab5 |
| 0x4a835c | 827 | m4a835c_hit_test | ret 0xc; blocks of 0x90, rows of 16, 0x4a8007 / 0x4a8697, announcement globals (takes a non-const world) |
| 0x45841e | 896 | m45841e_hit_test | ret 0xc; three paths on [+0x20] and word [+0x3a], local rectangle for 0x45839e, 0x458262, 0x45879e |
| 0x45565f | 943 | m45565f_click_27c4_27c8 | plain ret; events 0x27c7..0x27c4, 0x27c8, word state machine, rows of 0x96 |
| 0x473206 | 1099 | m473206_click | ret 8; centre of a table rectangle, 0x4e22fd, record-object announcement, four block rows (byte or 0x4d5316), 0x473f7d, 0x4eb184, 0x47409e, GetTickCount, 0x47512a |

Record table at 0x5bb5e5: stride 0x8d, object address at +0, state dword at +0x4d. Hit-test x/y are sign-extended words compared as signed dwords.

## Dropped, with reason

- 0x4b5d17: dropped. Its block 0x4b5eb1..0x4b603c sits behind `mov edx, 1; test edx, edx; je`, a constant-true test, so those instructions are unreachable from any input and the packet's N/N instruction coverage cannot be met without patching the original. Porting it would need an agreed dead-code rule; left for root.
- 0x4712bd, 0x4b2250, 0x46bca9: not attempted (tool-call budget). Returned to the pool unchanged; no claim files or partial code exist for them.

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH` (clang shim of this environment).

- Direct and Unicorn differential, slice tests only: `python3 -m unittest tests.test_fl25a_direct tests.test_fl25a_differential` -> 14 tests, OK (8 direct: six functions, `test_sweep_bounded`, and the run-all check; 6 differential).
- Original-bytes-only oracle: `python3 tests/fl25a_original_oracle.py`; also under the recorder `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl25a_original_oracle.py` (same summary lines, one trace file written).
- Sanitisers: `tests/fl25a_direct_test.c` + the port built with gcc `-std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined`: all 7 cases PASS, no report. (clang in this environment has no ASan runtime, so gcc was used.)
- Mutation: `python3 tests/fl25a_mutation_check.py` (full run): 478 mutants, 22 survivors. 20 survivors are equivalent: a dword narrowed to a word whose result is then truncated to the low 16 bits, `wr16` stores that truncate anyway, word arguments of the callees that the host contract masks to 16 bits, and a redundant `else if`. The other two were fixture gaps in 0x473206 and are now fixed: line 529 (`rd32(self, 0x371) != 0` -> `rd16`) and line 515 (`rd32(self, at) == 0` on the dwords at 0x375 + 4w -> `rd16`). The Unicorn fixtures now also draw the dwords [+0x371] and [+0x375 + 4i] from 0x10000 and 0x01000000 (non-zero in the high word only), and `tests/fl25a_direct_test.c` has cases where only the high word is non-zero (0x47512a still runs and [+0x371] is cleared; the 0x4eb184 call is skipped). Hand mutants `rd32 -> rd16` at lines 515 and 529 now fail both the direct test and the differential. The tool has no `--lines` option; the two hand mutants were run with a scratch driver.

Oracle results (instructions reached / in the code window, conditional-jump directions taken / total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x45e1ca | 186/186 | 44/44 | 444 | 052189066d6203b05ba31816c6099324fa37bb059fcf6c2411439cb5c9ee6ca6 |
| 0x464792 | 230/230 | 68/68 | 534 | 8a404ce312e1c66e7f198fdd13061c3abc93dd5a3dd1b89e28c01a867c1bf57a |
| 0x4a835c | 207/207 | 36/36 | 360 | 37c2d81585dd505c4e5b6317fedc826caa77947c1480ba2d9b34c3380b2a403e |
| 0x45841e | 234/234 | 53/54 | 378 | c043b0f3c26a6a24879b3965ef3013bbc2687f14f09f35fe294535be56d61bb5 |
| 0x45565f | 219/219 | 40/40 | 288 | aa9a03aba37073af7a6f20c863ab644a999312408d33e1e4f93b51427896115c |
| 0x473206 | 257/257 | 40/40 | 384 | 0a5e8f6be33fedd15f08b7df04409bf7930a0c809f6cda69c4e8dd12aa95704a |

The one untaken direction is 0x4586f4 `jne 0x458746` in 0x45841e (allowlisted in `fl25a_fixtures.UNTAKEN_ALLOWED`): it repeats the compare dword [+0x20] != 5 whose negation led there, with no store or call in between, so it cannot be taken. All six windows are pure code (no data inside). The direction of a jump is read from the original run itself (every (instruction, next instruction) pair seen by the Unicorn code hook).

`tasks/fl25a-acceptances.json` has 6 entries (class `native_oracle_verified`, window = start to start+span).

## Hooks (Unicorn differential and oracle)

Only OS and host boundaries are stubbed; no decision of the function under test is replaced. Each stub records its arguments and the memory it sees at call time and returns a scripted value.

- 0x45e4d4, 0x46465d, 0x464ab5, 0x4a8007, 0x4a8697, 0x458262, 0x45839e, 0x45879e, 0x455ab8, 0x455a63, 0x455a0e, 0x455b2e, 0x455c4f, 0x4e22fd, 0x473651, 0x4d5316, 0x473f7d, 0x4eb184, 0x47409e, 0x47512a: recording stubs by entry address (the callees; recovered separately). 0x464ab5 and 0x4e22fd record word arguments by their low 16 bits (pushed from 16-bit registers).
- GetTickCount: IAT slot 0x52a23c.

## Divergences and unverified branches

- Callees are stubbed in the oracle and a host callback in the native tests; the native code does not model any effect of a callee on `self`, the record table or an object (host contract in the header: flush the world before and resync after each call).
- The world is a snapshot of scalars (`Fl25aWorld`); the original reads globals at the instant of use. All the scenarios keep the globals constant between the callee call and the read, which matches because the callees are stubbed.
- 0x4586f4 (above) is unreachable by the bytes; no native rejection was needed.
- 0x473206: the tick store uses the loop index k at the `break` (the original's register); the direct and differential tests cover k = 0..3 with the matching index. A loop that ends without a hit returns before reaching it, so k = 4 is never used.
- Unsafe original behaviour: none rejected. Out-of-range word indices (a record index outside -1..4 in the tests, a row index outside 0..3 in 0x473206) read memory the original would also read; the native code does the same on the host buffers and the tests never go there.
- P3, integration: in 0x45841e and 0x473206 the `Fl18Host.call` arguments mix host pointers (self+0x3e, &local, self+0x335) and guest addresses (record+0xe5, 0x5a4b5e+16k). The differential hides this by mapping addresses; the integration step must say which side the host adapter translates.
- No independent review; no claim that the batch or FL-25 is complete.

## Hashes

Code windows (sha256 of the original bytes, va to va+span):

| va | span | sha256 |
|---|---|---|
| 0x45e1ca | 778 | e5deb2d574791e94553f78d1bf472d3665447c9c1c228aeddc6b4711f591f0b5 |
| 0x464792 | 803 | d84503892c7653d362233b4ca75e3cc9367d36fc8b946d6177e16a99cb9976db |
| 0x4a835c | 827 | f5b0c1945a046602a9fe24a9067617173768e41e88bd9bd1dc24b59eff78b870 |
| 0x45841e | 896 | e6452ddecf37331d81e7f6c62fd506fca689130eb9a9c98c223288ff7bb2d2ac |
| 0x45565f | 943 | f9754edc898b93412a51a739efc5ebe229d7fc0262bd7e59b9f71817a6a8428c |
| 0x473206 | 1099 | e754ee96891c3c4375ac79094eafa610e3408c5a7562a2d3f126ecf93c1bf6e3 |

## Mutation

`python3 tests/fl25a_mutation_check.py --limit 80` (an even sample of the full mutant set; the unsampled full run was not done for lack of budget): 96 mutants, 87 caught by the direct test (build failures and timeouts included), 4 more caught only by the Unicorn differential, 5 survivors. All five are width-only swaps: `rd16(` -> `rd32(` at lines 374, 398, 426 (0x45565f) and `rd32(` -> `rd16(` at lines 476, 529 (0x473206). Not claimed equivalent: a word read widened to a dword survives where the two bytes after the word are equal in the fixtures, and a dword narrowed to a word survives where the high half is zero at that read. The original uses the stated widths there (checked in the disassembly while porting); these are gaps in fixture data to close in review. The differential of the owning function ran against each survivor and still passed, so the original-bytes fixtures share the gap.

Known gap of the tool: mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width); multi-line guard deletion, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Last commit

see git log

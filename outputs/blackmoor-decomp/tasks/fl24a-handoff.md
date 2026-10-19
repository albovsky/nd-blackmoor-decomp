# FL-24 batch a (fl24a) handoff

Branch `worktree-agent-a3bcb2485e019c11e`, based on `claude/fl24-session-input-2-9ro24m` (ed4f9258). Implementer: Claude Sonnet. No independent review has been done; the acceptance entries say so.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (12 of 12), none dropped

All are in `src/original_methods_fl24a.c` / `.h`, thiscall with `self` = ecx as a byte buffer with raw offsets, world globals in `Fl24aWorld`, callees through the `Fl18Host` convention (`call(callee, this, args[], n)`, args[0] = last pushed).

| va | span | symbol | what |
|---|---|---|---|
| 0x4d3bef | 46 | m4d3bef_reset_flags | clears [+0x462], sets [+0x1c] of the byte at 0x61c6ae |
| 0x44edfb | 466 | m44edfb_click_2785_2787 | events 2785/2786/2787, record state, 49-byte copies, nine-byte announce |
| 0x4cb3ab | 475 | m4cb3ab_store_flag | two arms, flag-table store, cdecl 50ca3e and 44a2b7 |
| 0x44eab1 | 510 | m44eab1_hit_test | item loop and four fixed rectangles, ret 8 |
| 0x46ebff | 545 | m46ebff_click_27c2_27c3 | events 27c2/27c3, tick, 4f6334/4fb2e3, 4709bb/4709de loop, 448d11 |
| 0x4571e1 | 572 | m4571e1_hit_test | 32-bit wrapping margins, item loop, ret 8 |
| 0x47b4aa | 607 | m47b4aa_hit_test | signed-byte gate, two row tables, 12-byte entries |
| 0x4a6574 | 639 | m4a6574_hit_test | five rectangles and a tail |
| 0x4a6946 | 664 (code 648) | m4a6946_click_276f_2770 | jump-table switch, string copies, announce; the 16-byte table is data, so instruction coverage uses the 648 code bytes |
| 0x470ffe | 690 | m470ffe_hit_test | rectangles, announcement globals (takes a non-const world) |
| 0x482724 | 740 | m482724_click_27b5_27b6 | events 27b5/27b6, word compares, 482595 byte result |
| 0x465c99 | 757 | m465c99_hit_test | row split at (hi-lo)/2, three rectangles, last |

Record table at 0x5bb5e5: stride 0x8d, object address at +0, state dword at +0x4d, index a signed word (`movsx`, `imul 0x8d`). Hit-test x/y are sign-extended words compared as signed dwords. Word arguments compare by low 16 bits.

## Verification

Run from `outputs/blackmoor-decomp`.

- Build and direct tests: `python3 -m unittest tests.test_fl24a_direct` (13 cases: 12 functions plus `test_sweep_bounded`).
- Unicorn differential: `python3 -m unittest tests.test_fl24a_differential`. With the direct tests, 26 tests, all OK.
- Original-bytes-only oracle: `python3 tests/fl24a_original_oracle.py`, and under the recorder with `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl24a_original_oracle.py`. The two outputs are byte-identical (checked with `cmp`).
- Sanitisers: `tests/fl24a_direct_test.c` built with gcc `-fsanitize=address,undefined -fno-sanitize-recover=all` at -O0, -O1 and -O2 (the bounded random sweep, 12 x 2500 iterations plus the case tables): clean.
- Mutation: `python3 tests/fl24a_mutation_check.py` (literal +1, ==/!= swap, guard deletion, width swaps and, new in the review-fix revision, relational boundary flips `<` <-> `<=`, `>` <-> `>=` in if/for/while conditions over each port; the differential of a surviving mutant now runs in a child process, so a mutant that crashes the shim counts as caught). Result: 665 mutants (24 of them boundary flips), 626 caught by the direct tests (including build failures and non-terminating mutants, which time out after 20 s and count as caught), 9 more caught only by the Unicorn differential, 30 survivors.

Mutation-tool gap (stated so that the tool is not over-read): its mutants are single textual edits (one literal, one operator, one one-line `if (...) return;` guard, one width). It does not model a deleted multi-line guard, `if (1)`, a dropped `||` operand, or a changed comparison against a constant (`== 3` to `>= 3` is only reached through the new boundary flips for `<`/`>`, not through `==`), nor two edits together, which is exactly where the review found the fixtures weak (the direct test caught those, the Unicorn differential did not). The branch-direction assertion above closes that class for conditional jumps of the original; the five review mutants were applied by hand as listed in the coverage claim.

Survivors (not claimed equivalent, except the one stated; they are gaps in fixture data, to be closed by review or a follow-up). The line numbers below are those of the port, which this revision did not change. 27 of the 30 are width-only swaps (`rd16` to `rd32`, `rds16` to `rd16`, `rd32` to `rd16`) at lines 153-171 (0x44edfb), 209 and 218 (0x4cb3ab), 293 (0x46ebff), 348 (0x4571e1), 395 (0x47b4aa), 489/495/508 (0x465c99), 544-579 (0x482724) and 679-691 (0x4a6946). A word-to-dword widening survives where the two bytes after the word are zero in the fixtures, and a signed-to-unsigned change survives where the word never has bit 15 set at that read. The original disassembly uses the stated widths and signedness at each of those reads (checked while porting), so these are weaknesses of the test data, not known divergences; the Unicorn differential test of the same function does exercise the instruction paths. Two are literals: line 208 (0x4cb3ab) `0x12` to `0x13` and line 569 (0x482724) `0x95` to `0x96`, field offsets whose neighbouring bytes carry the same fixture values. The thirtieth is the one boundary survivor, line 679 (0x4a6946) `i < n - 1` to `i <= n - 1` in the shift loop: the extra iteration copies word `[+0x94 + 2(n-1)]` from `[+0x96 + 2(n-1)]`, and the very next statement (line 680) stores `[+0x92 + 2n]`, the same slot, so no observable state differs; an equivalent mutant. Run: `python3 tests/fl24a_mutation_check.py` (about 40 minutes).

Coverage claim (review-fix revision). The scenarios of each function reach every instruction of the code window AND take both directions of every conditional jump (jcc, loop, jecxz forms) of it, with one allowlisted untaken edge: 0x4a6597 `jne 0x4a679f` in 0x4a6574 (byte `[+0x29]` != 0, the documented uninitialised-slot path; not fixtured; reason recorded in `fl24a_fixtures.UNTAKEN_ALLOWED`). The direction of a jump is read from the original run itself: the Unicorn code hook records every (instruction, next instruction) pair and the next address after each jcc says which way it went (`fl24a_fixtures.Original20`, `conditional_edges`, `check_edges`). `tests.test_fl24a_differential` asserts it for each function (and fails if an allowlisted edge is taken after all); `tests/fl24a_original_oracle.py` prints it and exits non-zero otherwise. 419 of the 420 directions are taken. Instruction reach alone did not show this: before the review fixes the fixtures never made 0x4f6334 answer non-zero in 0x44edfb, 0x46ebff and 0x4a6946, never failed the `[+0x12]` / `[+0x16]` gates of 0x4cb3ab (the pointers were stored after the gate bytes), never cleared `[+0xd3e]` in 0x470ffe, never had `[+0xa9]` == 1 with `[+0x92]` == 0 in 0x482724, and never combined `[+0x2c]` > 3 with the 0x58/0x60 rectangle hit in 0x465c99; a deleted guard at any of them left the Unicorn differential green and was caught by the direct test only. Hand-applied mutants (one at a time, then reverted), all now failing the differential of their function: delete the `!= 0) return` after the 0x4f6334 call (0x44edfb, 0x46ebff, 0x4a6946), delete the `[+0x12]` guard and the `[+0x16]` guard of 0x4cb3ab (the second makes the shim fault, process exit -11, which counts as detected), `if (self[0xd3e] != 0)` -> `if (1)` in 0x470ffe, drop `rds16(self, 0xa9) == 1 ||` in 0x482724, `rds16(self, 0x2c) == 3` -> `>= 3` in 0x465c99.

Oracle results (instructions reached / instructions in the code window, conditional-jump directions taken / total, scenarios, digest):

| va | instr | branch directions | scenarios | digest |
|---|---|---|---|---|
| 0x4d3bef | 15/15 | 2/2 | 12 | e53d4e19789450cf3ca0ffdaa1ce6f2b8a36e98a046410e66fce139036b8aa75 |
| 0x44edfb | 128/128 | 24/24 | 484 | 9c941456c2eb30886bf8a6f228a1f2fe46d7368463ec9813e150fac2e72b08df |
| 0x4cb3ab | 126/126 | 24/24 | 156 | 616c43f9bf8d0d4f5e044a6bc3d06ff4acab362533d4923d05a9b8423244e2dc |
| 0x44eab1 | 146/146 | 44/44 | 440 | 1fd0a6edd54b37f00db9c3d9e6238e8bc3aca476ab8415fa7b380d1dae06584f |
| 0x46ebff | 146/146 | 24/24 | 704 | cdd2b94e3254c00e66f6b178ab39b8d9596c475e81a8677cba2659521ac1299b |
| 0x4571e1 | 166/166 | 48/48 | 520 | cc832faa30655ea7a9861b25057a3a1e7ca26497bd9321c1e072a190a372d791 |
| 0x47b4aa | 159/159 | 32/32 | 680 | ddd4f84166bc59b0f626570855d7f2ed0f5c1985051a4699295f990970556add |
| 0x4a6574 | 179/179 | 63/64 | 520 | 347b575c4ff7ccea4f6db7189bd2f192e7e40487670b9876aa6c50bbfc8dc75a |
| 0x465c99 | 222/222 | 62/62 | 1215 | a8c8f3055966568769d093308ce230ab6ae9f61ed34d25ce7b57af941d7c485b |
| 0x482724 | 180/180 | 40/40 | 640 | eff3049c0e1f630d9a969c73713b97ae446212b5ce5ff2fa4b271a25ef1e722b |
| 0x470ffe | 149/149 | 34/34 | 480 | 61939cea4f89e84a313c76319932ca74062bc2c1462e7f2ff3471cb88463c5f7 |
| 0x4a6946 | 177/177 | 22/22 | 616 | a351cba8e3047628b194800594cce346672d08da696513b7bd56773d57f54158 |

`tasks/fl24a-acceptances.json` has 12 entries (class `native_oracle_verified`, window = start to start+span).

## Hooks (Unicorn differential and oracle)

Only OS and host boundaries are stubbed; no decision the original makes is replaced. Each stub records its arguments and the state it sees at call time, and returns a scripted value.

- 0x4f6334, 0x4fb2e3, 0x44ecaf, 0x50ca3e, 0x44a2b7, 0x4709bb, 0x4709de, 0x448d11, 0x45741d, 0x47b709, 0x4a67f3, 0x465f8e, 0x482595: recording stubs by entry address (the callees of these functions; recovered separately).
- GetTickCount: IAT slot 0x52a23c.

## Hashes

Code windows (sha256 of the original bytes, va to va+span):

| va | span | sha256 |
|---|---|---|
| 0x4d3bef | 46 | 54b97b80d61bcb1486bec09c9d41dbe49dfc88290912d0b1b612b18ad77bfe29 |
| 0x44edfb | 466 | c04e236320ab23a7b879129454bc1942aa0dba17166032cbbb23582481b4174b |
| 0x4cb3ab | 475 | da3fefcf655fa56e0f65469e029f17b2833668ce865d5bb9a76f7751c73b8aca |
| 0x44eab1 | 510 | ef70d31c4c608225926ef52c6a220e188f1c870cd6dbd0cc19153fe4e534b7e5 |
| 0x46ebff | 545 | 213d8f44003046cbba49bdb55cdbf7273f56671e22c1f27f9ff6cd27f20fd0fb |
| 0x4571e1 | 572 | d476e8318bd1bdbb9e82ec64aacce23fccfd7f8efb4ed8f0920e56fdfb000660 |
| 0x47b4aa | 607 | 976f6a0d3a04cea1356a2ae7b88f6276cafc011c9c54350834944bed000591df |
| 0x4a6574 | 639 | f69edef4407e87c1abcbebbd9706e1d525e8c76ba01f411a396c6026a0be7b09 |
| 0x465c99 | 757 | 73b39b4335e58aa195af51213735d01df79ca50cfad42215160ce134f261038c |
| 0x482724 | 740 | 104e459a861fa5a55905d936ff131298f7e225edfa36e340c16f8b8482dbb40c |
| 0x470ffe | 690 | 1a99ab253749788c02e0224f889d8dfcdf2d74f3b92e0989721b5121733255f9 |
| 0x4a6946 | 664 | 2ef83bf35c58e5be070d4d5a6ab6049ade3db22e48fad28fcae445d1a1e74a6a |

Files (sha256 at the review-fix revision; the port, header, shim, direct test and acceptances are unchanged by it; the direct test C file hash is the current file, which differs from the earlier table entry):

| file | sha256 |
|---|---|
| src/original_methods_fl24a.c | fe60a3e974d57042b10ebfeb8ab9b1f9a0c5b83b531a8bc02bc1557e4c1c7d75 |
| src/original_methods_fl24a.h | 511f14614ee5c82653ceff79ccf87827796c6cb597363e98bb7f76602d2f74d1 |
| tests/fl24a_direct_test.c | c8bd68bb6b81ed022ea26f1f867c360f2e85283d3a84d7f350fad6a6025dc848 |
| tests/test_fl24a_direct.py | d1216ee0c88d2093fbe70b4bd04156058cb55afddc23d14a600fff0622580f99 |
| tests/fl24a_differential_shim.c | 2ffc2d9d78e9c6ed38c775781d4d0ba3f4f83a53c1debe8bb713f39993bc7e7b |
| tests/test_fl24a_differential.py | 3983c8813baba72a6954efa3957ab7888eb684948e336150f4364adb41d99594 |
| tests/fl24a_fixtures.py | f614852906a74b90409aa7bdd634974621186ed8b54049a66310ae32bb92593d |
| tests/fl24a_original_oracle.py | 57c8a7960398c20d5b7cc683dd12d022c84ba0e5d5411ce1c877e25f9e5a56c9 |
| tests/fl24a_mutation_check.py | 683926d1b2d0414c2a2d144de5a7e6b13fbeb4f907c665709769fd2ef9035a85 |
| tasks/fl24a-acceptances.json | 0a24a29d4b483f25f710a4d0ebc5227638989a4235c74c2c397749d59af7e2ca |

## Deliberate divergences (native rejections of unsafe original behaviour)

- 0x4a6574: the original can dereference an uninitialised stack slot on one path; the port treats uninitialised locals as zero and rejects that path rather than reproducing stack garbage. Not fixtured.
- 0x4a6946: the string copy (`repne scasb`, `rep movsd`, `rep movsb`) into the 40-byte local buffer is unbounded in the original. A string of 40 bytes or more (no terminator within 40) would overwrite the saved record pointer at [ebp-4]; the port rejects it (effects before the copy stay, no tick, no store of [+0x90], no calls). Also, when the switch takes no arm (`[+0x25]` = 0, 5, 0x80000001, 0xffffffff) the kept string and word are uninitialised stack locals in the original and zero here; the oracle fixtures set the announce flag to 0 on those paths.

## Unverified branches and open points

- The uninitialised-slot path of 0x4a6574 and the default arm of 0x4a6946 above: original behaviour is stack garbage, not modelled.
- The callees listed under hooks are stubbed; their own behaviour is outside this batch.
- The ledger row for 0x4d3bef points at an FL-16 function; this packet's acceptance entry for it stands on the oracle but root should reconcile the ledger.
- No independent review yet; `function-ledger*.json`, `function-evidence.json` and `function-execution.json` are untouched.
- Oracle coverage of 0x4a6946 counts the 648 code bytes, not the 16 table bytes.

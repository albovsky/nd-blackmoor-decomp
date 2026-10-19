# FL-26 batch c (fl26c) handoff

Branch `fl26c`, created with `git checkout -B fl26c claude/project-thread-cmhyad` (base `1ad09e99`, the head of `claude/project-thread-cmhyad` that contains the FL-26 packet and the batch a and b merges; the worktree had been created from an older `main`). Implementer: Claude Sonnet. No independent review has been done; the acceptance entry says so. Nothing is pushed.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).

## Ported (1 of 1)

`src/original_methods_fl26c.c` / `.h`, symbol `m424346_node_condition`. Conventions as FL-25 / FL-26b: `Fl18Host` (`call`, `resolve`), `self` is the original `this` (ecx) as raw bytes, world scalars in `Fl26cWorld`, the effects keep the order of the original.

| va | span | symbol | what |
|---|---|---|---|
| 0x424346 | 1,890 (1,782 code + 23-entry jump table 0x424a3c + 4-entry jump table 0x424a98 = 108 data bytes) | m424346_node_condition | thiscall, `ret 4`; the argument is a node (original address). Loads the signed words kind [+0x10], a [+0x12], b [+0x14], [+0x16] (loaded, never used) and the dwords d [+0x20], e [+0x24], f [+0x28]; `cmp kind, 0x16; ja` (unsigned: a negative kind is out of range) then `jmp [kind*4+0x424a3c]` |

Arms (kind: what; every arm that evaluates a condition stores 1 or 0 into the dword [node + 4]):

- 0: always 1. 1: b = 1 and (dword 0x583bd5[a] == 1 or word 0x583a29 == a); b = 0 and (0x583bd5[a] == 0 and word 0x583a29 != a); else 0. 2: dword 0x585801[a] == b. 3: dword 0x581a71[a] == b. 4: dword 0x585d37 >= d (signed). 5: dword 0x585d41 >= d. 0xc: a == word 0x5bb20a. 0xf: word 0x58c94f == b.
- 9: q = node + 0x18, mode = word [q+6]: 1 -> table word 0x587b2d[word [q]] < word [q+2]; 2 -> `>`; 3 -> equal; else the diagnostic path 0x50ca3e(0x63888b, 0x5449a8, [0x5bb57b]), 0x52139c(0x63888b, 0, 0), 0x4c97b4(this 0x5cf659) with no result store.
- 0xb: obj = [node + 0x48], rr = [obj + 0x14]; if dword [self + 0x614] != 0: [node+4] = 1, [rr+0x24] = 0; else if word 0x583a29 == a: [node+4] = 1, [rr+0x24] = node; else [node+4] = 0 and [rr+0x24] = 0 when it equals node.
- 0xd / 0xe / 0x16: record at 0x585d65 + a * 0x106: live when its dword is 1, 5 or 6 (the original reads it up to three times); 0xd: live and dword [rec+4] <= d; 0xe: live and [rec+4] > d; 0x16: live.
- 0x10: b = 1 -> dword 0x5bb202 == 0; b = 2 -> 0x5bb202 != 0; else 0. 0x11: r = 0x4f6334(this 0x5cf1eb; a as a dword); b = 1 -> r != 0; b = 0 -> r == 0; else 0.
- 6 (second jump table 0x424a98 on b, unsigned compare with 3): 0: dword 0x585d4b >= d; 1: <= d; 2: == d; 3: with e <= f the value is in [e, f]; with e > f it is in [e, 0x59f] or in [0, f] (all signed); b above 3 (or negative): the diagnostic path with format 0x5449e8.
- 0x14: only when dword [node + 0x2c] == 0: r = 0x50cd50(); [node+0x30] = r % 100 (signed idiv); when word 0x63a4cd != 0 and b is outside 1..100: 0x50ca3e(0x63888b, 0x544a34, [0x5bb57b], b) (four arguments), 0x52139c(0x63888b, 0, 0), 0x44a2b7(0x63888b), 0x4c97b4(this 0x5cf659); then (always) [node+4] = ([node+0x30] < b, signed) and [node+0x2c] = 1.
- 0x15: dword 0x5c3a47 != 0.
- 7, 8, 0xa, 0x12, 0x13 (the table entries that point at the default code) and every kind above 0x16 or negative: 0x50ca3e(0x63888b, 0x544a80, kind), 0x42639d(this 0x583979; 0x544a88, 0x63888b) (ret 8), 0x4c97b4(this 0x5cf659); no result store.

The indexed tables are read through `Fl18Host.resolve` at their original addresses (not through world pointers), so a wild index is an unresolved address and rejected, not a wild host read.

Acceptance entry: `tasks/fl26c-acceptances.json`, 1 entry, class `native_oracle_verified`, window `0x424346`..`0x424aa8`. `function-evidence.json` lists no blocker and no divergence for 0x424346, so `blockers_reviewed` is empty. Note: the A-2E.1 blocker `6cca21030ace49fd` (dependency construction in 0x424aa8, 0x423f57, 0x424201) that the 0x424201 entry in batch b reviewed names this function as a callee but is not recorded against 0x424346.

## Dropped, with reason

None. (The packet named 0x424346 as the most likely drop; it fits because it has no loops, no string handling and no callee that changes state it reads back, so the whole body runs under the original-bytes oracle.)

## Verification

Run from `outputs/blackmoor-decomp` with `export PATH=/tmp/claude-0/shim:$PATH` (compiler shim of this environment).

- Slice tests: `python3 -m unittest tests.test_fl26c_direct tests.test_fl26c_differential` -> 18 tests (16 direct cases + the run-all check, 1 differential), all OK.
- Original-bytes-only oracle: `python3 tests/fl26c_original_oracle.py` (exit 0): `0x424346 instructions 451/451 branch-directions 116/116 scenarios 2292 digest bdb73a67afe05598dde2ed26cf8f7caa2de882936a77044c245dcf1bfda6ea33`. The code window is the 1,782 code bytes (`code=1782` in the fixtures); the 108 bytes behind them are the two jump tables, not code. No untaken conditional-jump direction: `fl26c_fixtures.UNTAKEN_ALLOWED` is empty. Every table entry is reached (kinds 0..0x16 including the five default entries, kinds above 0x16 and negative, b = 0..3 and the out-of-range arm of kind 6). The Unicorn differential requires the same instruction and direction coverage and compares the whole memory (node, self, object, [rr + 0x24], the five tables, the globals), the bytes popped, and the ordered calls (callee, ecx, arguments, and the node/rr bytes at each call).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl26c_direct_test.c src/original_methods_fl26c.c`: all 16 cases PASS, no report (the sweep runs 6000 random rounds including unresolvable nodes, NULL `self`, wild `rr` and table indices).
- Mutation (`python3 tests/fl26c_mutation_check.py`, full run): 210 mutants, 196 caught by the direct test, 8 more only by the Unicorn differential, 6 survivors, all equivalent and reasoned (line numbers of `src/original_methods_fl26c.c`): 159 (`0x16` -> `0x17` and `g16s` -> `g32` on the discarded read of the word at +0x16: the same address resolves, nothing is used), 166 (`0x16u` -> `0x17u`: kind 0x17 then reaches the `default` arm, which calls the same diagnostic function), 232 (`mode == 3` swapped: the two orders only differ in the order of three pure reads of one object), 303 (`(int16_t)world->word_63a4cd` -> `(int32_t)`: the field is already an int16_t), 309 (`g32` -> `g16s` on the read of [node + 0x30], which the function has just stored as r % 100, a value in -99..99 that a signed word reads back identically). Earlier runs found redundant CHK() lines (a failed read leaves `c.bad` set, so a later CHK() or the final one before the result store already stops; the redundant ones were removed) and, with `test_partial_reads_reject` and `test_kind_0x14_holes` (a one-byte hole in the host address map at node + 0x28, + 0x1e, + 0x48, and at + 0x2c, + 0x30, + 4 for kind 0x14), the checks that matter are killed. Known gap of the tool: mutants are single textual edits (one literal, operator, `?:` result, statement, CHK or width); double edits, reordered effects and multi-line deletions are not modelled.

## Hooks (Unicorn differential and oracle)

Only host boundaries are stubbed (recording stubs by entry address; they pop their arguments and return scripted `eax`): 0x4f6334 (thiscall, ret 4), 0x50cd50 (cdecl, no argument), 0x50ca3e (cdecl varargs: 3 logged arguments, 4 at the one call site 0x42497b whose return address 0x424980 the stub hook checks), 0x52139c (stdcall, pops 12), 0x44a2b7 (cdecl, one argument), 0x4c97b4 (thiscall), 0x42639d (thiscall, `ret 8`, checked at 0x426425). No decision of the function under test is replaced. Call logs include the bytes of the node (0x50) and of the object behind [[node+0x48]+0x14] (0x30) as they are at each call.

## Divergences and unverified branches

- Native rejection (no counterpart in the original, `int32_t *reject`, tested in the direct test and the sweep): `FL26C_REJECT_UNRESOLVED` for an address that `Fl18Host.resolve` cannot resolve (node, table index, object pointer, the pointer behind it) and for a NULL `self` where kind 0xb reads [self + 0x614]. The call stops there; effects already made stay made (for kind 0xb the result store precedes the failing [rr+0x24] store). The function has no loop, no buffer and no division by a variable, so there is no endless-loop or overrun rejection. Review fixes (P2/P3): kind 0x14 now CHK()s the read of [node + 0x2c] and, before the random draw 0x50cd50 and any diagnostic call, preflights that [node + 4] and [node + 0x30] resolve (the original would fault at the store after the calls; the port rejects before any host call, a native-only ordering difference on a path the original cannot survive); a host without `call` or `resolve` (or a NULL host) is rejected at entry with FL26C_REJECT_UNRESOLVED instead of returning 0 silently (`test_null_host_rejects`); the header now lists the kind 0x14 stores ([node + 4], [node + 0x30], [node + 0x2c] = 1) and the mapping contract (resolve is asked for the first byte of an access only: the host must map the whole width, 2 bytes per word, 4 per dword).
- The word [node + 0x16] is loaded by the original and never used; the port reads it (a resolve-only read) and discards it.
- Structure: the original compares `kind` against 0x16 unsigned and then jumps through a 23-entry table whose entries 7, 8, 0xa, 0x12, 0x13 point at the same code as the out-of-range path (0x424a02); the port compares against 0x16, switches, and gives the arms without a case the same diagnostic function. The jump tables are data and are not ported as tables.
- Callees are stubs; a callee that changes `self`, the node, an object or a global that the function re-reads is not exercised (kind 0x14 re-reads [node + 0x30] after the diagnostic calls; kind 0x11 uses the returned `eax` of 0x4f6334; the diagnostic callees' own behaviour, including whether 0x52139c / 0x44a2b7 return, is outside this function).
- Fixture limits: the tables are covered for dword indices -8..8 (0x583bd5, 0x585801, 0x581a71), word indices -16..16 (0x587b2d) and records 0..3 (0x585d65); the record index a in -1..3 for the kinds 0xd, 0xe, 0x16 (the original handles a = -1 as an ordinary record at 0x585c5f, so the oracle and differential cover it with a separate 8-byte area; the bytes above it hold the globals 0x585d37.., so no wider window); a <= -2 is exercised only by the native rejection test. Wild indices are exercised only by the native rejection tests, not by the original oracle.
- Integration note (P3): the one argument of 0x4f6334 is the sign-extended word a; the first argument of the 4-argument 0x50ca3e call is the format; the host adapter must say which side translates original addresses (all pointer-like arguments here are constants or the node address, none is a host pointer). 0x424201 (fl26b) currently stubs this function as a host call by address 0x424346; the integration step may replace that stub with `m424346_node_condition`.
- No independent review; no claim that the batch or FL-26 is complete.

## Hashes

Code window (sha256 of the original bytes): va 0x424346, span 1,890: `5672164e09b143d391d76bbacc1075b7a0e3e9bf3b64d4bbb5bc58051faacb01`; the 1,782 code bytes: `6ef61d36effbd2005a44bc6657536230683d1b1e885449958c0f0a434f627704`; the 108 jump-table bytes: `e04e0c94e4e4af56730fddf9d876068f133d7908942affca732440d004585fd2`.

Files (sha256): `src/original_methods_fl26c.c` 629b0647814925f558abb491a1f1b34df0b77ba229bc28d1f1c185d896c5a4d2, `src/original_methods_fl26c.h` 9ca0b9acc4afb8b72c0c1bfb6c846205e07162ff3f3d3e80d28b20c24c963a29, `tests/fl26c_fixtures.py` 9db46a0a62d824b42b49aa8d93c27b3d319b2b2da239c36d804ab9695a06ed7b.

## Last commit

see git log

# FL-27 batch b (`fl27b`) handoff

Branch `worktree-agent-a1ff74d24a1f8aaed`. Nine of the thirteen listed functions are ported 1:1 with direct tests, Unicorn differential tests against the original bytes, an oracle script with full instruction and branch-direction coverage, and a mutation check. Four are dropped (below). No independent review has been done: every acceptance entry says so in its `reviewer` field, and root must have the `slice-reviewer` confirm before collection. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (checked by the oracle on every run). Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited; `tasks/fl27b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries).

## Files

- `src/original_methods_fl27b.h`, `src/original_methods_fl27b.c`: the ports (symbols `m<va>_*`, the world struct `Fl27bWorld`, host convention `Fl18Host` as in batch FL-18/26).
- `tests/fl27b_direct_test.c`, `tests/test_fl27b_direct.py`: hand-derived direct tests and a bounded sweep (also run under ASan/UBSan).
- `tests/fl27b_fixtures.py`, `tests/fl27b_differential_shim.c`, `tests/test_fl27b_differential.py`: Unicorn differential tests (original bytes vs the native symbol on the same generated fixtures; ordered host calls with arguments and the memory behind them compared).
- `tests/fl27b_original_oracle.py`: coverage oracle (one summary line per function; exit 0 only with every instruction executed and every branch direction taken or allowlisted with a reason).
- `tests/fl27b_mutation_check.py`: textual mutation check.
- `tasks/fl27b-acceptances.json`: acceptances, with `blockers_reviewed` for 0x4c5377.

## Ported (commit per function; last port commit c9d5eacf)

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x449bff | 253 | m449bff_resume_thread | 77/77 | 12/12 | 174 | 87bd6e5577be657025ab0f8b0b259bf2f66e1980df307ed4455da002f87743fc | c27f5aa0b42dfbc2f8981e50b6e9e1e2e604177d0c0a3805bad9e32774e0846c |
| 0x449a94 | 273 | m449a94_stop_thread | 84/84 | 14/16 (2 allowlisted) | 90 | 0cc635ec998fca86d12a9e2a1ca2d21cb8c625e171f15ee9363b71f84509c5d0 | 720b11933709f732ac47abd039c5a915bfaf66ae6ce5a9d33cdefba8cab57d1f |
| 0x4bf773 | 308 | m4bf773_release_player | 85/85 | 12/12 | 210 | d1cf80567cfc66f55983fc6f14232e0b7feeae9c2fcf1fa94206c18d3602efb0 | b188addc3169e5c437f751302769aaba7a26d9cd8cc3af0148b30236bc03b73f |
| 0x4161d1 | 346 | m4161d1_alloc_buffers | 86/86 | 10/10 | 148 | 07632a225ef8c63fbf1a8cef96aeda9bfa3ff16a42f9b140ac6ef108ec85aaae | 9b1dc6ed8fb242f085b8bcbd693dbcaf5c70425e7cab3adc9b92ece2203a55eb |
| 0x4c2c3a | 449 | m4c2c3a_make_record | 144/144 | 8/8 | 296 | 39632bc625c4def1e134822184b928e9d3652726f989d7aa312afa92740a07d4 | 85c06c99894a04187283cd32d1bcf32df9e8508bfdc8bfe52413829c60398775 |
| 0x4c0d3f | 497 (483 code) | m4c0d3f_present_rect | 143/143 | 28/28 | 320 | 339558c5962a72a5db074f927d32341a5ce91e405346fc608d28a4f01fe30cdd | 48bf6a0f4c7cad86b215ab0c245a69fae7ef1b7e46a3152442dbc2c229424391 |
| 0x4c5377 | 532 | m4c5377_blit_rows | 165/165 | 14/14 | 336 | ec4f78e1324c8f2ab3f31c830393940d8a6ddc0a9c243cee730dce7129f07df0 | c3a031588738495a441eb125c4395b7538e0b99f22ccf14afdbf78eb1bb6d06b |
| 0x4c04e3 | 657 | m4c04e3_start_movie | 163/163 | 20/20 | 216 | a16c3e5fea38be9be8403df6686864f1879a2022c2e463b01a462686fc1a045b | 588bc16e5e4db5b1326a0feb1056f789c634a7af0d72464a96b04aef5ac2c1c0 |
| 0x415db9 | 722 | m415db9_unpack | 202/202 | 14/14 | 42 | e56c17abdd57ec4b378612dbf3d2285b63c8f786ae956f140e924c8422092f94 | 78599b1a90603040c67e238dc3df985540abbf9ea86823fa19c5994bab43c9dc |

The digest is the sha256 of the ordered calls and the memory read back over all scenarios of the function. 0x4c0d3f has 14 trailing data/padding bytes inside the 497-byte span; its 483 code bytes are fully executed.

Commands (from `outputs/blackmoor-decomp`, `export PATH=/tmp/claude-0/shim:$PATH`):

- direct: `cd tests && python3 -m unittest test_fl27b_direct` (11 tests, builds the C test with `-Werror`).
- differential: `cd tests && python3 -m unittest test_fl27b_differential` (needs Unicorn; run per function or all).
- oracle: `cd tests && python3 fl27b_original_oracle.py` (prints the nine lines above; exit 0 only on full coverage).
- mutation: `python3 tests/fl27b_mutation_check.py` (from `outputs/blackmoor-decomp`).
- sanitisers: the direct test binary built with gcc `-fsanitize=address,undefined` (clang here has no ASan runtime), run with the bounded sweep: all nine tests plus `test_sweep_bounded` PASS, exit 0.

## Hooks (everything the oracle and differential stub; nothing the original decides is replaced)

All callees are stubbed at their entry address (the original function is not run), recording ordered arguments, `ecx` where a thiscall, and the memory behind the object at the call. Where a callee changes the object or a local in the original, the stub applies a scripted write at that call (documented in the generator).

- 0x449bff: 0x52a284, 0x50ca3e, 0x44a2b7, 0x4264e8, 0x4c97b4; scripted re-write of `[self+0x36]` where a callee changes it.
- 0x449a94: 0x449bff, 0x52a2b0, 0x52a280, 0x426367, 0x44a2b7, 0x50ca3e; scripted store of the thread exit code where the original callee writes it.
- 0x4bf773: 0x44c479, 0x449a94, 0x44c4ab, 0x44a2b7, 0x415011, 0x4c2dfb, 0x41632b, 0x4bedfa; scripted re-write of `[self+0x1d6]` where a callee changes it.
- 0x4161d1: 0x51dc43 (allocator), 0x50ca3e, 0x52139c (stdcall `ret 0xc`), 0x4c97b4.
- 0x4c2c3a: 0x51dc43, 0x42639d, 0x4c97b4.
- 0x4c0d3f: 0x4c5377 (both calls: the second with two host pointers to the local rectangles, compared by content).
- 0x4c5377: 0x50ca3e, 0x52139c, 0x4c97b4, 0x4c4067 (scripted fill of the descriptor), 0x4c4202, 0x4c952f.
- 0x4c04e3: 0x4befc8, 0x4bf098, 0x4bee2c, 0x4c0ab1, 0x4c08d3, 0x4bef85, 0x4bf10f, 0x50ca3e, 0x44a2b7.
- 0x415db9: none. The `call 0x50c920` stack probe (`__alloca_probe`) is executed as the original bytes under Unicorn; the native port has no corresponding call (it has no effect on data).
- Debug words: the global debug word 0x63a4cd is patched into the image per scenario (and the two bytes behind it are compared-out neighbours, so a dword read would show).

## Deliberate divergences and native rejections (not original behaviour)

- 0x415db9: a length dword above 0x7fffffff returns 1 before reading anything (the original would read past the buffer or loop). The 0x12 ring bytes the original leaves uninitialised (stack garbage) are zero in the port; the fixtures never read them before they are written, and the header says so. The output length is not bounded by the original and is the caller's contract.
- 0x449a94: an original null store (access violation) on the 0x449aed branch is a native rejection (the branch is allowlisted as untaken in the oracle; see below).
- Other functions: null-pointer and negative-count rejections are listed in the header comments of `src/original_methods_fl27b.h` and tested in `tests/fl27b_direct_test.c` separately from valid input.

## Allowlisted untaken branch edges

Only 0x449a94: 14 of 16 directions.

- 0x449ab9: a consecutive re-test of the same dword as the compare before it, so the second direction is unreachable on any input.
- 0x449aed: leads to an access-violation null store in the original; covered by the native rejection, not run in the oracle.

All other functions: every direction taken.

## Dropped (not ported, no code written)

The last four listed functions were not started: 0x4497a0 (728 bytes), 0x414ceb (806), 0x4c2e97 (1208), 0x44c4c1 (1306). Reason: the tool-call budget for this task ran out after the ninth port; each needs its own fixture generator with scripted callee effects (the packet's smallest-first order was followed), and a rushed port without full instruction and branch coverage would not meet the acceptance bar. They are not claimed and remain open for a follow-up batch; 0x4bf9bb and 0x413187 were left alone as told.

## Mutation check

`python3 tests/fl27b_mutation_check.py` on the final nine-function source: 381 single-edit mutants (hex literal +1, `==`/`!=` swap, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32` width swap). 339 caught by the direct test, 17 more only by the Unicorn differential test, 25 survivors (below). The check is textual and single-edit; its known gaps are listed in the script header.

Survivors, with the reason for each:

- 0x449a94 line 122, literal 0x36 -> 0x37: the port keeps the original's own second test of `[self+0x36]` right after the first one returned on zero (the allowlisted 0x449ab9 re-test). The mutant would read a different dword; no fixture has `[+0x36]` non-zero with `[+0x37]` dword zero. Fixture gap, not an equivalent mutant; the port itself is correct against the bytes.
- 0x4c2c3a lines 266, 267, 270, 271, 272 (five literals of the zero stores into the new record): equivalent. The port (like the original) clears the 0x59-byte record first (`memset(rec, 0, 0x59)`), so these stores write zero over zero.
- 0x4c5377 lines 331 and 332 (`text[0xfb]`, `desc[0x7c]` sizes +1): equivalent, buffer sizes.
- 0x4c5377 lines 362 and 379, `rd16` -> `rd32`, and 0x4c04e3 lines 398 and 399, `rd16` -> `rd32`: equivalent. Each is wrapped in `(int16_t)` so the wider read is truncated to the same word.
- 0x4c5377 lines 345 to 352 (`rd32` -> `rd16` on the eight rectangle coordinates in the debug diagnostic): were a real fixture gap (coordinates with bits above the low word never occurred). A direct case with negative and above-0xffff coordinates (`fl27b_direct_test.c`, "full dwords") was added after the mutation run and passes; the mutation check was not re-run afterwards, so these eight are still listed as survivors of the recorded run.
- 0x4c5377 line 376 (`0x7fffffff` -> `0x80000000` and `>` -> `>=`): the threshold of a native-only rejection (`rowbytes` above 0x7fffffff); the original copies about 4 GB there, so the exact boundary cannot be driven by a fixture. Not an original-behaviour rule.
- 0x415db9 lines 448 and 459 (`ring[0x1000]` size and the `0x1000 - 0x12` space fill, +1): equivalent for every stream the oracle compares. The size only widens the array; the fill covers one more ring byte at the write position, which is always written before it is read. Line 454 (`>` -> `>=`): the threshold of the native-only length rejection, as above.

Hand mutants (deleted multi-line guards, `if (1)`, dropped `||` operand) from the review fixes of earlier work are not part of this batch; no hand mutants were applied to the new ports beyond the mechanical set.

## Unverified / open

- No independent review (see top).
- 0x415db9: streams that read the uninitialised ring tail are outside the comparison (original-dependent garbage).
- Receipt blocker for 0x4c5377: `blockers_reviewed` rationale in the acceptances says only the callee is verified; the UI lifecycle that calls it (S05 item 0, S05-2) stays open.
- Callee semantics are not verified here: every callee is a stub; only the call order, arguments and effects on the object are.

# FL-25 batch b handoff (4 of 9 ported)

Branch `worktree-agent-a954db816b487f530` (worktree `.claude/worktrees/agent-a954db816b487f530`). The worktree was created from an older `main`; it was reset (own branch, no prior commits) to `claude/project-thread-219yxj` at 9cb9b577 (the FL-25 packet commit) before any work. One commit per function on top (694ac212 0x455180, 1adc9d19 0x4cb058, c3f1d915 0x4a3f40, 556a9a55 0x4588ad); the tip is the commit that adds this note. No independent slice-reviewer pass has been done. `function-ledger*.json`, `function-evidence.json`, `function-execution.json` were not touched. Not pushed. The files copy the FL-24b shapes (renamed `fl25b`, `Fl25bWorld`).

## Ported symbols (`src/original_methods_fl25b.c/.h`, `Fl18Host` convention)

| va | span | symbol | instructions executed (original) | scenarios |
|---|---|---|---|---|
| 0x455180 | 827 | `m455180_hit_test` | 229/229 | 640 |
| 0x4cb058 | 851 | `m4cb058_hit_test` | 191/191 | 720 |
| 0x4a3f40 | 896 | `m4a3f40_hit_test` | 244/244 | 720 |
| 0x4588ad | 901 | `m4588ad_click_279f_27a5` | 215/215 | 960 |

All four also reach BOTH directions of every conditional jump (the differential test requires it; `fl25b_fixtures.UNTAKEN_EDGES` is empty). 0x455180, 0x4cb058 and 0x4a3f40 are hit tests (`ret 0xc`, `ret 8`, `ret 0xc`; eax = 1 or 0); 0x455180 and 0x4a3f40 take a pointer to four dwords as the third stack argument, ported as `const uint8_t *block`. 0x4588ad is a plain-`ret` click handler.

## Dropped / not started (5)

- 0x47b767 (786): DROPPED, not ported. Two debug tails are provably unreachable code: at 0x47b9b4 and 0x47ba3f the original executes `mov edx,1; test edx,edx; je` (resp. `mov ecx,1; test ecx,ecx; je`), so the `je` never jumps and the 10 instructions each at 0x47b9c6..0x47b9e7 and 0x47ba51..0x47ba72 (a `call 0x427a40` printf-like) cannot run under any state. By the packet rule (N/N or an unreachable edge reported; "if the instruction itself cannot run, drop the function") the function cannot reach N/N. Everything else in it is straightforward (guards, selectors 0x2768 / 0x2769, a 0xc-byte table at [+0x14], calls 0x4fb2e3, 0x47d02d, 0x47badf, 0x47cd90, 0x47ce6f, GetTickCount); if root decides to credit it with 20 dead instructions excluded, it is a quick port.
- 0x4a8818 (986), 0x4aa3d2 (1100), 0x46c6a9 (1506), 0x4a44c0 (1877): not started, tool-call budget exhausted. Observations from the disassembly only: none has dead `mov reg,1; test` tails; each has several `repe cmpsb` / `rep movsd` nine-byte and record copies; 0x4a44c0 has one `jmp dword ptr [table]` switch (index and jump tables inside the span, so the coverage target is the code bytes only); callees: 0x4a8818 {0x4a8bf2, 0x4f6334, 0x4fb2e3}, 0x4aa3d2 {0x423259, 0x448d11, 0x4fb2e3, 0x4fb77a}, 0x46c6a9 {0x46cc8b, 0x4f6334, 0x4fb2e3}, 0x4a44c0 {0x4a4d55, 0x4f6334, 0x4fb2e3}. Return them to the pool.

## Files (all owned by this batch)

`src/original_methods_fl25b.c`, `src/original_methods_fl25b.h`, `tests/fl25b_direct_test.c`, `tests/test_fl25b_direct.py`, `tests/fl25b_differential_shim.c`, `tests/test_fl25b_differential.py`, `tests/fl25b_fixtures.py`, `tests/fl25b_original_oracle.py`, `tests/fl25b_mutation_check.py`, `tasks/fl25b-acceptances.json`, this note.

## Commands and results (from `outputs/blackmoor-decomp`, `work` symlinked to the evidence directory)

- `python3 -m unittest tests.test_fl25b_direct tests.test_fl25b_differential`: 9 tests OK (direct: 1 all-cases check + 4; differential: 4).
- `python3 tests/fl25b_original_oracle.py`: exit 0, four lines `0x... instructions N/N scenarios M digest ...` (digests below). Original bytes only, no native library.
- ASan/UBSan: the direct binary built with `gcc -std=c11 -Wall -Wextra -g -fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer` at -O0 and -O2: all 4 cases PASS, no sanitizer output. No random sweep: sanitizer coverage is the tested inputs, which stay inside the buffers by construction.
- Mutation check `python3 tests/fl25b_mutation_check.py [--range A-B | --lines N,N]` (literal +1, `==`/`!=` swap, guard deletion, rd16/rd32/rds16 width slips; direct test first, then the Unicorn differential of the function). 0x455180 lines 109-177: 90 mutants, direct 72, differential only 12, 6 survivors before a fixture fix (the word after `[E+0x94]` is now zero in half of the scenarios and in the direct case v=0) which killed the 0x95 literal mutant; remaining survivors 5, all equivalent. 0x4cb058 lines 178-264: 108 mutants, direct 96, differential 5, 7 survivors, one (`rd32(self, 0x12)` -> 0x13) killed by a direct-test change (`[+0x16]` low byte non-zero in the G1 case); remaining 6 equivalent. 0x4a3f40 lines 265-331: 57 mutants, direct 50, differential 6, 1 survivor (equivalent). 0x4588ad lines 332-434: 103 mutants, direct 92, differential 1, 10 survivors (below). Equivalent survivors, all by reading: `rds16 -> rd16` on a compare with 0 or 0xc8 (0x455180 lines 137, 166, 170; 0x4cb058 202, 223; 0x4a3f40 308; 0x4588ad 415 truncated by the word store); `rd16 -> rd32` of a word that is stored through `wr16` or masked as a word host argument (0x455180 141, 171; 0x4cb058 203, 204; 0x4588ad 378, 380, 393, 413); `rd32 -> rd16` of the loop counter `[+0x132]` (0x4cb058 213, 238: needs 65536 iterations); `rd32(self,0x20) == 5` -> rd16 (0x4588ad 362: the guard before it admits only 0 and 5); `rd32 -> rd16` of dwords whose difference is truncated to a word (0x4588ad 395, 397: the low word of a difference depends on the low words only). The one non-equivalent gap, 0x4588ad lines 394 and 396 (`rds16(self, 0x3a) * 16` -> `rd16`), is fixed: the Unicorn fixtures now draw `[+0xae]` also from the negative words 0xffff and 0xfffe (the record object sits 0x40 bytes into its area, `obj_bias`), and the direct test has a loop with `[+0xae]` = 0xffff, 0xfffe, 0xfffd. Hand mutants `rds16` -> `rd16` at both lines now fail the differential and crash the direct test (the zero-extended index leaves the buffer); the oracle still reports 215/215 and exits 0.

## Hooks (OS and host boundaries only; nothing inside a function under test is patched)

Recording stubs entered by address, logging ecx and the stack arguments, popping the callee-cleanup bytes, result 0 unless scripted; they change no memory:

- 0x455180: 0x45504b (this = self, no argument, plain `ret`), 0x4554bb (this = self, two arguments, `ret 8`; the second is a word where the original pushes a 16-bit register).
- 0x4cb058: 0x4ea06c (this 0x571442, one word argument, `ret 4`).
- 0x4a3f40: 0x4a3beb (this = self, no argument), 0x4a42c0 (this = self, three dword arguments, `ret 0xc`).
- 0x4588ad: 0x448d11 (this 0x619a05, four dword arguments, `ret 0x10`), 0x458c32 (this = self, no argument), 0x4fb77a (this 0x5c3a67, one dword), 0x4fb2e3 (this 0x5c3a67, one word), GetTickCount through the import slot 0x52a23c (an ordered `tick` event).

The wrong `ret N` of a stub shifts esp and aborts the run: the functions pop exactly the bytes of their own `ret`.

## Deliberate divergences, limits and unverified branches

- A callee that changes `self`, the record object or a global is not exercised (the stubs change nothing); the ports re-read the object where the original does.
- No bounds checks, as in the original: record index words; 0x455180 `[+0x36]` (the entry at ro + 0x45 + 0x96 * n; the word -1 is exercised with the record object 0x200 bytes into its area in the direct test and the differential), the loop count word `[ro+0x21]`; 0x4cb058 the list count `P12[+2]`, the entry words `k` (table index `0x5f + 2k`, fixtures keep k in -8..47 inside a 0x400-byte object), and the object pointers `[+0x12]`, `[+0x16]`, `[+0x15c]` (the original dereferences `[+0x16]` at +0x5f even when it is zero, if the words differ at 0x4cb099; not exercised: unsafe original behaviour with no native rejection added); 0x4a3f40 the signed-byte counts `ro[+0x21]` and `ro[+0x22]` (fixtures keep a < 4 and b < 6, edge counts 0, -1, -128 scan nothing) and the rows of 0x60 bytes overlapping when b >= 6; 0x4588ad the word stack index `0x5a4c08` (fixtures -32..25, inside a 116-byte table area that ends exactly at 0x5a4c08), the index word `[+0xae]`/`[+0x3a]` (0..20 and the negative words -1, -2, -3 in the direct test, -1 and -2 in the differential; the record object sits 0x40 bytes into its area).
- 0x4588ad: the global words/dwords 0x5a4c08 (a count, int16) and 0x5d03b3 are snapshot scalars in `Fl25bWorld` (host contract of FL-21: flush before / resync after each `Fl18Host.call`); the word table at 0x5a4bd4 is passed as host memory (`words_5a4bd4`). The pointer arguments of 0x4fb77a (ro + 0x55b / ro + 0x52a) are the guest addresses kept in the record table, not host pointers.
- 0x4cb058: world scalars 0x583a29 (int16, compared and stored), 0x5b44f0, 0x5b44f4, 0x5d0377, 0x5d162d, 0x5d1631, 0x5d1639, 0x571ad3, 0x5c39e5 are snapshot scalars; the lea/shl arithmetic of 0x5d1631 uses the just-stored globals as the original does.
- Word arguments of 0x4554bb and 0x4ea06c and 0x4fb2e3 compare by their low 16 bits (the original pushes `ax`/`cx`/`dx` with leftover upper halves); `push 0` and the loop-index dwords of 0x4a42c0 are compared exactly.
- 0x455180 and 0x4a3f40 take the four-dword block as a host pointer; the differential translates the stack pointer to the fixture region. The rep movsd/movsb copy of 0x4588ad is a 49-byte `memcpy` (source and destination never overlap).
- P3, integration: the `Fl18Host.call` arguments of 0x4588ad mix host pointers and guest addresses (the pointer arguments of 0x4fb77a are guest addresses kept in the record table); the same mixing exists in 0x45841e and 0x473206 of FL-25a (host pointers self+0x3e, &local, self+0x335 next to guest addresses record+0xe5, 0x5a4b5e+16k). The differential hides this by mapping addresses; the integration step must say which side the host adapter translates.

## Hashes

- Original GAME.EXE: afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 (unmodified).
- Code windows (sha256 of the original bytes from the start for `span` bytes; equal to the `window` of the acceptances):
  - 0x455180 ea962ee2d7ed38494e315798b320e51df9babaa4a5b10b964ba7b55f4029927f
  - 0x4cb058 568624cd62497da9fc1e586881fcf96b7ebac155ecb597534087bfeef8da33f8
  - 0x4a3f40 bc04fb3e4d529c7fa4413e6330b91a66a287f895b843c581c25f1dfd49258a15
  - 0x4588ad 0ce0ac3209c4155426fbd706037ad8391ac35108bf60f8be98a62dbbf674a546
- Source and test hashes (sha256, at 556a9a55; `tests/fl25b_direct_test.c` and `tests/fl25b_fixtures.py` re-hashed after the 0x4588ad fixture fix; the note itself is not hashed):
  - `src/original_methods_fl25b.c` b2c5e454d3fc0c8a27116026149ca2d6cef6e1feb74cb80d2bedee56c027016a
  - `src/original_methods_fl25b.h` d424754a4705eb274713513b0a23084f669e98cf07ee324a135ce4d610d5c859
  - `tests/fl25b_direct_test.c` c0c49da8a74d9e2beec6f258cf288fea94bff5fc7abe70a09929d08c583b00c0
  - `tests/test_fl25b_direct.py` dd29fcfaac27f2a99ade9e2c0c496f4d843e3865c246816cc5438fffce92e6a1
  - `tests/fl25b_differential_shim.c` bc06c3613d78171d6a6c1c16c24d1c47d5320c4992e96943715c0188ea89bb74
  - `tests/test_fl25b_differential.py` 89062d02b5aa38702e25e9bdcf66dd2ab6e4d13074ae1ff63d4b84097a4d594c
  - `tests/fl25b_fixtures.py` 76ee83184d4f43d529eb47ff89713732cd044233eb152f788c4c8a010f82c25f
  - `tests/fl25b_original_oracle.py` 9f3db63348cb38e7a6882a809f56bd9c92e663ad4a890d4f9bb6e6f5ebfd0473
  - `tests/fl25b_mutation_check.py` cb341ad6817f268ccd5e1a7d316294c48d5500427b88603fe4ee93c5c6ae7120
  - `tasks/fl25b-acceptances.json` 772c5d5bcab658da8107a9df0e157247c5be2f0c610c3323c719ee9abccad432
- Oracle digests (sha256 over the ordered call logs and the memory read back of all scenarios, deterministic): 0x455180 69e964142dff7b6cee37d202741c34674667710d68a4120c040eaafabd13d5f3, 0x4cb058 818286db1ed59a75e46fd1d497acb0c55660e55e5a572b2595c258cee858004c, 0x4a3f40 6c3c7e3018f4f1e10b2d6702355dd0de0a88aa967f3780a36c77f94fd461de80, 0x4588ad a3ad8eb3f9483a22a856945df34e5eaab2e5eb5f6e2d5dd6b5afe9f0c9a57950 (after the fixture change above).

## Reproduce

`cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl25b_direct tests.test_fl25b_differential && python3 tests/fl25b_original_oracle.py && BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl25b_original_oracle.py` (the `work` symlink must point at the evidence directory; the trace-dir form was not run in this session).

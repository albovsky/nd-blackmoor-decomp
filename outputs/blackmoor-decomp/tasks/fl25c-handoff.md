# FL-25 batch c handoff (4 of 4 ported)

Branch `worktree-agent-ac8aa654f44932627` (worktree `.claude/worktrees/agent-ac8aa654f44932627`), reset to `9cb9b577` (the FL-25 packet commit) before any work. One commit per function: 039ab9a4 (0x4a8818), 367dac9e (0x4aa3d2), 99bf6b52 (0x46c6a9), 4e306b7c (0x4a44c0); the tip is the commit that adds this note. No independent slice-reviewer pass has been done. `function-ledger*.json`, `function-evidence.json`, `function-execution.json` were not touched. Not pushed. The files copy the FL-25b shapes (renamed `fl25c`, `Fl25cWorld`, `Fl18Host` convention); `fl25c_fixtures.chain_build` gained a per-callee stub override (`c.stub_kw`, used for `deref`) and `normalize_original` keeps `bytes` entries, both needed for the bytes behind the pointer argument of 0x448d11.

## Ported symbols (`src/original_methods_fl25c.c/.h`)

| va | span | symbol | instructions executed (original) | scenarios |
|---|---|---|---|---|
| 0x4a8818 | 986 | `m4a8818_click_2798_279a` | 236/236 | 1000 |
| 0x4aa3d2 | 1100 | `m4aa3d2_click_276f_2771` | 262/262 | 1800 |
| 0x46c6a9 | 1506 | `m46c6a9_click_27e2_27ea` | 304/304 | 1800 |
| 0x4a44c0 | 1877 (code 1861 + a 16-byte jump table at 0x4a4c05) | `m4a44c0_click_274c_274f` | 412/412 | 1800 |

All four plain-`ret` thiscall handlers (guard chain on `[+0x..]`, record state, selector `[0x5c39e5]`). The differential test also requires both directions of every conditional jump; `fl25c_fixtures.UNTAKEN_EDGES` lists the only three untaken ones, all in 0x46c6a9, each a `jne` that re-tests a selector already known by the block it is in (0x46c840 `!= 0x27e8`, 0x46c99f `!= 0x27e3`, 0x46cb02 `!= 0x27e5`; the global is not changed in between). 0x4a44c0's switch is `jmp [ecx*4 + 0x4a4c05]` (not a jcc): arms 0 .. 3 and the `ja` default arm (the word A taken as unsigned: 4, -1, 0x7fff, -0x8000) are all reached; the coverage target is the 1861 code bytes (`code=1861` in the spec).

## Dropped / not started

None. (No function had dead `mov reg,1; test; je` tails; all code bytes of the four are reached.)

## Files (all owned by this batch)

`src/original_methods_fl25c.c`, `src/original_methods_fl25c.h`, `tests/fl25c_direct_test.c`, `tests/test_fl25c_direct.py`, `tests/fl25c_differential_shim.c`, `tests/test_fl25c_differential.py`, `tests/fl25c_fixtures.py`, `tests/fl25c_original_oracle.py`, `tests/fl25c_mutation_check.py`, `tasks/fl25c-acceptances.json`, this note.

## Commands and results (from `outputs/blackmoor-decomp`, `work` symlinked to the evidence directory, `export PATH=/tmp/claude-0/shim:$PATH`)

- `python3 -m unittest tests.test_fl25c_direct tests.test_fl25c_differential`: 9 tests OK (direct: 1 all-cases check + 4; differential: 4; about 40 s).
- `python3 tests/fl25c_original_oracle.py` (also under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace`): exit 0, four lines `0x... instructions N/N scenarios M digest ...` (digests below). Original bytes only, no native library.
- ASan/UBSan: the direct binary built with `gcc -std=c11 -Wall -Wextra -g -O0|-O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer`: all 4 cases PASS, no sanitizer output (the inputs stay inside the buffers by construction; the rejection cases of 0x4aa3d2 and 0x4a44c0 are run in the direct test).
- Mutation check `python3 tests/fl25c_mutation_check.py --range A-B` (literal +1, `==`/`!=` swap, guard deletion, rd16/rd32/rds16 width slips; direct test first, then the Unicorn differential of the function):
  (Re-run after the fixture-gap fix below, on the current source: the line numbers are those of this commit.)
  - 0x4a8818 lines 141-213: 89 mutants, direct 81, differential only 3, 5 survivors, all equivalent (below).
  - 0x4aa3d2 lines 214-322: 93 mutants, direct 84, differential only 1, 8 survivors, all equivalent (below).
  - 0x46c6a9 lines 323-427: 159 mutants, direct 134, differential only 8, 17 survivors, all equivalent.
  - 0x4a44c0 lines 428-548: 116 mutants, direct 97, differential only 3, 16 survivors, all equivalent.
  Survivors, all by reading: `rd16 -> rd32` of a word that is stored through `wr16` or a `uint16_t` (the store truncates: 0x4a8818 lines 186, 187; 0x4aa3d2 250, 253, 278, 280; 0x46c6a9 361 .. 399; 0x4a44c0 511, 512, 520, 522, 529 .. 531, 534, 535) or passed as a word host argument that the tests compare by its low 16 bits (0x4a8818 174, 182, 191; 0x4aa3d2 256, 269, 283; 0x46c6a9 409, 410, 416, 422; 0x4a44c0 463); `rds16 -> rd16` on a compare with 0 or 1 (0x4a44c0 443, 501, 503, 505: a sign-extended word is 0 or 1 exactly when the word is), on the switch value (0x4a44c0 500: a negative word and its zero extension both exceed 3 and take the default arm) and on the operands of a difference truncated to a word (0x4a44c0 452: the low 16 bits of `n - q * d` depend only on the low 16 bits of n and q); `uint8_t local[0xcc] -> 0xcd` (0x4aa3d2 line 291: the size of a local array is not observable).

Fixture gap found by the first review and now closed: `rds16 -> rd16` of the entry index `[+0x23]` in the 0x2770 arm of 0x4aa3d2 (line 279) and of the row / sub-row / word index words `[+0x264]`, `[+0x278]`, `[+0x276]` in `matrix_offset` of 0x4a44c0 (line 434, three fields) survived because no fixture used a negative index word and no readable memory lay below the record object or the matrices. Now: the Unicorn fixtures give the record object of 0x4aa3d2 0x400 bytes of random slack below its start (`objpad` in `fl25c_fixtures.SPECS`; the record table points past it; the area is compared in full) and the matrices of 0x4a44c0 0x200 bytes below theirs (`matpad`; the area base moves down, the world pointer stays at 0x591a28), and draw index words -1 / -2 (0xffff / 0xfffe) for `[+0x23]` (0x2770 arm and 0x276f arm) and -1, -2 (-3 for the word index) for each of the three matrix index words, alone or together. The direct test has `obj_lo` (0x400 bytes right below `fx.obj`, compared after each case) and `buf47s` (0x200 bytes below `buf47`), a 0x2770 block with `[+0x23]` = 0xffff / 0xfffe (flag dword zero; string 2 only; string 1 plus S) and a 0x274c / 0x274d / 0x274e block with each matrix index word negative in turn. Hand mutants, direct test and differential run separately on each: `rds16 -> rd16` at line 279 and at each of the three fields of line 434 are all caught by both (the mutant reads far outside the buffer and the run crashes or differs); the unmutated control passes both. The oracle digests of 0x4aa3d2 and 0x4a44c0 changed with the new fixtures (below); 0x4a8818 and 0x46c6a9 are unchanged.

## Hooks (OS and host boundaries only; nothing inside a function under test is patched)

Recording stubs entered by address, logging ecx and the stack arguments, popping the callee-cleanup bytes, result 0 unless scripted; they change no memory:

- 0x4a8818: 0x4f6334 (this 0x5cf1eb, one dword, `ret 4`, result scripted 0 / non-zero), 0x4fb2e3 (this 0x5c3a67, one word, `ret 4`), 0x4a8bf2 (this = self, no argument, plain `ret`).
- 0x4aa3d2: 0x4fb2e3, 0x4fb77a (this 0x5c3a67, one dword, `ret 4`), 0x423259 (this 0x619a6b, one dword, `ret 4`, result scripted: 0, a guest address of a string in a fixture region, or a string longer than 0x9c40 bytes), 0x448d11 (this 0x619a05, four dwords, `ret 0x10`; the log also carries the bytes behind its second argument, length string + 4, read at the call: the local buffer of the function, or a string of the record object).
- 0x46c6a9: 0x4f6334, 0x4fb2e3, 0x46cc8b (this = self, no argument, plain `ret`).
- 0x4a44c0: 0x4f6334, 0x4fb2e3, 0x4a4d55 (this = self, no argument, plain `ret`).

Calls into original code that change `self`, the record object or a global are not exercised (the stubs change nothing); the ports re-read the object where the original does. The wrong `ret N` of a stub shifts esp and aborts the run: the functions pop exactly the bytes of their own `ret`.

## Deliberate divergences, limits and unverified branches

- Unsafe original behaviour, rejected natively (separate from the valid-input behaviour, documented in the function comments, covered by direct-test cases; the oracle and the differential do not exercise them):
  - 0x4aa3d2: the string S returned by 0x423259 is copied with its zero into a local buffer of 0xcc bytes (ebp - 0xd8 up to the local S at ebp - 0xc) and a dword is stored at its end, without any bound but the test `strlen(S) > 0x9c40` (which sends a longer S to the second string). The buffer is 0xcc = 204 bytes and the dword is stored at buf + strlen(S): for strlen(S) 201 .. 203 the store only clobbers the low 1 .. 3 bytes of the local S (afterwards only compared with zero at 0x4aa771) and the original still copies, calls 0x448d11 and stores `[+0x2b]` and `[+0x25]`, which the port skips; for larger lengths the copy and the store overrun the frame. The port returns at once (no call, no further store, including `[+0x2b]` and `[+0x25]`) when `strlen(S)` is in 201 .. 0x9c40 (a documented divergence from the 201 .. 203 behaviour of the original), and when the guest address S cannot be resolved by the host. A string up to 200 bytes (the largest that fits with its terminator dword) and one longer than 0x9c40 are exercised by the oracle and the differential (S at 28 bytes and 0 in the fixtures; a 0x9c41-byte string for the long path; the direct test also copies exactly 200 bytes).
  - 0x4a44c0: `idiv` by the signed byte `r[+0x21]` in the 0x274c and 0x274d arms with no zero test (a divide error in the original); the port returns at that point, after the stores that precede it ([+0x272], [+0x260], [+0x258], [+0x214] for 0x274c; [+0x258], [+0x214] and the matrix swap for 0x274d). A zero word [+0x214] never divides (both words are zeroed). The fixtures keep the byte non-zero.
- No bounds checks, as in the original: record index words; 0x4a8818 the cell words `[+0xe7a]`/`[+0xe7c]` (cell at 0xa40 + a * 0x36 + b * 6), the two loop counters (16-bit words that wrap, not exercised past 8 / 9 entries, fixtures keep the loop inside the 0x1e6-byte buffer); 0x4aa3d2 the index word `k = [+0x23]` (-2 .. 9 in both arms, the entries at `k * 0x15c`, negative k below the object), the byte flags at `self + 0x2c + k`, the string lengths of the record object (fixtures: at most 28 bytes), the count word `r[+0xf7]` (bytes at 0x630a60, fixtures at most 64); 0x46c6a9 the cell indices `[+0x49e0]`/`[+0x49e2]` (-2 .. 18, cells of 16 bytes below the words); 0x4a44c0 the row / sub-row / word indices (-2..3, -2..4, -3..5) in the matrix.
- World mirrors: the dwords/words 0x5bb1ca, 0x5bb202, 0x5d03b3, 0x550e50 are snapshot scalars in `Fl25cWorld` (FL-21 host contract: flush before / resync after each `Fl18Host.call`); the buffers at 0x5a110f (0x4a8818), 0x630a60 (0x4aa3d2), 0x5a14df (0x46c6a9) and the word matrices at 0x591a28/0x591a64 (0x4a44c0, one area, since they are 0x3c bytes apart and overlap in the original's addressing) are host memory passed as pointers; the nine-byte constants (0x550bac/0x550bb8, 0x550e2c/0x550e38/0x550e44, 0x54bd00/0x54bd0c, 0x550570/0x55057c/0x550588) are pointers to the constants. The pointer arguments of 0x4fb77a and 0x448d11 for strings of the record object are guest addresses (the address kept in the record table plus the offset); the local buffer pointer of 0x4aa3d2 is a host pointer (the log normalises it to `L`).
- Word arguments of 0x4fb2e3 compare by their low 16 bits (the original pushes `cx`/`dx` with leftover upper halves); the dword arguments of 0x4f6334 are the sign-extended words (`movsx`) and are compared exactly.
- 0x4a8818 `repe cmpsb` with ecx = 9: ported as a 9-byte equality (the tenth byte is never compared; exercised); `rep movsd` + `movsw` of 0x1e6 bytes as a `memcpy` (source `self + 0xa40`, destination in the host area: no overlap).
- Cached reads (the port keeps a value the original re-reads; not exercised, because the stubs change nothing): 0x4aa3d2 caches the entry offset `e` (from `[+0x23]`) and the record object address `r_addr` while the original re-reads `[+0x23]` after each callee, so a callee that changes self (or the record table) would be seen by the original and not by the port; 0x46c6a9 snapshots the selector across the 0x46cc8b call where the original re-reads 0x5c39e5.
- Host contract, bound the record index: `record_object_address` in 0x4aa3d2 (and in fl25d 0x4712bd) reads the host record table at the word `[+0x21]` BEFORE the byte `[+0x45]` gate, as the original does (it loads the table entry first). A garbage index word is therefore an out-of-bounds host read natively; the host adapter must bound the record table (or the index) so that this read stays inside it. The fixtures keep the index in -1 .. 4 with a slack record below the table.
- Open (not verified): selector changes made by the called code between the tests (the three untaken `jne` of 0x46c6a9 assume the global is not changed by the blocks above them: true for the stubs; the original callees 0x46cc8b / 0x4a8bf2 / 0x4a4d55 / 0x4f6334 / 0x4fb2e3 were not run).

## Hashes

- Original GAME.EXE: afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 (unmodified).
- Code windows (sha256 of the original bytes from the start for `span` bytes; equal to the `window` of the acceptances):
  - 0x4a8818 1ecb59b1ca301fb8a2e42e83113bd4bcb4cd795fc7234f16c9577b1a6bd63df3
  - 0x4aa3d2 69638bf74dc9f2ed560a0b157b47f91d59fff4acba0da96eb8a6206fd1aabc12
  - 0x46c6a9 f889dc8129791671c212c676e24c3a6c1f8523d444220066e49b956f9ced942b
  - 0x4a44c0 98cbb7f8e53cc716b38746ccea1d69119b82c2040a22ea5eaa3ed1a24282c6d4
- Source and test hashes (sha256, after the review fixes of the fixture gap and the notes, FL-25c fixes commit; the note itself is not hashed):
  - `src/original_methods_fl25c.c` da9ffe17c4b7be888218a554a00e533edff32cbc5de83f3a506cc757e7abf96d
  - `src/original_methods_fl25c.h` 37f74c618b8f97af92114f039ce49c5ea5240761ec91c67d72c5941ecf2c63d1
  - `tests/fl25c_direct_test.c` 86f2cae62192d45522e476f3683a60fef913a8a05038396ec9fed5ecb2c777f0
  - `tests/test_fl25c_direct.py` ec8587f231f7ffc42cd7f09ab1a4bfde0e061dc667a43bdb327757085f2a8f11
  - `tests/fl25c_differential_shim.c` 8553ce2dbc5066ba669c7948958e55501f4c20e3c6ea4d87ea568d53b4143b46
  - `tests/test_fl25c_differential.py` c66555c8b7e082b99a8ed2ac662dda7bc9a682ceefd59b1fce16dbafa89b34cf
  - `tests/fl25c_fixtures.py` 523612bab94652a77e40f92185109c8e60c887551432e3ec2309345a4c066471
  - `tests/fl25c_original_oracle.py` 3a81457010e9475051b7abc61d96acdc4b5da24671c2ab8d512ca920b0832e1d
  - `tests/fl25c_mutation_check.py` 3b42fa2ec00ccb05d25dd7e98e7e64159d933fd539e51977d7b76679bb4b140f
  - `tasks/fl25c-acceptances.json` 36be55c1581bcfbec3cec8a25f6288f3b1793d7858c84efec31cfd3709122674
- Oracle digests (sha256 over the ordered call logs and the memory read back of all scenarios, deterministic): 0x4a8818 c009b7f758f0288232328831d22601105532292ec11bad1a4992bb88114e2be3, 0x4aa3d2 2fe71bb9cd0d74ded560ef5cc1e5488aa3b451904b811d7a5951d939a0f68dd2, 0x46c6a9 bb81b01d647c890f7dc9b32063b183d686ba17e4df98ceddebd9eb0848cd36b5, 0x4a44c0 90b5ab3c5b5743406b56836978d2f711dee945d46258892c331e12b15cccdb7f.

## Reproduce

`cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl25c_direct tests.test_fl25c_differential && python3 tests/fl25c_original_oracle.py && BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl25c_original_oracle.py` (the `work` symlink must point at the evidence directory).

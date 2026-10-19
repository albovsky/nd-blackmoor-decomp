# FL-24 batch b handoff (12 of 12 ported)

Branch `worktree-agent-adcb0aa0235c772b2` (worktree `.claude/worktrees/agent-adcb0aa0235c772b2`), reset to `claude/fl24-session-input-2-9ro24m` at ed4f9258 (the packet commit) before any work; one commit per function on top, the tip is the final commit (this note is committed last). An independent slice-reviewer pass has not been done. `function-ledger.json`, the override, evidence and execution files were not touched. Not pushed.

## Ported symbols (`src/original_methods_fl24b.c/.h`, `Fl18Host` convention, `Fl24bWorld`)

Thiscall (`ecx` = the object `self`). The four hit tests (0x467740, 0x482359, 0x4acf45 and 0x4aa0f0) take word arguments (read by `movsx`) and end in `ret 8` / `ret 0xc` and return eax = 1 or 0 as `int32_t`; the other seven end in a plain `ret` and return `void` (0x4dad60 leaves eax = this, asserted in the oracle run). Arms are 1:1 with the disassembly of `work/original/GAME.EXE`, not the ledger names.

| va | span | symbol | instructions executed (original) | scenarios |
|---|---|---|---|---|
| 0x4dad60 | 159 | `m4dad60_init_swap_buttons` | 39/39 | 224 |
| 0x466073 | 468 | `m466073_click_27d2_27d3` | 127/127 | 396 |
| 0x467740 | 506 | `m467740_hit_test` | 110/110 | 480 |
| 0x4b7563 | 538 | `m4b7563_click_27bf_27c1` | 150/150 | 440 |
| 0x459e49 | 562 | `m459e49_click_2742` | 134/134 | 480 |
| 0x482359 | 572 | `m482359_hit_test` | 128/128 | 480 |
| 0x46793a | 612 | `m46793a_click_27ab_27ac` | 136/136 | 630 |
| 0x4ad310 | 640 | `m4ad310_click_2774_2776` | 173/173 | 640 |
| 0x4acf45 | 672 | `m4acf45_hit_test` | 183/183 | 640 |
| 0x4aa0f0 | 738 | `m4aa0f0_hit_test` | 154/154 | 640 |
| 0x487ed5 | 756 | `m487ed5_click_2788_2789` | 196/196 | 960 |
| 0x464c59 | 764 | `m464c59_click_27c9_27cd` | 181/181 | 600 |

Dropped: none. Remaining: none.

0x466073 ends its span with a 16-byte jump table (0x466237: word 1 -> 0x466131, 2 -> 0x4661aa, 3 -> 0x4661d9, 4 -> 0x466164); the coverage target is the 452 code bytes (`code=0x1c4` in `SPECS`), the out-of-range default arm and all four table arms run in the oracle.

## Files (all owned by this batch)

- `src/original_methods_fl24b.c`
- `src/original_methods_fl24b.h`
- `tests/fl24b_direct_test.c`
- `tests/test_fl24b_direct.py`
- `tests/fl24b_differential_shim.c`
- `tests/test_fl24b_differential.py`
- `tests/fl24b_fixtures.py`
- `tests/fl24b_original_oracle.py`
- `tests/fl24b_mutation_check.py`
- `tasks/fl24b-acceptances.json`
- this note

## Commands and results (from `outputs/blackmoor-decomp`; plain `clang`/`cc`, the `xcrun` shim in `/tmp/claude-0/shim` passes `--sdk` to a non-Apple clang and fails, so it is not on PATH)

- `python3 -m unittest tests.test_fl24b_direct tests.test_fl24b_differential` : 25 tests OK (direct: 1 all-cases check + 12; differential: 12).
- `python3 tests/fl24b_original_oracle.py` : exit 0, 12 lines `0x... instructions N/N scenarios M digest ...` (table above; digests below). Original bytes only, no native library.
- ASan/UBSan: the direct binary built with `gcc -fsanitize=address,undefined -fno-sanitize-recover=undefined -fno-omit-frame-pointer` at -O0, -O1, -O2 : all 12 cases PASS, no sanitizer output. There is no random sweep in this batch (the FL-23 `sweep()` was not ported): sanitizer coverage is the tested inputs, which stay inside the buffers by construction. The Python differential cannot be sanitised (capstone/unicorn).
- Mutation check `python3 tests/fl24b_mutation_check.py` (all 728 mutants; `--lines N,N` runs chosen source lines). IMPORTANT correction: the differential stage of the earlier runs (this note's first version and the independent review's) looked up test names that do not exist (`test_<va>` instead of `test_<va>_<name>`), so every direct-test survivor counted as "caught by the differential" and the reported survivor lists were wrong or empty. The script now resolves the real method names and treats any harness fault as an error, not a detection. Result of the full run after the first fixture fixes: `mutants 728: caught by the direct test 627, by the differential test only 59, survivors 42`; the 0x464c59 [+0x90] gap (lines 737, two mutants) was then closed by a fixture change and the 108 mutants of lines 680 to 760 re-run (5 survivors, all equivalent, below); the other functions were not re-run after that change (their fixtures were untouched by it). The mutants of the review findings (0x487ed5 rd32 -> rd16 and rds16 -> rd16 at lines 652, 0x4acf45 at 543, 0x4ad310 at 470, 472, 477, 489) are all caught.
- Remaining survivors (40, none a fixture gap by reading): rd16 -> rd32 whose value feeds `wr16`, a truncation to 16 bits or a word-typed host argument (equivalent): 0x466073 lines 170, 178, 183, 190; 0x4b7563 250, 253, 274, 281; 0x459e49 310, 315, 316, 324, 334; 0x46793a 429; 0x4ad310 485, 488; 0x4acf45 545; 0x487ed5 638, 646, 650, 657, 658, 660, 662; 0x464c59 693, 700, 716. rds16 -> rd16 where neither reading can equal the loop index or the compared constant (equivalent): 0x466073 161 (switch index 0 to 3 only), 0x4b7563 251 (low 16 bits), 0x482359 361, 362, 363, 0x4ad310 476, 0x4acf45 544, 547 (the list counter is at most 15). 0x464c59 719, 721 (low 16 bits of a difference stored as a word). 0x466073 148 (0x31 -> 0x32: one extra byte of a zeroed local copy). 0x46793a 417 (`[+0x240] == 0` read as a word: equivalent for any valid pair count, a dword with a zero low word is out of the object). 0x4ad310 478 (guard `count >= 15` deleted: unreachable, see below).

## Tests

- Direct (`tests/fl24b_direct_test.c`, expectations hand-derived from the disassembly): per function a guard matrix (every guard failing in turn with several fail values, byte guards with junk neighbours, dword guards failing only in a high byte, the record state with 0/2/3/0xffffffff/0x101/0x10001 while the decoy records pass; record index 2 and -1), every arm with the whole object, record table and target object compared against a hand-edited copy, the ordered host calls with arguments (word arguments masked, sign-extended dword arguments exact), the object at call time, the nine-byte compare at every byte position plus the tenth byte, signed and word boundaries.
- Differential (`tests/test_fl24b_differential.py`, shim `tests/fl24b_differential_shim.c`, fixtures `tests/fl24b_fixtures.py`): original bytes (Unicorn) against the port on 224 to 960 generated scenarios per function (guard-chain profiles or a function-specific builder), comparing all writable memory, the globals, eax where a value is returned, the bytes the function popped, and the ordered calls with ecx, arguments and the object / record-table bytes at each call. A run also requires that the scenarios reached every instruction of the original and BOTH directions of every conditional jump (the Unicorn code hook records the instruction executed after each jcc, `fl24b_fixtures.untaken_edges`); the only untaken directions are the two in `fl24b_fixtures.UNTAKEN_EDGES`, each a redundant re-test that no state can flip: 0x467ac9 `jne` taken (re-tests the pair already found equal at 0x467a2a) and 0x4ad409 `je` taken (re-tests dword [+0x20] != 0 already found by 0x4ad36e). The 0x4ad310 scenarios place the object 0x400 bytes into its area so that a selected word [+0x24] of -1 to -3 (entry below the object) is exercised; 0x4acf45 scenarios in every third cycle use a mask pointer 0x80 bytes into the mask with negative strides (-1, -2, -3, -5), and the direct test a 0x20100-byte mask with the stride words 0xffff and 0xfffd; 0x487ed5 arms 8 to 11 give the equal word a slot dword whose low word is 1 or 0 (0x10001, 0x80000001, 0xffff0001, 0x10000), and the direct test arm 7 uses 0x10001 with the equal word.

## Hooks (OS and host boundaries only; nothing inside a function under test is patched)

Recording stubs entered by address, logging ecx and the stack arguments, popping the callee-cleanup bytes and returning a scripted eax; none changes memory except where stated:

- 0x4dad60: IAT slot 0x52a498 (stdcall, one argument 0x17), result scripted (0, 1, 0x100, 0x10000, 0x80000000, 0xffffffff, random).
- 0x466073, 0x4b7563, 0x459e49, 0x487ed5: 0x4fb2e3 (this 0x5c3a67, one word argument, `ret 4`); 0x459e49 also 0x4f6334 (this 0x5cf1eb, one sign-extended dword, `ret 4`, result 0 or non-zero); 0x487ed5 also reads GetTickCount (IAT slot 0x52a23c, an ordered `tick` event).
- 0x467740: 0x467b9e (this = self, one argument, `ret 4`, results per call).
- 0x46793a: 0x467c0e (result stored at [+0x1b6]), 0x467d5f, 0x467e70, 0x467eb0 (this = self, no argument, plain `ret`), 0x4fb2e3.
- 0x4ad310: 0x4af96e (word answer), 0x4ada56, 0x4ae683 (1 arg), 0x4ae495 (1 arg), 0x4ada9f, 0x4ae96c (1 arg), 0x4aef4a (2 args, `ret 8`, results per call), 0x4adae8; all this = self.
- 0x4acf45: 0x4acdc2, 0x4ad1e5 (1 arg), 0x4aec35 (1 arg = pointer to a local dword that the stub stores through, then eax), 0x4ae452 (1 arg), 0x4ae495 (1 arg).
- 0x464c59: 0x464fff, 0x4641bb, 0x464faa, 0x464f55, 0x465075 (this = self, no argument).
- 0x482359, 0x4aa0f0: none (pure tests plus global stores). 0x4acf45 reads a mask byte through `Fl18Host.resolve` (a region of the fixture).

The callees are called with `ret` forms verified by the oracle (a wrong `ret N` shifts esp and the run aborts: the function must pop exactly the bytes of its own `ret`).

## Deliberate divergences, limits and unverified branches

- A callee that changes `self` or the record object is not exercised (the stubs change nothing); the ports re-read the object after calls as the original does where it does.
- No bounds checks, as in the original: record index words; 0x459e49 `[+0xcc]` and `[+0xdf]` (byte store at `self + p + 0x1e`, word store at `self + 2n + 0xce`; fixtures keep both in the buffer and exercise p pointing at `[+0xcc]` itself); 0x46793a `n = [+0x240]` (pairs at `n*8+0x1b8 .. 0x1c4`; n = -1 overlaps the gate dwords [+0x1b2], [+0x1b6] and the selection [+0x1ba], covered in direct and differential); 0x487ed5 `[+0x66]` slot index and the queue count `ro[+0x425]`; 0x464c59 `[+0x36]` slot index and entry `[+0x36] * 32`; 0x482359 / 0x4aa0f0 / 0x4acf45 / 0x467740 entry counts (fixtures keep them to 8 to 12 entries and, for 0x4acf45, to a mask offset inside the mask region).
- 0x466073: in the out-of-range word arm (not 1 to 4) with the flag 0x5bb1ca set, the original compares an uninitialised stack local with the constant; the port uses zeros (packet rule). The differential and the oracle force the flag clear in that arm, so that exact combination (flag set, default arm) is an unverified branch: the native result there is `compare zeros` (verified only by reading the code).
- 0x4ad310: the original computes a pointer from the byte `p[0x26]` that it never uses (not reproduced, no effect). The local array holds 15 words; the original tolerates up to 19 matches (words 15 to 17 land in padding and the unused pointer slot, word 18 writes i over itself). Entry 15 would start at the list pointer [+0xc17], so at most 15 entries exist, one of them the selected entry, hence at most 14 matches: the port's `count >= 15` rejection (a native-only rejection) is unreachable through the handlers and is not exercised. A selected word [+0x24] >= 0x8000 (entry pointer below the object) is exercised in the differential only (the direct fixture has no memory before the object).
- 0x4acf45: the same unused pointer in the `[+0x20] != 0` arm is not reproduced. The entry index list at `[+0xe39]` has 15 words before the counter word `[+0xe57]`, and at most 15 entries exist, so the list cannot reach the counter word through the handlers (the earlier remark about 16 or more matches was wrong); fixtures stop at 8 entries. The mask address `dword[q+0x1c] + dy * stride + dx` is formed in 32 bits and read through `Fl18Host.resolve` (NULL result would crash; the host must map it).
- 0x467740 / 0x482359 / 0x4aa0f0 / 0x4acf45: the arming of the globals reads the globals back after storing them (shifts of the just-stored values), as the original does; the world scalars are a snapshot (host contract of FL-21: flush before / resync after a call, no call occurs between the stores).
- Word arguments of 0x4fb2e3 compare by their low 16 bits (the original pushes `ax` / `cx` / `dx` with leftover upper halves); the dword arguments built by `movsx` (0x4f6334, 0x467b9e, 0x4ae683 ...) are compared exactly (the port casts through `uint32_t`).
- 0x4dad60 returns `this` in eax in the original; the port is `void`. The IAT call 0x52a498 goes through `Fl18Host.call` with the slot as callee and `this_ptr` 0.
- Hit-test pointer argument (0x4acf45): the port takes a host pointer to the four-dword block; the differential translates the stack pointer to the fixture region.

## Hashes

- Original GAME.EXE: afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 (unmodified).
- Code windows (sha256 of the original bytes from the start of the function for `span` bytes; equal to the `window` start..start+span of the acceptances):
  - 0x4dad60 9c4ab7e560866ec71f9cb47482b5ae85dc2d93dd7f53221eaa92d88b4f1b175a
  - 0x466073 ca70ef886b3e08aa3fe687a011b5244801a2cc6ae7c5393a2a6a3fd07da0af40
  - 0x467740 d08fd6db45102db48f388125b3983bdb927ffe3253ee4be6d4eff3b232deabad
  - 0x4b7563 7788f82c4d9db6c817a0523690e4a30bc7392d9e20a4840404ab5e1589be7db2
  - 0x459e49 ad9a49266643d573e489532fbe7bb4388cf368bf68d2f7e916e376abaf856116
  - 0x482359 286336193b807c5d9ec13efb771848e456ca7cc54e5429dd0759305536c8e4f7
  - 0x46793a c37d6efd3aba439e52bc36958a9411b1777d925a244467d0e6271dfd08b485b7
  - 0x4ad310 ba3fb67fcc07a37f81f17bfad755ad1d83558d162269720ea1dedc8d0cbc4bb6
  - 0x4acf45 b398d62e011c59a660278a4f3b170c6da7db9f122ed4e8fa9d3f13c29e3159f0
  - 0x4aa0f0 e69b56ff071b5f658e0f4fefdf6168cd0c6185728f01cd074a4197ec71836ab5
  - 0x487ed5 650e438e73319c0554fe3d8c7d80e44ad20177639a8526db7de41dc7e3057ced
  - 0x464c59 fb1f838f00c9eb2c9e89eaea4d3369993d58c051dc71dd4508216c7c71068e0e
- Source and test hashes (sha256, at the commit before this note; the acceptances file is generated with the note):
  - `src/original_methods_fl24b.c` 5fad87633d5db90c11c73187ea001b5f47de0dc2270805a51050ac61432a457f
  - `src/original_methods_fl24b.h` 7fb89e3a5684be79d77db0a575b7e080da6cceb7372e740133c2983637df92d1
  - `tests/fl24b_direct_test.c` 0a03c5e22279d872829fb449a8317214aac24f4d52e50c7a28f72d9fff49a8ba
  - `tests/test_fl24b_direct.py` 5022395757f47b9db0088c1bdd1920879388d3f1a7df857d943690236e893946
  - `tests/fl24b_differential_shim.c` 5c95998d3dfa12d381ee78893724c5d70adf9cdbd38b475ab0e39edc926903d0
  - `tests/test_fl24b_differential.py` 2440234115376ce82a1ba84506a2cd6f30ecf72c95c50906c203c9f8dae756b7
  - `tests/fl24b_fixtures.py` f296fce2191cee60057bf93c984a6d402168a2d347191cc8c36cc2005344283e
  - `tests/fl24b_original_oracle.py` bb3c57732d9c0f556ee410888652af6c4e6408c4e7676a0270a91b94d279f75e
  - `tests/fl24b_mutation_check.py` b68fa8b613e40496df1b10f470ac84e801a94b7d48c92aa2ac2e17f2697dc7a3
  - `tasks/fl24b-acceptances.json` db6fc17e45769806ae4a5f44734baf8233705b3147f5793d69ba5cb18bf77749
- Oracle digests (sha256 over the ordered call logs and the memory read back of all scenarios, deterministic): 0x4dad60 65955e585e00da2fbfd787d42c5171d1fa8c1cd52a2c98e07a6c47eb61aec0d2, 0x466073 27458579b1c23194fff5979f4b9b4ab1e1483d7a2e1c93176856e7f3a78048fd, 0x467740 cfcddd8d82e4401841d76998d74e0a611087aa6e93f1b10ea93195512623c4f8, 0x4b7563 1bdeba04a1dc443f2d2c24a5fa620b1a6696775d80ffb599b89da332f3413819, 0x459e49 f61355facd063ea9931579a9f57b8b9571ab25ed1d3eb321cf1cf2f8b1e72607, 0x482359 f084100114f722b1f2830067bc29be5e84391f3fcf01d2e7d399029d7975d79a, 0x46793a d04e2b6f535c7385fdb5947a17b9f3eabcd286ac24530acd034f1e0d49cfcda2, 0x4ad310 aeced9de546f82b3226304ae2df2926baba6448f34544c56530e847dc23b0ce2, 0x4acf45 8d0f488e3fdcb5606f872073ac230bb39a9d56b6a7cbadb054aa2ec32dfc3b7e, 0x4aa0f0 efad23b4f1ca3287622047ba72da9e73193cd5e670a9229a4f9a3daca7fd0492, 0x487ed5 71da656b804f98c7b634e33f262e55ed037a0d06bcd4fcbd0759106ef0d53658, 0x464c59 77b021661e9e3376345b8d08332f8993bfd85e9328ed82f67458246e247721b1.

## Reproduce

`cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl24b_direct tests.test_fl24b_differential && python3 tests/fl24b_original_oracle.py && BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl24b_original_oracle.py` (the work symlink must point at the canonical `work/`).

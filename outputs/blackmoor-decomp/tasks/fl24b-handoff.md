# FL-24 batch b handoff (12 of 12 ported)

Branch `worktree-agent-adcb0aa0235c772b2` (worktree `.claude/worktrees/agent-adcb0aa0235c772b2`), reset to `claude/fl24-session-input-2-9ro24m` at ed4f9258 (the packet commit) before any work; one commit per function on top, the tip is the final commit (this note is committed last). An independent slice-reviewer pass has not been done. `function-ledger.json`, the override, evidence and execution files were not touched. Not pushed.

## Ported symbols (`src/original_methods_fl24b.c/.h`, `Fl18Host` convention, `Fl24bWorld`)

Thiscall (`ecx` = the object `self`). The five hit tests (0x467740, 0x482359, 0x4acf45, 0x4aa0f0 and none else) take word arguments (read by `movsx`) and end in `ret 8` / `ret 0xc` and return eax = 1 or 0 as `int32_t`; the other seven end in a plain `ret` and return `void` (0x4dad60 leaves eax = this, asserted in the oracle run). Arms are 1:1 with the disassembly of `work/original/GAME.EXE`, not the ledger names.

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
| 0x487ed5 | 756 | `m487ed5_click_2788_2789` | 196/196 | 600 |
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
- Mutation check `python3 tests/fl24b_mutation_check.py --limit 330` (about 25 minutes):

```
mutants 364: caught by the direct test 311, by the differential test only 23, survivors 30
  survivor: line 148 (0x466073) literal 0x31 -> 0x32
  survivor: line 170 (0x466073) width rd16( -> rd32(
  survivor: line 178 (0x466073) width rd16( -> rd32(
  survivor: line 190 (0x466073) width rd16( -> rd32(
  survivor: line 250 (0x4b7563) width rd16( -> rd32(
  survivor: line 310 (0x459e49) width rd16( -> rd32(
  survivor: line 315 (0x459e49) width rd16( -> rd32(
  survivor: line 324 (0x459e49) width rd16( -> rd32(
  survivor: line 334 (0x459e49) width rd16( -> rd32(
  survivor: line 361 (0x482359) width rds16( -> rd16(
  survivor: line 362 (0x482359) width rds16( -> rd16(
  survivor: line 429 (0x46793a) width rd16( -> rd32(
  survivor: line 470 (0x4ad310) width rds16( -> rd16(
  survivor: line 472 (0x4ad310) width rds16( -> rd16(
  survivor: line 476 (0x4ad310) width rds16( -> rd16(
  survivor: line 477 (0x4ad310) width rds16( -> rd16(
  survivor: line 485 (0x4ad310) width rd16( -> rd32(
  survivor: line 489 (0x4ad310) width rds16( -> rd16(
  survivor: line 543 (0x4acf45) width rds16( -> rd16(
  survivor: line 544 (0x4acf45) width rds16( -> rd16(
  survivor: line 547 (0x4acf45) width rds16( -> rd16(
  survivor: line 638 (0x487ed5) width rd16( -> rd32(
  survivor: line 652 (0x487ed5) width rd32( -> rd16(
  survivor: line 657 (0x487ed5) width rd16( -> rd32(
  survivor: line 662 (0x487ed5) width rd16( -> rd32(
  survivor: line 693 (0x464c59) width rd16( -> rd32(
  survivor: line 700 (0x464c59) width rd16( -> rd32(
  survivor: line 716 (0x464c59) width rd16( -> rd32(
  survivor: line 719 (0x464c59) width rd32( -> rd16(
  survivor: line 721 (0x464c59) width rd32( -> rd16(
```

The run is a deterministic stride sample (`--limit 330`, 364 mutants of the roughly 1100 the script generates; the full run was started first but one mutant crashed the in-process shared library (exit 139), so the differential of a direct-test survivor now runs in its own process and a crash counts as caught). Survivors are width/signedness mutants and one literal. Triage (by reading, not individually proven): `rd16 -> rd32` mutants feed `wr16` or a word-typed host argument and are equivalent (low 16 bits only); `rd32 -> rd16` in 0x464c59 lines 719/721 compare the low 16 bits of a difference that is truncated to a word anyway (equivalent); the 0x31-byte local copy of 0x466073 reads one byte more than used (equivalent). `rds16 -> rd16` survivors in 0x482359 (361, 362), 0x4ad310 (470-489) and 0x4acf45 (543-547) are real fixture gaps in the NEGATIVE-word case where the original indexes before the object or the count word has its sign bit set (for example a negative `[+0x24]` makes the entry pointer of 0x4ad310 precede the object, so no legal fixture exists; negative `[+0xe57]` is unreachable with at most 15 matches). They are listed as unverified branches, not claimed as covered. The unsampled mutants were not run.

## Tests

- Direct (`tests/fl24b_direct_test.c`, expectations hand-derived from the disassembly): per function a guard matrix (every guard failing in turn with several fail values, byte guards with junk neighbours, dword guards failing only in a high byte, the record state with 0/2/3/0xffffffff/0x101/0x10001 while the decoy records pass; record index 2 and -1), every arm with the whole object, record table and target object compared against a hand-edited copy, the ordered host calls with arguments (word arguments masked, sign-extended dword arguments exact), the object at call time, the nine-byte compare at every byte position plus the tenth byte, signed and word boundaries.
- Differential (`tests/test_fl24b_differential.py`, shim `tests/fl24b_differential_shim.c`, fixtures `tests/fl24b_fixtures.py`): original bytes (Unicorn) against the port on 224 to 640 generated scenarios per function (guard-chain profiles or a function-specific builder), comparing all writable memory, the globals, eax where a value is returned, the bytes the function popped, and the ordered calls with ecx, arguments and the object / record-table bytes at each call.

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
- 0x4ad310: the original computes a pointer from the byte `p[0x26]` that it never uses (not reproduced, no effect). The 15-word local array overruns when more than 15 entries answer non-zero; the port rejects the 16th (returns, no further effect). Fixtures keep the list size at 12 or fewer, so the rejection is not exercised (it is a native-only explicit rejection, documented here).
- 0x4acf45: the same unused pointer in the `[+0x20] != 0` arm is not reproduced. With 16 or more matches the original writes the entry index over the counter word `[+0xe57]` itself (index 15 = address 0xe57); the port does the same (unchecked), but fixtures stop at 8 entries so this is not exercised. The mask address `dword[q+0x1c] + dy * stride + dx` is formed in 32 bits and read through `Fl18Host.resolve` (NULL result would crash; the host must map it).
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
  - `src/original_methods_fl24b.c` 9594e8991a560525266dbff84851c13604265a84ecb283fa9dfcbb7903cf6bc8
  - `src/original_methods_fl24b.h` 7fb89e3a5684be79d77db0a575b7e080da6cceb7372e740133c2983637df92d1
  - `tests/fl24b_direct_test.c` a36d076d54abda425538a6d692c1323f4b59e64887ecdd00a005b10d3c0356c5
  - `tests/test_fl24b_direct.py` fc0e0ab78a7c4bcc0276c373b1bce2cd262d5d5d1dd21a236c187d7c7759cd2e
  - `tests/fl24b_differential_shim.c` 5c95998d3dfa12d381ee78893724c5d70adf9cdbd38b475ab0e39edc926903d0
  - `tests/test_fl24b_differential.py` b4c3f2a91b4091829bebcbf9638886c964a47da1dd239305db9a895dacf3fe2e
  - `tests/fl24b_fixtures.py` 8e92fda09a1434647bd1c233a44deb9a673e7d40635c9596e26b5c90e21f13ef
  - `tests/fl24b_original_oracle.py` bb3c57732d9c0f556ee410888652af6c4e6408c4e7676a0270a91b94d279f75e
  - `tests/fl24b_mutation_check.py` 467a47694a0625c809c8e8607cf32a496e4498916e752fc47253621123c91227
  - `tasks/fl24b-acceptances.json` db6fc17e45769806ae4a5f44734baf8233705b3147f5793d69ba5cb18bf77749
- Oracle digests (sha256 over the ordered call logs and the memory read back of all scenarios, deterministic): 0x4dad60 65955e585e00da2fbfd787d42c5171d1fa8c1cd52a2c98e07a6c47eb61aec0d2, 0x466073 27458579b1c23194fff5979f4b9b4ab1e1483d7a2e1c93176856e7f3a78048fd, 0x467740 cfcddd8d82e4401841d76998d74e0a611087aa6e93f1b10ea93195512623c4f8, 0x4b7563 1bdeba04a1dc443f2d2c24a5fa620b1a6696775d80ffb599b89da332f3413819, 0x459e49 f61355facd063ea9931579a9f57b8b9571ab25ed1d3eb321cf1cf2f8b1e72607, 0x482359 f084100114f722b1f2830067bc29be5e84391f3fcf01d2e7d399029d7975d79a, 0x46793a d04e2b6f535c7385fdb5947a17b9f3eabcd286ac24530acd034f1e0d49cfcda2, 0x4ad310 148bbaee787cff3129bf8a9cf31e93e26ddb1d3727178e1cb02f163b79146956, 0x4acf45 417d662881996c8c8db81bce4bdc60ea7e2e9579334dcd1b22b46d24d9755e11, 0x4aa0f0 efad23b4f1ca3287622047ba72da9e73193cd5e670a9229a4f9a3daca7fd0492, 0x487ed5 2331d9ed94080f24c9710057530d9475f1c67a64dd467f49734ac0f42cd8ab64, 0x464c59 62f3dc74e1ae5d2d9934597a1c04e89c6accbd6f837a056629cc6b255905be12.

## Reproduce

`cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl24b_direct tests.test_fl24b_differential && python3 tests/fl24b_original_oracle.py && BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl24b_original_oracle.py` (the work symlink must point at the canonical `work/`).

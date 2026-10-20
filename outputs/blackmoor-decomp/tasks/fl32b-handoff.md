# FL-32 batch b (`fl32b`) handoff

Branch `worktree-agent-ad401b5d31be77e5f` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-ad401b5d31be77e5f`), based on `df1a427d` (the FL-32 packet commit, fast-forwarded in: the worktree had been created at `6f8d3d56`). Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says so in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl32b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 9 entries, none has a receipt blocker, so no `blockers_reviewed`; `FL.test_area` resolves all 27 test ids and each test body names its symbol).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (9 of 9, none dropped)

All in `src/original_methods_fl32b.c` / `.h` (symbols `m<va>_*`, world struct `Fl32bWorld`, host convention `Fl18Host` as in FL-18/26..31). The spill rows were not touched. Commit: the one that adds this file (its hash is in the report; a commit cannot name itself).

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x40a613 | 82 | m40a613_read_tag_word | 30/30 | 2/2 | 102 | 372dbcc9f5751a0dd271fb6c86a36be870a34ddb5901888e0eb34a14ca28f0cd | ce4dfa42228e1b0a9a83065ef3846ccdf9c3cce316c702a7cbf8fa8f64266da5 |
| 0x40a665 | 82 | m40a665_read_tag_word | 30/30 | 2/2 | 102 | e58f0f94b2e8acccae36b47580a5e71b36ab7df338382520e4e159954d71004d | ec8082fa512d6af069c21c0fedabe7b1ca56ed465c1698083159b9e09dcea8de |
| 0x4a9f27 | 60 | m4a9f27_reset_fields | 19/19 | 0/0 | 8 | a3adf817878c748afdcede65389db21e1840ef0f9e5c5701a149d3dbcaceac93 | 95a5fdf9ded6b017efa2a6365b3f952e7feac5c6171d030fe063b20e59703a56 |
| 0x4b71f7 | 50 | m4b71f7_reset_fields | 17/17 | 0/0 | 8 | 380ae154a5fddadab14f4b4135eb7fba5b8308dc17def38c63370e79b8ec1b09 | ed7a6bf486f43d17c64df5d4ce954f955c5a92c1ac0e927d7c15d2b09d934714 |
| 0x4781fa | 68 | m4781fa_reset_fields | 17/17 | 0/0 | 8 | 0153a52800ed622732b8d17c1e8d2902d070f52dcff7cb4c5c027a2f0c6aa5f7 | 39add3d2ff0d4db161889dd29b52b1feb2fe73f0ca151ddd1bc2f2031a24fe08 |
| 0x4afd3a | 68 | m4afd3a_reset_fields | 17/17 | 0/0 | 8 | 6d364aae7010e89a295cefe9d62e7c36c5f8b2273937156cc775d2a2bff1eaca | 7581a961d141e222004bd57b15808aa82100a2c89033a1dff60602b6a1fde094 |
| 0x4e04f3 | 76 | m4e04f3_reset_fields | 17/17 | 0/0 | 8 | e533c98469a18066ec21da7265508d57c71f5e7ca21b9406551a7d1d440a300d | 7849d46365d2d27ea1505c187408a5921c1bc86a8529ac60476901dd76fceec1 |
| 0x454565 | 75 | m454565_cross_product | 30/30 | 0/0 | 84 | 9947089033432311ef916b8fd7d47108acec762314e7de44fe8032bd577fe4ec | d80598154d2a1d68c7cd4dd883dc4224151760ae51bb6ca297cc979dccc96d6d |
| 0x4a638a | 82 | m4a638a_reset_fields | 21/21 | 0/0 | 8 | 903bfd19b7600bdfc30d9a07a2d671ccd6cebffe9d77d4f157f7011d6f95de05 | 6f674cde679d18cf673ffb1378c9518c1becbb3bf8157fee750938245d82b1e9 |

Untaken jump edges: none. `fl32b_fixtures.UNTAKEN_ALLOWED` is empty; the only conditional jumps are the two `je` of 0x40a613 (0x40a643) and 0x40a665 (0x40a695), both taken both ways (equal tag / different tag). The other seven functions have no conditional jump. None has an unreachable block behind an always-true guard (checked from the disassembly: the `xor edx,edx` before `repe cmpsb` only clears a register the function never reads again, `ecx` is the constant 4, so the compare always runs).

Notes per function (the header `original_methods_fl32b.h` gives the byte-level contract of each; the constants of every row were read from its own disassembly, the three families were not assumed identical):

- **0x40a613 / 0x40a665** differ in three constants each and share one static helper in the source (one exported symbol each, citing its own address): string field `self+0xcc` / `self+0x10c`, 4-byte tag at the original address `0x53ec5c` / `0x53ec60`, word store at `0x5ec2d8` / `0x5ec2da`. Order: `0x51d5b2(this field, buf, 0x13)` (thiscall, 2 stack arguments, `ret 8`: the cleanup is verified in the callee's bytes), `repe cmpsb` of 4 bytes (`ecx` = 4; the compare ends at the first difference, only "all four equal" decides), then, when not equal, `0x50cb1b(buf)` (cdecl, 1 argument, the argument cleaned by the caller) and `mov word [word], ax` BEFORE the last call `0x4090ab(this)`; the return value is the eax of 0x4090ab (the port returns it). The fixtures put a different tag behind the one compared (a fifth compared byte shows), the twin's tag in the other function, a mismatch at each of the four positions with equal and with random bytes behind it, and 8 CRT results including values above 16 bits (only `ax` is stored; the neighbouring words 0x5ec2d6 / 0x5ec2dc are carried in the world and compared). The call log carries the globals at the 0x4090ab call, which proves the store happens first.
- **0x4a9f27, 0x4b71f7, 0x4781fa, 0x4afd3a, 0x4e04f3, 0x4a638a** straight-line reset stores in the order of the original (the stores hit disjoint bytes, so their order is not observable; the port keeps it). Each returns `this` (the last `mov eax,[ebp-4]` of the original). Fixtures: 0x1800-byte objects with random or constant (0xa5) background; the whole object is compared after the run, so one stray or wider store shows. 0x4781fa and 0x4afd3a share the words (`+0x1e`, `+0x1c`) but have different dword offsets (0x157a/0x157e/0x1576 against 0x1515/0x1519/0x151d); 0x4e04f3 is the only one with `0xffffffff` dword stores.
- **0x454565** (`ret 0xc`, three pointer arguments, `ecx` stored and unused): `(b.x-a.x)*(c.y-a.y) - (c.x-a.x)*(b.y-a.y)`, 32-bit `sub` and `imul` (low half), the port does the arithmetic in `uint32_t` (no signed-overflow UB). The points are only read; fixtures include the signed extremes, products that wrap and all four aliasing combinations of the pointers. The native pointers are host pointers (they are addresses of memory the caller owns); the differential converts the fixture addresses.

## Dropped

None.

## Files

`src/original_methods_fl32b.h`, `src/original_methods_fl32b.c`; `tests/fl32b_direct_test.c`, `tests/test_fl32b_direct.py`; `tests/fl32b_fixtures.py`, `tests/fl32b_differential_shim.c`, `tests/test_fl32b_differential.py`; `tests/fl32b_original_oracle.py`; `tests/fl32b_mutation_check.py`, `tests/fl32b_hand_mutants.py`; `tasks/fl32b-acceptances.json`; this file. `fl32b_fixtures.py` imports the generic harness of `tests/fl28b_fixtures.py` (the Unicorn runner `Original27` with the edge hook, the stub constructor, the call-log normaliser, the conditional-jump finder), so the oracle needs that file present (it is on main). `fl28b_fixtures.run_original` handles `g:` probes; the fl31a copy did not, so `fl32b_fixtures.run_original` takes the fl28b form.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl32b_direct tests.test_fl32b_differential` -> 21 tests, OK (12 direct: 9 functions, the exact-size-buffer check, the sweep and the run-all check; 9 differential).
- Oracle: `python3 tests/fl32b_original_oracle.py` (9 lines as in the table, exit 0).
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl32b_direct_test.c src/original_methods_fl32b.c -lm` -> 11 PASS (9 functions, `test_exact_size_buffers`, the bounded sweep of 300 random scenarios), no report. `test_exact_size_buffers` calls each port on a heap buffer of exactly the highest offset + width the original touches (and the three 8-byte points of 0x454565), so one byte too many is an ASan report.
- Mutation: `python3 tests/fl32b_mutation_check.py [--both] [--only <va key>]`, `python3 tests/fl32b_hand_mutants.py [--both]` (`--both` also runs the Unicorn differential on mutants that the direct test already caught).

## Hooks (oracle and differential; nothing the original decides is replaced)

All callees are recording stubs entered by address (the callee is not run): they pop their arguments, return a scripted `eax` and log ecx, the stack arguments and, where named, probes. Shapes from the call sites and the callee bytes: 0x51d5b2 thiscall(2), `ret 8` (verified in the callee's bytes; scripted WRITE of the 0x14 bytes of the buffer through argument 0 at the first call; this is the host boundary, the callee fills the caller's local); 0x50cb1b cdecl(1) (the caller does `add esp,4`; the buffer behind argument 0 is logged at the call, 0x14 bytes), scripted results; 0x4090ab thiscall(0) (every `ret` that a linear disassembly from 0x4090ab meets up to 0x40a664 is a plain `ret`; the callee's body is not recovered), scripted results, probes of the globals 0x5ec2d8 / 0x5ec2da and the first 0x120 bytes of `this` at the call. The tag bytes at 0x53ec58..0x53ec68 are patched into the image per scenario (the native side gets the same bytes through `Fl18Host.resolve`); the real tag value (a 3-character string and a NUL, at both addresses) is used in one pass of the cycle and random tags in the others. No `rep` string move other than the `repe cmpsb` of 0x40a613/0x40a665 (run as the original instruction), no x87, no indirect jump. The oracle checks the number of bytes the function popped on every run (12 for 0x454565, 0 for the others) and that the pure resets return `this`.

## Deliberate divergences and native rejections (not original behaviour)

- The local buffer of 0x40a613/0x40a665 is zeroed by the port before the callee fills it (the original leaves it uninitialised; the callee writes 0x14 bytes in the oracle). It is not observable through the callee and avoids reading uninitialised memory when a host has no `call`.
- Nothing is bounds checked, as in the original: the object pointer must cover the highest offset stored (0x48, 0x3c, 0x1582, 0x1521, 0xf3a, 0x8c bytes; `test_exact_size_buffers` proves these sizes suffice), and the tag address must resolve (a `resolve` that returns NULL for 0x53ec5c / 0x53ec60 faults natively; the original reads the image). No native rejection was needed: none of the nine functions has a path that faults on a valid object.

## Unverified

- `0x50cb1b` is called with the buffer and its result's low 16 bits are stored: the callee is probably the CRT atoi (`push [esp+4]; call 0x50ca90; pop ecx; ret`), recorded only as a hint, not a recovered name; `0x4090ab` is a game method whose body is not recovered here. Callee side effects on `self` or on the words 0x5ec2d6.. are not exercised (a callee that changes a global the function re-reads is not modelled; these functions do not re-read any).
- The meaning of the fields is a description of what the code does, not recovered source names. 0x454565's mathematical meaning (orientation of three points) is a description, not a name.
- The `repe cmpsb` ends early at the first mismatch; the port uses `memcmp` over the same four bytes. They agree on the final "all equal" decision, which is the only thing the original uses (the registers after the instruction are overwritten or dead); the oracle compares the decision on all four mismatch positions.
- No independent review; no claim that any family or pool is complete.

## Mutation check

`python3 tests/fl32b_mutation_check.py --both` (single textual edits: hex literal +1, `==`/`!=`, `<`/`<=` boundary, one-line guard deleted, `rd16`/`rd32`/`rds16` width swap):

```
mutants 57: caught by the direct test 55, by the differential test only 1, survivors 1
mutants the direct test caught but the differential (original-x86 oracle) did not: 0
  survivor: line 63 (0x40a613) literal 0x14 -> 0x15
```

So the original-x86 oracle (differential) catches 56 of the 57 mutants by itself (all 55 that the direct test catches plus the one only it catches). The survivor is an equivalent mutant: it makes the local buffer of the shared helper 0x15 bytes instead of 0x14; the callee is told 0x13, writes 0x14 at most and the port reads four bytes, so a larger buffer is unobservable. The mechanical tool has no mutants for the `4` of the `memcmp` length, a store width (`wr16`/`wr32`/byte) or a swapped constant pair, so those shapes are hand-written.

Hand-written mutants (`python3 tests/fl32b_hand_mutants.py --both`, each applied to a scratch copy inside the named function; all 25 caught by the direct test AND by the differential, 0 survivors; the `--both` flag runs the differential on every mutant): compare length 3 / 5 / first byte skipped (0x40a613); a dword store of the CRT result, a shifted result, the word stored after the last call, the last call's result dropped, the field address off by one, the buffer argument off by one, the twin's tag / word / field (0x40a613, 0x40a665); a word store in place of the last byte store (0x4a9f27, 0x47); `return NULL` (0x4a9f27); a changed word value (0x4b71f7, 0x4afd3a); a dropped byte store (0x4b71f7, 0x4a638a); a dword store narrowed to a word (0x4781fa, 0x4a638a); a changed dword value (0x4e04f3); swapped difference, a crossed operand in each of the two products and a 16-bit truncated result (0x454565). (A word store at 0x4a9f27+0x45 is an equivalent mutant: the next store clears 0x46, so it was not used.)

Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, loop-bound expressions and double edits are not modelled (these functions have none).

## Integration proposal (for the integration owner)

- The two tag readers take `Fl18Host` with `call` / `resolve`; `resolve(0x53ec5c)` / `resolve(0x53ec60)` must return the host copy of the 4 tag bytes of the image; `Fl32bWorld.word_5ec2d8` / `word_5ec2da` are the host's copies of the two global words (the host copies them back, or points the world at its storage). The callees 0x51d5b2, 0x50cb1b, 0x4090ab go through `Fl18Host.call` with the conventions above (0x51d5b2 must write up to 0x13 bytes into the buffer given as argument 0).
- The six resets return `self`; 0x454565 takes host pointers to the three points (two little-endian dwords each) and returns the signed 32-bit value.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, at the commit that adds this file)

| file | sha256 |
|---|---|
| src/original_methods_fl32b.c | e962e60d401805d81f73e678e3832c5e2ae1d2e27bc7618de42828613c45a34f |
| src/original_methods_fl32b.h | 53bee3d9854aab7030195a8df7375954e69ff4a75096f1d22ba6ba2b6188c944 |
| tests/fl32b_original_oracle.py | 6598bab8646c564bf1c9a73cbc6afde1f214cd12faa23051289bf8b1175ed672 |
| tests/fl32b_fixtures.py | c4fe5b290811035bfa3c617ec192a07cc9e26443b87dea58adfff1c08855c10c |
| tests/fl32b_direct_test.c | 57391862b1a428d8acc3b74ddad3d586bf99cf848ef1a1c6c8d1909855e3ad78 |
| tests/fl32b_differential_shim.c | 12722fcf3393e70ccdd3006dbf6b70805895a86095bbce2a9028100ef4287ab4 |
| tests/test_fl32b_differential.py | 09b0fd15d2b3930af759f53088fac2fd727a2c0933a0e7debc0fd0b9df8bf5b2 |
| tests/test_fl32b_direct.py | 1928190dfab1f07611d81cd0d54865682f6915b87c04a824f6776a60e44936c7 |
| tests/fl32b_mutation_check.py | a06d763d8a87c2868e322a957343e0f99c23c6fa955b190a94d992525e39d701 |
| tests/fl32b_hand_mutants.py | a50caf0686475e7d8ba818ff4f821e3f6e6f7ddf0c22123cdc03341bcaca5a75 |

Native library: the differential builds `tests/fl32b_differential_shim.c` + `src/original_methods_fl32b.c` into a throwaway shared object per run (no committed binary).

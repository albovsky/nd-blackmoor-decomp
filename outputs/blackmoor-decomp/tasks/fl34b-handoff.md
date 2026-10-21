# FL-34 batch b (`fl34b`) handoff

Branch `worktree-agent-a53036daf0fdbd051` (worktree `/home/user/nd-blackmoor-decomp/.claude/worktrees/agent-a53036daf0fdbd051`), based on `425d4bad` (main). The FL-34 packet (`tasks/FL-34-toggle-family.md`, commit `917c6ca5` on `claude/project-thread-mokacw`) is not in this base; it was read from the main checkout. Code commit `241c2d3a`; this handoff is added in the next commit. Implementer: Claude Sonnet. No independent review has been done: every acceptance entry says "independent review pending" in its `reviewer` field; root must have the `slice-reviewer` confirm before collection. Nothing in `function-ledger*.json`, `function-evidence.json` or `function-execution.json` was edited. `tasks/fl34b-acceptances.json` is the proposed `port_acceptances` content (class `native_oracle_verified`, 10 entries; no receipt blocker is named in the packet, so no `blockers_reviewed`). The ledger helpers `FL.symbol_area`, `FL.addresses_in` and `FL.test_area` resolve all 30 test ids and find each row's address in its symbol's leading comment (checked with a scratch script, not committed).

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, checked by the oracle's loader on every run).

## Ported (10 of 10, none dropped)

All in `src/original_methods_fl34b.c` / `.h` (symbols `m<va>_toggle_<flag>`, world struct `Fl34bWorld`, host convention `Fl18Host` as in FL-32a). One symbol per row, written out separately (no shared helper), each citing its own address and carrying its own flag and word constant. The constants were read from each row's own disassembly (Capstone over the original image, per-instruction): every row is `push ebp; mov ebp,esp; push ecx; mov [ebp-4],ecx; cmp dword [flag],1; jne A; mov dword [flag],0; jmp C; A: mov dword [flag],1; movsx eax, word [0x5e335e]; cmp eax,k (0x4067a5: test eax,eax); jne C; mov word [0x5e335e],0xffff; C: mov ecx,[ebp-4]; call 0x404be1; mov esp,ebp; pop ebp; ret` (plain `ret`, 18 instructions); the three flag references of each row are the same address and the end of each span (va + span) is the end of its `ret`.

| va | span | symbol | instructions | branch directions | scenarios | oracle digest (sha256) | window sha256 (original bytes, va..va+span) |
|---|---|---|---|---|---|---|---|
| 0x4067a5 | 70 | m4067a5_toggle_5e350a | 18/18 | 4/4 | 132 | 68d1231a4ec5165c0d4d1551789bc2dfedaa862abce2acd1bd0008bfaadca296 | a99fbde28cf07b2027c8964b52bd49f13fe6b986dfcedcfa73b68638395f6db3 |
| 0x4068c0 | 71 | m4068c0_toggle_5e351a | 18/18 | 4/4 | 156 | bfe5398f215ecc09d394841eb35f0ade0820064c393150e6d9215b19e2c026c0 | 7a8ba8400576e43eb99b6998d16bf58d5c2ee83c16497a342628c5ae34018f4e |
| 0x406907 | 71 | m406907_toggle_5e351e | 18/18 | 4/4 | 168 | 709ef6ab71ec38f87d95ac16e705a67ef4f055f8c913d0ef2fc01d8474537950 | 5c15800c8c7bbef02721cfc235e77fdd87518005e4c91e998cde03045ad7965f |
| 0x40694e | 71 | m40694e_toggle_5e3522 | 18/18 | 4/4 | 180 | d6ca0b2a64d00bbd7b82a9ca0939d238cc8871dc901a949df7d16b153b2cefb4 | 4db6f25d74cca4731f644c44eb9a31ed1aad5173f1c25a217a6683447bb84292 |
| 0x406995 | 71 | m406995_toggle_5e3526 | 18/18 | 4/4 | 180 | 7dc2119989de267c67bdf6eabef12e6f9e0d637fe908fa2a9ebbc57a57c47021 | 5e12ec120fed91fcad6a8c1ea5ad4639022c0272952cafb344630789b7f47cef |
| 0x4069dc | 71 | m4069dc_toggle_5e352a | 18/18 | 4/4 | 180 | 8ba32f4f132fa3d16f0b02e995a8f1f71fe39b335154ea50f07f8be63ffa7da6 | 94152def9d734c38d1eb1a9a4166311e32ccdb7c300d14714e5cce92692d7a0b |
| 0x406a23 | 71 | m406a23_toggle_5e352e | 18/18 | 4/4 | 180 | d6c8edad6e2107e26bc6f5aea3b3bc1cf7b6a76f72e244391cc816d1977acc0a | 26c8c9e9a6d21862f0d215ab450f81133d23b36a5b8ef9293055d3c34f920ae4 |
| 0x406a6a | 71 | m406a6a_toggle_5e3532 | 18/18 | 4/4 | 180 | 65fc5aae749d0ef22dcc7ce6db8b16846ed4b853a57f71f611185c78c09d6cb1 | ba321602dcb12e677d5bdf7e26a92aa092a5bfc69d82c95413e9bebe0d3ae281 |
| 0x406ab1 | 71 | m406ab1_toggle_5e3536 | 18/18 | 4/4 | 168 | bc6c49c4e09c520386cbb2881266b278e10e40ccf031ef8a9b6079370787f8c7 | 8f32847bac2075c566c0e57f82f04804c00e86f153037d38e26162196ad10d25 |
| 0x406af8 | 71 | m406af8_toggle_5e353a | 18/18 | 4/4 | 156 | b8d053080968bd98660422ee271d0988b2b56c83c85d41e1ac49c88f8cdf139d | 45f4193694350f353c81befc9240f6969a3a2d98324895c51284497e24a16338 |

Per-row constants (flag, k): 0x4067a5 (0x5e350a, `test eax,eax` = 0), 0x4068c0 (0x5e351a, 4), 0x406907 (0x5e351e, 5), 0x40694e (0x5e3522, 6), 0x406995 (0x5e3526, 7), 0x4069dc (0x5e352a, 8), 0x406a23 (0x5e352e, 9), 0x406a6a (0x5e3532, 0xa), 0x406ab1 (0x5e3536, 0xb), 0x406af8 (0x5e353a, 0xc); all match the packet. Semantics: when `dword [flag] == 1` it becomes 0 and nothing else is stored; otherwise it becomes 1 and, when the signed word `[0x5e335e]` equals k (is zero for 0x4067a5), the word becomes 0xffff; then `0x404be1(this self)`.

Untaken jump edges: none. `fl34b_fixtures.UNTAKEN_ALLOWED` is empty; each function has two conditional jumps, taken both ways (10 x 4 = 40 of 40 directions). None of the ten has an unreachable block behind an always-true guard (the compares are against memory and a loaded word; nothing is guarded by a loaded constant).

## Dropped

None. The remaining ~50 rows of the family (flags 0x5e353e.., k = 0xd..0x45) stay in the pool, as do batches `fl34a` and `fl34c`.

## Files

`src/original_methods_fl34b.h`, `src/original_methods_fl34b.c`; `tests/fl34b_direct_test.c`, `tests/test_fl34b_direct.py`; `tests/fl34b_fixtures.py`, `tests/fl34b_differential_shim.c`, `tests/test_fl34b_differential.py`; `tests/fl34b_original_oracle.py`; `tests/fl34b_mutation_check.py`, `tests/fl34b_hand_mutants.py`; `tasks/fl34b-acceptances.json`; this file. The fixtures import the generic harness of `tests/fl28b_fixtures.py` and the differential test imports `DiffBase` from `tests/test_fl_differential.py` (both on main), as `fl32a` does.

## Commands (from `outputs/blackmoor-decomp`; no xcrun needed, tests fall back to clang)

- Slice tests: `python3 -m unittest tests.test_fl34b_direct tests.test_fl34b_differential` -> 22 tests, OK (12 direct: 10 functions, the run-all check and the sweep; 10 differential).
- Oracle: `python3 tests/fl34b_original_oracle.py` -> 10 lines as in the table, exit 0.
- Sanitisers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl34b_direct_test.c src/original_methods_fl34b.c -lm` -> 11 PASS (10 functions + the bounded sweep of 300 random scenarios), no report.
- Mutation: `python3 tests/fl34b_mutation_check.py`, `python3 tests/fl34b_hand_mutants.py`.

## Hooks (oracle and differential; nothing the original decides is replaced)

One recording stub, entered by address: `0x404be1` thiscall(0) (the callee is not run; it pops no argument, returns a scripted `eax` and logs ecx, `self` bytes 0..0x20 and the ten flags and the word at the call, which proves that both stores come before the call). Globals are patched into the image per scenario; every global of `Fl34bWorld` (ten flags and the word) is set to a random value in every scenario and read back, so a store to a neighbouring flag or with the wrong width shows. The oracle checks that the function pops 0 bytes. The scenarios per row: every word value (k, k-1, k+1, 0, 1, 2, 3, 0xffff, 0x8000, 0x8000|k, 0x100|k, 0xfffe, 4, 0xc, 0xd, deduplicated) with the flag equal to 1, and with the flag in {0, 2, 0x100, 0x10001, 0xffffffff}, two passes. No `rep` string move, no x87, no indirect jump.

## Deliberate divergences and native rejections

None. Nothing is bounds checked, as in the original. The word is compared as a signed 16-bit value (`movsx`), the flag as a full dword (`cmp dword`).

## Unverified

- The convention of `0x404be1` (thiscall, no stack argument, plain `ret`) is taken from the packet and from the FL-32a handoff, not re-derived here; the oracle stub pops nothing and the function never inspects the result.
- Not exercised: a callee that changes a flag or the word that the function reads again afterwards (nothing is read after the call, so it cannot matter in these ten rows).
- The mutation checks below were all caught by the direct test, so the differential test was not the detector of any mutant in this run (fl32a's check shows the same pattern); both tests compare the same effects, but the differential's independent sensitivity to broken rules was not separately measured here.
- The names are descriptions of what the code does, not recovered source names. No independent review; no claim that the family or the pool is complete.

## Mutation check

`python3 tests/fl34b_mutation_check.py` over the whole file (single textual edits: hex literal +1, `==`/`!=`, boundary, one-line guard deleted, width swap):

```
mutants 49: caught by the direct test 49, by the differential test only 0, survivors 0
```

Hand-written mutants (`python3 tests/fl34b_hand_mutants.py`, 165, all caught by the direct test, 0 survivors; 16 per row plus 5 extra for the `test eax,eax` row and the boundary rows): byte-wide (`uint8_t`) compare of the word, stored word 0 and 0x7fff instead of 0xffff, k+1 and the next row's k, `!=` instead of `==` on k, an ordered compare (`<=`, `>=`, truthiness) instead of equality, a masked (`& 0xffff`, `& 1`) or loosened (`!= 0`) flag compare, a store of 2 or to the neighbouring flag, the word test also done in the "flag was 1" arm (and an unconditional word store there), the callee given `self + 1` or a zero `this`, and the call moved before the flag compare. Known gap of the tool: mutants are single textual edits; multi-line guards, `if (1)`, a dropped `||` operand and double edits are not modelled.

## Integration proposal (for the integration owner)

- The ports take `Fl18Host` with `call`; the eleven globals (ten flags, one word) are read and written through `Fl34bWorld` (the host copies them back to its own storage or points the world at it). `self` is passed on as `ecx` of the one host call `0x404be1`.
- The ports are standalone; no shared parser, dispatcher or app file was edited.

## Source and test hashes (sha256, of the files in the code commit `241c2d3a`; this handoff is added in the next commit)

| file | sha256 |
|---|---|
| src/original_methods_fl34b.c | 6473b25bab50d9b6b49921312e04bfe56d500dab2f21ce1c7eec028166ecc369 |
| src/original_methods_fl34b.h | 4bbf013d448733a35f13f43b5b651f9778e1fbccb4c4a2bd7b3280b2815237fa |
| tests/fl34b_original_oracle.py | 87c1a647da622442dec6e07bc8313da2f96f5d382839e5b8cb2dd0318cd7a857 |
| tests/fl34b_fixtures.py | 5a0b5281164ace3d739211c765a4b25d2b0c048cde082908c4fedd9865db2b5c |
| tests/fl34b_direct_test.c | e2b58278c67a9170ec605c8c684c2abed3b2a707acde703f638673ef315052b6 |
| tests/fl34b_differential_shim.c | 9a657f3d883a6050d6dadabaf9b3a0468d65e460f5fdf413dc3e7a18c30f6a38 |
| tests/test_fl34b_differential.py | bd86bb87cbcd09b6da81006ffcf3d18dec1ae0aac00cbe9bffd03ff2b3715938 |
| tests/test_fl34b_direct.py | c50e664f58c4a841790e71aaec16682dfc19aa7307c0ed81ec4d13f2bb293bfb |
| tests/fl34b_mutation_check.py | 2425fbfc78b8cfec4ae6a0be7bcce2edab598e80f21efa4a12438f0827b48303 |
| tests/fl34b_hand_mutants.py | 319e087a542b07548f5c296ab1d3ff32c95dba1e54ea2eaa476f3ce7bca45914 |
| tasks/fl34b-acceptances.json | c8ccac7290e0ce10227b1b6014e771ff4e0d8eecd844640464376774fac3a6c4 |

Native library: the differential builds `tests/fl34b_differential_shim.c` + `src/original_methods_fl34b.c` into a throwaway shared object per run (no committed binary).

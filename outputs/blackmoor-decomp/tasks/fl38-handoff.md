# FL-38 handoff: medium-size same-shape families below 0x480000 (batches `fl38a`, `fl38b`, `fl38c`)

Cloud thread, 2026-10-21 PDT. Packet `tasks/FL-38-medium-families.md`. GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only). Implementers: three Claude Sonnet batches generated per row from that row's own disassembly (generators were throwaway scripts outside the repo); one Sonnet diff review of all 69 rows (no wrong port; one wording P1 and one window P2, both fixed; reviewer text `Sonnet slice-reviewer, diff review, no P1 after fix (FL-38)`). Per-batch detail (hooks, divergences, hashes, per-function counts): `tasks/fl38a-handoff.md`, `fl38b-handoff.md`, `fl38c-handoff.md`; acceptances `tasks/fl38a/b/c-acceptances.json` (69), appended to `function-ledger-overrides.json`.

Pool rule (coordinator, Oct 21): FL-38 takes pending game rows below 0x480000; FL-39 takes rows at or above it. Rows of these families at or above 0x480000 were released to FL-39 and not started (listed in the packet's batch texts).

## Ported (69 of 69, none dropped)

- `fl38a` (27, `src/original_methods_fl38a.c/.h`): this-field guards (10), release tails (7), release-and-clear (3), NO SOUND check (3), constant getters (4): `0x414c6d`, `0x447cc4`, `0x4487de`, `0x44be44`, `0x4542b5`, `0x4542f2`, `0x45441d`, `0x454de6`, `0x454e39`, `0x456d2e`, `0x456d77`, `0x457fc2`, `0x458045`, `0x459b87`, `0x45dd4d`, `0x464076`, `0x4640c9`, `0x465b9f`, `0x467651`, `0x468f19`, `0x468f68`, `0x46b707`, `0x46e7a6`, `0x46e7ef`, `0x470ddc`, `0x47823e`, `0x478287`.
- `fl38b` (18, `fl38b`, symbol `m<va>_clone_record`): allocate-and-copy-a-record rows (record size per row, `0x51dc43` new, `rep movs` copy, pointer advance): `0x44d1d1`, `0x456fb6`, `0x45807c`, `0x464100`, `0x465bde`, `0x46b79a`, `0x47314b`, `0x4782db`, `0x475964`, `0x44fbe3`, `0x467688`, `0x468f9f`, `0x47e477`, `0x44e8a2`, `0x454e70`, `0x459c10`, `0x45ddd0`, `0x47b3f0`.
- `fl38c` (24, `fl38c`): word-setting readers of 59 and 164 bytes, rectangle shifts of 83 bytes, two 139-byte allocate-and-zero rows and three rectangle clamps: `0x40430e`, `0x404349`, `0x40492f`, `0x40496a`, `0x4049a5`, `0x4049e0`, `0x40893f`, `0x4043b6`, `0x40445a`, `0x4044fe`, `0x4045a2`, `0x404646`, `0x4046ea`, `0x454f29`, `0x457071`, `0x458137`, `0x46453b`, `0x466db1`, `0x479d98`, `0x4465fd`, `0x4547bc`, `0x454f7c`, `0x46458e`, `0x46b855`.

Oracle (`python3 tests/fl38<x>_original_oracle.py`): original bytes only under Unicorn, callees as recording stubs; every instruction of every row executed and both directions of every conditional jump taken for all 69 rows, so there is no untaken-edge allowlist and nothing is flagged for the owner. Mutation checks: a 316, b 864, c 590 mutants, 0 survivors.

## Notes the owner may care about

- Callee `0x4c97b4` (failure branch of the 18 `fl38b` rows): it posts WM_QUIT (PostQuitMessage) and returns; the original then copies S bytes through `*out` = 0, an access violation. The oracle stub stops the run at the call and the port returns 1 after the same call prefix; behaviour after the call is not modelled or claimed. The review caught the first wording ("does not return") and it was corrected everywhere. `fl38c` models the same callee as returning.
- Five `fl38b` rows carry `unverified_branches` blockers from older action slices (`0x44d1d1`, `0x475964`, `0x47e477`, `0x45ddd0`, `0x47b3f0`); each is cleared through `blockers_reviewed` with a rationale (the oracle covers every instruction and both jump directions of the function).
- Windows: the 16-byte constant getters and two `fl38c` rows carry the ledger span (with `int3` padding) as the window.
- Names are descriptions, not recovered source names. The `reviewer` field was set by the root after the one diff review.

## Next pool

Pending game rows after this slice: 1,184 (of 4,188 functions: 1,502 ported). FL-39 owns rows at or above 0x480000. Remaining same-shape families below the line that were not taken: the 82-byte x87 family (`0x40af5d` + 9, `fstp` of a float parsed by `0x50ccec`, needs an x87 stub), single 81-byte `0x446faa` (the other five of its shape are above the line), and the singletons. Still pending by ruling: the unreachable-code rows, `0x41137f`, `0x4c334f`, `0x44cde2`, `0x4cf687`, `0x4bf9bb`, `0x413187`, the dispatchers `0x43a7ca` and `0x4f0059`, `0x44753b`.

Verification (FL-38): `extract_function_evidence.py --check`, `build_function_ledger.py --check`, `function_names.py check`, `annotate_machine.py check` and the six FL-38 modules pass on the final tree (145 tests with the batch oracles). Full suite on Linux (342 files, 4 at a time): 134 failing files; rerunning exactly those on clean main (`d0103aaf`) leaves 133 failing there too (the Mac-bound set), and the one extra, `test_action_family_ee_runtime`, timed out under load and passes alone (8 tests, 1 skipped, 330 s). No new failure.

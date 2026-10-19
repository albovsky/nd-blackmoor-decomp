# FL-22 batch a: handoff

Branch `worktree-agent-ac563a69b25a7d714` (worktree `.claude/worktrees/agent-ac563a69b25a7d714`), baseline `claude/fl22-large-ports-lzg8dy` at `7c9a7f5b` (the packet commit). Implementer: Claude Sonnet 5.5. Not yet independently reviewed. Note for root: the worktree was created from an unrelated older `main`; it was reset to the packet commit before any work (no commit of mine precedes it).

## Ported (four of four, none dropped)

| Original | Native symbol | Direct test | Differential test | Oracle (window, bytes) |
|---|---|---|---|---|
| 0x463392 | `m463392_step_scene(self, int16 index, world, host)` | `test_m463392_step_scene` | `test_463392_step_scene`, `test_463392_scripted_stubs` | `action_family_d3_...` 0x463392..0x463b00, 1882 |
| 0x461d82 | `m461d82_move_step(self, world, host)` returns 0/1 | `test_m461d82_move_step` | `test_461d82_move_step`, `test_461d82_scripted_stub` | `action_family_d3_...` 0x461d82..0x462577, 2021 |
| 0x4778df | `m4778df_render(world, host)` | `test_m4778df_render` | `test_4778df_render`, `test_4778df_scripted` | `action_family_e4_...` 0x4778df..0x4780e0, 2035 |
| 0x45d2c6 | `m45d2c6_render(world, host)` | `test_m45d2c6_render` | `test_45d2c6_render`, `test_45d2c6_boundaries` | `action_family_da_...` 0x45d2c6..0x45db70, 2212 |

Commits (one per function, oldest first): `bf40da87` (0x463392), `19a26278` (0x461d82), `c8da9e0f` (0x4778df), `acca1ea2` (0x45d2c6 and the mutation check). The final commit adds this file and `tasks/fl22a-acceptances.json`.

Files (all under `outputs/blackmoor-decomp/`): `src/original_methods_fl22a.c/.h`, `tests/fl22a_direct_test.c`, `tests/test_fl22a_direct.py`, `tests/fl22a_differential_shim.c`, `tests/test_fl22a_differential.py`, `tests/fl22a_mutation_check.py`, `tasks/fl22a-acceptances.json`, this file. No shared file was edited (the differential machinery was copied from `test_fl21a_differential.py` / `fl21a_differential_shim.c`, not changed). `Fl22aWorld` (in the header) is this batch's world struct; host calls go through `Fl18Host`.

## Commands and results

- `python3 -m unittest tests.test_fl22a_direct tests.test_fl22a_differential` (run from `outputs/blackmoor-decomp`): 13 tests OK (5 direct: four per-function plus the "every case ran and the binary passed" check; 8 differential).
- `python3 tests/fl22a_mutation_check.py [out.json] [label substrings]`: 16 deliberate rule breaks, one at a time, source restored after each. All 16 are detected by the original-x86 differential suite and also by the direct suite. Result file: `work/analysis/slices/fl22a-mutation.json` (private).
- No ASan/UBSan run was added (the packet asks for direct and differential tests only; `-Wall -Wextra -Wpedantic -Werror` builds clean at -O2). The bounded-input fixtures keep indices inside the tables; see divergence 3.

Differential counts (the two test variants of a function share one tally; 300 scenarios each; instruction coverage is asserted by the primary variant):

| Function | Scenarios | Instructions reached | Ordered host calls compared | Memory bytes compared | Globals compared | Fixture digest (sha256) |
|---|---|---|---|---|---|---|
| 0x463392 | 600 | 456/456 (code before the table at 0x463aec) | 1394 | 935400 | 5400 | `39fc22161506dd13b276546d54fd92b8cc9a71c2c976fa896c00555b996a0622` |
| 0x461d82 | 600 | 504/504 (code before the table at 0x462567) | 176 | 1813200 | 0 | `d4f7ce3d0dd192b789b1585af91b2314b2b71c41dfa825fb716d3d0ea0e9923f` |
| 0x4778df | 600 | 514/514 (code up to the ret at 0x4780d1) | 5000 | 507600 | 11400 | `84ecb5f30163a69954f9e5e9eb8ffeb7e114b1ede65935d80d48fdff4d173b62` |
| 0x45d2c6 | 600 | 590/590 (code up to the ret at 0x45db69) | 26086 | 507600 | 13200 | `3daa4c838d9c62fc885c9ccb3a035d1ede9eb56aefa907992cc6bdf68b7a32e8` |

(Stats dump: `work/analysis/slices/fl22a-stats.json`, private.)

## Hashes

- GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (unmodified, read only).
- Oracle files (sha256, equal to the ledger recorded hashes): d3 `cc2c1c64459605779c02931802e80df11145e9eea7ee98c7e951ff01b40e5230`; da `b492090be0fb3524d2ee004180f219766485154cc85b9f1fc650731f7fd68037`; e4 `c535f3841a1aa500fc242e491801dbb9c61ba89ac24a206de07714c2f9b663d6`.
- Oracle code-window sha256 (ledger `window_sha256`): 463392 `91a70bc03752e30560690d8f61a5cf79557b453e99f7021ad83d3a10fabab208`; 461d82 `07ad4647f309e11290b96bbebbeba818f7c88887d44e11c2d04ba8f2ce08e85f`; 4778df `768dc720e07b6fdf4715abbbc287937c22b0fb413d65716a1777d9cf0f8e0992`; 45d2c6 `55f48adb8d3b1d46f5267a6289202030028d8f37ff8952ca7b088215962cb47a`.
- Source and tests (sha256 of the content at `acca1ea2`): `src/original_methods_fl22a.c` `c9153c7ae2962d5dcde5fc1d5b46293c46779043ddee471397d971dd078cf990`; `src/original_methods_fl22a.h` `99e9ad1715d114d52058a8c49fe6532b203bbbd083f8f6475fefac49a885a559`; `tests/fl22a_differential_shim.c` `7083b2e3f8bc17ba457589b678d05ed88737bd84e7ede514c86dd531af9d98bd`; `tests/test_fl22a_differential.py` `8f94f12648a90c85102abd28dca9980185eb9e32efa6af3faf8af3d749b5697c`; `tests/fl22a_direct_test.c` `2dc4edd54ab6c25d48d37c748db599e1c3478d05fd23031e364e6bc1cdb6faff`; `tests/test_fl22a_direct.py` `60e84d20e5f11542246ca7d49fb9be32eddb8669d5f2ed6dcabba749b066deb4`; `tests/fl22a_mutation_check.py` `8cb34036d7e0133a8b3c8e5df1e353ed20608a5f73809798c985dcc3531676a3`.

## Hooks (the only stand-ins in the Unicorn runs)

Every callee is a recording stub (arguments, `this`, bytes behind a pointer argument, call-time probes of named state); some stubs store scripted values through a pointer argument. No decision of the original is replaced.
- 0x463392: 0x4618df, 0x4e8d96, 0x462577, 0x4632bf, 0x461862 (thiscall, no argument), 0x4d39f9 (cdecl, returns ax), 0x4c2790 (thiscall, 4 args, ret 0x10), 0x4fb77a, 0x4fba69, 0x4fb2e3, 0x4f6334, 0x4619be (thiscall, 1 arg), 0x461d4b (thiscall, 3 args), 0x461d82 (thiscall, no argument, returns eax; in the scripted variant it stores [self+0x57]), 0x42ba3a (cdecl, 1 arg), and the IAT slot 0x52a23c (GetTickCount, an ordered event, native `host->tick`).
- 0x461d82: 0x462b84 (thiscall, 4 args, ret 0x10; the scripted variant stores [self+0x5b], [self+0x5d], [self+0x39]).
- 0x4778df: 0x4c5377 (thiscall, 5 args, ret 0x14; bytes of the rectangle behind arg 3 are logged), 0x475cc4 (thiscall, 2 args; bytes behind both arguments logged), 0x4d3836 (cdecl, 3 args, returns ax), 0x50ca3e (cdecl, 3 args; stores four bytes of text through arg 0).
- 0x45d2c6: 0x45b568 (thiscall, 2 args, ret 8; stores the four dwords of the rectangle through arg 1), 0x4c5377 and 0x4c5d4b (thiscall, 5 args, ret 0x14; the rectangle behind arg 3 is logged).

## Deliberate divergences and known limits

1. Word arguments: where the original pushes a 16-bit register whose upper half is a leftover (0x42ba3a, 0x4fb2e3, 0x4619be, 0x461d4b in 0x463392; the row and column handed to 0x462b84 in 0x461d82, where the upper half of the first is the address of `this`) the port passes the zero-extended word and the differential test compares the low 16 bits.
2. Pointers into the original's frame (the rectangle and text buffer locals of 0x4778df and 0x45d2c6) are host pointers to locals of the port; the locals are zeroed at entry, the original's are uninitialised stack. Every use in the original follows an assignment (rectangle fully written before each use; the text buffer by 0x50ca3e), so the zeroing is not observable through the host calls compared.
3. No bounds checks: indices into the record, slot, cell, flag and entry tables, and the loop limits taken from the records, are used as the original uses them. Explicit native rejections (the original would fault or never return): 0x461d82 returns 0 at the `idiv` when the divisor ([rec+0x24a]) is 0 or the quotient overflows (dividend INT32_MIN, divisor -1), keeping the stores made before it (tested in the direct test only; the Unicorn fixtures avoid the faults); 0x45d2c6 returns from the two loops whose limit is a 32-bit expression (`[rec+0x23] - word - 1`) when the 16-bit counter reaches 0x7fff, where the original would never leave the loop (not reachable in the fixtures).
4. Tables are passed by pointer inside `Fl22aWorld`; the differential harness maps them to the original addresses. In the 0x4778df and 0x45d2c6 fixtures the table at 0x5d1599 holds the global 0x5d15e3 at its entry 1; the fixture writes the global's value into the table bytes so that the Unicorn image and the native table agree. A real integration host that backs a callee with original code must resync the world (and the 0x6237a3/a4/a5/0x62383b, 0x62475c, 0x624810..0x62481c and 0x624840..0x62484c writes) around each host call.
5. 0x463392 and 0x461d82: the jump tables (five dwords at 0x463aec, four at 0x462567) are data inside the window and not part of the instruction coverage; the ports use the same unsigned compare (with 4, with 3) and the same arms. The table was read from the file (arm order 0x463690, 0x463775, 0x4636bc, 0x463816, 0x4637a2 for 0x463392; 0x461e0b, 0x461fe1, 0x4621b7, 0x46238d for 0x461d82); note that the arm order is not the code order for 0x463392.
6. 0x461d82 uses one helper (`step_arm`) for its four arms and 0x463392 one helper (`apply_palette`) for its two palette groups; the store and call order is the original's. The ports also pass `(uint32_t)` sums with wrap exactly as the 32-bit original.

## Unverified branches

None in the sense of unreached original instructions (all reached, see counts). Not exercised against the original: the divide faults and the word-wrap loop rejection (above). The callees listed under Hooks are not ported by this batch; their meaning is the callers' (the ledger lists no receipt blockers for any of the four functions, so `blockers_reviewed` is empty).

## Integration

Root merges `tasks/fl22a-acceptances.json` into `port_acceptances` of `function-ledger-overrides.json` and regenerates the ledger. Add `src/original_methods_fl22a.c` to whatever build list names the FL-21 sources.

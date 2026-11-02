# RECOMP-07: seedlings and Betty repair

One coherent story milestone, split into two game-save legs: solve Drake's seedlings, earn his crank and repair Betty. This PR adds ordinary-input routes/checkers; no host defect was needed. Source is the recompiled GAME.EXE native host, not the old handwritten app. Root retains the original owner chat01a170c4-6fa4-7831-9a46-f076fbcfab37 authorization to implement, independently review and squash-merge one slice per PR. Delegates prepared private candidates/evidence only. Immutable originals, scratch clones/saves, no device output or crash-producing test families remain in force.

## Observed progression

`story_route.py seedlings --save m11`: genuine m10 bedroom→Betty's missing crank→Drake conversation→2347 automatically opens2348. Fourteen ordinary zero-rotation pick/drop placements set2002=1 and return2347. The public route intentionally retains the previously exercised empty-area306,194 click and duplicate drop hovers; the click did not enter the puzzle. Save via original Load & Save UI at safe2347/view0/held-1. Flags1535/1838/1839/1968/2002/2080 plus retained1906/1980/1993/2036/2037=1;1160/1541=0.

`story_route.py crank-repair --save m12`: ordinary10,000,000virtual-ms overnight wait lets the original clock advance and authored day/room housekeeping restore Drake. Drag the original caption slider to expose the seedlings reward and Bye. Reward1088/1089 sets1541 and adds real crank20. Ordinary inventory selection records2711/held20/1160=0; using it plays2712 and reaches2713/held-1/1160=1. Visit the normal keypad2702/1782=1, exit, then save safe2701/view0/held-1.1963=0; no card reward claimed. Cells338–341 overlap original clock globals and are excluded from story flag scope/values in the checker, remaining diagnostic clock observations only. No clock/flag/RNG state is injected.

## Root acceptance at 2026-11-02, 00:50 Pacific

Native f8b34e6d2c64d85c951aa336d6c05607d3199ea5aac1ccd11d18bd9b1142be58 is unchanged. Original GAME.EXE remains afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Both public scripts are byte-identical to their separately exercised accepted inputs: seedlings234steps/SHA3a2ad43204fec5c9d31aa318f569aa4f957a388c02ff46592f40d7f7e185d878; crank262steps/SHA34d76a0092ed332871228c664aba693d76b43ffb0e96dbd00d00d97c36afea19.

Root replayed seedlings in32.00s from fresh-chain m10 `70f0512d86c56569df3f70bbcc66a8eaf7f0a521c6de4582b5e5dfe12db64e77` in a new APFS data clone, producing genuine m11 `d4485349e80d83f4d20db3a7ba6007b90b365e7c7510587ab1bbd109bfdc00aa`. A separate m11-only fresh clone reloads2347/view0/held-1 and all required flags. Root then replayed the public crank leg in76.59s from that exact newly produced m11 in another fresh clone, producing genuine m12 `b81382251440b6f15bf384a1d7b8982df55ce27cc485c11d0cc5d7307ea83cdf`. The public checker passes ordered pre/post puzzle, reward, held-item, repair, keypad and safe-checkpoint observations. A separate fresh m12-only clone reloads2701/view0/held-1, all required positive flags and1963=0; copied-save SHA matches the producer.

Private root evidence: `seedlings-public-root-replay/`, `seedlings-public-root-reload/`, `crank-public-root-replay/`, `crank-public-root-reload/` under `work/recomp-playability-20261101/`. The original earlier delegate runs and rejected probes remain under `seedlings-playthrough/` and `crank-playthrough/`; their different save hashes are separate runs, not substituted into root's chain. Producer→consumer hashes match mechanically.22 ordinary Python checker tests pass, including rejection of missing/unobserved win flags, wrong ordering, preexisting reward/repair, wrong held item and absent card-zero scope. Tests use finite synthetic log text; they execute no guest, audio, CPU faults or oracle. The checker validates observations, requested-stop line, matching file-open and170770-byte save, not serialized contents or fresh-folder provenance; actual independent reloads supply those additional checks.

## Boundaries

This validates Junior/current chained headless gameplay and save/load. Rotation was unnecessary; original right-button rotation is still a host input gap. Keypad code/card reward, later story, both complete difficulty campaigns and final background app playthrough remain incomplete. The long overnight interval is a headless route choice, not a recommendation to wait that long in real time; a later app route may use the authored alarm UI. Existing DirectSound3D/accelerator stub limitations are unchanged. Original timer/worker scheduling can vary save bytes between runs; story/scene/held-item checks and producer/copy identity, not equality with a different run's save hash, determine acceptance.

The modified registered checker test requires both evidence generators to be refreshed under the owner's latest pasted instruction. Derivation runs in a clean frozen scratch checkout, excluding parked unrelated files. No original methods, overrides, protected tests or acceptance claims change; function statuses/coverage/lifter fields are verified unchanged (`betty-refresh-receipt-20261102.json`). Independent Sonnet review is pending before publication.

## Source pins

- `recomp/route_tools/story_route.py`: `2a8898a3c0561b993a707d609198e010436c337bf3be0cfa8e96842570a38b37`
- `recomp/route_tools/check_route.py`: `335bca633b91d6037b2913cd8b52ec84a502737166216f97ff20ada47a6e1415`
- `tests/test_recomp_route_check.py`: `147a05ebf0216a5158028b9ac51fd47f2185324c0e62a81ea8b61c89f0bc354a`

Independent Sonnet high review accepts frozen e9bf99c6 with no P1 or blocking P2 (`betty-review.txt`). Root also reran the final combined public checker on both retained root logs and checkpoints; `betty-final-public-checkers.json` pins that final checker and confirms both results. The earlier seedlings replay receipt correctly retains its earlier candidate-source pins; this new record establishes final-checker acceptance without rewriting history. Static evidence and ledger freshness checks both finish successfully. The checker’s documented limits and untested rejection branches remain; no new function-port credit is claimed.

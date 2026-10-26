# FL-59 handoff (rows below 0x480000, round twelve): the last three hand ports and an automated lower pass

No new ported credits: the ledger stays at **2,186 of 4,188 verified ported** (main after FL-58). **Translated, unverified: 1,782** (111 lower in `src/original_methods_fl56_unverified.c`, 1,551 upper in `translated/original_methods_fl41_translated.c`, 117 in `translated/original_methods_fl57_translated.c`, and the 3 new rows below). No row anywhere is untranslated by the lifter any more. Translated, unverified rows are NOT port credits.

## Hand ports (new, `scripts/fl59_handports.py`, `translated/original_methods_fl59_handports.c`, `tests/fl59_handports.json`, `tests/test_fl59_handports.py`)

- **0x50ed50 and 0x50fa90** (the CRT memmove, two copies, jump tables inside the code): C with memmove semantics (forward copy when dst <= src or dst >= src + n, else backward; returns dst in eax; cdecl). Compared with the original bytes on 378 constructed (dst, src, n) cases each (every alignment of both pointers, n 0 to 300, forward and backward overlaps) plus natural seeds: eax, esp, ebx, ebp, esi, edi and the final content of every written non-stack cell agree. ecx, edx and the flags are scratch in the original and are not modelled; the original writes dwords and bytes in an alignment-dependent order, so write order is not compared.
- **0x4d8dca** (recursive quicksort of the pointer array at this+0x980c by the key at [element + 0x100], thiscall, `ret 8`): the BULK lift with its two self-calls changed to `FL41_CALL_LIFTED(m4d8dca_lifted)` (the callee pops its own arguments, so nothing is added after the call). The original-bytes harness runs it with no callee stub at its own entry. 12 seeds agree on the full digest (registers, ordered writes, ordered calls).

## Automated pass over the lower rows: what it found

- **Gate: none of the 111 lower unverified rows has full coverage.** 9 run every instruction but miss one or two jump directions (0x411b16 0x42b510 0x441d74 0x44887c 0x44e9ae 0x44efcd 0x45e6bd 0x45eadc 0x478396); 45 have no seed at all (103 KB of code). `scripts/fl56_bulk.py` proves one direction impossible (0x42e693) and that row still misses 8 instructions.
- **Coverage search again** with new seed ranges (`fl40_generate.py --more-from 20000`, guided 8000) on 0x45eadc 0x44e9ae 0x411b16: same single direction missing each time, the search queue ran dry after about 1,700 runs (no new child scenario), so it is stuck structurally, not short of budget. Stopped.
- **Exhaustive mutation check (`FL46_BUDGET=1 tests/fl40_mutation_check.py --per-row 100000`) on the 8 corpus rows that were never checked** (full coverage, no log): 0x473ac5 (800 mutants, 53 survivors, 49 not explained by `fl40_survivors.classify`), 0x46a98e (405, 55, 52), 0x4523b5 (195, 23, 19): all held. 0x43f31a and 0x43ff18: `cc1` was OOM-killed compiling all mutants in one file (needs `--window lo:hi`, as FL-42 found for 0x4033db); with 40 to 60 unexplained survivors per small row there is no sign the big ones come out clean, so not pursued. 0x404be1, 0x4033db, 0x478f91 not started. Logs are not committed (nothing credited); numbers are above.
- `fl44_final` still says 285 clean, 91 held of 376 corpus rows; ledger regenerated on merged main, only the evidence hashes moved.

## Left

- The 91 held corpus rows and the 111 unverified rows: unchanged. The cheapest next gain is not more seeds but a real fix for a harness limit (the closest held rows need purpose-built scenarios, see FL-54), or accepting a different standard for rows with one impossible-looking direction (Glib's open question on untaken-jump credits).
- Big unchecked rows need `--window` slices (compiler memory).

## Tests (targeted policy, no full suite)

`test_function_names`, ledger and evidence regeneration, every `tests/test_fl*.py` (see the PR for results), `test_fl59_handports`.

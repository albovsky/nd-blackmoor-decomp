# FL-55b handoff (bulk upper translation, follows FL-55): bulk "translated, unverified" rows at or above 0x480000

> Update (FL-58): the 155 no-seed rows are now 10 and the 5 rows 0x4db0d6 0x4db10c 0x4db147 0x4db178 0x4db223 are credited (ledger 2,186); the table holds 1,551 rows. See `tasks/fl58-handoff.md`.

Glib's instruction (25 Oct 2026): speed over verification for now. Translate every pending upper row with the lifter, skip the mutation checks and the seed searches, record the result under a separate status, merge in big batches with only light checks.

**This is not a port credit.** The ledger is unchanged (2,181 of 4,188 ported). The count below is the "translated, unverified" count that the status reports quote.

## Result

Of the 1,676 pending rows at or above 0x480000 (303 game, 1,373 library), **1,552 are translated** (`translated/original_methods_fl41_translated.c`, table in `tests/fl41_translated.json`):

- 1,397 `agrees`: the translation and the original (Unicorn) give the same registers, writes and callee calls on at least one seed that ran without a fault (the first 8 plain seeds, plus 8 float seeds for an x87 row; a seed is kept when it runs new instructions or edges). Coverage is partial: the table records instructions executed/total and jump directions taken/total per row.
- 155 `no seed`: the C compiles but no seed gave a comparable run (every seed faulted in the original, or a call through a pointer ran real code in the original where the translation has a stub).
- 0 lifter defects: the 6 first found were fragments that run on past their span (0x50df94, 0x50e054, 0x50e104, 0x50e284, 0x513843) and `__EH_prolog` (0x50f978, `push eax; ret`); they are compared on the digest only / skipped as non-comparable.
- 4 hang rows: 0x4933ff, 0x4a1d3a, 0x4adb6c, 0x4ae178 (a run did not return in the row budget; the translation or the original loops on a seed). Not in the C file.
- 120 rows the lifter still refuses (`refused` in the same file): callee not a ledger function 35, callee writes esp 13, `fnstcw` 11, disassembly stops 10, indirect jump 9, `sahf` 9, `fldcw` 7, conditional jump out of the function 6, recursive call 3, `rcr` 3, `shld` 3, `lock` 2, others.

The generated C is kept in `translated/`, NOT in `src/`: the evidence extractor scans `src/*.c`, and 1,552 start-address comments there moved 40 compiler EH funclets out of `not_needed` (their rule needs the address to appear nowhere in native source).

## Tools

- `scripts/fl55_bulk.py [--rows ...] [--seeds 8] [--jobs 4] [--timeout 25] [--cache FILE]`: lifts, builds one library, runs the quick comparison per row (small rows first; a per-row alarm; a row stuck inside native code cannot be interrupted, so rows that hang are recorded by hand as `hang` in the cache and not retried), writes the C file, the table and the defects file.
- `scripts/lift_fl41.py` gained `BULK` (off for the credited rows, so their text is unchanged): calls through a register or a pointer (`indirect_call`: the target is computed first; the bytes the target pops are a heuristic, `indirect_cleanup`: 0 when `add esp, N` follows, else 4 bytes per push since the last call or label, not counting the prologue), unknown x87 effect of a callee taken as none, `wait` as a no-op. Always on: `scripts/fl55_imports.py` (stdcall argument counts for 290 more Win32 imports; `_f@N` names carry their size) and the `wait` no-op.
- `tests/test_fl55_translated.py`: table and C file belong together, the C compiles with the FL-41 model, a deterministic sample of 30+ rows agrees with the original again, no translated row is in the corpus or ported.

## Next

0. **Split with the lower thread (FL-57), per the coordinator:** FL-57 takes the 120 upper rows this lifter still refuses; the list with the reason of each is `refused` in `tasks/fl55-translation-defects.json`. This thread keeps the 4 hang rows and the 155 `no seed` rows (`status` `no seed` in `tests/fl41_translated.json`; 64 seeds were tried, they mostly call through pointers or build an SEH frame in `fs:[0]`).
1. Fix the refusals that open the most rows: callee not a ledger function (35), esp-writing callees (13), `fnstcw`/`fldcw`/`sahf`/`rcr`/`shld` (30), disassembly stops and indirect jumps (19).
2. More seeds for the `no seed` rows and for rows with low coverage; pointer-call rows need a world that stubs the targets of indirect calls.
3. To turn a translated row into a port credit it still needs the FL-41 pipeline: full instruction and jump coverage, then the exhaustive mutation check with the soundness-checked rules of FL-55 (`tasks/fl55-handoff.md`). Run that tool-first and in bulk over all translated rows before looking at single rows.
4. Policy: porting PRs run only the targeted tests (function names, ledger/evidence, `test_fl*`, tests citing new rows); a separate thread runs the full suite every second night.

## Lessons

- A native loop that never returns cannot be interrupted from Python (signal handlers run only between bytecodes, and an exception raised inside a ctypes callback is swallowed): check a flag after every run and expect rare hangs.
- Run the cheap rows first; the large ones dominate the time (a 40 s alarm per row, 4 jobs, 1,300 rows took about 25 minutes in total once the small rows were ordered first).
- `pgrep -f` / `pkill -f` matches the calling shell when the pattern appears in the same command line (exit 144): kill by pid from a command of its own.

- Codex review of PR 192 (two P2 findings, both fixed in the follow-up): the compile-error line ranges of `fl55_bulk.py` drifted one line per function; the BULK x87 analysis shared the strict `_FPU_NET` cache (now a separate cache).

# FL-56 handoff (rows below 0x480000, round ten): translate first, verify later

No new ported credits this round (the ledger count is whatever main had after FL-55: 2,181 of 4,188). Glib changed the approach mid-thread: stop the seed searches and mutation checks, translate every lower row the lifter can take, and keep the verified count honest. Result: **482 lower rows have a lifter translation** (376 in the verified-coverage corpus: 285 credited, 91 held; 106 new "translated, unverified"). 5 lower rows are still refused by the lifter.

## What is new

- **Translated, unverified** (`src/original_methods_fl56_unverified.c`, manifest `tasks/fl56-translated-unverified.json`, generator `scripts/fl56_unverified.py`, test `tests/test_fl56_unverified.py`). 106 rows. Each compiles, and where seeds exist (66 rows) agrees with the original bytes on every kept seed; the seeds do not cover every instruction or jump direction (9 rows cover every instruction), and no mutation check was run. They are NOT ported credits; the ledger does not count them. The manifest records per row the coverage, the seeds, `assumed_x87_neutral` (library callees whose x87 stack effect was assumed to be none) and `guessed_callee_pops` (call targets that start no ledger function, pop taken from the first `ret`). Indirect calls (`call reg` / `call [mem]`) are translated with `FL40_CALL(target)` and a callee pop INFERRED from the pushes before the call (none when `add esp, N` follows): this is an assumption, not a proof, and the harness cannot run those rows yet.
- **Lifter** (`scripts/lift_function.py`): `UNVERIFIED = True` (set only by `fl56_unverified.py`) allows indirect and recursive calls, non-ledger call targets and unclassified library x87 callees. The strict mode used by the corpus is unchanged.
- **Impossible jump directions** (`scripts/fl56_untaken.py`, corpus field `untaken_ok`, checked by `tests/test_fl40_differential.py`, `tests/fl40_original_oracle.py` and `tests/test_fl56_unverified.py`): a direction is allowed only when a small mechanical proof shows that the flags of the jump are constant for every input (`mov r, 1; test r, r; je`, `xor r, r; mov r8, <byte>; cmp r, -1; je`). Four rows use it (0x4230d1, 0x433eaa, 0x41f5b1, 0x46f4b0). Rows whose never-run instructions sit behind such a direction (0x42e693) stay out: the ledger needs every byte executed.
- 8 rows entered the verified-coverage corpus and the mutation check (0x4230d1 0x433eaa 0x41f5b1 0x46f4b0 0x44a177 0x4570c4 0x44a5ca 0x4484ba). All are held: after equivalence and the 40000-seed rescue they still have 2, 16, 54, 59, 19, 13, 11 and 88 open survivors. `tasks/fl56-mutation-log.txt` is listed in `scripts/fl44_final.py` and pinned by `tests/test_fl46_verdicts.py`; `tasks/fl56-rescue-40000.txt` holds the two finished rescue runs but is not in `fl44_final.RESCUE` (they did not clear their rows).
- Tools: `scripts/fl56_add_rows.py` (move a covered pending row into corpus/source/test), `scripts/fl56_cover.py` (coverage lab with compare operands in front of an untaken jump), `scripts/fl56_bulk.py` (which pending rows are provably complete).

## Left

- 5 rows refused: 0x427a50 0x4381f4 (callee 0x4f95a4), 0x42babf 0x432d1a (callee 0x4f9b50), 0x43a7ca (callee 0x47d788): the x87 depth of the callee differs on two paths.
- 66 corpus-pending rows with incomplete coverage (guided search, 14000 runs each, left 10 near-complete rows open: 0x411b16 0x44e9ae 0x45eadc 0x45e6bd 0x44efcd 0x42b510 0x44887c (one direction each), 0x478396 (3), 0x467c0e (1 instruction), 0x467eb0 (6)). Directed scenarios for these were started and stopped on Glib's instruction; `scripts/fl56_cover.py --show` is the tool for them.
- The 91 held rows and the unverified rows need the usual verification (mutation check, killing scenarios, written reasons) later.
- Open questions for Glib are unchanged (assumption-based reasons; seven older credits with an untaken direction). The new `untaken_ok` rows are not credited.

## Testing policy (Glib, Oct 25)

No full suite in porting PRs, not even every 4th merge; a separate thread runs the full suite every second night. A porting PR runs only: `test_function_names`, the ledger/evidence tests (`test_function_ledger`, `test_extract_function_evidence`, `test_function_xrefs`, `test_record_function_execution`), every `tests/test_fl*.py`, and any runtime test that cites a row the PR credited. This round: 167 files, all passed except `test_extract_function_evidence` (one Mac-path failure, `/private/tmp`, identical on clean main) and `test_fl46_verdicts` (fixed: it pins the FL-56 log).

## Regeneration (worked)

`record_function_execution.py run --root <repo> --trace-dir work/analysis/FL-56/traces --only fl40_original_oracle`, then `collect --write --merge` WITH the same `--trace-dir` and `--root` (without them it reads the default trace dir and silently changes nothing), `extract_function_evidence.py --write`, `build_function_ledger.py --write`, both again, `function_names.py write` (no new names without new credits, so no audits), `fl44_final.py --write`.

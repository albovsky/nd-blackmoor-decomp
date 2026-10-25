# FL-57 handoff (rows below 0x480000, round eleven): the lower half is fully translated

No new ported credits (ledger count as on main after FL-55: 2,181 of 4,188). All **202 pending lower game rows are translated**: 91 are in the verified-coverage corpus (held, mutation survivors open) and **111 are "translated, unverified"** (`src/original_methods_fl56_unverified.c`, manifest `tasks/fl56-translated-unverified.json`, generator `scripts/fl56_unverified.py`). 487 lower rows now have a lifter translation (376 corpus rows, 285 of them credited, plus the 111). Nothing below 0x480000 is refused any more. Translated, unverified rows are NOT ported credits.

## What changed

- `scripts/lift_function.py`, unverified mode only: `fpu_net` follows call chains up to 40 deep (strict mode keeps 6). The cut-off at 6 guessed 0 for a float-returning callee deeper in the chain and made two paths of its caller disagree: that was the "x87 depth differs on two paths" refusal of 0x427a50 0x4381f4 0x42babf 0x432d1a 0x43a7ca.
- `guess_math_wrapper`: the Borland math library is a set of thunks `mov edx, imm; jmp wrapper` into wrappers that open `push ebp; mov ebp, esp; add esp, -0x2d0; push ebx`. A wrapper that continues with `wait; fnstcw` works on st(0) in place (net 0); one that pushes its stack arguments takes doubles from the stack and leaves the result in st(0) (net +1). 0x50de00 gets +1. `UNVERIFIED_LIBRARY_FPU_NET` adds 0x50e19e (floor-like, ends in the loader 0x513e60, +1), read from its bytes. These are guesses recorded per row in the manifest as `assumed_x87_math` (new field), next to `assumed_x87_neutral`.
- Strict mode (the corpus and every credited row) is unchanged.

## Left (lower half)

Nothing to translate. What remains is verification of the 111 + 91 rows (mutation check, killing scenarios, written reasons), and the open Glib questions listed in the FL-56 handoff.

## Tests run (targeted policy, no full suite)

`test_function_names`, ledger/evidence tests, all 162 `tests/test_fl*.py` and `test_fl56_unverified`. `test_extract_function_evidence` has 76 errors that are all `FileNotFoundError: /private/tmp/...` (Mac temp path; the container has no /private). `test_record_function_execution` must be started as a script (`python3 tests/test_record_function_execution.py`), not `-m unittest tests.…` (import of `oracle_support`).

## Part 2: upper rows the FL-55b lifter refused (coordinator split)

FL-55b translated 1,546+ of the 1,676 pending upper rows and left 120 refused. `scripts/fl57_bulk.py` (new) takes exactly those 120 (`refused` in `tasks/fl55-translation-defects.json`), lifts them with `scripts/lift_fl41.py` in BULK mode plus the FL-57 extensions, compiles them, and runs the same quick comparison against the original bytes (Unicorn) as `scripts/fl55_bulk.py`. Result: **117 translated, unverified** (87 `agrees`, 30 `no seed`), 1 hang (0x4d8dca, a recursive row: the translation calls its own entry through the host and never returns), 2 not lifted (0x50ed50 and 0x50fa90, CRT memmove variants whose jump tables sit inside the code). Output: `translated/original_methods_fl57_translated.c` (helpers for the extra x87 operations are defined at the top of that file, not in the hash-pinned model header), table `tests/fl57_translated.json` (per row: seeds, coverage, `stack_rule`, `guessed_callee_pops`), defects `tasks/fl57-translation-defects.json`, test `tests/test_fl57_translated.py` (table and C belong together, no overlap with FL-55b's table or the corpus, compiles, 25+ rows agree with the original again). Not port credits; ledger unchanged.

Lifter extensions (BULK only, credited rows unchanged: `test_fl41_differential`, `test_fl43_equiv`, `test_fl52_x87` still pass): call targets that start no ledger function (pop from the first `ret`, recorded as `guessed_callee_pops`); callees that write esp (EH prolog/epilog); conditional and indirect jumps out of the function as tail calls (the target pops what the row's own `ret N` pops); recursion; `lock` ignored; `sahf`, `lahf`, `rcl`, `rcr`, `shld`, `shrd`, `xlatb`; jump tables without a `cmp/ja` bound (dwords that point into the function); x87 `fldz fld1 fldpi fldl2e fldl2t fldlg2 fldln2`, `fxch`, `fst/fstp st(i)`, `fnstcw`, `fldcw`, `fnclex`, `fnstsw` to memory, 10-byte `fld`/`fstp`, `fist/fistp`, `frndint fabs fsqrt fsin fcos f2xm1 fprem fprem1 fpatan fyl2x fscale fxam`, `fadd st(i)`. `fpu_net` follows call chains 40 deep and classifies the Borland math wrappers (`ASSUMED_MATH`). The helper operations take their rounding from the model's control word and, like the credited model, set no exception flag; only the condition codes come from the host.

Rows are lifted over the ledger SPAN when it decodes (the Ghidra body can end before a tail the function jumps into), else the body, else the part that decodes. A row whose callee or tail target is real code in the original (a fragment that is not a function start, a tail jump into another function, a recursive row) is compared on the seeds where translation and original agree and skips the others (`indirect` rows, as in FL-55b); that is weaker evidence, and the five x87 math wrappers 0x50df9d 0x50e05d 0x50e10d 0x50e28d 0x50f72d have no agreeing seed at all (status `no seed`).

## Left (upper, FL-57 share)

0x4d8dca (needs recursion in the harness), 0x50ed50 and 0x50fa90 (hand-port as memmove: dst `[esp+4]`, src `[esp+8]`, n `[esp+0xc]`, returns dst in eax, cdecl; ecx and edx are clobbered). FL-55b keeps its own defects and the no-seed rows.

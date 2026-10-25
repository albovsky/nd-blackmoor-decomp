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

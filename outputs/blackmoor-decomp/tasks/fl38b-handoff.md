# FL-38b handoff: "clone a record" rows below 0x480000 (18 rows)

Branch `fl38b-work` (worktree `/home/user/wt-fl38b`). Scope per the coordinator: rows at addresses below 0x480000 only; the other rows of the packet's fl38b list (including the two x87 rows
4f8562 and 4f8b22) were released to another slice.

## Ported (18, class `native_oracle_verified`, symbol `m<va>_clone_record`)

| sub-shape (S mod 4 tail) | rows (S) |
| --- | --- |
| 187 bytes (movsw+movsb) | 44d1d1 (0x2fb), 456fb6 (0x27b), 45807c (0x663), 464100 (0x43f), 465bde (0x55f), 46b79a (0x6e3), 47314b (0x4ff), 4782db (0x29b) |
| 186 bytes (movsw) | 475964 (0x7f2) |
| 184 bytes (no tail) | 44fbe3 (0x4e8), 467688 (0x408), 468f9f (0x5d8), 47e477 (0xa34) |
| 185 bytes (movsb) | 44e8a2 (0x269), 454e70 (0xd01), 459c10 (0x2b1) |
| 186 bytes, reordered loads (movsw) | 45ddd0 (0x1346), 47b3f0 (0x16c2) |

Oracle (`python3 tests/fl38b_original_oracle.py`): every row runs N/N instructions (58/58 for the 187 shape, 57/57 for 475964, 45ddd0, 47b3f0, 44e8a2, 454e70, 459c10; 56/56 for the 184 shape)
and takes both directions of both conditional jumps (`jne` after the allocation, `je` on the debug word): 4/4 directions, 46 scenarios per row, allowlist empty.

## What each row does

Stdcall, `ret 0xc`, three stack arguments, each the address of a dword cell: `out`, `in2`, `adv`. `p = 0x51dc43(S)` (cdecl, 1 argument) is stored at `*out`. When p is 0: `0x50ca3e(0x63888b, fmt,
dword [0x5bb57b], (int16)[0x5c39e3])`, `0x42639d` (thiscall on 0x583979, arguments message then 0x63888b), `0x4c97b4` (thiscall on 0x5cf659; posts WM_QUIT through PostQuitMessage and returns). Otherwise S bytes are copied
from `*in2` to `*out` (rep movsd, then movsw and/or movsb per S mod 4), `*adv += S`, then `*in2 += S` (each cell is re-read, so aliased cells advance twice), and when the word [0x63a4cd] is
non-zero `0x44a2b7(debug message)` is called. The format, message and debug strings and S are read per row (the generator `/tmp/claude-0/s/gen38b.py`, outside the repo, asserted the whole
instruction stream of every row against its sub-shape, including the jump targets, and that S agrees in the allocation, the repeat count + tail and both advances).

## Divergences and models

- The failure branch is modelled as a bounded partial model: the Unicorn stub of 0x4c97b4 stops the run (`halt`, `Original38b` in `tests/fl38b_fixtures.py`); the port makes the same
  calls up to and including it and returns 1 (0 otherwise). The differential compares that prefix of calls, `*out == 0`, and requires every other byte of every area unchanged
  (`partial`). 0x4c97b4 really posts WM_QUIT (PostQuitMessage, IAT 0x52a48c) and returns; the original then runs `rep movsd` with edi = *out = 0, an access violation. The stub stops the run at the call and the port returns 1 after the same call prefix; behaviour after the call is not modelled or claimed.
- The cells are original addresses resolved through `host->resolve`, the stored dwords too; nothing is bounds checked. Overlapping source and destination are exercised (the port copies
  unit by unit like rep movsd, forward). Direction flag assumed clear. The return value (eax at `ret`) of the original is garbage-by-design and is not compared.
- The port is one shared static body plus per-row wrappers that carry the constants; each wrapper has its `/* 0x<va> <symbol> */` comment directly above it.

## Tests and results (from outputs/blackmoor-decomp)

- `python3 -m unittest tests.test_fl38b_direct tests.test_fl38b_differential`: 38 tests OK (direct: 18 rows + exact-size buffers + every-case; differential: 18 rows).
- `python3 tests/fl38b_original_oracle.py`: 18 rows, all N/N, 4/4.
- `python3 tests/fl38b_mutation_check.py`: 48 mutation rounds (4 constants of every wrapper, 44 places of the shared body) x 18 rows = 864 mutants, 0 survivors (the byte/word tail mutants
  are skipped on rows that have no such tail: equivalent).
- direct test built with `-fsanitize=address,undefined` (clang): clean.

## Unverified / for the reviewer

- Acceptance `reviewer` field is a placeholder ("Sonnet 5.5 implementer, self-checked, independent review pending"): the root must replace it after review.
- The unreachable-or-never-returns part of the failure path (after 0x4c97b4) is not modelled beyond the stop, by design.
- The 18 symbols' effect on a real host (the callee ABI for 0x42639d with two arguments and callee cleanup) is as read from the call sites (no `add esp` after it); not exercised against a real callee.

Commit: see `git log -1` on `fl38b-work`.

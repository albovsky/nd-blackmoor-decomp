# FL-38 batch a handoff: this-field guards, release-surface tails, "NO SOUND" checks, constant getters (27 rows)

Branch `fl38a-work` (worktree /home/user/wt-fl38a), not pushed. Scope: the rows below 0x480000 of the packet's `fl38a` list; the rows from 0x480000 up were released to another slice.

## Ported rows (27)

Every row was disassembled on its own (`disx.py`, ledger body size), the whole masked instruction stream (numbers and jump targets masked, jump structure checked) was asserted equal to its group's, and every constant (offsets, string address and bytes, tail callee, returned value) was read from that row. The packet's byte sizes were approximate: the real ledger sizes differ (disp8 versus disp32 offsets: 52 to 61, 79 and 85 bytes; the 16-byte rows have int3 padding in their span, the oracle counts the 16 code bytes and the acceptance window is the span).

| va | symbol | kind | instructions executed/total | branch directions taken/total |
|---|---|---|---|---|
| 0x414c6d | m414c6d_get_constant | get | 8/8 | 0/0 |
| 0x447cc4 | m447cc4_get_constant | get | 8/8 | 0/0 |
| 0x4487de | m4487de_get_constant | get | 8/8 | 0/0 |
| 0x44be44 | m44be44_get_constant | get | 8/8 | 0/0 |
| 0x4542b5 | m4542b5_check_no_sound_call | nosound | 23/23 | 2/2 |
| 0x4542f2 | m4542f2_check_no_sound_call | nosound | 23/23 | 2/2 |
| 0x45441d | m45441d_check_no_sound_call | nosound | 23/23 | 2/2 |
| 0x454de6 | m454de6_release_surface_clear_call_tail | releaseclr | 28/28 | 4/4 |
| 0x454e39 | m454e39_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x456d2e | m456d2e_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x456d77 | m456d77_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x457fc2 | m457fc2_release_surface_clear_call_tail | releaseclr | 28/28 | 4/4 |
| 0x458045 | m458045_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x459b87 | m459b87_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x45dd4d | m45dd4d_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x464076 | m464076_release_surface_clear_call_tail | releaseclr | 28/28 | 4/4 |
| 0x4640c9 | m4640c9_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x465b9f | m465b9f_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x467651 | m467651_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x468f19 | m468f19_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x468f68 | m468f68_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x46b707 | m46b707_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x46e7a6 | m46e7a6_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x46e7ef | m46e7ef_guard_set_table_flag | guard | 18/18 | 4/4 |
| 0x470ddc | m470ddc_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x47823e | m47823e_release_surface_call_tail | release | 26/26 | 4/4 |
| 0x478287 | m478287_guard_set_table_flag | guard | 18/18 | 4/4 |

Kinds (see the header `src/original_methods_fl38a.h`): `guard` = `if (dword [this+A] && (int16)[this+B] != -1) dword [0x5d15a5 + 0x4a*(int16)[this+B]] = 1`, returns this (eax is this on every path; the port returns self and the tests check it); `release` = `if (dword [this+A]) 0x4c2dfb(ecx 0x5cf659, this+A); if ((int16)[this+B] != -1) 0x4d3992(word) cdecl; return tail(this)`; `releaseclr` = the same with `dword [this+A] = 0` after the first call; `nosound` = `repe cmpsb` 9 bytes at this+A against "NO SOUND\0" (read from the image per row), else 0x4fb2e3(ecx 0x5c3a67, word [this+B]), eax 0 when equal; `get` = returns a constant.

Table base of every `guard` row is 0x5d15a5 (asserted per row), stride 0x4a; the port takes the host memory of that address in `Fl38aWorld.table_5d15a5`; the fixtures use indices -3..0x1f and the world table covers -3..0x20.

## Dropped / pending

None dropped inside the scope: every row has all instructions executed and both directions of every conditional jump taken, no x87, no indirect jump. The rows at or above 0x480000 were released to another slice.

## Divergences, hooks, unverified

- Callees (0x4c2dfb, 0x4d3992, the tail callees, 0x4fb2e3) are recording host stubs; their own behaviour is not modelled or read. A callee that changes `self` is not exercised.
- The word argument of 0x4d3992 and 0x4fb2e3 is pushed by the original from a 16-bit register (`mov dx/ax, word`, `push edx/eax`), so the upper half of the pushed dword is whatever the register held; both sides compare the low 16 bits (WORD_ARGS in the fixtures). The port passes the zero-extended word.
- The table index has no bounds check in the original; fixtures keep it inside a table of 36 records.
- The `repe cmpsb` leaves esi/edi/ecx/ZF unobserved after the function; only the equal/different outcome and eax are compared. The C port uses `memcmp` of the 9 bytes (it may read all 9 bytes when the original stops at the first difference; both buffers are at least that long in every caller-visible layout since the word at [this+B] lies beyond them).
- Acceptances name the reviewer as "Sonnet implementer (FL-38a), no independent review yet": no separate slice review has been done.

## Tests and results (from outputs/blackmoor-decomp)

- `python3 tests/fl38a_original_oracle.py`: exit 0, every row N/N instructions and all branch directions (output above per row).
- `python3 -m unittest tests.test_fl38a_direct tests.test_fl38a_differential`: 56 tests OK (27 direct rows + the exact-size case + the all-cases check; 27 differential).
- `python3 tests/fl38a_mutation_check.py --differential`: 316 mutants (36 labels, each applied to every function of its kind), 0 survivors with the direct and differential tests; a mutant that makes the shim crash (unsigned index) counts as caught.
- Generator (not in the repo): /tmp/claude-0/s/gen38a*.py.

Commit: 7e7d8986 (all files); this handoff was updated in the following commit.

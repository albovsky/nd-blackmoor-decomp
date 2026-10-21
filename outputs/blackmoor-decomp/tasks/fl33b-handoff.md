# FL-33 batch fl33b handoff

Branch `worktree-agent-abad65baa85550390`, baseline commit `a7839503` (FL-33 packet). Owner: Claude Sonnet FL-33b implementer. A Sonnet `slice-reviewer` diff review found no P1 (the acceptance `reviewer` field is `Sonnet slice-reviewer, diff review, no P1 (FL-33)`); its fixture-gap findings are closed below (profiles `a_zero` and `wmis_hi`, high-word entries in 0x41db40, a 0x10000 value at 0x4f594d [rec+0x130]) and the 0x47d02d acceptance note was corrected.

GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only, never modified).

## Result

8 of 8 rows ported, none dropped. No jump direction is allowlisted: every instruction and both directions of every conditional jump were executed by the oracle for every function.

| va | span | native symbol | instructions | branch directions | oracle scenarios | digest | original window SHA-256 |
|---|---|---|---|---|---|---|---|
| 0x47d02d | 406 | `m47d02d_show_names` | 136/136 | 14/14 | 42 | 653380ea6223e5df8273f65eba30df4d60ccb195108254d70c45ec0fe882da97 | 168eb928e1f7250de7c75a86b3bea83032a4ce87b8a510c562c54e70f4c82d4e |
| 0x4c51a5 | 466 | `m4c51a5_copy_rows` | 153/153 | 12/12 | 111 | 0df6de6356aaab548e315bcd6efb34c50e35835a5c605592564a77da2b1d7575 | dc7b9a9ed6c6241cef6a4b866d5beb55aa030f2a9263d521b3c28f917702eb0b |
| 0x47df57 | 477 | `m47df57_update_view` | 124/124 | 12/12 | 66 | c9d4e923c6913bab422bf582db5ce1beb7d543372d71ab9cea9248deeccb2b3e | fbf64d7a5c459aaa0a2d0746e9295b0f38734f3fc82e4ff1fad9d38741caed5e |
| 0x4c2898 | 501 | `m4c2898_alloc_surface` | 163/163 | 8/8 | 66 | d1288c29b98102d3c664dbbf60b3c3a56e135822957ce4a0bbc4386b727f1a9e | a8cd1b424b3b67a98f9faafd1f7222f31ba5213bd840ff64beae0106ed998c43 |
| 0x4f594d | 515 | `m4f594d_read_checked` | 155/155 | 26/26 | 76 | ee7a5705a378a52f8ca39ec915f666fa1643e7d4cdc985d4cc1ce6c38a5b5d3a | 3264f3b418f03b14486222be8c6dca01dbc559b6506f57bfb8fb67bcc1e34b69 |
| 0x41e3c0 | 647 | `m41e3c0_build_text` | 203/203 | 6/6 | 52 | 781935a675d22d8f028ba2a04f5cacefa414841b335e3bc88202f02550af158f | 96668493d1f4eda163a3da88b563ae49ba32c1e86b0f33da83c40544fdd961da |
| 0x4f5b50 | 741 | `m4f5b50_read_block` | 200/200 | 32/32 | 88 | 9ea4b7b5aeef98ef3fee24ab5b6a003666baf4057530d9b828987850ce026992 | 157262bbb9905bacfac1cabd6964914a7db6690ee32abf7c386175170ece5e1c |
| 0x41db40 | 745 | `m41db40_free_record` | 189/189 | 36/36 | 130 | e3ddaee41028f82e62dd288a8fc8ae1a3f0f7ee76a9f89ada20329fa1393cf5c | 7cc75ace8699f28c8bc1b56ac952114d181ab80dd4992372b034bddab8a48c4a |

Differential tests compare the native symbol against the Unicorn run of the unmodified original on the same scenarios (return value, world/self state and ordered callee effects): 8/8 functions, 631 scenario comparisons (the oracle's scenario counts above; 579 before the review-round fixture additions: 0x4c51a5 63 -> 111, 0x4f594d 72 -> 76), 0 mismatches.

## Files (owned)

- `src/original_methods_fl33b.c` (SHA-256 8f433795b10587c4ce73fdb4a15ebdaae5cd1f9a43b5ed0f5dcec61befcb99a5), `src/original_methods_fl33b.h` (cceb12921f6a33ad2499c5c7e7bb4e727549125bddfac6aaa5d565427bdf5e98)
- `tests/fl33b_fixtures.py` (6fea8f7c60675f96d43149fb16096c119caf9f25b986f9820c70cd93529c1889), `tests/fl33b_original_oracle.py` (04e30ea85c67a1936039b4c1e7d65c117b4bee676780441cc4aba306c1259b19)
- `tests/fl33b_differential_shim.c` (55abb007bd87fe417cea3f5fbae72f7e5138a8d30846f948ccc9d430614fbf03), `tests/test_fl33b_differential.py` (769e685ccbed48912a62a7661d62a39f6f8052b0fed02450fb56fce3430b5976)
- `tests/fl33b_direct_test.c` (243017553c9ed01e163ba3da584539ad713721ba8e01b7f67c1569f401afc718), `tests/test_fl33b_direct.py` (2c1497555c53f4317e687865138a76d69f8786342f73036cc3db7e636a8507bb)
- `tests/fl33b_mutation_check.py` (46ac1dfaf553479308585386aa6f338d8cad18146dc30ff8b704eb6f6887da01), `tests/fl33b_hand_mutants.py` (see `git hash-object`; edited last)
- `tasks/fl33b-acceptances.json`, `tasks/fl33b-handoff.md`

Shared inputs used unchanged: `tests/original_differential.py` (409ef0377e0a42ccfee72db7fb25f803267a3eaa171aa177c350f178903b10f0), `tests/fl28b_fixtures.py` (5653b5c8e12a6ce0a764ee79904c6cfc014756960ad95190e812921d2e582929).

## Commands (from `outputs/blackmoor-decomp`)

- Oracle: `python3 tests/fl33b_original_oracle.py` (prints the rows above; exits non-zero on any unexecuted instruction or untaken jump direction)
- Unit and differential: `python3 -m unittest tests.test_fl33b_direct tests.test_fl33b_differential` -> 18 tests OK
- Direct C test with sanitizers: `gcc -std=c11 -g -O1 -fsanitize=address,undefined -fno-sanitize-recover=undefined -Isrc tests/fl33b_direct_test.c src/original_methods_fl33b.c -lm` -> 9 PASS (eight functions and the bounded malformed-input sweep). The plain build also passes under `-Wall -Wextra -Wpedantic -Werror`.
- Mutation: `python3 tests/fl33b_mutation_check.py` (mechanical) and `python3 tests/fl33b_hand_mutants.py` (49 hand mutants)
- Acceptance shape check: `function_ledger.symbol_area` / `test_area` for all 8 entries -> 8 checked, 0 problems (window `[va, va+size)`, VA in the leading comment `/* 0x<va> m<va>_<name> */`).

## Mutation results

Mechanical (`tests/fl33b_mutation_check.py`, final sources, re-run after the review-round fixture additions): 350 mutants, 292 caught by the direct test, 30 caught only by the Unicorn differential test, 28 survivors (35 before the review round). Survivors are reported, not hidden; classification (by reading the source line):

- Native-rejection guards that the original does not have (0x47d02d line 140 `> 0x9c40`; 0x41e3c0 lines 365, 370, 377, 385, 390, 396 boundary and guard-deleted; 0x4c51a5 line 193): 14 survivors. Deleting or shifting such a guard only matters for an overrun or fault, which the plain direct build does not detect; the ASan/UBSan run is the check for those. Boundary-exact inputs for them are an open test gap.
- Equivalent: 0x4c2898 lines 288, 290, 296, 297, 298, 299 (a literal moved by one on a zero store into a record that `rep_stos` cleared just before, 6 survivors); 0x41e3c0 line 352 (`text[0x34]` to `text[0x35]`, size of a local only); 0x47df57 lines 226, 227 (`<` to `<=` when width equals size: the stored difference is 0 either way); 0x4f5b50 line 409 (mode is compared with 1 and 2 only) and line 443 (only bits 0x10 and 0x20 of the flag are tested); 0x4c51a5 line 176 (`text[0x100]` is the size of a local); 0x41db40 line 475 (`rds16` to `rd16` in the loop bound: the guard on line 474 has already proved the count is positive, so both widths give the same value): 13 survivors.
- Test gap that remains: 0x4c51a5 line 192 (`rd32` to `rd16` in the byte count of the copy path): seeing it needs a copy path whose row length has a non-zero high word, i.e. a row of 64 KiB or more, which the 0x800 byte fixture surfaces do not hold; the widths follow the disassembly. 1 survivor.
- Closed in the review round (caught now, by the differential test where the direct test passes): 0x4c51a5 lines 173, 174, 177 (profiles `wmis_hi`: one coordinate of `fr` or `tr` offset by 0x10000 or 0x80000000, so the extents agree in the low 16 bits and differ in the 32-bit compare, and the report arguments carry the high words); 0x4f594d line 327 (`[rec+0x130] = 0x00010000` on the first pass of every b_* profile) and line 330 (`n < 0` to `n <= 0`: profile `a_zero`, the second 0x4f5b50 read returns exactly 0); 0x41db40 lines 474 and 477 (entry pointers `[e+2]` of 0x50000, 0x10000, 0x80000000, 0xdead0000 in state `hi`, and a table pointer equal to the region address, whose low word is zero, in one block of three). 7 survivors closed.

Hand mutants (`tests/fl33b_hand_mutants.py`): 49, every non-equivalent one caught by the direct test or the differential test; 7 are annotated equivalent (reasons are in the file). Survivors 0.

## Hooks (all at the call boundary of a callee, nothing replaces a decision of the function under test)

Every callee is replaced by a host stub that pops the arguments, logs (callee, this, args) in call order and returns a scripted eax. In the native code the same call goes through `Fl18Host.call`. Original addresses and constants (for example 0x54d158, 0x54388c) come through `Fl18Host.resolve`. Shapes inferred from the call sites:

- 0x47d02d: 0x516530 cdecl 2 args; 0x4fb77a thiscall 1 arg; 0x4fb2e3 thiscall 1 arg (argument is `(r & 0xffff0000) | word[rec+0x21]`); 0x423259 thiscall 1 arg (ecx 0x619a6b); 0x448d11 thiscall 4 args (ecx 0x619a05).
- 0x4c51a5: 0x50ca3e cdecl 11 args (debug report); 0x52139c stdcall 3 args; 0x4c97b4 thiscall 0 args.
- 0x47df57: 0x4c5377 thiscall 5 args, 0x4c62f0 thiscall 9 args, 0x4c6929 thiscall 7 args (all ecx 0x5cf659).
- 0x4c2898: 0x51dc43 cdecl 1 arg; 0x42639d thiscall 2 args (ecx 0x583979); 0x4c97b4 thiscall 0 args.
- 0x4f594d: 0x4f5e95 and 0x4f5e35 thiscall 2 args; 0x4f5b50 thiscall 3 args.
- 0x41e3c0: 0x51e745 thiscall 0 args; 0x51ea75 and 0x51eac4 thiscall 1 arg; 0x50ca3e cdecl 5 args (sprintf-like, writes into the local).
- 0x4f5b50: 0x50ca3e cdecl, declared 4 arguments (the stub logs one extra dword on the 3-argument calls with format 0x55e63c or 0x55e718; the comparison trims it); 0x44a2b7 cdecl 1; 0x52139c stdcall 3; 0x4fe2d0 cdecl 7; 0x4fdc70 cdecl 3; 0x50cf61 cdecl 4; 0x50ce2b cdecl 3.
- 0x41db40: 0x51dc6c cdecl 1 (free); 0x44a2b7 cdecl 1.

## Deliberate divergences (native rejections of original-unsafe behaviour)

These return the function's rejection status (status value 1 where the function has a status result) and are checked by the direct tests only, not by the oracle:

- 0x47d02d: a name text with length + 7 > 0x68 (the original overruns its 0x68 byte local).
- 0x4c51a5: a null surface descriptor on the copy path (the original faults at 0x4c529e or 0x4c52c9; the oracle runs those scenarios up to the fault) and a negative byte count with rows > 0.
- 0x41e3c0: a null buffer (the original faults at 0x41e400; the oracle runs it to the fault), any write that would leave the 0x3a98 byte buffer or the 0x34 byte local, a buffer without NUL, a callee text of 52 bytes without NUL, and a negative 16-bit offset.

For valid input, behaviour equals the original in every compared scenario.

## Unverified branches and open points

- Callee calling conventions and callee-pop counts come from the call sites only (0x4f5e95, 0x4f5e35, 0x4f5b50, 0x448d11, the 0x4fb77a and 0x4fb2e3 argument widths). A wrong pop count would be visible in the original-x86 runs of the callers but is not proven against the callees.
- Callees that change `self` or globals that the function reads afterwards are not exercised: the stubs only return scripted eax and, where noted, write scripted bytes through pointer arguments.
- The 0x9c40 boundary of 0x47d02d cannot be driven in the oracle (the original overruns the stack); it is covered by the direct test as a rejection.
- The native rejections above are not executed by the oracle beyond the fault points named.
- Equivalent mutants (annotated in `tests/fl33b_hand_mutants.py`): the 0x47d02d NUL copy that the suffix overwrites, the 0x4c2898 name NUL copy after the record clear, the 0x41e3c0 16-bit loop counter and the redundant upper bound of `text_end`, the 0x4f5b50 `rds16` versus `rd16` compare with 8 and the swapped `pos += go` / 0x4fdc70 call, and the 0x41db40 `(uint16_t)i` index.
- A Sonnet `slice-reviewer` diff review found no P1; the acceptances carry that reviewer string. Root decides on `port_acceptances`.

## Integration proposal

Add `tasks/fl33b-acceptances.json` to the reviewed acceptance set after review. No shared file was edited. `src/original_methods_fl33b.c` needs adding to whatever compiles `original_methods_fl*.c` (the tests build it directly with gcc).

Integration notes (review round):

- 0x47d02d: the native rejection starts at a text length of 98 (`n + 7 > 0x68`); a text of 97 characters is accepted. For n = 98..101 the original does not fault: it only overwrites the dead local `t` that sits behind its 0x68 byte buffer and still calls 0x448d11 with the buffer, while the native port returns the rejection status 1 and makes no call. For longer texts the original overruns further. The host must treat status 1 as "no name shown" and must not rely on the original's behaviour in that range.
- 0x4234dd belongs to batch a (`tasks/fl33a-handoff.md`): its callers must keep `n` ([self+4]) below 0x80, because the port, like the original, stores out of bounds at `self + n*12 + 0xc/0x10` for n >= 0x80 after the report chain.

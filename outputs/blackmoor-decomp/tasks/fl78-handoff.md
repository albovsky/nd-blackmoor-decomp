# FL-78 handoff: prover rows (0x49d945, 0x4f7207, 0x48f181, ...) (2026-11-02, worktree wt-prover, branch fl78-prover)

Phase 2 (this file replaces the phase 1 text). Both rows asked for in phase 2 are proved; 0x48f181 is still blocked.

## Row status

| Row | Status | Result |
| --- | --- | --- |
| 0x49d945 | proved (see "check result" at the end) | All three error paths prove. 0x49da7c via the whole-function / backward invariants plus a forward window; 0x49db1c and 0x49dbc5 via forward-window invariants at the copy-loop headers (`tests/fl78_forward_invariants.json`). Direct `prove_row`: all 39 targets proved, 463 s. |
| 0x4f7207 | proved (`check --prove`: `0x4f7207 proved [568, 569] [57, 58]`) | No frame address escapes any more: the two inline strcpy copies, the sprintf call and the member call 0x4fa127 are each covered by a benign-lea rule (below). |
| 0x48f181 | blocked | Unchanged from phase 1. Needs a pointer-into-the-frame model: the strcmp loop at 0x48f370 reads through the pointer in the frame slot `[ebp-0x2c]` (set by `lea eax,[ebp-4]` at 0x48f357); a value loaded from a frame cell is classified as a non-frame address (`has_frame_term` stops at SELECT), so the read never sees `[ebp-3] = 0` (0x48f30e). Same family as 0x456516, 0x471722, 0x47c0f0. |
| 0x4e812f, 0x4ba56a | not attempted | Time. |

## Decisions taken as the recommended defaults under the 2-hour rule

All three are in `RULE_TEXT2` (`scripts/fl66_tested.py`). Common condition: the `lea R,[ebp+d]` is in eax/ecx/edx, the straight line from it has no jump, extra call or branch target, and R is dead afterwards. Anything else (a frame address in a destination position of a listed call, passed to an unlisted call, kept, stored elsewhere) still switches the frame assumption off for the function or window.

1. **Source argument of an allow-listed library call** (`LIBRARY_WRITERS`, `'source'`): `push R` ... `call 0x50ca3e` (the CRT sprintf, identified from its bytes) in a position that is not a destination position; the callee's pops plus the following `add esp,K` cover the pushed arguments. Only sprintf is listed.
2. **Destination of an inline `rep movs/stos` copy** (`'copy'`): the first thing touching R is `mov edi,R`, then `rep movs/stos`, then R and edi are dead. Model: the copy may write any byte of the frame and of `mem` (both arrays get fresh contents, edi stays frame-derived). This is a superset of "writes only inside the buffer, length bounded by ecx", so it is sound under that description and also if the copy overran. It is weaker than a bounded write; no current row needs the bound.
3. **Member call 0x4fa127 (an out-parameter writer), verified from its bytes** (`'out'`, `out_param_extent`): the callee is accepted only if it starts `push ebp; mov ebp,esp`, has no frame escape, no esp-based or indexed-ebp memory operand, no write at or above ebp, reads the slot only by `mov r32,[ebp+argoff]` into eax/ecx/edx, and on every path uses that register only as the base of `fst/fstp [r+d]`, d >= 0. It returns the largest d+size. For 0x4fa127 at offset 0xc this is 12 bytes, so the call is modelled as writing exactly 12 fresh bytes at the pushed pointer (`Machine.out_writes`), and the rest of the frame survives the call (apart from the argument slots). eax/ecx/edx must be dead after the call, and ecx must not be read by the callee (checked with `ecx_free_call`, which follows the callee's calls). A callee that fails any check leaves the escape in place.

Prover mechanics added in phase 2:
- **Forward-window invariants** (`scripts/fl71_window.py`, data `tests/fl78_forward_invariants.json`, generator `tasks/fl78/make_fwd_invariants.py`): per target, keyed `"0xJCC:taken|fall"` or `"0xBLOCK:ins"`. A header keeps its atoms only if initiation (every entry edge) and consecution (every back edge) are proved, under the esp-to-ebp tie of the window start (`tie`). A header named in an invariant must be generalised, else Unsupported.
- **`arr` Boolean**: at a generalised header the arrival condition is replaced by a fresh Bool `arr` with `Implies(real_arrival, arr)` as a fact, so consecution is checked from the header only. Without it the consecution query for the outer copy loop (0x49dc2f) was `unknown` at 600 s; with it, seconds.
- **`discard_facts`**: a refused window removes the facts it added to the shared `M.facts` (used by `prove_target` and `prove_faults`).

## Tests

- `tests/test_fl67_infeasible.py`: `Fl78` (8, source rule), `Fl78Copy` (4, inline copy), `Fl78Out` (6, out-parameter callee, incl. one that reads GAME.EXE: 0x4fa127 extent 12, 0x4f7207 `esc_addrs == []`, `out_writes == {0x4f757d: [(4,12)]}`), `Fl78Forward` (8). Each rule has a test that fails with the rule patched out and tests that an unlisted case (destination position, other callee, register read afterwards, extra branch, callee reads ecx, callee reads or writes elsewhere) still switches the assumption off. The existing test `ecx_then_call` now uses a callee that reads `[ecx]` (a bare `ret` callee is correctly accepted as not reading ecx); `ecx_then_call_free` is the positive counterpart.
- Narrow runs are listed in the "check result" section below.

## Next

1. Pointer-into-the-frame model (0x48f181, 0x456516, 0x471722, 0x47c0f0).
2. 0x4e812f, 0x4ba56a: untouched.

## Review fixes (independent review of the phase 2 diff)

- **Blocker 1, circular initiation** (`fl71_window.py` run_window / run_forward, `fl67_infeasible.py` execute): the assumed invariant facts are no longer in `M.facts` but in `M.inv_facts` as `(key, fact)`. `Analysis.check(f, only=keys)` conjoins just those. The initiation of a header is checked with the facts of the headers the run passes BEFORE it (`reach_back` over the non-back edges), never its own; consecution with the facts of the headers on the way round the loop (its own included, as the induction hypothesis). Windows then add the facts to the final query; they are removed after the query (`discard_facts` takes `(len(facts), fact_keys, len(inv_facts))`), also for accepted windows (minor d).
- **Blocker 2** (`_library_arg_lea`, kind `out`): the callee must not read the register that still holds the frame address (`dead_from` over the callee's bytes from its entry for R). Also checks `push ebp/esp` and `mov r, ebp/esp` between the pushes (minor c).
- **Major 3**: `ecx_free_call` is replaced by `call_kills(image, call, R)`: an import (a slot of `image/imports.json` plus the row's imports, not any absolute call) or a direct callee whose bytes overwrite R on every path before reading it (`dead_from(..., must_write=True)`). Any other call neither ends the life of eax/ecx/edx nor is followed; `out_param_extent` uses it too (a call that does not kill the pointer register leaves a possible later store, so the callee is refused).
- **Minor a**: a `cmov` reads its destination (`_rw`). **Minor b**: the sprintf rule needs the format (argument 1) to be a `push imm` of an address inside the image whose string has no `%n` within 256 bytes; the frame address may not be the format. Stated assumption: the literal is not overwritten at run time (old MSVC keeps literals in the writable .data, so this cannot be shown from the bytes). **Minor e**: the non-header test asserts the specific refusal.
- Tests: `Fl78Circular` (3, whole function / backward window / each with the leaky check proving the false atom), `Fl78Forward` (circular memory-free loop; leaky check proves it), `Fl78` (format, push ebp, call keeps edx / kills edx, import vs non-import call, cmov with the old `_rw`), `Fl78Copy` / `Fl78Out` (callee stores through edx / ecx).

## Results after the fixes

- `python3 -m unittest tests.test_fl67_infeasible tests.test_fl71_window`: 96 tests, all OK (one oracle test errored on an apostrophe in a RULE_TEXT2 edit; fixed, `Replay` rerun OK).
- reprove_all (`FL78_MANIFEST=<main manifest> python3 tasks/fl78/reprove_all.py ...`, log `tasks/fl78/reprove_all2.log`): 106 of 106 rows proved, including 0x448d11, 0x413187, 0x4e5fdb.
- `check 0x4f7207 --redo --prove`: `0x4f7207 proved [568, 569] [57, 58]` (15 s). `check 0x49d945 --redo --prove`: `0x49d945 proved [563, 599] [73, 76]` (128 s).

## Second review: the sprintf format check (`constant_format`)

- `format_text_ok`: the string is non-empty printable ASCII and every `%` starts a specification of `FORMAT_SPEC` (flags, width and precision as digits only, length h l L I64, conversions d i o x X u c s f e E g G and the percent sign). So `%n` in any form (`%hn`, `%ln`, `%5n`, `%1$n`), `*`, `$`, `%p`, `%S`, `%a`, a lone `%`, an empty string (a zero-initialised buffer) and non-text bytes are refused.
- `format_references_ok`: every 4-byte occurrence of an address inside the string anywhere in the image (code and data, any alignment) must be `push <start of the string>` directly in front of one more push and a `call` of a LIBRARY_WRITERS function named sprintf (the string is argument 1). An absolute write, a `mov reg, imm`, a pointer into the middle, a table entry, a use as destination or as an argument of another call all refuse. For the 0x4f7207 / 0x49d945 format (0x55ea74) the only reference is the push at 0x4f7488.
- Residual assumption (stated in RULE_TEXT2): nothing writes the bytes of the literal through an address computed from another base.
- No row of the 106-row manifest uses the sprintf source rule (only `copy` kinds appear there), so none can drop; 0x4f7207 and 0x49d945 both call sprintf and still prove.
- Tests in `Fl78`: allowed conversions accepted, 16 refused formats, 4 empty/unprintable formats, 7 image-reference cases plus the accepted second sprintf use. Unit run: `tests.test_fl67_infeasible tests.test_fl71_window` 100 tests OK. `check 0x4f7207 --redo --prove`: proved (15 s). `check 0x49d945 --redo --prove`: see `tasks/fl78/run_49d945_r2.log`.
